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

  
  use work.PkgNiDmaConfig.all;

  
  
  use work.PkgCommIntConfiguration.all;

  use work.PkgDmaPortCommIfcArbiter.all;

entity DmaPortCommIfcSinkStreamTcrUpdateController is
    generic(

      
      kDataWidthInBits : positive := 64;

      
      kStreamNumber : natural;

      
      kFifoCountWidth : natural

    );
    port(

      
      
      aReset                : in boolean;

      
      
      
      bReset                : in boolean;

      BusClk                : in std_logic;

      
      
      

      
      
      bNiDmaInputRequestToDma : out NiDmaInputRequestToDma_t;

      
      
      bNiDmaInputRequestFromDma : in NiDmaInputRequestFromDma_t;

      bNiDmaInputDataFromDma : in NiDmaInputDataFromDma_t;

      bNiDmaInputDataToDma : out NiDmaInputDataToDma_t;

      bSatcrUpdateDataValid : out boolean;

      
      
      

      
      
      
      bArbiterNormalReq     : out std_logic;

      
      
      
      bArbiterEmergencyReq  : out std_logic;

      
      
      
      
      bArbiterDone          : out std_logic;

      
      
      bArbiterGrant         : in std_logic;

      
      
      

      
      
      bFifoEmptyCount       : in unsigned(kFifoCountWidth-1 downto 0);

      
      
      bSatcrWriteStrobe     : out boolean;

      
      
      bReqWriteSpaces       : out unsigned(kFifoCountWidth-1 downto 0);

      
      
      

      
      
      bTcrAddress           : in NiDmaAddress_t;

      
      
      

      
      
      
      bDisable              : in boolean;

      
      
      
      bDisabled             : out boolean;

      
      
      
      bSatcrUpdatesEnabled  : in boolean

    );
end DmaPortCommIfcSinkStreamTcrUpdateController;


