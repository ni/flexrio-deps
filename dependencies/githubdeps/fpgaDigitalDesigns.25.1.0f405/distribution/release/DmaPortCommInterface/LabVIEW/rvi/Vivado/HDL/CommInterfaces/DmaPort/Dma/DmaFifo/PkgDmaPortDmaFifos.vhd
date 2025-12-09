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

library work;
  use work.PkgNiUtilities.all;
  use work.PkgCommIntConfiguration.all;
  use work.PkgDmaPortCommIfcStreamStates.all;
  use work.PkgDmaPortDataPackingFifo.all;
  use work.PkgNiDma.all;
  use work.PkgNiDmaConfig.all;

Package PkgDmaPortDmaFifos is

  function FifoDepthInDataBusWidthWords(FifoDepthInSamples : integer;
                                        SampleSizeInBits : integer)
    return natural;

  function GetFifoDepths(ChannelConfig: DmaChannelConfArray_t)
    return DmaChannelConfArray_t;

  type FifoDataWidthArray_t is array (natural range <>) of integer;

  function GetFifoDataWidth(FifoConfig: DmaChannelConfArray_t)
    return FifoDataWidthArray_t;

  
  
  type InputStreamInterfaceToFifo_t is record

    
    
    
    

    
    
    DmaReset : boolean;

    
    Pop : boolean;

    
    
    TransferEnd : boolean;

    
    ByteCount : NiDmaBusByteCount_t;

    
    
    ByteEnable : NiDmaByteEnable_t;

    
    
    NumReadSamples : NiDmaInputByteCount_t;

    
    
    
    RsrvReadSpaces : boolean;

    
    StreamState : StreamStateValue_t;
    
    
    ByteLane : NiDmaByteLane_t;

  end record;

  constant kInputStreamInterfaceToFifoZero : InputStreamInterfaceToFifo_t :=
   (DmaReset => false,
    Pop => false,
    TransferEnd => false,
    ByteCount => (others=>'0'),
    ByteEnable => (others=>false),
    NumReadSamples => (others=>'0'),
    RsrvReadSpaces => false,
    StreamState => kStreamStateUnlinked,
    ByteLane => (others => '0'));

  function SizeOf(Var : InputStreamInterfaceToFifo_t) return integer;


  
  
  type InputStreamInterfaceFromFifo_t is record

    
    
    
    

    
    
    ResetDone : boolean;

    
    FifoDataOut : NiDmaData_t;

    
    
    
    FifoFullCount : unsigned(31 downto 0);

    
    FifoOverflow : boolean;

    
    ByteLanePtr : NiDmaByteLane_t;

    
    
    StartStreamRequest : boolean;

    
    
    StopStreamRequest : boolean;

    
    
    
    StopStreamWithFlushRequest : boolean;

    
    
    
    
    
    
    
    FlushRequest : boolean;
    
    WritesDisabled : boolean;

    
    WriteDetected : boolean;

    
    
    StateInDefaultClkDomain : StreamStateValue_t;

  end record;

  constant kInputStreamInterfaceFromFifoZero : InputStreamInterfaceFromFifo_t :=
   (ResetDone => false,
    FifoDataOut => (others=>'0'),
    FifoFullCount => (others=>'0'),
    FifoOverflow => false,
    ByteLanePtr => (others=>'0'),
    StartStreamRequest => false,
    StopStreamRequest => false,
    StopStreamWithFlushRequest => false,
    FlushRequest => false,
    WritesDisabled => true,
    WriteDetected => false,
    StateInDefaultClkDomain => to_StreamStateValue(Unlinked));

  function SizeOf(Var : InputStreamInterfaceFromFifo_t) return integer;

  
  
  type OutputStreamInterfaceToFifo_t is record

    
    
    
    

    
    
    DmaReset : boolean;

    
    
    FifoWrite : boolean;

    
    
    WriteLengthInBytes : NiDmaBusByteCount_t;

    
    FifoData : NiDmaData_t;

    
    
    ByteEnable : NiDmaByteEnable_t;

    
    RsrvWriteSpaces : boolean;

    
    
    NumWriteSpaces : unsigned(31 downto 0);

    
    StreamState : StreamStateValue_t;

    
    
    
    ReportDisabledToDiagram : boolean;

  end record;

  constant kOutputStreamInterfaceToFifoZero : OutputStreamInterfaceToFifo_t :=
   (DmaReset => false,
    FifoWrite => false,
    WriteLengthInBytes => (others=>'0'),
    FifoData => (others=>'0'),
    ByteEnable => (others=> false),
    RsrvWriteSpaces => false,
    NumWriteSpaces => (others=>'0'),
    StreamState => to_StreamStateValue(Unlinked),
    ReportDisabledToDiagram => false);

  function SizeOf(Var : OutputStreamInterfaceToFifo_t) return integer;


  
  
  type OutputStreamInterfaceFromFifo_t is record

    
    
    
    

    
    
    ResetDone : boolean;

    
    
    
    EmptyCount : unsigned(31 downto 0);

    
    
    
    
    RsrvdSpacesFilled : boolean;

    
    FifoUnderflow : boolean;

    
    
    StartStreamRequest : boolean;

    
    
    StopStreamRequest : boolean;

    
    
    
    
    HostReadableFullCount : unsigned(31 downto 0);

    
    
    StateInDefaultClkDomain : StreamStateValue_t;

  end record;


  constant kOutputStreamInterfaceFromFifoZero : OutputStreamInterfaceFromFifo_t :=
   (ResetDone => false,
    EmptyCount => (others=>'0'),
    RsrvdSpacesFilled => false,
    FifoUnderflow => false,
    StartStreamRequest => false,
    StopStreamRequest => false,
    HostReadableFullCount => (others=>'0'),
    StateInDefaultClkDomain => to_StreamStateValue(Unlinked));

  function SizeOf(Var : OutputStreamInterfaceFromFifo_t) return integer;


  
  type InputStreamInterfaceFromFifoArray_t is array (natural range <>) of
    InputStreamInterfaceFromFifo_t;
  type InputStreamInterfaceToFifoArray_t is array (natural range <>) of
    InputStreamInterfaceToFifo_t;
  type OutputStreamInterfaceFromFifoArray_t is array (natural range <>) of
    OutputStreamInterfaceFromFifo_t;
  type OutputStreamInterfaceToFifoArray_t is array (natural range <>) of
    OutputStreamInterfaceToFifo_t;

