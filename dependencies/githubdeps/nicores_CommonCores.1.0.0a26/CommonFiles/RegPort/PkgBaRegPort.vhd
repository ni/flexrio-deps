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
  use work.PkgXReg.all;
  use work.PkgBaRegPortConfig.all;

package PkgBaRegPort is

  
  
  
  
  
  

  
  
  constant kBaRegPortAddressWidth : natural := kBaRegPortAddressWidthConfig;
  constant kBaRegPortDataWidth : natural := kBaRegPortDataWidthConfig;

  

  constant kBaRegPortDataWidthInBytes : positive := kBaRegPortDataWidth / 8;
  constant kBaRegPortByteWidthLog2 : natural := Log2(kBaRegPortDataWidthInBytes);


  

  subtype BaRegPortAddress_t is unsigned(kBaRegPortAddressWidth - 1 downto 0);

  subtype BaRegPortData_t is std_logic_vector(kBaRegPortDataWidth - 1 downto 0);

  subtype BaRegPortStrobe_t is BooleanVector(kBaRegPortDataWidthInBytes - 1 downto 0);

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  type BaRegPortIn_t is record
    Address : BaRegPortAddress_t;
    Data : BaRegPortData_t;
    WtStrobe : BaRegPortStrobe_t;
    RdStrobe : BaRegPortStrobe_t;
  end record;

  constant kBaRegPortInZero : BaRegPortIn_t := (
    Address => (others => '0'),
    Data => (others => '0'),
    WtStrobe => (others => false),
    RdStrobe => (others => false)
  );

  type BaRegPortInArray_t is array (natural range <>) of BaRegPortIn_t;

  type BaRegPortOut_t is record
    Data : BaRegPortData_t;
    Ack : boolean;
  end record;

  constant kBaRegPortOutZero : BaRegPortOut_t := (
    Data => (others => '0'),
    Ack => false
  );

  type BaRegPortOutArray_t is array (natural range <>) of BaRegPortOut_t;

  function SizeOf(Var : BaRegPortIn_t) return integer;
  function SizeOf(Var : BaRegPortOut_t) return integer;

  
  
  
  function RegSelected(RegOffset : integer;
                       RegSize : integer;
                       BaRegPortIn : BaRegPortIn_t) return boolean;

  
  
  function RangeSelected (AddrLo, AddrHi : integer; RPI : BaRegPortIn_t) return boolean;

  
  
  function RegWriteEnables(RegOffset : integer;
                           RegSize : integer;
                           BaRegPortIn : BaRegPortIn_t) return BooleanVector;
  
  function RegWriteEnables(RegInfo : XReg2_t;
                           BaRegPortIn : BaRegPortIn_t;
                           BaseAddr : natural := 0) return BooleanVector;

  
  
  
  function RegWriteData(RegOffset : integer;
                        RegSize : integer;
                        BaRegPortIn : BaRegPortIn_t) return std_logic_vector;
  
  
  
  function RegWriteData(RegOffset : integer;
                        RegSize : integer;
                        OldData : std_logic_vector;
                        BaRegPortIn : BaRegPortIn_t) return std_logic_vector;
  
  
  
  
  
  
  
  
  function RegWriteData(RegInfo : XReg2_t;
                        OldData : std_logic_vector;
                        BaRegPortIn : BaRegPortIn_t;
                        BaseAddr : natural := 0) return std_logic_vector;

  
  
  function RegReadEnables(RegOffset : integer;
                          RegSize : integer;
                          BaRegPortIn : BaRegPortIn_t) return BooleanVector;
  
  function RegReadEnables(RegInfo : XReg2_t;
                          BaRegPortIn : BaRegPortIn_t;
                          BaseAddr : natural := 0) return BooleanVector;

  
  
  
  
  function RegReadData(RegOffset : integer;
                       RegSize : integer;
                       RegReadValue : std_logic_vector;
                       BaRegPortIn : BaRegPortIn_t) return BaRegPortData_t;
  
  
  
  function RegReadData(RegInfo : XReg2_t;
                       RegReadValue : std_logic_vector;
                       BaRegPortIn : BaRegPortIn_t;
                       BaseAddr : natural := 0) return BaRegPortData_t;

  
  
  
  function RegAccess(RegOffset : integer;
                     RegSize : integer;
                     BaRegPortIn : BaRegPortIn_t) return boolean;
  
  
  
  function RegAccess(RegInfo : XReg2_t;
                     BaRegPortIn : BaRegPortIn_t;
                     BaseAddr : natural := 0) return boolean;

  
  
  
  
  function DriveRegPortOut(RegInfo : XReg2_t;
                           RegReadValue : std_logic_vector;
                           BaRegPortIn : BaRegPortIn_t;
                           BaseAddr : natural := 0) return BaRegPortOut_t;
  
  
  function DriveRegPortOut(RegInfo : XReg2_t;
                           BaRegPortIn : BaRegPortIn_t;
                           BaseAddr : natural := 0) return BaRegPortOut_t;

  
  function "or" (L, R : BaRegPortOut_t) return BaRegPortOut_t;
  function OrArray(BaRegPortOutArray : BaRegPortOutArray_t) return BaRegPortOut_t;
  
  
  function BaAddrResize(Offset : unsigned) return BaRegPortAddress_t;

  
  
  
  function WindowBaRegPortIn (kBase, kSize : natural;
                              BaRegPortIn : BaRegPortIn_t) return BaRegPortIn_t;
  function WindowBaRegPortIn (RegInfo : XReg2_t;
                              BaRegPortIn : BaRegPortIn_t) return BaRegPortIn_t;

