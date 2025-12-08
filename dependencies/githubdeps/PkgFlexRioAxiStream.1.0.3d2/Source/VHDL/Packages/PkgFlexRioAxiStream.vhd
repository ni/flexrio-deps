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

package PkgFlexRioAxiStream is

  
  
  
  
  
  
  constant kAxiStreamTDataWidth : positive := 32;
  subtype AxiStreamTData_t is std_logic_vector(kAxiStreamTDataWidth - 1 downto 0);

  
  type AxiStreamData_t is record
    TData  : AxiStreamTData_t;
    TLast  : boolean;
    TValid : boolean;
  end record;

  
  constant kAxiStreamDataZero : AxiStreamData_t := (
    TData  => (others => '0'),
    TLast  => false,
    TValid => false
    );

  
  type AxiStreamDataAry_t is array (natural range <>) of AxiStreamData_t;

  
  constant kFlatAxiStreamDataWidth : positive := kAxiStreamTDataWidth + 2;
  subtype FlatAxiStreamData_t is std_logic_vector(kFlatAxiStreamDataWidth - 1 downto 0);

  
  function Flatten(
    Channel : AxiStreamData_t)
    return FlatAxiStreamData_t;

  function UnFlatten(
    FlatChannel : FlatAxiStreamData_t)
    return AxiStreamData_t;

  
  
  
  
  
  constant kAxiStreamReadyZero : boolean := false;

end PkgFlexRioAxiStream;


package body PkgFlexRioAxiStream is

  
  
  
  
  constant kTDataIndex  : natural := 0;
  constant kTLastIndex  : natural := kTDataIndex + kAxiStreamTDataWidth;
  constant kTValidIndex : natural := kTLastIndex + 1;

  function Flatten (
    Channel : AxiStreamData_t)
    return FlatAxiStreamData_t is
    variable retVal : FlatAxiStreamData_t;
  begin  

    retVal := SetField(kTDataIndex, Channel.TData, kFlatAxiStreamDataWidth) or
              SetBit(kTLastIndex, Channel.TLast, kFlatAxiStreamDataWidth) or
              SetBit(kTValidIndex, Channel.TValid, kFlatAxiStreamDataWidth);
    return retVal;

  end function Flatten;

  function UnFlatten (
    FlatChannel : FlatAxiStreamData_t)
    return AxiStreamData_t is
    variable retVal : AxiStreamData_t;
  begin  

    retVal.TValid := to_Boolean(FlatChannel(kTValidIndex));
    retVal.TLast  := to_Boolean(FlatChannel(kTLastIndex));
    retVal.TData  := FlatChannel(kTDataIndex + kAxiStreamTDataWidth-1 downto kTDataIndex);

    return retVal;

  end function UnFlatten;

  
  
  



end PkgFlexRioAxiStream;