end PkgDmaPortDmaFifos;


package body PkgDmaPortDmaFifos is

  
  
  
  
  
  function FifoDepthInDataBusWidthWords(FifoDepthInSamples : integer;
                                        SampleSizeInBits : integer)
    return natural is

  begin

    
    
    
    assert(SampleSizeInBits = 8 or SampleSizeInBits = 16 or SampleSizeInBits = 32 or
      SampleSizeInBits = 64 or FifoDepthInSamples = 0)
      report "Sample size reported as " & integer'image(SampleSizeInBits) & LF &
             " which is not one of the restricted values of 8, 16, 32, or 64."
      severity error;

    if FifoDepthInSamples <= 0 then
      return 0;
    else
      return (FifoDepthInSamples+1)*SampleSizeInBits/kNiDmaDataWidth;
    end if;
  end FifoDepthInDataBusWidthWords;


  
  
  
  
  
  
  function GetFifoDepths(ChannelConfig: DmaChannelConfArray_t)
    return DmaChannelConfArray_t is

    variable ReturnVal : DmaChannelConfArray_t(ChannelConfig'range);
    variable SampleSize : integer;
    variable PeerToPeer : boolean;

  begin

    
    ReturnVal := ChannelConfig;

    
    
    for i in ChannelConfig'range loop

      PeerToPeer := ChannelConfig(i).Mode = NiFpgaPeerToPeerWriter or
                    ChannelConfig(i).Mode = NiFpgaPeerToPeerReader;

      
      SampleSize := ActualSampleSize(
        SampleSizeInBits => ChannelConfig(i).FifoWidth,
        PeerToPeer       => PeerToPeer,
        FxpType          => ChannelConfig(i).FxpType);

      
      
      if ChannelConfig(i).Mode = NiFpgaPeerToPeerWriter or
         ChannelConfig(i).Mode = NiFpgaMemoryBufferWriter or      
         ChannelConfig(i).Mode = NiFpgaTargetToHost then
        ReturnVal(i).FifoDepth :=
          FifoDepthInDataBusWidthWords(ChannelConfig(i).FifoDepth, SampleSize);
      else
        ReturnVal(i).FifoDepth :=
          FifoDepthInDataBusWidthWords(ChannelConfig(i).FifoDepth -
                ChannelConfig(i).ElementsPerClockCycle * 6, SampleSize);
      end if;
    end loop;

    return ReturnVal;

  end GetFifoDepths;

  
  function GetFifoDataWidth(FifoConfig: DmaChannelConfArray_t)
    return FifoDataWidthArray_t is

    variable ReturnVal : FifoDataWidthArray_t(FifoConfig'range);

  begin

    for i in FifoConfig'range loop
      ReturnVal(i) := FifoConfig(i).FifoWidth*FifoConfig(i).ElementsPerClockCycle;
    end loop;

    return ReturnVal;

  end function;


  function SizeOf(Var : InputStreamInterfaceToFifo_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;                           
    RetVal := RetVal + 1;                           
    RetVal := RetVal + 1;                           
    RetVal := RetVal + Var.ByteCount'length;        
    RetVal := RetVal + Var.ByteEnable'length;       
    RetVal := RetVal + Var.NumReadSamples'length;   
    RetVal := RetVal + Var.ByteLane'length;         
    RetVal := RetVal + 1;                           
    RetVal := RetVal + Var.StreamState'length;      
    return RetVal;
  end function SizeOf;

  function SizeOf(Var : InputStreamInterfaceFromFifo_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;                                   
    RetVal := RetVal + var.FifoDataOut'length;              
    RetVal := RetVal + var.FifoFullCount'length;            
    RetVal := RetVal + 1;                                   
    RetVal := RetVal + Var.ByteLanePtr'length;              
    RetVal := RetVal + 1;                                   
    RetVal := RetVal + 1;                                   
    RetVal := RetVal + 1;                                   
    RetVal := RetVal + 1;                                   
    RetVal := RetVal + 1;                                   
    RetVal := RetVal + 1;                                   
    RetVal := RetVal + var.StateInDefaultClkDomain'length;  
    return RetVal;
  end function SizeOf;

  function SizeOf(Var : OutputStreamInterfaceToFifo_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;                                   
    RetVal := RetVal + 1;                                   
    RetVal := RetVal + Var.WriteLengthInBytes'length;       
    RetVal := RetVal + Var.FifoData'length;                 
    RetVal := RetVal + Var.ByteEnable'length;               
    RetVal := RetVal + 1;                                   
    RetVal := RetVal + Var.NumWriteSpaces'length;           
    RetVal := RetVal + Var.StreamState'length;              
    RetVal := RetVal + 1;                                   
    return RetVal;
  end function SizeOf;

  function SizeOf(Var : OutputStreamInterfaceFromFifo_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;                                   
    RetVal := RetVal + var.EmptyCount'length;               
    RetVal := RetVal + 1;                                   
    RetVal := RetVal + 1;                                   
    RetVal := RetVal + 1;                                   
    RetVal := RetVal + 1;                                   
    RetVal := RetVal + var.HostReadableFullCount'length;    
    RetVal := RetVal + var.StateInDefaultClkDomain'length;  
    return RetVal;
  end function SizeOf;
  
end PkgDmaPortDmaFifos;