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

  
  
  use work.PkgCommunicationInterface.all;
  use work.PkgDmaPortCommunicationInterface.all;

  
  
  use work.PkgCommIntConfiguration.all;

  
  use work.PkgDmaPortDataPackingFifo.all;

  
  use work.PkgDmaPortDmaFifos.all;

  
  use work.PkgDmaPortCommIfcStreamStates.all;

  
  
  use work.PkgNiDma.all;

entity DmaPortCommIfcSinkStream is
    generic(

      
      kFifoDepth         : natural := 1024;

      
      
      
      kFifoBaseOffset    : natural := 16#10#;

      
      
      
      
      kWriteWindow       : natural := 4096;

      
      
      
      kSampleWidth       : positive := 32;

      
      
      
      kBaseOffset        : natural := 0;

      
      
      kStreamNumber      : natural := 0;

      
      
      kFxpType           : boolean  := false

    );
    port(

      
      aReset : in boolean;

      
      
      
      
      
      bReset : in boolean;

      
      
      

      BusClk : in std_logic;

      
      
      

      
      
      bNiDmaInputRequestToDma : out NiDmaInputRequestToDma_t;

      
      
      bNiDmaInputRequestFromDma : in NiDmaInputRequestFromDma_t;

      bNiDmaInputDataFromDma : in NiDmaInputDataFromDma_t;

      bNiDmaInputDataToDma : out NiDmaInputDataToDma_t;

      bNiDmaHighSpeedSinkFromDma : in NiDmaHighSpeedSinkFromDma_t;

      bNiDmaInputDataToDmaValid : out boolean;

      
      
      

      
      
      bArbiterNormalReq      : out std_logic;

      
      
      
      bArbiterEmergencyReq   : out std_logic;

      
      
      
      bArbiterDone           : out std_logic;

      
      
      
      bArbiterGrant          : in  std_logic;

      
      
      

      
      
      
      bRegPortIn             : in  RegPortIn_t;

      
      
      
      bRegPortOut            : out RegPortOut_t;

      
      
      

      
      
      bOutputStreamInterfaceToFifo : out OutputStreamInterfaceToFifo_t;

      
      
      bOutputStreamInterfaceFromFifo : in OutputStreamInterfaceFromFifo_t;

      
      
      

      
      bIrq : out IrqStatusToInterface_t

    );
end DmaPortCommIfcSinkStream;


architecture structure of DmaPortCommIfcSinkStream is

  
  constant kSampleSize : integer := ActualSampleSize (SampleSizeInBits => kSampleWidth,
                                                      PeerToPeer => true,
                                                      FxpType => kFxpType);

  
  constant kFifoCountWidth : integer := Log2(kFifoDepth);

  constant kReqWriteSpacesZero : unsigned(Log2(kFifoWriteWindow) downto 0) :=
    (others=>'0');

  signal bEmptyCount: unsigned(kFifoCountWidth-1 downto 0);
  signal bReqWriteSpaces: unsigned(kFifoCountWidth-1 downto 0);
  signal bHostReadableFullCount : unsigned(31 downto 0);

  
  signal bByteEnable: NiDmaByteEnable_t;
  signal bClearDisableIrq: boolean;
  signal bClearEnableIrq: boolean;
  signal bDisable: boolean;
  signal bDisabled: boolean;
  signal bDisabledFromDataReceiver: boolean;
  signal bDisabledFromTcrUpdateController: boolean;
  signal bDisabledStatusForHost: boolean;
  signal bDmaReset: boolean;
  signal bFifoData: NiDmaData_t;
  signal bFifoUnderflow: boolean;
  signal bFifoWrite: boolean;
  signal bHostDisable: boolean;
  signal bHostEnable: boolean;
  signal bLinked: boolean;
  signal bPeerAddress: NiDmaAddress_t;
  signal bReportDisabledToDiagram: boolean;
  signal bResetDmaChannel: boolean;
  signal bResetDmaChannelAndFifo: boolean;
  signal bResetDone: boolean;
  signal bResetFifo: boolean;
  signal bSatcrUpdatesEnabled: boolean;
  signal bSatcrWriteStrobe: boolean;
  signal bSetEnableIrq: boolean;
  signal bStartChannelRequest: boolean;
  signal bState: StreamStateValue_t;
  signal bStateInDefaultClkDomain: StreamStateValue_t;
  signal bStopChannelRequest: boolean;
  signal bStreamError: boolean;
  signal bWriteLengthInBytes: NiDmaBusByteCount_t;
  

