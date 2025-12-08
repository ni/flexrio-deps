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

  use work.PkgDmaPortCommIfcArbiter.all;

entity DmaPortCommIfcInputArbiter is
  generic (

    
    
    
    kNumOfInStrms : natural := 64
  );
  port (
    aReset               : in  boolean;
    BusClk               : in  std_logic;
    bReset               : in  boolean;

    
    
    
    bInStrmsAccNormalReq     : in  std_logic_vector(ArbVecMSB(kNumOfInStrms) downto 0);
    bInStrmsAccEmergencyReq  : in  std_logic_vector(ArbVecMSB(kNumOfInStrms) downto 0);
    bInStrmsAccDoneStrb      : in  boolean;
    bInStrmsAccGrant         : out std_logic_vector(ArbVecMSB(kNumOfInStrms) downto 0)
    );

end DmaPortCommIfcInputArbiter;

architecture rtl of DmaPortCommIfcInputArbiter is

  type ArbitrationState_t is (Idle, EmergencyAccess, NormalAccess);
  signal bArbitrationState : ArbitrationState_t := (Idle);

  
  signal bInStrmsAccGntEmergency: std_logic_vector(kNumOfInStrms-1 downto 0);
  signal bInStrmsAccGntNormal: std_logic_vector(kNumOfInStrms-1 downto 0);
  signal bInStrmsAccStrmDoneEmergency: boolean ;
  signal bInStrmsAccStrmDoneNormal: boolean ;
  signal bInStrmsEmergencyEnArb: boolean;
  signal bInStrmsNormalEnArb: boolean;
  
  signal bInStrmsAccNormalReqAssert, bInStrmsAccEmergencyReqAssert: boolean;

begin

  
  
  
  
  LocalInArbiter: Block
  begin
    
    
    
    
    NoInStrm: if kNumOfInStrms = 0 generate

      bInStrmsAccEmergencyReqAssert <= false;
      bInStrmsAccNormalReqAssert <= false;

      bInStrmsAccGrant <= (others => '0');
      bInStrmsAccStrmDoneEmergency <= false;
      bInStrmsAccStrmDoneNormal <= false;
    end generate;

    
    
    
    
    
    

    OneInStrm: if kNumOfInStrms = 1 generate

      
      bInStrmsAccEmergencyReqAssert <= to_Boolean(OrVector(bInStrmsAccEmergencyReq));
      bInStrmsAccNormalReqAssert <= to_Boolean(OrVector(bInStrmsAccNormalReq));

      
      bInStrmsAccGrant <= (others=>'1') when bInStrmsEmergencyEnArb or bInStrmsNormalEnArb
        else (others=>'0');
      bInStrmsAccStrmDoneEmergency <= false;
      bInStrmsAccStrmDoneNormal <= false;
    end generate;

    
    
    
    
    

    MultInStrms: if kNumOfInStrms > 1 generate

      bInStrmsAccEmergencyReqAssert <= to_Boolean(OrVector(bInStrmsAccEmergencyReq));
      bInStrmsAccNormalReqAssert <= to_Boolean(OrVector(bInStrmsAccNormalReq));
      bInStrmsAccGrant <= bInStrmsAccGntEmergency or bInStrmsAccGntNormal;

      
      
      
      
      
      
      
      
      
      InStrmsEmergencyArbiter: entity work.DmaPortStrmArbiterRoundRobin (rtl)
        generic map (
          kNumOfStrms => kNumOfInStrms)  
        port map (
          aReset       => aReset,                        
          SysClk       => BusClk,                        
          sReset       => bReset,                        
          sAccReq      => bInStrmsAccEmergencyReq,       
          sAccGnt      => bInStrmsAccGntEmergency,       
          sEnArb       => bInStrmsEmergencyEnArb,        
          sAccDoneStrb => bInStrmsAccDoneStrb,           
          sStrmDone    => bInStrmsAccStrmDoneEmergency); 


      
      
      
      
      
      
      
      
      
      InStrmsNormalArbiter: entity work.DmaPortStrmArbiterRoundRobin (rtl)
        generic map (
          kNumOfStrms => kNumOfInStrms)  
        port map (
          aReset       => aReset,                     
          SysClk       => BusClk,                     
          sReset       => bReset,                     
          sAccReq      => bInStrmsAccNormalReq,       
          sAccGnt      => bInStrmsAccGntNormal,       
          sEnArb       => bInStrmsNormalEnArb,        
          sAccDoneStrb => bInStrmsAccDoneStrb,        
          sStrmDone    => bInStrmsAccStrmDoneNormal); 

    end generate;

  end block LocalInArbiter;

  bInStrmsEmergencyEnArb <= (bArbitrationState = EmergencyAccess);
  bInStrmsNormalEnArb <= (bArbitrationState = NormalAccess);

  StateMachineRegisters: process(aReset, BusClk)
  begin
    if aReset then
      bArbitrationState <= Idle;

    elsif rising_edge(BusClk) then
      if bReset then
        bArbitrationState <= Idle;

      else

        case bArbitrationState is
          when Idle =>
            if bInStrmsAccEmergencyReqAssert then
              bArbitrationState <= EmergencyAccess;
            elsif bInStrmsAccNormalReqAssert then
              bArbitrationState <= NormalAccess;
            end if;

          when EmergencyAccess =>

            if bInStrmsAccDoneStrb or bInStrmsAccStrmDoneEmergency then
              bArbitrationState <= Idle;
            end if;

          when NormalAccess =>

            if bInStrmsAccDoneStrb or bInStrmsAccStrmDoneNormal then
              bArbitrationState <= Idle;
            end if;

        end case;

      end if;
    end if;
  end process StateMachineRegisters;

end rtl;