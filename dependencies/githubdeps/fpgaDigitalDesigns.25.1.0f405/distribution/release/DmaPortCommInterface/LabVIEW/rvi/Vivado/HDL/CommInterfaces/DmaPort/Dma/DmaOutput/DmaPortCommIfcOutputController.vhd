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

  use work.PkgNiDma.all;

  use work.PkgCommIntConfiguration.all;

entity DmaPortCommIfcOutputController is
    generic(

      
      kStreamNumber        : natural := 0;

      
      kSampleSizeInBits     : positive := 64;

      
      kFifoCountWidth      : natural;

      
      kFxpType             : boolean  := false

    );
    port(

      
      
      aReset                : in boolean;

      
      
      bReset                : in boolean;

      
      
      BusClk                : in std_logic;

      
      
      

      
      
      bRequestAcknowledge   : in NiDmaOutputRequestFromDma_t;

      
      
      
      bOutputRequest        : out NiDmaOutputRequestToDma_t;

      
      
      bReadResponseReceived : in boolean;

      
      
      

      
      
      
      bArbiterNormalReq       : out std_logic;

      
      
      
      bArbiterEmergencyReq    : out std_logic;

      
      
      
      
      bArbiterDone            : out std_logic;

      
      
      bArbiterGrant           : in std_logic;

      
      
      

      
      
      
      
      
      bMaxPktSize    : in NiDmaOutputByteCount_t;

      
      
      

      
      
      bFifoEmptyCount       : in unsigned(kFifoCountWidth-1 downto 0);

      
      
      bNumWriteSpaces       : out NiDmaOutputByteCount_t;

      
      
      bSatcrWriteStrobe     : out boolean;

      
      
      
      bReqWriteSpaces       : out NiDmaOutputByteCount_t;

      
      
      

      
      
      
      bDisable                 : in boolean;

      
      
      bDisabled                : out boolean

    );
end DmaPortCommIfcOutputController;


