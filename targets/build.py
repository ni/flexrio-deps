#!/usr/bin/env python
# build.py

"""This build.py can be used to synthesize the clip fixed logic or compile it for simulation:
For synthesis run:  python build.py (--noinc)
For simulation run: python build.py --flow=compile (--noinc)
"""

import os
import shutil
import tempfile
from hwtools.api import (
    cmd,
    EdaBuildClass,
    githubbuildtools,
    pathapi,
    pp,
    vivado,
    WorkingFolder,
)
from hwcommon.cmd.gitcmd import git
from mako.template import Template
from enum import Enum

import commonbuildfuncs

from targetconfig import targetconfigs
from targetutils import add_target_build_arg, get_applicable_targetconfigs

# Global list to track temporary files
TEMP_FILES = []

# Construct the uservisible tag to prevent this file from being kept as a user visible file
USERVISIBLE_TAG = "githubvisible" + "=" + "true"

# Dependency path mapping settings used by both path-list generation and dependency gathering.
DEPS_MAX_REL_PATH_LEN = 150
DEPS_MAX_REL_PATH_DEPTH = 12
DEPS_SHORTEN_TAIL_DIR_COUNT = 3
DEPS_SHORTEN_HASH_LEN = 10

# Regular expressions for files to remove from the hdl_shared_deps vsmake file list.
# These files are already provided by the per-target builds and must not be duplicated
# when processing the shared dependencies file list.
HDL_SHARED_DEPS_PRE_FILTER_REGEX_LIST = [
    r"(.*)HdlSharedWrapper\.vhd",
    r"(.*)NiFifo(Reader|Writer)Core\.vhd",
    r"/lvgen/",
]


def _resolve_commit_message():
    """Resolve commit message from CI environment with fallback default.

    Priority:
      1) BUILD_SOURCEVERSIONMESSAGE (Azure Pipelines)
      2) Build.SourceVersionMessage (if provided by environment as-is)
      3) fallback default string
    """
    commit_message = os.environ.get("BUILD_SOURCEVERSIONMESSAGE") or os.environ.get("Build.SourceVersionMessage")

    if commit_message is None or str(commit_message).strip() == "":
        return "Update release branch"

    # Ensure message is a single line to avoid odd commit formatting from multiline source messages.
    return " ".join(str(commit_message).splitlines()).strip()

def _render_mako_template(template_path, output_dir):
    """Render a Mako template and write the output to objects directory
    
    Args:
        template_path: Path to template file
        
    Returns:
        bool: True if successful, False otherwise
    """
    template_file = os.path.basename(template_path)
    output_file = template_file.replace('.mako', '')
    output_path = os.path.join(output_dir, output_file) 
    
    if os.path.exists(template_path):
        os.makedirs(output_dir, exist_ok=True)
        with open(template_path, 'r') as f:
            template = Template(f.read())
        output_text = template.render(
            include_target_io=True,
            include_custom_io=False,
            custom_target=False,
            lv_target_name="",
            lv_target_guid="",
            custom_signals=[],
            # All targets that support GitHub release use the same 0x00000 default min offset for LV FPGA registers
            # This could be sourced from targetconfig.py if it needs to be target-specific in the future
            min_lv_reg_offset="0x00000",
            net_path_to_the_window = "TheLvWindow",
            current_instance_path_for_window = "",
            include_current_instance_path_for_window = False
        )
        with open(output_path, 'w') as f:
            f.write(output_text)

class VSMakeMode(Enum):
    nosynth = "nosynth"
    synth = "synth"
    lvfpgasynth = "lvfpgasynth"

def _run_cfmake(args, githubonly=False):
    """Run cfmake on the targets
    """

    for target in get_applicable_targetconfigs(args):
        tc = targetconfigs[target]
        if tc.get("supportsgithubrelease", True) or (not githubonly):
            print(f"Running cfmake on {target}")
            tc = targetconfigs[target]

            target_xml = pathapi.get_abs_path(
                base="root", path=f"{target}/xdc/cfmakesettings.xml"
            )

            target_xdc = pathapi.get_abs_path(
                base="objects",
                path=f"{target}/cfmake/{tc['constraintsfile']}",
                checkexist=False,
            )

            commonbuildfuncs.cfmake(target_xml, target_xdc, tc["toplevelname"])           

            """Run cfmake on placement constraints"""
            target_xml = pathapi.get_abs_path(
                base="root", path=f"{target}/xdc/cfmakesettings_place.xml"
            )
            target_xdc = pathapi.get_abs_path(
                base="objects",
                path=f"{target}/cfmake/constraints_place.xdc",
                checkexist=False,
            )

            commonbuildfuncs.cfmake(
                target_xml, target_xdc, "constraints_place", delete_and_recreate=False
            )

