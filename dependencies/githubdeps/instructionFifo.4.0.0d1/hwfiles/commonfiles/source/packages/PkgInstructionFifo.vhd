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
use work.PkgInstructionFifoConfig.all;
use work.PkgNiDmaConfig.all;

package PkgInstructionFifo is

  
  
  
  constant kIFifoWriteDataWidth : positive := kIFifoWriteDataWidthBytes * 8;

  subtype IFifoWriteData_t is std_logic_vector(kIFifoWriteDataWidth-1 downto 0);
  constant kIFifoWriteDataZero : IFifoWriteData_t := (others => '0');
  type IFifoWriteDataAry_t is array (natural range <>) of IFifoWriteData_t;

  
  
  
  
  constant kIFifoReadDataWidth : positive        := kIFifoReadDataWidthBytes * 8;
  subtype IFifoReadData_t is std_logic_vector(kIFifoReadDataWidth-1 downto 0);
  constant kIFifoReadDataZero  : IFifoReadData_t := (others => '0');
  type IFifoReadDataAry_t is array (natural range <>) of IFifoReadData_t;

  constant kIFifoSentinelWidth : positive             := kIFifoSentinelWidthBytes * 8;
  subtype IFifoSentinel_t is unsigned(kIFifoSentinelWidth-1 downto 0);
  constant kIFifoSentinelZero  : IFifoSentinel_t := (others => '0');
  type IFifoSentinelAry_t is array (natural range <>) of IFifoSentinel_t;

  
  
  constant kIFifoReturnsStatus : boolean := kIFIfoReadStatusWidthBytes > 0;
  
  type IFifoReadStatus_t is record
    IsError : boolean;
    Last    : boolean;
  end record IFifoReadStatus_t;

  constant kIFifoReadStatusZero : IFifoReadStatus_t :=
    (IsError => false, Last => false);

  type IFifoReadStatusAry_t is array (natural range <>) of IFifoReadStatus_t;

  
  
  
  constant kIFifoReadStatusWidth : natural := kIFifoReadStatusWidthBytes * 8;
  subtype FlatIFifoReadStatus_t is std_logic_vector(kIFifoReadStatusWidth-1 downto 0);
  constant kFlatIFifoReadStatusZero : FlatIFifoReadStatus_t := (others => '0');

  
  constant kIFifoReadStatusErrorIndex : natural := 0;
  constant kIFifoReadStatusLastIndex : natural := 1;

  function Unflatten (
    slv : FlatIFifoReadStatus_t)
    return IFifoReadStatus_t;

  function Flatten (
    val : IFifoReadStatus_t)
    return FlatIFifoReadStatus_t;

  
  type IFifoRead_t is record
    Data     : IFifoReadData_t;
    Status   : IFifoReadStatus_t;
    Sentinel : IFifoSentinel_t;
  end record IFifoRead_t;

  constant kIFifoReadZero : IFifoRead_t :=
    (Data => kIFifoReadDataZero,
     Status => kIFifoReadStatusZero,
     Sentinel => kIFifoSentinelZero);

  constant kIFifoReadWidthBytes : positive := kIFifoReadDataWidthBytes +
                                              kIFifoReadStatusWidthBytes +
                                              kIFifoSentinelWidthBytes;
  constant kIFifoReadWidth : positive := kIFifoReadWidthBytes * 8;

  subtype FlatIFifoRead_t is std_logic_vector(kIFifoReadWidth-1 downto 0);
  type FlatIFifoReadAry_t is array (natural range <>) of FlatIFifoRead_t;

  function Unflatten (
    slv : FlatIFifoRead_t)
    return IFifoRead_t;

  function Flatten (
    val : IFifoRead_t)
    return FlatIFifoRead_t;

  
  
  
  
  subtype IFifoCredits_t is signed(kIFifoElementsLog2 downto 0);
  constant kIFifoCreditsZero : IFifoCredits_t := (others => '0');

  type IFifoCreditsAry_t is array (natural range <>) of IFifoCredits_t;

  
  
  
  
  
  
  
  
  
  function GetAddressWidthModifier (
    constant kDmaWidth         :    natural;
    constant kInstructionWidth : in natural)
    return integer;

  
  
  type NiDmaAddressAry_t is array (natural range <>) of
    unsigned(kNiDmaAddressWidth-1 downto 0);

  
  
  

  
  subtype AxiStreamRange_t is natural range 0 to kNumAxiStreamFifos-1;
  subtype LvFpgaRange_t is natural range kNumAxiStreamFifos to kNumAxiStreamFifos + kNumLvFpgaFifos -1;
  subtype IFifoRange_t is natural range 0 to kIFifoNrFifos-1;

