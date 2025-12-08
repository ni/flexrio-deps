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

package PkgDram2DP is





  
  
  
  
  
  
  
  
  
  
  
  
  
  





  
  constant k32BitAddressSize: integer := 32;
  constant k32BitAddressMask : std_logic_vector(31 downto 0) := X"00000000";

  
  constant kBufferBaggageRegTypeSize: integer := 32;
  constant kBufferBaggageRegTypeMask : std_logic_vector(31 downto 0) := X"ffffffff";
  constant kBaggageSize       : integer := 32;  
  constant kBaggageMsb        : integer := 31;  
  constant kBaggage           : integer :=  0;  





  
  constant kVersionRegister : integer := 16#0#; 
  constant kVersionRegisterSize: integer := 32;  
  constant kVersionRegisterMask : std_logic_vector(31 downto 0) := X"00000000";
  function kVersionRegisterRec return XReg2_t; 

  
  constant kCoreEnabled : integer := 16#4#; 
  constant kCoreEnabledSize: integer := 32;  
  constant kCoreEnabledMask : std_logic_vector(31 downto 0) := X"00000001";
  constant kEnableSize       : integer := 1;  
  constant kEnableMsb        : integer := 0;  
  constant kEnable           : integer := 0;  
  function kCoreEnabledRec return XReg2_t; 

  
  constant kNumberOfBuffers : integer := 16#8#; 
  constant kNumberOfBuffersSize: integer := 32;  
  constant kNumberOfBuffersMask : std_logic_vector(31 downto 0) := X"0000ffff";
  constant kNumOfBuffersSize       : integer := 16;  
  constant kNumOfBuffersMsb        : integer := 15;  
  constant kNumOfBuffers           : integer :=  0;  
  function kNumberOfBuffersRec return XReg2_t; 

  
  constant kBufferAddressLoZero : integer := 16#C#; 
  constant kBufferAddressLoZeroSize: integer := 32;  
  function kBufferAddressLoZeroRec return XReg2_t; 

  
  constant kBufferAddressHiZero : integer := 16#10#; 
  constant kBufferAddressHiZeroSize: integer := 32;  
  function kBufferAddressHiZeroRec return XReg2_t; 

  
  constant kCoreEnabled2 : integer := 16#14#; 
  constant kCoreEnabled2Size: integer := 32;  
  constant kCoreEnabled2Mask : std_logic_vector(31 downto 0) := X"00000077";
  constant kHmbEnableSize       : integer := 1;  
  constant kHmbEnableMsb        : integer := 0;  
  constant kHmbEnable           : integer := 0;  
  constant kHmbDisableSize       : integer := 1;  
  constant kHmbDisableMsb        : integer := 1;  
  constant kHmbDisable           : integer := 1;  
  constant kHmbEnabledSize       : integer := 1;  
  constant kHmbEnabledMsb        : integer := 2;  
  constant kHmbEnabled           : integer := 2;  
  constant kLlbEnableSize       : integer := 1;  
  constant kLlbEnableMsb        : integer := 4;  
  constant kLlbEnable           : integer := 4;  
  constant kLlbDisableSize       : integer := 1;  
  constant kLlbDisableMsb        : integer := 5;  
  constant kLlbDisable           : integer := 5;  
  constant kLlbEnabledSize       : integer := 1;  
  constant kLlbEnabledMsb        : integer := 6;  
  constant kLlbEnabled           : integer := 6;  
  function kCoreEnabled2Rec return XReg2_t; 

  
  constant kCoreCapabilities : integer := 16#18#; 
  constant kCoreCapabilitiesSize: integer := 32;  
  constant kCoreCapabilitiesMask : std_logic_vector(31 downto 0) := X"031f1f0f";
  constant kCapMaxNumOfMemBuffersSize       : integer := 4;  
  constant kCapMaxNumOfMemBuffersMsb        : integer := 3;  
  constant kCapMaxNumOfMemBuffers           : integer := 0;  
  constant kCapSizeOfMemBuffersSize       : integer :=  5;  
  constant kCapSizeOfMemBuffersMsb        : integer := 12;  
  constant kCapSizeOfMemBuffers           : integer :=  8;  
  constant kCapSizeOfLlbMemBufferSize       : integer :=  5;  
  constant kCapSizeOfLlbMemBufferMsb        : integer := 20;  
  constant kCapSizeOfLlbMemBuffer           : integer := 16;  
  constant kCapHmbInUseSize       : integer :=  1;  
  constant kCapHmbInUseMsb        : integer := 24;  
  constant kCapHmbInUse           : integer := 24;  
  constant kCapLlbInUseSize       : integer :=  1;  
  constant kCapLlbInUseMsb        : integer := 25;  
  constant kCapLlbInUse           : integer := 25;  
  function kCoreCapabilitiesRec return XReg2_t; 

  
  constant kLlbCapabilities : integer := 16#1C#; 
  constant kLlbCapabilitiesSize: integer := 32;  
  constant kLlbCapabilitiesMask : std_logic_vector(31 downto 0) := X"0fffffff";
  constant kDevRamSwBaseOffsetSize       : integer := 28;  
  constant kDevRamSwBaseOffsetMsb        : integer := 27;  
  constant kDevRamSwBaseOffset           : integer :=  0;  
  function kLlbCapabilitiesRec return XReg2_t; 

  
  constant kLowLatencyBufferLo : integer := 16#20#; 
  constant kLowLatencyBufferLoSize: integer := 32;  
  function kLowLatencyBufferLoRec return XReg2_t; 

  
  constant kLowLatencyBufferHi : integer := 16#24#; 
  constant kLowLatencyBufferHiSize: integer := 32;  
  function kLowLatencyBufferHiRec return XReg2_t; 

  
  constant kLowLatencyBufferBaggage : integer := 16#28#; 
  constant kLowLatencyBufferBaggageSize: integer := 32;  
  function kLowLatencyBufferBaggageRec return XReg2_t; 

  
  function kBufferAddressLo (i:integer) return integer; 
  constant kBufferAddressLoCount : integer := 32; 
  constant kBufferAddressLoSize: integer := 32; 
  function kBufferAddressLoRec (i:integer) return XReg2_t; 

  
  function kBufferAddressHi (i:integer) return integer; 
  constant kBufferAddressHiCount : integer := 32; 
  constant kBufferAddressHiSize: integer := 32; 
  function kBufferAddressHiRec (i:integer) return XReg2_t; 

  
  function kBufferBaggage (i:integer) return integer; 
  constant kBufferBaggageCount : integer := 32; 
  constant kBufferBaggageSize: integer := 32; 
  function kBufferBaggageRec (i:integer) return XReg2_t; 