def _run_vsmake(mode: VSMakeMode):
    # Delete old modelsim data just in case
    shutil.rmtree("./modelsim", ignore_errors=True)

    # delete old vsmake outputs
    cmd.runlive("vsmake", "--clean", raise_on_err=True)

    # Create a new modelsim project, if needed, by running vsmake
    # on a low-level package that shouldn't have any dependencies
    cmd.runlive("vsmake", "PkgNiUtilities", raise_on_err=True)

    # Run VSMake with arguements
    if mode == VSMakeMode.nosynth:
        cmd.runlive("vsmake", raise_on_err=True)
    elif mode == VSMakeMode.synth:
        cmd.runlive("vsmake", "--synth", raise_on_err=True)        
    elif mode == VSMakeMode.lvfpgasynth:
        cmd.runlive("vsmake", "--synth", "--customarg=lvfpga", raise_on_err=True)
    else:
        raise ValueError(f"Unsupported vsmake mode: {mode}")

def _copy_object_files_for_github(args):
    # Copy files from the objects directory into the GitHub source code directory
    # It is not ideal to put objects into the source code, but we have a couple exceptions
    # like the combined XDC files and the list of source HDL produced by VSMake
    global TEMP_FILES
    
    copied_destinations = []
    
    for target in get_applicable_targetconfigs(args):
        tc = targetconfigs[target]
        if tc.get("supportsgithubrelease", True):
            # Copy hdl files list from the objects directory into the source code directory
            hdl_file_list_objects = pathapi.get_abs_path(
                base="objects", path=f"{target}/githubfilelists"
            )
            hdl_file_list_github = pathapi.get_abs_path(
                base="root", path=f"{target}", checkexist=False
            )
            # Iterate through files in the source directory
            for file_name in os.listdir(hdl_file_list_objects):
                objects_file = os.path.join(hdl_file_list_objects, file_name)
                github_file = os.path.join(hdl_file_list_github, file_name)
                shutil.copyfile(objects_file, github_file)
                TEMP_FILES.append(github_file)
                copied_destinations.append(github_file)

            # Copy XDC files from the objects directory into the source code directory            
            xdc_cfmake_objects = pathapi.get_abs_path(
                base="objects", path=f"{target}/cfmake"
            )
            xdc_github = pathapi.get_abs_path(
                base="root", path=f"{target}/xdc", checkexist=False
            )
            os.makedirs(xdc_github, exist_ok=True)
            # ##### DOUBLE SOURCED CODE ALERT #####
            # This text is double sourced to what is in cfmake - be careful to keep it in sync
            header = "Automatically generated XDC file. Do not modify manually!"
            # Copy all files from xdc_objects to xdc_github
            for file_name in os.listdir(xdc_cfmake_objects):
                objects_file = os.path.join(xdc_cfmake_objects, file_name)
                github_file = os.path.join(xdc_github, file_name)
                # Read source file content
                with open(objects_file, 'r') as f:
                    content = f.read()           
                # Remove all instances of the header text
                original_content = content
                content = content.replace(header, "")
                # If no header is found, then it has changed in cfmake and we need to raise an error
                if content == original_content:
                    raise ValueError(f"XDC header text not found in file: {objects_file}")            
                # Write modified content to destination
                with open(github_file, 'w') as f:
                    f.write(content)
                TEMP_FILES.append(github_file)
                copied_destinations.append(github_file)
    
    return copied_destinations
    


def _delete_temp_files():
    """Deletes all temporary files that were created during the build process"""
    global TEMP_FILES
    
    pp.printmsg(f"Deleting {len(TEMP_FILES)} temporary files...")
    
    for file_path in TEMP_FILES:
        try:
            if os.path.exists(file_path):
                os.remove(file_path)
                pp.printmsg(f"Deleted: {file_path}")
            else:
                pp.printmsg(f"File not found: {file_path}")
        except Exception as e:
            pp.printwrn(f"Failed to delete {file_path}: {str(e)}")
    
    # Clear the list after deletion
    TEMP_FILES.clear()
    pp.printmsg("Temporary file cleanup complete.")