end package PkgInstructionFifo;

package body PkgInstructionFifo is

  
  
  

  function Unflatten (
    slv : FlatIFifoReadStatus_t)
    return IFifoReadStatus_t is
    alias slvLcl : std_logic_vector(slv'length-1 downto 0) is slv;
    variable retVal : IFifoReadStatus_t;
  begin  

    
    retVal := kIFifoReadStatusZero;

    if kIFifoReturnsStatus then
      retVal.IsError := to_Boolean(slvLcl(kIFifoReadStatusErrorIndex));
      retVal.Last := to_Boolean(slvLcl(kIFifoReadStatusLastIndex));
    end if;

    return retVal;

  end function Unflatten;

  function Flatten (
    val : IFifoReadStatus_t)
    return FlatIFifoReadStatus_t is
    variable retVal : FlatIFifoReadStatus_t;
  begin  
    retval := (others => '0');
    if kIFifoReturnsStatus then
      retVal(kIFifoReadStatusErrorIndex) := to_StdLogic(val.IsError);
      retVal(kIFifoReadStatusLastIndex) := to_StdLogic(val.Last);
    end if;

    return retVal;
  end function Flatten;

  
  
  

  function Unflatten (
    slv : FlatIFifoRead_t)
    return IFifoRead_t is
    alias slvLcl        : std_logic_vector(slv'length-1 downto 0) is slv;
    variable retVal     : IFifoRead_t;
    variable goingIndex : natural := 0;
  begin  

    
    retVal.Data := slvLcl(kIFifoReadDataWidth-1 downto 0);
    goingIndex  := kIFifoReadDataWidth;

    
    
    retVal.Status := kIFifoReadStatusZero;
    if kIFifoReturnsStatus then
      retVal.Status := Unflatten(slvLcl(goingIndex + kIFifoReadStatusWidth -1 downto
                                        goingIndex));
      goingIndex := goingIndex + kIFifoReadStatusWidth;
    end if;

    
    retVal.Sentinel := unsigned(slvLcl(goingIndex + kIFifoSentinelWidth- 1
                                       downto goingIndex));

    return retVal;
  end function Unflatten;

  function Flatten (
    val : IFifoRead_t)
    return FlatIFifoRead_t is
    variable retVal : FlatIFifoRead_t;
  begin  

    
    if kIFifoReturnsStatus then
      retVal := std_logic_vector(val.Sentinel) & Flatten(val.Status) & std_logic_vector(val.Data);
    else
      retVal := std_logic_vector(val.Sentinel) & std_logic_vector(val.Data);
    end if;
    return retVal;
  end function Flatten;

  
  
  

  function GetAddressWidthModifier (
    constant kDmaWidth         :    natural;
    constant kInstructionWidth : in natural)
    return integer is
  begin  

    
    
    
    
    
    
    if kDmaWidth > kInstructionWidth then

      
      assert kDmaWidth mod kInstructionWidth = 0
        report "kInstructionWidth is not a divisor of kDmaWidth."
        severity error;
      

      return 0 - Log2(kDmaWidth / kInstructionWidth);

    else

      
      assert kInstructionWidth mod kDmaWidth = 0
        report "kDmaWidth is not a divisor of kInstructionWidth."
        severity error;
      

      return Log2(kInstructionWidth / kDmaWidth);

    end if;
  end function GetAddressWidthModifier;

end package body PkgInstructionFifo;