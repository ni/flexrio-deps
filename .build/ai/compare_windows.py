import re
from mako.template import Template

def ctx(bio):
    return dict(
        include_board_io=bio, include_custom_io=False, custom_target=False,
        lv_target_name="X", lv_target_guid="", custom_signals=[], min_lv_reg_offset="0x0",
        num_reserved_dma_stream_channel_ids="4", net_path_to_the_window="W",
        current_instance_path_for_window="", include_current_instance_path_for_window=False,
        custom_clock="c", custom_boardio="b",
    )

TARGETS = ["pcie-7981","pcie-7982","pcie-7985","pxie-7990","pxie-7991","pxie-7992","pxie-7993","pxie-6595"]
PORT_RE = re.compile(r'^\s*([A-Za-z]\w*)\s*:\s*(in|out|inout)\b')

def portset(t, bio):
    src = open(f"targets/{t}/rtl-lvfpga/lvgen/TheWindow.vhd.mako").read()
    r = Template(src).render(**ctx(bio))
    return [m.group(1) for line in r.splitlines() if (m := PORT_RE.match(line))]

outside = {t: set(portset(t, False)) for t in TARGETS}
allports = {t: set(portset(t, True)) for t in TARGETS}

allnames = sorted(set().union(*outside.values()))
common = set.intersection(*outside.values())
diff = [n for n in allnames if n not in common]

print(f"Common OUTSIDE-board-io signals across all 8: {len(common)}")
print(f"Signals that differ (outside): {len(diff)}\n")

def cls(t, n):
    if n in outside[t]:
        return "OUT"
    if n in allports[t]:
        return "IN "
    return "-- "

hdr = "SIGNAL".ljust(26) + "".join(t.replace('pcie-','c').replace('pxie-','p').rjust(7) for t in TARGETS)
print(hdr)
inconsistent = []
for n in diff:
    cells = [cls(t, n) for t in TARGETS]
    print(n.ljust(26) + "".join(c.rjust(7) for c in cells))
    if "OUT" in cells and "IN " in cells:
        inconsistent.append(n)

print("\n=== WRAPPING INCONSISTENCIES (OUT in some, IN board_io in others) ===")
print("  " + (", ".join(inconsistent) if inconsistent else "(none - every difference is OUT-vs-absent = genuine hardware variation)"))