end package;

package body PkgDram2DP is

  
  function kVersionRegisterRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"0");
    Rec.size := 32;
    Rec.readable := true;
    Rec.writable := false;
    Rec.wmask := XRegResize(X"00000000");
    Rec.rmask := XRegResize(X"ffffffff");
    Rec.strobemask := XRegResize(X"00000000");
    Rec.clearablemask := XRegResize(X"00000000");
    
    
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("VersionRegister");
    --synopsys translate_on
    return Rec;
  end function kVersionRegisterRec;

  
  function kCoreEnabledRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"4");
    Rec.size := 32;
    Rec.readable := true;
    Rec.writable := true;
    Rec.wmask := XRegResize(X"00000001");
    Rec.rmask := XRegResize(X"00000001");
    Rec.strobemask := XRegResize(X"00000000");
    Rec.clearablemask := XRegResize(X"00000000");
    Rec.initialvalue := XRegResize(X"00000000");
    
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("CoreEnabled");
    --synopsys translate_on
    return Rec;
  end function kCoreEnabledRec;

  
  function kNumberOfBuffersRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"8");
    Rec.size := 32;
    Rec.readable := true;
    Rec.writable := true;
    Rec.wmask := XRegResize(X"0000ffff");
    Rec.rmask := XRegResize(X"0000ffff");
    Rec.strobemask := XRegResize(X"00000000");
    Rec.clearablemask := XRegResize(X"00000000");
    Rec.initialvalue := XRegResize(X"00000000");
    
    Rec.msblookupw(kNumOfBuffers) := kNumOfBuffersMsb;
    Rec.msblookupr(kNumOfBuffers) := kNumOfBuffersMsb;
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("NumberOfBuffers");
    --synopsys translate_on
    return Rec;
  end function kNumberOfBuffersRec;

  
  function kBufferAddressLoZeroRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"C");
    Rec.size := 32;
    Rec.readable := true;
    Rec.writable := true;
    Rec.wmask := XRegResize(X"ffffffff");
    Rec.rmask := XRegResize(X"ffffffff");
    Rec.strobemask := XRegResize(X"00000000");
    Rec.clearablemask := XRegResize(X"00000000");
    Rec.initialvalue := XRegResize(X"00000000");
    
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("BufferAddressLoZero");
    --synopsys translate_on
    return Rec;
  end function kBufferAddressLoZeroRec;

  
  function kBufferAddressHiZeroRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"10");
    Rec.size := 32;
    Rec.readable := true;
    Rec.writable := true;
    Rec.wmask := XRegResize(X"ffffffff");
    Rec.rmask := XRegResize(X"ffffffff");
    Rec.strobemask := XRegResize(X"00000000");
    Rec.clearablemask := XRegResize(X"00000000");
    Rec.initialvalue := XRegResize(X"00000000");
    
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("BufferAddressHiZero");
    --synopsys translate_on
    return Rec;
  end function kBufferAddressHiZeroRec;

  
  function kCoreEnabled2Rec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"14");
    Rec.size := 32;
    Rec.readable := true;
    Rec.writable := true;
    Rec.wmask := XRegResize(X"00000033");
    Rec.rmask := XRegResize(X"00000044");
    Rec.strobemask := XRegResize(X"00000033");
    Rec.clearablemask := XRegResize(X"00000000");
    
    
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("CoreEnabled2");
    --synopsys translate_on
    return Rec;
  end function kCoreEnabled2Rec;

  
  function kCoreCapabilitiesRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"18");
    Rec.size := 32;
    Rec.readable := true;
    Rec.writable := false;
    Rec.wmask := XRegResize(X"031f1f0f");
    Rec.rmask := XRegResize(X"031f1f0f");
    Rec.strobemask := XRegResize(X"00000000");
    Rec.clearablemask := XRegResize(X"00000000");
    Rec.initialvalue := XRegResize(X"00000000");
    
    Rec.msblookupw(kCapMaxNumOfMemBuffers) := kCapMaxNumOfMemBuffersMsb;
    Rec.msblookupw(kCapSizeOfMemBuffers) := kCapSizeOfMemBuffersMsb;
    Rec.msblookupw(kCapSizeOfLlbMemBuffer) := kCapSizeOfLlbMemBufferMsb;
    Rec.msblookupr(kCapMaxNumOfMemBuffers) := kCapMaxNumOfMemBuffersMsb;
    Rec.msblookupr(kCapSizeOfMemBuffers) := kCapSizeOfMemBuffersMsb;
    Rec.msblookupr(kCapSizeOfLlbMemBuffer) := kCapSizeOfLlbMemBufferMsb;
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("CoreCapabilities");
    --synopsys translate_on
    return Rec;
  end function kCoreCapabilitiesRec;

  
  function kLlbCapabilitiesRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"1C");
    Rec.size := 32;
    Rec.readable := true;
    Rec.writable := false;
    Rec.wmask := XRegResize(X"0fffffff");
    Rec.rmask := XRegResize(X"0fffffff");
    Rec.strobemask := XRegResize(X"00000000");
    Rec.clearablemask := XRegResize(X"00000000");
    Rec.initialvalue := XRegResize(X"00000000");
    
    Rec.msblookupw(kDevRamSwBaseOffset) := kDevRamSwBaseOffsetMsb;
    Rec.msblookupr(kDevRamSwBaseOffset) := kDevRamSwBaseOffsetMsb;
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("LlbCapabilities");
    --synopsys translate_on
    return Rec;
  end function kLlbCapabilitiesRec;

  
  function kLowLatencyBufferLoRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"20");
    Rec.size := 32;
    Rec.readable := true;
    Rec.writable := true;
    Rec.wmask := XRegResize(X"ffffffff");
    Rec.rmask := XRegResize(X"ffffffff");
    Rec.strobemask := XRegResize(X"00000000");
    Rec.clearablemask := XRegResize(X"00000000");
    Rec.initialvalue := XRegResize(X"00000000");
    
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("LowLatencyBufferLo");
    --synopsys translate_on
    return Rec;
  end function kLowLatencyBufferLoRec;

  
  function kLowLatencyBufferHiRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"24");
    Rec.size := 32;
    Rec.readable := true;
    Rec.writable := true;
    Rec.wmask := XRegResize(X"ffffffff");
    Rec.rmask := XRegResize(X"ffffffff");
    Rec.strobemask := XRegResize(X"00000000");
    Rec.clearablemask := XRegResize(X"00000000");
    Rec.initialvalue := XRegResize(X"00000000");
    
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("LowLatencyBufferHi");
    --synopsys translate_on
    return Rec;
  end function kLowLatencyBufferHiRec;

  
  function kLowLatencyBufferBaggageRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"28");
    Rec.size := 32;
    Rec.readable := true;
    Rec.writable := true;
    Rec.wmask := XRegResize(X"ffffffff");
    Rec.rmask := XRegResize(X"ffffffff");
    Rec.strobemask := XRegResize(X"00000000");
    Rec.clearablemask := XRegResize(X"00000000");
    Rec.initialvalue := XRegResize(X"00000000");
    
    Rec.msblookupw(kBaggage) := kBaggageMsb;
    Rec.msblookupr(kBaggage) := kBaggageMsb;
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("LowLatencyBufferBaggage");
    --synopsys translate_on
    return Rec;
  end function kLowLatencyBufferBaggageRec;

  
  function kBufferAddressLo (i:integer) return integer is
  begin
    --synopsys translate_off
    assert i>=0 and i<=31 report "kBufferAddressLo i=" & integer'image(i) & " is out of range" severity error;
    --synopsys translate_on
    return (i * 16) + 16#100#;
  end function kBufferAddressLo;

  
  function kBufferAddressLoRec (i:integer) return XReg2_t is
    variable Rec : XReg2_t;
  begin
    --synopsys translate_off
    assert i>=0 and i<=31 report "kBufferAddressLoRec i=" & integer'image(i) & " is out of range" severity error;
    --synopsys translate_on
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := (i * 16) + XAddrResize(X"100");
    Rec.size := 32;
    Rec.readable := true;
    Rec.writable := true;
    Rec.wmask := XRegResize(X"ffffffff");
    Rec.rmask := XRegResize(X"ffffffff");
    Rec.strobemask := XRegResize(X"00000000");
    Rec.clearablemask := XRegResize(X"00000000");
    Rec.initialvalue := XRegResize(X"00000000");
    
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("BufferAddressLo");
    --synopsys translate_on
    return Rec;
  end function kBufferAddressLoRec;

  
  function kBufferAddressHi (i:integer) return integer is
  begin
    --synopsys translate_off
    assert i>=0 and i<=31 report "kBufferAddressHi i=" & integer'image(i) & " is out of range" severity error;
    --synopsys translate_on
    return (i * 16) + 16#104#;
  end function kBufferAddressHi;

  
  function kBufferAddressHiRec (i:integer) return XReg2_t is
    variable Rec : XReg2_t;
  begin
    --synopsys translate_off
    assert i>=0 and i<=31 report "kBufferAddressHiRec i=" & integer'image(i) & " is out of range" severity error;
    --synopsys translate_on
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := (i * 16) + XAddrResize(X"104");
    Rec.size := 32;
    Rec.readable := true;
    Rec.writable := true;
    Rec.wmask := XRegResize(X"ffffffff");
    Rec.rmask := XRegResize(X"ffffffff");
    Rec.strobemask := XRegResize(X"00000000");
    Rec.clearablemask := XRegResize(X"00000000");
    Rec.initialvalue := XRegResize(X"00000000");
    
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("BufferAddressHi");
    --synopsys translate_on
    return Rec;
  end function kBufferAddressHiRec;

  
  function kBufferBaggage (i:integer) return integer is
  begin
    --synopsys translate_off
    assert i>=0 and i<=31 report "kBufferBaggage i=" & integer'image(i) & " is out of range" severity error;
    --synopsys translate_on
    return (i * 16) + 16#108#;
  end function kBufferBaggage;

  
  function kBufferBaggageRec (i:integer) return XReg2_t is
    variable Rec : XReg2_t;
  begin
    --synopsys translate_off
    assert i>=0 and i<=31 report "kBufferBaggageRec i=" & integer'image(i) & " is out of range" severity error;
    --synopsys translate_on
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := (i * 16) + XAddrResize(X"108");
    Rec.size := 32;
    Rec.readable := true;
    Rec.writable := true;
    Rec.wmask := XRegResize(X"ffffffff");
    Rec.rmask := XRegResize(X"ffffffff");
    Rec.strobemask := XRegResize(X"00000000");
    Rec.clearablemask := XRegResize(X"00000000");
    Rec.initialvalue := XRegResize(X"00000000");
    
    Rec.msblookupw(kBaggage) := kBaggageMsb;
    Rec.msblookupr(kBaggage) := kBaggageMsb;
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("BufferBaggage");
    --synopsys translate_on
    return Rec;
  end function kBufferBaggageRec;

end package body;