def _validate_vivado_project_file_lists(source_file_list, deps_file_list):
    """Validates all paths listed in Vivado source/dependency file list files."""
    list_files = [source_file_list, deps_file_list]
    missing_list_files = []
    missing_project_files = []
    checked_file_count = 0

    for list_file in list_files:
        list_file_abs = os.path.abspath(os.path.normpath(list_file))
        if not os.path.exists(list_file_abs):
            missing_list_files.append(list_file_abs)
            continue

        with open(list_file_abs, "r", errors="ignore") as f:
            for line in f:
                entry = line.strip().strip('"').strip("'")
                if not entry or entry.startswith("#"):
                    continue

                checked_file_count += 1
                project_file_abs = os.path.abspath(os.path.normpath(entry))
                if not os.path.exists(project_file_abs):
                    missing_project_files.append(
                        (list_file_abs, entry, project_file_abs)
                    )

    if missing_list_files or missing_project_files:
        error_lines = ["Vivado project file list validation failed."]

        if missing_list_files:
            error_lines.append("Missing Vivado project file list(s):")
            for path in missing_list_files:
                error_lines.append(f"  - {path}")

        if missing_project_files:
            error_lines.append("Missing file(s) listed in Vivado project file lists:")
            for list_file, entry, resolved_path in missing_project_files:
                error_lines.append(f"  - listed file: {entry}")
                error_lines.append(f"    list file:   {list_file}")
                error_lines.append(f"    resolved:    {resolved_path}")

        raise FileNotFoundError("\n".join(error_lines))

    pp.printmsg(
        f"Validated {checked_file_count} file path(s) from Vivado project file lists."
    )

def _process_vsmake_file_lists_core(target, toplevelname, pre_filter_regex_list=None):
    # File generated by VSMake that contains the list of files to include in the Vivado project
    vsmake_file_list_path = pathapi.get_abs_path(
        base="objects", path=f"{target}/vsmake/absfiles_{toplevelname}.json", checkexist=False
    )
    # Python file with regular expressions for files to exclude from the LV FPGA target plugin.
    # This is needed in build.py to create the lvtargetexcludefiles.txt that goes onto GitHub.
    # This is independent of the process that removes these files from the LV Target Plugin that
    # comes out of this build and ships with FlexRIO driver.
    lv_target_exclude_patterns_path = pathapi.get_abs_path(
        base="root", path=f"lvfpgaexcludefiles.py", checkexist=False
    )                                        
    # Locations to store the generated file lists in the objects directory during build
    encrypted_file_list_path = pathapi.get_abs_path(
        base="objects", path=f"{target}/githubfilelists/vivadoprojectdeps.txt", checkexist=False
    )
    source_file_list_path = pathapi.get_abs_path(
        base="objects", path=f"{target}/githubfilelists/vivadoprojectsources.txt", checkexist=False
    )              
    lv_target_exclude_file_list_path = pathapi.get_abs_path(
        base="objects", path=f"{target}/githubfilelists/lvtargetexcludefiles.txt", checkexist=False
    )     
    deps_manifest_path = pathapi.get_abs_path(
        base="objects", path=f"{target}/githubfilelists/depspathmanifest.json", checkexist=False,
    )

    # Create the lists of files that will be included in the Vivado project
    githubbuildtools.process_vsmake_file_list(
        vsmake_file_list_path=vsmake_file_list_path,
        pre_filter_regex_list=pre_filter_regex_list,
        deps_file_list_path=encrypted_file_list_path,
        source_file_list_path=source_file_list_path,
        lv_target_exclude_patterns_path=lv_target_exclude_patterns_path,
        lv_target_exclude_file_list_path=lv_target_exclude_file_list_path,
        new_folder_path="../../deps/flexrio-deps/encrypted/",
        uservisible_tag=USERVISIBLE_TAG,
        deps_manifest_path=deps_manifest_path,
        max_rel_path_len=DEPS_MAX_REL_PATH_LEN,
        max_rel_path_depth=DEPS_MAX_REL_PATH_DEPTH,
        shorten_tail_dir_count=DEPS_SHORTEN_TAIL_DIR_COUNT,
        shorten_hash_len=DEPS_SHORTEN_HASH_LEN,
    )

def _process_vsmake_file_lists(args):
    """Process the file lists generated by VSMake to create file lists for use in the GitHub user project

       This is a pre-req for gather_encrypted_files because it turns the VSMake file lists into the GitHub
       file lists that are used to create the Vivado project. 
    """
 
    for target in get_applicable_targetconfigs(args):
        with WorkingFolder(folder=f"{target}", base="root"):
            # Check if the target supports GitHub release before processing the vsmake file lists
            tc = targetconfigs[target]
            toplevelname = tc["toplevelname"]
            if tc.get("supportsgithubrelease", True):
                _process_vsmake_file_lists_core(target, toplevelname)
        with WorkingFolder(folder="github/hdl_shared_deps", base="root"):
            # We also need to process the file list for the shared deps since those files also go onto GitHub and into the Vivado project
            _process_vsmake_file_lists_core("hdl_shared_deps", "HdlSharedWrapper", pre_filter_regex_list=HDL_SHARED_DEPS_PRE_FILTER_REGEX_LIST)


