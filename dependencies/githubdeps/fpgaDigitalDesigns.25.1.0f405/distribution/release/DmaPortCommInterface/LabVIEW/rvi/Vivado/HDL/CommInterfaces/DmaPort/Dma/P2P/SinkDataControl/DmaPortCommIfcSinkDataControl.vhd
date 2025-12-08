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
  use work.PkgNiDmaConfig.all;

  use work.PkgDmaPortCommunicationInterface.all;
  use work.PkgDmaPortCommIfcInputDataControl.all;
  use work.PkgCommIntConfiguration.all;

entity DmaPortCommIfcSinkDataControl is
  generic (
    
    
    
    kNumOfSinkStrms : natural := 16
  );

  port (
    aReset : in  boolean;
    BusClk : in  std_logic;

    
    
    
    bNiDmaInputDataToDma : out NiDmaInputDataToDma_t;

    
    
    
    
    bNiDmaInputDataToDmaValid : out boolean;

    
    
    
    bInputDataFromSinkStreamArray : in
      NiDmaInputDataToDmaArray_t(Larger(kNumOfSinkStrms,1)-1 downto 0);

    
    
    bInputDataFromSinkStreamValidArray : in
      BooleanVector(Larger(kNumOfSinkStrms,1)-1 downto 0)
    );
end DmaPortCommIfcSinkDataControl;


architecture rtl of DmaPortCommIfcSinkDataControl is
  
  signal bNiDmaInputDataToDmaLocArray : NiDmaInputDataToDmaArray_t(Larger(kNumOfSinkStrms,1)-1 downto 0) := (others => kNiDmaInputDataToDmaZero);
  
  signal bDataValidDelayedArray : BooleanVector(0 to kInputDataDelay);
  signal bNiDmaInputDataToDmaShiftReg : NiDmaInputDataToDmaArray_t ( 0 to kInputDataDelay ) := (others => kNiDmaInputDataToDmaZero);
  
  
  
  
  
  
  
  
  
  function SelectData ( InputDataToDma : NiDmaInputDataToDmaArray_t;
                        Selector : BooleanVector(Larger(kNumOfSinkStrms,1)-1 downto 0) ) return
                        NiDmaInputDataToDmaArray_t is
    variable rval : NiDmaInputDataToDmaArray_t ( InputDataToDma'range ) :=
                    (others => kNiDmaInputDataToDmaZero);
  begin
    for i in rval'range loop
      if Selector ( i ) then
        rval ( i ) := InputDataToDma ( i );
      end if;
    end loop;

    return rval;
  end function SelectData;


begin

  bNiDmaInputDataToDmaLocArray <= SelectData(
    bInputDataFromSinkStreamArray,
    bInputDataFromSinkStreamValidArray);

  
  bDataValidDelayedArray(0) <= OrVector(bInputDataFromSinkStreamValidArray);
  bNiDmaInputDataToDmaShiftReg(0) <= OrArray(bNiDmaInputDataToDmaLocArray);
  
  DataValidDelay: process (aReset, BusClk) is
  begin
    if aReset then
      bDataValidDelayedArray(1 to kInputDataDelay) <= (others => false);
      bNiDmaInputDataToDmaShiftReg(1 to kInputDataDelay) <= (others => kNiDmaInputDataToDmaZero);
    elsif rising_edge(BusClk) then
      bDataValidDelayedArray(1 to kInputDataDelay) <= bDataValidDelayedArray(0 to kInputDataDelay - 1);
      bNiDmaInputDataToDmaShiftReg(1 to kInputDataDelay) <= bNiDmaInputDataToDmaShiftReg(0 to kInputDataDelay - 1);
    end if;
  end process;
  bNiDmaInputDataToDmaValid <= bDataValidDelayedArray(kInputDataDelay);
  bNiDmaInputDataToDma <= bNiDmaInputDataToDmaShiftReg(kInputDataDelay);
  
  
  CheckForOneOrNoneHotVector: process(BusClk)
  begin
    if rising_edge(BusClk) then
      for i in 0 to bInputDataFromSinkStreamValidArray'length-1 loop
        if bInputDataFromSinkStreamValidArray(i) then
          for j in i+1 to bInputDataFromSinkStreamValidArray'length-1 loop
            assert not bInputDataFromSinkStreamValidArray(j)
              report "Sink streams #" & integer'image(i) & "and #" & integer'image(j) & " are both selected in Sink Data Control multiplexer."
              severity Error;
          end loop;
        end if;
      end loop;
    end if;
  end process CheckForOneOrNoneHotVector;
  

end rtl;