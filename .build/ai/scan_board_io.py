import glob, re
from mako.template import Template

# Ports that belong to a board-IO CLIP/socket. If any survive an
# include_board_io=False render, they are NOT wrapped -> bug.
BOARD_IO_SIGNATURES = [
    "MgtPortRx", "MgtPortTx", "MgtRefClk_", "MgtPortOneLane", "MgtPortZeroLane",
    "MgtTxPort", "MgtRxPort", "Qsfp",
    "ext_ch_gt_drp",
    "aLvAuxDio", "aSeGpio", "aDiffGpio", "DioMgt",
    "aPllI2c", "aPllPdn", "aPllStatus", "aPllGpio", "aExtRefClkEn",
    "xClipAxi4Lite", "xDiagramAxiStream", "xHostAxiStream",
    "aConfigTx", "aConfigRx", "aReservedToClip", "aReservedFromClip",
    "stIoModuleSupportsFRAGLs", "aRsrvGpio", "ExportedMgtRefClk",
]

BASE = dict(
    include_custom_io=False, custom_target=False, lv_target_name="X",
    lv_target_guid="", custom_signals=[], min_lv_reg_offset="0x00000",
    num_reserved_dma_stream_channel_ids="4", net_path_to_the_window="TheLvWindow",
    current_instance_path_for_window="", include_current_instance_path_for_window=False,
    custom_clock="c.xml", custom_boardio="b.xml",
)

TARGETS = ["pcie-7981","pcie-7982","pcie-7985","pxie-7990","pxie-7991","pxie-7992","pxie-7993","pxie-6595"]
any_bug = False
for t in TARGETS:
    win = f"targets/{t}/rtl-lvfpga/lvgen/TheWindow.vhd.mako"
    src = open(win).read()
    off = Template(src).render(**dict(BASE, include_board_io=False))
    on  = Template(src).render(**dict(BASE, include_board_io=True))
    leaked = sorted({sig for sig in BOARD_IO_SIGNATURES if sig in off})
    # also count how many board-IO ports get dropped (sanity: should be > 0)
    dropped = sum(1 for sig in BOARD_IO_SIGNATURES if sig in on) - len(leaked)
    status = "OK" if not leaked else f"LEAK: {leaked}"
    print(f"{t:12} board-IO sigs dropped={dropped:2}  {status}")
    if leaked:
        any_bug = True
print("\nRESULT:", "ALL WRAPPED CORRECTLY" if not any_bug else "*** MISMATCHES FOUND ***")
