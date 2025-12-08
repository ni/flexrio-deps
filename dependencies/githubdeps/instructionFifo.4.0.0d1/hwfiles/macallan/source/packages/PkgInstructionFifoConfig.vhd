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

package PkgInstructionFifoConfig is

  
  
  
  
  
  
  
  constant kIFifoWindowGlobalOffset : natural :=16#80000#;

  
  
  
  
  
  
  
  
  
  constant kIFifoWindowSize : natural := 16#200#;

  
  
  
  constant kIFifoRegMapOffset : natural := 16#11000#;
  
  
  
  
  
  constant kIFifoMaxNrFifos : positive := 8;

  
  constant kNumAxiStreamFifos : natural := 2;
  constant kNumLvFpgaFifos    : natural := 1;

  
  constant kIFifoNrFifos : positive range 1 to kIFifoMaxNrFifos :=
    kNumAxiStreamFifos + kNumLvFpgaFifos;

  
  
  constant kIFifoElementsLog2 : positive range 1 to 10 := 7;

  
  
  

  
  constant kIFifoCreditsToReq : positive range 1 to 2**kIFifoElementsLog2-1 := 127;

  
  
  constant kIFifoNrMailboxes : positive range 1 to 1 := 1;

  
  
  
  
  
  
  
  
  
  
  
  constant kIFifoDmaChannel : natural := 62;

  
  
  
  
  
  
  
  
  
  
  constant kIFifoWriteDataWidthBytes : positive := 8;
  constant kIFifoReadDataWidthBytes  : positive := 8;
  
  
  constant kIFifoReadStatusWidthBytes : natural range 0 to 1 := 1;
  
  
  constant kIFifoSentinelWidthBytes  : positive := 1;

end package PkgInstructionFifoConfig;