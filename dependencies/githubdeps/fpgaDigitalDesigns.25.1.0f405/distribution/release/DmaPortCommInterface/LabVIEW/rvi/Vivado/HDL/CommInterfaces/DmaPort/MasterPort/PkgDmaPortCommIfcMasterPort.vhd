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

package PkgDmaPortCommIfcMasterPort is

  
  
  

  
  type NiFpgaMasterWriteRequestFromMaster_t is record
    Request : boolean;
    Space : NiDmaSpace_t;
    Address : NiDmaAddress_t;
    Baggage : NiDmaBaggage_t;
    ByteSwap : NiDmaByteSwap_t;
    ByteLane : NiDmaByteLane_t;
    ByteCount : NiDmaInputByteCount_t;
  end record;

  constant kNiFpgaMasterWriteRequestFromMasterZero : NiFpgaMasterWriteRequestFromMaster_t
    := (Request => false,
        Space => kNiDmaSpaceStream,
        Address => (others => '0'),
        Baggage => (others => '0'),
        ByteSwap => (others => '0'),
        ByteLane => (others => '0'),
        ByteCount => (others => '0')
        );

  function SizeOf(Var : NiFpgaMasterWriteRequestFromMaster_t) return integer;

  type NiFpgaMasterWriteRequestToMaster_t is record
    Acknowledge : boolean;
  end record;

  constant kNiFpgaMasterWriteRequestToMasterZero : NiFpgaMasterWriteRequestToMaster_t := (
    Acknowledge => false
  );

  function SizeOf(Var : NiFpgaMasterWriteRequestToMaster_t) return integer;

  
  type NiFpgaMasterWriteDataFromMaster_t is record
    Data : NiDmaData_t;
  end record;

  constant kNiFpgaMasterWriteDataFromMasterZero : NiFpgaMasterWriteDataFromMaster_t := (
    Data => (others => '0')
  );

  function SizeOf(Var : NiFpgaMasterWriteDataFromMaster_t) return integer;


  type NiFpgaMasterWriteDataToMaster_t is record
    TransferStart : boolean;
    TransferEnd : boolean;
    Space : NiDmaSpace_t;
    ByteLane : NiDmaByteLane_t;
    ByteCount : NiDmaBusByteCount_t;
    ByteEnable : NiDmaByteEnable_t;
    Pop : boolean;
  end record;

  constant kNiFpgaMasterWriteDataToMasterZero : NiFpgaMasterWriteDataToMaster_t := (
    TransferStart => false,
    TransferEnd => false,
    Space => kNiDmaSpaceStream,
    ByteLane => (others => '0'),
    ByteCount => (others => '0'),
    ByteEnable => (others => false),
    Pop => false
  );

  function SizeOf(Var : NiFpgaMasterWriteDataToMaster_t) return integer;

  
  type NiFpgaMasterWriteStatusToMaster_t is record
    Ready : boolean;
    Space : NiDmaSpace_t;
    ByteCount : NiDmaInputByteCount_t;
    ErrorStatus : boolean;
  end record;

  constant kNiFpgaMasterWriteStatusToMasterZero : NiFpgaMasterWriteStatusToMaster_t := (
    Ready => false,
    Space => kNiDmaSpaceStream,
    ByteCount => (others => '0'),
    ErrorStatus => false
  );

  function SizeOf(Var : NiFpgaMasterWriteStatusToMaster_t) return integer;

  
  
  

  
  type NiFpgaMasterReadRequestFromMaster_t is record
    Request : boolean;
    Space : NiDmaSpace_t;
    Address : NiDmaAddress_t;
    Baggage : NiDmaBaggage_t;
    ByteSwap : NiDmaByteSwap_t;
    ByteLane : NiDmaByteLane_t;
    ByteCount : NiDmaOutputByteCount_t;
  end record;

  constant kNiFpgaMasterReadRequestFromMasterZero : NiFpgaMasterReadRequestFromMaster_t
  := (Request => false,
      Space => kNiDmaSpaceStream,
      Address => (others => '0'),
      Baggage => (others => '0'),
      ByteSwap => (others => '0'),
      ByteLane => (others => '0'),
      ByteCount => (others => '0')
      );

  function SizeOf(Var : NiFpgaMasterReadRequestFromMaster_t) return integer;

  type NiFpgaMasterReadRequestToMaster_t is record
    Acknowledge : boolean;
  end record;

  constant kNiFpgaMasterReadRequestToMasterZero : NiFpgaMasterReadRequestToMaster_t := (
    Acknowledge => false
  );

  function SizeOf(Var : NiFpgaMasterReadRequestToMaster_t) return integer;

  
  type NiFpgaMasterReadDataToMaster_t is record
    TransferStart : boolean;
    TransferEnd : boolean;
    Space : NiDmaSpace_t;
    ByteLane : NiDmaByteLane_t;
    ByteCount : NiDmaBusByteCount_t;
    ErrorStatus : boolean;
    ByteEnable : NiDmaByteEnable_t;
    Push : boolean;
    Data : NiDmaData_t;
  end record;

  constant kNiFpgaMasterReadDataToMasterZero : NiFpgaMasterReadDataToMaster_t := (
    TransferStart => false,
    TransferEnd => false,
    Space => kNiDmaSpaceStream,
    ByteLane => (others => '0'),
    ByteCount => (others => '0'),
    ErrorStatus => false,
    ByteEnable => (others => false),
    Push => false,
    Data => (others => '0')
  );

  function SizeOf(Var : NiFpgaMasterReadDataToMaster_t) return integer;


  
  
  

  type NiFpgaMasterWriteRequestFromMasterArray_t is array (natural range <>)
    of NiFpgaMasterWriteRequestFromMaster_t;

  type NiFpgaMasterWriteRequestToMasterArray_t is array (natural range <>)
    of NiFpgaMasterWriteRequestToMaster_t;

  type NiFpgaMasterWriteDataFromMasterArray_t is array (natural range <>)
    of NiFpgaMasterWriteDataFromMaster_t;

  type NiFpgaMasterWriteDataToMasterArray_t is array (natural range <>)
    of NiFpgaMasterWriteDataToMaster_t;

  type NiFpgaMasterWriteStatusToMasterArray_t is array (natural range <>)
    of NiFpgaMasterWriteStatusToMaster_t;

  type NiFpgaMasterReadRequestFromMasterArray_t is array (natural range <>)
    of NiFpgaMasterReadRequestFromMaster_t;

  type NiFpgaMasterReadRequestToMasterArray_t is array (natural range <>)
    of NiFpgaMasterReadRequestToMaster_t;

  type NiFpgaMasterReadDataToMasterArray_t is array (natural range <>)
    of NiFpgaMasterReadDataToMaster_t;

