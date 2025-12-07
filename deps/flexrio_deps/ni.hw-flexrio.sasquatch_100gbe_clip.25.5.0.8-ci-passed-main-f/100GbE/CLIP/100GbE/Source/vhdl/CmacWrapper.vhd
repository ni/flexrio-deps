-------------------------------------------------------------------------------
--
-- File: CmacWrapper.vhd
-- Author: National Instruments
-- Original Project: PXIe-7903 HSS
-- Date: 02 June 2022
--
-------------------------------------------------------------------------------
-- Copyright (c) 2025 National Instruments Corporation
-- 
-- SPDX-License-Identifier: MIT
-------------------------------------------------------------------------------
--
-- Purpose:
--   Instantiates the CMAC IP, renaming ports and tying unused ports to
-- appropriate values.
--
-------------------------------------------------------------------------------
--
-- githubvisibledep=true
--

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.PkgFlexRioTargetConfig.all;

library unisim;
  use unisim.vcomponents.all;

entity CmacWrapper is
  port (
    -- MGTs
    MgtRefClk_p                                     : in  std_logic;
    MgtRefClk_n                                     : in  std_logic;
    MgtPortRx_n                                     : in  std_logic_vector(3 downto 0);
    MgtPortRx_p                                     : in  std_logic_vector(3 downto 0);
    MgtPortTx_n                                     : out std_logic_vector(3 downto 0);
    MgtPortTx_p                                     : out std_logic_vector(3 downto 0);
    --vhook_nodgv MgtPort*
    -- Resets
    aResetSl                                        : in  std_logic;
    uUsrRxReset                                     : out std_logic;
    uUsrTxReset                                     : out std_logic;
    -- Clocks
    SysClk                                          : in  std_logic;
    UserClk                                         : out std_logic;
    -- RX AXIS
    uRxTData0                                       : out std_logic_vector(63 downto 0);
    uRxTData1                                       : out std_logic_vector(63 downto 0);
    uRxTData2                                       : out std_logic_vector(63 downto 0);
    uRxTData3                                       : out std_logic_vector(63 downto 0);
    uRxTData4                                       : out std_logic_vector(63 downto 0);
    uRxTData5                                       : out std_logic_vector(63 downto 0);
    uRxTData6                                       : out std_logic_vector(63 downto 0);
    uRxTData7                                       : out std_logic_vector(63 downto 0);
    uRxTKeep                                        : out std_logic_vector(63 downto 0);
    uRxTLast                                        : out std_logic;
    uRxTUser                                        : out std_logic;
    uRxTValid                                       : out std_logic;
    -- TX AXIS
    uTxTData0                                       : in  std_logic_vector(63 downto 0);
    uTxTData1                                       : in  std_logic_vector(63 downto 0);
    uTxTData2                                       : in  std_logic_vector(63 downto 0);
    uTxTData3                                       : in  std_logic_vector(63 downto 0);
    uTxTData4                                       : in  std_logic_vector(63 downto 0);
    uTxTData5                                       : in  std_logic_vector(63 downto 0);
    uTxTData6                                       : in  std_logic_vector(63 downto 0);
    uTxTData7                                       : in  std_logic_vector(63 downto 0);
    uTxTKeep                                        : in  std_logic_vector(63 downto 0);
    uTxTLast                                        : in  std_logic;
    uTxTUser                                        : in  std_logic;
    uTxTReady                                       : out std_logic;
    uTxTValid                                       : in  std_logic;
    -- RX Control/Status
    aRxPolarity                                     : in  std_logic_vector(3 downto 0);
    uStatRxAligned                                  : out std_logic;
    uCtlRxEnable                                    : in  std_logic;
    aCtlRxForceResync                               : in  std_logic;
    uCtlRxTestPattern                               : in  std_logic;
    -- TX Control/Status
    aTxDiffCtrl                                     : in  std_logic_vector(19 downto 0);
    aTxPolarity                                     : in  std_logic_vector(3 downto 0);
    aTxPostCursor                                   : in  std_logic_vector(19 downto 0);
    aTxPreCursor                                    : in  std_logic_vector(19 downto 0);
    uCtlTxEnable                                    : in  std_logic;
    uCtlTxTestPattern                               : in  std_logic;
    uCtlTxSendIdle                                  : in  std_logic;
    uCtlTxSendLfi                                   : in  std_logic;
    uCtlTxSendRfi                                   : in  std_logic;
    -- FEC
    uCtlRsfecIeeeErrorIndicationMode                : in  std_logic;
    uCtlRxRsfecEnable                               : in  std_logic;
    uCtlRxRsfecEnableCorrection                     : in  std_logic;
    uCtlRxRsfecEnableIndication                     : in  std_logic;
    uCtlTxRsfecEnable                               : in  std_logic;
    uStatRxRsfecAmLock0                             : out std_logic;
    uStatRxRsfecAmLock1                             : out std_logic;
    uStatRxRsfecAmLock2                             : out std_logic;
    uStatRxRsfecAmLock3                             : out std_logic;
    uStatRxRsfecCorrectedCwInc                      : out std_logic;
    uStatRxRsfecCwInc                               : out std_logic;
    uStatRxRsfecErrCount0Inc                        : out std_logic_vector(2 downto 0);
    uStatRxRsfecErrCount1Inc                        : out std_logic_vector(2 downto 0);
    uStatRxRsfecErrCount2Inc                        : out std_logic_vector(2 downto 0);
    uStatRxRsfecErrCount3Inc                        : out std_logic_vector(2 downto 0);
    uStatRxRsfecHiSer                               : out std_logic;
    uStatRxRsfecLaneAlignmentStatus                 : out std_logic;
    uStatRxRsfecLaneFill0                           : out std_logic_vector(13 downto 0);
    uStatRxRsfecLaneFill1                           : out std_logic_vector(13 downto 0);
    uStatRxRsfecLaneFill2                           : out std_logic_vector(13 downto 0);
    uStatRxRsfecLaneFill3                           : out std_logic_vector(13 downto 0);
    uStatRxRsfecLaneMapping                         : out std_logic_vector(7 downto 0);
    uStatRxRsfecUncorrectedCwInc                    : out std_logic;
    -- Flow Control
    uCtlRxCheckEtypeGcp      : in  std_logic;
    uCtlRxCheckEtypeGpp      : in  std_logic;
    uCtlRxCheckEtypePcp      : in  std_logic;
    uCtlRxCheckEtypePpp      : in  std_logic;
    uCtlRxCheckMcastGcp      : in  std_logic;
    uCtlRxCheckMcastGpp      : in  std_logic;
    uCtlRxCheckMcastPcp      : in  std_logic;
    uCtlRxCheckMcastPpp      : in  std_logic;
    uCtlRxCheckOpcodeGcp     : in  std_logic;
    uCtlRxCheckOpcodeGpp     : in  std_logic;
    uCtlRxCheckOpcodePcp     : in  std_logic;
    uCtlRxCheckOpcodePpp     : in  std_logic;
    uCtlRxCheckSaGcp         : in  std_logic;
    uCtlRxCheckSaGpp         : in  std_logic;
    uCtlRxCheckSaPcp         : in  std_logic;
    uCtlRxCheckSaPpp         : in  std_logic;
    uCtlRxCheckUcastGcp      : in  std_logic;
    uCtlRxCheckUcastGpp      : in  std_logic;
    uCtlRxCheckUcastPcp      : in  std_logic;
    uCtlRxCheckUcastPpp      : in  std_logic;
    uCtlRxEnableGcp          : in  std_logic;
    uCtlRxEnableGpp          : in  std_logic;
    uCtlRxEnablePcp          : in  std_logic;
    uCtlRxEnablePpp          : in  std_logic;
    uCtlRxPauseAck           : in  std_logic_vector(8 downto 0);
    uCtlRxPauseEnable        : in  std_logic_vector(8 downto 0);
    uCtlTxPauseEnable        : in  std_logic_vector(8 downto 0);
    uCtlTxPauseQuanta0       : in  std_logic_vector(15 downto 0);
    uCtlTxPauseQuanta1       : in  std_logic_vector(15 downto 0);
    uCtlTxPauseQuanta2       : in  std_logic_vector(15 downto 0);
    uCtlTxPauseQuanta3       : in  std_logic_vector(15 downto 0);
    uCtlTxPauseQuanta4       : in  std_logic_vector(15 downto 0);
    uCtlTxPauseQuanta5       : in  std_logic_vector(15 downto 0);
    uCtlTxPauseQuanta6       : in  std_logic_vector(15 downto 0);
    uCtlTxPauseQuanta7       : in  std_logic_vector(15 downto 0);
    uCtlTxPauseQuanta8       : in  std_logic_vector(15 downto 0);
    uCtlTxPauseRefreshTimer0 : in  std_logic_vector(15 downto 0);
    uCtlTxPauseRefreshTimer1 : in  std_logic_vector(15 downto 0);
    uCtlTxPauseRefreshTimer2 : in  std_logic_vector(15 downto 0);
    uCtlTxPauseRefreshTimer3 : in  std_logic_vector(15 downto 0);
    uCtlTxPauseRefreshTimer4 : in  std_logic_vector(15 downto 0);
    uCtlTxPauseRefreshTimer5 : in  std_logic_vector(15 downto 0);
    uCtlTxPauseRefreshTimer6 : in  std_logic_vector(15 downto 0);
    uCtlTxPauseRefreshTimer7 : in  std_logic_vector(15 downto 0);
    uCtlTxPauseRefreshTimer8 : in  std_logic_vector(15 downto 0);
    uCtlTxPauseReq           : in  std_logic_vector(8 downto 0);
    uCtlTxResendPause        : in  std_logic;
    uStatRxPauseQanta0       : out std_logic_vector(15 downto 0);
    uStatRxPauseQanta1       : out std_logic_vector(15 downto 0);
    uStatRxPauseQanta2       : out std_logic_vector(15 downto 0);
    uStatRxPauseQanta3       : out std_logic_vector(15 downto 0);
    uStatRxPauseQanta4       : out std_logic_vector(15 downto 0);
    uStatRxPauseQanta5       : out std_logic_vector(15 downto 0);
    uStatRxPauseQanta6       : out std_logic_vector(15 downto 0);
    uStatRxPauseQanta7       : out std_logic_vector(15 downto 0);
    uStatRxPauseQanta8       : out std_logic_vector(15 downto 0);
    uStatRxPauseReq          : out std_logic_vector(8 downto 0);
    uStatRxPauseValid        : out std_logic_vector(8 downto 0);
    uStatTxPauseValid        : out std_logic_vector(8 downto 0);
    -- IEEE 1588
    uCtlRxSystemtimerin                             : in  std_logic_vector(79 downto 0);
    uCtlTxSystemtimerin                             : in  std_logic_vector(79 downto 0);
    uRxLaneAlignerFill0                             : out std_logic_vector(6 downto 0);
    uRxLaneAlignerFill1                             : out std_logic_vector(6 downto 0);
    uRxLaneAlignerFill10                            : out std_logic_vector(6 downto 0);
    uRxLaneAlignerFill11                            : out std_logic_vector(6 downto 0);
    uRxLaneAlignerFill12                            : out std_logic_vector(6 downto 0);
    uRxLaneAlignerFill13                            : out std_logic_vector(6 downto 0);
    uRxLaneAlignerFill14                            : out std_logic_vector(6 downto 0);
    uRxLaneAlignerFill15                            : out std_logic_vector(6 downto 0);
    uRxLaneAlignerFill16                            : out std_logic_vector(6 downto 0);
    uRxLaneAlignerFill17                            : out std_logic_vector(6 downto 0);
    uRxLaneAlignerFill18                            : out std_logic_vector(6 downto 0);
    uRxLaneAlignerFill19                            : out std_logic_vector(6 downto 0);
    uRxLaneAlignerFill2                             : out std_logic_vector(6 downto 0);
    uRxLaneAlignerFill3                             : out std_logic_vector(6 downto 0);
    uRxLaneAlignerFill4                             : out std_logic_vector(6 downto 0);
    uRxLaneAlignerFill5                             : out std_logic_vector(6 downto 0);
    uRxLaneAlignerFill6                             : out std_logic_vector(6 downto 0);
    uRxLaneAlignerFill7                             : out std_logic_vector(6 downto 0);
    uRxLaneAlignerFill8                             : out std_logic_vector(6 downto 0);
    uRxLaneAlignerFill9                             : out std_logic_vector(6 downto 0);
    uRxPtpPcslaneOut                                : out std_logic_vector(4 downto 0);
    uRxPtpTstampOut                                 : out std_logic_vector(79 downto 0);
    uStatTxPtpFifoReadError                         : out std_logic;
    uStatTxPtpFifoWriteError                        : out std_logic;
    uTxPtp1588opIn                                  : in  std_logic_vector(1 downto 0);
    uTxPtpPcslaneOut                                : out std_logic_vector(4 downto 0);
    uTxPtpTagFieldIn                                : in  std_logic_vector(15 downto 0);
    uTxPtpTstampOut                                 : out std_logic_vector(79 downto 0);
    uTxPtpTstampTagOut                              : out std_logic_vector(15 downto 0);
    uTxPtpTstampValidOut                            : out std_logic;
    -- DRP
    DrpClk                                          : in  std_logic;
    dDrpAddr                                        : in  std_logic_vector(9 downto 0);
    dDrpDi                                          : in  std_logic_vector(15 downto 0);
    dDrpEn                                          : in  std_logic;
    dDrpDo                                          : out std_logic_vector(15 downto 0);
    dDrpRdy                                         : out std_logic;
    dDrpWe                                          : in  std_logic;
    -- Others
    aGtLoopbackIn                                   : in  std_logic_vector(11 downto 0);
    aGtPowerGoodOut                                 : out std_logic_vector(3 downto 0)
  );
