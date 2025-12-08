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
use work.PkgNiDma.all;
use work.PkgLinkStorageRam.all;

entity LinkStorageRamAddrMapper is

  generic (
    kEnabledChannels   : NiDmaDmaChannelOneHot_t;
    kMemoryWtAddrWidth : natural;
    kMemoryRdAddrWidth : natural
  );

  port (
    
    dLinkStorageRamWriteAddr : in unsigned(kLinkStorageRamAddrWidth-1 downto 0);
    dLinkStorageRamReadAddr  : in unsigned(kLinkStorageRamRdAddrWidth-1 downto 0);
    
    dNewRamWtAddr : out unsigned(kMemoryWtAddrWidth-1 downto 0);
    dNewRamRdAddr : out unsigned(kMemoryRdAddrWidth-1 downto 0)
  );

end entity LinkStorageRamAddrMapper;

architecture rtl of LinkStorageRamAddrMapper is

  
  
  

  
  
  
  
  
  subtype EnabledDmaChannel_t is
  unsigned (Log2(Larger(NumEnabledChannels(kEnabledChannels),1)) -1 downto 0);

  
  
  
  signal dIncomingWtDmaChannel, dIncomingRdDmaChannel : NiDmaDmaChannel_t;
  signal dNewWtDmaChannel, dNewRdDmaChannel           : EnabledDmaChannel_t;

  function MapDmaChannel (
      constant Channel : in NiDmaDmaChannel_t)
    return EnabledDmaChannel_t is
    variable EnabledCount : natural;
  begin 

    EnabledCount := 0;

    if not kEnabledChannels(to_integer(Channel)) then
      
      
      
      
      
      
      
      
      
      
      --synopsys translate_off
      
      
      
      --synopsys translate_on
      return (others => '0');

    end if;

    
    
    
    for i in kEnabledChannels'range loop

      
      
      if i = Channel then
        return to_unsigned(EnabledCount, EnabledDmaChannel_t'length);
      end if;

      if kEnabledChannels(i) then
        EnabledCount := EnabledCount + 1;
      end if;

    end loop; 

    
    
    return (others => '0');

  end function MapDmaChannel;

begin

  
  
  

  
  
  dIncomingWtDmaChannel <= dLinkStorageRamWriteAddr(dLinkStorageRamWriteAddr'high downto dLinkStorageRamWriteAddr'length - dIncomingWtDmaChannel'length);
  dIncomingRdDmaChannel <= dLinkStorageRamReadAddr(dLinkStorageRamReadAddr'high downto dLinkStorageRamReadAddr'length - dIncomingRdDmaChannel'length);

  
  
  dNewWtDmaChannel <= MapDmaChannel(dIncomingWtDmaChannel);
  dNewRdDmaChannel <= MapDmaChannel(dIncomingRdDmaChannel);

  
  dNewRamWtAddr <= dNewWtDmaChannel & dLinkStorageRamWriteAddr(dLinkStorageRamWriteAddr'high - dIncomingWtDmaChannel'length downto 0);
  dNewRamRdAddr <= dNewRdDmaChannel & dLinkStorageRamReadAddr(dLinkStorageRamReadAddr'high - dIncomingRdDmaChannel'length downto 0);

end architecture rtl;