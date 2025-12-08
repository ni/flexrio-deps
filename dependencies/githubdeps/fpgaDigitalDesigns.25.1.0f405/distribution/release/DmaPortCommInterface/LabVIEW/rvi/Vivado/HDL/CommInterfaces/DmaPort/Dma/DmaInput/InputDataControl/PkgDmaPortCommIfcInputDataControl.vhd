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
  use work.PkgNiDmaConfig.all;
  use work.PkgCommIntConfiguration.all;

Package PkgDmaPortCommIfcInputDataControl is

  type NiDmaMuxCountArray_t is array (natural range <>) of natural;

  
  
  
  
  
  function GetNumberOfMuxLevels(NumOfChannels : natural;
                                ExtraLastStage : boolean := false) return natural;
  function GetNumberOfMuxes(NumOfChannels : natural) return natural;
  function GetNumberOfMuxesForLevel(NumOfChannels : natural) return NiDmaMuxCountArray_t;
  function GetOffsetForLevel(NumOfChannels : natural) return NiDmaMuxCountArray_t;

  
  
  
  
  
  
  
  constant kInputDataDelay : natural := 1;

end Package PkgDmaPortCommIfcInputDataControl;

Package body PkgDmaPortCommIfcInputDataControl is

  
  
  
  
  function GetNumberOfMuxLevels (NumOfChannels : natural;
                                 ExtraLastStage : boolean := false) return natural is
  variable rval, remainder, quotient : natural;
  begin
    rval := 0;
    quotient := NumOfChannels;
    while quotient > kNiDmaMaxMuxWidth loop
      rval := rval + 1;
      remainder := quotient mod kNiDmaMaxMuxWidth;
      if remainder = 0 then
        quotient := quotient / kNiDmaMaxMuxWidth;
      else
        quotient := quotient / kNiDmaMaxMuxWidth + 1;
      end if;
    end loop;
    if ExtraLastStage then
      rval := rval + 1; 
    end if;
    return rval;
  end function GetNumberOfMuxLevels;
  
  
  
  function GetNumberOfMuxes (NumOfChannels : natural) return natural is
  variable rval, remainder, quotient : natural;
  begin
    rval := 0;
    quotient := NumOfChannels;
    while quotient > kNiDmaMaxMuxWidth loop
      remainder := quotient mod kNiDmaMaxMuxWidth;
      if remainder = 0 then
        quotient := quotient / kNiDmaMaxMuxWidth;
      else
        quotient := quotient / kNiDmaMaxMuxWidth + 1;
      end if;
      rval := rval + quotient;
    end loop;
    rval := rval + 1; 
    return rval;
  end function GetNumberOfMuxes;
  
  
  
  
  function GetNumberOfMuxesForLevel (NumOfChannels : natural) return NiDmaMuxCountArray_t is
  variable rval : NiDmaMuxCountArray_t(GetNumberOfMuxLevels(NumOfChannels) downto 0);
  variable remainder, quotient, pointer : natural;
  begin
    pointer := 0;
    quotient := NumOfChannels;
    while quotient > kNiDmaMaxMuxWidth loop
      remainder := quotient mod kNiDmaMaxMuxWidth;
      if remainder = 0 then
        quotient := quotient / kNiDmaMaxMuxWidth;
      else
        quotient := quotient / kNiDmaMaxMuxWidth + 1;
      end if;
      rval(pointer) := quotient;
      pointer := pointer + 1;
    end loop;
    rval(pointer) := 1;
    return rval;
  end function GetNumberOfMuxesForLevel;
  
  
  
  function GetOffsetForLevel (NumOfChannels : natural) return NiDmaMuxCountArray_t is
  variable rval : NiDmaMuxCountArray_t(GetNumberOfMuxLevels(NumOfChannels) downto 0);
  variable remainder, quotient, pointer, acc : natural;
  begin
    pointer := 0;
    acc := 0;
    quotient := NumOfChannels;
    while quotient > kNiDmaMaxMuxWidth loop
      rval(pointer) := acc;
      remainder := quotient mod kNiDmaMaxMuxWidth;
      if remainder = 0 then
        quotient := quotient / kNiDmaMaxMuxWidth;
      else
        quotient := quotient / kNiDmaMaxMuxWidth + 1;
      end if;
      acc := acc + quotient;
      pointer := pointer + 1;
    end loop;
    rval(pointer) := acc;
    return rval;
  end function GetOffsetForLevel;

end Package body PkgDmaPortCommIfcInputDataControl;