def _gather_dependency_files(args, deps_repo_build):
    # Aggregate all dependency path manifest files.
    all_deps_manifest_paths = []
    for target in get_applicable_targetconfigs(args):
        with WorkingFolder(folder=f"{target}", base="root"):
            # Check if the target supports GitHub release before processing the vsmake file lists
            tc = targetconfigs[target]
            if tc.get("supportsgithubrelease", True):
                deps_manifest_path = pathapi.get_abs_path(
                    base="objects", path=f"{target}/githubfilelists/depspathmanifest.json", checkexist=False,
                )
                all_deps_manifest_paths.append(deps_manifest_path)
    # Add HDL Shared Dependencies manifest since those also go onto GitHub and into the Vivado project
    deps_manifest_path = pathapi.get_abs_path(
        base="objects", path=f"hdl_shared_deps/githubfilelists/depspathmanifest.json", checkexist=False,
    )
    all_deps_manifest_paths.append(deps_manifest_path)

    # Copy all dependency files into flexrio-deps OR encrypted folder
    if deps_repo_build:
        # If this is to release the deps to GitHub, we just put it all in a folder that goes onto the GitHub
        # This stage of the build puts it in a "source" folder to make it clear that these files are not encrypted yet
        # There is another build pipeline stage that makes the encrypted folder
        encrypted_folder = pathapi.get_abs_path("source", base="repo", checkexist=False)
    else:
        # When this is gathering dependencies to test building the Vivado project, we must mimick the folder structure that
        # the deps will be installed into which includes the "deps" and "flexrio-deps" folders
        encrypted_folder = pathapi.get_abs_path("deps/flexrio-deps/encrypted", base="repo", checkexist=False)
    # Preserve folder hierarchy in the deps folder so same-named files from different sources remain distinct.
    githubbuildtools.gather_release_deps_files(
        encrypted_folder,
        deps_manifest_paths=all_deps_manifest_paths,
    )


def _copy_object_files_for_github_deps():
    """Copy the hdl_shared_deps vivado project deps file list to the source code directory for the deps branch."""
    source_file = pathapi.get_abs_path(
        base="objects", path="hdl_shared_deps/githubfilelists/vivadoprojectdeps.txt"
    )
    dest_dir = pathapi.get_abs_path(
        base="root", path="../hdl_shared_deps_list", checkexist=False
    )
    os.makedirs(dest_dir, exist_ok=True)
    dest_file = os.path.join(dest_dir, "hdlsharedvivadoprojectdeps.txt")
    shutil.copyfile(source_file, dest_file)
    pp.printmsg(f"Copied: {source_file} -> {dest_file}")


def _encrypt_files(source_folder, encrypted_folder, delete_source):
    """Encrypt files using encrypt-vhdl-vivado tool.
    
    Args:
        source_folder: Path to the folder containing files to encrypt
        encrypted_folder: Path to the folder where encrypted files will be stored
        delete_source: Whether to delete the source folder after encryption
    """
    # Remove any prior output before encrypting
    encrypted_folder_abs = os.path.abspath(os.path.normpath(encrypted_folder))
    if os.path.exists(encrypted_folder_abs):
        shutil.rmtree(encrypted_folder_abs)
        pp.printmsg(f"Deleted old encrypted folder: {encrypted_folder}")

    # Create output folder
    os.makedirs(encrypted_folder_abs, exist_ok=True)
    
    # Run the encryption command
    cmd.runlive("encrypt-vhdl-vivado", source_folder, encrypted_folder, raise_on_err=True)
    
    if delete_source:
        # Delete the source folder after encryption
        source_folder_abs = os.path.abspath(os.path.normpath(source_folder))
        if os.path.exists(source_folder_abs):
            shutil.rmtree(source_folder_abs)
            pp.printmsg(f"Deleted source folder: {source_folder}")


def _validate_encrypted_files(encrypted_folder):
    """Validate that all VHDL files in the encrypted folder are properly encrypted with IEEE-1735v2.
    
    Args:
        encrypted_folder: Path to the folder containing encrypted files to validate
        
    Raises:
        RuntimeError: If any files are not properly encrypted
    """
    if not os.path.exists(encrypted_folder):
        raise RuntimeError(f"Encrypted folder not found: {encrypted_folder}")
    
    # Markers for IEEE-1735v2 encryption
    BEGIN_MARKER = "`protect begin_protected"
    END_MARKER = "`protect end_protected"
    
    unencrypted_files = []
    
    # Check all .vhd and .vhdl files
    for root, dirs, files in os.walk(encrypted_folder):
        for file in files:
            if file.endswith(('.vhd')):
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                        content = f.read()
                        
                    # Check if file contains encryption markers
                    if BEGIN_MARKER not in content or END_MARKER not in content:
                        unencrypted_files.append(file_path)
                        pp.printmsg(f"WARNING: File not encrypted: {file_path}")
                    else:
                        pp.printmsg(f"Verified encrypted: {file}")
                        
                except Exception as e:
                    pp.printmsg(f"ERROR: Could not read file {file_path}: {e}")
                    unencrypted_files.append(file_path)
    
    if unencrypted_files:
        error_msg = f"Found {len(unencrypted_files)} unencrypted VHDL file(s):\n"
        for file in unencrypted_files:
            error_msg += f"  - {file}\n"
        error_msg += "\nAll VHDL files must be encrypted with IEEE-1735v2 before pushing to GitHub."
        raise RuntimeError(error_msg)
    
    pp.printmsg(f"All VHDL files in {encrypted_folder} are properly encrypted.")


