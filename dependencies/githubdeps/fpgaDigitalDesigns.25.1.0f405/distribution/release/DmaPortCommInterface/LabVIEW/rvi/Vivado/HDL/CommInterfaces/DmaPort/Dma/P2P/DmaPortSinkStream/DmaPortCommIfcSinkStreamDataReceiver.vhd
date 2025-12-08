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

  
  
  use work.PkgNiDma.all;

entity DmaPortCommIfcSinkStreamDataReceiver is
    generic(

      
      kFifoBaseOffset : natural;

      
      kWriteWindow : natural := 4096;

      
      
      kStreamNumber      : natural

    );
    port(

      
      
      aReset                : in boolean;

      
      
      
      bReset                : in boolean;

      BusClk                : in std_logic;

      
      
      

      bHighSpeedSink : in NiDmaHighSpeedSinkFromDma_t;

      
      
      

      
      bFifoWrite            : out boolean;

      
      
      bWriteLengthInBytes   : out NiDmaBusByteCount_t;

      
      bFifoData             : out NiDmaData_t;

      bByteEnable           : out NiDmaByteEnable_t;

      
      
      

      
      
      bDisable              : in boolean := true;

      
      
      bDisabled             : out boolean;

      
      
      
      bStreamError          : out boolean

    );
end DmaPortCommIfcSinkStreamDataReceiver;


architecture rtl of DmaPortCommIfcSinkStreamDataReceiver is

  
  
  
  signal bStartingByteLane, bStartingByteLaneNx : NiDmaByteLane_t;
  signal bFifoWriteNx : boolean;
  signal bFifoDataNx : NiDmaData_t;
  signal bWriteLengthInBytesLoc, bWriteLengthInBytesNx : NiDmaBusByteCount_t;

  
  
  
  signal bDisabledNx : boolean;
  signal bByteEnableNx : NiDmaByteEnable_t;
  signal bSinkStreamAddressDecode, bSinkStreamDecodeLower,
    bSinkStreamDecodeUpper  : boolean;


  
  
  
  type SinkStreamDataReceiverState_t is (

    
    
    
    
    
    Idle,

    
    
    ReceiveData,

    
    
    DiscardData

  );

  signal bSinkStreamDataReceiverStateNx, bSinkStreamDataReceiverState :
    SinkStreamDataReceiverState_t;

  signal bDisabledLoc : boolean := true;
begin

  bWriteLengthInBytes <= bWriteLengthInBytesLoc;
  bDisabled <= bDisabledLoc;
  
  
  StateRegs: process(BusClk, aReset)
  begin

    if(aReset) then

      
      bSinkStreamDataReceiverState <= Idle;
      bStartingByteLane <= (others=>'0');
      bFifoWrite <= false;
      bFifoData <= (others=>'0');
      bWriteLengthInBytesLoc <= (others=>'0');
      bByteEnable <= (others=>false);
      bDisabledLoc <= true;

    elsif(rising_edge(BusClk)) then

      bFifoData <= bFifoDataNx;

      
      

      if(bReset) then

        bSinkStreamDataReceiverState <= Idle;
        bStartingByteLane <= (others=>'0');
        bFifoWrite <= false;
        bWriteLengthInBytesLoc <= (others=>'0');
        bByteEnable <= (others=>false);
        bDisabledLoc <= true;

      else

        bSinkStreamDataReceiverState <= bSinkStreamDataReceiverStateNx;
        bStartingByteLane <= bStartingByteLaneNx;
        bFifoWrite <= bFifoWriteNx;
        bWriteLengthInBytesLoc <= bWriteLengthInBytesNx;
        bByteEnable <= bByteEnableNx;
        bDisabledLoc <= bDisabledNx;

      end if;

    end if;

  end process StateRegs;


  
  
  
  
  

  
  DmaNextStateLogic: process(bSinkStreamDataReceiverState, bHighSpeedSink,
    bDisable, bSinkStreamAddressDecode, bStartingByteLane, bWriteLengthInBytesLoc)
  begin

    
    bSinkStreamDataReceiverStateNx <= bSinkStreamDataReceiverState;
    bStartingByteLaneNx <= bStartingByteLane;
    bFifoDataNx <= (others=>'0');
    bFifoWriteNx <= false;
    bByteEnableNx <= (others=>false);
    bDisabledNx <= false;
    bStreamError <= false;
    bWriteLengthInBytesNx <= bWriteLengthInBytesLoc;

    case bSinkStreamDataReceiverState is

      
      
      
      
      
      when Idle =>

        if bHighSpeedSink.Push and bSinkStreamAddressDecode then

          if not bHighSpeedSink.TransferEnd then

            if bDisable then
              bSinkStreamDataReceiverStateNx <= DiscardData;

            else
              bFifoWriteNx <= bHighSpeedSink.Push;
              bFifoDataNx <= bHighSpeedSink.Data;
              bByteEnableNx <= bHighSpeedSink.ByteEnable;
              bWriteLengthInBytesNx <= bHighSpeedSink.ByteCount;

              bSinkStreamDataReceiverStateNx <= ReceiveData;

            end if;

          elsif not bDisable then

              bFifoWriteNx <= bHighSpeedSink.Push;
              bFifoDataNx <= bHighSpeedSink.Data;
              bByteEnableNx <= bHighSpeedSink.ByteEnable;
              bWriteLengthInBytesNx <= bHighSpeedSink.ByteCount;

              bStartingByteLaneNx <= resize(bHighSpeedSink.ByteLane +
                bHighSpeedSink.ByteCount, bStartingByteLane'length);

          end if;

          if bHighSpeedSink.ByteLane /= bStartingByteLane then

            bStreamError <= true;
            bFifoWriteNx <= false;
            bStartingByteLaneNx <= bStartingByteLane;

            if not bHighSpeedSink.TransferEnd then

              bSinkStreamDataReceiverStateNx <= DiscardData;

            end if;

          end if;

        end if;

        
        
        bDisabledNx <= bDisable;


      
      
      
      
      
      when ReceiveData =>

        if bHighSpeedSink.Push and bSinkStreamAddressDecode then

          bFifoWriteNx <= bHighSpeedSink.Push;
          bFifoDataNx <= bHighSpeedSink.Data;
          bByteEnableNx <= bHighSpeedSink.ByteEnable;
          bWriteLengthInBytesNx <= bHighSpeedSink.ByteCount;

          if bHighSpeedSink.TransferEnd then

            bStartingByteLaneNx <= resize(bHighSpeedSink.ByteLane + bHighSpeedSink.ByteCount,
              bStartingByteLane'length);
            bSinkStreamDataReceiverStateNx <= Idle;

          end if;

        end if;


      
      
      
      
      when DiscardData =>

        if bHighSpeedSink.TransferEnd and bSinkStreamAddressDecode then

          bSinkStreamDataReceiverStateNx <= Idle;

        end if;

        
        bDisabledNx <= true;


      when Others =>

        bSinkStreamDataReceiverStateNx <= Idle;

    end case;

  end process DmaNextStateLogic;

  
  bSinkStreamAddressDecode <= bSinkStreamDecodeLower and bSinkStreamDecodeUpper;
  bSinkStreamDecodeLower <= bHighSpeedSink.Address >= kFifoBaseOffset;
  bSinkStreamDecodeUpper <= bHighSpeedSink.Address < kFifoBaseOffset + kWriteWindow;

end architecture rtl;