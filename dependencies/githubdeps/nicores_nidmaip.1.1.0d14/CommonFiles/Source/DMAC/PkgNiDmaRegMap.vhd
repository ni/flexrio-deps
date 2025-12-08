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
  use work.PkgBaggageRegTypeRegMap.all;
  --synopsys translate_off
  use work.PkgNiSim.all;
  --synopsys translate_on

package PkgNiDmaRegMap is





  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  













  
  constant kByteSwap_tSize : integer := 4;
  constant kSwapNoneOr8bitData : integer := 0;  
  constant kSwap16bitData      : integer := 1;  
  constant kSwap32bitData      : integer := 2;  
  constant kSwap64bitData      : integer := 3;  

  
  constant kDmaMode_tSize : integer := 3;
  constant kModeNull         : integer := 0;  
  constant kModeNormal       : integer := 1;  
  constant kModeLinkChaining : integer := 2;  

  
  constant kSize_tSize : integer := 4;
  constant k8bit  : integer := 0;  
  constant k16bit : integer := 1;  
  constant k32bit : integer := 2;  
  constant k64bit : integer := 3;  

  
  constant kChannelBaseAddress : integer := 16#10#; 
  constant kChannelBaseAddressSize: integer := 64;  
  constant kChannelBaseAddressMask : std_logic_vector(63 downto 0) := X"ffffffffffffffff";
  constant kBaseAddressSize       : integer := 64;  
  constant kBaseAddressMsb        : integer := 63;  
  constant kBaseAddress           : integer :=  0;  
  function kChannelBaseAddressRec return XReg2_t; 

  
  constant kChannelBaseSize : integer := 16#18#; 
  constant kChannelBaseSizeSize: integer := 64;  
  constant kChannelBaseSizeMask : std_logic_vector(63 downto 0) := X"ffffffffffffffff";
  constant kBaseSizeSize       : integer := 64;  
  constant kBaseSizeMsb        : integer := 63;  
  constant kBaseSize           : integer :=  0;  
  function kChannelBaseSizeRec return XReg2_t; 

  
  constant kChannelNextListLinkAddress : integer := 16#20#; 
  constant kChannelNextListLinkAddressSize: integer := 64;  
  constant kChannelNextListLinkAddressMask : std_logic_vector(63 downto 0) := X"ffffffffffffffff";
  constant kDoorbellAddressSize       : integer := 64;  
  constant kDoorbellAddressMsb        : integer := 63;  
  constant kDoorbellAddress           : integer :=  0;  
  function kChannelNextListLinkAddressRec return XReg2_t; 

  
  constant kChannelNextListLinkSize : integer := 16#34#; 
  constant kChannelNextListLinkSizeSize: integer := 32;  
  constant kChannelNextListLinkSizeMask : std_logic_vector(31 downto 0) := X"ffffffff";
  constant kDoorbellValueSize       : integer := 32;  
  constant kDoorbellValueMsb        : integer := 31;  
  constant kDoorbellValue           : integer :=  0;  
  function kChannelNextListLinkSizeRec return XReg2_t; 

  
  constant kChannelMemoryAddress : integer := 16#38#; 
  constant kChannelMemoryAddressSize: integer := 64;  
  constant kChannelMemoryAddressMask : std_logic_vector(63 downto 0) := X"ffffffffffffffff";
  constant kMemoryAddressSize       : integer := 64;  
  constant kMemoryAddressMsb        : integer := 63;  
  constant kMemoryAddress           : integer :=  0;  
  function kChannelMemoryAddressRec return XReg2_t; 

  
  constant kChannelBaggage : integer := 16#40#; 
  constant kChannelBaggageSize: integer := 64;  
  function kChannelBaggageRec return XReg2_t; 

  
  constant kChannelLinkAddress : integer := 16#48#; 
  constant kChannelLinkAddressSize: integer := 64;  
  constant kChannelLinkAddressMask : std_logic_vector(63 downto 0) := X"ffffffffffffffff";
  constant kLinkAddressSize       : integer := 64;  
  constant kLinkAddressMsb        : integer := 63;  
  constant kLinkAddress           : integer :=  0;  
  function kChannelLinkAddressRec return XReg2_t; 

  
  constant kChannelLinkSize : integer := 16#50#; 
  constant kChannelLinkSizeSize: integer := 32;  
  constant kChannelLinkSizeMask : std_logic_vector(31 downto 0) := X"ffffffff";
  constant kLinkSizeSize       : integer := 32;  
  constant kLinkSizeMsb        : integer := 31;  
  constant kLinkSize           : integer :=  0;  
  function kChannelLinkSizeRec return XReg2_t; 

  
  constant kChannelControl : integer := 16#54#; 
  constant kChannelControlSize: integer := 32;  
  constant kChannelControlMask : std_logic_vector(31 downto 0) := X"0ab08307";
  constant kModeSize       : integer := 2;  
  constant kModeMsb        : integer := 1;  
  constant kMode           : integer := 0;  
  constant kDisableLinkFetchingSize       : integer := 1;  
  constant kDisableLinkFetchingMsb        : integer := 2;  
  constant kDisableLinkFetching           : integer := 2;  
  constant kByteSwapSize       : integer := 2;  
  constant kByteSwapMsb        : integer := 9;  
  constant kByteSwap           : integer := 8;  
  constant kNotifyOnDoneSize       : integer :=  1;  
  constant kNotifyOnDoneMsb        : integer := 15;  
  constant kNotifyOnDone           : integer := 15;  
  constant kDoorbellSizeSize       : integer :=  2;  
  constant kDoorbellSizeMsb        : integer := 21;  
  constant kDoorbellSize           : integer := 20;  
  constant kPushOnDoneSize       : integer :=  1;  
  constant kPushOnDoneMsb        : integer := 23;  
  constant kPushOnDone           : integer := 23;  
  constant kNotifyOnTotalCountSize       : integer :=  1;  
  constant kNotifyOnTotalCountMsb        : integer := 25;  
  constant kNotifyOnTotalCount           : integer := 25;  
  constant kNotifyOnErrorSize       : integer :=  1;  
  constant kNotifyOnErrorMsb        : integer := 27;  
  constant kNotifyOnError           : integer := 27;  
  function kChannelControlRec return XReg2_t; 

  
  constant kChannelOperation : integer := 16#58#; 
  constant kChannelOperationSize: integer := 32;  
  constant kChannelOperationMask : std_logic_vector(31 downto 0) := X"02000017";
  constant kStartSize       : integer := 1;  
  constant kStartMsb        : integer := 0;  
  constant kStart           : integer := 0;  
  constant kStopSize       : integer := 1;  
  constant kStopMsb        : integer := 1;  
  constant kStop           : integer := 1;  
  constant kClrTtcSize       : integer := 1;  
  constant kClrTtcMsb        : integer := 2;  
  constant kClrTtc           : integer := 2;  
  constant kBaseRegsReadySize       : integer := 1;  
  constant kBaseRegsReadyMsb        : integer := 4;  
  constant kBaseRegsReady           : integer := 4;  
  constant kArmTotalCountInterruptSize       : integer :=  1;  
  constant kArmTotalCountInterruptMsb        : integer := 25;  
  constant kArmTotalCountInterrupt           : integer := 25;  
  function kChannelOperationRec return XReg2_t; 

  
  constant kChannelStatus : integer := 16#60#; 
  constant kChannelStatusSize: integer := 32;  
  constant kChannelStatusMask : std_logic_vector(31 downto 0) := X"be00cfff";
  constant kStreamSize       : integer := 12;  
  constant kStreamMsb        : integer := 11;  
  constant kStream           : integer :=  0;  
  constant kLinkReadyBarInvalidSize       : integer :=  1;  
  constant kLinkReadyBarInvalidMsb        : integer := 14;  
  constant kLinkReadyBarInvalid           : integer := 14;  
  constant kDoneSize       : integer :=  1;  
  constant kDoneMsb        : integer := 15;  
  constant kDone           : integer := 15;  
  constant kTotalCountSize       : integer :=  1;  
  constant kTotalCountMsb        : integer := 25;  
  constant kTotalCount           : integer := 25;  
  constant kLastLinkSize       : integer :=  1;  
  constant kLastLinkMsb        : integer := 26;  
  constant kLastLink           : integer := 26;  
  constant kErrorSize       : integer :=  1;  
  constant kErrorMsb        : integer := 27;  
  constant kError           : integer := 27;  
  constant kInterruptSourceSize       : integer :=  2;  
  constant kInterruptSourceMsb        : integer := 29;  
  constant kInterruptSource           : integer := 28;  
  constant kInterruptPendingSize       : integer :=  1;  
  constant kInterruptPendingMsb        : integer := 31;  
  constant kInterruptPending           : integer := 31;  
  function kChannelStatusRec return XReg2_t; 

  
  constant kChannelVolatileStatus : integer := 16#68#; 
  constant kChannelVolatileStatusSize: integer := 32;  
  constant kChannelVolatileStatusMask : std_logic_vector(31 downto 0) := X"00000000";
  function kChannelVolatileStatusRec return XReg2_t; 

  
  constant kChannelMemorySize : integer := 16#70#; 
  constant kChannelMemorySizeSize: integer := 64;  
  constant kChannelMemorySizeMask : std_logic_vector(63 downto 0) := X"ffffffffffffffff";
  constant kMemorySizeSize       : integer := 64;  
  constant kMemorySizeMsb        : integer := 63;  
  constant kMemorySize           : integer :=  0;  
  function kChannelMemorySizeRec return XReg2_t; 

  
  constant kChannelTotalTransferCountCompare : integer := 16#90#; 
  constant kChannelTotalTransferCountCompareSize: integer := 64;  
  constant kChannelTotalTransferCountCompareMask : std_logic_vector(63 downto 0) := X"ffffffffffffffff";
  constant kTotalCompareCountSize       : integer := 64;  
  constant kTotalCompareCountMsb        : integer := 63;  
  constant kTotalCompareCount           : integer :=  0;  
  function kChannelTotalTransferCountCompareRec return XReg2_t; 

  
  constant kChannelTotalTransferCountStatus : integer := 16#A0#; 
  constant kChannelTotalTransferCountStatusSize: integer := 64;  
  constant kChannelTotalTransferCountStatusMask : std_logic_vector(63 downto 0) := X"ffffffffffffffff";
  constant kTotalTransferCountStatusSize       : integer := 64;  
  constant kTotalTransferCountStatusMsb        : integer := 63;  
  constant kTotalTransferCountStatus           : integer :=  0;  
  function kChannelTotalTransferCountStatusRec return XReg2_t; 

  
  constant kChannelTotalTransferCountLatching : integer := 16#A8#; 
  constant kChannelTotalTransferCountLatchingSize: integer := 64;  
  constant kChannelTotalTransferCountLatchingMask : std_logic_vector(63 downto 0) := X"ffffffffffffffff";
  constant kTotalTransferCountLatchingSize       : integer := 64;  
  constant kTotalTransferCountLatchingMsb        : integer := 63;  
  constant kTotalTransferCountLatching           : integer :=  0;  
  function kChannelTotalTransferCountLatchingRec return XReg2_t; 

  
  constant kChannelDoNotAccess : integer := 16#FC#; 
  constant kChannelDoNotAccessSize: integer := 32;  
  constant kChannelDoNotAccessMask : std_logic_vector(31 downto 0) := X"ffffffff";
  constant kIllegalSize       : integer := 32;  
  constant kIllegalMsb        : integer := 31;  
  constant kIllegal           : integer :=  0;  
  function kChannelDoNotAccessRec return XReg2_t; 

