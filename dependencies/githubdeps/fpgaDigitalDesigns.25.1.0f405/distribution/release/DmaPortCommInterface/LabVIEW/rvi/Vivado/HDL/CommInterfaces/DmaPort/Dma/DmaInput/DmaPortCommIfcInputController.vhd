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

  
  
  use work.PkgNiDma.all;

  
  
  use work.PkgCommunicationInterface.all;
  use work.PkgDmaPortCommunicationInterface.all;

  
  
  use work.PkgDmaPortDataPackingFifo.all;

  use work.PkgCommIntConfiguration.all;

entity DmaPortCommIfcInputController is
    generic(

      
      kStreamNumber : natural := 0;

      
      kSampleSizeInBits : positive := 64;

      
      kFifoCountWidth : natural;

      
      
      kEvictionTimeout : natural := 128;

      
      
      kPeerToPeerStream    : boolean := false
    );
    port(

      
      
      aReset                : in boolean;

      
      
      
      bReset                : in boolean;

      
      BusClk                : in std_logic;

      
      
      

      
      
      
      bInputRequest          : out NiDmaInputRequestToDma_t;

      
      
      bRequestAcknowledge    : in NiDmaInputRequestFromDma_t;

      
      
      
      
      bInputStatusReceived   : in boolean;
      
      
      

      
      
      
      
      bArbiterNormalReq     : out std_logic;

      
      
      
      
      bArbiterEmergencyReq  : out std_logic;

      
      
      
      
      bArbiterDone          : out std_logic;

      
      
      
      
      bArbiterGrant         : in std_logic;

      
      
      

      
      
      
      
      
      bMaxPktSize    : in NiDmaInputByteCount_t;

      
      
      

      
      
      bWriteDetected        : in boolean;

      
      
      bFifoFullCount        : in unsigned(kFifoCountWidth-1 downto 0);

      
      
      
      bNumReadSamples       : out NiDmaInputByteCount_t;

      
      
      
      
      
      
      bByteLanePtr          : in NiDmaByteLane_t;

      
      
      bRsrvReadSpaces       : out boolean;
      bFlushReq             : in boolean; 

      
      
      
      
      bResetFifo            : out boolean;

      
      
      bResetDone            : in boolean;

      
      
      

      
      
      
      bSatcrWriteStrobe     : out boolean;

      
      
      bReqWriteSpaces       : out NiDmaInputByteCount_t;

      
      
      
      bDisable              : in boolean;

      
      
      bDisabled             : out boolean;

      
      
      bClearSatcr           : out boolean

    );
end DmaPortCommIfcInputController;

