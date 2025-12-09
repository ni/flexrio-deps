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

Package PkgDmaPortCommIfcStreamStates is

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  subtype StreamStateValue_t is std_logic_vector(1 downto 0);
  type StreamStateValueArray_t is array (natural range <>) of StreamStateValue_t;
  
  constant kStreamStateUnlinked  : StreamStateValue_t := "00";
  constant kStreamStateDisabled  : StreamStateValue_t := "01";
  constant kStreamStateEnabled   : StreamStateValue_t := "10";
  constant kStreamStateFlushing  : StreamStateValue_t := "11";

  type StreamState_t is (Unlinked, Disabled, Enabled, Flushing);
  
  
  function to_StreamState(arg : StreamStateValue_t) return StreamState_t;
  function to_StreamStateValue(arg : StreamState_t) return StreamStateValue_t;
  
end Package PkgDmaPortCommIfcStreamStates;

Package body PkgDmaPortCommIfcStreamStates is
  
  
  function to_StreamState(arg : StreamStateValue_t) return StreamState_t is
    variable ReturnVal : StreamState_t;
  begin
    
    if arg = kStreamStateUnlinked then
      ReturnVal := Unlinked;
    elsif arg = kStreamStateDisabled then
      ReturnVal := Disabled;
    elsif arg = kStreamStateEnabled then
      ReturnVal := Enabled;
    elsif arg = kStreamStateFlushing then
      ReturnVal := Flushing;
    else
      ReturnVal := Unlinked;
    end if;
    
    return ReturnVal;
    
  end to_StreamState;
  
  
  function to_StreamStateValue(arg : StreamState_t) return StreamStateValue_t is
    variable ReturnVal : StreamStateValue_t;
  begin
    
    if arg = Unlinked then
      ReturnVal := kStreamStateUnlinked;
    elsif arg = Disabled then
      ReturnVal := kStreamStateDisabled;
    elsif arg = Enabled then
      ReturnVal := kStreamStateEnabled;
    elsif arg = Flushing then
      ReturnVal := kStreamStateFlushing;
    else
      ReturnVal := kStreamStateUnlinked;
    end if;
    
    return ReturnVal;
    
  end to_StreamStateValue;
    
end Package body PkgDmaPortCommIfcStreamStates;
