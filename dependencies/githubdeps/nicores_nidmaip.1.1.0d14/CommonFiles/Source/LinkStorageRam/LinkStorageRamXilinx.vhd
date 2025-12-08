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
use work.PkgLinkStorageRamConfig.all;

library xpm;
use xpm.vcomponents.all;

entity LinkStorageRamXilinx is
  generic (
    kEnabledChannels : in NiDmaDmaChannelOneHot_t);
  port (
    DmaClock : in std_logic;
    
    dLinkStorageRamWrite     : in boolean;
    dLinkStorageRamWriteAddr : in unsigned(kLinkStorageRamAddrWidth-1 downto 0);
    dLinkStorageRamWriteData : in std_logic_vector(kLinkStorageRamDataWidth-1 downto 0);
    
    dLinkStorageRamReadAddr : in  unsigned(kLinkStorageRamRdAddrWidth-1 downto 0);
    dLinkStorageRamReadData : out std_logic_vector(kLinkStorageRamRdDataWidth-1 downto 0)
  );

end entity LinkStorageRamXilinx;

architecture struct of LinkStorageRamXilinx is

  
  
  

  
  
  
  constant kMemorySizeInBits : natural :=
    kChunkyLinkSize * 8 * NumEnabledChannels(kEnabledChannels) * 2;

  
  
  
  
  constant kMemoryWtAddrWidth : natural := Log2(Larger(kMemorySizeInBits / kLinkStorageRamDataWidth,1));
  constant kMemoryRdAddrWidth : natural := Log2(Larger(kMemorySizeInBits / kLinkStorageRamRdDataWidth,1));

  
  
  
  
  
  
  constant kLinkStorageRamByteWriteWidth : natural := kLinkStorageRamDataWidth;

  
  
  
  
  constant kLinkStorageRamWriteEn : std_logic_vector(kLinkStorageRamDataWidth/kLinkStorageRamByteWriteWidth-1 downto 0) := (others => '1');

  
  signal dNewRamRdAddr: unsigned(kMemoryRdAddrWidth-1 downto 0);
  signal dNewRamWtAddr: unsigned(kMemoryWtAddrWidth-1 downto 0);
  

begin

  InstMemory : if NumEnabledChannels(kEnabledChannels) > 0 generate

    
    
    
    
    LinkStorageRamAddrMapperx: entity work.LinkStorageRamAddrMapper (rtl)
      generic map (
        kEnabledChannels   => kEnabledChannels,    
        kMemoryWtAddrWidth => kMemoryWtAddrWidth,  
        kMemoryRdAddrWidth => kMemoryRdAddrWidth)  
      port map (
        dLinkStorageRamWriteAddr => dLinkStorageRamWriteAddr,  
        dLinkStorageRamReadAddr  => dLinkStorageRamReadAddr,   
        dNewRamWtAddr            => dNewRamWtAddr,             
        dNewRamRdAddr            => dNewRamRdAddr);            

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    LinkStorageBramx: xpm_memory_sdpram
      generic map (
        MEMORY_SIZE        => kMemorySizeInBits,              
        MEMORY_PRIMITIVE   => "auto",                         
        USE_MEM_INIT       => 0,                              
        MESSAGE_CONTROL    => 0,                              
        WRITE_DATA_WIDTH_A => kLinkStorageRamDataWidth,       
        BYTE_WRITE_WIDTH_A => kLinkStorageRamByteWriteWidth,  
        ADDR_WIDTH_A       => kMemoryWtAddrWidth,             
        READ_DATA_WIDTH_B  => kLinkStorageRamRdDataWidth,     
        ADDR_WIDTH_B       => kMemoryRdAddrWidth,             
        READ_LATENCY_B     => kLinkStorageRamReadLatency,     
        WRITE_MODE_B       => "read_first")                   
      port map (
        sleep          => '0',                                
        clka           => DmaClock,                           
        ena            => to_StdLogic(dLinkStorageRamWrite),  
        wea            => kLinkStorageRamWriteEn,             
        addra          => std_logic_vector(dNewRamWtAddr),    
        dina           => dLinkStorageRamWriteData,           
        injectsbiterra => '0',                                
        injectdbiterra => '0',                                
        clkb           => DmaClock,                           
        rstb           => '0',                                
        enb            => '1',                                
        regceb         => '1',                                
        addrb          => std_logic_vector(dNewRamRdAddr),    
        doutb          => dLinkStorageRamReadData,            
        sbiterrb       => open,                               
        dbiterrb       => open);                              

  end generate InstMemory;

  NoMemory : if NumEnabledChannels(kEnabledChannels) = 0 generate

    
    
    dLinkStorageRamReadData <= (others => '0');

  end generate NoMemory;

end architecture struct;