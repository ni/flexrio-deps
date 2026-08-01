import subprocess, difflib, sys
from mako.template import Template

CTX = dict(
    include_board_io=True, include_custom_io=False, custom_target=False,
    lv_target_guid="", custom_signals=[], min_lv_reg_offset="0x00000",
    num_reserved_dma_stream_channel_ids="4", net_path_to_the_window="TheLvWindow",
    current_instance_path_for_window="", include_current_instance_path_for_window=False,
)

def lv_name(t):
    return t.upper().replace("PXIE", "PXIe").replace("PCIE", "PCIe")

def dev(t):
    # device xml basename per target
    return {
        "pcie-7981": "Garrison7981", "pcie-7982": "Garrison7982", "pcie-7985": "Garrison7985",
        "pxie-7993": "Blackadder7993", "pxie-7990": "BTrace7990", "pxie-7991": "BTrace7991",
        "pxie-7992": "BTrace7992", "pxie-6595": "Coruba6595",
    }[t]

def files(t):
    d = dev(t)
    return [("lvFpgaTarget/Resource.xml.mako", "lvFpgaTarget/Resource.xml"),
            (f"lvFpgaTarget/{d}.xml.mako", f"lvFpgaTarget/{d}.xml"),
            ("rtl-lvfpga/lvgen/TheWindow.vhd.mako", "rtl-lvfpga/lvgen/TheWindow.vhd")]

ALL = ["pcie-7981","pcie-7982","pcie-7985","pxie-7993","pxie-7990","pxie-7991","pxie-7992","pxie-6595"]
only = sys.argv[1:] or ALL
for t in only:
    ctx = dict(CTX, lv_target_name=lv_name(t))
    print("=" * 70, t)
    for m, b in files(t):
        try:
            with open(f"targets/{t}/{m}") as f:
                r = Template(f.read()).render(**ctx)
        except Exception as e:
            print(f"  {m}: RENDER ERROR {e}")
            continue
        base = subprocess.run(["git", "show", f"HEAD:targets/{t}/{b}"], capture_output=True, text=True).stdout
        diff = list(difflib.unified_diff(base.splitlines(), r.splitlines(), lineterm="", n=0))[2:]
        if not diff:
            print(f"  {m}: IDENTICAL")
        else:
            print(f"  {m}:")
            for l in diff:
                if not l.startswith("@@"):
                    print("     ", l)