architecture rtl of DmaPortCommIfcOutputController is

  
  
  

  
  constant kSampleShift : natural := Log2(kSampleSizeInBits)-3;

  constant kChannel : NiDmaGeneralChannel_t :=
    to_unsigned(kStreamNumber, bOutputRequest.Channel'length);

  signal bByteLane, bByteLaneNx : NiDmaByteLane_t;
  signal bOutputRequestLcl, bOutputRequestNx : NiDmaOutputRequestToDma_t;
  signal bReqWriteSpacesLcl, bReqWriteSpacesNx : NiDmaOutputByteCount_t;

  signal bSatcrWriteStrobeNx : boolean;
  signal bArbiterRequestEnable : boolean;
  signal bPacketLength : NiDmaOutputByteCount_t;
  signal bArbiterNormalReqNx, bArbiterEmergencyReqNx : std_logic;
  signal bCanRequestArbiterNormal, bCanRequestArbiterEmergency : boolean;
  signal bAllReadsReceived : boolean;
  signal bReadRequested : boolean;
  signal bArbiterDoneNx : std_logic;
  signal bArbiterDoneLcl : std_logic;
  signal bArbiterGrantQual : std_logic;

  
  
  
  type DmaOutputRequestState_t is (

    
    
    Idle,


    
    
    
    
    
    Enabled,


    
    
    SendDataRequest,


    
    
    
    Hold,


    
    
    
    
    
    
    Disabling

  );

  signal bDmaOutputRequestStateNx, bDmaOutputRequestState : DmaOutputRequestState_t;
  signal bDmaOutputRequestStatePrev : DmaOutputRequestState_t;
  signal bFifoEmptyCountReg    : unsigned(kFifoCountWidth-1 downto 0) := (others => '0');


begin

  bOutputRequest <= bOutputRequestLcl;
  bReqWriteSpaces <= bReqWriteSpacesLcl;
  bNumWriteSpaces <= shift_right(bOutputRequestLcl.ByteCount, kSampleShift);
  bArbiterDone <= bArbiterDoneLcl;
  
  
  
  
  bArbiterGrantQual <= bArbiterGrant and not bArbiterDoneLcl;

  
  
  
  
  FifoResetRegs: process(BusClk, aReset)
  begin

    if aReset then
      bByteLane <= (others=>'0');
    elsif rising_edge(BusClk) then
      if bReset then
        bByteLane <= (others=>'0');
      else
        bByteLane <= bByteLaneNx;
      end if;
    end if;

  end process FifoResetRegs;

  
  StateRegs: process(BusClk, aReset)
  begin

    if(aReset) then

      
      bDmaOutputRequestState <= Idle;

      bSatcrWriteStrobe <= false;
      bOutputRequestLcl <= kNiDmaOutputRequestToDmaZero;
      bReqWriteSpacesLcl <= (others=>'0');
      bArbiterDoneLcl <= '0';
      bDmaOutputRequestStatePrev <= Idle;

    elsif(rising_edge(BusClk)) then

      
      

      if(bReset) then

        bDmaOutputRequestState <= Idle;
        bDmaOutputRequestStatePrev <= Idle;

        bSatcrWriteStrobe <= false;
        bOutputRequestLcl <= kNiDmaOutputRequestToDmaZero;
        bArbiterDoneLcl <= '0';

      else

        bDmaOutputRequestState <= bDmaOutputRequestStateNx;
        bDmaOutputRequestStatePrev <= bDmaOutputRequestState;

        bSatcrWriteStrobe <= bSatcrWriteStrobeNx;
        bOutputRequestLcl <= bOutputRequestNx;
        bReqWriteSpacesLcl <= bReqWriteSpacesNx;
        bArbiterDoneLcl <= bArbiterDoneNx;

      end if;

    end if;

  end process StateRegs;

  
  
  
  
  
  
  

  
  DmaNextStateLogic: process(bDmaOutputRequestState, bDisable, bMaxPktSize,
    bArbiterGrantQual, bPacketLength, bRequestAcknowledge, bAllReadsReceived,
    bByteLane, bOutputRequestLcl, bDmaOutputRequestStatePrev)
  begin

    
    bDmaOutputRequestStateNx <= bDmaOutputRequestState;

    bOutputRequestNx <= kNiDmaOutputRequestToDmaZero;

    bDisabled <= false;
    bArbiterRequestEnable <= false;
    bArbiterDoneNx <= '0';
    bSatcrWriteStrobeNx <= false;
    bReadRequested <= false;
    bByteLaneNx <= bByteLane;
    bReqWriteSpacesNx <= (others=>'0');

    case bDmaOutputRequestState is

      
      
      
      
      when Idle =>

        
        
        if not bDisable and bMaxPktSize(bMaxPktSize'left downto
          kSampleShift) /= 0 then

          bDmaOutputRequestStateNx <= Enabled;

          
          
          bArbiterRequestEnable <= true;

        end if;

        
        
        if bArbiterGrantQual = '1' then
          bArbiterDoneNx <= '1';
        end if;

        
        bDisabled <= bDisable;


      
      
      
      
      
      
      when Enabled =>

        bArbiterRequestEnable <= true;

        
        
        if bDisable or bMaxPktSize(bMaxPktSize'left downto 
          kSampleShift) = 0 then

          bDmaOutputRequestStateNx <= Disabling;
          bArbiterRequestEnable <= false;

        
        
        elsif bArbiterGrantQual = '1' then

          bDmaOutputRequestStateNx <= SendDataRequest;

          
          
          bReqWriteSpacesNx <= resize(bPacketLength, bReqWriteSpaces'length);
          bSatcrWriteStrobeNx <= true;

          bOutputRequestNx.Request <= true;
          bOutputRequestNx.Space <= kNiDmaSpaceStream;
          bOutputRequestNx.Channel <= kChannel;
          bOutputRequestNx.Address <= (others => '0');
          bOutputRequestNx.Baggage <= (others => '0');
          bOutputRequestNx.ByteSwap <= (others => '0');
          bOutputRequestNx.ByteLane <= bByteLane;
          bOutputRequestNx.ByteCount <= bPacketLength;
          bOutputRequestNx.Done <= false;
          bOutputRequestNx.EndOfRecord <= false;

          

          
          
          bArbiterRequestEnable <= false;

        end if;


      
      
      
      
      when SendDataRequest =>

        if bDmaOutputRequestStatePrev=Enabled then
        
          
          
          bByteLaneNx <= resize(bByteLane + bOutputRequestLcl.ByteCount, bByteLaneNx'length);
          
        end if;
      
        
        
        bArbiterRequestEnable <= false;

        
        
        if bRequestAcknowledge.Acknowledge then

          bDmaOutputRequestStateNx <= Hold;
          bArbiterDoneNx <= '1';
          bReadRequested <= true;
        else

          bOutputRequestNx <= bOutputRequestLcl;
        end if;


      
      
      
      
      
      when Hold =>

        
        
        bArbiterRequestEnable <= false;
        bDmaOutputRequestStateNx <= Enabled;


      
      
      
      
      
      
      
      
      when Disabling =>

        if bArbiterGrantQual = '1' then
          bArbiterDoneNx <= '1';
        end if;

        
        
        
        if not bDisable and bMaxPktSize(bMaxPktSize'left downto 
          kSampleShift) /= 0 then

          bDmaOutputRequestStateNx <= Enabled;

          
          
          bArbiterRequestEnable <= true;

        elsif bAllReadsReceived then

          bDmaOutputRequestStateNx <= Idle;
        end if;

      when Others =>

    end case;

  end process DmaNextStateLogic;

  
  
  EmptyCountReg : process (aReset, BusClk)
  begin
    if aReset then
      bFifoEmptyCountReg <= (others => '0');
    elsif rising_edge(BusClk) then
      bFifoEmptyCountReg <= bFifoEmptyCount;
    end if;
  end process EmptyCountReg;
  
  
  
  
  
  
  
  
  
  
  GetPacketLength: process(bFifoEmptyCountReg, bMaxPktSize)
  begin

    if to_integer(bFifoEmptyCountReg) >= to_integer(bMaxPktSize(
      bMaxPktSize'left downto kSampleShift))
    then
      bPacketLength <= bMaxPktSize;
    else
      bPacketLength <= shift_left(resize(bFifoEmptyCountReg,
        bPacketLength'length), kSampleShift);
    end if;

  end process GetPacketLength;


  
  
  
  
  
  
  HandleArbiterRequests: block is

    signal bFifoHalfEmpty, bFifoQuarterEmpty : boolean;
    signal bFullPacketAvailable, bFullPacketAvailableLatched : boolean;

  begin

    
    
    
    
    
    
    
    
    
    
    
    bArbiterNormalReqNx <= to_stdlogic(bCanRequestArbiterNormal and
      bArbiterRequestEnable);
    bArbiterEmergencyReqNx <= to_stdlogic(bCanRequestArbiterEmergency and
      bArbiterRequestEnable);

    bCanRequestArbiterNormal <= bFifoQuarterEmpty or bFullPacketAvailable;
    bCanRequestArbiterEmergency <= bFifoHalfEmpty;


    process(aReset, BusClk)
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
    end process;

    
    
    bFifoQuarterEmpty <= bFifoEmptyCountReg(bFifoEmptyCountReg'left) = '1' or
                         bFifoEmptyCountReg(bFifoEmptyCountReg'left-1) = '1';
    bFifoHalfEmpty <= bFifoEmptyCountReg(bFifoEmptyCountReg'left) = '1';

    
    
    bFullPacketAvailable <= (bFifoEmptyCountReg >=
      bMaxPktSize(bMaxPktSize'left downto kSampleShift) and bMaxPktSize /= 0) or
      bFullPacketAvailableLatched;

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    LatchFullPacketAvailable: process(aReset, BusClk)
    begin
      if aReset then
        bFullPacketAvailableLatched <= false;
      elsif rising_edge(BusClk) then
        bFullPacketAvailableLatched <= bFullPacketAvailable and bArbiterRequestEnable;
      end if;
    end process LatchFullPacketAvailable;
      
  end block HandleArbiterRequests;

  
  
  
  
  
  OutstandingReadCounter: block is

    
    
    signal bReadCount : unsigned(bFifoEmptyCountReg'range);

  begin

    ReadCount: process(aReset, BusClk)
    begin
      if aReset then
        bReadCount <= (others=>'0');
      elsif rising_edge(BusClk) then

        
        
        if bReset then
          bReadCount <= (others=>'0');
        elsif bReadRequested and not bReadResponseReceived then
          bReadCount <= bReadCount + 1;
        elsif bReadResponseReceived and not bReadRequested then
          bReadCount <= bReadCount - 1;
        end if;

      end if;
    end process ReadCount;

    
    bAllReadsReceived <= bReadCount = 0;

  end block OutstandingReadCounter;

end architecture rtl;