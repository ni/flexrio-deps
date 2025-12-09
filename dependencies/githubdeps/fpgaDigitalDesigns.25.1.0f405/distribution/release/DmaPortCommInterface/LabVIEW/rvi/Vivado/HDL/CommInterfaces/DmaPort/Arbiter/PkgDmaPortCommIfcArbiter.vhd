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





















library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

Package PkgDmaPortCommIfcArbiter is

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  function ArbVecMSB(NumOfStrms : natural) return natural;
  
  
  
  constant kNumStreamsPerSubArbiter : natural := 4;

  type NiDmaArbReq_t is record
    NormalReq : std_logic;
    EmergencyReq : std_logic;
    DoneStrb : std_logic;
  end record;
  constant kNiDmaArbReqZero : NiDmaArbReq_t := (others => '0');

  type NiDmaArbReqArray_t is array ( natural range<> ) of NiDmaArbReq_t;

  
  
  
  function GetNormalReq ( val : NiDmaArbReqArray_t ) return std_logic_vector;
  function GetEmergencyReq ( val : NiDmaArbReqArray_t ) return std_logic_vector;
  function GetDoneStrb ( val : NiDmaArbReqArray_t ) return std_logic_vector;

  type NiDmaArbGrant_t is record
    Grant : std_logic;
  end record;
  constant kNiDmaArbGrantZero : NiDmaArbGrant_t := (others => '0');

  type NiDmaArbGrantArray_t is array ( natural range<> ) of NiDmaArbGrant_t;

  function to_NiDmaArbGrantArray_t ( val : std_logic_vector ) return NiDmaArbGrantArray_t;

end Package PkgDmaPortCommIfcArbiter;

Package body PkgDmaPortCommIfcArbiter is

  function ArbVecMSB (NumOfStrms : natural) return natural is  
  begin
    if NumOfStrms=0 then
      return 0;
    else 
      return NumOfStrms-1;
    end if;
  end function;

  function to_NiDmaArbGrantArray_t ( val : std_logic_vector ) return NiDmaArbGrantArray_t is
    variable rval : NiDmaArbGrantArray_t (val'range);
  begin
    for i in val'range loop
      rval ( i ) := (Grant => val ( i ));
    end loop;

    return rval;
  end function to_NiDmaArbGrantArray_t;

  function GetNormalReq ( val : NiDmaArbReqArray_t ) return std_logic_vector is
    variable rval : std_logic_vector ( val'range );
  begin
    for i in val'range loop
      rval ( i ) := val ( i ).NormalReq;
    end loop;
    return rval;
  end function GetNormalReq;

  function GetEmergencyReq ( val : NiDmaArbReqArray_t ) return std_logic_vector is
    variable rval : std_logic_vector ( val'range );
  begin
    for i in val'range loop
      rval ( i ) := val ( i ).EmergencyReq;
    end loop;
    return rval;
  end function GetEmergencyReq;

  function GetDoneStrb ( val : NiDmaArbReqArray_t ) return std_logic_vector is
    variable rval : std_logic_vector ( val'range );
  begin
    for i in val'range loop
      rval ( i ) := val ( i ).DoneStrb;
    end loop;
    return rval;
  end function GetDoneStrb;

end Package body PkgDmaPortCommIfcArbiter;