@EdaBuildClass.flow(["compile", "build"])
def update_revision(args):
    """Updates the revision to generate the package file"""
    if args.noinc:
        cmd.runlive("updaterevision", "--noinc", raise_on_err=True)
    else:
        cmd.runlive("updaterevision", raise_on_err=True)


@EdaBuildClass.flow(["buildgithubrelease", "testgithubrelease"])
def cfmake_github(args):
    """Run cfmake only on GitHub targets to save time
    """
    _run_cfmake(args, githubonly=True) 


@EdaBuildClass.flow(["build"])
def cfmake(args):
    """Run cfmake on all targets
    """
    _run_cfmake(args, githubonly=False) 


@EdaBuildClass.flow(["build", "buildgithubrelease", "testgithubrelease", "compile", "processwindow"])
def process_the_window(args):
    """Process TheWindow mako template - needed for both VSMake and GitHub release

       This is a pre-req for vsmake_compile and vsmake_build because TheWindow.vhd needs mako processing
    """
    for target in get_applicable_targetconfigs(args):
        with WorkingFolder(folder=f"{target}", base="root"):
            # Delete old generated files to prevent stale files from being included in VSMake
            # This also clears out the objects/lvFpgaTarget folder used for processed XML files that
            # are included in the target plugin export
            shutil.rmtree("objects", ignore_errors=True)            
            # Process all mako templates under rtl-lvfpga (recursively), outputting flat to objects/GeneratedHDL
            for dirpath, _, filenames in os.walk("rtl-lvfpga"):
                for filename in filenames:
                    if filename.endswith(".vhd.mako"):
                        _render_mako_template(os.path.join(dirpath, filename), "objects/GeneratedHDL")


@EdaBuildClass.flow(["build"])
def process_resource_xml(args):
    """Process Resource XML mako template
        
       This is a pre-req for build because the processed resource XML file is published in the nuget
       that proves the XML files to the LV FPGA target support installer.  This is not needed for
       buildgithubrelease because in the GitHub workflow the XML files are processed as a user step
       when they export a custom LV FPGA target.
    """
    for target in get_applicable_targetconfigs(args):
        with WorkingFolder(folder=f"{target}", base="root"):
            # Look for XML Mako templates in the lvFpgaTarget directory
            template_dir = "lvFpgaTarget"
            if os.path.exists(template_dir):
                # Find all .xml.mako files in the directory
                # The XML processing needs to be  generic because targets have different file names
                template_files = [f for f in os.listdir(template_dir) 
                                 if f.endswith('.xml.mako')]               
                if not template_files:
                    continue                    
                # Process each template file
                for template_file in template_files:
                    template_path = os.path.join(template_dir, template_file)
                    _render_mako_template(template_path, "objects/lvFpgaTarget")


@EdaBuildClass.flow(["compile"])
def vsmake_compile(args):
    """Compile the target for nisim"""
    for target in get_applicable_targetconfigs(args):
        with WorkingFolder(folder=f"{target}", base="root"):
            _run_vsmake(mode=VSMakeMode.nosynth)


@EdaBuildClass.flow(["buildgithubrelease", "testgithubrelease"])
def vsmake_synth_buildgithub(args):
    """Run VSMake only on GitHub targets to save build time - by default all of the files needed for the 
    GitHub release will be included in the synthesis file list when running VSMake.
    """    
    for target in get_applicable_targetconfigs(args):
        with WorkingFolder(folder=f"{target}", base="root"):
            tc = targetconfigs[target]
            if tc.get("supportsgithubrelease", True):
                _run_vsmake(mode=VSMakeMode.synth)


@EdaBuildClass.flow(["buildgithubrelease", "testgithubrelease"])
def vsmake_shared_deps(args):
    """Run VSMake on shared dependencies top VHDL file to get the file list for the shared dependencies 
    that are needed for the GitHub release.
    """
    with WorkingFolder(folder="github/hdl_shared_deps", base="repo"):
        _run_vsmake(mode=VSMakeMode.nosynth)

@EdaBuildClass.flow(["buildgithubrelease", "testgithubrelease", "processvsmakefiles"])
def process_vsmake_file_lists(args):
    """Process the file lists generated by VSMake to create the file lists used for the GitHub release and testing
    """    
    _process_vsmake_file_lists(args)


