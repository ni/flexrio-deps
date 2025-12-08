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
use work.PkgNiDma.all;
use work.PkgNiDmaConfig.all;
use work.PkgNiUtilities.all;
--synopsys translate_off
use work.PkgNiSim.all;
--synopsys translate_on
use work.PkgLinkStorageRamConfig.all;

package PkgLinkStorageRam is

  
  
  
  
  
  

  
  constant kLinkStorageSizeInBytes : natural := kNiDmaDmaChannels * 2 * kChunkyLinkSize;

  
  
  
  constant kLinkStorageRamDataWidth : natural := kNiDmaDataWidth;
  constant kLinkStorageRamAddrWidth : natural := Log2(kLinkStorageSizeInBytes*8/kLinkStorageRamDataWidth);

  
  
  constant kLinkOffsetByteCount : integer := 8;
  constant kLinkOffsetMaxValue  : integer := kChunkyLinkSize / kLinkOffsetByteCount;

  
  constant kLinkStorageRamRdDataWidth : integer := kLinkOffsetByteCount*8;
  constant kLinkStorageRamRdAddrWidth : natural := Log2(kLinkStorageSizeInBytes/kLinkOffsetByteCount);

  constant kLinkStorageRamWidthRatio : natural := kLinkStorageRamDataWidth/kLinkStorageRamRdDataWidth;

  
  
  
  
  
  
  function NumEnabledChannels (
      constant kEnabledChannels : NiDmaDmaChannelOneHot_t
    ) return natural;

  
  
  
  
  constant kLinkStorageRamReadLatency : natural := 2;

end package PkgLinkStorageRam;

package body PkgLinkStorageRam is

  function NumEnabledChannels (
      constant kEnabledChannels : NiDmaDmaChannelOneHot_t)
    return natural is
    variable ChannelCount : natural := 0;
  begin 

    
    for i in kEnabledChannels'range loop
      if kEnabledChannels(i) then
        ChannelCount := ChannelCount + 1;
      end if;
    end loop;

    return ChannelCount;

  end function NumEnabledChannels;

end package body PkgLinkStorageRam;