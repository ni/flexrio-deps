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

package PkgNiDmaConfig is

  

  
  
  
  
  
  
  
  constant kNiDmaAddressWidth : natural := 64;

  
  constant kNiDmaDataWidth : natural := 256;

  
  
  
  
  
  
  
  constant kNiDmaBaggageWidth : natural := 6;

  
  
  
  constant kNiDmaInputMaxTransfer  : natural := 1024;
  constant kNiDmaOutputMaxTransfer : natural := 1024;

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  constant kNiDmaInputMaxRequests : natural := 16;
  constant kNiDmaOutputMaxRequests : natural := 64;

  
  
  
  
  
  
  
  
  
  
  
  constant kNiDmaInputDataBuffer : natural := 2;

  
  constant kNiDmaDmaChannels : natural := 64;

  
  
  constant kNiDmaDirectMasters : natural := 128;

  
  
  
  constant kNiDmaInputDataReadLatency : natural := 5;

  

  
  constant kNiDmaIpBaseAddress         : natural := 16#00#;
  constant kNiDmaIpCompanionWindowSize : natural := 16#4000#;
  
  

  
  
  
  
  
  
  
  
  
  
  
  
  constant kNiDmaDmaRegBase : natural := 16#4000#;
  constant kNiDmaDmaRegSize : positive := 16#4000#;  

  
  
  
  
  
  constant kNiDmaHbBimRegBase : natural := 16#1000#;
  constant kNiDmaHbBimRegSize : natural := 16#200#;

  

  
  
  
  
  
  
  
  
  
  constant kNiDmaHighSpeedSinkAddressWidth : positive := 20;

  
  
  
  
  constant kNiDmaHighSpeedSinkBase : natural := 16#80000#;
  constant kNiDmaHighSpeedSinkSize : positive := 16#40000#;  

  

  constant kNiDmaEnableInput : boolean := true;
  constant kNiDmaEnableOutput : boolean := true;

  constant kNiDmaEnableByteSwapper : boolean := false;

  constant kNiDmaTtcWidth : natural := 64;
  constant kNiDmaEnableLatchingTtc : boolean := true;

  constant kNiDmaEnableFullScatterGather : boolean := true;

  
  constant kNiDmaMaxChunkyLinkSize : natural := 2048;
  constant kNiDmaLinkFetchMaxRequests : natural := 1;

  constant kNiDmaEnableDmaInterrupts : boolean := true;
  constant kNiDmaEnableMessageAndStatusPusher : boolean := true;
  
  
  
  
  
  constant kNiDmaStatusPusherChannel : natural := kNiDmaDmaChannels - 1;

  

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  constant kNiDmaMaxMuxWidth : natural := 8;

  
  
  
  
  
  constant kNiDmaMaxLutRamAddressWidth : natural := 8;
  constant kNiDmaMaxLutRamDataWidth : natural := 512;

end PkgNiDmaConfig;

package body PkgNiDmaConfig is

end package body PkgNiDmaConfig;