@EdaBuildClass.flow(["build"])
def vsmake_synth_lvfpga(args):
    """Run VSMake again with the "lvfga" option
    
       This runs VSMake excluding lvgen and other files that are needed for 
       synthesis but should not ship with the LV FPGA target plugin.  The file
       list output of this VSMake run is used to create the target plugin export.
    """
    for target in get_applicable_targetconfigs(args):
        with WorkingFolder(folder=f"{target}", base="root"):
            tc = targetconfigs[target]
            _run_vsmake(mode=VSMakeMode.lvfpgasynth)


@EdaBuildClass.flow("build")
def gather_synthesis_files(args):
    """Gathers all files used by synthesis to a single directory
    
       This must run after vsmake_lvfpga that will not include all the lvgen files so 
       they don't get pulled into gatheredfiles for export into the target plugin.
    """
    for target in get_applicable_targetconfigs(args):
        tc = targetconfigs[target]
        topname = tc["toplevelname"]

        # Copy files used by vsmake
        absfiles_txt = pathapi.get_abs_path(
            base="objects", path=f"{target}/vsmake/absfiles_{topname}.txt"
        )
        dest_base = pathapi.get_abs_path(
            base="objects", path=f"{target}/gatheredfiles", checkexist=False
        )

        with WorkingFolder(dest_base, base=None, delete_and_recreate=True):
            with open(absfiles_txt, "r") as file:
                for line in file:
                    s = line.split("::")[1].rstrip()
                    f = os.path.basename(s)
                    d = os.path.join(dest_base, f)
                    pp.printmsg(shutil.copyfile(s, d) + " <--- " + s)


# Only run this steps if this is a CI build - creating the release branch does not work
# in a PR build because the "source_branch" is a temporary merge branch for the PR that 
# cannot be used to restore the files.
@EdaBuildClass.flow(["buildgithubrelease", "buildreleasebranch"])
def build_release_branch(args):
    """Build the GitHub release branch and check it into AzDO"""
    git.runlive("status", raise_on_err=True)  
    git.runlive("fetch", "origin", "ni/githubstaging/flexrio", raise_on_err=True)
    git.runlive("checkout", "ni/githubstaging/flexrio", raise_on_err=True)
    source_branch = "origin/" + args.source_branch.replace("refs/heads/", "")
    print(f"Source branch: {source_branch}")    
    git.runlive("restore", "--source", source_branch, ":/", raise_on_err=True)

    # Gather all of the dependency files into deps/flexrio-deps
    #
    # This needs to happen before we delete the non-user-visible files because some of the files that need 
    # to be gathered are in the source code repo (not in dependencies) and would be deleted before they can
    # be gathered if we ran this step after deleting non-user-visible files.  
    _gather_dependency_files(args, deps_repo_build=False)

    # checkexist default to True for all of these - we want that beacause we are carefully and explicitly choosing
    # which files/folders to keep and want to catch errors if something is missing that we expected to keep.
    #
    # 1) Keep the .git folder because we need it to push to the git repo
    # 2) Keep the .gitignore file because we need it to prevent certain files from being added
    # 3) Keep the dependencies.toml file because it is needed by the HDL flow
    # 4) Keep the deps folder because it contains the flexrio-deps needed to test the workflow
    #    - this is OK because they are ignored in .gitignore
    # 5) Keep the objects folder because it contains files needed to build
    #    - this is OK because they are ignored in .gitignore
    # 6) Keep the repo docs/public folder because it contains the user-facing documentation and
    #    it has binaries that can't get uservisible tag    
    # 7) Keep the targetpluginmenus folder because it contains the target plugin files that are needed
    #    to generate the target plugin.  Some of these files are binary and not marked as user visible.
    skip_paths = [
        pathapi.get_abs_path(".git", base="repo"),
        pathapi.get_abs_path(".gitignore", base="repo"),
        pathapi.get_abs_path("deps/", base="repo"),
        pathapi.get_abs_path("objects/", base="root"),
        pathapi.get_abs_path("docs/public", base="repo"),     
        pathapi.get_abs_path("targets/common/lvFpgaTarget/targetpluginmenus", base="repo"),        
    ]
    # 8) Keep the target docs/public folder because it contains the user-facing documentation and
    #    it has binaries that can't get uservisible tag.  Not all targets have this folder so we disable
    #    checking existence
    for target in get_applicable_targetconfigs(args):
        skip_paths.append(pathapi.get_abs_path(f"targets/{target}/docs/public", base="repo", checkexist=False))

    # Normalize the skip_paths for cross-platform compatibility
    skip_paths = [os.path.normpath(path) for path in skip_paths]
    githubbuildtools.delete_files_without_uservisible_tag(
        pathapi.get_abs_path(".", base="repo"), USERVISIBLE_TAG, skip_paths
    )

    # Copy files from objects directory into the GitHub source code directory
    _copy_object_files_for_github(args)

    git.runlive("add", "--all", raise_on_err=True)

    # Check if there are any changes using diff-index
    # diff-index returns True if no changes, False if there are changes
    has_no_changes = git.run("diff-index", "--quiet", "HEAD", raise_on_err=False)   
    if has_no_changes:
        pp.printmsg("No changes to commit. Skipping commit and push.")
    else:
        git.runlive("commit", "-m", _resolve_commit_message(), raise_on_err=True)
        git.runlive("push", "origin", "ni/githubstaging/flexrio", raise_on_err=True)