end package;

package body PkgNiDmaRegMap is

  
  function kChannelBaseAddressRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"10");
    Rec.size := 64;
    Rec.readable := true;
    Rec.writable := true;
    Rec.wmask := XRegResize(X"ffffffffffffffff");
    Rec.rmask := XRegResize(X"ffffffffffffffff");
    Rec.strobemask := XRegResize(X"0000000000000000");
    Rec.clearablemask := XRegResize(X"0000000000000000");
    
    
    Rec.msblookupw(kBaseAddress) := kBaseAddressMsb;
    Rec.msblookupr(kBaseAddress) := kBaseAddressMsb;
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("ChannelBaseAddress");
    --synopsys translate_on
    return Rec;
  end function kChannelBaseAddressRec;

  
  function kChannelBaseSizeRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"18");
    Rec.size := 64;
    Rec.readable := true;
    Rec.writable := true;
    Rec.wmask := XRegResize(X"ffffffffffffffff");
    Rec.rmask := XRegResize(X"ffffffffffffffff");
    Rec.strobemask := XRegResize(X"0000000000000000");
    Rec.clearablemask := XRegResize(X"0000000000000000");
    
    
    Rec.msblookupw(kBaseSize) := kBaseSizeMsb;
    Rec.msblookupr(kBaseSize) := kBaseSizeMsb;
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("ChannelBaseSize");
    --synopsys translate_on
    return Rec;
  end function kChannelBaseSizeRec;

  
  function kChannelNextListLinkAddressRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"20");
    Rec.size := 64;
    Rec.readable := true;
    Rec.writable := true;
    Rec.wmask := XRegResize(X"ffffffffffffffff");
    Rec.rmask := XRegResize(X"ffffffffffffffff");
    Rec.strobemask := XRegResize(X"0000000000000000");
    Rec.clearablemask := XRegResize(X"0000000000000000");
    
    
    Rec.msblookupw(kDoorbellAddress) := kDoorbellAddressMsb;
    Rec.msblookupr(kDoorbellAddress) := kDoorbellAddressMsb;
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("ChannelNextListLinkAddress");
    --synopsys translate_on
    return Rec;
  end function kChannelNextListLinkAddressRec;

  
  function kChannelNextListLinkSizeRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"34");
    Rec.size := 32;
    Rec.readable := true;
    Rec.writable := true;
    Rec.wmask := XRegResize(X"ffffffff");
    Rec.rmask := XRegResize(X"ffffffff");
    Rec.strobemask := XRegResize(X"00000000");
    Rec.clearablemask := XRegResize(X"00000000");
    
    
    Rec.msblookupw(kDoorbellValue) := kDoorbellValueMsb;
    Rec.msblookupr(kDoorbellValue) := kDoorbellValueMsb;
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("ChannelNextListLinkSize");
    --synopsys translate_on
    return Rec;
  end function kChannelNextListLinkSizeRec;

  
  function kChannelMemoryAddressRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"38");
    Rec.size := 64;
    Rec.readable := true;
    Rec.writable := true;
    Rec.wmask := XRegResize(X"ffffffffffffffff");
    Rec.rmask := XRegResize(X"ffffffffffffffff");
    Rec.strobemask := XRegResize(X"0000000000000000");
    Rec.clearablemask := XRegResize(X"0000000000000000");
    
    
    Rec.msblookupw(kMemoryAddress) := kMemoryAddressMsb;
    Rec.msblookupr(kMemoryAddress) := kMemoryAddressMsb;
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("ChannelMemoryAddress");
    --synopsys translate_on
    return Rec;
  end function kChannelMemoryAddressRec;

  
  function kChannelBaggageRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"40");
    Rec.size := 64;
    Rec.readable := true;
    Rec.writable := true;
    Rec.wmask := XRegResize(X"ffffffffffffffff");
    Rec.rmask := XRegResize(X"ffffffffffffffff");
    Rec.strobemask := XRegResize(X"0000000000000000");
    Rec.clearablemask := XRegResize(X"0000000000000000");
    
    
    Rec.msblookupw(kBaggage) := kBaggageMsb;
    Rec.msblookupr(kBaggage) := kBaggageMsb;
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("ChannelBaggage");
    --synopsys translate_on
    return Rec;
  end function kChannelBaggageRec;

  
  function kChannelLinkAddressRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"48");
    Rec.size := 64;
    Rec.readable := true;
    Rec.writable := true;
    Rec.wmask := XRegResize(X"ffffffffffffffff");
    Rec.rmask := XRegResize(X"ffffffffffffffff");
    Rec.strobemask := XRegResize(X"0000000000000000");
    Rec.clearablemask := XRegResize(X"0000000000000000");
    
    
    Rec.msblookupw(kLinkAddress) := kLinkAddressMsb;
    Rec.msblookupr(kLinkAddress) := kLinkAddressMsb;
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("ChannelLinkAddress");
    --synopsys translate_on
    return Rec;
  end function kChannelLinkAddressRec;

  
  function kChannelLinkSizeRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"50");
    Rec.size := 32;
    Rec.readable := true;
    Rec.writable := true;
    Rec.wmask := XRegResize(X"ffffffff");
    Rec.rmask := XRegResize(X"ffffffff");
    Rec.strobemask := XRegResize(X"00000000");
    Rec.clearablemask := XRegResize(X"00000000");
    
    
    Rec.msblookupw(kLinkSize) := kLinkSizeMsb;
    Rec.msblookupr(kLinkSize) := kLinkSizeMsb;
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("ChannelLinkSize");
    --synopsys translate_on
    return Rec;
  end function kChannelLinkSizeRec;

  
  function kChannelControlRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"54");
    Rec.size := 32;
    Rec.readable := true;
    Rec.writable := true;
    Rec.wmask := XRegResize(X"0ab08307");
    Rec.rmask := XRegResize(X"0ab08307");
    Rec.strobemask := XRegResize(X"00000000");
    Rec.clearablemask := XRegResize(X"00000000");
    
    
    Rec.msblookupw(kMode) := kModeMsb;
    Rec.msblookupw(kByteSwap) := kByteSwapMsb;
    Rec.msblookupw(kDoorbellSize) := kDoorbellSizeMsb;
    Rec.msblookupr(kMode) := kModeMsb;
    Rec.msblookupr(kByteSwap) := kByteSwapMsb;
    Rec.msblookupr(kDoorbellSize) := kDoorbellSizeMsb;
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("ChannelControl");
    --synopsys translate_on
    return Rec;
  end function kChannelControlRec;

  
  function kChannelOperationRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"58");
    Rec.size := 32;
    Rec.readable := true;
    Rec.writable := true;
    Rec.wmask := XRegResize(X"02000017");
    Rec.rmask := XRegResize(X"02000017");
    Rec.strobemask := XRegResize(X"02000017");
    Rec.clearablemask := XRegResize(X"00000000");
    
    
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("ChannelOperation");
    --synopsys translate_on
    return Rec;
  end function kChannelOperationRec;

  
  function kChannelStatusRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"60");
    Rec.size := 32;
    Rec.readable := true;
    Rec.writable := false;
    Rec.wmask := XRegResize(X"be00cfff");
    Rec.rmask := XRegResize(X"be00cfff");
    Rec.strobemask := XRegResize(X"00000000");
    Rec.clearablemask := XRegResize(X"00000000");
    
    
    Rec.msblookupw(kStream) := kStreamMsb;
    Rec.msblookupw(kInterruptSource) := kInterruptSourceMsb;
    Rec.msblookupr(kStream) := kStreamMsb;
    Rec.msblookupr(kInterruptSource) := kInterruptSourceMsb;
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("ChannelStatus");
    --synopsys translate_on
    return Rec;
  end function kChannelStatusRec;

  
  function kChannelVolatileStatusRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"68");
    Rec.size := 32;
    Rec.readable := true;
    Rec.writable := false;
    Rec.wmask := XRegResize(X"00000000");
    Rec.rmask := XRegResize(X"ffffffff");
    Rec.strobemask := XRegResize(X"00000000");
    Rec.clearablemask := XRegResize(X"00000000");
    
    
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("ChannelVolatileStatus");
    --synopsys translate_on
    return Rec;
  end function kChannelVolatileStatusRec;

  
  function kChannelMemorySizeRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"70");
    Rec.size := 64;
    Rec.readable := true;
    Rec.writable := false;
    Rec.wmask := XRegResize(X"ffffffffffffffff");
    Rec.rmask := XRegResize(X"ffffffffffffffff");
    Rec.strobemask := XRegResize(X"0000000000000000");
    Rec.clearablemask := XRegResize(X"0000000000000000");
    
    
    Rec.msblookupw(kMemorySize) := kMemorySizeMsb;
    Rec.msblookupr(kMemorySize) := kMemorySizeMsb;
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("ChannelMemorySize");
    --synopsys translate_on
    return Rec;
  end function kChannelMemorySizeRec;

  
  function kChannelTotalTransferCountCompareRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"90");
    Rec.size := 64;
    Rec.readable := true;
    Rec.writable := true;
    Rec.wmask := XRegResize(X"ffffffffffffffff");
    Rec.rmask := XRegResize(X"ffffffffffffffff");
    Rec.strobemask := XRegResize(X"0000000000000000");
    Rec.clearablemask := XRegResize(X"0000000000000000");
    
    
    Rec.msblookupw(kTotalCompareCount) := kTotalCompareCountMsb;
    Rec.msblookupr(kTotalCompareCount) := kTotalCompareCountMsb;
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("ChannelTotalTransferCountCompare");
    --synopsys translate_on
    return Rec;
  end function kChannelTotalTransferCountCompareRec;

  
  function kChannelTotalTransferCountStatusRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"A0");
    Rec.size := 64;
    Rec.readable := true;
    Rec.writable := false;
    Rec.wmask := XRegResize(X"ffffffffffffffff");
    Rec.rmask := XRegResize(X"ffffffffffffffff");
    Rec.strobemask := XRegResize(X"0000000000000000");
    Rec.clearablemask := XRegResize(X"0000000000000000");
    
    
    Rec.msblookupw(kTotalTransferCountStatus) := kTotalTransferCountStatusMsb;
    Rec.msblookupr(kTotalTransferCountStatus) := kTotalTransferCountStatusMsb;
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("ChannelTotalTransferCountStatus");
    --synopsys translate_on
    return Rec;
  end function kChannelTotalTransferCountStatusRec;

  
  function kChannelTotalTransferCountLatchingRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"A8");
    Rec.size := 64;
    Rec.readable := true;
    Rec.writable := false;
    Rec.wmask := XRegResize(X"ffffffffffffffff");
    Rec.rmask := XRegResize(X"ffffffffffffffff");
    Rec.strobemask := XRegResize(X"0000000000000000");
    Rec.clearablemask := XRegResize(X"0000000000000000");
    
    
    Rec.msblookupw(kTotalTransferCountLatching) := kTotalTransferCountLatchingMsb;
    Rec.msblookupr(kTotalTransferCountLatching) := kTotalTransferCountLatchingMsb;
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("ChannelTotalTransferCountLatching");
    --synopsys translate_on
    return Rec;
  end function kChannelTotalTransferCountLatchingRec;

  
  function kChannelDoNotAccessRec return XReg2_t is
    variable Rec : XReg2_t;
  begin
    Rec := kXRegDefault;
    Rec.version := 1;
    Rec.offset := XAddrResize(X"FC");
    Rec.size := 32;
    Rec.readable := true;
    Rec.writable := true;
    Rec.wmask := XRegResize(X"ffffffff");
    Rec.rmask := XRegResize(X"ffffffff");
    Rec.strobemask := XRegResize(X"00000000");
    Rec.clearablemask := XRegResize(X"00000000");
    
    
    Rec.msblookupw(kIllegal) := kIllegalMsb;
    Rec.msblookupr(kIllegal) := kIllegalMsb;
    Rec.isreg := true;
    --synopsys translate_off
    Rec.name := rs("ChannelDoNotAccess");
    --synopsys translate_on
    return Rec;
  end function kChannelDoNotAccessRec;

end package body;