architecture rtl of DmaPortCommIfcInputController is

  
  
  

  
  constant kSampleShift : natural := Log2(kSampleSizeInBits)-3;

  constant kChannel : NiDmaGeneralChannel_t := 
    to_unsigned(kStreamNumber, bInputRequest.Channel'length);

  
  constant kNiDmaInputRequestToDmaDone : NiDmaInputRequestToDma_t := (
    Request => true,
    Space => kNiDmaSpaceStream,
    Channel => kChannel,
    Address => (others => '0'),
    Baggage => (others => '0'),
    ByteSwap => (others => '0'),
    ByteLane => (others => '0'),
    ByteCount => (others => '0'),
    Done => true,
    EndOfRecord => false
  );
  
  
  

  
  signal bInputRequestLcl : NiDmaInputRequestToDma_t;
  signal bSatcrWriteStrobeLcl : boolean;
  signal bRsrvReadSpacesLcl : boolean;
  signal bArbiterDoneNx : std_logic;
  signal bArbiterDoneLcl : std_logic;

  
  
  
  signal bArbiterNormalReqNx, bArbiterEmergencyReqNx  : std_logic;
  signal bDoneArbiterRequest : boolean;
  signal bSatcrWriteStrobeNx : boolean;
  signal bSatcrWriteStrobeNxNx : boolean;
  signal bResetFifoNx : boolean;
  signal bInputRequestNx : NiDmaInputRequestToDma_t;
  signal bPacketLength, bPacketLengthNx : NiDmaInputByteCount_t;
  signal bAllInputStatusReceived : boolean;
  signal bInputRequestSent : boolean;
  signal bPacketLengthLoad : boolean;
  signal bRsrvReadSpacesNx : boolean;
  signal bArbiterGrantQual : std_logic;

  
  
  
  type DmaInputState_t is (

    
    
    
    DisableRequest,


    
    
    
    SendDoneRequest,

    
    
    
    WaitForData,


    
    
    
    
    Disabled,


    
    
    Idle,


    
    
    
    FifoClear,


    
    
    
    
    WaitForArbiter,


    
    
    
    PacketSetup,


    
    SendPacketRequest

  );

  signal bDmaInputStateNx, bDmaInputState : DmaInputState_t := Disabled;
  signal bFullCountNotYetUpdated : boolean := false;
  signal bFifoFullCountReg : unsigned(kFifoCountWidth-1 downto 0);

  
begin

  
  StateRegs: process(BusClk, aReset)
  begin

    if(aReset) then

      
      bDmaInputState <= Disabled;
      bSatcrWriteStrobeNx <= false;
      bSatcrWriteStrobeLcl <= false;
      bResetFifo <= false;
      bInputRequestLcl <= kNiDmaInputRequestToDmaZero;
      bRsrvReadSpacesLcl <= false;
      bArbiterDoneLcl <= '0';
      bFullCountNotYetUpdated <= false;
      bFifoFullCountReg <= (others => '0');

    elsif(rising_edge(BusClk)) then

      
      
      

      if(bReset) then

        bDmaInputState <= Disabled;
        bSatcrWriteStrobeNx <= false;
        bSatcrWriteStrobeLcl <= false;
        bResetFifo <= false;
        bInputRequestLcl <= kNiDmaInputRequestToDmaZero;
        bRsrvReadSpacesLcl <= false;
        bArbiterDoneLcl <= '0';
        bFullCountNotYetUpdated <= false;
        bFifoFullCountReg <= (others => '0');

      else

        bDmaInputState <= bDmaInputStateNx;
        bSatcrWriteStrobeNx <= bSatcrWriteStrobeNxNx;
        bSatcrWriteStrobeLcl <= bSatcrWriteStrobeNx;
        bResetFifo <= bResetFifoNx;
        bInputRequestLcl <= bInputRequestNx;
        bRsrvReadSpacesLcl <= bRsrvReadSpacesNx;       
        bArbiterDoneLcl <= bArbiterDoneNx;
        bFullCountNotYetUpdated <= bRsrvReadSpacesLcl;
        bFifoFullCountReg <= bFifoFullCount;

      end if;

    end if;

  end process StateRegs;

  bInputRequest <= bInputRequestLcl;
  bSatcrWriteStrobe <= bSatcrWriteStrobeLcl;
  bRsrvReadSpaces <= bRsrvReadSpacesLcl;
  bArbiterDone <= bArbiterDoneLcl;
  

  
  
  
  bArbiterGrantQual <= bArbiterGrant and not bArbiterDoneLcl;

  
  
  bReqWriteSpaces <= bInputRequestLcl.ByteCount;
  bNumReadSamples <= shift_right(bInputRequestLcl.ByteCount, kSampleShift);


  
  
  
  
  
  
  

  
  DmaNextStateLogic: process(bDmaInputState, bArbiterNormalReqNx, bInputRequestLcl,
    bArbiterEmergencyReqNx, bByteLanePtr, bPacketLength, bArbiterGrantQual, bDisable,
    bResetDone, bRequestAcknowledge, bAllInputStatusReceived)
  begin

    
    bDmaInputStateNx <= bDmaInputState;

    bArbiterDoneNx <= '0';
    bDoneArbiterRequest <= false;
    bDisabled <= false;
    bSatcrWriteStrobeNxNx <= false;
    bResetFifoNx <= false;
    bClearSatcr <= false;
    bInputRequestNx <= kNiDmaInputRequestToDmaZero;
    bInputRequestSent <= false;
    bPacketLengthLoad <= false;
    bRsrvReadSpacesNx <= false;

    case bDmaInputState is

      
      
      
      
      
      when DisableRequest =>

        bDoneArbiterRequest <= true;

        if bArbiterGrantQual = '1' then
          bDmaInputStateNx <= SendDoneRequest;
          bInputRequestNx <= kNiDmaInputRequestToDmaDone;
        end if;


      
      
      
      
      
      when SendDoneRequest =>

        if(bRequestAcknowledge.Acknowledge) then

          bDmaInputStateNx <= WaitForData;

          bArbiterDoneNx <= '1';
          bInputRequestSent <= true;
        else
          
          bInputRequestNx <= kNiDmaInputRequestToDmaDone;

        end if;


      
      
      
      
      
      
      when WaitForData =>
      
        if bAllInputStatusReceived then

          if not kPeerToPeerStream then
            bDmaInputStateNx <= FifoClear;
            bResetFifoNx <= true;
          else
            bDmaInputStateNx <= Disabled;
          end if;

        end if;


      
      
      
      
      
      
      when Disabled =>

        bDisabled <= true;

        
        if not bDisable then

          
          
          
          if kPeerToPeerStream then

            bDmaInputStateNx <= FifoClear;

            
            bResetFifoNx <= true;

            
            
            
            
            
            bClearSatcr <= true;

          else

            bDmaInputStateNx <= Idle;

          end if;

        end if;


      
      
      
      
      
      when FifoClear =>

        if kPeerToPeerStream then
          
          
          bDisabled <= true;
        end if;

        bResetFifoNx <= true;

        if bResetDone then
          bResetFifoNx <= false;

          
          
          if kPeerToPeerStream then
            bDmaInputStateNx <= Idle;
          else
            bDmaInputStateNx <= Disabled;
          end if;

        end if;


      
      
      
      
      when Idle =>

        if bDisable then
          bDoneArbiterRequest <= true;
          bDmaInputStateNx <= DisableRequest;
        elsif bArbiterNormalReqNx = '1' or bArbiterEmergencyReqNx = '1' then
          bDmaInputStateNx <= WaitForArbiter;
        end if;

        
        
        
        
        if bArbiterGrantQual = '1' and not bDisable then
          bArbiterDoneNx <= '1';
        end if;


      
      
      
      
      
      
      
      
      when WaitForArbiter =>

        
        if bDisable then
          bDmaInputStateNx <= DisableRequest;
          bDoneArbiterRequest <= true;

        
        elsif bArbiterNormalReqNx = '0' and bArbiterEmergencyReqNx = '0' then
          bDmaInputStateNx <= Idle;

        
        
        elsif(bArbiterGrantQual = '1') then

          bPacketLengthLoad <= true;
          
          
          bSatcrWriteStrobeNxNx <= true;

          bDmaInputStateNx <= PacketSetup;
        end if;

      
      
      
      
      when PacketSetup =>

        
        bRsrvReadSpacesNx <= true;

        
        bInputRequestNx.Request <= true;
        bInputRequestNx.Space <= kNiDmaSpaceStream;
        bInputRequestNx.Channel <= kChannel;
        bInputRequestNx.Address <= (others => '0');
        bInputRequestNx.Baggage <= (others => '0');
        bInputRequestNx.ByteSwap <= (others => '0');
        bInputRequestNx.ByteLane <= bByteLanePtr;
        bInputRequestNx.ByteCount <= bPacketLength;
        bInputRequestNx.Done <= false;
        bInputRequestNx.EndOfRecord <= false;

        bDmaInputStateNx <= SendPacketRequest;

      
      
      
      
      
      
      
      
      
      
      
      
      when SendPacketRequest =>

        if bRequestAcknowledge.Acknowledge then
          bArbiterDoneNx <= '1';
          bDmaInputStateNx <= Idle;
          bInputRequestSent <= true;

        else
          bInputRequestNx <= bInputRequestLcl;

        end if;

      when Others =>

        bDmaInputStateNx <= Idle;

    end case;

  end process DmaNextStateLogic;


  
  
  
  
  
  
  
  
  
  GetPacketLength: process(bFifoFullCountReg, bMaxPktSize)
  begin

    if bFifoFullCountReg >= bMaxPktSize(bMaxPktSize'left downto kSampleShift) then

      
      if kSampleShift > 0 then
        bPacketLengthNx <= bMaxPktSize(bMaxPktSize'left downto kSampleShift) &
          unsigned(Zeros(kSampleShift));
      else
        
        
        bPacketLengthNx <= bMaxPktSize;
      end if;

    else
      bPacketLengthNx <= shift_left(resize(bFifoFullCountReg,
        bPacketLengthNx'length), kSampleShift);
    end if;

  end process GetPacketLength;


  
  PacketLengthReg: process(aReset, BusClk)
  begin
  
    if aReset then
      bPacketLength <= (others=>'0');
    elsif rising_edge(BusClk) then
      if bPacketLengthLoad then
        bPacketLength <= bPacketLengthNx;
      end if;
    end if;
    
  end process PacketLengthReg;


  
  
  
  
  
  
  
  HandleArbiterRequests: block is

    signal bFifoHalfFull, bFifoQuarterFull : boolean;
    signal bFullPacketAvailable, bFullPacketAvailableLatched : boolean;
    signal bEnableRequest : boolean;

    signal bEvictionTimeoutFlag : boolean;
    signal bEvictionCounter : unsigned(Log2(kEvictionTimeout) downto 0);

  begin

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    
    
    bArbiterNormalReqNx <= to_stdlogic((bFullPacketAvailable or
      bFifoQuarterFull) and shift_right(bMaxPktSize, kSampleShift) /= 0 and
      bEnableRequest);
        bArbiterEmergencyReqNx <= to_stdlogic(((bFifoHalfFull or
      bEvictionTimeoutFlag or (bFlushReq and (bFifoFullCount > 0))) and shift_right(bMaxPktSize,kSampleShift) /= 0 and
      bEnableRequest) or (bDoneArbiterRequest and bArbiterGrantQual = '0')); 

    
    
    bEnableRequest <= (not bDisable) and bDmaInputState /= Disabled and
                      bDmaInputState /= FifoClear and (not bFullCountNotYetUpdated);

    
    
    
    
    
    
    
    
    

    RegisterArbiterReqs: process(aReset, BusClk)
    begin
      if aReset then
        bArbiterNormalReq <= '0';
        bArbiterEmergencyReq <= '0';
      elsif rising_edge(BusClk) then
        if bReset then
          bArbiterNormalReq <= '0';
          bArbiterEmergencyReq <= '0';
        else
          bArbiterNormalReq <= bArbiterNormalReqNx;
          bArbiterEmergencyReq <= bArbiterEmergencyReqNx;
        end if;
      end if;
    end process RegisterArbiterReqs;

    
    
    bFifoQuarterFull <= (bFifoFullCountReg(bFifoFullCountReg'left-1) = '1') or
                         (bFifoFullCountReg(bFifoFullCountReg'left) = '1');
    bFifoHalfFull <= bFifoFullCountReg(bFifoFullCountReg'left) = '1';

    
    
    bFullPacketAvailable <= ((bFifoFullCountReg >= 
      shift_right(bMaxPktSize, kSampleShift)) and
      (shift_right(bMaxPktSize, kSampleShift) /= 0)) or bFullPacketAvailableLatched;

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    LatchFullPacketAvailable: process(aReset, BusClk)
    begin
      if aReset then
        bFullPacketAvailableLatched <= false;
      elsif rising_edge(BusClk) then
        bFullPacketAvailableLatched <= bFullPacketAvailable and bEnableRequest;
      end if;
    end process LatchFullPacketAvailable;
    
    
    
    
    
    bEvictionTimeoutFlag <= bEvictionCounter >= kEvictionTimeout;


    
    
    
    
    
    
    
    
    
    
    
    TimeoutCounter: process(BusClk, aReset)
    begin
      if aReset then

        bEvictionCounter <= to_unsigned(0, bEvictionCounter'length);

      elsif rising_edge(BusClk) then

        if bReset then

          bEvictionCounter <= to_unsigned(0, bEvictionCounter'length);

        
        
        
        
        
        
        

        
        
        
        
        
        
        
        
        
        
        
        
        
        elsif (not bEvictionTimeoutFlag and bWriteDetected) or bDisable
          or bSatcrWriteStrobeLcl then

          bEvictionCounter <= to_unsigned(0, bEvictionCounter'length);

        
        
        elsif bFifoFullCountReg /= 0 and not bEvictionTimeoutFlag then

          bEvictionCounter <= bEvictionCounter + 1;

        end if;
      end if;
    end process TimeoutCounter;

  end block HandleArbiterRequests;


  
  
  
  
  
  OutstandingReadCounter: block is

    
    
    signal bInputStatusCount : unsigned(bFifoFullCountReg'range);

  begin

    InputStatusCount: process(aReset, BusClk)
    begin
      if aReset then
        bInputStatusCount <= (others=>'0');
      elsif rising_edge(BusClk) then

        
        
        if bReset then
          bInputStatusCount <= (others=>'0');
        elsif bInputRequestSent and not bInputStatusReceived then
          bInputStatusCount <= bInputStatusCount + 1;
        elsif bInputStatusReceived and not bInputRequestSent then
          bInputStatusCount <= bInputStatusCount - 1;
        end if;

      end if;
    end process InputStatusCount;

    
    bAllInputStatusReceived <= bInputStatusCount = 0;

  end block OutstandingReadCounter;

end architecture rtl;