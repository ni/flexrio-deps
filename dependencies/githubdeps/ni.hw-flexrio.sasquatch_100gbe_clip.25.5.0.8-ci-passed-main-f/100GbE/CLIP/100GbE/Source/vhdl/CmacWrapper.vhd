-- 
-- This file was automatically processed for release on GitHub
-- All comments were removed and this header was added
-- 
-- 
-- (c) 2025 Copyright National Instruments Corporation
-- 
-- SPDX-License-Identifier: MIT
-- 
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
    
    MgtRefClk_p                                     : in  std_logic;
    MgtRefClk_n                                     : in  std_logic;
    MgtPortRx_n                                     : in  std_logic_vector(3 downto 0);
    MgtPortRx_p                                     : in  std_logic_vector(3 downto 0);
    MgtPortTx_n                                     : out std_logic_vector(3 downto 0);
    MgtPortTx_p                                     : out std_logic_vector(3 downto 0);
    
    
    aResetSl                                        : in  std_logic;
    uUsrRxReset                                     : out std_logic;
    uUsrTxReset                                     : out std_logic;
    
    SysClk                                          : in  std_logic;
    UserClk                                         : out std_logic;
    
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
    
    aRxPolarity                                     : in  std_logic_vector(3 downto 0);
    uStatRxAligned                                  : out std_logic;
    uCtlRxEnable                                    : in  std_logic;
    aCtlRxForceResync                               : in  std_logic;
    uCtlRxTestPattern                               : in  std_logic;
    
    aTxDiffCtrl                                     : in  std_logic_vector(19 downto 0);
    aTxPolarity                                     : in  std_logic_vector(3 downto 0);
    aTxPostCursor                                   : in  std_logic_vector(19 downto 0);
    aTxPreCursor                                    : in  std_logic_vector(19 downto 0);
    uCtlTxEnable                                    : in  std_logic;
    uCtlTxTestPattern                               : in  std_logic;
    uCtlTxSendIdle                                  : in  std_logic;
    uCtlTxSendLfi                                   : in  std_logic;
    uCtlTxSendRfi                                   : in  std_logic;
    
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
    
    DrpClk                                          : in  std_logic;
    dDrpAddr                                        : in  std_logic_vector(9 downto 0);
    dDrpDi                                          : in  std_logic_vector(15 downto 0);
    dDrpEn                                          : in  std_logic;
    dDrpDo                                          : out std_logic_vector(15 downto 0);
    dDrpRdy                                         : out std_logic;
    dDrpWe                                          : in  std_logic;
    
    aGtLoopbackIn                                   : in  std_logic_vector(11 downto 0);
    aGtPowerGoodOut                                 : out std_logic_vector(3 downto 0)
  );
end CmacWrapper;

