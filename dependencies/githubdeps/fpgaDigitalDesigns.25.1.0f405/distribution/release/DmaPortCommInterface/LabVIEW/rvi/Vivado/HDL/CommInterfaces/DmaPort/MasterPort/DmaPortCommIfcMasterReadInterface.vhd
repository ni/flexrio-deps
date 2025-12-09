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

  
  use work.PkgDmaPortDmaFifos.all;

  
  use work.PkgDmaPortCommIfcStreamStates.all;

  
  
  use work.PkgNiDma.all;

  
  use work.PkgNiDmaConfig.all;

  
  use work.PkgCommIntConfiguration.all;

  
  use work.PkgDmaPortCommIfcMasterPort.all;

entity DmaPortCommIfcMasterReadInterface is
    generic(

      kReadMasterPortNumber : natural := 1

    );
    port(

      
      aReset : in boolean;

      
      
      

      
      BusClk : in std_logic;

      
      
      

      bNiFpgaMasterReadRequestToDma : out NiDmaOutputRequestToDma_t;
      bNiFpgaMasterReadRequestFromDma : in NiDmaOutputRequestFromDma_t;
      bNiFpgaMasterReadDataFromDma : in NiDmaOutputDataFromDma_t;

      
      
      

      bNiFpgaMasterReadRequestFromMaster : in NiFpgaMasterReadRequestFromMaster_t;
      bNiFpgaMasterReadRequestToMaster : out NiFpgaMasterReadRequestToMaster_t;
      bNiFpgaMasterReadDataToMaster : out NiFpgaMasterReadDataToMaster_t;

      
      
      

      
      
      bMasterReadArbiterReq     : out std_logic;

      
      
      
      
      bMasterReadArbiterDone    : out std_logic;

      
      
      
      bMasterReadArbiterGrant    : in  std_logic

    );
end DmaPortCommIfcMasterReadInterface;


