
set_false_path -from [get_pins -hierarchical -filter {NAME =~ *Dram2DPCorex*bNumOfMemBuffers*/C}]
set_false_path -from [get_pins -hierarchical -filter {NAME =~ *Dram2DPCorex*bLowLatencyBuffer*/C}]
set_false_path -from [get_pins -hierarchical -filter {NAME =~ *Dram2DPCorex*bBaseAddrTable*/C}]
set_false_path -from [get_pins -hierarchical -filter {NAME =~ *Dram2DPCorex*bBaggageBits*/C}]
set_false_path -from [get_pins -hierarchical -filter {NAME =~ *Dram2DPCorex*ClearFDCP*/C}]