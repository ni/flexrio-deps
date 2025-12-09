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

Package PkgNiUtilities is

  
  
  

  type NiClk_t is record
    
    C : std_logic;
    
    
    
    
    
    
    
    
    
    kSyncCnt : positive;
  end record;

  constant kNiClkDef : NiClk_t := ('0', 2);

  
  
  
  
  
  
  
  
  
  
  function ToNiClk (ClkIn : std_logic; SyncCnt : positive) return NiClk_t;
  
  function ToNiClk2 (ClkIn : std_logic) return NiClk_t;

  
  
  
  
  
  function rising_edge(signal Clk : NiClk_t) return boolean;
  function falling_edge(signal Clk : NiClk_t) return boolean;

  
  
  

  type BooleanVector is array ( natural range<> ) of boolean;
  type IntegerVector is array ( natural range <>) of integer;
  type NaturalVector is array ( natural range <>) of natural;
  type Slv64Ary_t is array ( natural range <> ) of std_logic_vector(63 downto 0);
  type Slv32Ary_t is array ( natural range <> ) of std_logic_vector(31 downto 0);
  type Slv16Ary_t is array ( natural range <> ) of std_logic_vector(15 downto 0);

  
  
  

  
  function to_Boolean (s : std_ulogic) return boolean;

  
  function to_BooleanActiveLow (s : std_ulogic) return boolean;

  
  function to_BooleanVector(s : std_logic_vector) return BooleanVector;
  function to_BooleanVector(s : unsigned) return BooleanVector;

  
  function to_BooleanVectorActiveLow(s : std_logic_vector)
                                     return BooleanVector;

  
  function to_StdLogic(b : boolean) return std_ulogic;

  
  function to_StdLogicActiveLow(b : boolean) return std_ulogic;

  
  function to_StdLogicVector(b : BooleanVector) return std_logic_vector;
  function to_Unsigned(b : BooleanVector) return unsigned;

  
  function to_StdLogicVectorActiveLow(b : BooleanVector) return std_logic_vector;
  function to_UnsignedActiveLow(b : BooleanVector) return unsigned;

  
  
  

  
  function Zeros(Length : natural) return std_logic_vector;

  
  function Ones(Length : natural) return std_logic_vector;

  
  function Log2(arg : positive) return natural;
  function Log4(arg : positive) return natural;

  
  function CountOnes(arg : std_logic_vector) return natural;

  
  function CountOnes(arg : unsigned) return natural;

  
  function IsPowerOf2(arg : unsigned) return boolean;

  
  function IsPowerOf2(arg : natural) return boolean;

  
  
  

  constant kByteSize : natural := 8;

  
  
  
  
  
  
  
  

  
  
  
  
  
  
  
  
  
  

  
  
  
  
  
  
  
  
  
  


  
  
  

  
  function Larger(a,b : integer) return integer;

  
  
  
  

  
  function Smaller(a,b : integer) return integer;

  
  
  
  
  
  
  

  
  
  

  
  function OrVector (arg : std_logic_vector) return std_ulogic;
  function OrVector (arg : unsigned) return std_ulogic;
  function OrVector (arg : BooleanVector) return boolean;

  
  function AndVector (arg : std_logic_vector) return std_ulogic;
  function AndVector (arg : unsigned) return std_ulogic;
  function AndVector (arg : BooleanVector) return boolean;

  
  function XorVector (arg : std_logic_vector) return std_ulogic;
  function XorVector (arg : unsigned) return std_ulogic;
  function XorVector (arg : BooleanVector) return boolean;

  
  
  
  
  

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  
  
  
  
  
  
  
  
  
  
  
  
  function SetBits(Indices : NaturalVector; W : natural) return std_logic_vector;
  function SetBits(Indices : NaturalVector) return std_logic_vector;

  function SetBit(Index : natural;
                  Val : std_logic;
                  W : natural) return std_logic_vector;
  function SetBit(Index : natural;
                  Val : std_logic) return std_logic_vector;

  function SetBit(Index : natural; W : natural) return std_logic_vector;
  function SetBit(Index : natural) return std_logic_vector;

  function SetBit(Index : natural;
                  Val : boolean;
                  W : natural) return std_logic_vector;
  function SetBit(Index : natural;
                  Val : boolean) return std_logic_vector;

  function SetField(Index : natural;
                    Val : unsigned;
                    W : natural) return std_logic_vector;
  function SetField(Index : natural;
                    Val : unsigned) return std_logic_vector;

  function SetField(Index : natural;
                    Val : std_logic_vector;
                    W : natural) return std_logic_vector;
  function SetField(Index : natural;
                    Val : std_logic_vector) return std_logic_vector;

  function SetField(Index : natural;
                    Val : natural;
                    W : natural) return std_logic_vector;
  function SetField(Index : natural;
                    Val : natural) return std_logic_vector;

