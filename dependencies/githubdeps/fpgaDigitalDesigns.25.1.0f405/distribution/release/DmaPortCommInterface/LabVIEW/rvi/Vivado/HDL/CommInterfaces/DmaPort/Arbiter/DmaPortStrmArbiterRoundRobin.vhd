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

entity DmaPortStrmArbiterRoundRobin is

  generic (
    kNumOfStrms : positive := 16);

  port (
    aReset        : in  boolean;
    SysClk        : in  std_logic;
    sReset        : in  boolean;
    
    sAccReq       : in  std_logic_vector(kNumOfStrms-1 downto 0);
    sAccGnt       : out std_logic_vector(kNumOfStrms-1 downto 0);
    
    sEnArb        : in  boolean;
    sAccDoneStrb  : in  boolean;
    sStrmDone     : out boolean
    );

end entity DmaPortStrmArbiterRoundRobin;

architecture rtl of DmaPortStrmArbiterRoundRobin is

  subtype ArbVector_t is std_logic_vector(kNumOfStrms-1 downto 0);

  
  signal sMask, sMaskedVector : ArbVector_t := (others => '1');

  
  signal sNxTherm, sTherm : ArbVector_t := (others => '0');
  signal sPrePriority     : ArbVector_t := (others => '0');

  
  signal sHoldingGrant : boolean := false;

  
  signal sSelectMask : boolean := false;

  
  
  function Thermometer (
    vec : ArbVector_t)
    return ArbVector_t
  is
    variable retVal : ArbVector_t := (others => '0');
  begin  
    for i in retVal'range loop
      retVal(i) := OrVector(vec(i downto 0));
    end loop;  

    return retVal;
  end function Thermometer;

  function GrantFromTherm (
    thermometer : ArbVector_t)
    return ArbVector_t
  is
    variable shiftTherm : ArbVector_t;
  begin  

    
    
    
    
    
    
    
    
    
    
    
    
    
    shiftTherm := thermometer(thermometer'high-1 downto 0) & '0';
    return ArbVector_t'(thermometer xor shiftTherm);

  end function GrantFromTherm;

begin  

  
  
  
  
  
  
  
  sMask         <= sTherm(sTherm'high-1 downto 0) & '0';
  sMaskedVector <= sMask and sAccReq;

  
  
  
  sSelectMask <= to_Boolean(OrVector(sMaskedVector));

  Pipeline : process (SysClk, aReset)
  begin  
    if aReset then
      sPrePriority <= (others => '0');
    elsif rising_edge(SysClk) then
      if sReset then
        sPrePriority <= (others => '0');
      else
        
        
        
        
        
        
        
        
        
        if sSelectMask then
          sPrePriority <= sMaskedVector;
        else
          sPrePriority <= sAccReq;
        end if;
      end if;
    end if;
  end process Pipeline;

  
  
  sNxTherm <= Thermometer(sPrePriority);

  FFs : process (SysClk, aReset)
  begin  
    if aReset then
      sTherm        <= (others => '0');
      sHoldingGrant <= false;
    elsif rising_edge(SysClk) then

      if sReset then
        sTherm        <= (others => '0');
        sHoldingGrant <= false;
      else
        
        
        if sEnArb and not sHoldingGrant then
          sTherm        <= sNxTherm;
          sHoldingGrant <= true;
        end if;

        
        
        
        
        if sAccDoneStrb or not sEnArb then
          sHoldingGrant <= false;
        end if;

      end if;

    end if;
  end process FFs;

  
  
  
  
  
  
  
  
  
  
  
  
  sAccGnt <= GrantFromTherm(sTherm) when sHoldingGrant else (others => '0');

  

  
  
  
  

  CheckForRescindedRequests : block is
    signal sReqBeforeEnable : ArbVector_t := (others => '0');
  begin  
    Delays : process (SysClk, aReset)
    begin  
      if aReset then
        sReqBeforeEnable <= (others => '0');
      elsif rising_edge(SysClk) then

        
        
        if not sEnArb then
          sReqBeforeEnable <= sAccReq;
        end if;

        
        
        if sEnArb and not sHoldingGrant then
          for i in sReqBeforeEnable'range loop
            
            
            if sReqBeforeEnable(i) = '1' then
              assert sAccReq(i) = '1'
                report "Stream # " & integer'image(i) &
                " illegally rescinded its request during the Arbiter's enable period."
                severity warning;
            end if;
          end loop;  
        end if;
      end if;
    end process Delays;

  end block CheckForRescindedRequests;
  

  
  
  sStrmDone <= false;

end architecture rtl;