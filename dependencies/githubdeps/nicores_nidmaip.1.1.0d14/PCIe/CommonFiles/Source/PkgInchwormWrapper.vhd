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
use work.PkgCommIntConfiguration.all;
use work.PkgNiDma.all;

package PkgInchwormWrapper is

  
  
  
  
  
  function kGetEnabledChannels (
      constant kForceChannelEnable : NiDmaDmaChannelOneHot_t := (others => false)
    ) return NiDmaDmaChannelOneHot_t;

end package PkgInchwormWrapper;

package body PkgInchwormWrapper is

  function kGetEnabledChannels (
    constant kForceChannelEnable : NiDmaDmaChannelOneHot_t := (others => false)
  ) return NiDmaDmaChannelOneHot_t is
    variable retval : NiDmaDmaChannelOneHot_t := (others => false);
  begin
    for i in NiDmaDmaChannelOneHot_t'range loop
      
      
      
      
      
      retval(i) := (kDmaFifoConfArray(i).Mode /= NiFpgaPeerToPeerReader
                   and kDmaFifoConfArray(i).Mode /= Disabled)
                   or kForceChannelEnable(i);

    end loop;

    return retval;
  end function kGetEnabledChannels;

end package body PkgInchwormWrapper;