end CmacWrapper;

architecture rtl of CmacWrapper is

  --vhook_sigstart
  --vhook_sigend

  --vhook_d cmac_ip
  component cmac_ip
    port (
      gt_rxp_in                            : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_rxn_in                            : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_txp_out                           : out STD_LOGIC_VECTOR(3 downto 0);
      gt_txn_out                           : out STD_LOGIC_VECTOR(3 downto 0);
      gt_txusrclk2                         : out STD_LOGIC;
      gt_loopback_in                       : in  STD_LOGIC_VECTOR(11 downto 0);
      gt_rxrecclkout                       : out STD_LOGIC_VECTOR(3 downto 0);
      gt_powergoodout                      : out STD_LOGIC_VECTOR(3 downto 0);
      gt_ref_clk_out                       : out STD_LOGIC;
      gtwiz_reset_tx_datapath              : in  STD_LOGIC;
      gtwiz_reset_rx_datapath              : in  STD_LOGIC;
      gt_eyescanreset                      : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_eyescantrigger                    : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_rxcdrhold                         : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_rxpolarity                        : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_rxrate                            : in  STD_LOGIC_VECTOR(11 downto 0);
      gt_txdiffctrl                        : in  STD_LOGIC_VECTOR(19 downto 0);
      gt_txpolarity                        : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_txinhibit                         : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_txpippmen                         : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_txpippmsel                        : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_txpostcursor                      : in  STD_LOGIC_VECTOR(19 downto 0);
      gt_txprbsforceerr                    : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_txprecursor                       : in  STD_LOGIC_VECTOR(19 downto 0);
      gt_eyescandataerror                  : out STD_LOGIC_VECTOR(3 downto 0);
      gt_txbufstatus                       : out STD_LOGIC_VECTOR(7 downto 0);
      gt_rxdfelpmreset                     : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_rxlpmen                           : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_rxprbscntreset                    : in  STD_LOGIC_VECTOR(3 downto 0);
      gt_rxprbserr                         : out STD_LOGIC_VECTOR(3 downto 0);
      gt_rxprbssel                         : in  STD_LOGIC_VECTOR(15 downto 0);
      gt_rxresetdone                       : out STD_LOGIC_VECTOR(3 downto 0);
      gt_txprbssel                         : in  STD_LOGIC_VECTOR(15 downto 0);
      gt_txresetdone                       : out STD_LOGIC_VECTOR(3 downto 0);
      gt_rxbufstatus                       : out STD_LOGIC_VECTOR(11 downto 0);
      gt_drpclk                            : in  STD_LOGIC;
      gt0_drpdo                            : out STD_LOGIC_VECTOR(15 downto 0);
      gt0_drprdy                           : out STD_LOGIC;
      gt0_drpen                            : in  STD_LOGIC;
      gt0_drpwe                            : in  STD_LOGIC;
      gt0_drpaddr                          : in  STD_LOGIC_VECTOR(9 downto 0);
      gt0_drpdi                            : in  STD_LOGIC_VECTOR(15 downto 0);
      gt1_drpdo                            : out STD_LOGIC_VECTOR(15 downto 0);
      gt1_drprdy                           : out STD_LOGIC;
      gt1_drpen                            : in  STD_LOGIC;
      gt1_drpwe                            : in  STD_LOGIC;
      gt1_drpaddr                          : in  STD_LOGIC_VECTOR(9 downto 0);
      gt1_drpdi                            : in  STD_LOGIC_VECTOR(15 downto 0);
      gt2_drpdo                            : out STD_LOGIC_VECTOR(15 downto 0);
      gt2_drprdy                           : out STD_LOGIC;
      gt2_drpen                            : in  STD_LOGIC;
      gt2_drpwe                            : in  STD_LOGIC;
      gt2_drpaddr                          : in  STD_LOGIC_VECTOR(9 downto 0);
      gt2_drpdi                            : in  STD_LOGIC_VECTOR(15 downto 0);
      gt3_drpdo                            : out STD_LOGIC_VECTOR(15 downto 0);
      gt3_drprdy                           : out STD_LOGIC;
      gt3_drpen                            : in  STD_LOGIC;
      gt3_drpwe                            : in  STD_LOGIC;
      gt3_drpaddr                          : in  STD_LOGIC_VECTOR(9 downto 0);
      gt3_drpdi                            : in  STD_LOGIC_VECTOR(15 downto 0);
      sys_reset                            : in  STD_LOGIC;
      gt_ref_clk_p                         : in  STD_LOGIC;
      gt_ref_clk_n                         : in  STD_LOGIC;
      init_clk                             : in  STD_LOGIC;
      common0_drpaddr                      : in  STD_LOGIC_VECTOR(15 downto 0);
      common0_drpdi                        : in  STD_LOGIC_VECTOR(15 downto 0);
      common0_drpwe                        : in  STD_LOGIC;
      common0_drpen                        : in  STD_LOGIC;
      common0_drprdy                       : out STD_LOGIC;
      common0_drpdo                        : out STD_LOGIC_VECTOR(15 downto 0);
      rx_axis_tvalid                       : out STD_LOGIC;
      rx_axis_tdata                        : out STD_LOGIC_VECTOR(511 downto 0);
      rx_axis_tlast                        : out STD_LOGIC;
      rx_axis_tkeep                        : out STD_LOGIC_VECTOR(63 downto 0);
      rx_axis_tuser                        : out STD_LOGIC;
      rx_otn_bip8_0                        : out STD_LOGIC_VECTOR(7 downto 0);
      rx_otn_bip8_1                        : out STD_LOGIC_VECTOR(7 downto 0);
      rx_otn_bip8_2                        : out STD_LOGIC_VECTOR(7 downto 0);
      rx_otn_bip8_3                        : out STD_LOGIC_VECTOR(7 downto 0);
      rx_otn_bip8_4                        : out STD_LOGIC_VECTOR(7 downto 0);
      rx_otn_data_0                        : out STD_LOGIC_VECTOR(65 downto 0);
      rx_otn_data_1                        : out STD_LOGIC_VECTOR(65 downto 0);
      rx_otn_data_2                        : out STD_LOGIC_VECTOR(65 downto 0);
      rx_otn_data_3                        : out STD_LOGIC_VECTOR(65 downto 0);
      rx_otn_data_4                        : out STD_LOGIC_VECTOR(65 downto 0);
      rx_otn_ena                           : out STD_LOGIC;
      rx_otn_lane0                         : out STD_LOGIC;
      rx_otn_vlmarker                      : out STD_LOGIC;
      rx_preambleout                       : out STD_LOGIC_VECTOR(55 downto 0);
      usr_rx_reset                         : out STD_LOGIC;
      gt_rxusrclk2                         : out STD_LOGIC;
      rx_lane_aligner_fill_0               : out STD_LOGIC_VECTOR(6 downto 0);
      rx_lane_aligner_fill_1               : out STD_LOGIC_VECTOR(6 downto 0);
      rx_lane_aligner_fill_10              : out STD_LOGIC_VECTOR(6 downto 0);
      rx_lane_aligner_fill_11              : out STD_LOGIC_VECTOR(6 downto 0);
      rx_lane_aligner_fill_12              : out STD_LOGIC_VECTOR(6 downto 0);
      rx_lane_aligner_fill_13              : out STD_LOGIC_VECTOR(6 downto 0);
      rx_lane_aligner_fill_14              : out STD_LOGIC_VECTOR(6 downto 0);
      rx_lane_aligner_fill_15              : out STD_LOGIC_VECTOR(6 downto 0);
      rx_lane_aligner_fill_16              : out STD_LOGIC_VECTOR(6 downto 0);
      rx_lane_aligner_fill_17              : out STD_LOGIC_VECTOR(6 downto 0);
      rx_lane_aligner_fill_18              : out STD_LOGIC_VECTOR(6 downto 0);
      rx_lane_aligner_fill_19              : out STD_LOGIC_VECTOR(6 downto 0);
      rx_lane_aligner_fill_2               : out STD_LOGIC_VECTOR(6 downto 0);
      rx_lane_aligner_fill_3               : out STD_LOGIC_VECTOR(6 downto 0);
      rx_lane_aligner_fill_4               : out STD_LOGIC_VECTOR(6 downto 0);
      rx_lane_aligner_fill_5               : out STD_LOGIC_VECTOR(6 downto 0);
      rx_lane_aligner_fill_6               : out STD_LOGIC_VECTOR(6 downto 0);
      rx_lane_aligner_fill_7               : out STD_LOGIC_VECTOR(6 downto 0);
      rx_lane_aligner_fill_8               : out STD_LOGIC_VECTOR(6 downto 0);
      rx_lane_aligner_fill_9               : out STD_LOGIC_VECTOR(6 downto 0);
      rx_ptp_tstamp_out                    : out STD_LOGIC_VECTOR(79 downto 0);
      rx_ptp_pcslane_out                   : out STD_LOGIC_VECTOR(4 downto 0);
      ctl_rx_systemtimerin                 : in  STD_LOGIC_VECTOR(79 downto 0);
      stat_rx_aligned                      : out STD_LOGIC;
      stat_rx_aligned_err                  : out STD_LOGIC;
      stat_rx_bad_code                     : out STD_LOGIC_VECTOR(2 downto 0);
      stat_rx_bad_fcs                      : out STD_LOGIC_VECTOR(2 downto 0);
      stat_rx_bad_preamble                 : out STD_LOGIC;
      stat_rx_bad_sfd                      : out STD_LOGIC;
      stat_rx_bip_err_0                    : out STD_LOGIC;
      stat_rx_bip_err_1                    : out STD_LOGIC;
      stat_rx_bip_err_10                   : out STD_LOGIC;
      stat_rx_bip_err_11                   : out STD_LOGIC;
      stat_rx_bip_err_12                   : out STD_LOGIC;
      stat_rx_bip_err_13                   : out STD_LOGIC;
      stat_rx_bip_err_14                   : out STD_LOGIC;
      stat_rx_bip_err_15                   : out STD_LOGIC;
      stat_rx_bip_err_16                   : out STD_LOGIC;
      stat_rx_bip_err_17                   : out STD_LOGIC;
      stat_rx_bip_err_18                   : out STD_LOGIC;
      stat_rx_bip_err_19                   : out STD_LOGIC;
      stat_rx_bip_err_2                    : out STD_LOGIC;
      stat_rx_bip_err_3                    : out STD_LOGIC;
      stat_rx_bip_err_4                    : out STD_LOGIC;
      stat_rx_bip_err_5                    : out STD_LOGIC;
      stat_rx_bip_err_6                    : out STD_LOGIC;
      stat_rx_bip_err_7                    : out STD_LOGIC;
      stat_rx_bip_err_8                    : out STD_LOGIC;
      stat_rx_bip_err_9                    : out STD_LOGIC;
      stat_rx_block_lock                   : out STD_LOGIC_VECTOR(19 downto 0);
      stat_rx_broadcast                    : out STD_LOGIC;
      stat_rx_fragment                     : out STD_LOGIC_VECTOR(2 downto 0);
      stat_rx_framing_err_0                : out STD_LOGIC_VECTOR(1 downto 0);
      stat_rx_framing_err_1                : out STD_LOGIC_VECTOR(1 downto 0);
      stat_rx_framing_err_10               : out STD_LOGIC_VECTOR(1 downto 0);
      stat_rx_framing_err_11               : out STD_LOGIC_VECTOR(1 downto 0);
      stat_rx_framing_err_12               : out STD_LOGIC_VECTOR(1 downto 0);
      stat_rx_framing_err_13               : out STD_LOGIC_VECTOR(1 downto 0);
      stat_rx_framing_err_14               : out STD_LOGIC_VECTOR(1 downto 0);
      stat_rx_framing_err_15               : out STD_LOGIC_VECTOR(1 downto 0);
      stat_rx_framing_err_16               : out STD_LOGIC_VECTOR(1 downto 0);
      stat_rx_framing_err_17               : out STD_LOGIC_VECTOR(1 downto 0);
      stat_rx_framing_err_18               : out STD_LOGIC_VECTOR(1 downto 0);
      stat_rx_framing_err_19               : out STD_LOGIC_VECTOR(1 downto 0);
      stat_rx_framing_err_2                : out STD_LOGIC_VECTOR(1 downto 0);
      stat_rx_framing_err_3                : out STD_LOGIC_VECTOR(1 downto 0);
      stat_rx_framing_err_4                : out STD_LOGIC_VECTOR(1 downto 0);
      stat_rx_framing_err_5                : out STD_LOGIC_VECTOR(1 downto 0);
      stat_rx_framing_err_6                : out STD_LOGIC_VECTOR(1 downto 0);
      stat_rx_framing_err_7                : out STD_LOGIC_VECTOR(1 downto 0);
      stat_rx_framing_err_8                : out STD_LOGIC_VECTOR(1 downto 0);
      stat_rx_framing_err_9                : out STD_LOGIC_VECTOR(1 downto 0);
      stat_rx_framing_err_valid_0          : out STD_LOGIC;
      stat_rx_framing_err_valid_1          : out STD_LOGIC;
      stat_rx_framing_err_valid_10         : out STD_LOGIC;
      stat_rx_framing_err_valid_11         : out STD_LOGIC;
      stat_rx_framing_err_valid_12         : out STD_LOGIC;
      stat_rx_framing_err_valid_13         : out STD_LOGIC;
      stat_rx_framing_err_valid_14         : out STD_LOGIC;
      stat_rx_framing_err_valid_15         : out STD_LOGIC;
      stat_rx_framing_err_valid_16         : out STD_LOGIC;
      stat_rx_framing_err_valid_17         : out STD_LOGIC;
      stat_rx_framing_err_valid_18         : out STD_LOGIC;
      stat_rx_framing_err_valid_19         : out STD_LOGIC;
      stat_rx_framing_err_valid_2          : out STD_LOGIC;
      stat_rx_framing_err_valid_3          : out STD_LOGIC;
      stat_rx_framing_err_valid_4          : out STD_LOGIC;
      stat_rx_framing_err_valid_5          : out STD_LOGIC;
      stat_rx_framing_err_valid_6          : out STD_LOGIC;
      stat_rx_framing_err_valid_7          : out STD_LOGIC;
      stat_rx_framing_err_valid_8          : out STD_LOGIC;
      stat_rx_framing_err_valid_9          : out STD_LOGIC;
      stat_rx_got_signal_os                : out STD_LOGIC;
      stat_rx_hi_ber                       : out STD_LOGIC;
      stat_rx_inrangeerr                   : out STD_LOGIC;
      stat_rx_internal_local_fault         : out STD_LOGIC;
      stat_rx_jabber                       : out STD_LOGIC;
      stat_rx_local_fault                  : out STD_LOGIC;
      stat_rx_mf_err                       : out STD_LOGIC_VECTOR(19 downto 0);
      stat_rx_mf_len_err                   : out STD_LOGIC_VECTOR(19 downto 0);
      stat_rx_mf_repeat_err                : out STD_LOGIC_VECTOR(19 downto 0);
      stat_rx_misaligned                   : out STD_LOGIC;
      stat_rx_multicast                    : out STD_LOGIC;
      stat_rx_oversize                     : out STD_LOGIC;
      stat_rx_packet_1024_1518_bytes       : out STD_LOGIC;
      stat_rx_packet_128_255_bytes         : out STD_LOGIC;
      stat_rx_packet_1519_1522_bytes       : out STD_LOGIC;
      stat_rx_packet_1523_1548_bytes       : out STD_LOGIC;
      stat_rx_packet_1549_2047_bytes       : out STD_LOGIC;
      stat_rx_packet_2048_4095_bytes       : out STD_LOGIC;
      stat_rx_packet_256_511_bytes         : out STD_LOGIC;
      stat_rx_packet_4096_8191_bytes       : out STD_LOGIC;
      stat_rx_packet_512_1023_bytes        : out STD_LOGIC;
      stat_rx_packet_64_bytes              : out STD_LOGIC;
      stat_rx_packet_65_127_bytes          : out STD_LOGIC;
      stat_rx_packet_8192_9215_bytes       : out STD_LOGIC;
      stat_rx_packet_bad_fcs               : out STD_LOGIC;
      stat_rx_packet_large                 : out STD_LOGIC;
      stat_rx_packet_small                 : out STD_LOGIC_VECTOR(2 downto 0);
      stat_rx_pause                        : out STD_LOGIC;
      stat_rx_pause_quanta0                : out STD_LOGIC_VECTOR(15 downto 0);
      stat_rx_pause_quanta1                : out STD_LOGIC_VECTOR(15 downto 0);
      stat_rx_pause_quanta2                : out STD_LOGIC_VECTOR(15 downto 0);
      stat_rx_pause_quanta3                : out STD_LOGIC_VECTOR(15 downto 0);
      stat_rx_pause_quanta4                : out STD_LOGIC_VECTOR(15 downto 0);
      stat_rx_pause_quanta5                : out STD_LOGIC_VECTOR(15 downto 0);
      stat_rx_pause_quanta6                : out STD_LOGIC_VECTOR(15 downto 0);
      stat_rx_pause_quanta7                : out STD_LOGIC_VECTOR(15 downto 0);
      stat_rx_pause_quanta8                : out STD_LOGIC_VECTOR(15 downto 0);
      stat_rx_pause_req                    : out STD_LOGIC_VECTOR(8 downto 0);
      stat_rx_pause_valid                  : out STD_LOGIC_VECTOR(8 downto 0);
      stat_rx_user_pause                   : out STD_LOGIC;
      ctl_rx_check_etype_gcp               : in  STD_LOGIC;
      ctl_rx_check_etype_gpp               : in  STD_LOGIC;
      ctl_rx_check_etype_pcp               : in  STD_LOGIC;
      ctl_rx_check_etype_ppp               : in  STD_LOGIC;
      ctl_rx_check_mcast_gcp               : in  STD_LOGIC;
      ctl_rx_check_mcast_gpp               : in  STD_LOGIC;
      ctl_rx_check_mcast_pcp               : in  STD_LOGIC;
      ctl_rx_check_mcast_ppp               : in  STD_LOGIC;
      ctl_rx_check_opcode_gcp              : in  STD_LOGIC;
      ctl_rx_check_opcode_gpp              : in  STD_LOGIC;
      ctl_rx_check_opcode_pcp              : in  STD_LOGIC;
      ctl_rx_check_opcode_ppp              : in  STD_LOGIC;
      ctl_rx_check_sa_gcp                  : in  STD_LOGIC;
      ctl_rx_check_sa_gpp                  : in  STD_LOGIC;
      ctl_rx_check_sa_pcp                  : in  STD_LOGIC;
      ctl_rx_check_sa_ppp                  : in  STD_LOGIC;
      ctl_rx_check_ucast_gcp               : in  STD_LOGIC;
      ctl_rx_check_ucast_gpp               : in  STD_LOGIC;
      ctl_rx_check_ucast_pcp               : in  STD_LOGIC;
      ctl_rx_check_ucast_ppp               : in  STD_LOGIC;
      ctl_rx_enable_gcp                    : in  STD_LOGIC;
      ctl_rx_enable_gpp                    : in  STD_LOGIC;
      ctl_rx_enable_pcp                    : in  STD_LOGIC;
      ctl_rx_enable_ppp                    : in  STD_LOGIC;
      ctl_rx_pause_ack                     : in  STD_LOGIC_VECTOR(8 downto 0);
      ctl_rx_pause_enable                  : in  STD_LOGIC_VECTOR(8 downto 0);
      ctl_rx_enable                        : in  STD_LOGIC;
      ctl_rx_force_resync                  : in  STD_LOGIC;
      ctl_rx_test_pattern                  : in  STD_LOGIC;
      ctl_rsfec_ieee_error_indication_mode : in  STD_LOGIC;
      ctl_rx_rsfec_enable                  : in  STD_LOGIC;
      ctl_rx_rsfec_enable_correction       : in  STD_LOGIC;
      ctl_rx_rsfec_enable_indication       : in  STD_LOGIC;
      core_rx_reset                        : in  STD_LOGIC;
      rx_clk                               : in  STD_LOGIC;
      stat_rx_received_local_fault         : out STD_LOGIC;
      stat_rx_remote_fault                 : out STD_LOGIC;
      stat_rx_status                       : out STD_LOGIC;
      stat_rx_stomped_fcs                  : out STD_LOGIC_VECTOR(2 downto 0);
      stat_rx_synced                       : out STD_LOGIC_VECTOR(19 downto 0);
      stat_rx_synced_err                   : out STD_LOGIC_VECTOR(19 downto 0);
      stat_rx_test_pattern_mismatch        : out STD_LOGIC_VECTOR(2 downto 0);
      stat_rx_toolong                      : out STD_LOGIC;
      stat_rx_total_bytes                  : out STD_LOGIC_VECTOR(6 downto 0);
      stat_rx_total_good_bytes             : out STD_LOGIC_VECTOR(13 downto 0);
      stat_rx_total_good_packets           : out STD_LOGIC;
      stat_rx_total_packets                : out STD_LOGIC_VECTOR(2 downto 0);
      stat_rx_truncated                    : out STD_LOGIC;
      stat_rx_undersize                    : out STD_LOGIC_VECTOR(2 downto 0);
      stat_rx_unicast                      : out STD_LOGIC;
      stat_rx_vlan                         : out STD_LOGIC;
      stat_rx_pcsl_demuxed                 : out STD_LOGIC_VECTOR(19 downto 0);
      stat_rx_pcsl_number_0                : out STD_LOGIC_VECTOR(4 downto 0);
      stat_rx_pcsl_number_1                : out STD_LOGIC_VECTOR(4 downto 0);
      stat_rx_pcsl_number_10               : out STD_LOGIC_VECTOR(4 downto 0);
      stat_rx_pcsl_number_11               : out STD_LOGIC_VECTOR(4 downto 0);
      stat_rx_pcsl_number_12               : out STD_LOGIC_VECTOR(4 downto 0);
      stat_rx_pcsl_number_13               : out STD_LOGIC_VECTOR(4 downto 0);
      stat_rx_pcsl_number_14               : out STD_LOGIC_VECTOR(4 downto 0);
      stat_rx_pcsl_number_15               : out STD_LOGIC_VECTOR(4 downto 0);
      stat_rx_pcsl_number_16               : out STD_LOGIC_VECTOR(4 downto 0);
      stat_rx_pcsl_number_17               : out STD_LOGIC_VECTOR(4 downto 0);
      stat_rx_pcsl_number_18               : out STD_LOGIC_VECTOR(4 downto 0);
      stat_rx_pcsl_number_19               : out STD_LOGIC_VECTOR(4 downto 0);
      stat_rx_pcsl_number_2                : out STD_LOGIC_VECTOR(4 downto 0);
      stat_rx_pcsl_number_3                : out STD_LOGIC_VECTOR(4 downto 0);
      stat_rx_pcsl_number_4                : out STD_LOGIC_VECTOR(4 downto 0);
      stat_rx_pcsl_number_5                : out STD_LOGIC_VECTOR(4 downto 0);
      stat_rx_pcsl_number_6                : out STD_LOGIC_VECTOR(4 downto 0);
      stat_rx_pcsl_number_7                : out STD_LOGIC_VECTOR(4 downto 0);
      stat_rx_pcsl_number_8                : out STD_LOGIC_VECTOR(4 downto 0);
      stat_rx_pcsl_number_9                : out STD_LOGIC_VECTOR(4 downto 0);
      stat_rx_rsfec_am_lock0               : out STD_LOGIC;
      stat_rx_rsfec_am_lock1               : out STD_LOGIC;
      stat_rx_rsfec_am_lock2               : out STD_LOGIC;
      stat_rx_rsfec_am_lock3               : out STD_LOGIC;
      stat_rx_rsfec_corrected_cw_inc       : out STD_LOGIC;
      stat_rx_rsfec_cw_inc                 : out STD_LOGIC;
      stat_rx_rsfec_err_count0_inc         : out STD_LOGIC_VECTOR(2 downto 0);
      stat_rx_rsfec_err_count1_inc         : out STD_LOGIC_VECTOR(2 downto 0);
      stat_rx_rsfec_err_count2_inc         : out STD_LOGIC_VECTOR(2 downto 0);
      stat_rx_rsfec_err_count3_inc         : out STD_LOGIC_VECTOR(2 downto 0);
      stat_rx_rsfec_hi_ser                 : out STD_LOGIC;
      stat_rx_rsfec_lane_alignment_status  : out STD_LOGIC;
      stat_rx_rsfec_lane_fill_0            : out STD_LOGIC_VECTOR(13 downto 0);
      stat_rx_rsfec_lane_fill_1            : out STD_LOGIC_VECTOR(13 downto 0);
      stat_rx_rsfec_lane_fill_2            : out STD_LOGIC_VECTOR(13 downto 0);
      stat_rx_rsfec_lane_fill_3            : out STD_LOGIC_VECTOR(13 downto 0);
      stat_rx_rsfec_lane_mapping           : out STD_LOGIC_VECTOR(7 downto 0);
      stat_rx_rsfec_uncorrected_cw_inc     : out STD_LOGIC;
      ctl_tx_systemtimerin                 : in  STD_LOGIC_VECTOR(79 downto 0);
      stat_tx_ptp_fifo_read_error          : out STD_LOGIC;
      stat_tx_ptp_fifo_write_error         : out STD_LOGIC;
      tx_ptp_tstamp_valid_out              : out STD_LOGIC;
      tx_ptp_pcslane_out                   : out STD_LOGIC_VECTOR(4 downto 0);
      tx_ptp_tstamp_tag_out                : out STD_LOGIC_VECTOR(15 downto 0);
      tx_ptp_tstamp_out                    : out STD_LOGIC_VECTOR(79 downto 0);
      tx_ptp_1588op_in                     : in  STD_LOGIC_VECTOR(1 downto 0);
      tx_ptp_tag_field_in                  : in  STD_LOGIC_VECTOR(15 downto 0);
      stat_tx_bad_fcs                      : out STD_LOGIC;
      stat_tx_broadcast                    : out STD_LOGIC;
      stat_tx_frame_error                  : out STD_LOGIC;
      stat_tx_local_fault                  : out STD_LOGIC;
      stat_tx_multicast                    : out STD_LOGIC;
      stat_tx_packet_1024_1518_bytes       : out STD_LOGIC;
      stat_tx_packet_128_255_bytes         : out STD_LOGIC;
      stat_tx_packet_1519_1522_bytes       : out STD_LOGIC;
      stat_tx_packet_1523_1548_bytes       : out STD_LOGIC;
      stat_tx_packet_1549_2047_bytes       : out STD_LOGIC;
      stat_tx_packet_2048_4095_bytes       : out STD_LOGIC;
      stat_tx_packet_256_511_bytes         : out STD_LOGIC;
      stat_tx_packet_4096_8191_bytes       : out STD_LOGIC;
      stat_tx_packet_512_1023_bytes        : out STD_LOGIC;
      stat_tx_packet_64_bytes              : out STD_LOGIC;
      stat_tx_packet_65_127_bytes          : out STD_LOGIC;
      stat_tx_packet_8192_9215_bytes       : out STD_LOGIC;
      stat_tx_packet_large                 : out STD_LOGIC;
      stat_tx_packet_small                 : out STD_LOGIC;
      stat_tx_total_bytes                  : out STD_LOGIC_VECTOR(5 downto 0);
      stat_tx_total_good_bytes             : out STD_LOGIC_VECTOR(13 downto 0);
      stat_tx_total_good_packets           : out STD_LOGIC;
      stat_tx_total_packets                : out STD_LOGIC;
      stat_tx_unicast                      : out STD_LOGIC;
      stat_tx_vlan                         : out STD_LOGIC;
      ctl_tx_enable                        : in  STD_LOGIC;
      ctl_tx_test_pattern                  : in  STD_LOGIC;
      ctl_tx_rsfec_enable                  : in  STD_LOGIC;
      ctl_tx_send_idle                     : in  STD_LOGIC;
      ctl_tx_send_rfi                      : in  STD_LOGIC;
      ctl_tx_send_lfi                      : in  STD_LOGIC;
      core_tx_reset                        : in  STD_LOGIC;
      stat_tx_pause_valid                  : out STD_LOGIC_VECTOR(8 downto 0);
      stat_tx_pause                        : out STD_LOGIC;
      stat_tx_user_pause                   : out STD_LOGIC;
      ctl_tx_pause_enable                  : in  STD_LOGIC_VECTOR(8 downto 0);
      ctl_tx_pause_quanta0                 : in  STD_LOGIC_VECTOR(15 downto 0);
      ctl_tx_pause_quanta1                 : in  STD_LOGIC_VECTOR(15 downto 0);
      ctl_tx_pause_quanta2                 : in  STD_LOGIC_VECTOR(15 downto 0);
      ctl_tx_pause_quanta3                 : in  STD_LOGIC_VECTOR(15 downto 0);
      ctl_tx_pause_quanta4                 : in  STD_LOGIC_VECTOR(15 downto 0);
      ctl_tx_pause_quanta5                 : in  STD_LOGIC_VECTOR(15 downto 0);
      ctl_tx_pause_quanta6                 : in  STD_LOGIC_VECTOR(15 downto 0);
      ctl_tx_pause_quanta7                 : in  STD_LOGIC_VECTOR(15 downto 0);
      ctl_tx_pause_quanta8                 : in  STD_LOGIC_VECTOR(15 downto 0);
      ctl_tx_pause_refresh_timer0          : in  STD_LOGIC_VECTOR(15 downto 0);
      ctl_tx_pause_refresh_timer1          : in  STD_LOGIC_VECTOR(15 downto 0);
      ctl_tx_pause_refresh_timer2          : in  STD_LOGIC_VECTOR(15 downto 0);
      ctl_tx_pause_refresh_timer3          : in  STD_LOGIC_VECTOR(15 downto 0);
      ctl_tx_pause_refresh_timer4          : in  STD_LOGIC_VECTOR(15 downto 0);
      ctl_tx_pause_refresh_timer5          : in  STD_LOGIC_VECTOR(15 downto 0);
      ctl_tx_pause_refresh_timer6          : in  STD_LOGIC_VECTOR(15 downto 0);
      ctl_tx_pause_refresh_timer7          : in  STD_LOGIC_VECTOR(15 downto 0);
      ctl_tx_pause_refresh_timer8          : in  STD_LOGIC_VECTOR(15 downto 0);
      ctl_tx_pause_req                     : in  STD_LOGIC_VECTOR(8 downto 0);
      ctl_tx_resend_pause                  : in  STD_LOGIC;
      tx_axis_tready                       : out STD_LOGIC;
      tx_axis_tvalid                       : in  STD_LOGIC;
      tx_axis_tdata                        : in  STD_LOGIC_VECTOR(511 downto 0);
      tx_axis_tlast                        : in  STD_LOGIC;
      tx_axis_tkeep                        : in  STD_LOGIC_VECTOR(63 downto 0);
      tx_axis_tuser                        : in  STD_LOGIC;
      tx_ovfout                            : out STD_LOGIC;
      tx_unfout                            : out STD_LOGIC;
      tx_preamblein                        : in  STD_LOGIC_VECTOR(55 downto 0);
      usr_tx_reset                         : out STD_LOGIC;
      core_drp_reset                       : in  STD_LOGIC;
      drp_clk                              : in  STD_LOGIC;
      drp_addr                             : in  STD_LOGIC_VECTOR(9 downto 0);
      drp_di                               : in  STD_LOGIC_VECTOR(15 downto 0);
      drp_en                               : in  STD_LOGIC;
      drp_do                               : out STD_LOGIC_VECTOR(15 downto 0);
      drp_rdy                              : out STD_LOGIC;
      drp_we                               : in  STD_LOGIC);
  end component;

  signal UserClkLcl : std_logic;