architecture rtl of DmaPortCommIfcMasterReadInterface is

  
  constant kChannel : NiDmaGeneralChannel_t := to_unsigned(kReadMasterPortNumber,
    NiDmaGeneralChannel_t'length);

  signal bNiFpgaMasterReadRequestToDmaNx, bNiFpgaMasterReadRequestToDmaLcl :
    NiDmaOutputRequestToDma_t;

  type ReadRequestState_t is (
  
  
  
  Idle,

  
  
  
  WaitForArbiter,

  
  
  
  SendRequest);

  signal bReadRequestState, bReadRequestStateNx : ReadRequestState_t := Idle;

begin

  StateReg: process (aReset, BusClk) is
  begin

    if aReset then

      bReadRequestState <= Idle;
      bNiFpgaMasterReadRequestToDmaLcl <= kNiDmaOutputRequestToDmaZero;

    elsif rising_edge(BusClk) then

      bReadRequestState <= bReadRequestStateNx;
      bNiFpgaMasterReadRequestToDmaLcl <= bNiFpgaMasterReadRequestToDmaNx;

    end if;

  end process StateReg;

  bNiFpgaMasterReadRequestToDma <= bNiFpgaMasterReadRequestToDmaLcl;

  
  
  
  
  
  

  ReadRequestNextStateLogic: process (bReadRequestState, 
    bNiFpgaMasterReadRequestFromMaster, bMasterReadArbiterGrant,
    bNiFpgaMasterReadRequestToDmaLcl, bNiFpgaMasterReadRequestFromDma) is
  begin

    
    bReadRequestStateNx <= bReadRequestState;
    bMasterReadArbiterReq <= '0';
    bMasterReadArbiterDone <= '0';
    bNiFpgaMasterReadRequestToDmaNx <= kNiDmaOutputRequestToDmaZero;
    bNiFpgaMasterReadRequestToMaster.Acknowledge <= false;

    case bReadRequestState is

      when Idle =>

        if bNiFpgaMasterReadRequestFromMaster.Request then
          bMasterReadArbiterReq <= '1';
          bReadRequestStateNx <= WaitForArbiter;
        end if;

      when WaitForArbiter =>

        bMasterReadArbiterReq <= '1';

        if bMasterReadArbiterGrant = '1' then

          bNiFpgaMasterReadRequestToDmaNx.Request <=
            bNiFpgaMasterReadRequestFromMaster.Request;
          bNiFpgaMasterReadRequestToDmaNx.Space <=
            bNiFpgaMasterReadRequestFromMaster.Space;
          bNiFpgaMasterReadRequestToDmaNx.Channel <= kChannel;
          bNiFpgaMasterReadRequestToDmaNx.Address <=
            bNiFpgaMasterReadRequestFromMaster.Address;
          bNiFpgaMasterReadRequestToDmaNx.Baggage <=
            bNiFpgaMasterReadRequestFromMaster.Baggage;
          bNiFpgaMasterReadRequestToDmaNx.ByteSwap <=
            bNiFpgaMasterReadRequestFromMaster.ByteSwap;
          bNiFpgaMasterReadRequestToDmaNx.ByteLane <=
            bNiFpgaMasterReadRequestFromMaster.ByteLane;
          bNiFpgaMasterReadRequestToDmaNx.ByteCount <=
            bNiFpgaMasterReadRequestFromMaster.ByteCount;
          bNiFpgaMasterReadRequestToDmaNx.Done <= false;
          bNiFpgaMasterReadRequestToDmaNx.EndOfRecord <= false;

          bReadRequestStateNx <= SendRequest;

        end if;

      when SendRequest =>

        if bNiFpgaMasterReadRequestFromDma.Acknowledge then
          bMasterReadArbiterDone <= '1';
          bReadRequestStateNx <= Idle;
          bNiFpgaMasterReadRequestToMaster.Acknowledge <= true;
        else

          bMasterReadArbiterReq <= '1';
          bNiFpgaMasterReadRequestToDmaNx <= bNiFpgaMasterReadRequestToDmaLcl;

        end if;

    end case;

  end process ReadRequestNextStateLogic;

  
  
  ReadDataFromDmaDecode: process (aReset, BusClk) is
  begin
    if aReset then
      bNiFpgaMasterReadDataToMaster <= kNiFpgaMasterReadDataToMasterZero;
    elsif rising_edge(BusClk) then

      if bNiFpgaMasterReadDataFromDma.DirectChannel(kReadMasterPortNumber) then

        bNiFpgaMasterReadDataToMaster.TransferStart <=
          bNiFpgaMasterReadDataFromDma.TransferStart;
        bNiFpgaMasterReadDataToMaster.TransferEnd <= 
          bNiFpgaMasterReadDataFromDma.TransferEnd;
        bNiFpgaMasterReadDataToMaster.Space <= bNiFpgaMasterReadDataFromDma.Space;
        bNiFpgaMasterReadDataToMaster.ByteLane <= bNiFpgaMasterReadDataFromDma.ByteLane;
        bNiFpgaMasterReadDataToMaster.ByteCount <= bNiFpgaMasterReadDataFromDma.ByteCount;
        bNiFpgaMasterReadDataToMaster.ByteEnable <=
          bNiFpgaMasterReadDataFromDma.ByteEnable;
        bNiFpgaMasterReadDataToMaster.ErrorStatus <=
          bNiFpgaMasterReadDataFromDma.ErrorStatus;
        bNiFpgaMasterReadDataToMaster.Push <= bNiFpgaMasterReadDataFromDma.Push;
        bNiFpgaMasterReadDataToMaster.Data <= bNiFpgaMasterReadDataFromDma.Data;
      else
        bNiFpgaMasterReadDataToMaster <= kNiFpgaMasterReadDataToMasterZero;
      end if;

    end if;
  end process ReadDataFromDmaDecode;


end rtl;