end PkgDmaPortCommIfcMasterPort;

package body PkgDmaPortCommIfcMasterPort is

  function SizeOf(Var : NiFpgaMasterWriteRequestFromMaster_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;                   
    RetVal := RetVal + Var.Space'length;    
    RetVal := RetVal + Var.Address'length;  
    RetVal := RetVal + Var.Baggage'length;  
    RetVal := RetVal + Var.ByteSwap'length; 
    RetVal := RetVal + Var.ByteLane'length; 
    RetVal := RetVal + Var.ByteCount'length;
    return RetVal;
  end function SizeOf;

  function SizeOf(Var : NiFpgaMasterWriteRequestToMaster_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;
    return RetVal;
  end function SizeOf;

  function SizeOf(Var : NiFpgaMasterWriteDataFromMaster_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + Var.Data'length;
    return RetVal;
  end function SizeOf;

  function SizeOf(Var : NiFpgaMasterWriteDataToMaster_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;                     
    RetVal := RetVal + 1;                     
    RetVal := RetVal + Var.Space'length;      
    RetVal := RetVal + Var.ByteLane'length;   
    RetVal := RetVal + Var.ByteCount'length;  
    RetVal := RetVal + Var.ByteEnable'length; 
    RetVal := RetVal + 1;                     
    return RetVal;
  end function SizeOf;

  function SizeOf(Var : NiFpgaMasterWriteStatusToMaster_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;                       
    RetVal := RetVal + Var.Space'length;        
    RetVal := RetVal + Var.ByteCount'length;    
    RetVal := RetVal + 1;  
    return RetVal;
  end function SizeOf;

  function SizeOf(Var : NiFpgaMasterReadRequestFromMaster_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;                   
    RetVal := RetVal + Var.Space'length;    
    RetVal := RetVal + Var.Address'length;  
    RetVal := RetVal + Var.Baggage'length;  
    RetVal := RetVal + Var.ByteSwap'length; 
    RetVal := RetVal + Var.ByteLane'length; 
    RetVal := RetVal + Var.ByteCount'length;
    return RetVal;
  end function SizeOf;

  function SizeOf(Var : NiFpgaMasterReadRequestToMaster_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;
    return RetVal;
  end function SizeOf;

  function SizeOf(Var : NiFpgaMasterReadDataToMaster_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;                     
    RetVal := RetVal + 1;                     
    RetVal := RetVal + Var.Space'length;      
    RetVal := RetVal + Var.ByteLane'length;   
    RetVal := RetVal + Var.ByteCount'length;  
    RetVal := RetVal + 1;                     
    RetVal := RetVal + Var.ByteEnable'length; 
    RetVal := RetVal + 1;                     
    RetVal := RetVal + Var.Data'length;       
    return RetVal;
  end function SizeOf;

end PkgDmaPortCommIfcMasterPort;