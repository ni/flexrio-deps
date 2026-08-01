import glob, sys
from mako.template import Template

def lv(t):
    return t.upper().replace("PXIE","PXIe").replace("PCIE","PCIe")

CTX = dict(
    include_board_io=True, include_custom_io=False, custom_target=False,
    lv_target_guid="GUID", custom_signals=[], min_lv_reg_offset="0x0",
    num_reserved_dma_stream_channel_ids="4", net_path_to_the_window="W",
    current_instance_path_for_window="", include_current_instance_path_for_window=False,
    custom_clock="c", custom_boardio="b",
)
CTX_CUSTOM = dict(CTX, custom_target=True, lv_target_name="MyCustomTgt")

def target_of(path):
    return path.replace("\\","/").split("targets/")[1].split("/")[0]

out = {}
for f in sorted(glob.glob("targets/**/lvFpgaTarget/Resource.xml.mako", recursive=True)):
    if "\\objects\\" in f or "/objects/" in f:
        continue
    t = target_of(f)
    src = open(f).read()
    base = Template(src).render(**dict(CTX, lv_target_name=lv(t)))
    cust = Template(src).render(**CTX_CUSTOM)
    out[t] = (base, cust)

mode = sys.argv[1] if len(sys.argv) > 1 else "dump"
import json, os
snap = ".build/ai/_resource_snapshot.json"
if mode == "save":
    json.dump(out, open(snap,"w"))
    print(f"saved {len(out)} baselines")
elif mode == "check":
    old = json.load(open(snap))
    bad = 0
    for t in out:
        if out[t][0] != old[t][0]:
            bad += 1; print(f"*** {t}: BASE RENDER CHANGED ***")
        if out[t][1] != old[t][1]:
            bad += 1; print(f"*** {t}: CUSTOM RENDER CHANGED ***")
    print("ALL RENDERS IDENTICAL (base+custom preserved)" if not bad else f"{bad} DIFFERENCES")