architecture rtl of CmacWrapper is

  
  

  
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

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  cmac_ipx: cmac_ip
    port map (
      gt_rxp_in                             => MgtPortRx_p,                       
      gt_rxn_in                             => MgtPortRx_n,                       
      gt_txp_out                            => MgtPortTx_p,                       
      gt_txn_out                            => MgtPortTx_n,                       
      gt_txusrclk2                          => UserClkLcl,                        
      gt_loopback_in                        => aGtLoopbackIn,                     
      gt_rxrecclkout                        => open,                              
      gt_powergoodout                       => aGtPowerGoodOut,                   
      gt_ref_clk_out                        => open,                              
      gtwiz_reset_tx_datapath               => '0',                               
      gtwiz_reset_rx_datapath               => '0',                               
      gt_eyescanreset                       => (others => '0'),                   
      gt_eyescantrigger                     => (others => '0'),                   
      gt_rxcdrhold                          => (others => '0'),                   
      gt_rxpolarity                         => aRxPolarity,                       
      gt_rxrate                             => (others => '0'),                   
      gt_txdiffctrl                         => aTxDiffCtrl,                       
      gt_txpolarity                         => aTxPolarity,                       
      gt_txinhibit                          => (others => '0'),                   
      gt_txpippmen                          => (others => '0'),                   
      gt_txpippmsel                         => (others => '1'),                   
      gt_txpostcursor                       => aTxPostCursor,                     
      gt_txprbsforceerr                     => (others => '0'),                   
      gt_txprecursor                        => aTxPreCursor,                      
      gt_eyescandataerror                   => open,                              
      gt_txbufstatus                        => open,                              
      gt_rxdfelpmreset                      => (others => '0'),                   
      gt_rxlpmen                            => (others => '1'),                   
      gt_rxprbscntreset                     => (others => '0'),                   
      gt_rxprbserr                          => open,                              
      gt_rxprbssel                          => (others => '0'),                   
      gt_rxresetdone                        => open,                              
      gt_txprbssel                          => (others => '0'),                   
      gt_txresetdone                        => open,                              
      gt_rxbufstatus                        => open,                              
      gt_drpclk                             => '0',                               
      gt0_drpdo                             => open,                              
      gt0_drprdy                            => open,                              
      gt0_drpen                             => '0',                               
      gt0_drpwe                             => '0',                               
      gt0_drpaddr                           => (others => '0'),                   
      gt0_drpdi                             => (others => '0'),                   
      gt1_drpdo                             => open,                              
      gt1_drprdy                            => open,                              
      gt1_drpen                             => '0',                               
      gt1_drpwe                             => '0',                               
      gt1_drpaddr                           => (others => '0'),                   
      gt1_drpdi                             => (others => '0'),                   
      gt2_drpdo                             => open,                              
      gt2_drprdy                            => open,                              
      gt2_drpen                             => '0',                               
      gt2_drpwe                             => '0',                               
      gt2_drpaddr                           => (others => '0'),                   
      gt2_drpdi                             => (others => '0'),                   
      gt3_drpdo                             => open,                              
      gt3_drprdy                            => open,                              
      gt3_drpen                             => '0',                               
      gt3_drpwe                             => '0',                               
      gt3_drpaddr                           => (others => '0'),                   
      gt3_drpdi                             => (others => '0'),                   
      sys_reset                             => aResetSl,                          
      gt_ref_clk_p                          => MgtRefClk_p,                       
      gt_ref_clk_n                          => MgtRefClk_n,                       
      init_clk                              => SysClk,                            
      common0_drpaddr                       => (others => '0'),                   
      common0_drpdi                         => (others => '0'),                   
      common0_drpwe                         => '0',                               
      common0_drpen                         => '0',                               
      common0_drprdy                        => open,                              
      common0_drpdo                         => open,                              
      rx_axis_tvalid                        => uRxTValid,                         
      rx_axis_tdata(64*1-1 downto 64*(1-1)) => uRxTData0,                         
      rx_axis_tdata(64*2-1 downto 64*(2-1)) => uRxTData1,                         
      rx_axis_tdata(64*3-1 downto 64*(3-1)) => uRxTData2,                         
      rx_axis_tdata(64*4-1 downto 64*(4-1)) => uRxTData3,                         
      rx_axis_tdata(64*5-1 downto 64*(5-1)) => uRxTData4,                         
      rx_axis_tdata(64*6-1 downto 64*(6-1)) => uRxTData5,                         
      rx_axis_tdata(64*7-1 downto 64*(7-1)) => uRxTData6,                         
      rx_axis_tdata(64*8-1 downto 64*(8-1)) => uRxTData7,                         
      rx_axis_tlast                         => uRxTLast,                          
      rx_axis_tkeep                         => uRxTKeep,                          
      rx_axis_tuser                         => uRxTUser,                          
      rx_otn_bip8_0                         => open,                              
      rx_otn_bip8_1                         => open,                              
      rx_otn_bip8_2                         => open,                              
      rx_otn_bip8_3                         => open,                              
      rx_otn_bip8_4                         => open,                              
      rx_otn_data_0                         => open,                              
      rx_otn_data_1                         => open,                              
      rx_otn_data_2                         => open,                              
      rx_otn_data_3                         => open,                              
      rx_otn_data_4                         => open,                              
      rx_otn_ena                            => open,                              
      rx_otn_lane0                          => open,                              
      rx_otn_vlmarker                       => open,                              
      rx_preambleout                        => open,                              
      usr_rx_reset                          => uUsrRxReset,                       
      gt_rxusrclk2                          => open,                              
      rx_lane_aligner_fill_0                => uRxLaneAlignerFill0,               
      rx_lane_aligner_fill_1                => uRxLaneAlignerFill1,               
      rx_lane_aligner_fill_10               => uRxLaneAlignerFill10,              
      rx_lane_aligner_fill_11               => uRxLaneAlignerFill11,              
      rx_lane_aligner_fill_12               => uRxLaneAlignerFill12,              
      rx_lane_aligner_fill_13               => uRxLaneAlignerFill13,              
      rx_lane_aligner_fill_14               => uRxLaneAlignerFill14,              
      rx_lane_aligner_fill_15               => uRxLaneAlignerFill15,              
      rx_lane_aligner_fill_16               => uRxLaneAlignerFill16,              
      rx_lane_aligner_fill_17               => uRxLaneAlignerFill17,              
      rx_lane_aligner_fill_18               => uRxLaneAlignerFill18,              
      rx_lane_aligner_fill_19               => uRxLaneAlignerFill19,              
      rx_lane_aligner_fill_2                => uRxLaneAlignerFill2,               
      rx_lane_aligner_fill_3                => uRxLaneAlignerFill3,               
      rx_lane_aligner_fill_4                => uRxLaneAlignerFill4,               
      rx_lane_aligner_fill_5                => uRxLaneAlignerFill5,               
      rx_lane_aligner_fill_6                => uRxLaneAlignerFill6,               
      rx_lane_aligner_fill_7                => uRxLaneAlignerFill7,               
      rx_lane_aligner_fill_8                => uRxLaneAlignerFill8,               
      rx_lane_aligner_fill_9                => uRxLaneAlignerFill9,               
      rx_ptp_tstamp_out                     => uRxPtpTstampOut,                   
      rx_ptp_pcslane_out                    => uRxPtpPcslaneOut,                  
      ctl_rx_systemtimerin                  => uCtlRxSystemtimerin,               
      stat_rx_aligned                       => uStatRxAligned,                    
      stat_rx_aligned_err                   => open,                              
      stat_rx_bad_code                      => open,                              
      stat_rx_bad_fcs                       => open,                              
      stat_rx_bad_preamble                  => open,                              
      stat_rx_bad_sfd                       => open,                              
      stat_rx_bip_err_0                     => open,                              
      stat_rx_bip_err_1                     => open,                              
      stat_rx_bip_err_10                    => open,                              
      stat_rx_bip_err_11                    => open,                              
      stat_rx_bip_err_12                    => open,                              
      stat_rx_bip_err_13                    => open,                              
      stat_rx_bip_err_14                    => open,                              
      stat_rx_bip_err_15                    => open,                              
      stat_rx_bip_err_16                    => open,                              
      stat_rx_bip_err_17                    => open,                              
      stat_rx_bip_err_18                    => open,                              
      stat_rx_bip_err_19                    => open,                              
      stat_rx_bip_err_2                     => open,                              
      stat_rx_bip_err_3                     => open,                              
      stat_rx_bip_err_4                     => open,                              
      stat_rx_bip_err_5                     => open,                              
      stat_rx_bip_err_6                     => open,                              
      stat_rx_bip_err_7                     => open,                              
      stat_rx_bip_err_8                     => open,                              
      stat_rx_bip_err_9                     => open,                              
      stat_rx_block_lock                    => open,                              
      stat_rx_broadcast                     => open,                              
      stat_rx_fragment                      => open,                              
      stat_rx_framing_err_0                 => open,                              
      stat_rx_framing_err_1                 => open,                              
      stat_rx_framing_err_10                => open,                              
      stat_rx_framing_err_11                => open,                              
      stat_rx_framing_err_12                => open,                              
      stat_rx_framing_err_13                => open,                              
      stat_rx_framing_err_14                => open,                              
      stat_rx_framing_err_15                => open,                              
      stat_rx_framing_err_16                => open,                              
      stat_rx_framing_err_17                => open,                              
      stat_rx_framing_err_18                => open,                              
      stat_rx_framing_err_19                => open,                              
      stat_rx_framing_err_2                 => open,                              
      stat_rx_framing_err_3                 => open,                              
      stat_rx_framing_err_4                 => open,                              
      stat_rx_framing_err_5                 => open,                              
      stat_rx_framing_err_6                 => open,                              
      stat_rx_framing_err_7                 => open,                              
      stat_rx_framing_err_8                 => open,                              
      stat_rx_framing_err_9                 => open,                              
      stat_rx_framing_err_valid_0           => open,                              
      stat_rx_framing_err_valid_1           => open,                              
      stat_rx_framing_err_valid_10          => open,                              
      stat_rx_framing_err_valid_11          => open,                              
      stat_rx_framing_err_valid_12          => open,                              
      stat_rx_framing_err_valid_13          => open,                              
      stat_rx_framing_err_valid_14          => open,                              
      stat_rx_framing_err_valid_15          => open,                              
      stat_rx_framing_err_valid_16          => open,                              
      stat_rx_framing_err_valid_17          => open,                              
      stat_rx_framing_err_valid_18          => open,                              
      stat_rx_framing_err_valid_19          => open,                              
      stat_rx_framing_err_valid_2           => open,                              
      stat_rx_framing_err_valid_3           => open,                              
      stat_rx_framing_err_valid_4           => open,                              
      stat_rx_framing_err_valid_5           => open,                              
      stat_rx_framing_err_valid_6           => open,                              
      stat_rx_framing_err_valid_7           => open,                              
      stat_rx_framing_err_valid_8           => open,                              
      stat_rx_framing_err_valid_9           => open,                              
      stat_rx_got_signal_os                 => open,                              
      stat_rx_hi_ber                        => open,                              
      stat_rx_inrangeerr                    => open,                              
      stat_rx_internal_local_fault          => open,                              
      stat_rx_jabber                        => open,                              
      stat_rx_local_fault                   => open,                              
      stat_rx_mf_err                        => open,                              
      stat_rx_mf_len_err                    => open,                              
      stat_rx_mf_repeat_err                 => open,                              
      stat_rx_misaligned                    => open,                              
      stat_rx_multicast                     => open,                              
      stat_rx_oversize                      => open,                              
      stat_rx_packet_1024_1518_bytes        => open,                              
      stat_rx_packet_128_255_bytes          => open,                              
      stat_rx_packet_1519_1522_bytes        => open,                              
      stat_rx_packet_1523_1548_bytes        => open,                              
      stat_rx_packet_1549_2047_bytes        => open,                              
      stat_rx_packet_2048_4095_bytes        => open,                              
      stat_rx_packet_256_511_bytes          => open,                              
      stat_rx_packet_4096_8191_bytes        => open,                              
      stat_rx_packet_512_1023_bytes         => open,                              
      stat_rx_packet_64_bytes               => open,                              
      stat_rx_packet_65_127_bytes           => open,                              
      stat_rx_packet_8192_9215_bytes        => open,                              
      stat_rx_packet_bad_fcs                => open,                              
      stat_rx_packet_large                  => open,                              
      stat_rx_packet_small                  => open,                              
      stat_rx_pause                         => open,                              
      stat_rx_pause_quanta0                 => uStatRxPauseQanta0,                
      stat_rx_pause_quanta1                 => uStatRxPauseQanta1,                
      stat_rx_pause_quanta2                 => uStatRxPauseQanta2,                
      stat_rx_pause_quanta3                 => uStatRxPauseQanta3,                
      stat_rx_pause_quanta4                 => uStatRxPauseQanta4,                
      stat_rx_pause_quanta5                 => uStatRxPauseQanta5,                
      stat_rx_pause_quanta6                 => uStatRxPauseQanta6,                
      stat_rx_pause_quanta7                 => uStatRxPauseQanta7,                
      stat_rx_pause_quanta8                 => uStatRxPauseQanta8,                
      stat_rx_pause_req                     => uStatRxPauseReq,                   
      stat_rx_pause_valid                   => uStatRxPauseValid,                 
      stat_rx_user_pause                    => open,                              
      ctl_rx_check_etype_gcp                => uCtlRxCheckEtypeGcp,               
      ctl_rx_check_etype_gpp                => uCtlRxCheckEtypeGpp,               
      ctl_rx_check_etype_pcp                => uCtlRxCheckEtypePcp,               
      ctl_rx_check_etype_ppp                => uCtlRxCheckEtypePpp,               
      ctl_rx_check_mcast_gcp                => uCtlRxCheckMcastGcp,               
      ctl_rx_check_mcast_gpp                => uCtlRxCheckMcastGpp,               
      ctl_rx_check_mcast_pcp                => uCtlRxCheckMcastPcp,               
      ctl_rx_check_mcast_ppp                => uCtlRxCheckMcastPpp,               
      ctl_rx_check_opcode_gcp               => uCtlRxCheckOpcodeGcp,              
      ctl_rx_check_opcode_gpp               => uCtlRxCheckOpcodeGpp,              
      ctl_rx_check_opcode_pcp               => uCtlRxCheckOpcodePcp,              
      ctl_rx_check_opcode_ppp               => uCtlRxCheckOpcodePpp,              
      ctl_rx_check_sa_gcp                   => uCtlRxCheckSaGcp,                  
      ctl_rx_check_sa_gpp                   => uCtlRxCheckSaGpp,                  
      ctl_rx_check_sa_pcp                   => uCtlRxCheckSaPcp,                  
      ctl_rx_check_sa_ppp                   => uCtlRxCheckSaPpp,                  
      ctl_rx_check_ucast_gcp                => uCtlRxCheckUcastGcp,               
      ctl_rx_check_ucast_gpp                => uCtlRxCheckUcastGpp,               
      ctl_rx_check_ucast_pcp                => uCtlRxCheckUcastPcp,               
      ctl_rx_check_ucast_ppp                => uCtlRxCheckUcastPpp,               
      ctl_rx_enable_gcp                     => uCtlRxEnableGcp,                   
      ctl_rx_enable_gpp                     => uCtlRxEnableGpp,                   
      ctl_rx_enable_pcp                     => uCtlRxEnablePcp,                   
      ctl_rx_enable_ppp                     => uCtlRxEnablePpp,                   
      ctl_rx_pause_ack                      => uCtlRxPauseAck,                    
      ctl_rx_pause_enable                   => uCtlRxPauseEnable,                 
      ctl_rx_enable                         => uCtlRxEnable,                      
      ctl_rx_force_resync                   => aCtlRxForceResync,                 
      ctl_rx_test_pattern                   => uCtlRxTestPattern,                 
      ctl_rsfec_ieee_error_indication_mode  => uCtlRsfecIeeeErrorIndicationMode,  
      ctl_rx_rsfec_enable                   => uCtlRxRsfecEnable,                 
      ctl_rx_rsfec_enable_correction        => uCtlRxRsfecEnableCorrection,       
      ctl_rx_rsfec_enable_indication        => uCtlRxRsfecEnableIndication,       
      core_rx_reset                         => aResetSl,                          
      rx_clk                                => UserClkLcl,                        
      stat_rx_received_local_fault          => open,                              
      stat_rx_remote_fault                  => open,                              
      stat_rx_status                        => open,                              
      stat_rx_stomped_fcs                   => open,                              
      stat_rx_synced                        => open,                              
      stat_rx_synced_err                    => open,                              
      stat_rx_test_pattern_mismatch         => open,                              
      stat_rx_toolong                       => open,                              
      stat_rx_total_bytes                   => open,                              
      stat_rx_total_good_bytes              => open,                              
      stat_rx_total_good_packets            => open,                              
      stat_rx_total_packets                 => open,                              
      stat_rx_truncated                     => open,                              
      stat_rx_undersize                     => open,                              
      stat_rx_unicast                       => open,                              
      stat_rx_vlan                          => open,                              
      stat_rx_pcsl_demuxed                  => open,                              
      stat_rx_pcsl_number_0                 => open,                              
      stat_rx_pcsl_number_1                 => open,                              
      stat_rx_pcsl_number_10                => open,                              
      stat_rx_pcsl_number_11                => open,                              
      stat_rx_pcsl_number_12                => open,                              
      stat_rx_pcsl_number_13                => open,                              
      stat_rx_pcsl_number_14                => open,                              
      stat_rx_pcsl_number_15                => open,                              
      stat_rx_pcsl_number_16                => open,                              
      stat_rx_pcsl_number_17                => open,                              
      stat_rx_pcsl_number_18                => open,                              
      stat_rx_pcsl_number_19                => open,                              
      stat_rx_pcsl_number_2                 => open,                              
      stat_rx_pcsl_number_3                 => open,                              
      stat_rx_pcsl_number_4                 => open,                              
      stat_rx_pcsl_number_5                 => open,                              
      stat_rx_pcsl_number_6                 => open,                              
      stat_rx_pcsl_number_7                 => open,                              
      stat_rx_pcsl_number_8                 => open,                              
      stat_rx_pcsl_number_9                 => open,                              
      stat_rx_rsfec_am_lock0                => uStatRxRsfecAmLock0,               
      stat_rx_rsfec_am_lock1                => uStatRxRsfecAmLock1,               
      stat_rx_rsfec_am_lock2                => uStatRxRsfecAmLock2,               
      stat_rx_rsfec_am_lock3                => uStatRxRsfecAmLock3,               
      stat_rx_rsfec_corrected_cw_inc        => uStatRxRsfecCorrectedCwInc,        
      stat_rx_rsfec_cw_inc                  => uStatRxRsfecCwInc,                 
      stat_rx_rsfec_err_count0_inc          => uStatRxRsfecErrCount0Inc,          
      stat_rx_rsfec_err_count1_inc          => uStatRxRsfecErrCount1Inc,          
      stat_rx_rsfec_err_count2_inc          => uStatRxRsfecErrCount2Inc,          
      stat_rx_rsfec_err_count3_inc          => uStatRxRsfecErrCount3Inc,          
      stat_rx_rsfec_hi_ser                  => uStatRxRsfecHiSer,                 
      stat_rx_rsfec_lane_alignment_status   => uStatRxRsfecLaneAlignmentStatus,   
      stat_rx_rsfec_lane_fill_0             => uStatRxRsfecLaneFill0,             
      stat_rx_rsfec_lane_fill_1             => uStatRxRsfecLaneFill1,             
      stat_rx_rsfec_lane_fill_2             => uStatRxRsfecLaneFill2,             
      stat_rx_rsfec_lane_fill_3             => uStatRxRsfecLaneFill3,             
      stat_rx_rsfec_lane_mapping            => uStatRxRsfecLaneMapping,           
      stat_rx_rsfec_uncorrected_cw_inc      => uStatRxRsfecUncorrectedCwInc,      
      ctl_tx_systemtimerin                  => uCtlTxSystemtimerin,               
      stat_tx_ptp_fifo_read_error           => uStatTxPtpFifoReadError,           
      stat_tx_ptp_fifo_write_error          => uStatTxPtpFifoWriteError,          
      tx_ptp_tstamp_valid_out               => uTxPtpTstampValidOut,              
      tx_ptp_pcslane_out                    => uTxPtpPcslaneOut,                  
      tx_ptp_tstamp_tag_out                 => uTxPtpTstampTagOut,                
      tx_ptp_tstamp_out                     => uTxPtpTstampOut,                   
      tx_ptp_1588op_in                      => uTxPtp1588opIn,                    
      tx_ptp_tag_field_in                   => uTxPtpTagFieldIn,                  
      stat_tx_bad_fcs                       => open,                              
      stat_tx_broadcast                     => open,                              
      stat_tx_frame_error                   => open,                              
      stat_tx_local_fault                   => open,                              
      stat_tx_multicast                     => open,                              
      stat_tx_packet_1024_1518_bytes        => open,                              
      stat_tx_packet_128_255_bytes          => open,                              
      stat_tx_packet_1519_1522_bytes        => open,                              
      stat_tx_packet_1523_1548_bytes        => open,                              
      stat_tx_packet_1549_2047_bytes        => open,                              
      stat_tx_packet_2048_4095_bytes        => open,                              
      stat_tx_packet_256_511_bytes          => open,                              
      stat_tx_packet_4096_8191_bytes        => open,                              
      stat_tx_packet_512_1023_bytes         => open,                              
      stat_tx_packet_64_bytes               => open,                              
      stat_tx_packet_65_127_bytes           => open,                              
      stat_tx_packet_8192_9215_bytes        => open,                              
      stat_tx_packet_large                  => open,                              
      stat_tx_packet_small                  => open,                              
      stat_tx_total_bytes                   => open,                              
      stat_tx_total_good_bytes              => open,                              
      stat_tx_total_good_packets            => open,                              
      stat_tx_total_packets                 => open,                              
      stat_tx_unicast                       => open,                              
      stat_tx_vlan                          => open,                              
      ctl_tx_enable                         => uCtlTxEnable,                      
      ctl_tx_test_pattern                   => uCtlTxTestPattern,                 
      ctl_tx_rsfec_enable                   => uCtlTxRsfecEnable,                 
      ctl_tx_send_idle                      => uCtlTxSendIdle,                    
      ctl_tx_send_rfi                       => uCtlTxSendRfi,                     
      ctl_tx_send_lfi                       => uCtlTxSendLfi,                     
      core_tx_reset                         => aResetSl,                          
      stat_tx_pause_valid                   => uStatTxPauseValid,                 
      stat_tx_pause                         => open,                              
      stat_tx_user_pause                    => open,                              
      ctl_tx_pause_enable                   => uCtlTxPauseEnable,                 
      ctl_tx_pause_quanta0                  => uCtlTxPauseQuanta0,                
      ctl_tx_pause_quanta1                  => uCtlTxPauseQuanta1,                
      ctl_tx_pause_quanta2                  => uCtlTxPauseQuanta2,                
      ctl_tx_pause_quanta3                  => uCtlTxPauseQuanta3,                
      ctl_tx_pause_quanta4                  => uCtlTxPauseQuanta4,                
      ctl_tx_pause_quanta5                  => uCtlTxPauseQuanta5,                
      ctl_tx_pause_quanta6                  => uCtlTxPauseQuanta6,                
      ctl_tx_pause_quanta7                  => uCtlTxPauseQuanta7,                
      ctl_tx_pause_quanta8                  => uCtlTxPauseQuanta8,                
      ctl_tx_pause_refresh_timer0           => uCtlTxPauseRefreshTimer0,          
      ctl_tx_pause_refresh_timer1           => uCtlTxPauseRefreshTimer1,          
      ctl_tx_pause_refresh_timer2           => uCtlTxPauseRefreshTimer2,          
      ctl_tx_pause_refresh_timer3           => uCtlTxPauseRefreshTimer3,          
      ctl_tx_pause_refresh_timer4           => uCtlTxPauseRefreshTimer4,          
      ctl_tx_pause_refresh_timer5           => uCtlTxPauseRefreshTimer5,          
      ctl_tx_pause_refresh_timer6           => uCtlTxPauseRefreshTimer6,          
      ctl_tx_pause_refresh_timer7           => uCtlTxPauseRefreshTimer7,          
      ctl_tx_pause_refresh_timer8           => uCtlTxPauseRefreshTimer8,          
      ctl_tx_pause_req                      => uCtlTxPauseReq,                    
      ctl_tx_resend_pause                   => uCtlTxResendPause,                 
      tx_axis_tready                        => uTxTReady,                         
      tx_axis_tvalid                        => uTxTValid,                         
      tx_axis_tdata(64*1-1 downto 64*(1-1)) => uTxTData0,                         
      tx_axis_tdata(64*2-1 downto 64*(2-1)) => uTxTData1,                         
      tx_axis_tdata(64*3-1 downto 64*(3-1)) => uTxTData2,                         
      tx_axis_tdata(64*4-1 downto 64*(4-1)) => uTxTData3,                         
      tx_axis_tdata(64*5-1 downto 64*(5-1)) => uTxTData4,                         
      tx_axis_tdata(64*6-1 downto 64*(6-1)) => uTxTData5,                         
      tx_axis_tdata(64*7-1 downto 64*(7-1)) => uTxTData6,                         
      tx_axis_tdata(64*8-1 downto 64*(8-1)) => uTxTData7,                         
      tx_axis_tlast                         => uTxTLast,                          
      tx_axis_tkeep                         => uTxTKeep,                          
      tx_axis_tuser                         => uTxTUser,                          
      tx_ovfout                             => open,                              
      tx_unfout                             => open,                              
      tx_preamblein                         => (others => '0'),                   
      usr_tx_reset                          => uUsrTxReset,                       
      core_drp_reset                        => aResetSl,                          
      drp_clk                               => DrpClk,                            
      drp_addr                              => dDrpAddr,                          
      drp_di                                => dDrpDi,                            
      drp_en                                => dDrpEn,                            
      drp_do                                => dDrpDo,                            
      drp_rdy                               => dDrpRdy,                           
      drp_we                                => dDrpWe);                           


  UserClk <= UserClkLcl;

end rtl;