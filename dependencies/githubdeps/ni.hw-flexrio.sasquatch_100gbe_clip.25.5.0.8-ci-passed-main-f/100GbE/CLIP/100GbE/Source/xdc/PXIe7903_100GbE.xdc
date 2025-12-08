# 
# This file was automatically processed for release on GitHub
# All comments were removed and this header was added
# 
# 
# (c) 2025 Copyright National Instruments Corporation
# 
# SPDX-License-Identifier: MIT
# 
# 

# IBERT uses 156.25MHz reference clocks
create_clock -period 6.4 [get_ports MgtRefClk_p[0]]
create_clock -period 6.4 [get_ports MgtRefClk_p[1]]
create_clock -period 6.4 [get_ports MgtRefClk_p[2]]
create_clock -period 6.4 [get_ports MgtRefClk_p[3]]
create_clock -period 6.4 [get_ports MgtRefClk_p[4]]
create_clock -period 6.4 [get_ports MgtRefClk_p[5]]
create_clock -period 6.4 [get_ports MgtRefClk_p[6]]
create_clock -period 6.4 [get_ports MgtRefClk_p[7]]
create_clock -period 6.4 [get_ports MgtRefClk_p[8]]
create_clock -period 6.4 [get_ports MgtRefClk_p[9]]
create_clock -period 6.4 [get_ports MgtRefClk_p[10]]
create_clock -period 6.4 [get_ports MgtRefClk_p[11]]

# CMAC location constraints
set_property LOC CMACE4_X0Y0 [get_cells -hierarchical -filter {NAME =~ %ClipInstancePath%/CmacCore0/CmacWrapperx/cmac_ipx/inst/* && REF_NAME==CMACE4}]
set_property LOC CMACE4_X0Y1 [get_cells -hierarchical -filter {NAME =~ %ClipInstancePath%/CmacCore2/CmacWrapperx/cmac_ipx/inst/* && REF_NAME==CMACE4}]
set_property LOC CMACE4_X0Y2 [get_cells -hierarchical -filter {NAME =~ %ClipInstancePath%/CmacCore3/CmacWrapperx/cmac_ipx/inst/* && REF_NAME==CMACE4}]
set_property LOC CMACE4_X0Y3 [get_cells -hierarchical -filter {NAME =~ %ClipInstancePath%/CmacCore8/CmacWrapperx/cmac_ipx/inst/* && REF_NAME==CMACE4}]
set_property LOC CMACE4_X0Y4 [get_cells -hierarchical -filter {NAME =~ %ClipInstancePath%/CmacCore10/CmacWrapperx/cmac_ipx/inst/* && REF_NAME==CMACE4}]
set_property LOC CMACE4_X0Y5 [get_cells -hierarchical -filter {NAME =~ %ClipInstancePath%/CmacCore11/CmacWrapperx/cmac_ipx/inst/* && REF_NAME==CMACE4}]

# GTY location constraints
set_property LOC GTYE4_COMMON_X0Y0 [get_cells -hierarchical -filter {NAME =~ %ClipInstancePath%/CmacCore0/CmacWrapperx/cmac_ipx/inst/* && REF_NAME==GTYE4_COMMON}]
set_property LOC GTYE4_COMMON_X0Y2 [get_cells -hierarchical -filter {NAME =~ %ClipInstancePath%/CmacCore2/CmacWrapperx/cmac_ipx/inst/* && REF_NAME==GTYE4_COMMON}]
set_property LOC GTYE4_COMMON_X0Y3 [get_cells -hierarchical -filter {NAME =~ %ClipInstancePath%/CmacCore3/CmacWrapperx/cmac_ipx/inst/* && REF_NAME==GTYE4_COMMON}]
set_property LOC GTYE4_COMMON_X0Y4 [get_cells -hierarchical -filter {NAME =~ %ClipInstancePath%/CmacCore8/CmacWrapperx/cmac_ipx/inst/* && REF_NAME==GTYE4_COMMON}]
set_property LOC GTYE4_COMMON_X0Y6 [get_cells -hierarchical -filter {NAME =~ %ClipInstancePath%/CmacCore10/CmacWrapperx/cmac_ipx/inst/* && REF_NAME==GTYE4_COMMON}]
set_property LOC GTYE4_COMMON_X0Y7 [get_cells -hierarchical -filter {NAME =~ %ClipInstancePath%/CmacCore11/CmacWrapperx/cmac_ipx/inst/* && REF_NAME==GTYE4_COMMON}]

# CMAC reset false paths
set_false_path -from [get_cells %ClipInstancePath%/SasquatchClipFixedLogicx/ConfigGpiox/bMgtRefClkEnabledLcl_reg[*]] -to [get_pins %ClipInstancePath%/CmacCore*/*/CLR]
set_false_path -from [get_cells %ClipInstancePath%/SasquatchClipFixedLogicx/ConfigGpiox/bMgtRefClkEnabledLcl_reg[*]] -to [get_pins %ClipInstancePath%/CmacCore*/*/PRE]

# Clock crossing false paths
set_false_path -from [get_cells %ClipInstancePath%/CmacCore*/uCoreReady_reg] -to [get_cells %ClipInstancePath%/CmacCore*/xCoreReady_ms_reg]