begin

  bOutputStreamInterfaceToFifo.DmaReset <= bDmaReset or bResetFifo;
  bOutputStreamInterfaceToFifo.FifoWrite <= bFifoWrite;
  bOutputStreamInterfaceToFifo.WriteLengthInBytes <= bWriteLengthInBytes;
  bOutputStreamInterfaceToFifo.FifoData <= bFifoData;
  bOutputStreamInterfaceToFifo.ByteEnable <= bByteEnable;
  bOutputStreamInterfaceToFifo.RsrvWriteSpaces <= bSatcrWriteStrobe;
  bOutputStreamInterfaceToFifo.NumWriteSpaces <= resize(bReqWriteSpaces,
    bOutputStreamInterfaceToFifo.NumWriteSpaces'length);
  bOutputStreamInterfaceToFifo.StreamState <= bState;
  bOutputStreamInterfaceToFifo.ReportDisabledToDiagram <= bReportDisabledToDiagram;

  bResetDone <= bOutputStreamInterfaceFromFifo.ResetDone;
  bEmptyCount <= resize(bOutputStreamInterfaceFromFifo.EmptyCount, bEmptyCount'length);
  bFifoUnderflow <= bOutputStreamInterfaceFromFifo.FifoUnderflow;
  bStartChannelRequest <= bOutputStreamInterfaceFromFifo.StartStreamRequest;
  bStopChannelRequest <= bOutputStreamInterfaceFromFifo.StopStreamRequest;
  bHostReadableFullCount <= bOutputStreamInterfaceFromFifo.HostReadableFullCount;
  bStateInDefaultClkDomain <= bOutputStreamInterfaceFromFifo.StateInDefaultClkDomain;


  
  
  bResetDmaChannel <= bDmaReset or bReset;

  
  
  bResetDmaChannelAndFifo <= bResetDmaChannel or bResetFifo;

  
  
  bDisabled <= bDisabledFromDataReceiver and bDisabledFromTcrUpdateController;

  
  
  
  
  DmaPortCommIfcSinkStreamDataReceiverx: entity work.DmaPortCommIfcSinkStreamDataReceiver (rtl)
    generic map (
      kFifoBaseOffset => kFifoBaseOffset,  
      kWriteWindow    => kWriteWindow,     
      kStreamNumber   => kStreamNumber)    
    port map (
      aReset              => aReset,                      
      bReset              => bResetDmaChannelAndFifo,     
      BusClk              => BusClk,                      
      bHighSpeedSink      => bNiDmaHighSpeedSinkFromDma,  
      bFifoWrite          => bFifoWrite,                  
      bWriteLengthInBytes => bWriteLengthInBytes,         
      bFifoData           => bFifoData,                   
      bByteEnable         => bByteEnable,                 
      bDisable            => bDisable,                    
      bDisabled           => bDisabledFromDataReceiver,   
      bStreamError        => bStreamError);               


  
  
  
  
  
  
  
  DmaPortCommIfcSinkStreamTcrUpdateControllerx: entity work.DmaPortCommIfcSinkStreamTcrUpdateController (rtl)
    generic map (
      kDataWidthInBits => kSampleSize,      
      kStreamNumber    => kStreamNumber,    
      kFifoCountWidth  => kFifoCountWidth)  
    port map (
      aReset                    => aReset,                            
      bReset                    => bResetDmaChannelAndFifo,           
      BusClk                    => BusClk,                            
      bNiDmaInputRequestToDma   => bNiDmaInputRequestToDma,           
      bNiDmaInputRequestFromDma => bNiDmaInputRequestFromDma,         
      bNiDmaInputDataFromDma    => bNiDmaInputDataFromDma,            
      bNiDmaInputDataToDma      => bNiDmaInputDataToDma,              
      bSatcrUpdateDataValid     => bNiDmaInputDataToDmaValid,         
      bArbiterNormalReq         => bArbiterNormalReq,                 
      bArbiterEmergencyReq      => bArbiterEmergencyReq,              
      bArbiterDone              => bArbiterDone,                      
      bArbiterGrant             => bArbiterGrant,                     
      bFifoEmptyCount           => bEmptyCount,                       
      bSatcrWriteStrobe         => bSatcrWriteStrobe,                 
      bReqWriteSpaces           => bReqWriteSpaces,                   
      bTcrAddress               => bPeerAddress,                      
      bDisable                  => bDisable,                          
      bDisabled                 => bDisabledFromTcrUpdateController,  
      bSatcrUpdatesEnabled      => bSatcrUpdatesEnabled);             



  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  DmaPortCommIfcRegistersx: entity work.DmaPortCommIfcRegisters (behavior)
    generic map (
      kBaseOffset       => kBaseOffset,       
      kInputStream      => false,             
      kPeerToPeerStream => true,              
      kMaxTransfer      => kFifoWriteWindow)  
    port map (
      aReset                     => aReset,                  
      bReset                     => bReset,                  
      BusClk                     => BusClk,                  
      bRegPortIn                 => bRegPortIn,              
      bRegPortOut                => bRegPortOut,             
      bHostEnable                => bHostEnable,             
      bHostDisable               => bHostDisable,            
      bHostFlush                 => open,                    
      bDisabled                  => bDisabledStatusForHost,  
      bDmaReset                  => bDmaReset,               
      bResetDone                 => bResetDone,              
      bFifoOverflow              => false,                   
      bFifoUnderflow             => bFifoUnderflow,          
      bStartChannelRequest       => bSetEnableIrq,           
      bStopChannelRequest        => bStopChannelRequest,     
      bFlushIrqStrobe            => false,                   
      bClearEnableIrq            => bClearEnableIrq,         
      bClearDisableIrq           => bClearDisableIrq,        
      bClearFlushingIrq          => false,                   
      bSetFlushingStatus         => false,                   
      bClearFlushingStatus       => false,                   
      bSetFlushingFailedStatus   => false,                   
      bClearFlushingFailedStatus => false,                   
      bSatcrWriteEvent           => open,                    
      bClearSatcr                => false,                   
      bStreamError               => bStreamError,            
      bMaxPktSize                => open,                    
      bSatcrWriteStrobe          => false,                   
      bReqWriteSpaces            => kReqWriteSpacesZero,     
      bFifoCount                 => bHostReadableFullCount,  
      bPeerAddress               => bPeerAddress,            
      bState                     => bState,                  
      bLinked                    => bLinked,                 
      bSatcrUpdatesEnabled       => bSatcrUpdatesEnabled,    
      bIrq                       => bIrq);                   



  
  
  
  DmaPortCommIfcSinkStreamStateControllerx: entity work.DmaPortCommIfcSinkStreamStateController (behavior)
    port map (
      aReset                   => aReset,                    
      bReset                   => bResetDmaChannel,          
      BusClk                   => BusClk,                    
      bState                   => bState,                    
      bReportDisabledToDiagram => bReportDisabledToDiagram,  
      bDisable                 => bDisable,                  
      bResetFifo               => bResetFifo,                
      bSetEnableIrq            => bSetEnableIrq,             
      bClearEnableIrq          => bClearEnableIrq,           
      bClearDisableIrq         => bClearDisableIrq,          
      bDisabledStatusForHost   => bDisabledStatusForHost,    
      bHostEnable              => bHostEnable,               
      bHostDisable             => bHostDisable,              
      bStopChannelRequest      => bStopChannelRequest,       
      bStartChannelRequest     => bStartChannelRequest,      
      bDisabled                => bDisabled,                 
      bLinked                  => bLinked,                   
      bResetDone               => bResetDone,                
      bStreamError             => bStreamError,              
      bStateInDefaultClkDomain => bStateInDefaultClkDomain); 



end structure;