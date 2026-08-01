import difflib
import os
import sys
from mako.template import Template

NEW = r"c:\dev\git\hw-flexrio\targets\pcie-7981"
OLD = r"c:\dev\git2\hw-flexrio\targets\pcie-7981"

CTX = dict(
    include_board_io=True,
    include_custom_io=False,
    custom_target=False,
    lv_target_name="PCIe-7981",
    lv_target_guid="",
    custom_signals=[],
    min_lv_reg_offset="0x00000",
    num_reserved_dma_stream_channel_ids="4",
    net_path_to_the_window="TheLvWindow",
    current_instance_path_for_window="",
    include_current_instance_path_for_window=False,
)

pairs = [
    ("lvFpgaTarget/Resource.xml.mako", "lvFpgaTarget/Resource.xml"),
    ("lvFpgaTarget/Garrison7981.xml.mako", "lvFpgaTarget/Garrison7981.xml"),
    ("rtl-lvfpga/lvgen/TheWindow.vhd.mako", "rtl-lvfpga/lvgen/TheWindow.vhd"),
]

for makorel, oldrel in pairs:
    makopath = os.path.join(NEW, makorel)
    oldpath = os.path.join(OLD, oldrel)
    with open(makopath) as f:
        rendered = Template(f.read()).render(**CTX)
    with open(oldpath) as f:
        original = f.read()
    print("=" * 80)
    print(makorel)
    diff = list(difflib.unified_diff(
        original.splitlines(), rendered.splitlines(),
        fromfile="ORIGINAL", tofile="RENDERED", lineterm=""))
    if not diff:
        print("  IDENTICAL")
    else:
        print("\n".join(diff))