end PkgBaRegPort;

package body PkgBaRegPort is

  function SizeOf(Var : BaRegPortIn_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + Var.Address'length;   
    RetVal := RetVal + Var.Data'length;      
    RetVal := RetVal + Var.WtStrobe'length;  
    RetVal := RetVal + Var.RdStrobe'length;  
    return RetVal;
  end function SizeOf;

  function SizeOf(Var : BaRegPortOut_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + Var.Data'length;  
    RetVal := RetVal + 1;                
    return RetVal;
  end function SizeOf;

  
  
  
  function OffsetMod (Offset : BaRegPortAddress_t) return integer is
  begin
    return To_Integer(Offset(kBaRegPortByteWidthLog2-1 downto 0));
  end function OffsetMod;

  
  function To_BaAddr(Offset : natural) return BaRegPortAddress_t is
  begin
    return To_Unsigned(Offset, kBaRegPortAddressWidth);
  end function To_BaAddr;

  
  function BaAddrResize(Offset : unsigned) return BaRegPortAddress_t is
  begin
    return resize(Offset, kBaRegPortAddressWidth);
  end function BaAddrResize;

  
  
  
  
  function RegSelected(RegOffset : BaRegPortAddress_t;
                       RegSize : integer;
                       BaRegPortIn : BaRegPortIn_t) return boolean is
    
    
    
    
    
    
    
    
    
    
    constant kUseWidth : integer := Larger(kBaRegPortDataWidthInBytes,
                                           (RegSize / 8));
  begin
    --synopsys translate_off
    assert (RegSize >= 8) and ((RegSize mod 8) = 0) and IsPowerOf2(RegSize)
      report "Register size must be a power-of-two multiple of eight."
      severity FAILURE;
    assert (RegOffset mod (RegSize / 8)) = 0
      report "Register offset must be naturally aligned to the register size."
      severity FAILURE;
    --synopsys translate_on
    return (BaRegPortIn.Address(BaRegPortIn.Address'high downto Log2(kUseWidth)) =
            (RegOffset / kUseWidth));
  end function RegSelected;

  
  function RegSelected(RegOffset : integer;
                       RegSize : integer;
                       BaRegPortIn : BaRegPortIn_t) return boolean is
  begin
    return RegSelected(To_BaAddr(RegOffset), RegSize, BaRegPortIn);
  end function RegSelected;

  
  
  function RangeSelected (AddrLo, AddrHi : BaRegPortAddress_t;
                          RPI : BaRegPortIn_t) return boolean is
  begin
    --synopsys translate_off
    assert (AddrHi > AddrLo) and (OffsetMod(AddrLo) = 0) and (OffsetMod(AddrHi + 1) = 0)
      report "Range cannot cross data bus word boundaries."
      severity FAILURE;
    --synopsys translate_on
    return (RPI.Address >= AddrLo) and
           (RPI.Address <= AddrHi) and
           (OrVector(RPI.RdStrobe) or OrVector(RPI.WtStrobe));
  end function RangeSelected;

  
  function RangeSelected (AddrLo, AddrHi : integer; RPI : BaRegPortIn_t) return boolean is
  begin
    return RangeSelected(To_BaAddr(AddrLo), To_BaAddr(AddrHi), RPI);
  end function RangeSelected;

  
  
  
  function RegEnables(RegOffset : BaRegPortAddress_t;
                      RegSize : integer;
                      BaRegPortIn : BaRegPortIn_t;
                      DoWt : boolean := true) return BooleanVector is
    variable RegWord : integer;
    variable RetVal : BooleanVector(RegSize / 8 - 1 downto 0) := (others => false);
    variable Strobes : BaRegPortStrobe_t;
  begin
    if DoWt then Strobes := BaRegPortIn.WtStrobe;
            else Strobes := BaRegPortIn.RdStrobe;
    end if;
    if RegSelected(RegOffset, RegSize, BaRegPortIn) then
      if RegSize <= kBaRegPortDataWidth then
        
        
        
        
        
        
        RetVal := Strobes(OffsetMod(RegOffset)+RegSize/8-1 downto OffsetMod(RegOffset));
      else
        
        
        RegWord := To_Integer(BaRegPortIn.Address(Log2(RegSize/8)-1 downto kBaRegPortByteWidthLog2))
                       * kBaRegPortDataWidthInBytes;
        for i in BaRegPortStrobe_t'range loop
          RetVal(RegWord + i) := Strobes(i);
        end loop;
      end if;
    end if;
    return RetVal;
  end function RegEnables;

  
  
  
  function RegWriteEnables(RegOffset : BaRegPortAddress_t;
                           RegSize : integer;
                           BaRegPortIn : BaRegPortIn_t) return BooleanVector is
  begin
    return RegEnables(RegOffset, RegSize, BaRegPortIn, DoWt=>true);
  end function RegWriteEnables;

  
  function RegWriteEnables(RegOffset : integer;
                           RegSize : integer;
                           BaRegPortIn : BaRegPortIn_t) return BooleanVector is
  begin
    return RegEnables(To_BaAddr(RegOffset), RegSize, BaRegPortIn, DoWt=>true);
  end function RegWriteEnables;

  
  function RegWriteEnables(RegInfo : XReg2_t;
                           BaRegPortIn : BaRegPortIn_t;
                           BaseAddr : natural := 0) return BooleanVector is
  begin
    return RegWriteEnables(BaAddrResize(BaseAddr + RegInfo.offset), RegInfo.size, BaRegPortIn);
  end function RegWriteEnables;

  
  
  
  
  function RegWriteData(RegOffset : BaRegPortAddress_t;
                        RegSize : integer;
                        BaRegPortIn : BaRegPortIn_t) return std_logic_vector is
    variable RetVal : std_logic_vector(RegSize - 1 downto 0);
  begin
    if RegSize <= kBaRegPortDataWidth then
      RetVal := BaRegPortIn.Data(OffsetMod(RegOffset)*8+RegSize-1 downto OffsetMod(RegOffset)*8);
    else
      for i in 0 to (RegSize / kBaRegPortDataWidth) - 1 loop
        RetVal((i+1)*kBaRegPortDataWidth-1 downto i*kBaRegPortDataWidth) := BaRegPortIn.Data;
      end loop;
    end if;
    return RetVal;
  end function RegWriteData;

  
  function RegWriteData(RegOffset : integer;
                        RegSize : integer;
                        BaRegPortIn : BaRegPortIn_t) return std_logic_vector is
  begin
    return RegWriteData(To_BaAddr(RegOffset), RegSize, BaRegPortIn);
  end function RegWriteData;

  
  
  
  function RegWriteData(RegOffset : integer;
                        RegSize : integer;
                        OldData : std_logic_vector;
                        BaRegPortIn : BaRegPortIn_t) return std_logic_vector is
    variable ByteEnables : BooleanVector(RegSize / 8 - 1 downto 0);
    variable NewData : std_logic_vector(RegSize - 1 downto 0);
    variable ReturnVal : std_logic_vector(RegSize - 1 downto 0) := OldData;
  begin
    --synopsys translate_off
    assert OldData'length = RegSize
      report "RegSize must match data length"
      severity FAILURE;
    --synopsys translate_on
    ByteEnables := RegWriteEnables(RegOffset, RegSize, BaRegPortIn);
    NewData := RegWriteData(RegOffset, RegSize, BaRegPortIn);
    for i in ByteEnables'range loop
      if ByteEnables(i) then
        ReturnVal(8*i + 7 downto 8*i) := NewData(8*i + 7 downto 8*i);
      end if;
    end loop;
    return ReturnVal;
  end function RegWriteData;

  
  
  
  
  
  
  
  function RegWriteData(RegInfo : XReg2_t;
                        OldData : std_logic_vector;
                        BaRegPortIn : BaRegPortIn_t;
                        BaseAddr : natural := 0) return std_logic_vector is
    variable ByteEnables : BooleanVector(RegInfo.size / 8 - 1 downto 0);
    variable WtMask, NewData, ReturnVal : std_logic_vector(RegInfo.size - 1 downto 0);
  begin
    --synopsys translate_off
    assert OldData'length = RegInfo.size
      report "RegInfo.size must match data length"
      severity FAILURE;
    --synopsys translate_on
    
    ReturnVal := OldData and not GetStrobeMask(RegInfo);
    
    
    if RegInfo.writable then
      
      ByteEnables := RegWriteEnables(RegInfo, BaRegPortIn, BaseAddr);
      NewData := RegWriteData(BaAddrResize(BaseAddr + RegInfo.offset), RegInfo.size, BaRegPortIn);
      WtMask := GetWtMask(RegInfo);
      
      for i in ByteEnables'range loop
        if ByteEnables(i) then
          for b in 8*i to 8*i+7 loop
            if WtMask(b)='1' then
              ReturnVal(b) := NewData(b);
            end if;
          end loop;
        end if;
      end loop;
    end if;
    return ReturnVal;
  end function RegWriteData;

  
  
  
  function RegReadEnables(RegOffset : BaRegPortAddress_t;
                          RegSize : integer;
                          BaRegPortIn : BaRegPortIn_t) return BooleanVector is
  begin
    return RegEnables(RegOffset, RegSize, BaRegPortIn, DoWt=>false);
  end function RegReadEnables;

  
  function RegReadEnables(RegOffset : integer;
                          RegSize : integer;
                          BaRegPortIn : BaRegPortIn_t) return BooleanVector is
  begin
    return RegEnables(To_BaAddr(RegOffset), RegSize, BaRegPortIn, DoWt=>false);
  end function RegReadEnables;

  
  function RegReadEnables(RegInfo : XReg2_t;
                          BaRegPortIn : BaRegPortIn_t;
                          BaseAddr : natural := 0) return BooleanVector is
  begin
    return RegReadEnables(BaAddrResize(BaseAddr + RegInfo.offset), RegInfo.size, BaRegPortIn);
  end function RegReadEnables;

  
  
  function RegReadData(RegOffset : BaRegPortAddress_t;
                       RegSize : integer;
                       RegReadValue : std_logic_vector;
                       BaRegPortIn : BaRegPortIn_t) return BaRegPortData_t is
    alias LocalData : std_logic_vector(RegReadValue'length - 1 downto 0) is RegReadValue;
    variable RegByte : integer;
    variable RetVal : BaRegPortData_t := (others => '0');
  begin
    --synopsys translate_off
    assert RegReadValue'length = RegSize
      report "Register read value must match register size."
      severity FAILURE;
    --synopsys translate_on
    if RegSelected(RegOffset, RegSize, BaRegPortIn) then
      if RegSize <= kBaRegPortDataWidth then
        RetVal(OffsetMod(RegOffset)*8+RegSize-1 downto OffsetMod(RegOffset)*8) := LocalData;
      else
        RegByte := to_integer(BaRegPortIn.Address(Log2(RegSize / 8) - 1 downto
                       kBaRegPortByteWidthLog2)) *
                       kBaRegPortDataWidth;
        RetVal := LocalData(RegByte + kBaRegPortDataWidth - 1 downto RegByte);
      end if;
    end if;
    return RetVal;
  end function RegReadData;

  
  function RegReadData(RegOffset : integer;
                       RegSize : integer;
                       RegReadValue : std_logic_vector;
                       BaRegPortIn : BaRegPortIn_t) return BaRegPortData_t is
  begin
    return RegReadData(To_BaAddr(RegOffset), RegSize, RegReadValue, BaRegPortIn);
  end function RegReadData;

  
  
  
  function RegReadData(RegInfo : XReg2_t;
                       RegReadValue : std_logic_vector;
                       BaRegPortIn : BaRegPortIn_t;
                       BaseAddr : natural := 0) return BaRegPortData_t is
    variable RetVal : BaRegPortData_t := (others => '0');
    variable RdData : std_logic_vector(RegReadValue'length - 1 downto 0) := RegReadValue;
  begin
    RdData := RdData and GetRdMask(RegInfo);
    if RegInfo.readable then
      RetVal := RegReadData(BaAddrResize(BaseAddr + RegInfo.offset), RegInfo.size, RdData, BaRegPortIn);
    end if;
    return RetVal;
  end function RegReadData;

  
  
  
  function RegAccess(RegOffset : integer; RegSize : integer;
                     BaRegPortIn : BaRegPortIn_t) return boolean is
  begin
    return OrVector(RegWriteEnables(RegOffset, RegSize, BaRegPortIn)) or
           OrVector(RegReadEnables(RegOffset, RegSize, BaRegPortIn));
  end function RegAccess;

  
  
  
  function RegAccess(RegInfo : XReg2_t;
                     BaRegPortIn : BaRegPortIn_t;
                     BaseAddr : natural := 0) return boolean is
  begin
    return (OrVector(RegWriteEnables(RegInfo, BaRegPortIn, BaseAddr)) and RegInfo.writable) or
           (OrVector(RegReadEnables(RegInfo, BaRegPortIn, BaseAddr)) and RegInfo.readable);
  end function RegAccess;

  
  
  
  
  function DriveRegPortOut(RegInfo : XReg2_t;
                           RegReadValue : std_logic_vector;
                           BaRegPortIn : BaRegPortIn_t;
                           BaseAddr : natural := 0) return BaRegPortOut_t is
    variable Accessed : boolean;
    variable ReturnVal : BaRegPortOut_t := kBaRegPortOutZero;
  begin
    Accessed := RegAccess(RegInfo, BaRegPortIn, BaseAddr);
    if RegInfo.readable and Accessed then
      ReturnVal.Data := RegReadData(RegInfo, RegReadValue, BaRegPortIn, BaseAddr);
    end if;
    ReturnVal.Ack := Accessed;
    return ReturnVal;
  end function DriveRegPortOut;

  
  
  function DriveRegPortOut(RegInfo : XReg2_t;
                           BaRegPortIn : BaRegPortIn_t;
                           BaseAddr : natural := 0) return BaRegPortOut_t is
  begin
    --synopsys translate_off
    assert not RegInfo.readable
      report "Readable registers need a RegReadValue."
      severity FAILURE;
    --synopsys translate_on
    return DriveRegPortOut(RegInfo, Zeros(RegInfo.size), BaRegPortIn, BaseAddr);
  end function DriveRegPortOut;

  
  function "or" (L, R : BaRegPortOut_t) return BaRegPortOut_t is
    variable RetVal : BaRegPortOut_t;
  begin
    RetVal.Data := L.Data or R.Data;
    RetVal.Ack := L.Ack or R.Ack;
    return RetVal;
  end function "or";

  
  function OrArray(BaRegPortOutArray : BaRegPortOutArray_t) return BaRegPortOut_t is
    variable RetVal : BaRegPortOut_t := kBaRegPortOutZero;
  begin
    for i in BaRegPortOutArray'range loop
      RetVal := RetVal or BaRegPortOutArray(i);
    end loop;
    return RetVal;
  end function OrArray;

  
  
  
  function WindowBaRegPortIn (kBase, kSize : natural;
                              BaRegPortIn : BaRegPortIn_t) return BaRegPortIn_t is
    variable RPI : BaRegPortIn_t;
  begin
    --synopsys translate_off
    assert (kBase mod kBaRegPortDataWidthInBytes = 0) and (kSize mod kBaRegPortDataWidthInBytes = 0)
      report "Window cannot cross data bus word boundaries."
      severity FAILURE;
    --synopsys translate_on
    RPI := BaRegPortIn;
      RPI.Address := BaRegPortIn.Address - kBase;
    if not RangeSelected(AddrLo=>kBase, AddrHi=>kBase+kSize-1, RPI=>BaRegPortIn) then
      RPI.WtStrobe := (others => false);
      RPI.RdStrobe := (others => false);
    end if;
    return RPI;
  end function WindowBaRegPortIn;

  
  function WindowBaRegPortIn (RegInfo : XReg2_t;
                              BaRegPortIn : BaRegPortIn_t) return BaRegPortIn_t is
  begin
    --synopsys translate_off
    assert not RegInfo.isreg
      report "WindowBaRegPortIn must be called on a RAM or a Window"
      severity failure;
    --synopsys translate_on
    return WindowBaRegPortIn(kBase=>GetOffset(RegInfo), kSize=>GetSize(RegInfo), BaRegPortIn=>BaRegPortIn);
  end function WindowBaRegPortIn;

end PkgBaRegPort;