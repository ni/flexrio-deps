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
  --synopsys translate_off
  use work.PkgNiSim.all;
  --synopsys translate_on

package PkgXReg is

    
    constant kMaxRegVecLen : integer := 512;
    subtype XRegVec_t is std_logic_vector(kMaxRegVecLen-1 downto 0);
    type XRegNatVec_t is array(0 to kMaxRegVecLen-1) of natural;

    
    constant kXAddrWidth : natural := 64;
    function XAddrResize (Addr : unsigned) return unsigned;


    
    
    
    
    
    
    
    
    type XReg_t is record
      offset, size : natural;
      readable, writable : boolean;
      mask, strobemask : XRegVec_t;
    end record;

    
    
    
    
    type XReg2_t is record  
      offset : unsigned(kXAddrWidth-1 downto 0);
      size : natural;
      readable, writable : boolean;
      rmask, wmask, strobemask, initialvalue: XRegVec_t;
      msblookupw, msblookupr : XRegNatVec_t; 
      isreg, ismem, iswin : boolean;  
      --synopsys translate_off
      name : TestStatusString_t;  
      --synopsys translate_on
      
      version : natural;
      clearablemask : XRegVec_t;
      
      
    end record;

    constant kXRegVecOnes : XRegVec_t := (others => '1');
    constant kXRegVecZero : XRegVec_t := (others => '0');
    
    constant kXRegDefault : XReg2_t;

    
    function XRegResize (X : std_logic_vector) return XRegVec_t;

    
    function GetOffset(X : XReg2_t) return unsigned;
    function GetOffset(X : XReg2_t) return natural;
    function GetSize(X : XReg2_t) return natural;

    
    function GetWtMask(X : XReg2_t) return std_logic_vector;
    function GetRdMask(X : XReg2_t) return std_logic_vector;
    
    function GetStrobeMask(X : XReg2_t) return std_logic_vector;
    function GetClearableMask(X : XReg2_t) return std_logic_vector;

    
    
    
    
    
    
    
    function GetBitfield(X : XReg2_t; Bf : natural; Reg : std_logic_vector; Rd : boolean := false)
      return std_logic_vector;
    function GetBitfield(X : XReg2_t; Bf : natural; Reg : std_logic_vector; Rd : boolean := false)
      return natural;
    function GetBitfield(X : XReg2_t; Bf : natural; Reg : std_logic_vector; Rd : boolean := false)
      return std_logic;
    function GetBitfield(X : XReg2_t; Bf : natural; Reg : std_logic_vector; Rd : boolean := false)
      return boolean;

    
    function GetMsb(X : XReg2_t; Bf : natural; Rd : boolean) return natural;

    
    function GetInitialVal(X : XReg2_t) return std_logic_vector;
    function GetInitialVal(X : XReg2_t; Bf : natural) return std_logic_vector;
    function GetInitialVal(X : XReg2_t; Bf : natural) return integer;
    function GetInitialVal(X : XReg2_t; Bf : natural) return std_logic;
    function GetInitialVal(X : XReg2_t; Bf : natural) return boolean;

    --synopsys translate_off
    function GetOffsetStr(X : XReg2_t; MinBitWidth : natural := 16) return string;
    function GetName(X : XReg2_t) return string;
    --synopsys translate_on

