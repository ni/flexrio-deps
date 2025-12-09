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

library WORK;
  use WORK.PkgNiUtilities.all;

  use work.PkgNiDma.all;

  use work.PkgDmaPortCommunicationInterface.all;
  use work.PkgDmaPortCommIfcInputDataControl.all;
  use work.PkgCommIntConfiguration.all;

entity DmaPortInputDataToDmaDelay is
  generic (
    kDelay : natural := 0
          );
  port (
    Clk                             : in  std_logic;
    cNiDmaInputDataToDma            : in  NiDmaInputDataToDma_t;
    cNiDmaInputDataToDmaDelayed     : out NiDmaInputDataToDma_t
       );
end entity DmaPortInputDataToDmaDelay;

architecture RTL of DmaPortInputDataToDmaDelay is

  
  
  
  
  
  
  
  signal cDataShiftReg : NiDmaInputDataToDmaArray_t ( 0 to kDelay ) :=
         (others => kNiDmaInputDataToDmaZero);

begin

  cDataShiftReg ( 0 ) <= cNiDmaInputDataToDma;

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  cDataShiftReg ( 1 to kDelay ) <= cDataShiftReg ( 0 to kDelay - 1 ) 
                                   when rising_edge ( Clk );

  cNiDmaInputDataToDmaDelayed <= cDataShiftReg ( kDelay );

end RTL;

