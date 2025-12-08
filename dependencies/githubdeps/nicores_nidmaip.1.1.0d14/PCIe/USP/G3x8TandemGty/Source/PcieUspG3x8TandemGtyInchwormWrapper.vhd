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
  use work.PkgNiUtilities.all;
  use work.PkgBaRegPort.all;  
  use work.PkgNiDma.all;                   
  use work.PkgDmaPortRecordFlattening.all; 
  use work.PkgSwitchedChinch.all;
  use work.PkgLinkStorageRam.all;
  use work.PkgInchwormWrapper.all;

--synopsys translate_off


library PcieUspG3x8TandemGtyInchwormLib;
--synopsys translate_on

entity PcieUspG3x8TandemGtyInchwormWrapper is
  generic (
    
    
    
    
    kCfgRevId        : std_logic_vector(7 downto 0)  := X"01";
    kCfgSubsysVendId : std_logic_vector(15 downto 0) := X"1093";
    kCfgSubsysId     : std_logic_vector(15 downto 0) := X"C4C4";
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    kForceChannelEnable : NiDmaDmaChannelOneHot_t := (others => false)
  );
  port (
    
    
    aPcieRst_n   : in  std_logic;

    
    PcieRefClk_p : in  std_logic;
    PcieRefClk_n : in  std_logic;

    
    
    
    PcieRefClkOut : out std_logic;

    
    PcieRx_p     : in  std_logic_vector(7 downto 0);
    PcieRx_n     : in  std_logic_vector(7 downto 0);
    PcieTx_p     : out std_logic_vector(7 downto 0);
    PcieTx_n     : out std_logic_vector(7 downto 0);

    
    
    
    DmaClockSource : out std_logic;
    DmaClock       : in  std_logic;

    
    
    
    
    
    
    aBusReset : out boolean;

    
    
    
    dAppHwInterrupt : in std_logic_vector(1 downto 0);

    
    
    
    
    
    
    
    
    dBaRegPortIn    : out BaRegPortIn_t;
    dBaRegPortOut   : in  BaRegPortOut_t;
    dLvUserMappable : in  std_logic;

    
    
    
    
    
    
    
    
    
    
    dHighSpeedSinkFromDma : out NiDmaHighSpeedSinkFromDma_t;

    
    
    
    
    
    
    
    
    dHostRequestTx    : out SwitchedLinkTx_t;
    dHostRequestRx    : in  SwitchedLinkRx_t;
    dHostResponseAck  : in  boolean;
    dHostResponseErr  : in  boolean;
    dHostResponseData : in  std_logic_vector(63 downto 0);

    
    
    
    
    dInputRequestToDma    : in  NiDmaInputRequestToDma_t;
    dInputRequestFromDma  : out NiDmaInputRequestFromDma_t;
    dInputDataToDma       : in  NiDmaInputDataToDma_t;
    dInputDataFromDma     : out NiDmaInputDataFromDma_t;
    dInputStatusFromDma   : out NiDmaInputStatusFromDma_t;
    dOutputRequestToDma   : in  NiDmaOutputRequestToDma_t;
    dOutputRequestFromDma : out NiDmaOutputRequestFromDma_t;
    dOutputDataFromDma    : out NiDmaOutputDataFromDma_t;

    
    dPoscPause : in  boolean;
    dPoscError : in  boolean;
    dPoscDone  : out boolean;

    
    aCpResetOut_n         : out std_logic;
    aCpResetIn_n          : in  std_logic; 
    aCpSCEN_n             : in  std_logic;
    aPoscRestoreAsyncMode : in  std_logic;

    
    
    
    
    
    
    
    
    
    
    Clk40Mhz              : in  std_logic;
    aAuthSdaIn            : in  std_logic;
    aAuthSdaOut           : out std_logic;

    
    
    dCfgLtssmState  : out std_logic_vector(5 downto 0);
    dUserLnkUp      : out std_logic;
    dUserAppRdy     : out std_logic;

    PcieDrpClk   : in  std_logic;
    pPcieDrpAddr : in  std_logic_vector(9 downto 0);
    pPcieDrpDi   : in  std_logic_vector(15 downto 0);
    pPcieDrpDo   : out std_logic_vector(15 downto 0);
    pPcieDrpEn   : in  std_logic;
    pPcieDrpRdy  : out std_logic;
    pPcieDrpWe   : in  std_logic;

    GtDrpClk   : out std_logic;
    gGtDrpAddr : in  std_logic_vector(79 downto 0);
    gGtDrpEn   : in  std_logic_vector(7 downto 0);
    gGtDrpDi   : in  std_logic_vector(127 downto 0);
    gGtDrpWe   : in  std_logic_vector(7 downto 0);
    gGtDrpDo   : out std_logic_vector(127 downto 0);
    gGtDrpRdy  : out std_logic_vector(7 downto 0);
    
    aIbertEyescanResetIn : in std_logic_vector(7 downto 0)
  );
