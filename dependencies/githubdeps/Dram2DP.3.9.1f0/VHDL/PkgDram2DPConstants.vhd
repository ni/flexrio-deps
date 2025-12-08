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
  use work.PkgNiDma.all;

package PkgDram2DPConstants is
  
  constant kCoreVersion : std_logic_vector(31 downto 0) := X"DEBB_B0FF";

  
  constant kReadCmd : std_logic_vector (2 downto 0) := B"001";
  constant kWriteCmd : std_logic_vector (2 downto 0) := B"000";

  
  
  constant kRegPortAddressesPerBuffer : integer := 16;

  
  constant kDramInterfaceAddressWidth : integer := 32;

  
  constant kDefaultDramInterfaceDataWidth : integer := 64;

  
  type NiD2DBaggageArr_t is array (integer range <>) of NiDmaBaggage_t;

end package PkgDram2DPConstants;