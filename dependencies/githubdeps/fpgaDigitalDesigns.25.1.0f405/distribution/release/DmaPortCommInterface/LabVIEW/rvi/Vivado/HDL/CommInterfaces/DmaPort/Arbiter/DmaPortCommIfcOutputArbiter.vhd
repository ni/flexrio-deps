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

entity DmaPortCommIfcOutputArbiter is
  generic (

    
    
    
    kNumOfOutStrms : natural := 16
  );
  port (
    aReset               : in  boolean;
    BusClk               : in  std_logic;
    bReset               : in  boolean;

    
    
    
    bOutStrmsAccNormalReq     : in  std_logic_vector(ArbVecMSB(kNumOfOutStrms) downto 0);
    bOutStrmsAccEmergencyReq  : in  std_logic_vector(ArbVecMSB(kNumOfOutStrms) downto 0);
    bOutStrmsAccDoneStrb      : in  boolean;
    bOutStrmsAccGrant         : out std_logic_vector(ArbVecMSB(kNumOfOutStrms) downto 0)
  );
end DmaPortCommIfcOutputArbiter;

architecture rtl of DmaPortCommIfcOutputArbiter is

  type ArbitrationState_t is (Idle, EmergencyAccess, NormalAccess);
  signal bArbitrationState : ArbitrationState_t := (Idle);

  
  signal bOutStrmsAccGntEmergency: std_logic_vector(kNumOfOutStrms-1 downto 0);
  signal bOutStrmsAccGntNormal: std_logic_vector(kNumOfOutStrms-1 downto 0);
  signal bOutStrmsAccStrmDoneEmergency: boolean ;
  signal bOutStrmsAccStrmDoneNormal: boolean ;
  signal bOutStrmsEmergencyEnArb: boolean;
  signal bOutStrmsNormalEnArb: boolean;
  
  signal bOutStrmsAccNormalReqAssert, bOutStrmsAccEmergencyReqAssert: boolean;

begin

  bOutStrmsEmergencyEnArb <= (bArbitrationState = EmergencyAccess);
  bOutStrmsNormalEnArb <= (bArbitrationState = NormalAccess);

  LocalOutArbiter: Block
  begin
    
    
    
    
    NoOutStrm: if kNumOfOutStrms = 0 generate

      bOutStrmsAccEmergencyReqAssert <= false;
      bOutStrmsAccNormalReqAssert <= false;
      bOutStrmsAccGrant <= (others => '0');

      bOutStrmsAccStrmDoneEmergency <= false;
      bOutStrmsAccStrmDoneNormal <= false;
    end generate;

    
    
    
    
    
    

    OneOutStrm: if kNumOfOutStrms = 1 generate

      
      bOutStrmsAccNormalReqAssert <= to_Boolean(OrVector(bOutStrmsAccNormalReq));
      bOutStrmsAccEmergencyReqAssert <= to_Boolean(OrVector(bOutStrmsAccEmergencyReq));

      
      bOutStrmsAccGrant <= (others=>'1') when bOutStrmsEmergencyEnArb or bOutStrmsNormalEnArb
        else (others=>'0');
      bOutStrmsAccStrmDoneEmergency <= false;
      bOutStrmsAccStrmDoneNormal <= false;
    end generate;

    
    
    
    
    

    MultOutStrms: if kNumOfOutStrms > 1 generate

      bOutStrmsAccNormalReqAssert <= to_Boolean(OrVector(bOutStrmsAccNormalReq));
      bOutStrmsAccEmergencyReqAssert <= to_Boolean(OrVector(bOutStrmsAccEmergencyReq));
      bOutStrmsAccGrant <= bOutStrmsAccGntEmergency or bOutStrmsAccGntNormal;

      
      
      
      
      
      
      
      
      
      OutStrmsEmergencyArbiter: entity work.DmaPortStrmArbiterRoundRobin (rtl)
        generic map (
          kNumOfStrms => kNumOfOutStrms)  
        port map (
          aReset       => aReset,                         
          SysClk       => BusClk,                         
          sReset       => bReset,                         
          sAccReq      => bOutStrmsAccEmergencyReq,       
          sAccGnt      => bOutStrmsAccGntEmergency,       
          sEnArb       => bOutStrmsEmergencyEnArb,        
          sAccDoneStrb => bOutStrmsAccDoneStrb,           
          sStrmDone    => bOutStrmsAccStrmDoneEmergency); 


      
      
      
      
      
      
      
      
      
      OutStrmsNormalArbiter: entity work.DmaPortStrmArbiterRoundRobin (rtl)
        generic map (
          kNumOfStrms => kNumOfOutStrms)  
        port map (
          aReset       => aReset,                      
          SysClk       => BusClk,                      
          sReset       => bReset,                      
          sAccReq      => bOutStrmsAccNormalReq,       
          sAccGnt      => bOutStrmsAccGntNormal,       
          sEnArb       => bOutStrmsNormalEnArb,        
          sAccDoneStrb => bOutStrmsAccDoneStrb,        
          sStrmDone    => bOutStrmsAccStrmDoneNormal); 

    end generate;

  end block LocalOutArbiter;


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
            if bOutStrmsAccEmergencyReqAssert then
              bArbitrationState <= EmergencyAccess;
            elsif bOutStrmsAccNormalReqAssert then
              bArbitrationState <= NormalAccess;
            end if;

          when EmergencyAccess =>

            if bOutStrmsAccDoneStrb or bOutStrmsAccStrmDoneEmergency then
              bArbitrationState <= Idle;
            end if;

          when NormalAccess =>

            if bOutStrmsAccDoneStrb or bOutStrmsAccStrmDoneNormal then
              bArbitrationState <= Idle;
            end if;

        end case;

      end if;
    end if;
  end process StateMachineRegisters;

end rtl;