# Only run this steps if this is a PR build - we cannot build the release staging branch in a PR build
# because the "source_branch" is a temporary merge branch for the PR.  However, we still want to test
# the GitHub release process so we run this step to copy the files into the GitHub source code directory
# which is needed for the downstream tests to work properly.
@EdaBuildClass.flow(["testgithubrelease", "copyfiles", "deletefiles"])
def copy_testing_files(args):
    # Copy files from objects directory into the GitHub source code directory
    _copy_object_files_for_github(args)  
    # Gather all of the encrypted files into deps/flexrio-deps/encrypted folder
    _gather_dependency_files(args, deps_repo_build=False)


@EdaBuildClass.flow(["buildgithubrelease", "testgithubrelease", "validategithubfiles"])
def validate_github_files(args):
    """Validate Vivado project file lists for the user FPGA workflow - for testing only
    
       This is done after build_release_branch because the repo is in the state after all the
       non-user-visible files are deleted and better mimics what it will be like for the user.
    """
    for target in get_applicable_targetconfigs(args):
        with WorkingFolder(folder=f"{target}", base="root"):
            if os.path.exists("VivadoProject"):
                shutil.rmtree("VivadoProject", ignore_errors=True)
            # Check if the target supports GitHub release before validating project file lists
            tc = targetconfigs[target]
            if tc.get("supportsgithubrelease", True):
                _validate_vivado_project_file_lists(
                    source_file_list="vivadoprojectsources.txt",
                    deps_file_list="vivadoprojectdeps.txt",
                )
            else:
                pp.printmsg(
                    f"Target does not support GitHub, skipping Vivado project file list validation."
                )


@EdaBuildClass.flow(["testgithubrelease", "deletefiles"])
def cleanup_testing_files(args):
    _delete_temp_files()


# This must be the last stage of buildgithubrelease because it deletes everything except the dependencies
@EdaBuildClass.flow(["buildgithubrelease"])
def build_deps_branch(args):
    """Build the GitHub dependencies branch and check it into AzDO"""
    git.runlive("status", raise_on_err=True)  
    git.runlive("fetch", "origin", "ni/githubstaging/flexrio-deps-source", raise_on_err=True)
    git.runlive(
        "checkout",
        "-B",
        "ni/githubstaging/flexrio-deps-source",
        "origin/ni/githubstaging/flexrio-deps-source",
        raise_on_err=True,
    )
    source_branch = "origin/" + args.source_branch.replace("refs/heads/", "")
    print(f"Source branch: {source_branch}")    
    git.runlive("restore", "--source", source_branch, ":/", raise_on_err=True)

    # Gather all of the dependency files from objects into source folder (not including deps/flexrio-deps in path)
    _gather_dependency_files(args, deps_repo_build=True)

    # 1) Keep the .git folder because we need it to push to the git repo
    # 2) Keep the .gitignore file because we need it to prevent certain files from being added
    # 3) Keep the targets objects folder because it contains the files that are during the build
    #    - this is OK because they are ignored in .gitignore
    # 4) Keep the source folder because these are the files we want in the deps repo
    skip_paths = [
        pathapi.get_abs_path(".git", base="repo"),
        pathapi.get_abs_path(".gitignore", base="repo"),
        pathapi.get_abs_path("objects/", base="root"),
        pathapi.get_abs_path("source/", base="repo"),
    ]

    # Normalize the skip_paths for cross-platform compatibility
    skip_paths = [os.path.normpath(path) for path in skip_paths]
    # Use a blank uservisible tag to delete all files except those in skip_paths
    blank_uservisible_tag = ""
    githubbuildtools.delete_files_without_uservisible_tag(
        pathapi.get_abs_path(".", base="repo"), blank_uservisible_tag, skip_paths
    )

    # Copy the hdl shared deps file list from objects into the source code directory
    _copy_object_files_for_github_deps()
                              
    git.runlive("add", "--all", raise_on_err=True)
    
    # Check if there are any changes using diff-index
    # diff-index returns True if no changes, False if there are changes
    has_no_changes = git.run("diff-index", "--quiet", "HEAD", raise_on_err=False)   
    if has_no_changes:
        pp.printmsg("No changes to commit. Skipping commit and push.")
    else:
        git.runlive("commit", "-m", _resolve_commit_message(), raise_on_err=True)
        git.runlive("push", "origin", "ni/githubstaging/flexrio-deps-source", raise_on_err=True)


