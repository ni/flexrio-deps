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
  use work.PkgXReg.all;
  --synopsys translate_off
  use work.PkgNiSim.all;
  --synopsys translate_on

package PkgBaggageRegTypeRegMap is










  
  constant kHostBusBaggage_tSize: integer := 64;
  constant kHostBusBaggage_tMask : std_logic_vector(63 downto 0) := X"ffffffffffffffff";
  constant kBaggageSize       : integer := 64;  
  constant kBaggageMsb        : integer := 63;  
  constant kBaggage           : integer :=  0;  





end package;

package body PkgBaggageRegTypeRegMap is

end package body;