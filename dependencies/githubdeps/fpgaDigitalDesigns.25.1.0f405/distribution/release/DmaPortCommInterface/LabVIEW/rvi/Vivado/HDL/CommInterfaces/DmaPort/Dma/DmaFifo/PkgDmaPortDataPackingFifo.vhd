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
  use work.PkgNiDmaConfig.all;
  use work.PkgNiDma.all;

Package PkgDmaPortDataPackingFifo is

  
  
  function ActualSampleSize(
    SampleSizeInBits : natural;
    PeerToPeer       : boolean;
    FxpType          : boolean
  ) return natural;

  
  
  function ActualFifoPortWidth(ViFifoPortWidth : natural) return natural;

  
  
  
  
  
  
  function FifoCountWidth(
    SampleSize   : natural;
    AddressWidth : natural
  ) return natural;

  
  
  
  
  function GetWriteEnables(
    WriteSampleAddress : unsigned;
    WrPortWidth        : natural
  ) return BooleanVector;


end Package PkgDmaPortDataPackingFifo;

Package body PkgDmaPortDataPackingFifo is

  
  
  
  function ActualSampleSize (SampleSizeInBits : natural;
                             PeerToPeer       : boolean;
                             FxpType          : boolean)
  return natural is

    variable rval : natural;
    variable AllowedWordSize : natural;

  begin

    
    if FxpType and not PeerToPeer then
      return 64;

    
    else

      
      
      
      
      
      
      
      
      BusSizeLoop:
      for i in 8 downto 0 loop
        AllowedWordSize := 8 * (2**i);
        if SampleSizeInBits <= AllowedWordSize then
          rval := AllowedWordSize;
        end if;
      end loop BusSizeLoop;
      
      return rval;

    end if;
  end function;

  
  
  
  
  function ActualFifoPortWidth(ViFifoPortWidth : natural) return natural is

  begin

    if kNiDmaDataWidth >= ViFifoPortWidth then
      
      return kNiDmaDataWidth;
    else
      
      return ViFifoPortWidth;
    end if;

  end function;

  
  function FifoCountWidth(SampleSize : natural;
                          AddressWidth : natural
  ) return natural is

  begin

    if kNiDmaDataWidth >= SampleSize then
      return AddressWidth + Log2(kNiDmaDataWidth/SampleSize);
    else
      return AddressWidth - Log2(SampleSize/kNiDmaDataWidth);
    end if;

  end function;

  
  
  
  
  
  
  
  
  
  function GetWriteEnables(
    WriteSampleAddress : unsigned;
    WrPortWidth        : natural
  ) return BooleanVector is

    variable WriteEnables : BooleanVector(kNiDmaDataWidthInBytes-1 downto 0);

  begin

    if WrPortWidth < kNiDmaDataWidth then
    
    
    

      for i in kNiDmaDataWidthInBytes-1 downto 0 loop
        WriteEnables(i) := i/(WrPortWidth/8) = WriteSampleAddress;
      end loop;

    else 
    
    
      WriteEnables := (others => true);

    end if;

    return WriteEnables;

  end function;


end Package body PkgDmaPortDataPackingFifo;
