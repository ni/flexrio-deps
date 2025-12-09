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

library work;
use work.PkgNiUtilities.all;
use work.PkgBaRegPort.all;  
use work.PkgCommunicationInterface.all;  
use work.PkgNiDma.all;                   
use work.PkgDmaPortRecordFlattening.all; 
use work.PkgSwitchedChinch.all;





entity IwCompanion is
  port (
    
    aBusReset               : in  boolean;
    
    DmaClock                : in  std_logic;
    
    dBaRegPortIn            : in  BaRegPortIn_t;
    dBaRegPortOut           : out BaRegPortOut_t;
    dLvUserMappable         : out std_logic;
    
    
    
    
    
    
    BusClk                  : in  std_logic;
    
    
    bLvWindowRegPortIn      : out RegPortIn_t;
    bLvWindowRegPortOut     : in  RegPortOut_t;
    bLvWindowRegPortTimeOut : out boolean;
    
    
    
    
    
    
    dDmaCommIfcRegPortIn    : out RegPortIn_t;
    dDmaCommIfcRegPortOut   : in  RegPortOut_t;
    
    
    
    
    
    
    
    
    dFixedLogicBaRegPortIn  : out BaRegPortIn_t;
    dFixedLogicBaRegPortOut : in  BaRegPortOut_t;
    
    
    
    aGa                     : in  std_logic_vector(4 downto 0)
    );

end entity;  

architecture wrapper of IwCompanion is

  component IwCompanionN
    port (
      aBusReset                   : in  boolean;
      DmaClock                    : in  std_logic;
      dFlatBaRegPortIn            : in  FlatBaRegPortIn_t;
      dFlatBaRegPortOut           : out FlatBaRegPortOut_t;
      dLvUserMappable             : out std_logic;
      BusClk                      : in  std_logic;
      bFlatLvWindowRegPortIn      : out std_logic_vector(kRegPortInSize-1 downto 0);
      bFlatLvWindowRegPortOut     : in  std_logic_vector(kRegPortOutSize-1 downto 0);
      bLvWindowRegPortTimeOut     : out boolean;
      dFlatDmaCommIfcRegPortIn    : out std_logic_vector(kRegPortInSize-1 downto 0);
      dFlatDmaCommIfcRegPortOut   : in  std_logic_vector(kRegPortOutSize-1 downto 0);
      dFlatFixedLogicBaRegPortIn  : out FlatBaRegPortIn_t;
      dFlatFixedLogicBaRegPortOut : in  FlatBaRegPortOut_t;
      aGa                         : in  std_logic_vector(4 downto 0));
  end component;

  
  signal bFlatLvWindowRegPortIn: std_logic_vector(kRegPortInSize-1 downto 0);
  signal bFlatLvWindowRegPortOut: std_logic_vector(kRegPortOutSize-1 downto 0);
  signal dFlatBaRegPortIn: FlatBaRegPortIn_t;
  signal dFlatBaRegPortOut: FlatBaRegPortOut_t;
  signal dFlatDmaCommIfcRegPortIn: std_logic_vector(kRegPortInSize-1 downto 0);
  signal dFlatDmaCommIfcRegPortOut: std_logic_vector(kRegPortOutSize-1 downto 0);
  signal dFlatFixedLogicBaRegPortIn: FlatBaRegPortIn_t;
  signal dFlatFixedLogicBaRegPortOut: FlatBaRegPortOut_t;
  

begin  

  
  IwCompanionNx: IwCompanionN
    port map (
      aBusReset                   => aBusReset,                    
      DmaClock                    => DmaClock,                     
      dFlatBaRegPortIn            => dFlatBaRegPortIn,             
      dFlatBaRegPortOut           => dFlatBaRegPortOut,            
      dLvUserMappable             => dLvUserMappable,              
      BusClk                      => BusClk,                       
      bFlatLvWindowRegPortIn      => bFlatLvWindowRegPortIn,       
      bFlatLvWindowRegPortOut     => bFlatLvWindowRegPortOut,      
      bLvWindowRegPortTimeOut     => bLvWindowRegPortTimeOut,      
      dFlatDmaCommIfcRegPortIn    => dFlatDmaCommIfcRegPortIn,     
      dFlatDmaCommIfcRegPortOut   => dFlatDmaCommIfcRegPortOut,    
      dFlatFixedLogicBaRegPortIn  => dFlatFixedLogicBaRegPortIn,   
      dFlatFixedLogicBaRegPortOut => dFlatFixedLogicBaRegPortOut,  
      aGa                         => aGa);                         

  
  
  
  
  dFlatBaRegPortIn            <= Flatten(dBaRegPortIn);
  dBaRegPortOut               <= Unflatten(dFlatBaRegPortOut);
  
  bLvWindowRegPortIn          <= BuildRegPortIn(bFlatLvWindowRegPortIn);
  bFlatLvWindowRegPortOut     <= to_StdLogicVector(bLvWindowRegPortOut);
  
  dDmaCommIfcRegPortIn        <= BuildRegPortIn(dFlatDmaCommIfcRegPortIn);
  dFlatDmaCommIfcRegPortOut   <= to_StdLogicVector(dDmaCommIfcRegPortOut);
  
  dFixedLogicBaRegPortIn      <= Unflatten(dFlatFixedLogicBaRegPortIn);
  dFlatFixedLogicBaRegPortOut <= Flatten(dFixedLogicBaRegPortOut);

end architecture wrapper;