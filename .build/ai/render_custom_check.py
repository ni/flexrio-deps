import glob, os, sys
from mako.template import Template

CTX = dict(
    include_board_io=False, include_custom_io=True, custom_target=True,
    lv_target_name="PXIe-9999Custom", lv_target_guid="12345678-1234-1234-1234-123456789abc",
    custom_signals=[{"name": "aFoo", "direction": "in", "type": "std_logic", "lv_name": "Foo"}],
    min_lv_reg_offset="0x00404", num_reserved_dma_stream_channel_ids="6",
    net_path_to_the_window="TheLvWindowWrapper/TheLvWindow",
    current_instance_path_for_window="TheLvWindowWrapper",
    include_current_instance_path_for_window=True,
    custom_clock="CustomClock.xml", custom_boardio="CustomBoardIo.xml",
)

TARGETS = ["pcie-7981","pcie-7982","pcie-7985","pxie-7993","pxie-7990","pxie-7991","pxie-7992","pxie-6595"]
fail = 0
for t in TARGETS:
    for m in glob.glob(f"targets/{t}/**/*.mako", recursive=True):
        try:
            out = Template(open(m).read()).render(**CTX)
        except Exception as e:
            print(f"ERROR {m}: {e}"); fail += 1; continue
        # sanity: no leftover mako control lines, window has entity
        bad = [ln for ln in out.splitlines() if ln.strip().startswith("% ")]
        if bad:
            print(f"LEFTOVER MAKO {m}: {bad[:2]}"); fail += 1
        if m.endswith("TheWindow.vhd.mako"):
            if "entity TheWindow" not in out or "aFoo : in std_logic" not in out:
                print(f"WINDOW SANITY FAIL {m}"); fail += 1
print("ALL CUSTOM RENDERS OK" if not fail else f"{fail} FAILURES")
