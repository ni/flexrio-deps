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
  use work.PkgNiDmaConfig.all;

library xpm;
  use xpm.VCOMPONENTS.all;

entity SingleClockDeviceRam is
  generic (
    kDevRamSizeInBytes        : natural := 16#1000#;  
    
    kDevRamSinkOffset         : natural := kNiDmaHighSpeedSinkBase + 16#1000#;
    kDevRamViAccessSizeInBits : natural := 256
  );
  port (

    adReset               : in boolean;
    dCoreReset            : in boolean;
    DmaClock              : in std_logic;
    dHighSpeedSinkFromDma : in NiDmaHighSpeedSinkFromDma_t;

    
    dLclAddr : in std_logic_vector(Log2(kDevRamSizeInBytes*8/kDevRamViAccessSizeInBits) downto 0);
    dLclDout : out std_logic_vector(kDevRamViAccessSizeInBits-1 downto 0);

    
    
    
    dLclRd        : in  boolean;
    dLclDataValid : out boolean
  );
end entity; 

architecture RTL of SingleClockDeviceRam is

  
  constant kMemRdDataSize : natural := Smaller(kDevRamViAccessSizeInBits, 4*kNiDmaDataWidth);
  constant kPortRatio     : natural := kMemRdDataSize / kNiDmaDataWidth;
  constant kNumOfMemories : natural := kDevRamViAccessSizeInBits / kMemRdDataSize;

  constant kHssinkAddrLsb : natural := Log2(kNiDmaDataWidth/8);
  constant kTargetAddrLsb : natural := kHssinkAddrLsb + Log2(kPortRatio);
  constant kMemAddrLsb    : natural := kTargetAddrLsb + Log2(kNumOfMemories);

  signal dHssinkAddress: std_logic_vector(Log2(kDevRamSizeInBytes)-1 downto 0);
  signal dTargetMemory : unsigned(Log2(kNumOfMemories)-1 downto 0);
  signal dMemOut: std_logic_vector(kDevRamViAccessSizeInBits-1 downto 0);

  
  signal dHostAddr: std_logic_vector(Log2(kDevRamSizeInBytes*8/(kNiDmaDataWidth*kNumOfMemories))-1 downto 0);
  signal dHostDin: std_logic_vector(kNiDmaDataWidth-1 downto 0);
  signal dHostEn: std_logic;
  signal dLclAddrL: std_logic_vector(Log2(kDevRamSizeInBytes*8/kDevRamViAccessSizeInBits)-1 downto 0);
  signal dLclEn: std_logic;
  

  signal dMemoryDecoded : boolean;

  constant kLatency : natural := 2;
  signal dDataValidSR : BooleanVector(1 to kLatency);

  signal dTransferCount : unsigned(31 downto 0);
  signal dReadRegister : boolean;
  signal dRegDataValid : boolean;
  signal dRegOut : std_logic_vector(kDevRamViAccessSizeInBits-1 downto 0);
  signal dHostWe: std_logic_vector(kNiDmaDataWidth/8-1 downto 0);

begin

  dMemoryDecoded <= dHighSpeedSinkFromDma.Address >= kDevRamSinkOffset and
                    dHighSpeedSinkFromDma.Address <= kDevRamSinkOffset + kDevRamSizeInBytes - 1;
  dHostEn <= '1';

  
  dHostDin      <= dHighSpeedSinkFromDma.Data;
  dHostWe       <= to_StdLogicVector(dHighSpeedSinkFromDma.ByteEnable) when dHighSpeedSinkFromDma.Push and dMemoryDecoded else (others => '0');

  dHssinkAddress <= std_logic_vector(resize(dHighSpeedSinkFromDma.Address, dHssinkAddress'length));
  dHostAddr      <= dHssinkAddress(dHssinkAddress'high downto kMemAddrLsb) &
                    dHssinkAddress(kTargetAddrLsb-1 downto kHssinkAddrLsb);
  dTargetMemory  <= unsigned(dHssinkAddress(kMemAddrLsb-1 downto kTargetAddrLsb));

  
  dLclEn  <= '1';

  DataValid : process(adReset, DmaClock)
  begin 
    if adReset then
      dDataValidSR <= (others => false);
    elsif rising_edge(DmaClock) then
      dDataValidSR(1)             <= dLclRd;
      dDataValidSR(2 to kLatency) <= dDataValidSR(1 to kLatency-1);
    end if;
  end process DataValid;

  dLclDataValid <= dDataValidSR(kLatency);

  TransferCount : process(adReset, DmaClock)
  begin 
    if adReset then
      dTransferCount <= (others => '0');
      dReadRegister  <= false;
      dRegDataValid  <= false;
    elsif rising_edge(DmaClock) then
      if dCoreReset then
        dTransferCount <= (others => '0');
      elsif dHighSpeedSinkFromDma.Push and dMemoryDecoded then
        dTransferCount <= dTransferCount + CountOnes(dHostWe);
      end if;

      dReadRegister <= false;
      if dLclRd then
        dReadRegister <= to_Boolean(dLclAddr(dLclAddr'high));
        
      end if;

      
      
      dRegDataValid <= dReadRegister;
    end if;
  end process TransferCount;

  
  dRegOut <= std_logic_vector(resize(dTransferCount,kDevRamViAccessSizeInBits));

  
  
  
  
  
  dLclAddrL <= dLclAddr(dLclAddrL'range);

  Memories: for i in 0 to kNumOfMemories-1 generate
    signal dHostWeL: std_logic_vector(kNiDmaDataWidth/8-1 downto 0);
    signal dLclDoutL: std_logic_vector(kMemRdDataSize-1 downto 0);
  begin
    dHostWeL  <= dHostWe when kNumOfMemories = 1 or dTargetMemory = i else (others => '0');

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    xpm_memory_sdpramx: xpm_memory_sdpram
      generic map (
        MEMORY_SIZE        => kDevRamSizeInBytes*8/kNumOfMemories,                          
        MEMORY_PRIMITIVE   => "auto",                                                       
        CLOCKING_MODE      => "independent_clock",                                          
        USE_MEM_INIT       => 0,                                                            
        MESSAGE_CONTROL    => 0,                                                            
        WRITE_DATA_WIDTH_A => kNiDmaDataWidth,                                              
        BYTE_WRITE_WIDTH_A => 8,                                                            
        ADDR_WIDTH_A       => Log2(kDevRamSizeInBytes*8/(kNiDmaDataWidth*kNumOfMemories)),  
        READ_DATA_WIDTH_B  => kMemRdDataSize,                                               
        ADDR_WIDTH_B       => Log2(kDevRamSizeInBytes*8/kDevRamViAccessSizeInBits),         
        READ_LATENCY_B     => kLatency,                                                     
        WRITE_MODE_B       => "read_first")                                                 
      port map (
        sleep          => '0',        
        clka           => DmaClock,   
        ena            => dHostEn,    
        wea            => dHostWeL,   
        addra          => dHostAddr,  
        dina           => dHostDin,   
        injectsbiterra => '0',        
        injectdbiterra => '0',        
        clkb           => DmaClock,   
        rstb           => '0',        
        enb            => dLclEn,     
        regceb         => '1',        
        addrb          => dLclAddrL,  
        doutb          => dLclDoutL,  
        sbiterrb       => open,       
        dbiterrb       => open);      

    dMemOut((i+1)*kMemRdDataSize-1 downto i*kMemRdDataSize) <= dLclDoutL;
  end generate;

  dLclDout <= dRegOut when dRegDataValid else dMemOut;

end RTL;