begin

  ----------------------------------------------------------------------------
  -- Ethernet100G Block Diagram
  ----------------------------------------------------------------------------
  -- use the same name for the instance as in the wrapper of the block diagram
  -- to be able to reuse the constaints
  --vhook cmac_ip
  --vhook_# Clocks and resets in
  --vhook_a sys_reset               aResetSl
  --vhook_a core_rx_reset           aResetSl
  --vhook_a core_tx_reset           aResetSl
  --vhook_a core_drp_reset          aResetSl
  --vhook_a gtwiz_reset_rx_datapath '0'
  --vhook_a gtwiz_reset_tx_datapath '0'
  --vhook_a rx_clk                  UserClkLcl
  --vhook_a init_clk                SysClk
  --vhook_a gt_rxrecclkout          open
  --vhook_a gt_rxusrclk2            open
  --vhook_# Clocks and resets out
  --vhook_a usr_rx_reset            uUsrRxReset
  --vhook_a usr_tx_reset            uUsrTxReset
  --vhook_a gt_txusrclk2            UserClkLcl
  --vhook_a gt_ref_clk_out          open
  --vhook_# MGT ports
  --vhook_a gt_ref_clk_p            MgtRefClk_p
  --vhook_a gt_ref_clk_n            MgtRefClk_n
  --vhook_a gt_rxp_in               MgtPortRx_p
  --vhook_a gt_rxn_in               MgtPortRx_n
  --vhook_a gt_txp_out              MgtPortTx_p
  --vhook_a gt_txn_out              MgtPortTx_n
  --vhook_# Control and status
  --vhook_a gt_loopback_in                             aGtLoopbackIn
  --vhook_a gt_powergoodout                            aGtPowerGoodOut
  --vhook_a gt_rxpolarity                              aRxPolarity
  --vhook_a gt_txpolarity                              aTxPolarity
  --vhook_a gt_txdiffctrl                              aTxDiffCtrl
  --vhook_a gt_txprecursor                             aTxPreCursor
  --vhook_a gt_txpostcursor                            aTxPostCursor
  --vhook_a ctl_rx_enable                              uCtlRxEnable
  --vhook_a ctl_rx_force_resync                        aCtlRxForceResync
  --vhook_a ctl_rx_test_pattern                        uCtlRxTestPattern
  --vhook_a ctl_tx_enable                              uCtlTxEnable
  --vhook_a ctl_tx_test_pattern                        uCtlTxTestPattern
  --vhook_a ctl_tx_send_idle                           uCtlTxSendIdle
  --vhook_a ctl_tx_send_lfi                            uCtlTxSendLfi
  --vhook_a ctl_tx_send_rfi                            uCtlTxSendRfi
  --vhook_a stat_rx_aligned                            uStatRxAligned
  --vhook_a ctl_rsfec_ieee_error_indication_mode       uCtlRsfecIeeeErrorIndicationMode
  --vhook_a ctl_rx_rsfec_enable                        uCtlRxRsfecEnable
  --vhook_a ctl_rx_rsfec_enable_correction             uCtlRxRsfecEnableCorrection
  --vhook_a ctl_rx_rsfec_enable_indication             uCtlRxRsfecEnableIndication
  --vhook_a ctl_tx_rsfec_enable                        uCtlTxRsfecEnable
  --vhook_a stat_rx_rsfec_am_lock0                     uStatRxRsfecAmLock0
  --vhook_a stat_rx_rsfec_am_lock1                     uStatRxRsfecAmLock1
  --vhook_a stat_rx_rsfec_am_lock2                     uStatRxRsfecAmLock2
  --vhook_a stat_rx_rsfec_am_lock3                     uStatRxRsfecAmLock3
  --vhook_a stat_rx_rsfec_corrected_cw_inc             uStatRxRsfecCorrectedCwInc
  --vhook_a stat_rx_rsfec_cw_inc                       uStatRxRsfecCwInc
  --vhook_a stat_rx_rsfec_err_count0_inc               uStatRxRsfecErrCount0Inc
  --vhook_a stat_rx_rsfec_err_count1_inc               uStatRxRsfecErrCount1Inc
  --vhook_a stat_rx_rsfec_err_count2_inc               uStatRxRsfecErrCount2Inc
  --vhook_a stat_rx_rsfec_err_count3_inc               uStatRxRsfecErrCount3Inc
  --vhook_a stat_rx_rsfec_hi_ser                       uStatRxRsfecHiSer
  --vhook_a stat_rx_rsfec_lane_alignment_status        uStatRxRsfecLaneAlignmentStatus
  --vhook_a stat_rx_rsfec_lane_fill_0                  uStatRxRsfecLaneFill0
  --vhook_a stat_rx_rsfec_lane_fill_1                  uStatRxRsfecLaneFill1
  --vhook_a stat_rx_rsfec_lane_fill_2                  uStatRxRsfecLaneFill2
  --vhook_a stat_rx_rsfec_lane_fill_3                  uStatRxRsfecLaneFill3
  --vhook_a stat_rx_rsfec_lane_mapping                 uStatRxRsfecLaneMapping
  --vhook_a stat_rx_rsfec_uncorrected_cw_inc           uStatRxRsfecUncorrectedCwInc
  --vhook_# RX Data
  --vhook_af {rx_axis_tdata}(64*1-1 downto 64*(1-1)) {uRxTData0} continue=true
  --vhook_af {rx_axis_tdata}(64*2-1 downto 64*(2-1)) {uRxTData1} continue=true
  --vhook_af {rx_axis_tdata}(64*3-1 downto 64*(3-1)) {uRxTData2} continue=true
  --vhook_af {rx_axis_tdata}(64*4-1 downto 64*(4-1)) {uRxTData3} continue=true
  --vhook_af {rx_axis_tdata}(64*5-1 downto 64*(5-1)) {uRxTData4} continue=true
  --vhook_af {rx_axis_tdata}(64*6-1 downto 64*(6-1)) {uRxTData5} continue=true
  --vhook_af {rx_axis_tdata}(64*7-1 downto 64*(7-1)) {uRxTData6} continue=true
  --vhook_af {rx_axis_tdata}(64*8-1 downto 64*(8-1)) {uRxTData7}
  --vhook_a rx_axis_tvalid                           uRxTValid
  --vhook_a rx_axis_tkeep                            uRxTKeep
  --vhook_a rx_axis_tlast                            uRxTLast
  --vhook_a rx_axis_tuser                            uRxTUser
  --vhook_# TX Data
  --vhook_af {tx_axis_tdata}(64*1-1 downto 64*(1-1)) {uTxTData0} continue=true
  --vhook_af {tx_axis_tdata}(64*2-1 downto 64*(2-1)) {uTxTData1} continue=true
  --vhook_af {tx_axis_tdata}(64*3-1 downto 64*(3-1)) {uTxTData2} continue=true
  --vhook_af {tx_axis_tdata}(64*4-1 downto 64*(4-1)) {uTxTData3} continue=true
  --vhook_af {tx_axis_tdata}(64*5-1 downto 64*(5-1)) {uTxTData4} continue=true
  --vhook_af {tx_axis_tdata}(64*6-1 downto 64*(6-1)) {uTxTData5} continue=true
  --vhook_af {tx_axis_tdata}(64*7-1 downto 64*(7-1)) {uTxTData6} continue=true
  --vhook_af {tx_axis_tdata}(64*8-1 downto 64*(8-1)) {uTxTData7}
  --vhook_a tx_axis_tuser                            uTxTUser
  --vhook_a tx_axis_tvalid                           uTxTValid
  --vhook_a tx_axis_tready                           uTxTReady
  --vhook_a tx_axis_tkeep                            uTxTKeep
  --vhook_a tx_axis_tlast                            uTxTLast
  --vhook_a tx_ovfout                                open
  --vhook_a tx_unfout                                open
  --vhook_# RX Pause Packets
  --vhook_af {stat_rx_pause_quanta(.)}           {uStatRxPauseQanta$1}
  --vhook_a stat_rx_pause_req                    uStatRxPauseReq
  --vhook_a stat_rx_pause_valid                  uStatRxPauseValid
  --vhook_a ctl_rx_check_etype_gcp               uCtlRxCheckEtypeGcp
  --vhook_a ctl_rx_check_etype_gpp               uCtlRxCheckEtypeGpp
  --vhook_a ctl_rx_check_etype_pcp               uCtlRxCheckEtypePcp
  --vhook_a ctl_rx_check_etype_ppp               uCtlRxCheckEtypePpp
  --vhook_a ctl_rx_check_mcast_gcp               uCtlRxCheckMcastGcp
  --vhook_a ctl_rx_check_mcast_gpp               uCtlRxCheckMcastGpp
  --vhook_a ctl_rx_check_mcast_pcp               uCtlRxCheckMcastPcp
  --vhook_a ctl_rx_check_mcast_ppp               uCtlRxCheckMcastPpp
  --vhook_a ctl_rx_check_opcode_gcp              uCtlRxCheckOpcodeGcp
  --vhook_a ctl_rx_check_opcode_gpp              uCtlRxCheckOpcodeGpp
  --vhook_a ctl_rx_check_opcode_pcp              uCtlRxCheckOpcodePcp
  --vhook_a ctl_rx_check_opcode_ppp              uCtlRxCheckOpcodePpp
  --vhook_a ctl_rx_check_sa_gcp                  uCtlRxCheckSaGcp
  --vhook_a ctl_rx_check_sa_gpp                  uCtlRxCheckSaGpp
  --vhook_a ctl_rx_check_sa_pcp                  uCtlRxCheckSaPcp
  --vhook_a ctl_rx_check_sa_ppp                  uCtlRxCheckSaPpp
  --vhook_a ctl_rx_check_ucast_gcp               uCtlRxCheckUcastGcp
  --vhook_a ctl_rx_check_ucast_gpp               uCtlRxCheckUcastGpp
  --vhook_a ctl_rx_check_ucast_pcp               uCtlRxCheckUcastPcp
  --vhook_a ctl_rx_check_ucast_ppp               uCtlRxCheckUcastPpp
  --vhook_a ctl_rx_enable_gcp                    uCtlRxEnableGcp
  --vhook_a ctl_rx_enable_gpp                    uCtlRxEnableGpp
  --vhook_a ctl_rx_enable_pcp                    uCtlRxEnablePcp
  --vhook_a ctl_rx_enable_ppp                    uCtlRxEnablePpp
  --vhook_a ctl_rx_pause_ack                     uCtlRxPauseAck
  --vhook_a ctl_rx_pause_enable                  uCtlRxPauseEnable
  --vhook_# TX Pause Packets
  --vhook_a stat_tx_pause_valid                  uStatTxPauseValid
  --vhook_a ctl_tx_pause_enable                  uCtlTxPauseEnable
  --vhook_af {ctl_tx_pause_quanta(.)}            {uCtlTxPauseQuanta$1}
  --vhook_af {ctl_tx_pause_refresh_timer(.)}     {uCtlTxPauseRefreshTimer$1}
  --vhook_a ctl_tx_pause_req                     uCtlTxPauseReq
  --vhook_a ctl_tx_resend_pause                  uCtlTxResendPause
  --vhook_# 1588 (RX)
  --vhook_a ctl_rx_systemtimerin         uCtlRxSystemtimerin
  --vhook_a rx_ptp_tstamp_out            uRxPtpTstampOut
  --vhook_a rx_ptp_pcslane_out           uRxPtpPcslaneOut
  --vhook_af {rx_lane_aligner_fill_(.*)} {uRxLaneAlignerFill$1}
  --vhook_# 1588 (TX)
  --vhook_a ctl_tx_systemtimerin         uCtlTxSystemtimerin
  --vhook_a tx_ptp_tstamp_valid_out      uTxPtpTstampValidOut
  --vhook_a tx_ptp_pcslane_out           uTxPtpPcslaneOut
  --vhook_a tx_ptp_tstamp_tag_out        uTxPtpTstampTagOut
  --vhook_a tx_ptp_tstamp_out            uTxPtpTstampOut
  --vhook_a tx_ptp_1588op_in             uTxPtp1588opIn
  --vhook_a tx_ptp_tag_field_in          uTxPtpTagFieldIn
  --vhook_a stat_tx_ptp_fifo_read_error  uStatTxPtpFifoReadError
  --vhook_a stat_tx_ptp_fifo_write_error uStatTxPtpFifoWriteError
  --vhook_# IP DRP
  --vhook_a drp_clk                               DrpClk
  --vhook_a drp_addr                              dDrpAddr
  --vhook_a drp_di                                dDrpDi
  --vhook_a drp_en                                dDrpEn
  --vhook_a drp_do                                dDrpDo
  --vhook_a drp_rdy                               dDrpRdy
  --vhook_a drp_we                                dDrpWe
  --vhook_# Unused OTN
  --vhook_a rx_otn_* open
  --vhook_# Unused preamble
  --vhook_a rx_preambleout open
  --vhook_a tx_preamblein  (others => '0')
  --vhook_# Unused statistic outputs
  --vhook_a stat_rx_aligned_err                   open
  --vhook_a stat_rx_bad_code                      open
  --vhook_a stat_rx_bad_fcs                       open
  --vhook_a stat_rx_bad_preamble                  open
  --vhook_a stat_rx_bad_sfd                       open
  --vhook_a stat_rx_bip_err_*                     open
  --vhook_a stat_rx_block_lock                    open
  --vhook_a stat_rx_broadcast                     open
  --vhook_a stat_rx_fragment                      open
  --vhook_a stat_rx_framing_err_valid_*           open
  --vhook_a stat_rx_framing_err_*                 open
  --vhook_a stat_rx_got_signal_os                 open
  --vhook_a stat_rx_hi_ber                        open
  --vhook_a stat_rx_inrangeerr                    open
  --vhook_a stat_rx_internal_local_fault          open
  --vhook_a stat_rx_jabber                        open
  --vhook_a stat_rx_local_fault                   open
  --vhook_a stat_rx_mf_err                        open
  --vhook_a stat_rx_mf_len_err                    open
  --vhook_a stat_rx_mf_repeat_err                 open
  --vhook_a stat_rx_misaligned                    open
  --vhook_a stat_rx_multicast                     open
  --vhook_a stat_rx_oversize                      open
  --vhook_a stat_rx_packet_*                      open
  --vhook_a stat_rx_received_local_fault          open
  --vhook_a stat_rx_remote_fault                  open
  --vhook_a stat_rx_status                        open
  --vhook_a stat_rx_stomped_fcs                   open
  --vhook_a stat_rx_synced                        open
  --vhook_a stat_rx_synced_err                    open
  --vhook_a stat_rx_test_pattern_mismatch         open
  --vhook_a stat_rx_toolong                       open
  --vhook_a stat_rx_total_bytes                   open
  --vhook_a stat_rx_total_good_bytes              open
  --vhook_a stat_rx_total_good_packets            open
  --vhook_a stat_rx_total_packets                 open
  --vhook_a stat_rx_truncated                     open
  --vhook_a stat_rx_undersize                     open
  --vhook_a stat_rx_unicast                       open
  --vhook_a stat_rx_vlan                          open
  --vhook_a stat_rx_pcsl_demuxed                  open
  --vhook_a stat_rx_pcsl_number_*                 open
  --vhook_a stat_rx_pause                         open
  --vhook_a stat_rx_user_pause                    open
  --vhook_a stat_tx_bad_fcs                       open
  --vhook_a stat_tx_broadcast                     open
  --vhook_a stat_tx_frame_error                   open
  --vhook_a stat_tx_local_fault                   open
  --vhook_a stat_tx_multicast                     open
  --vhook_a stat_tx_packet_*                      open
  --vhook_a stat_tx_total_bytes                   open
  --vhook_a stat_tx_total_good_bytes              open
  --vhook_a stat_tx_total_good_packets            open
  --vhook_a stat_tx_total_packets                 open
  --vhook_a stat_tx_unicast                       open
  --vhook_a stat_tx_vlan                          open
  --vhook_a stat_tx_pause                         open
  --vhook_a stat_tx_user_pause                    open
  --vhook_# Unused DRP
  --vhook_a gt_drpclk                           '0'
  --vhook_a *_drpdo                             open
  --vhook_a *_drprdy                            open
  --vhook_a *_drpen                             '0'
  --vhook_a *_drpwe                             '0'
  --vhook_a *_drpaddr                           (others => '0')
  --vhook_a *_drpdi                             (others => '0')
  --vhook_# Unused GT control
  --vhook_a gt_eyescanreset                       (others => '0')
  --vhook_a gt_eyescantrigger                     (others => '0')
  --vhook_a gt_rxcdrhold                          (others => '0')
  --vhook_a gt_rxrate                             (others => '0')
  --vhook_a gt_txinhibit                          (others => '0')
  --vhook_a gt_txpippmen                          (others => '0')
  --vhook_a gt_txpippmsel                         (others => '1')
  --vhook_a gt_txprbsforceerr                     (others => '0')
  --vhook_a gt_eyescandataerror                   open
  --vhook_a gt_txbufstatus                        open
  --vhook_a gt_rxdfelpmreset                      (others => '0')
  --vhook_a gt_rxlpmen                            (others => '1')
  --vhook_a gt_rxprbscntreset                     (others => '0')
  --vhook_a gt_rxprbserr                          open
  --vhook_a gt_rxprbssel                          (others => '0')
  --vhook_a gt_rxresetdone                        open
  --vhook_a gt_txprbssel                          (others => '0')
  --vhook_a gt_txresetdone                        open
  --vhook_a gt_rxbufstatus                        open
  cmac_ipx: cmac_ip
    port map (
      gt_rxp_in                             => MgtPortRx_p,                       --in  STD_LOGIC_VECTOR(3:0)
      gt_rxn_in                             => MgtPortRx_n,                       --in  STD_LOGIC_VECTOR(3:0)
      gt_txp_out                            => MgtPortTx_p,                       --out STD_LOGIC_VECTOR(3:0)
      gt_txn_out                            => MgtPortTx_n,                       --out STD_LOGIC_VECTOR(3:0)
      gt_txusrclk2                          => UserClkLcl,                        --out STD_LOGIC
      gt_loopback_in                        => aGtLoopbackIn,                     --in  STD_LOGIC_VECTOR(11:0)
      gt_rxrecclkout                        => open,                              --out STD_LOGIC_VECTOR(3:0)
      gt_powergoodout                       => aGtPowerGoodOut,                   --out STD_LOGIC_VECTOR(3:0)
      gt_ref_clk_out                        => open,                              --out STD_LOGIC
      gtwiz_reset_tx_datapath               => '0',                               --in  STD_LOGIC
      gtwiz_reset_rx_datapath               => '0',                               --in  STD_LOGIC
      gt_eyescanreset                       => (others => '0'),                   --in  STD_LOGIC_VECTOR(3:0)
      gt_eyescantrigger                     => (others => '0'),                   --in  STD_LOGIC_VECTOR(3:0)
      gt_rxcdrhold                          => (others => '0'),                   --in  STD_LOGIC_VECTOR(3:0)
      gt_rxpolarity                         => aRxPolarity,                       --in  STD_LOGIC_VECTOR(3:0)
      gt_rxrate                             => (others => '0'),                   --in  STD_LOGIC_VECTOR(11:0)
      gt_txdiffctrl                         => aTxDiffCtrl,                       --in  STD_LOGIC_VECTOR(19:0)
      gt_txpolarity                         => aTxPolarity,                       --in  STD_LOGIC_VECTOR(3:0)
      gt_txinhibit                          => (others => '0'),                   --in  STD_LOGIC_VECTOR(3:0)
      gt_txpippmen                          => (others => '0'),                   --in  STD_LOGIC_VECTOR(3:0)
      gt_txpippmsel                         => (others => '1'),                   --in  STD_LOGIC_VECTOR(3:0)
      gt_txpostcursor                       => aTxPostCursor,                     --in  STD_LOGIC_VECTOR(19:0)
      gt_txprbsforceerr                     => (others => '0'),                   --in  STD_LOGIC_VECTOR(3:0)
      gt_txprecursor                        => aTxPreCursor,                      --in  STD_LOGIC_VECTOR(19:0)
      gt_eyescandataerror                   => open,                              --out STD_LOGIC_VECTOR(3:0)
      gt_txbufstatus                        => open,                              --out STD_LOGIC_VECTOR(7:0)
      gt_rxdfelpmreset                      => (others => '0'),                   --in  STD_LOGIC_VECTOR(3:0)
      gt_rxlpmen                            => (others => '1'),                   --in  STD_LOGIC_VECTOR(3:0)
      gt_rxprbscntreset                     => (others => '0'),                   --in  STD_LOGIC_VECTOR(3:0)
      gt_rxprbserr                          => open,                              --out STD_LOGIC_VECTOR(3:0)
      gt_rxprbssel                          => (others => '0'),                   --in  STD_LOGIC_VECTOR(15:0)
      gt_rxresetdone                        => open,                              --out STD_LOGIC_VECTOR(3:0)
      gt_txprbssel                          => (others => '0'),                   --in  STD_LOGIC_VECTOR(15:0)
      gt_txresetdone                        => open,                              --out STD_LOGIC_VECTOR(3:0)
      gt_rxbufstatus                        => open,                              --out STD_LOGIC_VECTOR(11:0)
      gt_drpclk                             => '0',                               --in  STD_LOGIC
      gt0_drpdo                             => open,                              --out STD_LOGIC_VECTOR(15:0)
      gt0_drprdy                            => open,                              --out STD_LOGIC
      gt0_drpen                             => '0',                               --in  STD_LOGIC
      gt0_drpwe                             => '0',                               --in  STD_LOGIC
      gt0_drpaddr                           => (others => '0'),                   --in  STD_LOGIC_VECTOR(9:0)
      gt0_drpdi                             => (others => '0'),                   --in  STD_LOGIC_VECTOR(15:0)
      gt1_drpdo                             => open,                              --out STD_LOGIC_VECTOR(15:0)
      gt1_drprdy                            => open,                              --out STD_LOGIC
      gt1_drpen                             => '0',                               --in  STD_LOGIC
      gt1_drpwe                             => '0',                               --in  STD_LOGIC
      gt1_drpaddr                           => (others => '0'),                   --in  STD_LOGIC_VECTOR(9:0)
      gt1_drpdi                             => (others => '0'),                   --in  STD_LOGIC_VECTOR(15:0)
      gt2_drpdo                             => open,                              --out STD_LOGIC_VECTOR(15:0)
      gt2_drprdy                            => open,                              --out STD_LOGIC
      gt2_drpen                             => '0',                               --in  STD_LOGIC
      gt2_drpwe                             => '0',                               --in  STD_LOGIC
      gt2_drpaddr                           => (others => '0'),                   --in  STD_LOGIC_VECTOR(9:0)
      gt2_drpdi                             => (others => '0'),                   --in  STD_LOGIC_VECTOR(15:0)
      gt3_drpdo                             => open,                              --out STD_LOGIC_VECTOR(15:0)
      gt3_drprdy                            => open,                              --out STD_LOGIC
      gt3_drpen                             => '0',                               --in  STD_LOGIC
      gt3_drpwe                             => '0',                               --in  STD_LOGIC
      gt3_drpaddr                           => (others => '0'),                   --in  STD_LOGIC_VECTOR(9:0)
      gt3_drpdi                             => (others => '0'),                   --in  STD_LOGIC_VECTOR(15:0)
      sys_reset                             => aResetSl,                          --in  STD_LOGIC
      gt_ref_clk_p                          => MgtRefClk_p,                       --in  STD_LOGIC
      gt_ref_clk_n                          => MgtRefClk_n,                       --in  STD_LOGIC
      init_clk                              => SysClk,                            --in  STD_LOGIC
      common0_drpaddr                       => (others => '0'),                   --in  STD_LOGIC_VECTOR(15:0)
      common0_drpdi                         => (others => '0'),                   --in  STD_LOGIC_VECTOR(15:0)
      common0_drpwe                         => '0',                               --in  STD_LOGIC
      common0_drpen                         => '0',                               --in  STD_LOGIC
      common0_drprdy                        => open,                              --out STD_LOGIC
      common0_drpdo                         => open,                              --out STD_LOGIC_VECTOR(15:0)
      rx_axis_tvalid                        => uRxTValid,                         --out STD_LOGIC
      rx_axis_tdata(64*1-1 downto 64*(1-1)) => uRxTData0,                         --out STD_LOGIC_VECTOR(511:0)
      rx_axis_tdata(64*2-1 downto 64*(2-1)) => uRxTData1,                         --out STD_LOGIC_VECTOR(511:0)
      rx_axis_tdata(64*3-1 downto 64*(3-1)) => uRxTData2,                         --out STD_LOGIC_VECTOR(511:0)
      rx_axis_tdata(64*4-1 downto 64*(4-1)) => uRxTData3,                         --out STD_LOGIC_VECTOR(511:0)
      rx_axis_tdata(64*5-1 downto 64*(5-1)) => uRxTData4,                         --out STD_LOGIC_VECTOR(511:0)
      rx_axis_tdata(64*6-1 downto 64*(6-1)) => uRxTData5,                         --out STD_LOGIC_VECTOR(511:0)
      rx_axis_tdata(64*7-1 downto 64*(7-1)) => uRxTData6,                         --out STD_LOGIC_VECTOR(511:0)
      rx_axis_tdata(64*8-1 downto 64*(8-1)) => uRxTData7,                         --out STD_LOGIC_VECTOR(511:0)
      rx_axis_tlast                         => uRxTLast,                          --out STD_LOGIC
      rx_axis_tkeep                         => uRxTKeep,                          --out STD_LOGIC_VECTOR(63:0)
      rx_axis_tuser                         => uRxTUser,                          --out STD_LOGIC
      rx_otn_bip8_0                         => open,                              --out STD_LOGIC_VECTOR(7:0)
      rx_otn_bip8_1                         => open,                              --out STD_LOGIC_VECTOR(7:0)
      rx_otn_bip8_2                         => open,                              --out STD_LOGIC_VECTOR(7:0)
      rx_otn_bip8_3                         => open,                              --out STD_LOGIC_VECTOR(7:0)
      rx_otn_bip8_4                         => open,                              --out STD_LOGIC_VECTOR(7:0)
      rx_otn_data_0                         => open,                              --out STD_LOGIC_VECTOR(65:0)
      rx_otn_data_1                         => open,                              --out STD_LOGIC_VECTOR(65:0)
      rx_otn_data_2                         => open,                              --out STD_LOGIC_VECTOR(65:0)
      rx_otn_data_3                         => open,                              --out STD_LOGIC_VECTOR(65:0)
      rx_otn_data_4                         => open,                              --out STD_LOGIC_VECTOR(65:0)
      rx_otn_ena                            => open,                              --out STD_LOGIC
      rx_otn_lane0                          => open,                              --out STD_LOGIC
      rx_otn_vlmarker                       => open,                              --out STD_LOGIC
      rx_preambleout                        => open,                              --out STD_LOGIC_VECTOR(55:0)
      usr_rx_reset                          => uUsrRxReset,                       --out STD_LOGIC
      gt_rxusrclk2                          => open,                              --out STD_LOGIC
      rx_lane_aligner_fill_0                => uRxLaneAlignerFill0,               --out STD_LOGIC_VECTOR(6:0)
      rx_lane_aligner_fill_1                => uRxLaneAlignerFill1,               --out STD_LOGIC_VECTOR(6:0)
      rx_lane_aligner_fill_10               => uRxLaneAlignerFill10,              --out STD_LOGIC_VECTOR(6:0)
      rx_lane_aligner_fill_11               => uRxLaneAlignerFill11,              --out STD_LOGIC_VECTOR(6:0)
      rx_lane_aligner_fill_12               => uRxLaneAlignerFill12,              --out STD_LOGIC_VECTOR(6:0)
      rx_lane_aligner_fill_13               => uRxLaneAlignerFill13,              --out STD_LOGIC_VECTOR(6:0)
      rx_lane_aligner_fill_14               => uRxLaneAlignerFill14,              --out STD_LOGIC_VECTOR(6:0)
      rx_lane_aligner_fill_15               => uRxLaneAlignerFill15,              --out STD_LOGIC_VECTOR(6:0)
      rx_lane_aligner_fill_16               => uRxLaneAlignerFill16,              --out STD_LOGIC_VECTOR(6:0)
      rx_lane_aligner_fill_17               => uRxLaneAlignerFill17,              --out STD_LOGIC_VECTOR(6:0)
      rx_lane_aligner_fill_18               => uRxLaneAlignerFill18,              --out STD_LOGIC_VECTOR(6:0)
      rx_lane_aligner_fill_19               => uRxLaneAlignerFill19,              --out STD_LOGIC_VECTOR(6:0)
      rx_lane_aligner_fill_2                => uRxLaneAlignerFill2,               --out STD_LOGIC_VECTOR(6:0)
      rx_lane_aligner_fill_3                => uRxLaneAlignerFill3,               --out STD_LOGIC_VECTOR(6:0)
      rx_lane_aligner_fill_4                => uRxLaneAlignerFill4,               --out STD_LOGIC_VECTOR(6:0)
      rx_lane_aligner_fill_5                => uRxLaneAlignerFill5,               --out STD_LOGIC_VECTOR(6:0)
      rx_lane_aligner_fill_6                => uRxLaneAlignerFill6,               --out STD_LOGIC_VECTOR(6:0)
      rx_lane_aligner_fill_7                => uRxLaneAlignerFill7,               --out STD_LOGIC_VECTOR(6:0)
      rx_lane_aligner_fill_8                => uRxLaneAlignerFill8,               --out STD_LOGIC_VECTOR(6:0)
      rx_lane_aligner_fill_9                => uRxLaneAlignerFill9,               --out STD_LOGIC_VECTOR(6:0)
      rx_ptp_tstamp_out                     => uRxPtpTstampOut,                   --out STD_LOGIC_VECTOR(79:0)
      rx_ptp_pcslane_out                    => uRxPtpPcslaneOut,                  --out STD_LOGIC_VECTOR(4:0)
      ctl_rx_systemtimerin                  => uCtlRxSystemtimerin,               --in  STD_LOGIC_VECTOR(79:0)
      stat_rx_aligned                       => uStatRxAligned,                    --out STD_LOGIC
      stat_rx_aligned_err                   => open,                              --out STD_LOGIC
      stat_rx_bad_code                      => open,                              --out STD_LOGIC_VECTOR(2:0)
      stat_rx_bad_fcs                       => open,                              --out STD_LOGIC_VECTOR(2:0)
      stat_rx_bad_preamble                  => open,                              --out STD_LOGIC
      stat_rx_bad_sfd                       => open,                              --out STD_LOGIC
      stat_rx_bip_err_0                     => open,                              --out STD_LOGIC
      stat_rx_bip_err_1                     => open,                              --out STD_LOGIC
      stat_rx_bip_err_10                    => open,                              --out STD_LOGIC
      stat_rx_bip_err_11                    => open,                              --out STD_LOGIC
      stat_rx_bip_err_12                    => open,                              --out STD_LOGIC
      stat_rx_bip_err_13                    => open,                              --out STD_LOGIC
      stat_rx_bip_err_14                    => open,                              --out STD_LOGIC
      stat_rx_bip_err_15                    => open,                              --out STD_LOGIC
      stat_rx_bip_err_16                    => open,                              --out STD_LOGIC
      stat_rx_bip_err_17                    => open,                              --out STD_LOGIC
      stat_rx_bip_err_18                    => open,                              --out STD_LOGIC
      stat_rx_bip_err_19                    => open,                              --out STD_LOGIC
      stat_rx_bip_err_2                     => open,                              --out STD_LOGIC
      stat_rx_bip_err_3                     => open,                              --out STD_LOGIC
      stat_rx_bip_err_4                     => open,                              --out STD_LOGIC
      stat_rx_bip_err_5                     => open,                              --out STD_LOGIC
      stat_rx_bip_err_6                     => open,                              --out STD_LOGIC
      stat_rx_bip_err_7                     => open,                              --out STD_LOGIC
      stat_rx_bip_err_8                     => open,                              --out STD_LOGIC
      stat_rx_bip_err_9                     => open,                              --out STD_LOGIC
      stat_rx_block_lock                    => open,                              --out STD_LOGIC_VECTOR(19:0)
      stat_rx_broadcast                     => open,                              --out STD_LOGIC
      stat_rx_fragment                      => open,                              --out STD_LOGIC_VECTOR(2:0)
      stat_rx_framing_err_0                 => open,                              --out STD_LOGIC_VECTOR(1:0)
      stat_rx_framing_err_1                 => open,                              --out STD_LOGIC_VECTOR(1:0)
      stat_rx_framing_err_10                => open,                              --out STD_LOGIC_VECTOR(1:0)
      stat_rx_framing_err_11                => open,                              --out STD_LOGIC_VECTOR(1:0)
      stat_rx_framing_err_12                => open,                              --out STD_LOGIC_VECTOR(1:0)
      stat_rx_framing_err_13                => open,                              --out STD_LOGIC_VECTOR(1:0)
      stat_rx_framing_err_14                => open,                              --out STD_LOGIC_VECTOR(1:0)
      stat_rx_framing_err_15                => open,                              --out STD_LOGIC_VECTOR(1:0)
      stat_rx_framing_err_16                => open,                              --out STD_LOGIC_VECTOR(1:0)
      stat_rx_framing_err_17                => open,                              --out STD_LOGIC_VECTOR(1:0)
      stat_rx_framing_err_18                => open,                              --out STD_LOGIC_VECTOR(1:0)
      stat_rx_framing_err_19                => open,                              --out STD_LOGIC_VECTOR(1:0)
      stat_rx_framing_err_2                 => open,                              --out STD_LOGIC_VECTOR(1:0)
      stat_rx_framing_err_3                 => open,                              --out STD_LOGIC_VECTOR(1:0)
      stat_rx_framing_err_4                 => open,                              --out STD_LOGIC_VECTOR(1:0)
      stat_rx_framing_err_5                 => open,                              --out STD_LOGIC_VECTOR(1:0)
      stat_rx_framing_err_6                 => open,                              --out STD_LOGIC_VECTOR(1:0)
      stat_rx_framing_err_7                 => open,                              --out STD_LOGIC_VECTOR(1:0)
      stat_rx_framing_err_8                 => open,                              --out STD_LOGIC_VECTOR(1:0)
      stat_rx_framing_err_9                 => open,                              --out STD_LOGIC_VECTOR(1:0)
      stat_rx_framing_err_valid_0           => open,                              --out STD_LOGIC
      stat_rx_framing_err_valid_1           => open,                              --out STD_LOGIC
      stat_rx_framing_err_valid_10          => open,                              --out STD_LOGIC
      stat_rx_framing_err_valid_11          => open,                              --out STD_LOGIC
      stat_rx_framing_err_valid_12          => open,                              --out STD_LOGIC
      stat_rx_framing_err_valid_13          => open,                              --out STD_LOGIC
      stat_rx_framing_err_valid_14          => open,                              --out STD_LOGIC
      stat_rx_framing_err_valid_15          => open,                              --out STD_LOGIC
      stat_rx_framing_err_valid_16          => open,                              --out STD_LOGIC
      stat_rx_framing_err_valid_17          => open,                              --out STD_LOGIC
      stat_rx_framing_err_valid_18          => open,                              --out STD_LOGIC
      stat_rx_framing_err_valid_19          => open,                              --out STD_LOGIC
      stat_rx_framing_err_valid_2           => open,                              --out STD_LOGIC
      stat_rx_framing_err_valid_3           => open,                              --out STD_LOGIC
      stat_rx_framing_err_valid_4           => open,                              --out STD_LOGIC
      stat_rx_framing_err_valid_5           => open,                              --out STD_LOGIC
      stat_rx_framing_err_valid_6           => open,                              --out STD_LOGIC
      stat_rx_framing_err_valid_7           => open,                              --out STD_LOGIC
      stat_rx_framing_err_valid_8           => open,                              --out STD_LOGIC
      stat_rx_framing_err_valid_9           => open,                              --out STD_LOGIC
      stat_rx_got_signal_os                 => open,                              --out STD_LOGIC
      stat_rx_hi_ber                        => open,                              --out STD_LOGIC
      stat_rx_inrangeerr                    => open,                              --out STD_LOGIC
      stat_rx_internal_local_fault          => open,                              --out STD_LOGIC
      stat_rx_jabber                        => open,                              --out STD_LOGIC
      stat_rx_local_fault                   => open,                              --out STD_LOGIC
      stat_rx_mf_err                        => open,                              --out STD_LOGIC_VECTOR(19:0)
      stat_rx_mf_len_err                    => open,                              --out STD_LOGIC_VECTOR(19:0)
      stat_rx_mf_repeat_err                 => open,                              --out STD_LOGIC_VECTOR(19:0)
      stat_rx_misaligned                    => open,                              --out STD_LOGIC
      stat_rx_multicast                     => open,                              --out STD_LOGIC
      stat_rx_oversize                      => open,                              --out STD_LOGIC
      stat_rx_packet_1024_1518_bytes        => open,                              --out STD_LOGIC
      stat_rx_packet_128_255_bytes          => open,                              --out STD_LOGIC
      stat_rx_packet_1519_1522_bytes        => open,                              --out STD_LOGIC
      stat_rx_packet_1523_1548_bytes        => open,                              --out STD_LOGIC
      stat_rx_packet_1549_2047_bytes        => open,                              --out STD_LOGIC
      stat_rx_packet_2048_4095_bytes        => open,                              --out STD_LOGIC
      stat_rx_packet_256_511_bytes          => open,                              --out STD_LOGIC
      stat_rx_packet_4096_8191_bytes        => open,                              --out STD_LOGIC
      stat_rx_packet_512_1023_bytes         => open,                              --out STD_LOGIC
      stat_rx_packet_64_bytes               => open,                              --out STD_LOGIC
      stat_rx_packet_65_127_bytes           => open,                              --out STD_LOGIC
      stat_rx_packet_8192_9215_bytes        => open,                              --out STD_LOGIC
      stat_rx_packet_bad_fcs                => open,                              --out STD_LOGIC
      stat_rx_packet_large                  => open,                              --out STD_LOGIC
      stat_rx_packet_small                  => open,                              --out STD_LOGIC_VECTOR(2:0)
      stat_rx_pause                         => open,                              --out STD_LOGIC
      stat_rx_pause_quanta0                 => uStatRxPauseQanta0,                --out STD_LOGIC_VECTOR(15:0)
      stat_rx_pause_quanta1                 => uStatRxPauseQanta1,                --out STD_LOGIC_VECTOR(15:0)
      stat_rx_pause_quanta2                 => uStatRxPauseQanta2,                --out STD_LOGIC_VECTOR(15:0)
      stat_rx_pause_quanta3                 => uStatRxPauseQanta3,                --out STD_LOGIC_VECTOR(15:0)
      stat_rx_pause_quanta4                 => uStatRxPauseQanta4,                --out STD_LOGIC_VECTOR(15:0)
      stat_rx_pause_quanta5                 => uStatRxPauseQanta5,                --out STD_LOGIC_VECTOR(15:0)
      stat_rx_pause_quanta6                 => uStatRxPauseQanta6,                --out STD_LOGIC_VECTOR(15:0)
      stat_rx_pause_quanta7                 => uStatRxPauseQanta7,                --out STD_LOGIC_VECTOR(15:0)
      stat_rx_pause_quanta8                 => uStatRxPauseQanta8,                --out STD_LOGIC_VECTOR(15:0)
      stat_rx_pause_req                     => uStatRxPauseReq,                   --out STD_LOGIC_VECTOR(8:0)
      stat_rx_pause_valid                   => uStatRxPauseValid,                 --out STD_LOGIC_VECTOR(8:0)
      stat_rx_user_pause                    => open,                              --out STD_LOGIC
      ctl_rx_check_etype_gcp                => uCtlRxCheckEtypeGcp,               --in  STD_LOGIC
      ctl_rx_check_etype_gpp                => uCtlRxCheckEtypeGpp,               --in  STD_LOGIC
      ctl_rx_check_etype_pcp                => uCtlRxCheckEtypePcp,               --in  STD_LOGIC
      ctl_rx_check_etype_ppp                => uCtlRxCheckEtypePpp,               --in  STD_LOGIC
      ctl_rx_check_mcast_gcp                => uCtlRxCheckMcastGcp,               --in  STD_LOGIC
      ctl_rx_check_mcast_gpp                => uCtlRxCheckMcastGpp,               --in  STD_LOGIC
      ctl_rx_check_mcast_pcp                => uCtlRxCheckMcastPcp,               --in  STD_LOGIC
      ctl_rx_check_mcast_ppp                => uCtlRxCheckMcastPpp,               --in  STD_LOGIC
      ctl_rx_check_opcode_gcp               => uCtlRxCheckOpcodeGcp,              --in  STD_LOGIC
      ctl_rx_check_opcode_gpp               => uCtlRxCheckOpcodeGpp,              --in  STD_LOGIC
      ctl_rx_check_opcode_pcp               => uCtlRxCheckOpcodePcp,              --in  STD_LOGIC
      ctl_rx_check_opcode_ppp               => uCtlRxCheckOpcodePpp,              --in  STD_LOGIC
      ctl_rx_check_sa_gcp                   => uCtlRxCheckSaGcp,                  --in  STD_LOGIC
      ctl_rx_check_sa_gpp                   => uCtlRxCheckSaGpp,                  --in  STD_LOGIC
      ctl_rx_check_sa_pcp                   => uCtlRxCheckSaPcp,                  --in  STD_LOGIC
      ctl_rx_check_sa_ppp                   => uCtlRxCheckSaPpp,                  --in  STD_LOGIC
      ctl_rx_check_ucast_gcp                => uCtlRxCheckUcastGcp,               --in  STD_LOGIC
      ctl_rx_check_ucast_gpp                => uCtlRxCheckUcastGpp,               --in  STD_LOGIC
      ctl_rx_check_ucast_pcp                => uCtlRxCheckUcastPcp,               --in  STD_LOGIC
      ctl_rx_check_ucast_ppp                => uCtlRxCheckUcastPpp,               --in  STD_LOGIC
      ctl_rx_enable_gcp                     => uCtlRxEnableGcp,                   --in  STD_LOGIC
      ctl_rx_enable_gpp                     => uCtlRxEnableGpp,                   --in  STD_LOGIC
      ctl_rx_enable_pcp                     => uCtlRxEnablePcp,                   --in  STD_LOGIC
      ctl_rx_enable_ppp                     => uCtlRxEnablePpp,                   --in  STD_LOGIC
      ctl_rx_pause_ack                      => uCtlRxPauseAck,                    --in  STD_LOGIC_VECTOR(8:0)
      ctl_rx_pause_enable                   => uCtlRxPauseEnable,                 --in  STD_LOGIC_VECTOR(8:0)
      ctl_rx_enable                         => uCtlRxEnable,                      --in  STD_LOGIC
      ctl_rx_force_resync                   => aCtlRxForceResync,                 --in  STD_LOGIC
      ctl_rx_test_pattern                   => uCtlRxTestPattern,                 --in  STD_LOGIC
      ctl_rsfec_ieee_error_indication_mode  => uCtlRsfecIeeeErrorIndicationMode,  --in  STD_LOGIC
      ctl_rx_rsfec_enable                   => uCtlRxRsfecEnable,                 --in  STD_LOGIC
      ctl_rx_rsfec_enable_correction        => uCtlRxRsfecEnableCorrection,       --in  STD_LOGIC
      ctl_rx_rsfec_enable_indication        => uCtlRxRsfecEnableIndication,       --in  STD_LOGIC
      core_rx_reset                         => aResetSl,                          --in  STD_LOGIC
      rx_clk                                => UserClkLcl,                        --in  STD_LOGIC
      stat_rx_received_local_fault          => open,                              --out STD_LOGIC
      stat_rx_remote_fault                  => open,                              --out STD_LOGIC
      stat_rx_status                        => open,                              --out STD_LOGIC
      stat_rx_stomped_fcs                   => open,                              --out STD_LOGIC_VECTOR(2:0)
      stat_rx_synced                        => open,                              --out STD_LOGIC_VECTOR(19:0)
      stat_rx_synced_err                    => open,                              --out STD_LOGIC_VECTOR(19:0)
      stat_rx_test_pattern_mismatch         => open,                              --out STD_LOGIC_VECTOR(2:0)
      stat_rx_toolong                       => open,                              --out STD_LOGIC
      stat_rx_total_bytes                   => open,                              --out STD_LOGIC_VECTOR(6:0)
      stat_rx_total_good_bytes              => open,                              --out STD_LOGIC_VECTOR(13:0)
      stat_rx_total_good_packets            => open,                              --out STD_LOGIC
      stat_rx_total_packets                 => open,                              --out STD_LOGIC_VECTOR(2:0)
      stat_rx_truncated                     => open,                              --out STD_LOGIC
      stat_rx_undersize                     => open,                              --out STD_LOGIC_VECTOR(2:0)
      stat_rx_unicast                       => open,                              --out STD_LOGIC
      stat_rx_vlan                          => open,                              --out STD_LOGIC
      stat_rx_pcsl_demuxed                  => open,                              --out STD_LOGIC_VECTOR(19:0)
      stat_rx_pcsl_number_0                 => open,                              --out STD_LOGIC_VECTOR(4:0)
      stat_rx_pcsl_number_1                 => open,                              --out STD_LOGIC_VECTOR(4:0)
      stat_rx_pcsl_number_10                => open,                              --out STD_LOGIC_VECTOR(4:0)
      stat_rx_pcsl_number_11                => open,                              --out STD_LOGIC_VECTOR(4:0)
      stat_rx_pcsl_number_12                => open,                              --out STD_LOGIC_VECTOR(4:0)
      stat_rx_pcsl_number_13                => open,                              --out STD_LOGIC_VECTOR(4:0)
      stat_rx_pcsl_number_14                => open,                              --out STD_LOGIC_VECTOR(4:0)
      stat_rx_pcsl_number_15                => open,                              --out STD_LOGIC_VECTOR(4:0)
      stat_rx_pcsl_number_16                => open,                              --out STD_LOGIC_VECTOR(4:0)
      stat_rx_pcsl_number_17                => open,                              --out STD_LOGIC_VECTOR(4:0)
      stat_rx_pcsl_number_18                => open,                              --out STD_LOGIC_VECTOR(4:0)
      stat_rx_pcsl_number_19                => open,                              --out STD_LOGIC_VECTOR(4:0)
      stat_rx_pcsl_number_2                 => open,                              --out STD_LOGIC_VECTOR(4:0)
      stat_rx_pcsl_number_3                 => open,                              --out STD_LOGIC_VECTOR(4:0)
      stat_rx_pcsl_number_4                 => open,                              --out STD_LOGIC_VECTOR(4:0)
      stat_rx_pcsl_number_5                 => open,                              --out STD_LOGIC_VECTOR(4:0)
      stat_rx_pcsl_number_6                 => open,                              --out STD_LOGIC_VECTOR(4:0)
      stat_rx_pcsl_number_7                 => open,                              --out STD_LOGIC_VECTOR(4:0)
      stat_rx_pcsl_number_8                 => open,                              --out STD_LOGIC_VECTOR(4:0)
      stat_rx_pcsl_number_9                 => open,                              --out STD_LOGIC_VECTOR(4:0)
      stat_rx_rsfec_am_lock0                => uStatRxRsfecAmLock0,               --out STD_LOGIC
      stat_rx_rsfec_am_lock1                => uStatRxRsfecAmLock1,               --out STD_LOGIC
      stat_rx_rsfec_am_lock2                => uStatRxRsfecAmLock2,               --out STD_LOGIC
      stat_rx_rsfec_am_lock3                => uStatRxRsfecAmLock3,               --out STD_LOGIC
      stat_rx_rsfec_corrected_cw_inc        => uStatRxRsfecCorrectedCwInc,        --out STD_LOGIC
      stat_rx_rsfec_cw_inc                  => uStatRxRsfecCwInc,                 --out STD_LOGIC
      stat_rx_rsfec_err_count0_inc          => uStatRxRsfecErrCount0Inc,          --out STD_LOGIC_VECTOR(2:0)
      stat_rx_rsfec_err_count1_inc          => uStatRxRsfecErrCount1Inc,          --out STD_LOGIC_VECTOR(2:0)
      stat_rx_rsfec_err_count2_inc          => uStatRxRsfecErrCount2Inc,          --out STD_LOGIC_VECTOR(2:0)
      stat_rx_rsfec_err_count3_inc          => uStatRxRsfecErrCount3Inc,          --out STD_LOGIC_VECTOR(2:0)
      stat_rx_rsfec_hi_ser                  => uStatRxRsfecHiSer,                 --out STD_LOGIC
      stat_rx_rsfec_lane_alignment_status   => uStatRxRsfecLaneAlignmentStatus,   --out STD_LOGIC
      stat_rx_rsfec_lane_fill_0             => uStatRxRsfecLaneFill0,             --out STD_LOGIC_VECTOR(13:0)
      stat_rx_rsfec_lane_fill_1             => uStatRxRsfecLaneFill1,             --out STD_LOGIC_VECTOR(13:0)
      stat_rx_rsfec_lane_fill_2             => uStatRxRsfecLaneFill2,             --out STD_LOGIC_VECTOR(13:0)
      stat_rx_rsfec_lane_fill_3             => uStatRxRsfecLaneFill3,             --out STD_LOGIC_VECTOR(13:0)
      stat_rx_rsfec_lane_mapping            => uStatRxRsfecLaneMapping,           --out STD_LOGIC_VECTOR(7:0)
      stat_rx_rsfec_uncorrected_cw_inc      => uStatRxRsfecUncorrectedCwInc,      --out STD_LOGIC
      ctl_tx_systemtimerin                  => uCtlTxSystemtimerin,               --in  STD_LOGIC_VECTOR(79:0)
      stat_tx_ptp_fifo_read_error           => uStatTxPtpFifoReadError,           --out STD_LOGIC
      stat_tx_ptp_fifo_write_error          => uStatTxPtpFifoWriteError,          --out STD_LOGIC
      tx_ptp_tstamp_valid_out               => uTxPtpTstampValidOut,              --out STD_LOGIC
      tx_ptp_pcslane_out                    => uTxPtpPcslaneOut,                  --out STD_LOGIC_VECTOR(4:0)
      tx_ptp_tstamp_tag_out                 => uTxPtpTstampTagOut,                --out STD_LOGIC_VECTOR(15:0)
      tx_ptp_tstamp_out                     => uTxPtpTstampOut,                   --out STD_LOGIC_VECTOR(79:0)
      tx_ptp_1588op_in                      => uTxPtp1588opIn,                    --in  STD_LOGIC_VECTOR(1:0)
      tx_ptp_tag_field_in                   => uTxPtpTagFieldIn,                  --in  STD_LOGIC_VECTOR(15:0)
      stat_tx_bad_fcs                       => open,                              --out STD_LOGIC
      stat_tx_broadcast                     => open,                              --out STD_LOGIC
      stat_tx_frame_error                   => open,                              --out STD_LOGIC
      stat_tx_local_fault                   => open,                              --out STD_LOGIC
      stat_tx_multicast                     => open,                              --out STD_LOGIC
      stat_tx_packet_1024_1518_bytes        => open,                              --out STD_LOGIC
      stat_tx_packet_128_255_bytes          => open,                              --out STD_LOGIC
      stat_tx_packet_1519_1522_bytes        => open,                              --out STD_LOGIC
      stat_tx_packet_1523_1548_bytes        => open,                              --out STD_LOGIC
      stat_tx_packet_1549_2047_bytes        => open,                              --out STD_LOGIC
      stat_tx_packet_2048_4095_bytes        => open,                              --out STD_LOGIC
      stat_tx_packet_256_511_bytes          => open,                              --out STD_LOGIC
      stat_tx_packet_4096_8191_bytes        => open,                              --out STD_LOGIC
      stat_tx_packet_512_1023_bytes         => open,                              --out STD_LOGIC
      stat_tx_packet_64_bytes               => open,                              --out STD_LOGIC
      stat_tx_packet_65_127_bytes           => open,                              --out STD_LOGIC
      stat_tx_packet_8192_9215_bytes        => open,                              --out STD_LOGIC
      stat_tx_packet_large                  => open,                              --out STD_LOGIC
      stat_tx_packet_small                  => open,                              --out STD_LOGIC
      stat_tx_total_bytes                   => open,                              --out STD_LOGIC_VECTOR(5:0)
      stat_tx_total_good_bytes              => open,                              --out STD_LOGIC_VECTOR(13:0)
      stat_tx_total_good_packets            => open,                              --out STD_LOGIC
      stat_tx_total_packets                 => open,                              --out STD_LOGIC
      stat_tx_unicast                       => open,                              --out STD_LOGIC
      stat_tx_vlan                          => open,                              --out STD_LOGIC
      ctl_tx_enable                         => uCtlTxEnable,                      --in  STD_LOGIC
      ctl_tx_test_pattern                   => uCtlTxTestPattern,                 --in  STD_LOGIC
      ctl_tx_rsfec_enable                   => uCtlTxRsfecEnable,                 --in  STD_LOGIC
      ctl_tx_send_idle                      => uCtlTxSendIdle,                    --in  STD_LOGIC
      ctl_tx_send_rfi                       => uCtlTxSendRfi,                     --in  STD_LOGIC
      ctl_tx_send_lfi                       => uCtlTxSendLfi,                     --in  STD_LOGIC
      core_tx_reset                         => aResetSl,                          --in  STD_LOGIC
      stat_tx_pause_valid                   => uStatTxPauseValid,                 --out STD_LOGIC_VECTOR(8:0)
      stat_tx_pause                         => open,                              --out STD_LOGIC
      stat_tx_user_pause                    => open,                              --out STD_LOGIC
      ctl_tx_pause_enable                   => uCtlTxPauseEnable,                 --in  STD_LOGIC_VECTOR(8:0)
      ctl_tx_pause_quanta0                  => uCtlTxPauseQuanta0,                --in  STD_LOGIC_VECTOR(15:0)
      ctl_tx_pause_quanta1                  => uCtlTxPauseQuanta1,                --in  STD_LOGIC_VECTOR(15:0)
      ctl_tx_pause_quanta2                  => uCtlTxPauseQuanta2,                --in  STD_LOGIC_VECTOR(15:0)
      ctl_tx_pause_quanta3                  => uCtlTxPauseQuanta3,                --in  STD_LOGIC_VECTOR(15:0)
      ctl_tx_pause_quanta4                  => uCtlTxPauseQuanta4,                --in  STD_LOGIC_VECTOR(15:0)
      ctl_tx_pause_quanta5                  => uCtlTxPauseQuanta5,                --in  STD_LOGIC_VECTOR(15:0)
      ctl_tx_pause_quanta6                  => uCtlTxPauseQuanta6,                --in  STD_LOGIC_VECTOR(15:0)
      ctl_tx_pause_quanta7                  => uCtlTxPauseQuanta7,                --in  STD_LOGIC_VECTOR(15:0)
      ctl_tx_pause_quanta8                  => uCtlTxPauseQuanta8,                --in  STD_LOGIC_VECTOR(15:0)
      ctl_tx_pause_refresh_timer0           => uCtlTxPauseRefreshTimer0,          --in  STD_LOGIC_VECTOR(15:0)
      ctl_tx_pause_refresh_timer1           => uCtlTxPauseRefreshTimer1,          --in  STD_LOGIC_VECTOR(15:0)
      ctl_tx_pause_refresh_timer2           => uCtlTxPauseRefreshTimer2,          --in  STD_LOGIC_VECTOR(15:0)
      ctl_tx_pause_refresh_timer3           => uCtlTxPauseRefreshTimer3,          --in  STD_LOGIC_VECTOR(15:0)
      ctl_tx_pause_refresh_timer4           => uCtlTxPauseRefreshTimer4,          --in  STD_LOGIC_VECTOR(15:0)
      ctl_tx_pause_refresh_timer5           => uCtlTxPauseRefreshTimer5,          --in  STD_LOGIC_VECTOR(15:0)
      ctl_tx_pause_refresh_timer6           => uCtlTxPauseRefreshTimer6,          --in  STD_LOGIC_VECTOR(15:0)
      ctl_tx_pause_refresh_timer7           => uCtlTxPauseRefreshTimer7,          --in  STD_LOGIC_VECTOR(15:0)
      ctl_tx_pause_refresh_timer8           => uCtlTxPauseRefreshTimer8,          --in  STD_LOGIC_VECTOR(15:0)
      ctl_tx_pause_req                      => uCtlTxPauseReq,                    --in  STD_LOGIC_VECTOR(8:0)
      ctl_tx_resend_pause                   => uCtlTxResendPause,                 --in  STD_LOGIC
      tx_axis_tready                        => uTxTReady,                         --out STD_LOGIC
      tx_axis_tvalid                        => uTxTValid,                         --in  STD_LOGIC
      tx_axis_tdata(64*1-1 downto 64*(1-1)) => uTxTData0,                         --in  STD_LOGIC_VECTOR(511:0)
      tx_axis_tdata(64*2-1 downto 64*(2-1)) => uTxTData1,                         --in  STD_LOGIC_VECTOR(511:0)
      tx_axis_tdata(64*3-1 downto 64*(3-1)) => uTxTData2,                         --in  STD_LOGIC_VECTOR(511:0)
      tx_axis_tdata(64*4-1 downto 64*(4-1)) => uTxTData3,                         --in  STD_LOGIC_VECTOR(511:0)
      tx_axis_tdata(64*5-1 downto 64*(5-1)) => uTxTData4,                         --in  STD_LOGIC_VECTOR(511:0)
      tx_axis_tdata(64*6-1 downto 64*(6-1)) => uTxTData5,                         --in  STD_LOGIC_VECTOR(511:0)
      tx_axis_tdata(64*7-1 downto 64*(7-1)) => uTxTData6,                         --in  STD_LOGIC_VECTOR(511:0)
      tx_axis_tdata(64*8-1 downto 64*(8-1)) => uTxTData7,                         --in  STD_LOGIC_VECTOR(511:0)
      tx_axis_tlast                         => uTxTLast,                          --in  STD_LOGIC
      tx_axis_tkeep                         => uTxTKeep,                          --in  STD_LOGIC_VECTOR(63:0)
      tx_axis_tuser                         => uTxTUser,                          --in  STD_LOGIC
      tx_ovfout                             => open,                              --out STD_LOGIC
      tx_unfout                             => open,                              --out STD_LOGIC
      tx_preamblein                         => (others => '0'),                   --in  STD_LOGIC_VECTOR(55:0)
      usr_tx_reset                          => uUsrTxReset,                       --out STD_LOGIC
      core_drp_reset                        => aResetSl,                          --in  STD_LOGIC
      drp_clk                               => DrpClk,                            --in  STD_LOGIC
      drp_addr                              => dDrpAddr,                          --in  STD_LOGIC_VECTOR(9:0)
      drp_di                                => dDrpDi,                            --in  STD_LOGIC_VECTOR(15:0)
      drp_en                                => dDrpEn,                            --in  STD_LOGIC
      drp_do                                => dDrpDo,                            --out STD_LOGIC_VECTOR(15:0)
      drp_rdy                               => dDrpRdy,                           --out STD_LOGIC
      drp_we                                => dDrpWe);                           --in  STD_LOGIC


  UserClk <= UserClkLcl;

end rtl;
