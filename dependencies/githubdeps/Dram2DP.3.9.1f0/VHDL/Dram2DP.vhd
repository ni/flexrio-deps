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
  use work.PkgCommunicationInterface.all;
  use work.PkgDmaPortCommIfcArbiter.all;
  use work.PkgNiDma.all;
  use work.PkgNiDmaConfig.all;
  use work.PkgDram2DP.all;
  use work.PkgDram2DPConstants.all;

entity Dram2DP is
  generic (
    
    kSizeOfMemBuffers : positive := 22;
    
    
    
    
    kSizeOfLlbMemBuffer : positive := 20;
    
    kMaxNumOfMemBuffers : natural range 0 to 5 := 2;
    
    kDmaChannelNum : NiDmaGeneralChannel_t :=
      to_unsigned(kNiDmaDmaChannels - 1, NiDmaGeneralChannel_t'length);
    
    kHmbInUse : boolean := true;
    
    kLlbInUse : boolean := true;
    
    
    kDramInterfaceDataWidth : positive := kDefaultDramInterfaceDataWidth;
    
    
    
    
    
    
    
    kDefaultBaggage : NiDmaBaggage_t := SetField(0, 16#1A#, kNiDmaBaggageWidth);
    
    
    
    
    
    
    
    
    kDevRamSinkOffset : natural  := kNiDmaHighSpeedSinkBase + 4096;
    
    
    
    
    
    
    
    
    
    
    
    
    kDevRamSWOffset   : integer  := kNiDmaHighSpeedSinkBase + 4096 - 16#40000#
  );
  port (
    aBusReset:                   in std_logic;
    BusClk:                      in std_logic;

    
    bRegPortIn:                  in RegPortIn_t;
    bRegPortOut:                 out RegPortOut_t;

    
    dHighSpeedSinkFromDma:       in NiDmaHighSpeedSinkFromDma_t;

    
    
    
    
    

    
    
    dDramAddrFifoAddr:           in std_logic_vector(kDramInterfaceAddressWidth-1 downto 0);
    dDramAddrFifoCmd:            in std_logic_vector(2 downto 0);
    dDramAddrFifoFull:           out std_logic;
    dDramAddrFifoWrEn:           in std_logic;
    dDramRdDataValid:            out std_logic;
    dDramRdFifoDataOut:          out std_logic_vector(kDramInterfaceDataWidth-1 downto 0);
    dDramWrFifoDataIn:           in std_logic_vector(kDramInterfaceDataWidth-1 downto 0);
    dDramWrFifoFull:             out std_logic;
    
    dDramWrFifoMaskData:         in std_logic_vector(kDramInterfaceDataWidth/8-1 downto 0);
    dDramWrFifoWrEn:             in std_logic;
    dPhyInitDoneForLvfpga:       out std_logic;

    
    dLlbDramAddrFifoAddr:          in std_logic_vector(kDramInterfaceAddressWidth-1 downto 0);
    dLlbDramAddrFifoCmd:           in std_logic_vector(2 downto 0);
    dLlbDramAddrFifoFull:          out std_logic;
    dLlbDramAddrFifoWrEn:          in std_logic;
    dLlbDramRdDataValid:           out std_logic;
    dLlbDramRdFifoDataOut:         out std_logic_vector(kDramInterfaceDataWidth-1 downto 0);
    dLlbDramWrFifoDataIn:          in std_logic_vector(kDramInterfaceDataWidth-1 downto 0);
    dLlbDramWrFifoFull:            out std_logic;
    
    dLlbDramWrFifoMaskData:        in std_logic_vector(kDramInterfaceDataWidth/8-1 downto 0);
    dLlbDramWrFifoWrEn:            in std_logic;
    dLlbPhyInitDoneForLvfpga:      out std_logic;

    
    
    
    
    
    DMAClk : in std_logic;
    
    dNiFpgaInputRequestToDma:    out NiDmaInputRequestToDma_t;
    dNiFpgaInputRequestFromDma:  in NiDmaInputRequestFromDma_t;
    dNiFpgaInputDataToDma:       out NiDmaInputDataToDma_t;
    dNiFpgaInputDataFromDma:     in NiDmaInputDataFromDma_t;
    
    dNiFpgaInputStatusFromDma:   in NiDmaInputStatusFromDma_t;

    
    dNiFpgaOutputRequestToDma:   out NiDmaOutputRequestToDma_t;
    dNiFpgaOutputRequestFromDma: in NiDmaOutputRequestFromDma_t;
    dNiFpgaOutputDataFromDma:    in NiDmaOutputDataFromDma_t;

    
    dNiFpgaInputArbReq:          out NiDmaArbReq_t;
    dNiFpgaInputArbGrant:        in NiDmaArbGrant_t;
    dNiFpgaOutputArbReq:         out NiDmaArbReq_t;
    dNiFpgaOutputArbGrant:       in NiDmaArbGrant_t
  );
end Dram2DP;

architecture rtl of Dram2DP is

  
  signal dCoreReset: boolean;
  signal dPushValidWrite: boolean;
  signal dValidWriteWord: std_logic_vector(kNiDmaDataWidth-1 downto 0);
  

  constant kLocalMemSizeInBytes : natural := 4096;
  signal dLclAddr: std_logic_vector(Log2(kLocalMemSizeInBytes*8/kDramInterfaceDataWidth) downto 0);

  type ArbiterIfcState is (IDLE, REQ, GRANT, DONE);
  signal dArbiterIfcRdState : ArbiterIfcState;
  signal dArbiterIfcRdStateNxt : ArbiterIfcState;
  signal dArbiterIfcWrState : ArbiterIfcState;
  signal dArbiterIfcWrStateNxt : ArbiterIfcState;

  constant kByteCountLength : integer := dNiFpgaOutputRequestToDma.ByteCount'length;

  
  constant kSizeOfMemBufferinBytes: integer := 2**kSizeOfMemBuffers;
  constant kSizeOfLlbMemBufferinBytes: integer := 2**kSizeOfLlbMemBuffer;

  
  constant kSizeOfBaseAddressTable: integer := 2**kMaxNumOfMemBuffers;

  
  signal dDataOut: std_logic_vector(kNiDmaDataWidth-1 downto 0);

  
  
  
  constant kDataFifoAddrW : natural := 5;
  signal dEmptyCount: unsigned(kDataFifoAddrW downto 0);
  signal dFullCount: unsigned(kDataFifoAddrW downto 0);

  
  signal dDequeue: boolean;

  
  signal dDequeueDelay : std_logic_vector (kNiDmaInputDataReadLatency-2 downto 0);

  
  
  
  
  signal bHmbCoreEnabled : boolean;
  signal bLlbCoreEnabled : boolean;
  
  signal dHmbCoreEnabled : boolean;
  signal dLlbCoreEnabled : boolean;
  signal dLocalCoreEnabled : boolean;
  
  
  signal bNumOfMemBuffers : std_logic_vector(kMaxNumOfMemBuffers downto 0);
  
  type AddressTable_t is array ( natural range<> ) of std_logic_vector(31 downto 0);
  
  signal bBaseAddrTableLo : AddressTable_t(kSizeOfBaseAddressTable-1 downto 0);
  signal bBaseAddrTableHi : AddressTable_t(kSizeOfBaseAddressTable-1 downto 0);

  signal bLowLatencyBufferLo : std_logic_vector(31 downto 0);
  signal bLowLatencyBufferHi : std_logic_vector(31 downto 0);

  signal bBaggageBits : NiD2DBaggageArr_t(0 to 2**kMaxNumOfMemBuffers-1) := (others => kDefaultBaggage);
  signal bLlbBaggageBits : NiDmaBaggage_t := kDefaultBaggage;
  signal dMappedBaggage : NiDmaBaggage_t;

  
  signal dBufferIndex : natural range 0 to kSizeOfBaseAddressTable - 1;

  
  signal dBaseAddr : std_logic_vector(kNiDmaAddressWidth - 1 downto 0);
  
  signal dMappedAddr : unsigned(kNiDmaAddressWidth - 1 downto 0);

  signal dWrAddressReady        : boolean;
  signal dLatchedAddress        : unsigned(kNiDmaAddressWidth - 1 downto 0);
  signal dLatchedBaggage        : NiDmaBaggage_t;
  signal dLatchedData           : std_logic_vector(dDramWrFifoDataIn'range);
  signal dSerializingData       : boolean;
  signal dConsumeLatchedAddress : boolean;

  signal dLatchedRdAddress        : unsigned(kNiDmaAddressWidth - 1 downto 0);
  signal dLatchedRdBaggage        : NiDmaBaggage_t;

  
  signal dOutOfRange : boolean := false;

  signal dAcceptRead : boolean := false;
  signal dAcceptWrite : boolean := false;
  signal dAcceptWriteData : boolean := false;

  signal dReadyToRead : boolean := false;
  signal dReadyForValidReadDmaPort : boolean := false;
  signal dAcceptValidReadDmaPort : boolean := false;
  signal dReadyForValidReadLlb : boolean;
  signal dValidReadIsNewLlb : boolean := true;
  signal dAcceptValidReadLlb : boolean := false;

  signal dReadyToWrite : boolean := false;
  signal dReadyForValidWrite : boolean := false;
  signal dAcceptValidWrite : boolean := false;

  signal dDmaDataValid : std_logic := '0';
  signal dMyPop : boolean := false;

  signal dConsumeBadRead: boolean := false;
  signal dConsumeBadWrite: boolean := false;

  
  signal dLocalDramAddrFifoAddrRaw : std_logic_vector(dDramAddrFifoAddr'range);
  signal dLocalDramAddrFifoAddr    : std_logic_vector(dDramAddrFifoAddr'range);
  signal dLocalDramAddrFifoCmd     : std_logic_vector(dDramAddrFifoCmd'range);
  signal dLocalDramAddrFifoWrEn    : std_logic;
  signal dLocalDramWrFifoDataIn    : std_logic_vector(dDramWrFifoDataIn'range);
  signal dLocalDramWrFifoMaskData  : std_logic_vector(dDramWrFifoMaskData'range);
  signal dLocalDramWrFifoWrEn      : std_logic;
  signal dLocalAccessIsLlb         : boolean;

  constant kLastWrWord  : natural := Larger(kDramInterfaceDataWidth, kNiDmaDataWidth) / kNiDmaDataWidth - 1;
  signal dCurrentWrWord : natural range 0 to kLastWrWord;

  signal dDramAcceptCmd      : boolean;
  signal dLlbDramAcceptCmd   : boolean;

  
  function ValidAddress (Addr : std_logic_vector;
                         NumOfMemBuffers : std_logic_vector;
                         LocalAccessIsLlb : boolean)
                   return boolean is
  begin
    
    if LocalAccessIsLlb then
      return kSizeOfLlbMemBufferinBytes  > unsigned(Addr);
    else
      return kSizeOfMemBufferinBytes * resize(unsigned(NumOfMemBuffers), Addr'length) > unsigned(Addr);
    end if;
  end ValidAddress;

  
  function getOffsetWithinBuffer(Addr : std_logic_vector(kDramInterfaceAddressWidth-1 downto 0))
    return unsigned is
  begin
    return unsigned(Addr(kSizeOfMemBuffers-1 downto 0));
  end getOffsetWithinBuffer;

  
  function getBufferNumber(Addr : std_logic_vector(kDramInterfaceAddressWidth-1 downto 0))
    return integer is
  begin
    return to_integer(unsigned(Addr(kMaxNumOfMemBuffers+kSizeOfMemBuffers-1 downto kSizeOfMemBuffers)));
  end getBufferNumber;

  
  function getBaseAddressIndex(regPortAddress : unsigned)
    return natural is
  begin
    return ((to_integer(regPortAddress/4) * 16) - kBufferAddressLo(0)) / kRegPortAddressesPerBuffer;
  end getBaseAddressIndex;

  
  function WordSwap(Data : std_logic_vector(kDramInterfaceDataWidth-1 downto 0)) return std_logic_vector is
    variable j : natural;
    variable RetVal : std_logic_vector(kDramInterfaceDataWidth-1 downto 0);
  begin
    if kDramInterfaceDataWidth >= 64 then
      for i in 0 to kDramInterfaceDataWidth/64 -  1 loop
        j := kDramInterfaceDataWidth/64 - 1 - i;
        RetVal(i*64 + 63 downto i*64) := Data(j*64 + 63 downto j*64);
      end loop;
    else
      RetVal := Data;
    end if;
    return RetVal;
  end function WordSwap;

begin

  --synopsys translate_off
  assert kNiDmaInputDataReadLatency < 2**(kDataFifoAddrW-1)
    report "Too high DMA Input read latency configured"
    severity failure;
  --synopsys translate_on

  LocalArbq : process(DMAClk, aBusReset)
  begin 
    if aBusReset = '1' then
      dLocalAccessIsLlb <= false;
    elsif rising_edge(DMAClk) then
      
      
      
      if dDramAddrFifoWrEn = '1' and
         (dLlbDramAcceptCmd or dLlbDramAddrFifoWrEn = '0') then
        dLocalAccessIsLlb <= false;
      elsif dLlbDramAddrFifoWrEn = '1' and
           (dDramAcceptCmd or dDramAddrFifoWrEn = '0') then
        dLocalAccessIsLlb <= true;
      end if;
    end if;
  end process LocalArbq;

  WrBufferState : process(DMAClk, aBusReset)
  begin 
    if aBusReset = '1' then
      dWrAddressReady       <= false;
      dAcceptValidWrite     <= false;
      dLatchedAddress       <= (others => '0');
      dLatchedBaggage       <= (others => '0');
      dLatchedData          <= (others => '0');
      dSerializingData      <= false;
      dCurrentWrWord        <= 0;
    elsif rising_edge(DMAClk) then
      dAcceptValidWrite     <= false;

      if not dWrAddressReady  then
        if  dReadyForValidWrite and not dSerializingData then
          
          
          dAcceptValidWrite <= true;
          dLatchedAddress   <= dMappedAddr;
          dLatchedData      <= WordSwap(dLocalDramWrFifoDataIn);
          dLatchedBaggage   <= dMappedBaggage;
          dWrAddressReady   <= true;

          dSerializingData  <= true;
        end if;
      else
        if dConsumeLatchedAddress then
          dWrAddressReady  <= false;
        end if;
      end if;

      if dSerializingData then
        if dEmptyCount > 0 then
          if dCurrentWrWord = kLastWrWord then
            dSerializingData <= false;
          else
            dCurrentWrWord <= dCurrentWrWord + 1;
          end if;
        end if;
      else
        dCurrentWrWord    <= 0;
      end if;

    end if;
  end process WrBufferState;

  
  

  
  dLocalDramAddrFifoAddrRaw <= dDramAddrFifoAddr      when kHmbInUse and not dLocalAccessIsLlb else
                               dLlbDramAddrFifoAddr   when kLlbInUse and     dLocalAccessIsLlb else
                               (others => '0');
  dLocalDramAddrFifoCmd     <= dDramAddrFifoCmd       when kHmbInUse and not dLocalAccessIsLlb else
                               dLlbDramAddrFifoCmd    when kLlbInUse and     dLocalAccessIsLlb else
                               (others => '0');
  dLocalDramAddrFifoWrEn    <= dDramAddrFifoWrEn      when kHmbInUse and not dLocalAccessIsLlb else
                               dLlbDramAddrFifoWrEn   when kLlbInUse and     dLocalAccessIsLlb else
                               '0';
  dLocalDramWrFifoDataIn    <= dDramWrFifoDataIn      when kHmbInUse and not dLocalAccessIsLlb else
                               dLlbDramWrFifoDataIn   when kLlbInUse and     dLocalAccessIsLlb else
                               (others => '0');
  
  
  dLocalDramWrFifoMaskData  <= dDramWrFifoMaskData    when kHmbInUse and not dLocalAccessIsLlb else
                               dLlbDramWrFifoMaskData when kLlbInUse and     dLocalAccessIsLlb else
                               (others => '0');
  dLocalDramWrFifoWrEn      <= dDramWrFifoWrEn        when kHmbInUse and not dLocalAccessIsLlb else
                               dLlbDramWrFifoWrEn     when kLlbInUse and     dLocalAccessIsLlb else
                               '0';

  dLocalCoreEnabled         <= dHmbCoreEnabled        when kHmbInUse and not dLocalAccessIsLlb else
                               dLlbCoreEnabled        when kLlbInUse and     dLocalAccessIsLlb else
                               false;


  ConsumeInvalidRequest: process (aBusReset, DMAClk) is
  begin
    if aBusReset = '1' then  
      dConsumeBadRead <= false;
      dConsumeBadWrite <= false;
    elsif rising_edge(DMAClk) then
      dConsumeBadRead <= dReadyToRead and dOutOfRange;
      dConsumeBadWrite <= dReadyToWrite and dLocalDramWrFifoWrEn = '1' and dOutOfRange;
    end if;
  end process;

  
  
  
  process(dLocalDramAddrFifoAddrRaw)
    constant kTotalLeftShift : integer := log2(kDramInterfaceDataWidth / 8) - 3;
  begin
    if kTotalLeftShift < 0 then
      dLocalDramAddrFifoAddr <= std_logic_vector(shift_right(unsigned(dLocalDramAddrFifoAddrRaw), -kTotalLeftShift));
    else
      dLocalDramAddrFifoAddr <= std_logic_vector(shift_left(unsigned(dLocalDramAddrFifoAddrRaw), kTotalLeftShift));
    end if;
  end process;

  
  
  
  
  dOutOfRange <= not ValidAddress(dLocalDramAddrFifoAddr, bNumOfMemBuffers, dLocalAccessIsLlb);


  
  
  
  
  dReadyToRead <= dLocalDramAddrFifoCmd = kReadCmd and
                  dLocalDramAddrFifoWrEn = '1' and
                  dLocalCoreEnabled; 

  
  dReadyForValidReadDmaPort <= dReadyToRead and not dOutOfRange and not dLocalAccessIsLlb;
  dReadyForValidReadLlb     <= dReadyToRead and not dOutOfRange and     dLocalAccessIsLlb;

  
  dAcceptRead <= dConsumeBadRead or dAcceptValidReadDmaPort or dAcceptValidReadLlb;

  
  
  

  
  dReadyToWrite <= dLocalDramAddrFifoCmd = kWriteCmd and 
                   dLocalDramAddrFifoWrEn = '1' and      
                   dLocalDramWrFifoWrEn = '1' and        
                   dLocalCoreEnabled;                    

  
  dReadyForValidWrite <= dReadyToWrite and not dOutOfRange;

  
  dAcceptWrite <= dConsumeBadWrite or dAcceptValidWrite;

  dAcceptWriteData <= dConsumeBadWrite or dAcceptValidWrite;

  

  
  dDramAcceptCmd    <= (dAcceptRead or dAcceptWrite) and not dLocalAccessIsLlb;
  dLlbDramAcceptCmd <= (dAcceptRead or dAcceptWrite) and     dLocalAccessIsLlb;

  dDramAddrFifoFull    <= to_StdLogic(not dDramAcceptCmd);
  dLlbDramAddrFifoFull <= to_StdLogic(not dLlbDramAcceptCmd);

  
  dDramWrFifoFull    <= to_StdLogic(not dAcceptWriteData or     dLocalAccessIsLlb);
  dLlbDramWrFifoFull <= to_StdLogic(not dAcceptWriteData or not dLocalAccessIsLlb);

  
  dPhyInitDoneForLvfpga    <= to_StdLogic(dHmbCoreEnabled);
  dLlbPhyInitDoneForLvfpga <= to_StdLogic(dLlbCoreEnabled);

  
  

  
  dBufferIndex <= getBufferNumber(dLocalDramAddrFifoAddr);

  
  
  

  
  Assign32: if kNiDmaAddressWidth = 32 generate
    dBaseAddr <= bLowLatencyBufferLo when dLocalAccessIsLlb else
                 bBaseAddrTableLo(dBufferIndex);
  end generate;
  Assign64: if kNiDmaAddressWidth = 64 generate
    
    
    dBaseAddr <= bLowLatencyBufferHi & bLowLatencyBufferLo when dLocalAccessIsLlb else
                 bBaseAddrTableHi(dBufferIndex) & bBaseAddrTableLo(dBufferIndex);
  end generate;

  
  
  
  dMappedBaggage <= bBaggageBits(dBufferIndex) when not dLocalAccessIsLlb else
                    bLlbBaggageBits;
  
  dMappedAddr <= unsigned(dBaseAddr) + getOffsetWithinBuffer(dLocalDramAddrFifoAddr);

  
  
  LatchRdMuxes : process(DMAClk, aBusReset)
  begin 
    if to_Boolean(aBusReset) then
      dLatchedRdAddress  <= (others => '0');
      dLatchedRdBaggage  <= (others => '0');
    elsif rising_edge(DMAClk) then
      dLatchedRdAddress  <= dMappedAddr;
      dLatchedRdBaggage  <= dMappedBaggage;
    end if;
  end process LatchRdMuxes;



  
  dNiFpgaInputDataToDma.Data <= dDataOut when dDmaDataValid = '1'
                                else (others => '0');


  
  
  WidePath: if kDramInterfaceDataWidth > kNiDmaDataWidth generate
    constant kLastRdWord  : natural := Larger(kDramInterfaceDataWidth, kNiDmaDataWidth) / kNiDmaDataWidth - 1;
    type DmaDataArray_t is array (natural range <>) of NiDmaData_t;
    signal dDmaDataHistory : DmaDataArray_t(0 to kLastRdWord-1);
    signal dDramRdFifoDataOutLcl : std_logic_vector(dDramRdFifoDataOut'range);
  begin

    ReadDeserializer : process(DMAClk, aBusReset)
    begin 
      if aBusReset = '1' then
        dDmaDataHistory <= (others => (others => '0'));
      elsif rising_edge(DMAClk) then
        if dNiFpgaOutputDataFromDma.Push and
              (dNiFpgaOutputDataFromDma.Space = kNiDmaSpaceDirectSysMem) and
              (dNiFpgaOutputDataFromDma.Channel = kDmaChannelNum) then
          
          dDmaDataHistory(kLastRdWord-1) <= dNiFpgaOutputDataFromDma.Data;
          for i in 0 to kLastRdWord - 2 loop
            dDmaDataHistory(i) <= dDmaDataHistory(i + 1);
          end loop;
        end if;
      end if;
    end process ReadDeserializer;

    ReadWordAggregation : process(dNiFpgaOutputDataFromDma.Data, dDmaDataHistory)
    begin
      dDramRdFifoDataOutLcl((kLastRdWord+1)*kNiDmaDataWidth-1 downto kLastRdWord*kNiDmaDataWidth) <=
          dNiFpgaOutputDataFromDma.Data;
      for i in 0 to kLastRdWord - 1 loop
        dDramRdFifoDataOutLcl((i+1)*kNiDmaDataWidth-1 downto i*kNiDmaDataWidth) <=
          dDmaDataHistory(i);
      end loop;
    end process;

    dDramRdFifoDataOut <= WordSwap(dDramRdFifoDataOutLcl);
  end generate;

  NarrowPath: if kDramInterfaceDataWidth <= kNiDmaDataWidth generate
  begin

    dDramRdFifoDataOut <= dNiFpgaOutputDataFromDma.Data(kDramInterfaceDataWidth-1 downto 0);

  end generate;

  
  dDramRdDataValid <= to_StdLogic(dNiFpgaOutputDataFromDma.Push and
                                  dNiFpgaOutputDataFromDma.TransferEnd and
                                  (dNiFpgaOutputDataFromDma.Space = kNiDmaSpaceDirectSysMem) and
                                  (dNiFpgaOutputDataFromDma.Channel = kDmaChannelNum));

  
  

  

  dDequeue <= dDequeueDelay(kNiDmaInputDataReadLatency-2) = '1' and dFullCount /= 0;
  dDmaDataValid <= dDequeueDelay(kNiDmaInputDataReadLatency-2);

  
  

  dMyPop <= dNiFpgaInputDataFromDma.Pop and
            (dNiFpgaInputDataFromDma.Space = kNiDmaSpaceDirectSysMem) and
            (dNiFpgaInputDataFromDma.Channel = kDmaChannelNum);

  PopDelayShiftRegister: process (aBusReset, DMAClk) is
  begin
    if aBusReset = '1' then  
      dDequeueDelay <= (others => '0');
    elsif rising_edge(DMAClk) then
      dDequeueDelay <= std_logic_vector(shift_left(unsigned(dDequeueDelay), 1));
      dDequeueDelay(0) <= to_StdLogic(dMyPop);
    end if;
  end process PopDelayShiftRegister;






  ArbiterStateRegs : process (aBusReset, DMAClk) is
  begin
    if aBusReset = '1' then
      dArbiterIfcRdState <= IDLE;
      dArbiterIfcWrState <= IDLE;
    elsif rising_edge(DMAClk) then
      dArbiterIfcRdState <= dArbiterIfcRdStateNxt;
      dArbiterIfcWrState <= dArbiterIfcWrStateNxt;
    end if;
  end process;

  ArbiterNextRdState : process (dArbiterIfcRdState,
                                dReadyForValidReadDmaPort,
                                dLatchedRdAddress,
                                dLatchedRdBaggage,
                                dNiFpgaOutputArbGrant,
                                dNiFpgaOutputRequestFromDma) is
  begin
    dNiFpgaOutputArbReq <= kNiDmaArbReqZero;
    dArbiterIfcRdStateNxt <= dArbiterIfcRdState;
    dNiFpgaOutputRequestToDma <= kNiDmaOutputRequestToDmaZero;
    dAcceptValidReadDmaPort <= False;

    case dArbiterIfcRdState is
      when IDLE =>
        
        if dReadyForValidReadDmaPort then
          dArbiterIfcRdStateNxt <= REQ;
        end if;
      when REQ =>

        
        dNiFpgaOutputArbReq.NormalReq <= '1';

        
        if dNiFpgaOutputArbGrant.Grant = '1' then
          dArbiterIfcRdStateNxt <= GRANT;
        end if;
      when GRANT =>

        
        dNiFpgaOutputRequestToDma.Request <= True;
        dNiFpgaOutputRequestToDma.Space <= kNiDmaSpaceDirectSysMem;
        dNiFpgaOutputRequestToDma.Channel <= kDmaChannelNum;
        dNiFpgaOutputRequestToDma.Baggage <= dLatchedRdBaggage;
        dNiFpgaOutputRequestToDma.ByteCount <=
          to_unsigned(kDramInterfaceDataWidth/8, kByteCountLength);
        dNiFpgaOutputRequestToDma.Address <= unsigned(dLatchedRdAddress);

        
        if dNiFpgaOutputRequestFromDma.Acknowledge then
          dArbiterIfcRdStateNxt <= DONE;
          dAcceptValidReadDmaPort <= True;
        end if;
      when DONE =>
        dNiFpgaOutputArbReq.DoneStrb <= '1';
        dArbiterIfcRdStateNxt <= IDLE;
    end case;
  end process;

  ArbiterNextWrState : process (dArbiterIfcWrState,
                                dWrAddressReady,
                                dLatchedAddress,
                                dLatchedBaggage,
                                dFullCount,
                                dNiFpgaInputArbGrant,
                                dNiFpgaInputRequestFromDma) is
  begin
    dArbiterIfcWrStateNxt <= dArbiterIfcWrState;
    dNiFpgaInputArbReq <= kNiDmaArbReqZero;
    dNiFpgaInputRequestToDma <= kNiDmaInputRequestToDmaZero;
    dConsumeLatchedAddress <= False;
    case dArbiterIfcWrState is
      when IDLE =>
        
        
        if dWrAddressReady and dFullCount > Larger(0, kLastWrWord - kNiDmaInputDataReadLatency) then
          dArbiterIfcWrStateNxt <= REQ;
        end if;
      when REQ =>

        
        dNiFpgaInputArbReq.NormalReq <= '1';

        
        if dNiFpgaInputArbGrant.Grant = '1' then
          dArbiterIfcWrStateNxt <= GRANT;
        end if;
      when GRANT =>

        
        dNiFpgaInputRequestToDma.Request <= True;
        dNiFpgaInputRequestToDma.Space <= kNiDmaSpaceDirectSysMem;
        dNiFpgaInputRequestToDma.Channel <= kDmaChannelNum;
        dNiFpgaInputRequestToDma.Baggage <= dLatchedBaggage;
        dNiFpgaInputRequestToDma.ByteCount <=
          to_unsigned(kDramInterfaceDataWidth/8, kByteCountLength);
        dNiFpgaInputRequestToDma.Address <= unsigned(dLatchedAddress);

        
        if dNiFpgaInputRequestFromDma.Acknowledge then
          dConsumeLatchedAddress <= True;
          dArbiterIfcWrStateNxt <= DONE;
        end if;
      when DONE =>
        dNiFpgaInputArbReq.DoneStrb <= '1';
        dArbiterIfcWrStateNxt <= IDLE;
    end case;
  end process;


  
  dPushValidWrite <= dSerializingData and dEmptyCount > 0;

  
  process ( dCurrentWrWord, dLatchedData)
  begin
    if kDramInterfaceDataWidth >= kNiDmaDataWidth then
      
      for i in 0 to kNiDmaDataWidth -1 loop
        dValidWriteWord(i) <= dLatchedData(dCurrentWrWord * kNiDmaDataWidth + i);
      end loop;
    else
      
      dValidWriteWord <= std_logic_vector(resize(unsigned(dLatchedData), kNiDmaDataWidth));
    end if;
  end process;

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  SingleClkFifox: entity work.SingleClkFifo (rtl)
    generic map (
      kAddressWidth        => kDataFifoAddrW,   
      kWidth               => kNiDmaDataWidth,  
      kRamReadLatency      => 1,                
      kFifoAdditiveLatency => 0)                
    port map (
      aReset      => to_boolean(aBusReset),  
      Clk         => DMAClk,                 
      cReset      => false,                  
      cClkEn      => true,                   
      cWrite      => dPushValidWrite,        
      cDataIn     => dValidWriteWord,        
      cRead       => dDequeue,               
      cDataOut    => dDataOut,               
      cFullCount  => dFullCount,             
      cEmptyCount => dEmptyCount,            
      cDataValid  => open);                  


  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  RegPortRegisters: process (aBusReset, BusClk) is
    variable vRegPortOut : RegPortOut_t := kRegPortOutZero;
    procedure DriveRegPortOut(RegPortIn : RegPortIn_t; RegPortOut : inout RegPortOut_t; ReadOnly : boolean := false) is
    begin
      RegPortOut.Data      := RegPortOut.Data; 
      RegPortOut.Ready     := RegPortOut.Ready and not (RegPortIn.Rd or (RegPortIn.Wt and not ReadOnly));
      RegPortOut.DataValid := RegPortOut.DataValid or RegPortIn.Rd;
    end procedure DriveRegPortOut;
  begin
    if aBusReset = '1' then
      bHmbCoreEnabled <= false;
      bLlbCoreEnabled <= false;
      bBaseAddrTableLo <= (others => Zeros(32));
      bBaseAddrTableHi <= (others => Zeros(32));
      bLowLatencyBufferLo <= Zeros(32);
      bLowLatencyBufferHi <= Zeros(32);
      bLlbBaggageBits <= kDefaultBaggage;
      bBaggageBits <= (others => kDefaultBaggage);
      bNumOfMemBuffers <= (others=>'0');
      bRegPortOut <= kRegPortOutZero;
    elsif rising_edge(BusClk) then

      
      vRegPortOut.DataValid := false;
      vRegPortOut.Ready     := true;
      vRegPortOut.Data      := (others => '0');

      if bRegPortIn.address = (kVersionRegister / 4) then
        DriveRegPortOut(bRegPortIn, vRegPortOut, ReadOnly => true);
        if bRegPortIn.Rd then
          vRegPortOut.Data := vRegPortOut.Data or kCoreVersion;
        end if;
      end if;

      if bRegPortIn.address = (kCoreEnabled / 4) then
        DriveRegPortOut(bRegPortIn, vRegPortOut);
        if bRegPortIn.Wt then
          bHmbCoreEnabled <= to_boolean(bRegPortIn.Data(kEnable));
        end if;
        if bRegPortIn.Rd then
          vRegPortOut.Data := vRegPortOut.Data or SetBit(kEnable, bHmbCoreEnabled);
        end if;
      end if;

      if bRegPortIn.address = (kCoreEnabled2 / 4) then
        DriveRegPortOut(bRegPortIn, vRegPortOut);
        if bRegPortIn.Wt then
          if to_boolean(bRegPortIn.Data(kHmbEnable)) then
            bHmbCoreEnabled <= true;
          elsif to_boolean(bRegPortIn.Data(kHmbDisable)) then
            bHmbCoreEnabled <= false;
          end if;
          if to_boolean(bRegPortIn.Data(kLlbEnable)) then
            bLlbCoreEnabled <= true;
          elsif to_boolean(bRegPortIn.Data(kLlbDisable)) then
            bLlbCoreEnabled <= false;
          end if;
        end if;
        if bRegPortIn.Rd then
          vRegPortOut.Data := vRegPortOut.Data or SetBit(kHmbEnabled, bHmbCoreEnabled);
          vRegPortOut.Data := vRegPortOut.Data or SetBit(kLlbEnabled, bLlbCoreEnabled);
        end if;
      end if;

      if bRegPortIn.address = (kNumberOfBuffers / 4) then
        DriveRegPortOut(bRegPortIn, vRegPortOut);
        if bRegPortIn.Wt then
          bNumOfMemBuffers <= bRegPortIn.Data(kNumOfBuffers+bNumOfMemBuffers'length-1 downto kNumOfBuffers);
        end if;
        if bRegPortIn.Rd then
          vRegPortOut.Data := vRegPortOut.Data or SetField(kNumOfBuffers, bNumOfMemBuffers);
        end if;
      end if;

      if bRegPortIn.address = (kBufferAddressLoZero / 4) then
        DriveRegPortOut(bRegPortIn, vRegPortOut);
        if bRegPortIn.Wt then
          bBaseAddrTableLo(0) <= bRegPortIn.Data;
        end if;
        if bRegPortIn.Rd then
          vRegPortOut.Data := vRegPortOut.Data or bBaseAddrTableLo(0);
        end if;
      end if;

      if bRegPortIn.address = (kBufferAddressHiZero / 4) and kNiDmaAddressWidth = 64 then
        DriveRegPortOut(bRegPortIn, vRegPortOut);
        if bRegPortIn.Wt then
          bBaseAddrTableHi(0) <= bRegPortIn.Data;
        end if;
        if bRegPortIn.Rd then
          vRegPortOut.Data := vRegPortOut.Data or bBaseAddrTableHi(0);
        end if;
      end if;

      if bRegPortIn.address = (kCoreCapabilities / 4) then
        DriveRegPortOut(bRegPortIn, vRegPortOut, ReadOnly => true);
        if bRegPortIn.Rd then
          vRegPortOut.Data := vRegPortOut.Data or SetField(kCapMaxNumOfMemBuffers, kMaxNumOfMemBuffers);
          vRegPortOut.Data := vRegPortOut.Data or SetField(kCapSizeOfMemBuffers,   kSizeOfMemBuffers);
          vRegPortOut.Data := vRegPortOut.Data or SetField(kCapSizeOfLlbMemBuffer, kSizeOfLlbMemBuffer);
          vRegPortOut.Data := vRegPortOut.Data or SetBit  (kCapHmbInUse,           kHmbInUse);
          vRegPortOut.Data := vRegPortOut.Data or SetBit  (kCapLlbInUse,           kLlbInUse);
        end if;
      end if;

      if bRegPortIn.address = (kLlbCapabilities / 4) then
        DriveRegPortOut(bRegPortIn, vRegPortOut, ReadOnly => true);
        if bRegPortIn.Rd then
          vRegPortOut.Data := vRegPortOut.Data or SetField(kDevRamSwBaseOffset,
                                                    unsigned(to_signed(kDevRamSWOffset, kDevRamSwBaseOffsetSize)));
        end if;
      end if;

      if bRegPortIn.address = (kLowLatencyBufferLo / 4) then
        DriveRegPortOut(bRegPortIn, vRegPortOut);
        if bRegPortIn.Wt then
          bLowLatencyBufferLo <= bRegPortIn.Data;
        end if;
        if bRegPortIn.Rd then
          vRegPortOut.Data := vRegPortOut.Data or bLowLatencyBufferLo;
        end if;
      end if;

      if bRegPortIn.address = (kLowLatencyBufferHi / 4) and kNiDmaAddressWidth = 64 then
        DriveRegPortOut(bRegPortIn, vRegPortOut);
        if bRegPortIn.Wt then
          bLowLatencyBufferHi <= bRegPortIn.Data;
        end if;
        if bRegPortIn.Rd then
          vRegPortOut.Data := vRegPortOut.Data or bLowLatencyBufferHi;
        end if;
      end if;

      if bRegPortIn.address = (kLowLatencyBufferBaggage / 4) then
        DriveRegPortOut(bRegPortIn, vRegPortOut);
        if bRegPortIn.Wt then
          bLlbBaggageBits <= bRegPortIn.Data(kNiDmaBaggageWidth-1 downto 0);
        end if;
        if bRegPortIn.Rd then
          vRegPortOut.Data := vRegPortOut.Data or SetField(0, bLlbBaggageBits);
        end if;
      end if;

      for index in 0 to 2**kMaxNumOfMemBuffers-1 loop
        if bRegPortIn.address = (kBufferAddressLo(index) / 4) then
          DriveRegPortOut(bRegPortIn, vRegPortOut);
          if bRegPortIn.Wt then
            bBaseAddrTableLo(index) <= bRegPortIn.Data;
          end if;
          if bRegPortIn.Rd then
            vRegPortOut.Data := vRegPortOut.Data or bBaseAddrTableLo(index);
          end if;
        end if;

        if bRegPortIn.address = (kBufferAddressHi(index) / 4) and kNiDmaAddressWidth = 64 then
          DriveRegPortOut(bRegPortIn, vRegPortOut);
          if bRegPortIn.Wt then
            bBaseAddrTableHi(index) <= bRegPortIn.Data;
          end if;
          if bRegPortIn.Rd then
            vRegPortOut.Data := vRegPortOut.Data or bBaseAddrTableHi(index);
          end if;
        end if;

        if bRegPortIn.address = (kBufferBaggage(index) / 4) then
          DriveRegPortOut(bRegPortIn, vRegPortOut);
          if bRegPortIn.Wt then
            bBaggageBits(index) <= bRegPortIn.Data(kNiDmaBaggageWidth-1 downto 0);
          end if;
          if bRegPortIn.Rd then
            vRegPortOut.Data := vRegPortOut.Data or SetField(0, bBaggageBits(index));
          end if;
        end if;

      end loop;

      bRegPortOut <= vRegPortOut;
    end if;
  end process RegPortRegisters;

  
  
  
  DoubleSyncBoolHmb: entity work.DoubleSyncBool (behavior)
    port map (
      aReset => to_boolean(aBusReset),  
      iClk   => BusClk,                 
      iSig   => bHmbCoreEnabled,                    
      oClk   => DMAClk,                 
      oSig   => dHmbCoreEnabled);                   

  DoubleSyncBoolLlb: entity work.DoubleSyncBool (behavior)
    port map (
      aReset => to_boolean(aBusReset),  
      iClk   => BusClk,                 
      iSig   => bLlbCoreEnabled,                    
      oClk   => DMAClk,                 
      oSig   => dLlbCoreEnabled);                   

  LlbReadDly : process(DMAClk, aBusReset)
  begin 
    if aBusReset = '1' then
      dValidReadIsNewLlb <= true;
    elsif rising_edge(DMAClk) then
      
      
      
      dValidReadIsNewLlb <= not dReadyForValidReadLlb or dAcceptValidReadLlb;
    end if;
  end process LlbReadDly;

  
  dAcceptValidReadLlb   <= dReadyForValidReadLlb and dValidReadIsNewLlb;

  
  dLclAddr   <= dLocalDramAddrFifoAddr(Log2(kDramInterfaceDataWidth/8) + dLclAddr'length - 1 downto Log2(kDramInterfaceDataWidth/8));
  dCoreReset <= not dLlbCoreEnabled;

  

  DevMem : if kLlbInUse generate
    signal dLclDataValid: boolean;
    signal dLclDout: std_logic_vector(kDramInterfaceDataWidth-1 downto 0);
  begin

    
    
    
    
    
    
    SingleClockDeviceRamx: entity work.SingleClockDeviceRam (RTL)
      generic map (
        kDevRamSizeInBytes        => kLocalMemSizeInBytes,     
        kDevRamSinkOffset         => kDevRamSinkOffset,        
        kDevRamViAccessSizeInBits => kDramInterfaceDataWidth)  
      port map (
        adReset               => to_Boolean(aBusReset),  
        dCoreReset            => dCoreReset,             
        DmaClock              => DMAClk,                 
        dHighSpeedSinkFromDma => dHighSpeedSinkFromDma,  
        dLclAddr              => dLclAddr,               
        dLclDout              => dLclDout,               
        dLclRd                => dAcceptValidReadLlb,    
        dLclDataValid         => dLclDataValid);         

    dLlbDramRdDataValid   <= to_StdLogic(dLclDataValid);
    dLlbDramRdFifoDataOut <= WordSwap(dLclDout);

  end generate;

  NoDevMem : if not kLlbInUse generate
  begin

    dLlbDramRdDataValid   <= '0';
    dLlbDramRdFifoDataOut <= (others => '0');

  end generate;

end rtl;