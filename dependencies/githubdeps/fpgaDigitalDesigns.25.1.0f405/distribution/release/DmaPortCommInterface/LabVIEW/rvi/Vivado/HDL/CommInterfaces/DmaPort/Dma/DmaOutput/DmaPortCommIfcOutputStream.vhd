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

entity DmaPortCommIfcOutputStream is
    generic(

      
      
      
      kSampleWidth       : positive := 32;

      
      kFifoDepth         : natural  := 1024;

      
      
      kBaseOffset        : natural  := 0;

      
      
      kStreamNumber      : natural  := 0;

      
      
      kFxpType           : boolean  := false

    );
    port(

      
      aReset : in boolean;

      
      bReset : in boolean;

      
      
      

      
      BusClk : in std_logic;

      
      
      

      
      
      bNiDmaOutputRequestToDma : out NiDmaOutputRequestToDma_t;

      
      
      bNiDmaOutputRequestFromDma : in NiDmaOutputRequestFromDma_t;

      bNiDmaOutputDataFromDma : in NiDmaOutputDataFromDma_t;

      
      
      

      
      
      
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
end DmaPortCommIfcOutputStream;


architecture structure of DmaPortCommIfcOutputStream is

  
  constant kSampleSize : integer := ActualSampleSize (SampleSizeInBits => kSampleWidth,
                                                      PeerToPeer => false,
                                                      FxpType => kFxpType);

  
  constant kFifoCountWidth : integer := Log2(kFifoDepth);

  signal bEmptyCount: unsigned(kFifoCountWidth-1 downto 0);
  signal bHostReadableFullCount : unsigned(31 downto 0);
  signal bStopChannelRequest : boolean;
  signal bReadResponseReceived : boolean;
  signal bOutStreamErrorStatus : boolean;
  signal bReadDataPushEnable, bReadDataPushEnableNx : boolean;

  
  signal bClearDisableIrq: boolean;
  signal bClearEnableIrq: boolean;
  signal bDisable: boolean;
  signal bDisabled: boolean;
  signal bDisabledStatusForHost: boolean;
  signal bDmaReset: boolean;
  signal bFifoUnderflow: boolean;
  signal bHostDisable: boolean;
  signal bHostEnable: boolean;
  signal bLinked: boolean;
  signal bMaxPktSize: unsigned(Log2(kOutputMaxTransfer)downto 0);
  signal bNumWriteSpaces: NiDmaOutputByteCount_t;
  signal bReportDisabledToDiagram: boolean;
  signal bReqWriteSpaces: unsigned(Log2(kOutputMaxTransfer)downto 0);
  signal bResetDmaChannel: boolean;
  signal bResetDmaChannelAndFifo: boolean;
  signal bResetDone: boolean;
  signal bResetFifo: boolean;
  signal bSatcrWriteStrobe: boolean;
  signal bSetEnableIrq: boolean;
  signal bStartChannelRequest: boolean;
  signal bState: StreamStateValue_t;
  signal bStateInDefaultClkDomain: StreamStateValue_t;
  

begin

  bOutputStreamInterfaceToFifo.DmaReset <= bDmaReset or bResetFifo;
  bOutputStreamInterfaceToFifo.FifoWrite <= bNiDmaOutputDataFromDma.Push
    when (bReadDataPushEnable and (not bOutStreamErrorStatus)) and
      bNiDmaOutputDataFromDma.DmaChannel(kStreamNumber) else false;

  bOutputStreamInterfaceToFifo.WriteLengthInBytes <= bNiDmaOutputDataFromDma.ByteCount;
  bOutputStreamInterfaceToFifo.FifoData <= bNiDmaOutputDataFromDma.Data;
  bOutputStreamInterfaceToFifo.RsrvWriteSpaces <= bSatcrWriteStrobe;
  bOutputStreamInterfaceToFifo.NumWriteSpaces <= resize(bNumWriteSpaces,
    bOutputStreamInterfaceToFifo.NumWriteSpaces'length);
  bOutputStreamInterfaceToFifo.StreamState <= bState;
  bOutputStreamInterfaceToFifo.ReportDisabledToDiagram <= bReportDisabledToDiagram;
  bOutputStreamInterfaceToFifo.ByteEnable <= bNiDmaOutputDataFromDma.ByteEnable
    when (bReadDataPushEnable and (not bOutStreamErrorStatus)) and 
      bNiDmaOutputDataFromDma.DmaChannel(kStreamNumber) else (others => false);

  bResetDone <= bOutputStreamInterfaceFromFifo.ResetDone;
  bEmptyCount <= resize(bOutputStreamInterfaceFromFifo.EmptyCount, bEmptyCount'length);
  bFifoUnderflow <= bOutputStreamInterfaceFromFifo.FifoUnderflow;
  bStartChannelRequest <= bOutputStreamInterfaceFromFifo.StartStreamRequest;
  bStopChannelRequest <= bOutputStreamInterfaceFromFifo.StopStreamRequest;
  bHostReadableFullCount <= bOutputStreamInterfaceFromFifo.HostReadableFullCount;
  bStateInDefaultClkDomain <= bOutputStreamInterfaceFromFifo.StateInDefaultClkDomain;

  
  
  bReadResponseReceived <= bNiDmaOutputDataFromDma.TransferEnd when
                             bNiDmaOutputDataFromDma.DmaChannel(kStreamNumber) and
                             bNiDmaOutputDataFromDma.Push
                            else false;

  bOutStreamErrorStatus <= bNiDmaOutputDataFromDma.ErrorStatus when
                             bNiDmaOutputDataFromDma.DmaChannel(kStreamNumber) and
                             bNiDmaOutputDataFromDma.Push 
                           else false;

  
  
  bResetDmaChannel <= bReset or bDmaReset;

  
  bResetDmaChannelAndFifo <= bResetDmaChannel or bResetFifo;

  
  
  
  
  PushEnableReg: process (aReset, BusClk) is
  begin

    if aReset then
      bReadDataPushEnable <= false;
    elsif rising_edge(BusClk) then
      if bReset then
        bReadDataPushEnable <= false;
      else
        bReadDataPushEnable <= bReadDataPushEnableNx;
      end if;
    end if;

  end process;

  PushEnable: process (bOutStreamErrorStatus, bDisabled, bReadDataPushEnable)
  begin

    if bOutStreamErrorStatus then
       bReadDataPushEnableNx <= false;
    else
      if bDisabled then
         bReadDataPushEnableNx <= true;
      else
        bReadDataPushEnableNx <= bReadDataPushEnable;
      end if;
    end if;

  end process;

  
  
  
  
  
  
  DmaPortCommIfcOutputControllerx: entity work.DmaPortCommIfcOutputController (rtl)
    generic map (
      kStreamNumber     => kStreamNumber,    
      kSampleSizeInBits => kSampleSize,      
      kFifoCountWidth   => kFifoCountWidth,  
      kFxpType          => kFxpType)         
    port map (
      aReset                => aReset,                      
      bReset                => bResetDmaChannelAndFifo,     
      BusClk                => BusClk,                      
      bRequestAcknowledge   => bNiDmaOutputRequestFromDma,  
      bOutputRequest        => bNiDmaOutputRequestToDma,    
      bReadResponseReceived => bReadResponseReceived,       
      bArbiterNormalReq     => bArbiterNormalReq,           
      bArbiterEmergencyReq  => bArbiterEmergencyReq,        
      bArbiterDone          => bArbiterDone,                
      bArbiterGrant         => bArbiterGrant,               
      bMaxPktSize           => bMaxPktSize,                 
      bFifoEmptyCount       => bEmptyCount,                 
      bNumWriteSpaces       => bNumWriteSpaces,             
      bSatcrWriteStrobe     => bSatcrWriteStrobe,           
      bReqWriteSpaces       => bReqWriteSpaces,             
      bDisable              => bDisable,                    
      bDisabled             => bDisabled);                  



  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  DmaPortCommIfcRegistersx: entity work.DmaPortCommIfcRegisters (behavior)
    generic map (
      kBaseOffset       => kBaseOffset,         
      kInputStream      => false,               
      kPeerToPeerStream => false,               
      kMaxTransfer      => kOutputMaxTransfer)  
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
      bStreamError               => bOutStreamErrorStatus,   
      bMaxPktSize                => bMaxPktSize,             
      bSatcrWriteStrobe          => bSatcrWriteStrobe,       
      bReqWriteSpaces            => bReqWriteSpaces,         
      bFifoCount                 => bHostReadableFullCount,  
      bPeerAddress               => open,                    
      bState                     => bState,                  
      bLinked                    => bLinked,                 
      bSatcrUpdatesEnabled       => open,                    
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
      bStreamError             => false,                     
      bStateInDefaultClkDomain => bStateInDefaultClkDomain); 


end structure;