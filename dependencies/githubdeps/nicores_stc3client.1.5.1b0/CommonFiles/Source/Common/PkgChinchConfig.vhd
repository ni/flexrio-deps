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
  use work.PkgChinch.all;

package PkgChinchConfig is

  
  
  
  
  
  

  constant kTargetType : Target_t := Oki;
  constant kUseInferredMemory : boolean := false;



  
  

  constant kChinchConfig : ChinchCoreConfig_t := (
    TwoClocks => false,           
                                  
                                  
                                  
                                  
                                  

    DMA_TYPE => 16#50#,           
                                  

    DMA_ChannelsLog2 => 4,        
                                  
                                  

    LINKSZ_Log2 =>  9,            
                                  

    IncludeInputDma => true,      
                                  

    IncludeOutputDma => true,     
                                  

    IncludeTtccr => true,         
                                  
                                  

    IncludeTimer => true,         
                                  
                                  

    IncludeIntStatPush => true,   
                                  

    IncludeMCU => true,           
                                  

    RandomAccess => false,        
                                  
                                  

    IO_MPS => 512,                
                                  
                                  
                                  

    HB_MPS => 512,                
                                  
                                  
                                  

    IO_MSIT => 4,                 
                                  

    HB_MSIT => 16,                
                                  

    IORXBE_MP => 8,               
                                      
    IORXBE_MW =>  256,            
                                      

    IOTXBE_MP => 8,               
                                      
    IOTXBE_MW => 256,             
                                      

    HBRXBE_MP => 8,               
                                      
    HBRXBE_MW => 256,             
                                      

    HBTXBE_MP => 8,               
                                      
    HBTXBE_MW => 256,             
                                      

    IO_RegProgEndian => false,    
                                  
                                  

    IO_RegBigEndian => false,     
                                  
                                  
                                  
                                  

    HB_RegProgEndian => false,    
                                  
                                  

    HB_RegBigEndian => false,     
                                  
                                  
                                  
                                  

    IO_BaggageWidth => 1,         

    HB_BaggageWidth => 23,        

    IO_Windows => 2,              

    CP_Windows => 4,              
                                  
                                  
                                  

    ProgRomAddressWidth => 12,        
                                      

    OnChipRamAddressWidth => 7,       
                                      
                                      
                                      

    OffChipRamAddressWidth => 12,     
                                      

    NumGpios => 13                
                                  
                                
  );



  
  

  constant kDMA_SPACE_Log2 : natural :=
    ChinchGetDMA_SPACE_Log2(kChinchConfig.DMA_TYPE);



  
  
  
  

  constant kDMA_BASE : unsigned(31 downto 0) :=
    ChinchGetDMA_BASE(kDMA_SPACE_Log2, kChinchConfig.DMA_ChannelsLog2);



  
  
  

  constant kResetWaitStates : natural := 13;

  
  

  constant kSplitTimeStates : natural := 1250000;

end PkgChinchConfig;

package body PkgChinchConfig is
end PkgChinchConfig;