end entity; 

architecture RTL of PcieUspG3x8TandemGtyInchwormWrapper is

  component PcieUspG3x8TandemGtyInchwormNetlist
    port (
      aPcieRst_n                : in  std_logic;
      PcieRefClk_p              : in  std_logic;
      PcieRefClk_n              : in  std_logic;
      PcieRefClkOut             : out std_logic;
      PcieRx_p                  : in  std_logic_vector(7 downto 0);
      PcieRx_n                  : in  std_logic_vector(7 downto 0);
      PcieTx_p                  : out std_logic_vector(7 downto 0);
      PcieTx_n                  : out std_logic_vector(7 downto 0);
      DmaClockSource            : out std_logic;
      DmaClock                  : in  std_logic;
      aBusReset                 : out boolean;
      dCfgVendId                : in  std_logic_vector(15 downto 0);
      dCfgDevId                 : in  std_logic_vector(15 downto 0);
      dCfgRevId                 : in  std_logic_vector(7 downto 0);
      dCfgSubsysVendId          : in  std_logic_vector(15 downto 0);
      dCfgSubsysId              : in  std_logic_vector(15 downto 0);
      dLinkStorageRamWrite      : out boolean;
      dLinkStorageRamWriteAddr  : out unsigned(kLinkStorageRamAddrWidth-1 downto 0);
      dLinkStorageRamWriteData  : out std_logic_vector(kLinkStorageRamDataWidth-1 downto 0);
      dLinkStorageRamReadAddr   : out unsigned(kLinkStorageRamRdAddrWidth-1 downto 0);
      dLinkStorageRamReadData   : in  std_logic_vector(kLinkStorageRamRdDataWidth-1 downto 0);
      dAppHwInterrupt           : in  std_logic_vector(1 downto 0);
      dFlatBaRegPortIn          : out FlatBaRegPortIn_t;
      dFlatBaRegPortOut         : in  FlatBaRegPortOut_t;
      dLvUserMappable           : in  std_logic;
      dFlatHighSpeedSinkFromDma : out FlatNiDmaHighSpeedSinkFromDma_t;
      dFlatHostRequestTx        : out FlatSwitchedLinkTx_t;
      dFlatHostRequestRx        : in  FlatSwitchedLinkRx_t;
      dHostResponseAck          : in  boolean;
      dHostResponseErr          : in  boolean;
      dHostResponseData         : in  std_logic_vector(63 downto 0);
      dFlatInputRequestToDma    : in  FlatNiDmaInputRequestToDma_t;
      dFlatInputRequestFromDma  : out FlatNiDmaInputRequestFromDma_t;
      dFlatInputDataToDma       : in  FlatNiDmaInputDataToDma_t;
      dFlatInputDataFromDma     : out FlatNiDmaInputDataFromDma_t;
      dFlatInputStatusFromDma   : out FlatNiDmaInputStatusFromDma_t;
      dFlatOutputRequestToDma   : in  FlatNiDmaOutputRequestToDma_t;
      dFlatOutputRequestFromDma : out FlatNiDmaOutputRequestFromDma_t;
      dFlatOutputDataFromDma    : out FlatNiDmaOutputDataFromDma_t;
      dPoscPause                : in  boolean;
      dPoscError                : in  boolean;
      dPoscDone                 : out boolean;
      aCpResetOut_n             : out std_logic;
      aCpResetIn_n              : in  std_logic;
      aCpSCEN_n                 : in  std_logic;
      aPoscRestoreAsyncMode     : in  std_logic;
      Clk40Mhz                  : in  std_logic;
      aAuthSdaIn                : in  std_logic;
      aAuthSdaOut               : out std_logic;
      dCfgLtssmState            : out std_logic_vector(5 downto 0);
      dUserLnkUp                : out std_logic;
      dUserAppRdy               : out std_logic;
      PcieDrpClk                : in  std_logic;
      pPcieDrpAddr              : in  std_logic_vector(9 downto 0);
      pPcieDrpDi                : in  std_logic_vector(15 downto 0);
      pPcieDrpDo                : out std_logic_vector(15 downto 0);
      pPcieDrpEn                : in  std_logic;
      pPcieDrpRdy               : out std_logic;
      pPcieDrpWe                : in  std_logic;
      GtDrpClk                  : out std_logic;
      gGtDrpAddr                : in  std_logic_vector(79 downto 0);
      gGtDrpEn                  : in  std_logic_vector(7 downto 0);
      gGtDrpDi                  : in  std_logic_vector(127 downto 0);
      gGtDrpWe                  : in  std_logic_vector(7 downto 0);
      gGtDrpDo                  : out std_logic_vector(127 downto 0);
      gGtDrpRdy                 : out std_logic_vector(7 downto 0);
      aIbertEyescanResetIn      : in  std_logic_vector(7 downto 0));
  end component;

  
  signal dCfgDevId: std_logic_vector(15 downto 0);
  signal dCfgRevId: std_logic_vector(7 downto 0);
  signal dCfgSubsysId: std_logic_vector(15 downto 0);
  signal dCfgSubsysVendId: std_logic_vector(15 downto 0);
  signal dCfgVendId: std_logic_vector(15 downto 0);
  signal dFlatBaRegPortIn: FlatBaRegPortIn_t;
  signal dFlatBaRegPortOut: FlatBaRegPortOut_t;
  signal dFlatHighSpeedSinkFromDma: FlatNiDmaHighSpeedSinkFromDma_t;
  signal dFlatHostRequestRx: FlatSwitchedLinkRx_t;
  signal dFlatHostRequestTx: FlatSwitchedLinkTx_t;
  signal dFlatInputDataFromDma: FlatNiDmaInputDataFromDma_t;
  signal dFlatInputDataToDma: FlatNiDmaInputDataToDma_t;
  signal dFlatInputRequestFromDma: FlatNiDmaInputRequestFromDma_t;
  signal dFlatInputRequestToDma: FlatNiDmaInputRequestToDma_t;
  signal dFlatInputStatusFromDma: FlatNiDmaInputStatusFromDma_t;
  signal dFlatOutputDataFromDma: FlatNiDmaOutputDataFromDma_t;
  signal dFlatOutputRequestFromDma: FlatNiDmaOutputRequestFromDma_t;
  signal dFlatOutputRequestToDma: FlatNiDmaOutputRequestToDma_t;
  signal dLinkStorageRamReadAddr: unsigned(kLinkStorageRamRdAddrWidth-1 downto 0);
  signal dLinkStorageRamReadData: std_logic_vector(kLinkStorageRamRdDataWidth-1 downto 0);
  signal dLinkStorageRamWrite: boolean;
  signal dLinkStorageRamWriteAddr: unsigned(kLinkStorageRamAddrWidth-1 downto 0);
  signal dLinkStorageRamWriteData: std_logic_vector(kLinkStorageRamDataWidth-1 downto 0);
  

