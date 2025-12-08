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

  use work.PkgDmaPortCommunicationInterface.all;

  
  
  use work.PkgNiDma.all;

  
  use work.PkgNiDmaConfig.all;

  
  use work.PkgCommIntConfiguration.all;

  
  use work.PkgDmaPortCommIfcMasterPort.all;

  use work.PkgDmaPortCommIfcArbiter.all;

entity DmaPortCommIfcMasterWriteInterface is
    generic(

      kWriteMasterPortNumber : natural := 1

    );
    port(

      
      aReset : in boolean;

      
      
      

      
      BusClk : in std_logic;

      
      
      

      bNiFpgaMasterWriteRequestToDma : out NiDmaInputRequestToDma_t;
      bNiFpgaMasterWriteRequestFromDma : in NiDmaInputRequestFromDma_t;
      bNiFpgaMasterWriteDataFromDma : in NiDmaInputDataFromDma_t;
      bNiFpgaMasterWriteDataToDma : out NiDmaInputDataToDma_t;
      bNiFpgaMasterWriteStatusFromDma : in NiDmaInputStatusFromDma_t;

      
      
      
      bNiFpgaMasterWriteDataToDmaValid : out boolean;

      
      
      

      bNiFpgaMasterWriteRequestFromMaster : in NiFpgaMasterWriteRequestFromMaster_t;
      bNiFpgaMasterWriteRequestToMaster : out NiFpgaMasterWriteRequestToMaster_t;
      bNiFpgaMasterWriteDataFromMaster : in NiFpgaMasterWriteDataFromMaster_t;
      bNiFpgaMasterWriteDataToMaster : out NiFpgaMasterWriteDataToMaster_t;
      bNiFpgaMasterWriteStatusToMaster : out NiFpgaMasterWriteStatusToMaster_t;

      
      
      

      
      
      bMasterWriteArbiterReq    : out std_logic;

      
      
      
      
      bMasterWriteArbiterDone    : out std_logic;

      
      
      
      
      bMasterWriteArbiterGrant    : in  std_logic

    );
end DmaPortCommIfcMasterWriteInterface;