architecture rtl of DmaPortCommIfcSinkStreamTcrUpdateController is

  constant kChannel : NiDmaGeneralChannel_t := 
    to_unsigned(kStreamNumber, NiDmaGeneralChannel_t'length);

  
  
  
  signal bInputRequestLoc, bInputRequestNx : NiDmaInputRequestToDma_t;
  signal bSatcrWriteStrobeLoc : boolean;
  signal bReqWriteSpacesLoc : unsigned(kFifoCountWidth-1 downto 0);
  signal bArbiterDoneNx : std_logic;
  signal bArbiterDoneLcl : std_logic;

  
  
  
  signal bSatcrUpdateRequest : NiDmaInputRequestToDma_t;
  signal bReqWriteSpacesLocNx : unsigned(kFifoCountWidth-1 downto 0);
  signal bSatcrWriteStrobeLocNx : boolean;
  signal bArbiterNormalReqNx, bArbiterEmergencyReqNx : std_logic;
  signal bArbiterRequestForRead : boolean;
  signal bFifoEmptyCountInBytes : unsigned(31 downto 0);
  signal bEnableArbiterRequests : boolean;
  signal bPopData : boolean;
  signal bArbiterGrantQual : std_logic;


  
  
  
  type TcrUpdateState_t is (

    
    
    Disabled,

    
    
    
    Idle,


    
    
    
    WaitForArbiter,


    
    
    SendSatcrUpdateRequest,

    
    
    
    
    
    WaitForPop

  );

  signal bTcrUpdateStateNx, bTcrUpdateState : TcrUpdateState_t := Disabled;


begin

  bNiDmaInputRequestToDma <= bInputRequestLoc;
  bReqWriteSpaces <= bReqWriteSpacesLoc;
  bSatcrWriteStrobe <= bSatcrWriteStrobeLoc;
  bArbiterDone <= bArbiterDoneLcl;
  
  
  
  
  bArbiterGrantQual <= bArbiterGrant and not bArbiterDoneLcl;


  process(BusClk, aReset)
  begin

    if aReset then

      bFifoEmptyCountInBytes <= (others => '0');

    elsif rising_edge(BusClk) then

      if bSatcrWriteStrobeLoc then

        bFifoEmptyCountInBytes <= shift_left(resize(bReqWriteSpacesLoc,
          bFifoEmptyCountInBytes'length), Log2(kDataWidthInBits)-3);

      end if;

    end if;

  end process;

  
  StateRegs: process(BusClk, aReset)
  begin

    if(aReset) then

      
      bTcrUpdateState <= Disabled;
      bInputRequestLoc <= kNiDmaInputRequestToDmaZero;
      bReqWriteSpacesLoc <= (others=>'0');
      bSatcrWriteStrobeLoc <= false;
      bArbiterDoneLcl <= '0';

    elsif(rising_edge(BusClk)) then

      
      

      if(bReset) then

        bTcrUpdateState <= Disabled;
        bInputRequestLoc <= kNiDmaInputRequestToDmaZero;
        bReqWriteSpacesLoc <= (others=>'0');
        bSatcrWriteStrobeLoc <= false;
        bArbiterDoneLcl <= '0';

      else

        bTcrUpdateState <= bTcrUpdateStateNx;
        bInputRequestLoc <= bInputRequestNx;
        bReqWriteSpacesLoc <= bReqWriteSpacesLocNx;
        bSatcrWriteStrobeLoc <= bSatcrWriteStrobeLocNx;
        bArbiterDoneLcl <= bArbiterDoneNx;

      end if;

    end if;

  end process StateRegs;


  
  
  
  
  
  
  

  
  DmaNextStateLogic: process(bTcrUpdateState, bInputRequestLoc, bDisable,
                             bArbiterNormalReqNx, bArbiterEmergencyReqNx,
                             bArbiterGrantQual, bFifoEmptyCount, bTcrAddress,
                             bSatcrUpdatesEnabled, bSatcrWriteStrobeLoc,
                             bSatcrUpdateRequest, bNiDmaInputRequestFromDma,
                             bPopData)
  begin

    
    bTcrUpdateStateNx <= bTcrUpdateState;
    bInputRequestNx <= kNiDmaInputRequestToDmaZero;
    bReqWriteSpacesLocNx <= (others=>'0');
    bSatcrWriteStrobeLocNx <= false;
    bArbiterDoneNx <= '0';
    bDisabled <= false;
    bArbiterRequestForRead <= false;
    bEnableArbiterRequests <= false;

    case bTcrUpdateState is

      
      
      
      
      when Disabled =>

        
        bDisabled <= true;

        
        if not bDisable then
          bTcrUpdateStateNx <= Idle;
          bEnableArbiterRequests <= true;
        end if;

        if bArbiterGrantQual = '1' then
          bArbiterDoneNx <= '1';
        end if;

      
      
      
      
      
      when Idle =>

        bEnableArbiterRequests <= true;

        
        
        
        
        if bDisable then

          if bSatcrUpdatesEnabled then
            bTcrUpdateStateNx <= WaitForArbiter;
            bArbiterRequestForRead <= true;
          else
            bTcrUpdateStateNx <= Disabled;
          end if;

          bEnableArbiterRequests <= false;

        
        
        
        elsif bSatcrUpdatesEnabled and (bArbiterNormalReqNx = '1' or
          bArbiterEmergencyReqNx = '1') then

          bTcrUpdateStateNx <= WaitForArbiter;

        
        
        
        
        
        elsif not bDisable and not bSatcrUpdatesEnabled then

          
          
          
          
          if not bSatcrWriteStrobeLoc then
            bReqWriteSpacesLocNx <= bFifoEmptyCount;
            bSatcrWriteStrobeLocNx <= true;
          end if;

        end if;

        if bArbiterGrantQual = '1' then
          bArbiterDoneNx <= '1';
        end if;


      
      
      
      
      when WaitForArbiter =>

        bEnableArbiterRequests <= true;

        
        if bDisable then
          bTcrUpdateStateNx <= Disabled;
          bEnableArbiterRequests <= false;
        end if;

        if bArbiterGrantQual = '1' then

          bTcrUpdateStateNx <= SendSatcrUpdateRequest;
          bInputRequestNx <= bSatcrUpdateRequest;

          bReqWriteSpacesLocNx <= bFifoEmptyCount;
          bSatcrWriteStrobeLocNx <= true;

        end if;


      
      
      
      
      when SendSatcrUpdateRequest =>

        if bNiDmaInputRequestFromDma.Acknowledge then
          bArbiterDoneNx <= '1';
          if bPopData then
            bTcrUpdateStateNx <= Idle;
          else
            bTcrUpdateStateNx <= WaitForPop;
          end if;
        else
          bInputRequestNx <= bInputRequestLoc;

        end if;

      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      when WaitForPop =>
        if bPopData then
          bTcrUpdateStateNx <= Idle;
        end if;

      when Others =>

        bTcrUpdateStateNx <= Idle;

    end case;

  end process DmaNextStateLogic;


  
  
  
    bSatcrUpdateRequest.Request <= true;
    bSatcrUpdateRequest.Space <= kNiDmaSpaceDirectSysMem;
    bSatcrUpdateRequest.Channel <= kChannel;
    bSatcrUpdateRequest.Address <= bTcrAddress;
    bSatcrUpdateRequest.Baggage <= (others => '0');
    bSatcrUpdateRequest.ByteSwap <= (others => '0');
    bSatcrUpdateRequest.ByteLane <= (others => '0');
    bSatcrUpdateRequest.ByteCount <= to_unsigned(4, bSatcrUpdateRequest.ByteCount'length);
    bSatcrUpdateRequest.Done <= false;
    bSatcrUpdateRequest.EndOfRecord <= false;


  
  
  
  
  
  
  HandleArbiterRequests: block is

    signal bFifoHalfEmpty, bFifoQuarterEmpty : boolean;

  begin

    
    
    
    
    
    
    
    
    
    
    
    bArbiterNormalReqNx <= to_stdlogic(bFifoQuarterEmpty and not bDisable and
      bSatcrUpdatesEnabled and bEnableArbiterRequests);
    bArbiterEmergencyReqNx <= to_stdlogic((bFifoHalfEmpty and not bDisable and
      bSatcrUpdatesEnabled and bEnableArbiterRequests) or bArbiterRequestForRead);


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

    
    
    bFifoQuarterEmpty <= bFifoEmptyCount(bFifoEmptyCount'left) = '1' or
                         bFifoEmptyCount(bFifoEmptyCount'left-1) = '1';
    bFifoHalfEmpty <= bFifoEmptyCount(bFifoEmptyCount'left) = '1';

  end block HandleArbiterRequests;


  
  
  
  
  
  
  
  DelayStagesBlk: block

    signal bDataDelayedArray : NiDmaInputDataToDmaArray_t(
      0 to ArbVecMSB(kFifoReadLatency));

    signal bPopDelayedArray : BooleanVector(0 to kFifoReadLatency-1);

  begin

    NoDelayStages: if kFifoReadLatency = 0 generate

      bNiDmaInputDataToDma.Data <=
        std_logic_vector(resize(bFifoEmptyCountInBytes, kNiDmaDataWidth));

    end generate;

    DelayStages: if kFifoReadLatency > 0 generate

      InputDataLatency: for i in bDataDelayedArray'range generate

        DataDelayStage: process (aReset, BusClk) is
        begin

          if aReset then
            bDataDelayedArray(i).Data <= (others => '0');
          elsif rising_edge(BusClk) then

            if i = 0 then
              bDataDelayedArray(i).Data <=
                std_logic_vector(resize(bFifoEmptyCountInBytes, kNiDmaDataWidth));
            else
              bDataDelayedArray(i)<= bDataDelayedArray(i-1);
            end if;

          end if;

        end process;

      end generate InputDataLatency;

      bNiDmaInputDataToDma.Data <= bDataDelayedArray(kFifoReadLatency-1).Data;

    end generate DelayStages;

    bPopData <= bNiDmaInputDataFromDma.Pop when
      bNiDmaInputDataFromDma.DirectChannel(kStreamNumber) else false;

    
    
    PopDelay: for i in bPopDelayedArray'range generate

    begin

      PopDelayStage: process (aReset, BusClk) is
      begin
        if aReset then
          bPopDelayedArray(i) <= false;
        elsif rising_edge(BusClk) then

          if i = 0 then
            bPopDelayedArray(i) <= bPopData;
          else
            bPopDelayedArray(i)<= bPopDelayedArray(i-1);
          end if;

        end if;

      end process;

    end generate PopDelay;

    
    
    bSatcrUpdateDataValid <= bPopDelayedArray(kFifoReadLatency-1);

  end block DelayStagesBlk;

end architecture rtl;