begin

  --synopsys translate_off

  
  
  
  work.PkgSystemConfiguration.BimType.Set(work.PkgSystemConfigurationTypes.UsPlus);

  --synopsys translate_on

  
  
  
  
  dCfgVendId       <= X"1093";
  dCfgDevId        <= X"C4C4";

  
  
  dCfgRevId        <= kCfgRevId;
  dCfgSubsysVendId <= kCfgSubsysVendId;
  dCfgSubsysId     <= kCfgSubsysId;

  
  InchwormNetlist: PcieUspG3x8TandemGtyInchwormNetlist
    port map (
      aPcieRst_n                => aPcieRst_n,                 
      PcieRefClk_p              => PcieRefClk_p,               
      PcieRefClk_n              => PcieRefClk_n,               
      PcieRefClkOut             => PcieRefClkOut,              
      PcieRx_p                  => PcieRx_p,                   
      PcieRx_n                  => PcieRx_n,                   
      PcieTx_p                  => PcieTx_p,                   
      PcieTx_n                  => PcieTx_n,                   
      DmaClockSource            => DmaClockSource,             
      DmaClock                  => DmaClock,                   
      aBusReset                 => aBusReset,                  
      dCfgVendId                => dCfgVendId,                 
      dCfgDevId                 => dCfgDevId,                  
      dCfgRevId                 => dCfgRevId,                  
      dCfgSubsysVendId          => dCfgSubsysVendId,           
      dCfgSubsysId              => dCfgSubsysId,               
      dLinkStorageRamWrite      => dLinkStorageRamWrite,       
      dLinkStorageRamWriteAddr  => dLinkStorageRamWriteAddr,   
      dLinkStorageRamWriteData  => dLinkStorageRamWriteData,   
      dLinkStorageRamReadAddr   => dLinkStorageRamReadAddr,    
      dLinkStorageRamReadData   => dLinkStorageRamReadData,    
      dAppHwInterrupt           => dAppHwInterrupt,            
      dFlatBaRegPortIn          => dFlatBaRegPortIn,           
      dFlatBaRegPortOut         => dFlatBaRegPortOut,          
      dLvUserMappable           => dLvUserMappable,            
      dFlatHighSpeedSinkFromDma => dFlatHighSpeedSinkFromDma,  
      dFlatHostRequestTx        => dFlatHostRequestTx,         
      dFlatHostRequestRx        => dFlatHostRequestRx,         
      dHostResponseAck          => dHostResponseAck,           
      dHostResponseErr          => dHostResponseErr,           
      dHostResponseData         => dHostResponseData,          
      dFlatInputRequestToDma    => dFlatInputRequestToDma,     
      dFlatInputRequestFromDma  => dFlatInputRequestFromDma,   
      dFlatInputDataToDma       => dFlatInputDataToDma,        
      dFlatInputDataFromDma     => dFlatInputDataFromDma,      
      dFlatInputStatusFromDma   => dFlatInputStatusFromDma,    
      dFlatOutputRequestToDma   => dFlatOutputRequestToDma,    
      dFlatOutputRequestFromDma => dFlatOutputRequestFromDma,  
      dFlatOutputDataFromDma    => dFlatOutputDataFromDma,     
      dPoscPause                => dPoscPause,                 
      dPoscError                => dPoscError,                 
      dPoscDone                 => dPoscDone,                  
      aCpResetOut_n             => aCpResetOut_n,              
      aCpResetIn_n              => aCpResetIn_n,               
      aCpSCEN_n                 => aCpSCEN_n,                  
      aPoscRestoreAsyncMode     => aPoscRestoreAsyncMode,      
      Clk40Mhz                  => Clk40Mhz,                   
      aAuthSdaIn                => aAuthSdaIn,                 
      aAuthSdaOut               => aAuthSdaOut,                
      dCfgLtssmState            => dCfgLtssmState,             
      dUserLnkUp                => dUserLnkUp,                 
      dUserAppRdy               => dUserAppRdy,                
      PcieDrpClk                => PcieDrpClk,                 
      pPcieDrpAddr              => pPcieDrpAddr,               
      pPcieDrpDi                => pPcieDrpDi,                 
      pPcieDrpDo                => pPcieDrpDo,                 
      pPcieDrpEn                => pPcieDrpEn,                 
      pPcieDrpRdy               => pPcieDrpRdy,                
      pPcieDrpWe                => pPcieDrpWe,                 
      GtDrpClk                  => GtDrpClk,                   
      gGtDrpAddr                => gGtDrpAddr,                 
      gGtDrpEn                  => gGtDrpEn,                   
      gGtDrpDi                  => gGtDrpDi,                   
      gGtDrpWe                  => gGtDrpWe,                   
      gGtDrpDo                  => gGtDrpDo,                   
      gGtDrpRdy                 => gGtDrpRdy,                  
      aIbertEyescanResetIn      => aIbertEyescanResetIn);      

  
  
  LinkStorageRam: entity work.LinkStorageRamXilinx (struct)
    generic map (kEnabledChannels => kGetEnabledChannels(kForceChannelEnable))  
    port map (
      DmaClock                 => DmaClock,                  
      dLinkStorageRamWrite     => dLinkStorageRamWrite,      
      dLinkStorageRamWriteAddr => dLinkStorageRamWriteAddr,  
      dLinkStorageRamWriteData => dLinkStorageRamWriteData,  
      dLinkStorageRamReadAddr  => dLinkStorageRamReadAddr,   
      dLinkStorageRamReadData  => dLinkStorageRamReadData);  

  
  dFlatInputRequestToDma <= Flatten(dInputRequestToDma);
  dFlatInputDataToDma    <= Flatten(dInputDataToDma);
  dInputRequestFromDma   <= UnFlatten(dFlatInputRequestFromDma);
  dInputDataFromDma      <= UnFlatten(dFlatInputDataFromDma);
  dInputStatusFromDma    <= UnFlatten(dFlatInputStatusFromDma);

  dFlatOutputRequestToDma <= Flatten(dOutputRequestToDma);
  dOutputRequestFromDma   <= UnFlatten(dFlatOutputRequestFromDma);
  dOutputDataFromDma      <= UnFlatten(dFlatOutputDataFromDma);

  
  dHighSpeedSinkFromDma <= UnFlatten(dFlatHighSpeedSinkFromDma);

  
  dBaRegPortIn      <= UnFlatten(dFlatBaRegPortIn);
  dFlatBaRegPortOut <= Flatten(dBaRegPortOut);

  
  dFlatHostRequestRx <= Flatten(dHostRequestRx);
  dHostRequestTx     <= UnFlatten(dFlatHostRequestTx);

end RTL;