architecture rtl of DmaPortCommIfcMasterWriteInterface is

  
  
  constant kChannel : NiDmaGeneralChannel_t := to_unsigned(kWriteMasterPortNumber,
    NiDmaGeneralChannel_t'length);

  
  
  
  
  
  constant kNumberOfDelayStages : natural := kNiDmaInputDataReadLatency - 2;
  signal bDataDelayedArray : NiFpgaMasterWriteDataFromMasterArray_t(
    0 to ArbVecMSB(kNumberOfDelayStages));

  signal bPopDelayedArray : BooleanVector(0 to kNiDmaInputDataReadLatency-1);

  signal bMasterWriteDataToMasterLoc : NiFpgaMasterWriteDataToMaster_t;

  signal bNiFpgaMasterWriteRequestToDmaNx, bNiFpgaMasterWriteRequestToDmaLcl :
    NiDmaInputRequestToDma_t;

  type WriteRequestState_t is (
  
  
  
  Idle,

  
  
  
  WaitForArbiter,

  
  
  
  SendRequest);

  signal bWriteRequestState, bWriteRequestStateNx : WriteRequestState_t := Idle;

begin

  StateReg: process (aReset, BusClk) is
  begin

    if aReset then

      bWriteRequestState <= Idle;
      bNiFpgaMasterWriteRequestToDmaLcl <= kNiDmaInputRequestToDmaZero;

    elsif rising_edge(BusClk) then

      bWriteRequestState <= bWriteRequestStateNx;
      bNiFpgaMasterWriteRequestToDmaLcl <= bNiFpgaMasterWriteRequestToDmaNx;

    end if;

  end process StateReg;

  bNiFpgaMasterWriteRequestToDma <= bNiFpgaMasterWriteRequestToDmaLcl;

  
  
  
  
  
  

  WriteRequestNextStateLogic: process (bWriteRequestState, 
    bNiFpgaMasterWriteRequestFromMaster, bMasterWriteArbiterGrant,
    bNiFpgaMasterWriteRequestToDmaLcl, bNiFpgaMasterWriteRequestFromDma) is
  begin

    
    bWriteRequestStateNx <= bWriteRequestState;
    bMasterWriteArbiterReq <= '0';
    bMasterWriteArbiterDone <= '0';
    bNiFpgaMasterWriteRequestToDmaNx <= kNiDmaInputRequestToDmaZero;
    bNiFpgaMasterWriteRequestToMaster.Acknowledge <= false;

    case bWriteRequestState is

      when Idle =>

        if bNiFpgaMasterWriteRequestFromMaster.Request then
          bMasterWriteArbiterReq <= '1';
          bWriteRequestStateNx <= WaitForArbiter;
        end if;

      when WaitForArbiter =>

        bMasterWriteArbiterReq <= '1';

        if bMasterWriteArbiterGrant = '1' then

          bNiFpgaMasterWriteRequestToDmaNx.Request <=
            bNiFpgaMasterWriteRequestFromMaster.Request;
          bNiFpgaMasterWriteRequestToDmaNx.Space <=
            bNiFpgaMasterWriteRequestFromMaster.Space;
          bNiFpgaMasterWriteRequestToDmaNx.Channel <= kChannel;
          bNiFpgaMasterWriteRequestToDmaNx.Address <=
            bNiFpgaMasterWriteRequestFromMaster.Address;
          bNiFpgaMasterWriteRequestToDmaNx.Baggage <=
            bNiFpgaMasterWriteRequestFromMaster.Baggage;
          bNiFpgaMasterWriteRequestToDmaNx.ByteSwap <=
            bNiFpgaMasterWriteRequestFromMaster.ByteSwap;
          bNiFpgaMasterWriteRequestToDmaNx.ByteLane <=
            bNiFpgaMasterWriteRequestFromMaster.ByteLane;
          bNiFpgaMasterWriteRequestToDmaNx.ByteCount <=
            bNiFpgaMasterWriteRequestFromMaster.ByteCount;
          bNiFpgaMasterWriteRequestToDmaNx.Done <= false;
          bNiFpgaMasterWriteRequestToDmaNx.EndOfRecord <= false;

          bWriteRequestStateNx <= SendRequest;

        end if;

      when SendRequest =>

        if bNiFpgaMasterWriteRequestFromDma.Acknowledge then
          bMasterWriteArbiterDone <= '1';
          bWriteRequestStateNx <= Idle;
          bNiFpgaMasterWriteRequestToMaster.Acknowledge <= true;
        else

          bMasterWriteArbiterReq <= '1';
          bNiFpgaMasterWriteRequestToDmaNx <= bNiFpgaMasterWriteRequestToDmaLcl;

        end if;

    end case;

  end process WriteRequestNextStateLogic;


  
  
  WriteDataFromDmaDecode: process (bNiFpgaMasterWriteDataFromDma) is
  begin

      if bNiFpgaMasterWriteDataFromDma.DirectChannel(kWriteMasterPortNumber) then

        bMasterWriteDataToMasterLoc.TransferStart <=
          bNiFpgaMasterWriteDataFromDma.TransferStart;
        bMasterWriteDataToMasterLoc.TransferEnd <= 
          bNiFpgaMasterWriteDataFromDma.TransferEnd;
        bMasterWriteDataToMasterLoc.Space <= bNiFpgaMasterWriteDataFromDma.Space;
        bMasterWriteDataToMasterLoc.ByteLane <= bNiFpgaMasterWriteDataFromDma.ByteLane;
        bMasterWriteDataToMasterLoc.ByteCount <=
          bNiFpgaMasterWriteDataFromDma.ByteCount;
        bMasterWriteDataToMasterLoc.ByteEnable <=
          bNiFpgaMasterWriteDataFromDma.ByteEnable;
        bMasterWriteDataToMasterLoc.Pop <= bNiFpgaMasterWriteDataFromDma.Pop;
      else
        bMasterWriteDataToMasterLoc <= kNiFpgaMasterWriteDataToMasterZero;
      end if;

  end process WriteDataFromDmaDecode;

  bNiFpgaMasterWriteDataToMaster <= bMasterWriteDataToMasterLoc;

  
  
  
  
  DelayStagesBlk: block
  begin

    NoDelayStages: if kNumberOfDelayStages = 0 generate

      bNiFpgaMasterWriteDataToDma.Data <= bNiFpgaMasterWriteDataFromMaster.Data;
      
    end generate;
      
    DelayStages: if kNumberOfDelayStages > 0 generate

      InputDataLatency: for i in bDataDelayedArray'range generate

        DataDelayStage: process (aReset, BusClk) is
        begin

          if aReset then
            bDataDelayedArray(i).Data <= (others => '0');
          elsif rising_edge(BusClk) then

            if i = 0 then
              bDataDelayedArray(i).Data <= bNiFpgaMasterWriteDataFromMaster.Data;
            else
              bDataDelayedArray(i)<= bDataDelayedArray(i-1);
            end if;

          end if;

        end process;

      end generate InputDataLatency;

      bNiFpgaMasterWriteDataToDma.Data <= bDataDelayedArray(kNumberOfDelayStages-1).Data;

    end generate DelayStages;

  end block DelayStagesBlk;

  
  
  PopDelay: for i in bPopDelayedArray'range generate

  begin

    PopDelayStage: process (aReset, BusClk) is
    begin
      if aReset then
        bPopDelayedArray(i) <= false;
      elsif rising_edge(BusClk) then

        if i = 0 then
          bPopDelayedArray(i) <= bMasterWriteDataToMasterLoc.Pop;
        else
          bPopDelayedArray(i)<= bPopDelayedArray(i-1);
        end if;

      end if;

    end process;

  end generate PopDelay;

  
  
  bNiFpgaMasterWriteDataToDmaValid <= bPopDelayedArray(kNiDmaInputDataReadLatency-1);

  
  
  WriteStatusDecode: process (aReset, BusClk) is
  begin

    if aReset then
      bNiFpgaMasterWriteStatusToMaster <= kNiFpgaMasterWriteStatusToMasterZero;
    elsif rising_edge(BusClk) then

      if bNiFpgaMasterWriteStatusFromDma.DirectChannel(kWriteMasterPortNumber) then

        bNiFpgaMasterWriteStatusToMaster.Ready <= bNiFpgaMasterWriteStatusFromDma.Ready;
        bNiFpgaMasterWriteStatusToMaster.Space <= bNiFpgaMasterWriteStatusFromDma.Space;
        bNiFpgaMasterWriteStatusToMaster.ByteCount <=
          bNiFpgaMasterWriteStatusFromDma.ByteCount;
        bNiFpgaMasterWriteStatusToMaster.ErrorStatus <=
          bNiFpgaMasterWriteStatusFromDma.ErrorStatus;
      else
        bNiFpgaMasterWriteStatusToMaster <= kNiFpgaMasterWriteStatusToMasterZero;
      end if;

    end if;

  end process WriteStatusDecode;


end rtl;