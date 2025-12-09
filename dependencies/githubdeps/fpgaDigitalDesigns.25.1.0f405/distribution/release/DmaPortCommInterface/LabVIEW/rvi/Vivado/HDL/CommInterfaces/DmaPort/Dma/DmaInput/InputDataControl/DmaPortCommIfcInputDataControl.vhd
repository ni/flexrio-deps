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

  use work.PkgDmaPortCommunicationInterface.all;
  use work.PkgDmaPortCommIfcInputDataControl.all;
  use work.PkgCommIntConfiguration.all;

entity DmaPortCommIfcInputDataControl is
  generic (

    
    
    
    kNumOfInStrms : natural := 16;

    
    
    
    kInStrmIndex  : StrmIndex_t);
  port (
    aReset              : in  boolean;
    BusClk              : in  std_logic;

    
    
    
    bNiDmaInputDataFromDma   : in NiDmaInputDataFromDma_t;
    bNiDmaInputDataToDma     : out NiDmaInputDataToDma_t;

    
    
    
    bInputDataInterfaceFromFifoArray : in
      NiDmaInputDataToDmaArray_t(Larger(kNumOfInStrms,1)-1 downto 0);

    bInputDataInterfaceToFifoArray : out
      NiDmaInputDataFromDmaArray_t(Larger(kNumOfInStrms,1)-1 downto 0)
    );
end DmaPortCommIfcInputDataControl;

architecture rtl of DmaPortCommIfcInputDataControl is

  
  






















  
  
  
  
  
  constant kMaxNumOfStrms : natural := kNumberOfDmaChannels;

  
  
  
  type DmaChannelOneHotArray_t is array ( natural range<> )
       of NiDmaDmaChannelOneHot_t;
  subtype DmaChannelOneHotShiftReg_t is DmaChannelOneHotArray_t
          ( kFifoReadLatency downto 1 );
  signal bChannelOneHotShiftReg : DmaChannelOneHotShiftReg_t
         := (others => (others => false));

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  function ChannelOrderedDataFromFifo ( val : NiDmaInputDataToDmaArray_t )
           return NiDmaInputDataToDmaArray_t is
    variable rval : NiDmaInputDataToDmaArray_t ( NiDmaDmaChannelOneHot_t'range )
                  := (others => kNiDmaInputDataToDmaZero);
    variable StrmCount : natural;
  begin

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    for i in rval'range loop
      if    kDmaFifoConfArray(i).Mode = NiFpgaTargetToHost
         or kDmaFifoConfArray(i).Mode = NiFpgaPeerToPeerWriter then
        rval ( i ) := val ( kInStrmIndex ( i ) );
      end if;
    end loop;

    return rval;
  end function ChannelOrderedDataFromFifo;

  signal bChannelOrderedData : NiDmaInputDataToDmaArray_t ( NiDmaDmaChannelOneHot_t'range );

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  function SelectData ( InputDataToDma : NiDmaInputDataToDmaArray_t;
                        Channel : NiDmaDmaChannelOneHot_t ) return
                        NiDmaInputDataToDmaArray_t is
    variable rval : NiDmaInputDataToDmaArray_t ( InputDataToDma'range ) :=
                    (others => kNiDmaInputDataToDmaZero);
  begin

    
    
    for i in rval'range loop
      if Channel ( i ) then
        rval ( i ) := InputDataToDma ( i );
      end if;
    end loop;

    return rval;
  end function SelectData;

  
  signal bSelectedInputDataToDmaArray :
         NiDmaInputDataToDmaArray_t ( NiDmaDmaChannelOneHot_t'range ) :=
         (others => kNiDmaInputDataToDmaZero);

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
begin

  assert kInputDataDelay > 0
    report "This architecture adds at least one stage of delay on the data path"
    severity failure;

  
  
  
  






  
  
  
  
  OneHotChannelShifter:
  Process ( BusClk ) is
  begin
    if rising_edge ( BusClk ) then
      bChannelOneHotShiftReg <=
         bChannelOneHotShiftReg ( kFifoReadLatency - 1 downto 1 )
       & bNiDmaInputDataFromDma.DmaChannel;
    end if;
  end Process OneHotChannelShifter;

  
  
  
  
  
  bChannelOrderedData <=
    ChannelOrderedDataFromFifo ( bInputDataInterfaceFromFifoArray );
  SelectRegister:
  Process ( BusClk ) is
  begin
    if rising_edge ( BusClk ) then
      bSelectedInputDataToDmaArray <= SelectData (
        bChannelOrderedData,
        bChannelOneHotShiftReg ( kFifoReadLatency ));
    end if;
  end process SelectRegister;

  
  
  
  
  
  
  
  

  
  
  
  
  
  DmaPortInputDataToDmaDelayx: entity work.DmaPortInputDataToDmaDelay (RTL)
    generic map (kDelay => kInputDataDelay-1)  
    port map (
      Clk                         => BusClk,                                    
      cNiDmaInputDataToDma        => OrArray ( bSelectedInputDataToDmaArray ),  
      cNiDmaInputDataToDmaDelayed => bNiDmaInputDataToDma);                     

  
  
  
  bInputDataInterfaceToFifoArray <= (others => bNiDmaInputDataFromDma );

end rtl;