end Package PkgNiUtilities;

Package body PkgNiUtilities is

  
  
  
  function ToNiClk (ClkIn : std_logic; SyncCnt : positive) return NiClk_t is
    variable ClkOut : NiClk_t;
  begin
    ClkOut.C := ClkIn;
    ClkOut.kSyncCnt := SyncCnt;
    return ClkOut;
  end function ToNiClk;

  
  
  
  
  
  
  
  function ToNiClk2 (ClkIn : std_logic) return NiClk_t is
  begin
    return ToNiClk(ClkIn, 2);
  end function ToNiClk2;

  
  function rising_edge(signal Clk : NiClk_t) return boolean is
  begin
    return rising_edge(Clk.C);
  end function rising_edge;

  
  function falling_edge(signal Clk : NiClk_t) return boolean is
  begin
    return falling_edge(Clk.C);
  end function falling_edge;


  
  
  
  
  
  
  
  
  
  
  
  
  
  

  
  
  
  
  
  function to_Boolean (s : std_ulogic) return boolean is
  begin
    return (To_X01(s)='1');
  end to_Boolean;

  
  function to_BooleanActiveLow (s : std_ulogic) return boolean is
  begin
    return (To_X01(s)='0');
  end to_BooleanActiveLow;

  
  function to_BooleanVector(s : std_logic_vector) return BooleanVector is
    variable rval : BooleanVector(s'range);
  begin
    for i in rval'range loop
      rval(i) := to_Boolean(s(i));
    end loop;
    return rval;
  end to_BooleanVector;

  
  function to_BooleanVector(s : unsigned) return BooleanVector is
  begin
    return to_BooleanVector(std_logic_vector(s));
  end to_BooleanVector;

  
  function to_BooleanVectorActiveLow(s : std_logic_vector)
                                     return BooleanVector is
    variable rval : BooleanVector(s'range);
  begin
    for i in rval'range loop
      rval(i) := to_BooleanActiveLow(s(i));
    end loop;
    return rval;
  end to_BooleanVectorActiveLow;

  
  function to_StdLogic(b : boolean) return std_ulogic is
  begin
    if b then
      return '1';
    else
      return '0';
    end if;
  end to_StdLogic;

  function to_StdLogicActiveLow(b : boolean) return std_ulogic is
  begin
    return not to_StdLogic(b);
  end to_StdLogicActiveLow;

  function to_StdLogicVector(b : BooleanVector) return std_logic_vector is
    variable rval : std_logic_vector(b'range);
  begin
    for i in rval'range loop
      rval(i) := to_StdLogic(b(i));
    end loop;
    return rval;
  end to_StdLogicVector;

  function to_Unsigned(b : BooleanVector) return unsigned is
  begin
    return unsigned(to_StdLogicVector(b));
  end to_Unsigned;

  function to_StdLogicVectorActiveLow(b : BooleanVector)
                                      return std_logic_vector is
  begin
    return not to_StdLogicVector(b);
  end to_StdLogicVectorActiveLow;

  function to_UnsignedActiveLow(b : BooleanVector) return unsigned is
  begin
    return unsigned(to_StdLogicVectorActiveLow(b));
  end to_UnsignedActiveLow;

  function Zeros(Length : natural) return std_logic_vector is
    variable Vec: std_logic_vector(1 to Length) := (others => '0');
  begin
    return Vec;
  end Zeros;

  function Ones(Length : natural) return std_logic_vector is
    variable Vec: std_logic_vector(1 to Length) := (others => '1');
  begin
    return Vec;
  end Ones;

  
  
  
  
  
  
  
  
  
  
  
  
  function Log2(Arg : positive) return natural is
    variable ReturnVal : natural;
    variable ShiftedArg : natural;
  begin
    ReturnVal := 0;
    ShiftedArg := Arg-1;
    while ShiftedArg > 0 loop
      ShiftedArg := ShiftedArg / 2;
      ReturnVal := ReturnVal + 1;
    end loop;
    return ReturnVal;
  end Log2;

  
  function Log4(Arg : positive) return natural is
    variable ReturnVal : natural;
    variable ShiftedArg : natural;
  begin
    ReturnVal := 0;
    ShiftedArg := Arg-1;
    while ShiftedArg > 0 loop
      ShiftedArg := ShiftedArg / 4;
      ReturnVal := ReturnVal + 1;
    end loop;
    return ReturnVal;
  end Log4;

  
  function CountOnes(arg : std_logic_vector) return natural is
    
    variable argNormal : std_logic_vector(1 to arg'length) := arg;
    constant kMidPoint : natural := arg'length / 2;
  begin

    if arg'length = 0 then
      return 0;
    elsif arg'length = 1 then
      if To_Boolean(argNormal(1)) then
        return 1;
      else 
        return 0;
      end if;
    else
      return CountOnes(argNormal(1 to kMidPoint)) 
           + CountOnes(argNormal(kMidPoint + 1 to argNormal'high));
    end if;

  end function CountOnes;

  
  function CountOnes(arg : unsigned) return natural is
  begin
    return CountOnes(std_logic_vector(arg));
  end function CountOnes;

  
  function IsPowerOf2(arg : unsigned) return boolean is
  begin
    return CountOnes(arg) = 1;
  end function IsPowerOf2;

  
  function IsPowerOf2(arg : natural) return boolean is
  begin
    return IsPowerOf2(To_Unsigned(arg,32));
  end function IsPowerOf2;



  
  
  
  
  

  
  
  
  
  

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  
  function Larger(a,b : integer) return integer is
  begin
    if a > b then
      return a;
    else
      return b;
    end if;
  end Larger;

  
  function Smaller(a,b : integer) return integer is
  begin
    if a < b then
      return a;
    else
      return b;
    end if;
  end Smaller;

  
  function OrVector (arg : std_logic_vector) return std_ulogic is
    variable ReturnVal : std_ulogic;
  begin
    ReturnVal := '0';
    for i in arg'range loop
      ReturnVal := ReturnVal or arg(i);
    end loop;
    return ReturnVal;
  end OrVector;

  function OrVector (arg : unsigned) return std_ulogic is
  begin
    return OrVector(std_logic_vector(arg));
  end OrVector;

  function OrVector (arg : BooleanVector) return boolean is
  begin
    return To_Boolean(OrVector(To_StdLogicVector(arg)));
  end OrVector;

  
  function AndVector (arg : std_logic_vector) return std_ulogic is
    variable ReturnVal : std_ulogic;
  begin
    ReturnVal := '1';
    for i in arg'range loop
      ReturnVal := ReturnVal and arg(i);
    end loop;
    return ReturnVal;
  end AndVector;

  function AndVector (arg : unsigned) return std_ulogic is
  begin
    return AndVector(std_logic_vector(arg));
  end AndVector;

  function AndVector (arg : BooleanVector) return boolean is
  begin
    return To_Boolean(AndVector(To_StdLogicVector(arg)));
  end AndVector;

  
  function XorVector (arg : std_logic_vector) return std_ulogic is
    variable ReturnVal : std_ulogic;
  begin
    ReturnVal := '0';
    for i in arg'range loop
      ReturnVal := ReturnVal Xor arg(i);
    end loop;
    return ReturnVal;
  end XorVector;

  function XorVector (arg : unsigned) return std_ulogic is
  begin
    return XorVector(std_logic_vector(arg));
  end XorVector;

  function XorVector (arg : BooleanVector) return boolean is
  begin
    return To_Boolean(XorVector(To_StdLogicVector(arg)));
  end XorVector;


  
  
  

  
  function SetBits(Indices : NaturalVector; W : natural) return std_logic_vector is
    variable Data : std_logic_vector(W-1 downto 0);
  begin
    Data := (others => '0');
    for i in Indices'range loop
      Data(Indices(i)) := '1';
    end loop;
    return Data;
  end function SetBits;

  function SetBits(Indices : NaturalVector) return std_logic_vector is
  begin
    return SetBits ( Indices=>Indices, W=>32 );
  end function SetBits;

  
  function SetBit(Index : natural;
                  Val : std_logic;
                  W : natural) return std_logic_vector is
    variable Data : std_logic_vector(W-1 downto 0);
  begin
    --synopsys translate_off
    assert Index < W
      report "SetBit: Index (" & integer'image(Index) & ") must be less than W (" & integer'image(W) & ")"
      severity error;
    --synopsys translate_on
    Data := (others => '0');
    Data(Index) := Val;
    return Data;
  end function SetBit;

  function SetBit(Index : natural;
                  Val : std_logic ) return std_logic_vector is
  begin
    return SetBit ( Index=>Index, Val=>Val, W=>32 );
  end function SetBit;

  
  function SetBit(Index : natural; W : natural) return std_logic_vector is
  begin
    return SetBit(Index=>Index, Val=>'1', W=>W);
  end function SetBit;

  function SetBit(Index : natural) return std_logic_vector is
  begin
    return SetBit ( Index=>Index, W=>32 );
  end function SetBit;

  
  function SetBit(Index : natural;
                  Val : boolean;
                  W : natural) return std_logic_vector is
  begin
    return SetBit(Index=>Index, Val=>To_StdLogic(Val), W=>W);
  end function SetBit;

  function SetBit(Index : natural;
                  Val : boolean) return std_logic_vector is
  begin
    return SetBit ( Index=>Index, Val=>Val, W=>32 );
  end function SetBit;

  
  
  function SetField(Index : natural;
                    Val : unsigned;
                    W : natural) return std_logic_vector is
    variable Data : std_logic_vector(W-1 downto 0) := (others => '0');
  begin
    --synopsys translate_off
    assert Index < W
      report "SetField: Index (" & integer'image(Index) & ") must be less than W (" & integer'image(W) & ")"
      severity error;
    assert (Val'length + Index) <= W
      report "Val is too big to fit in vector" severity error;
    --synopsys translate_on
    Data(W-1 downto Index) := std_logic_vector(resize(Val, W-Index));
    return Data;
  end function SetField;

  function SetField(Index : natural;
                    Val : unsigned) return std_logic_vector is
  begin
    return SetField ( Index=>Index, Val=>Val, W=>32 );
  end function SetField;

  
  
  function SetField(Index : natural;
                    Val : std_logic_vector;
                    W : natural) return std_logic_vector is
  begin
    return SetField(Index=>Index, Val=>unsigned(Val), W=>W);
  end function SetField;

  function SetField(Index : natural;
                    Val : std_logic_vector) return std_logic_vector is
  begin
    return SetField ( Index=>Index, Val=>Val, W=>32 );
  end function SetField;

  
  
  function SetField(Index : natural;
                    Val : natural;
                    W : natural) return std_logic_vector is
  begin
    return SetField(Index=>Index, Val=>To_Unsigned(Val, W-Index), W=>W);
  end function SetField;

  function SetField(Index : natural;
                    Val : natural) return std_logic_vector is
  begin
    return SetField(Index=>Index, Val=>Val, W=>32);
  end function SetField;

end Package body PkgNiUtilities;
