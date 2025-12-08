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

  
  
  use work.PkgDmaPortDataPackingFifo.all;

  
  use work.PkgDmaPortDmaFifos.all;

  
  use work.PkgDmaPortCommIfcStreamStates.all;

  
  
  use work.PkgNiDma.all;
  
  use work.PkgCommIntConfiguration.all;

entity DmaPortCommIfcInputStream is
    generic(

      
      kFifoDepth           : natural  := 1024;

      
      
      kSampleWidth          : positive := 32;

      
      
      
      kBaseOffset          : natural  := 0;

      
      
      kStreamNumber        : natural  := 0;

      
      
      
      kEvictionTimeout     : natural  := 512;

      
      
      kPeerToPeerStream    : boolean := false;

      
      
      kFxpType             : boolean  := false

    );
    port(

      
      aReset : in boolean;

      
      
      
      
      
      bReset : in boolean;

      
      
      

      
      BusClk : in std_logic;

      
      
      

      
      
      bNiDmaInputRequestToDma : out NiDmaInputRequestToDma_t;

      
      bNiDmaInputRequestFromDma : in NiDmaInputRequestFromDma_t;

      
      
      bNiDmaInputStatusFromDma : in NiDmaInputStatusFromDma_t;

      
      
      
      
      bInputDataInterfaceFromFifo: out NiDmaInputDataToDma_t;
      bInputDataInterfaceToFifo: in NiDmaInputDataFromDma_t;

      
      
      

      
      
      bArbiterNormalReq      : out std_logic;

      
      
      
      bArbiterEmergencyReq   : out std_logic;

      
      
      
      bArbiterDone           : out std_logic;

      
      
      
      bArbiterGrant          : in  std_logic;

      
      
      

      
      
      bRegPortIn             : in  RegPortIn_t;

      
      
      bRegPortOut            : out RegPortOut_t;

      
      
      

      
      
      bInputStreamInterfaceToFifo   : out InputStreamInterfaceToFifo_t;

      
      
      bInputStreamInterfaceFromFifo : in InputStreamInterfaceFromFifo_t;

      
      
      

      bIrq : out IrqStatusToInterface_t

    );
end DmaPortCommIfcInputStream;


architecture structure of DmaPortCommIfcInputStream is

  
  constant kSampleSize : integer := ActualSampleSize (SampleSizeInBits => kSampleWidth,
                                                      PeerToPeer => kPeerToPeerStream,
                                                      FxpType => kFxpType);

  
  constant kFifoCountWidth : integer := Log2(kFifoDepth);

  signal bFifoFullCount: unsigned(kFifoCountWidth-1 downto 0);

  signal bStopChannelRequest : boolean;
  signal bInputStatusReceived : boolean;
  signal bInputStreamErrorStatus : boolean;

  
  signal bByteLanePtr: NiDmaByteLane_t;
  signal bClearEnableIrq: boolean;
  signal bClearFlushingFailedStatus: boolean;
  signal bClearFlushingIrq: boolean;
  signal bClearFlushingStatus: boolean;
  signal bClearSatcr: boolean;
  signal bDisableController: boolean;
  signal bDisabled: boolean;
  signal bDmaReset: boolean;
  signal bFifoOverflow: boolean;
  signal bFlushIrqStrobe: boolean;
  signal bFlushReq: boolean;
  signal bHostDisable: boolean;
  signal bHostEnable: boolean;
  signal bHostFlush: boolean;
  signal bLinked: boolean;
  signal bMaxPktSize: unsigned(Log2(kInputMaxTransfer)downto 0);
  signal bNumReadSamples: NiDmaInputByteCount_t;
  signal bReqWriteSpaces: unsigned(Log2(kInputMaxTransfer)downto 0);
  signal bResetDmaChannel: boolean;
  signal bResetDone: boolean;
  signal bResetFifo: boolean;
  signal bRsrvReadSpaces: boolean;
  signal bSatcrWriteEvent: boolean;
  signal bSatcrWriteStrobe: boolean;
  signal bSetEnableIrq: boolean;
  signal bSetFlushingFailedStatus: boolean;
  signal bSetFlushingStatus: boolean;
  signal bStartChannelRequest: boolean;
  signal bState: StreamStateValue_t;
  signal bStateInDefaultClkDomain: StreamStateValue_t;
  signal bStopChannelWithFlushRequest: boolean;
  signal bWriteDetected: boolean;
  signal bWritesDisabled: boolean;
  