@EdaBuildClass.flow("encryptdeps")
def encrypt_deps(args):
    """Encrypt the dependencies using encrypt-vhdl-vivado tool"""
    git.runlive("status", raise_on_err=True)
    git.runlive(
        "checkout",
        "-B",
        "ni/githubstaging/flexrio-deps-source",
        "origin/ni/githubstaging/flexrio-deps-source",
        raise_on_err=True,
    )
    git.runlive("pull", raise_on_err=True)
    source_folder = pathapi.get_abs_path("source", base="repo")
    hdl_shared_deps_list_src = pathapi.get_abs_path("hdl_shared_deps_list", base="repo", checkexist=False)

    with tempfile.TemporaryDirectory(prefix="flexrio-deps-encrypted-") as temp_dir:
        encrypted_temp = os.path.join(temp_dir, "encrypted")
        _encrypt_files(source_folder, encrypted_temp, delete_source=False)

        # Save hdl_shared_deps_list to temp before switching branches
        hdl_shared_deps_list_temp = os.path.join(temp_dir, "hdl_shared_deps_list")
        if os.path.exists(hdl_shared_deps_list_src):
            shutil.copytree(hdl_shared_deps_list_src, hdl_shared_deps_list_temp)

        git.runlive(
            "checkout",
            "-B",
            "ni/githubstaging/flexrio-deps",
            "origin/ni/githubstaging/flexrio-deps",
            raise_on_err=True,
        )
        git.runlive("pull", raise_on_err=True)

        encrypted_folder = pathapi.get_abs_path("encrypted", base="repo")
        if os.path.exists(encrypted_folder):
            shutil.rmtree(encrypted_folder)
        shutil.copytree(encrypted_temp, encrypted_folder)

        # Copy hdl_shared_deps_list from temp onto the deps branch
        hdl_shared_deps_list_dest = pathapi.get_abs_path("hdl_shared_deps_list", base="repo", checkexist=False)
        if os.path.exists(hdl_shared_deps_list_dest):
            shutil.rmtree(hdl_shared_deps_list_dest)
        if os.path.exists(hdl_shared_deps_list_temp):
            shutil.copytree(hdl_shared_deps_list_temp, hdl_shared_deps_list_dest)

        git.runlive("add", "--all", raise_on_err=True)
        git.runlive("commit", "-m", "Encrypt dependencies", raise_on_err=True)
        git.runlive("push", "origin", "ni/githubstaging/flexrio-deps", raise_on_err=True)


@EdaBuildClass.flow(["pushgithub", "pushgithubtargets"])
def push_release_branch_to_github(args):
    git.runlive("status", raise_on_err=True)
    git.runlive(
        "checkout",
        "-B",
        "ni/githubstaging/flexrio",
        "origin/ni/githubstaging/flexrio",
        raise_on_err=True,
    )
    git.runlive("pull", raise_on_err=True)
    githubbuildtools.add_git_remote_if_not_exists(
        "flexrio", "https://github.com/ni/flexrio.git"
    )
    git.runlive("fetch", "flexrio", raise_on_err=True)
    git.runlive("push", "flexrio", "ni/githubstaging/flexrio", raise_on_err=True)


@EdaBuildClass.flow(["pushgithub", "pushgithubdeps"])
def push_deps_branch_to_github(args):
    git.runlive("status", raise_on_err=True)
    git.runlive(
        "checkout",
        "-B",
        "ni/githubstaging/flexrio-deps",
        "origin/ni/githubstaging/flexrio-deps",
        raise_on_err=True,
    )
    git.runlive("pull", raise_on_err=True)
    
    # Validate that all files are encrypted before pushing to GitHub
    encrypted_folder = pathapi.get_abs_path("encrypted", base="repo")
    _validate_encrypted_files(encrypted_folder)
    
    githubbuildtools.add_git_remote_if_not_exists(
        "flexrio-deps", "https://github.com/ni/flexrio-deps.git"
    )
    git.runlive("fetch", "flexrio-deps", raise_on_err=True)
    git.runlive("push", "flexrio-deps", "ni/githubstaging/flexrio-deps", raise_on_err=True)


def build():
    with EdaBuildClass() as buildobj:
        buildobj.set_default_flow("build")
        buildobj.add_argument(
            "--source_branch",
            type=str,
            default="users/ssantolu/targets-lite",
            help="Branch used to create the release branch",
        )        
        add_target_build_arg(buildobj)


if __name__ == "__main__":
    build()