end package;
package body PkgXReg is

    function XAddrResize(Addr : unsigned) return unsigned is
    begin
      return resize(Addr, kXAddrWidth);
    end function XAddrResize;

    
    
    
    function XRegResize (X : std_logic_vector) return XRegVec_t is
      variable Val : XRegVec_t := (others => '0');
    begin
      Val(x'length-1 downto 0) := X;
      return Val;
    end function XRegResize;

    
    function XRegDefault return XReg2_t is
      variable X : XReg2_t;
    begin
      X.version := 0;
      X.offset := (others => '0');
      X.size := 32;
      X.readable := true;
      X.writable := true;
      X.wmask := kXRegVecOnes;
      X.rmask := kXRegVecOnes;
      X.strobemask := kXRegVecZero;
      X.clearablemask := kXRegVecZero;
      X.initialvalue := kXRegVecZero;
      
      for i in 0 to kMaxRegVecLen-1 loop
        X.msblookupw(i) := i;
        X.msblookupr(i) := i;
      end loop;
      x.isreg := false;
      x.ismem := false;
      x.iswin := false;
      --synopsys translate_off
      X.name := (others => ' ');
      --synopsys translate_on
      return X;
    end function XRegDefault;

    constant kXRegDefault : XReg2_t := XRegDefault;

    
    function GetOffset(X : XReg2_t) return unsigned is
    begin
      return X.offset;
    end function GetOffset;

    
    function GetOffset(X : XReg2_t) return natural is
    begin
      return To_Integer(X.offset);
    end function GetOffset;

    
    function GetSize(X : XReg2_t) return natural is
    begin
      return X.size;
    end function GetSize;

    
    function GetWtMask(X : XReg2_t) return std_logic_vector is
    begin
      return X.wmask(X.size-1 downto 0);
    end function GetWtMask;

    
    function GetRdMask(X : XReg2_t) return std_logic_vector is
    begin
      return X.rmask(X.size-1 downto 0);
    end function GetRdMask;

    
    function GetStrobeMask(X : XReg2_t) return std_logic_vector is
    begin
      
      
      
      
      
      
      return X.strobemask(X.size-1 downto 0) or X.clearablemask(X.size-1 downto 0);
    end function GetStrobeMask;

    
    function GetClearableMask(X : XReg2_t) return std_logic_vector is
    begin
      --synopsys translate_off
      assert X.version >= 1
        report "Called GetClearableMask with an XReg2_t record created with an old version of XmlParse or PkgXReg." & LF &
               "Default value of clearablemask returned may not reflect the actual attribute of the register." & LF &
               "Update the regmap package with the latest version of XmlParse and this (or newer) version of PkgXReg" & LF &
               "Register Name: " & X.name
        severity failure;
      --synopsys translate_on
      return X.clearablemask(X.size-1 downto 0);
    end function GetClearableMask;

    function GetMsb(X : XReg2_t; Bf : natural; Rd : boolean) return natural is
    begin
      if Rd then
        return X.msblookupr(Bf);
      end if;
      return X.msblookupw(Bf);
    end function GetMsb;

    
    function GetBitfield(X : XReg2_t; Bf : natural; Reg : std_logic_vector; Rd : boolean := false)
      return std_logic_vector is
    begin
      return Reg(GetMsb(X, Bf, Rd) downto Bf);
    end function GetBitfield;

    
    function GetBitfield(X : XReg2_t; Bf : natural; Reg : std_logic_vector; Rd : boolean := false)
      return natural is
    begin
      return To_Integer(unsigned(Reg(GetMsb(X, Bf, Rd) downto Bf)));
    end function GetBitfield;

    
    function GetBitfield(X : XReg2_t; Bf : natural; Reg : std_logic_vector; Rd : boolean := false)
      return std_logic is
    begin
      --synopsys translate_off
      assert GetMsb(X, Bf, Rd)=Bf
        report "Single bit version of GetBitfield called on multi-bit bitfield at lsb=" & integer'image(Bf)
        severity failure;
      --synopsys translate_on
      return Reg(Bf);
    end function GetBitfield;

    
    function GetBitfield(X : XReg2_t; Bf : natural; Reg : std_logic_vector; Rd : boolean := false)
      return boolean is
    begin
      --synopsys translate_off
      assert GetMsb(X, Bf, Rd)=Bf
        report "Single bit version of GetBitfield called on multi-bit bitfield at lsb=" & integer'image(Bf)
        severity failure;
      --synopsys translate_on
      return Reg(Bf)='1';
    end function GetBitfield;

    
    function GetInitialVal(X : XReg2_t) return std_logic_vector is
    begin
      return X.initialvalue(X.size-1 downto 0);
    end function GetInitialVal;

    
    function GetInitialVal(X : XReg2_t; Bf : natural) return std_logic_vector is
    begin
      --synopsys translate_off
      assert X.msblookupw(Bf)>Bf
        report "Multi-bit version of GetInitialVal called on single bit bitfield at " & integer'image(Bf)
        severity failure;
      --synopsys translate_on
      return X.initialvalue(X.msblookupw(Bf) downto Bf);
    end function GetInitialVal;

    
    function GetInitialVal(X : XReg2_t; Bf : natural) return integer is
    begin
      return To_Integer(unsigned(X.initialvalue(X.msblookupw(Bf) downto Bf)));
    end function GetInitialVal;

    
    function GetInitialVal(X : XReg2_t; Bf : natural) return std_logic is
    begin
      --synopsys translate_off
      assert X.msblookupw(Bf)=Bf
        report "Single bit version of GetInitialVal called on multi-bit bitfield at lsb=" & integer'image(Bf)
        severity failure;
      --synopsys translate_on
      return X.initialvalue(Bf);
    end function GetInitialVal;

    
    function GetInitialVal(X : XReg2_t; Bf : natural) return boolean is
    begin
      return X.initialvalue(Bf)='1';
    end function GetInitialVal;

    --synopsys translate_off

    
    function GetOffsetStr(X : XReg2_t; MinBitWidth : natural := 16) return string is
      variable MinLen : natural;
    begin
      MinLen := MinBitWidth / 4;
      if MinBitWidth mod 4 > 0 then
        MinLen := MinLen + 1;
      end if;
      return 'x' & TrimNumericString(HexImage(X.offset), MinLen);
    end function GetOffsetStr;

    
    function GetName(X : XReg2_t) return string is
    begin
      return RemoveTrailingSpaces(X.name);
    end function GetName;

    --synopsys translate_on

end package body;