begin

  bInputStreamInterfaceToFifo.DmaReset <= bDmaReset or bResetFifo;
  bInputStreamInterfaceToFifo.NumReadSamples <= bNumReadSamples;
  bInputStreamInterfaceToFifo.RsrvReadSpaces <= bRsrvReadSpaces;
  bInputStreamInterfaceToFifo.StreamState <= bState;

  
  
  
  
  
  
  
  
  
  
  
  
  bInputStreamInterfaceToFifo.Pop <= 
    bInputDataInterfaceToFifo.Pop when
                       bInputDataInterfaceToFifo.DmaChannel(kStreamNumber)
                   and not bDisabled
    else false;
  bInputStreamInterfaceToFifo.TransferEnd <= bInputDataInterfaceToFifo.TransferEnd;
  bInputStreamInterfaceToFifo.ByteCount <= bInputDataInterfaceToFifo.ByteCount;
  bInputStreamInterfaceToFifo.ByteEnable <= bInputDataInterfaceToFifo.ByteEnable;
  bInputStreamInterfaceToFifo.ByteLane <= bInputDataInterfaceToFifo.ByteLane;


  bResetDone <= bInputStreamInterfaceFromFifo.ResetDone;
  bFifoFullCount <= resize(bInputStreamInterfaceFromFifo.FifoFullCount,
    bFifoFullCount'length);
  bFifoOverflow <= bInputStreamInterfaceFromFifo.FifoOverflow;
  bByteLanePtr <= bInputStreamInterfaceFromFifo.ByteLanePtr;
  bStartChannelRequest <= bInputStreamInterfaceFromFifo.StartStreamRequest;
  bStopChannelRequest <= bInputStreamInterfaceFromFifo.StopStreamRequest;
  bStopChannelWithFlushRequest <=
    bInputStreamInterfaceFromFifo.StopStreamWithFlushRequest;
  bFlushReq <= bInputStreamInterfaceFromFifo.FlushRequest;
  bWritesDisabled <= bInputStreamInterfaceFromFifo.WritesDisabled;
  bStateInDefaultClkDomain <= bInputStreamInterfaceFromFifo.StateInDefaultClkDomain;
  bInputDataInterfaceFromFifo.Data <= (others => '0') when bDisabled
                                 else bInputStreamInterfaceFromFifo.FifoDataOut;
  bWriteDetected <= bInputStreamInterfaceFromFifo.WriteDetected;

  bInputStatusReceived <= bNiDmaInputStatusFromDma.Ready when
                            bNiDmaInputStatusFromDma.DmaChannel(kStreamNumber)
                          else false;

  bInputStreamErrorStatus <= bNiDmaInputStatusFromDma.ErrorStatus when
                               bNiDmaInputStatusFromDma.Ready and
                               bNiDmaInputStatusFromDma.DmaChannel(kStreamNumber)
                             else false;

  
  
  bResetDmaChannel <= bReset or bDmaReset;

  
  
  
  
  
  
  
  
  DmaPortCommIfcInputControllerx: entity work.DmaPortCommIfcInputController (rtl)
    generic map (
      kStreamNumber     => kStreamNumber,      
      kSampleSizeInBits => kSampleSize,        
      kFifoCountWidth   => kFifoCountWidth,    
      kEvictionTimeout  => kEvictionTimeout,   
      kPeerToPeerStream => kPeerToPeerStream)  
    port map (
      aReset               => aReset,                     
      bReset               => bResetDmaChannel,           
      BusClk               => BusClk,                     
      bInputRequest        => bNiDmaInputRequestToDma,    
      bRequestAcknowledge  => bNiDmaInputRequestFromDma,  
      bInputStatusReceived => bInputStatusReceived,       
      bArbiterNormalReq    => bArbiterNormalReq,          
      bArbiterEmergencyReq => bArbiterEmergencyReq,       
      bArbiterDone         => bArbiterDone,               
      bArbiterGrant        => bArbiterGrant,              
      bMaxPktSize          => bMaxPktSize,                
      bWriteDetected       => bWriteDetected,             
      bFifoFullCount       => bFifoFullCount,             
      bNumReadSamples      => bNumReadSamples,            
      bByteLanePtr         => bByteLanePtr,               
      bRsrvReadSpaces      => bRsrvReadSpaces,            
      bFlushReq            => bFlushReq,                  
      bResetFifo           => bResetFifo,                 
      bResetDone           => bResetDone,                 
      bSatcrWriteStrobe    => bSatcrWriteStrobe,          
      bReqWriteSpaces      => bReqWriteSpaces,            
      bDisable             => bDisableController,         
      bDisabled            => bDisabled,                  
      bClearSatcr          => bClearSatcr);               



  
  
  
  
  
  
  
  
  
  
  
  DmaPortCommIfcRegistersx: entity work.DmaPortCommIfcRegisters (behavior)
    generic map (
      kBaseOffset       => kBaseOffset,        
      kInputStream      => true,               
      kPeerToPeerStream => kPeerToPeerStream,  
      kMaxTransfer      => kInputMaxTransfer)  
    port map (
      aReset                     => aReset,                      
      bReset                     => bReset,                      
      BusClk                     => BusClk,                      
      bRegPortIn                 => bRegPortIn,                  
      bRegPortOut                => bRegPortOut,                 
      bHostEnable                => bHostEnable,                 
      bHostDisable               => bHostDisable,                
      bHostFlush                 => bHostFlush,                  
      bDisabled                  => bDisabled,                   
      bDmaReset                  => bDmaReset,                   
      bResetDone                 => bResetDone,                  
      bFifoOverflow              => bFifoOverflow,               
      bFifoUnderflow             => false,                       
      bStartChannelRequest       => bSetEnableIrq,               
      bStopChannelRequest        => false,                       
      bFlushIrqStrobe            => bFlushIrqStrobe,             
      bClearEnableIrq            => bClearEnableIrq,             
      bClearDisableIrq           => false,                       
      bClearFlushingIrq          => bClearFlushingIrq,           
      bSetFlushingStatus         => bSetFlushingStatus,          
      bClearFlushingStatus       => bClearFlushingStatus,        
      bSetFlushingFailedStatus   => bSetFlushingFailedStatus,    
      bClearFlushingFailedStatus => bClearFlushingFailedStatus,  
      bSatcrWriteEvent           => bSatcrWriteEvent,            
      bClearSatcr                => bClearSatcr,                 
      bStreamError               => bInputStreamErrorStatus,     
      bMaxPktSize                => bMaxPktSize,                 
      bSatcrWriteStrobe          => bSatcrWriteStrobe,           
      bReqWriteSpaces            => bReqWriteSpaces,             
      bFifoCount                 => bFifoFullCount,              
      bPeerAddress               => open,                        
      bState                     => bState,                      
      bLinked                    => bLinked,                     
      bSatcrUpdatesEnabled       => open,                        
      bIrq                       => bIrq);                       



  
  
  
  DmaPortCommIfcSourceStreamStateControllerx: entity work.DmaPortCommIfcSourceStreamStateController (behavior)
    port map (
      aReset                       => aReset,                        
      bReset                       => bReset,                        
      BusClk                       => BusClk,                        
      bState                       => bState,                        
      bDisable                     => open,                          
      bDisableController           => bDisableController,            
      bFlushIrqStrobe              => bFlushIrqStrobe,               
      bSetEnableIrq                => bSetEnableIrq,                 
      bClearEnableIrq              => bClearEnableIrq,               
      bClearFlushingIrq            => bClearFlushingIrq,             
      bSetFlushingStatus           => bSetFlushingStatus,            
      bClearFlushingStatus         => bClearFlushingStatus,          
      bSetFlushingFailedStatus     => bSetFlushingFailedStatus,      
      bClearFlushingFailedStatus   => bClearFlushingFailedStatus,    
      bHostEnable                  => bHostEnable,                   
      bHostDisable                 => bHostDisable,                  
      bHostFlush                   => bHostFlush,                    
      bStartChannelRequest         => bStartChannelRequest,          
      bStopChannelRequest          => bStopChannelRequest,           
      bStopChannelWithFlushRequest => bStopChannelWithFlushRequest,  
      bDisabled                    => bDisabled,                     
      bLinked                      => bLinked,                       
      bSatcrWriteEvent             => bSatcrWriteEvent,              
      bFifoFullCount               => bFifoFullCount,                
      bWritesDisabled              => bWritesDisabled,               
      bStateInDefaultClkDomain     => bStateInDefaultClkDomain);     



end structure;