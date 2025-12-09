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

























library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

library work;
  use work.PkgNiUtilities.all;
  use work.PkgCommunicationInterface.all;
  use work.PkgDmaPortCommunicationInterface.all;
  use work.PkgCommIntConfiguration.all;
  
entity DmaPortCommIfcIrqInterface is
  generic (
    
    
    kNumDmaIrqPorts : natural := 0
  
  );
  port (
  
    aReset           : in boolean;
    
    
    bReset           : in boolean;
    
    BusClk           : in std_logic;
    
    IrqClk           : in std_logic;

    
    bIrq             : out std_logic;
    
    
    iLvFpgaIrq       : in IrqToInterfaceArray_t(Larger(kNumberOfIrqs,1)-1 downto 0);
    
    
    bFixedLogicDmaIrq: in IrqStatusArray_t;

    
    bDmaIrq          : in IrqStatusArray_t(Larger(kNumDmaIrqPorts-1,0) downto 0)
    
  );
end DmaPortCommIfcIrqInterface;

architecture rtl of DmaPortCommIfcIrqInterface is

  signal bLvFpgaIrqSet, bDmaIrqSet : std_logic;
  signal iLvFpgaIrqSet : std_logic;

  
  

begin
  
  
  
  SetIrq: process(aReset, BusClk)
  begin
  
    if aReset then
    
      bIrq <= '0';
      
    elsif rising_edge(BusClk) then
      
      if bReset then
        bIrq <= '0';
      else
        
        bIrq <= bLvFpgaIrqSet or bDmaIrqSet;
      end if;
      
    end if;
  
  end process SetIrq;
  
  
  
  
  
  
  DoubleSyncSLx: entity work.DoubleSyncSL (behavior)
    port map (
      aReset => aReset,         
      IClk   => IrqClk,         
      iSig   => iLvFpgaIrqSet,  
      OClk   => BusClk,         
      oSig   => bLvFpgaIrqSet); 
  
  
  SetLvFpgaIrq: process(iLvFpgaIrq)
  begin
    iLvFpgaIrqSet <= '0';
    for VectorIndex in 0 to iLvFpgaIrq'length-1 loop
      for IrqIndex in 0 to iLvFpgaIrq(VectorIndex)'length -1 loop
        if iLvFpgaIrq(VectorIndex)(IrqIndex).Status = '1' then
          iLvFpgaIrqSet <= '1';
        end if;
      end loop; 
    end loop; 
  end process SetLvFpgaIrq;
  
  
  
  
  SetDmaIrq: process(bDmaIrq, bFixedLogicDmaIrq)
  begin
    bDmaIrqSet <= '0';
    for IrqIndex in 0 to bDmaIrq'length-1 loop
      if bDmaIrq(IrqIndex).Status = '1' then
        bDmaIrqSet <= '1';
      end if;
    end loop; 

    for i in bFixedLogicDmaIrq'range loop
      if bFixedLogicDmaIrq(i).Status = '1' then
        bDmaIrqSet <= '1';
      end if;
    end loop;

  end process SetDmaIrq;
   
  
end rtl;