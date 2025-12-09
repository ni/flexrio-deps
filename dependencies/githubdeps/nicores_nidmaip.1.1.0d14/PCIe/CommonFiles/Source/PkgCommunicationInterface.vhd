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

package PkgCommunicationInterface is

  subtype InterfaceData_t is std_logic_vector(31 downto 0);

  
  
  

  constant kAlignedAddressWidth : positive := 17; 

  
  

  constant kRegPortInSize  : positive := kAlignedAddressWidth + 34;

  
  

  constant kRegPortOutSize : positive := 34;

  
  
  

  
  
  type RegPortIn_t is record
    Address : unsigned(kAlignedAddressWidth - 1 downto 0);
    Data    : InterfaceData_t;
    Rd      : boolean;                  
    Wt      : boolean;                  
  end record;

  
  
  
  
  
  type RegPortOut_t is record
    Data      : InterfaceData_t;
    DataValid : boolean;                
    Ready     : boolean;                
  end record;

  
  type RegPortOutArray_t is array (natural range<>) of RegPortOut_t;
  function SelectPort(arg : RegPortOutArray_t) return RegPortOut_t;
  
  constant kRegPortInZero : RegPortIn_t := (
    Address => to_unsigned(0,kAlignedAddressWidth),
    Data => (others => '0'),
    Rd => false,
    Wt => false);

  constant kRegPortOutZero : RegPortOut_t := (
    Data => (others=>'0'),
    DataValid => false,
    Ready => true);

  function BuildRegPortIn(
    arg  : std_logic_vector(kRegPortInSize-1 downto 0))
    return RegPortIn_t;

  function BuildRegPortOut(
    arg : std_logic_vector(kRegPortOutSize-1 downto 0))
    return RegPortOut_t;

  function to_StdLogicVector(arg : RegPortIn_t) return std_logic_vector;
  function to_StdLogicVector(arg : RegPortOut_t) return std_logic_vector;

end PkgCommunicationInterface;

package body PkgCommunicationInterface is

  
  function SelectPort(arg : RegPortOutArray_t) return RegPortOut_t is

    type Array_t is array (arg'range) of InterfaceData_t;

    variable ReturnVal     : RegPortOut_t;
    
    
    variable ArrayToBeOred : Array_t;
  begin

    
    for i in arg'range loop
      if arg(i).DataValid then
        ArrayToBeOred(i) := arg(i).Data;
      else
        ArrayToBeOred(i) := (others => '0');
      end if;
    end loop;

    
    ReturnVal.Data      := (others => '0');
    ReturnVal.DataValid := false;
    ReturnVal.Ready     := true;

    for i in ArrayToBeOred'range loop
      ReturnVal.Data      := ReturnVal.Data or ArrayToBeOred(i);
      ReturnVal.DataValid := ReturnVal.DataValid or arg(i).DataValid;
      ReturnVal.Ready     := ReturnVal.Ready and arg(i).Ready;
    end loop;

    return ReturnVal;

  end SelectPort;

  function BuildRegPortOut(arg : std_logic_vector(kRegPortOutSize - 1 downto 0))
      return RegPortOut_t is
    variable ReturnVal : RegPortOut_t;
  begin
    ReturnVal.Data      := arg(31 downto 0);
    ReturnVal.DataValid := to_Boolean(arg(32));
    ReturnVal.Ready     := to_Boolean(arg(33));
    return ReturnVal;
  end BuildRegPortOut;

  function BuildRegPortIn(arg : std_logic_vector(kRegPortInSize - 1 downto 0))
      return RegPortIn_t is
    variable ReturnVal : RegPortIn_t;
  begin
    ReturnVal.Data    := arg(31 downto 0);
    ReturnVal.Address := unsigned(arg(kRegPortInSize - 3 downto 32));
    ReturnVal.Wt      := to_Boolean(arg(kRegPortInSize - 2));
    ReturnVal.Rd      := to_Boolean(arg(kRegPortInSize - 1));
    return ReturnVal;
  end BuildRegPortIn;

  function to_StdLogicVector(arg : RegPortOut_t) return std_logic_vector is
    variable ReturnVal : std_logic_vector(kRegPortOutSize - 1 downto 0);
  begin
    ReturnVal := to_StdLogic(arg.Ready) & to_StdLogic(arg.DataValid) & arg.Data;
    return ReturnVal;
  end to_StdLogicVector;

  function to_StdLogicVector(arg : RegPortIn_t) return std_logic_vector is
    variable ReturnVal : std_logic_vector(kRegPortInSize - 1 downto 0);
  begin
    ReturnVal := to_StdLogic(arg.Rd) &
                 to_StdLogic(arg.Wt) &
                 std_logic_vector(arg.Address) &
                 arg.Data;
    return ReturnVal;

  end to_StdLogicVector;


end PkgCommunicationInterface;