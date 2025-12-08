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
  use work.PkgNiDmaRegMap.all;

package PkgNiDma is

  
  
  

  
  
  
  
  
  
  constant kNiDmaWriteSubsystems : natural := 1;
  constant kNiDmaReadSubsystems  : natural := 2;

  
  
  
  
  constant kNiDmaWriteInfoInterfaceID : natural := 0;

  
  
  
  
  
  constant kNiDmaReadInfoInterfaceID : natural := 0;
  
  
  
  
  
  
  constant kNiDmaLinkProcessorReadInfoInterfaceID : natural := 1;

  
  
  constant kNiDmaAddressSpacePerChannel : natural := 256;

  
  
  

  constant kNiDmaDataWidthInBytes : positive := kNiDmaDataWidth / 8;

  
  
  

  subtype NiDmaSpace_t is std_logic_vector(1 downto 0);
    constant kNiDmaSpaceStream       : NiDmaSpace_t := "00";
    constant kNiDmaSpaceMessage      : NiDmaSpace_t := "01";
    constant kNiDmaSpaceDirectLocMem : NiDmaSpace_t := "10";
    constant kNiDmaSpaceDirectSysMem : NiDmaSpace_t := "11";

  subtype NiDmaAddress_t is unsigned(kNiDmaAddressWidth - 1 downto 0);

  subtype NiDmaHighSpeedSinkAddress_t is
               unsigned(kNiDmaHighSpeedSinkAddressWidth - 1 downto 0);

  subtype NiDmaData_t is std_logic_vector(kNiDmaDataWidth - 1 downto 0);

  subtype NiDmaBaggage_t is std_logic_vector(kNiDmaBaggageWidth - 1 downto 0);

  subtype NiDmaDmaChannel_t is unsigned(Log2(kNiDmaDmaChannels) - 1 downto 0);

  subtype NiDmaDmaChannelOneHot_t is BooleanVector(0 to kNiDmaDmaChannels - 1);

  subtype NiDmaDirectChannel_t is unsigned(Log2(kNiDmaDirectMasters) - 1 downto 0);

  subtype NiDmaDirectChannelOneHot_t is BooleanVector(0 to kNiDmaDirectMasters - 1);

  subtype NiDmaGeneralChannel_t is unsigned(Larger(NiDmaDmaChannel_t'length,
                                    NiDmaDirectChannel_t'length) - 1 downto 0);

  subtype NiDmaByteLane_t is unsigned(Log2(kNiDmaDataWidthInBytes) - 1 downto 0);

  subtype NiDmaBusByteCount_t is unsigned(Log2(kNiDmaDataWidthInBytes) downto 0);

  subtype NiDmaInputByteCount_t is unsigned(Log2(kNiDmaInputMaxTransfer) downto 0);

  subtype NiDmaOutputByteCount_t is unsigned(Log2(kNiDmaOutputMaxTransfer) downto 0);

  subtype NiDmaByteEnable_t is BooleanVector(kNiDmaDataWidthInBytes - 1 downto 0);

  
  
  subtype NiDmaTransferID_t is unsigned(Log2(Larger(2,Larger(kNiDmaWriteSubsystems,
    kNiDmaReadSubsystems)))-1 downto 0);

  

  subtype NiDmaByteSwap_t is unsigned(kByteSwapSize - 1 downto 0);

  subtype NiDmaMode_t is unsigned(kModeSize - 1 downto 0);

  subtype NiDmaTtc_t is unsigned(kNiDmaTtcWidth - 1 downto 0);
  subtype NiDmaTtcLatch_t is unsigned(Larger(kNiDmaTtcWidth - 33, 0) downto 0);

  subtype NiDmaLinkSize_t is unsigned(Log2(kNiDmaMaxChunkyLinkSize) downto 0);

  
  
  

  
  type NiDmaInputRequestToDma_t is record
    Request : boolean;
    Space : NiDmaSpace_t;
    Channel : NiDmaGeneralChannel_t;
    Address : NiDmaAddress_t;
    Baggage : NiDmaBaggage_t;
    ByteSwap : NiDmaByteSwap_t;
    ByteLane : NiDmaByteLane_t;
    ByteCount : NiDmaInputByteCount_t;
    Done : boolean;
    EndOfRecord : boolean;
  end record;

  constant kNiDmaInputRequestToDmaZero : NiDmaInputRequestToDma_t := (
    Request => false,
    Space => kNiDmaSpaceStream,
    Channel => (others => '0'),
    Address => (others => '0'),
    Baggage => (others => '0'),
    ByteSwap => (others => '0'),
    ByteLane => (others => '0'),
    ByteCount => (others => '0'),
    Done => false,
    EndOfRecord => false
  );

  function SizeOf(Var : NiDmaInputRequestToDma_t) return integer;

  type NiDmaInputRequestFromDma_t is record
    Acknowledge : boolean;
  end record;

  constant kNiDmaInputRequestFromDmaZero : NiDmaInputRequestFromDma_t := (
    Acknowledge => false
  );

  
  type NiDmaInputDataToDma_t is record
    Data : NiDmaData_t;
  end record;

  constant kNiDmaInputDataToDmaZero : NiDmaInputDataToDma_t := (
    Data => (others => '0')
  );  
  
  function "or" (L, R : NiDmaInputDataToDma_t) return NiDmaInputDataToDma_t;

  type NiDmaInputDataFromDma_t is record
    TransferStart : boolean;
    TransferEnd : boolean;
    Space : NiDmaSpace_t;
    Channel : NiDmaGeneralChannel_t;
    DmaChannel : NiDmaDmaChannelOneHot_t;
    DirectChannel : NiDmaDirectChannelOneHot_t;
    ByteLane : NiDmaByteLane_t;
    ByteCount : NiDmaBusByteCount_t;
    Done : boolean;
    EndOfRecord : boolean;
    ByteEnable : NiDmaByteEnable_t;
    Pop : boolean;
  end record;

  constant kNiDmaInputDataFromDmaZero : NiDmaInputDataFromDma_t := (
    TransferStart => false,
    TransferEnd => false,
    Space => kNiDmaSpaceStream,
    Channel => (others => '0'),
    DmaChannel => (others => false),
    DirectChannel => (others => false),
    ByteLane => (others => '0'),
    ByteCount => (others => '0'),
    Done => false,
    EndOfRecord => false,
    ByteEnable => (others => false),
    Pop => false
  );  
  
  function SizeOf(Var : NiDmaInputDataFromDma_t) return integer;
  
  
  type NiDmaInputStatusFromDma_t is record
    Ready : boolean;
    Space : NiDmaSpace_t;
    Channel : NiDmaGeneralChannel_t;
    DmaChannel : NiDmaDmaChannelOneHot_t;
    DirectChannel : NiDmaDirectChannelOneHot_t;
    ByteCount : NiDmaInputByteCount_t;
    Done : boolean;
    EndOfRecord : boolean;
    ErrorStatus : boolean;
  end record;

  constant kNiDmaInputStatusFromDmaZero : NiDmaInputStatusFromDma_t := (
    Ready => false,
    Space => kNiDmaSpaceStream,
    Channel => (others => '0'),
    DmaChannel => (others => false),
    DirectChannel => (others => false),
    ByteCount => (others => '0'),
    Done => false,
    EndOfRecord => false,
    ErrorStatus => false
  );

  function SizeOf(Var : NiDmaInputStatusFromDma_t) return integer;
  
  
  

  
  type NiDmaOutputRequestToDma_t is record
    Request : boolean;
    Space : NiDmaSpace_t;
    Channel : NiDmaGeneralChannel_t;
    Address : NiDmaAddress_t;
    Baggage : NiDmaBaggage_t;
    ByteSwap : NiDmaByteSwap_t;
    ByteLane : NiDmaByteLane_t;
    ByteCount : NiDmaOutputByteCount_t;
    Done : boolean;
    EndOfRecord : boolean;
  end record;

  constant kNiDmaOutputRequestToDmaZero : NiDmaOutputRequestToDma_t := (
    Request => false,
    Space => kNiDmaSpaceStream,
    Channel => (others => '0'),
    Address => (others => '0'),
    Baggage => (others => '0'),
    ByteSwap => (others => '0'),
    ByteLane => (others => '0'),
    ByteCount => (others => '0'),
    Done => false,
    EndOfRecord => false
  );

  function SizeOf(Var : NiDmaOutputRequestToDma_t) return integer;

  type NiDmaOutputRequestFromDma_t is record
    Acknowledge : boolean;
  end record;

  constant kNiDmaOutputRequestFromDmaZero : NiDmaOutputRequestFromDma_t := (
    Acknowledge => false
  );

  
  type NiDmaOutputDataFromDma_t is record
    TransferStart : boolean;
    TransferEnd : boolean;
    Space : NiDmaSpace_t;
    Channel : NiDmaGeneralChannel_t;
    DmaChannel : NiDmaDmaChannelOneHot_t;
    DirectChannel : NiDmaDirectChannelOneHot_t;
    ByteLane : NiDmaByteLane_t;
    ByteCount : NiDmaBusByteCount_t;
    Done : boolean;
    EndOfRecord : boolean;
    ErrorStatus : boolean;
    ByteEnable : NiDmaByteEnable_t;
    Push : boolean;
    Data : NiDmaData_t;
  end record;

  constant kNiDmaOutputDataFromDmaZero : NiDmaOutputDataFromDma_t := (
    TransferStart => false,
    TransferEnd => false,
    Space => kNiDmaSpaceStream,
    Channel => (others => '0'),
    DmaChannel => (others => false),
    DirectChannel => (others => false),
    ByteLane => (others => '0'),
    ByteCount => (others => '0'),
    Done => false,
    EndOfRecord => false,
    ErrorStatus => false,
    ByteEnable => (others => false),
    Push => false,
    Data => (others => '0')
  );

  function SizeOf(Var : NiDmaOutputDataFromDma_t) return integer;
  
  
  

  type NiDmaHighSpeedSinkFromDma_t is record
    TransferStart : boolean;
    TransferEnd : boolean;
    Address : NiDmaHighSpeedSinkAddress_t;
    ByteLane : NiDmaByteLane_t;
    ByteCount : NiDmaBusByteCount_t;
    ByteEnable : NiDmaByteEnable_t;
    Push : boolean;
    Data : NiDmaData_t;
  end record;

  constant kNiDmaHighSpeedSinkFromDmaZero : NiDmaHighSpeedSinkFromDma_t := (
    TransferStart => false,
    TransferEnd => false,
    Address => (others => '0'),
    ByteLane => (others => '0'),
    ByteCount => (others => '0'),
    ByteEnable => (others => false),
    Push => false,
    Data => (others => '0')
  );
  
  function SizeOf(Var : NiDmaHighSpeedSinkFromDma_t) return integer;
  
  
  

  
  type NiDmaWriteInfoToDma_t is record
    Acknowledge : boolean;
  end record;

  constant kNiDmaWriteInfoToDmaZero : NiDmaWriteInfoToDma_t := (
    Acknowledge => false
  );

  type NiDmaWriteInfoFromDma_t is record
    Request : boolean;
    Last : boolean;
    Discard : boolean;
    Local : boolean;
    TransferID : NiDmaTransferID_t;
    Address : NiDmaAddress_t;
    Baggage : NiDmaBaggage_t;
    ByteCount : NiDmaInputByteCount_t;
  end record;

  constant kNiDmaWriteInfoFromDmaZero : NiDmaWriteInfoFromDma_t := (
    Request => false,
    Last => false,
    Discard => false,
    Local => false,
    TransferID => (others => '0'),
    Address => (others => '0'),
    Baggage => (others => '0'),
    ByteCount => (others => '0')
  );

  
  type NiDmaWriteDataToDma_t is record
    TransferID : NiDmaTransferID_t;
    Pop : boolean;
  end record;

  constant kNiDmaWriteDataToDmaZero : NiDmaWriteDataToDma_t := (
    TransferID => (others => '0'),
    Pop => false
  );

  type NiDmaWriteDataFromDma_t is record
    Ready : boolean;
    Data : NiDmaData_t;
    Valid : boolean;
  end record;

  constant kNiDmaWriteDataFromDmaZero : NiDmaWriteDataFromDma_t := (
    Ready => false,
    Data => (others => '0'),
    Valid => false
  );

  
  type NiDmaWriteStatusToDma_t is record
    TransferID : NiDmaTransferID_t;
    ByteCount : NiDmaInputByteCount_t;
    ErrorStatus : boolean;
    Valid : boolean;
  end record;

  constant kNiDmaWriteStatusToDmaZero : NiDmaWriteStatusToDma_t := (
    TransferID => (others => '0'),
    ByteCount => (others => '0'),
    ErrorStatus => false,
    Valid => false
  );

  
  
  

  
  type NiDmaReadInfoToDma_t is record
    Acknowledge : boolean;
  end record;

  constant kNiDmaReadInfoToDmaZero : NiDmaReadInfoToDma_t := (
    Acknowledge => false
  );

  type NiDmaReadInfoFromDma_t is record
    Request : boolean;
    Last : boolean;
    Discard : boolean;
    Local : boolean;
    TransferID : NiDmaTransferID_t;
    Address : NiDmaAddress_t;
    Baggage : NiDmaBaggage_t;
    ByteCount : NiDmaOutputByteCount_t;
  end record;

  constant kNiDmaReadInfoFromDmaZero : NiDmaReadInfoFromDma_t := (
    Request => false,
    Last => false,
    Discard => false,
    Local => false,
    TransferID => (others => '0'),
    Address => (others => '0'),
    Baggage => (others => '0'),
    ByteCount => (others => '0')
  );

  
  type NiDmaReadDataToDma_t is record
    TransferID : NiDmaTransferID_t;
    Last : boolean;
    ErrorStatus : boolean;
    Data : NiDmaData_t;
    Push : boolean;
  end record;

  constant kNiDmaReadDataToDmaZero : NiDmaReadDataToDma_t := (
    TransferID => (others => '0'),
    Last => false,
    ErrorStatus => false,
    Data => (others => '0'),
    Push => false
  );

  type NiDmaReadDataFromDma_t is record
    Accept : boolean;
  end record;
  
  constant kNiDmaReadDataFromDmaZero : NiDmaReadDataFromDma_t := (
    Accept => false
  );
  
  
  

  constant kNiDmaInputInfoFifoDepth : natural := kNiDmaInputMaxRequests;
  constant kNiDmaInputDataFifoDepth : natural := (kNiDmaInputDataBuffer *
                  kNiDmaInputMaxTransfer) / kNiDmaDataWidthInBytes;
  constant kNiDmaInputStatusFifoDepth : natural := kNiDmaInputMaxRequests;

  constant kNiDmaOutputInfoFifoDepth : natural := kNiDmaOutputMaxRequests;

  subtype NiDmaInputInfoFifoCount_t is unsigned(Log2(kNiDmaInputInfoFifoDepth) downto 0);
  subtype NiDmaInputDataFifoCount_t is unsigned(Log2(kNiDmaInputDataFifoDepth) downto 0);
  subtype NiDmaInputStatusFifoCount_t is unsigned(Log2(kNiDmaInputStatusFifoDepth) downto 0);

  subtype NiDmaOutputInfoFifoCount_t is unsigned(Log2(kNiDmaOutputInfoFifoDepth) downto 0);

  subtype NiDmaInputWordCount_t is unsigned(Log2(kNiDmaInputMaxTransfer /
                                                 kNiDmaDataWidthInBytes) downto 0);

  subtype NiDmaOutputWordCount_t is unsigned(Log2(kNiDmaOutputMaxTransfer /
                                                  kNiDmaDataWidthInBytes) downto 0);

  subtype NiDmaMaxMuxSelect_t is unsigned(Log2(kNiDmaMaxMuxWidth) - 1 downto 0);

  
  type NiDmaRequestProcessorToRegs_t is record
    ReadChannel : NiDmaDmaChannel_t;
    
    WriteChannelBarInvalid : NiDmaDmaChannel_t;
    SetBarInvalid : boolean;
    SendLinkCommand : boolean;
    
    WriteChannelMemoryAddress : NiDmaDmaChannel_t;
    WriteDataMemoryAddress : NiDmaAddress_t;
    WriteMemoryAddress : boolean;
    
    WriteChannelMemorySize : NiDmaDmaChannel_t;
    WriteDataMemorySize : NiDmaAddress_t;
    WriteMemorySize : boolean;
  end record;

  constant kNiDmaRequestProcessorToRegsZero : NiDmaRequestProcessorToRegs_t := (
    ReadChannel => (others => '0'),
    WriteChannelBarInvalid => (others => '0'),
    SetBarInvalid => false,
    SendLinkCommand => false,
    WriteChannelMemoryAddress => (others => '0'),
    WriteDataMemoryAddress => (others => '0'),
    WriteMemoryAddress => false,
    WriteChannelMemorySize => (others => '0'),
    WriteDataMemorySize => (others => '0'),
    WriteMemorySize => false
  );

  type NiDmaRegsToRequestProcessor_t is record
    ReadDataStart : boolean;
    ReadDataMode : NiDmaMode_t;
    ReadDataDisableLinkFetching : boolean;
    ReadDataBaseAddress : NiDmaAddress_t;
    ReadDataBaseSize : NiDmaAddress_t;
    ReadDataBarInvalid : boolean;
    ReadDataMemoryAddress : NiDmaAddress_t;
    ReadDataMemorySize : NiDmaAddress_t;
    ReadDataBaggage : NiDmaBaggage_t;
    ReadDataPushOnDone : boolean;
    ReadDataDoorbellSize : unsigned(kDoorbellSizeSize-1 downto 0);
    ReadDataNextListLinkAddress : NiDmaAddress_t;
    GrantBarInvalid : boolean;
    GrantMemoryAddress : boolean;
    GrantMemorySize : boolean;
  end record;
  
  
  type NiDmaInputDataToRegs_t is record
    ReadChannel1 : NiDmaDmaChannel_t;
    ReadChannel2 : NiDmaDmaChannel_t;
  end record;

  constant kNiDmaInputDataToRegsZero : NiDmaInputDataToRegs_t := (
    ReadChannel1 => (others => '0'),
    ReadChannel2 => (others => '0')
  );

  type NiDmaRegsToInputData_t is record
    
    ReadDataByteSwap : NiDmaByteSwap_t;
    
    ReadDataDoorbellValue : std_logic_vector(kDoorbellValueSize-1 downto 0);
  end record;  

  
  type NiDmaStatusToRegs_t is record
    ReadChannel : NiDmaDmaChannel_t;
    
    WriteChannelTtc : NiDmaDmaChannel_t;
    WriteDataTtc : NiDmaTtc_t;
    WriteTtc : boolean;
    
    WriteChannelStatus : NiDmaDmaChannel_t;
    SetError : boolean;
    SetLastLink : boolean;
    SetDone : boolean;
    SetTotalCount : boolean;
    SetInterrupt : boolean;
  end record;

  constant kNiDmaStatusToRegsZero : NiDmaStatusToRegs_t := (
    ReadChannel => (others => '0'),
    WriteChannelTtc => (others => '0'),
    WriteDataTtc => (others => '0'),
    WriteTtc => false,
    WriteChannelStatus => (others => '0'),
    SetError => false,
    SetLastLink => false,
    SetDone => false,
    SetTotalCount => false,
    SetInterrupt => false
  );

  type NiDmaRegsToStatus_t is record
    ReadDataStart : boolean;
    ReadDataMode : NiDmaMode_t;
    ReadDataDisableLinkFetching : boolean;
    ReadDataTtc : NiDmaTtc_t;
    ReadDataTcc : NiDmaTtc_t;
    ReadDataArmTotalCount : boolean;
    ReadDataNotifyOnError : boolean;
    ReadDataNotifyOnDone : boolean;
    ReadDataNotifyOnTotalCount : boolean;
    ReadDataPushOnDone : boolean;
    ReadDataDoorbellSize : unsigned(kDoorbellSizeSize-1 downto 0);
    GrantTtc : boolean;
    GrantStatus : boolean;
  end record;

  type NiDmaStatusToRegPort_t is record
    CompareMet : boolean;
    Channel : NiDmaDmaChannel_t;
  end record;

  constant kNiDmaStatusToRegPortZero : NiDmaStatusToRegPort_t := (
    CompareMet => false,
    Channel => (others => '0')
  );

  type NiDmaRegPortToStatus_t is record
    ArmingTcc : boolean;
    Channel : NiDmaDmaChannel_t;
  end record;

  constant kNiDmaRegPortToStatusZero : NiDmaRegPortToStatus_t := (
    ArmingTcc => false,
    Channel => (others => '0')
  );

  
  type NiDmaLinkProcessorToRegs_t is record
    ReadChannel : NiDmaDmaChannel_t;
    ReadChannel2 : NiDmaDmaChannel_t;
    
    WriteChannelLinkAddress : NiDmaDmaChannel_t;
    WriteDataLinkAddress : NiDmaAddress_t;
    WriteLinkAddress : boolean;
    
    WriteChannelLinkSize : NiDmaDmaChannel_t;
    WriteDataLinkSize : NiDmaLinkSize_t;
    WriteLinkSize : boolean;
    
    WriteChannelBarInvalid : NiDmaDmaChannel_t;
    ClearBarInvalid : boolean;
    
    WriteChannelBaseAddress : NiDmaDmaChannel_t;
    WriteDataBaseAddress : NiDmaAddress_t;
    WriteBaseAddress : boolean;
    
    WriteChannelBaseSize : NiDmaDmaChannel_t;
    WriteDataBaseSize : NiDmaAddress_t;
    WriteBaseSize : boolean;
    
    WriteChannelStatus : NiDmaDmaChannel_t;
    SetInterrupt : boolean;
    SetError : boolean;
    SetLinkReady : boolean;
    
    WriteChannelSetLinkBusy : NiDmaDmaChannel_t;
    SetLinkBusy : boolean;
    
    WriteChannelClearLinkBusy : NiDmaDmaChannel_t;
    ClearLinkBusy : boolean;
  end record;

  constant kNiDmaLinkProcessorToRegsZero : NiDmaLinkProcessorToRegs_t := (
    ReadChannel => (others => '0'),
    ReadChannel2 => (others => '0'),
    WriteChannelLinkAddress => (others => '0'),
    WriteDataLinkAddress => (others => '0'),
    WriteLinkAddress => false,
    WriteChannelLinkSize => (others => '0'),
    WriteDataLinkSize => (others => '0'),
    WriteLinkSize => false,
    WriteChannelBarInvalid => (others => '0'),
    ClearBarInvalid => false,
    WriteChannelBaseAddress => (others => '0'),
    WriteDataBaseAddress => (others => '0'),
    WriteBaseAddress => false,
    WriteChannelBaseSize => (others => '0'),
    WriteDataBaseSize => (others => '0'),
    WriteBaseSize => false,
    WriteChannelStatus => (others => '0'),
    SetInterrupt => false,
    SetError => false,
    SetLinkReady => false,
    WriteChannelSetLinkBusy => (others => '0'),
    SetLinkBusy => false,
    WriteChannelClearLinkBusy => (others => '0'),
    ClearLinkBusy => false
  );

  type NiDmaRegsToLinkProcessor_t is record
    ReadDataLinkAddress : NiDmaAddress_t;
    ReadDataLinkSize : NiDmaLinkSize_t;
    ReadDataLinkSize2 : NiDmaLinkSize_t;
    ReadDataBaggage : NiDmaBaggage_t;
    ReadDataNotifyOnError2 : boolean;
    GrantLinkAddress : boolean;
    GrantLinkSize : boolean;
    GrantBarInvalid : boolean;
    GrantBaseAddress : boolean;
    GrantBaseSize : boolean;
    GrantStatus : boolean;
    GrantSetLinkBusy : boolean;
    GrantClearLinkBusy : boolean;
    CommandChannel : NiDmaDmaChannel_t;
    CommandFirstLink : boolean;
    CommandPush : boolean;
  end record;

  
  type NiDmaInputWriteInfo_t is record
    Address : NiDmaAddress_t;
    ByteCount : NiDmaInputByteCount_t;
    Baggage : NiDmaBaggage_t;
    Last : boolean;
    Discard : boolean;
    Local : boolean;
  end record;

  constant kNiDmaInputWriteInfoZero : NiDmaInputWriteInfo_t := (
    Address => (others => '0'),
    ByteCount => (others => '0'),
    Baggage => (others => '0'),
    Last => false,
    Discard => false,
    Local => false
  );

  function SizeOf(Var : NiDmaInputWriteInfo_t) return integer;

  
  type NiDmaOutputReadInfo_t is record
    Address : NiDmaAddress_t;
    ByteCount : NiDmaOutputByteCount_t;
    Baggage : NiDmaBaggage_t;
    Last : boolean;
    Discard : boolean;
    Local : boolean;
  end record;

  constant kNiDmaOutputReadInfoZero : NiDmaOutputReadInfo_t := (
    Address => (others => '0'),
    ByteCount => (others => '0'),
    Baggage => (others => '0'),
    Last => false,
    Discard => false,
    Local => false
  );

  function SizeOf(Var : NiDmaOutputReadInfo_t) return integer;

  
  type NiDmaInputAlignmentInfo_t is record
    ByteLane : NiDmaByteLane_t;
    ByteCount : NiDmaInputByteCount_t;
    Last : boolean;
    Message : boolean;
    Discard : boolean;
    DonePush : boolean;
  end record;

  constant kNiDmaInputAlignmentInfoZero : NiDmaInputAlignmentInfo_t := (
    ByteLane => (others => '0'),
    ByteCount => (others => '0'),
    Last => false,
    Message => false,
    Discard => false,
    DonePush => false
  );

  function SizeOf(Var : NiDmaInputAlignmentInfo_t) return integer;

    
  type NiDmaOutputAlignmentInfo_t is record
    ByteLane : NiDmaByteLane_t;
    ByteCount : NiDmaOutputByteCount_t;
    Last : boolean;
    Discard : boolean;
    ErrorStatus : boolean;
    
    
    
    FirstWordByteCount : NiDmaBusByteCount_t;
    FirstWordReadCount : NiDmaBusByteCount_t;
  end record;

  constant kNiDmaOutputAlignmentInfoZero : NiDmaOutputAlignmentInfo_t := (
    ByteLane => (others => '0'),
    ByteCount => (others => '0'),
    Last => false,
    Discard => false,
    ErrorStatus => false,
    FirstWordByteCount => (others => '0'),
    FirstWordReadCount => (others => '0')
  );

  function SizeOf(Var : NiDmaOutputAlignmentInfo_t) return integer;

  
  type NiDmaInputStatusInfo_t is record
    ByteCount : NiDmaInputByteCount_t;
    ErrorStatus : boolean;
  end record;

  constant kNiDmaInputStatusInfoZero : NiDmaInputStatusInfo_t := (
    ByteCount => (others => '0'),
    ErrorStatus => false
  );
  
  function SizeOf(Var : NiDmaInputStatusInfo_t) return integer;

  
  type NiDmaCompanionControlInfo_t is record
    IORXBEEN : boolean;
    IOTXBEEN : boolean;
  end record;
  
  constant kNiDmaCompanionControlInfoZero : NiDmaCompanionControlInfo_t := (
    IORXBEEN => false,
    IOTXBEEN => false
  );
  
  type NiDmaInterruptToCompanion_t is record
    Channel : NiDmaDmaChannel_t;
    Push : boolean;
  end record;
  
  type NiDmaMessageInfoToCompanion_t is record
    Request : boolean;
    Address : NiDmaAddress_t;
    ByteCount : NiDmaInputByteCount_t;
  end record;
  
  constant kNiDmaMessageInfoToCompanionZero : NiDmaMessageInfoToCompanion_t := (
    Request => false,
    Address => (others => '0'),
    ByteCount => (others => '0')
  );
  
  type NiDmaMessageInfoFromCompanion_t is record
    ReadyForRequest : boolean;
  end record;

  constant kNiDmaMessageInfoFromCompanionZero : NiDmaMessageInfoFromCompanion_t := (
    ReadyForRequest => false
  );
  
  type NiDmaMessageDataToCompanion_t is record
    Data : NiDmaData_t;
    Valid : boolean;
  end record;
  
  constant kNiDmaMessageDataToCompanionZero : NiDmaMessageDataToCompanion_t := (
    Data => (others => '0'),
    Valid => false
  );

  
  function InputDataWords(ByteCount : NiDmaInputByteCount_t;
               StartingLane : NiDmaByteLane_t) return NiDmaInputWordCount_t;

  function ExtraDataWords(ByteCount : NiDmaInputByteCount_t;
               StartingLane : NiDmaByteLane_t) return NiDmaInputWordCount_t;

  function OutputDataWords(ByteCount : NiDmaOutputByteCount_t;
               StartingLane : NiDmaByteLane_t) return NiDmaOutputWordCount_t;

  function GetDmaChannelOneHot(Space : NiDmaSpace_t;
              Channel : NiDmaGeneralChannel_t) return NiDmaDmaChannelOneHot_t;

  function GetDirectChannelOneHot(Space : NiDmaSpace_t;
           Channel : NiDmaGeneralChannel_t) return NiDmaDirectChannelOneHot_t;

  function GetByteEnables(StartingLane : NiDmaByteLane_t;
                          ByteCount : unsigned) return NiDmaByteEnable_t;

  function GetWordByteCount(StartingLane : NiDmaByteLane_t;
                            ByteCount : unsigned) return NiDmaBusByteCount_t;

  

end PkgNiDma;

package body PkgNiDma is

  

  function SizeOf(Var : NiDmaInputRequestToDma_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;                     
    RetVal := RetVal + Var.Channel'length;    
    RetVal := RetVal + Var.ByteLane'length;   
    RetVal := RetVal + Var.ByteCount'length;  
    if kNiDmaDirectMasters > 0 then
      RetVal := RetVal + 1;                   
      RetVal := RetVal + Var.Address'length;  
    end if;
    RetVal := RetVal + Var.Baggage'length;    
    RetVal := RetVal + Var.ByteSwap'length;   
    RetVal := RetVal + 1;                     
    RetVal := RetVal + 1;                     
    return RetVal;
  end function SizeOf;

  

  function SizeOf(Var : NiDmaOutputRequestToDma_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;                     
    RetVal := RetVal + Var.Channel'length;    
    RetVal := RetVal + Var.ByteLane'length;   
    RetVal := RetVal + Var.ByteCount'length;  
    if kNiDmaDirectMasters > 0 then
      RetVal := RetVal + 1;                   
      RetVal := RetVal + Var.Address'length;  
    end if;
    RetVal := RetVal + Var.Baggage'length;    
    RetVal := RetVal + Var.ByteSwap'length;   
    RetVal := RetVal + 1;                     
    RetVal := RetVal + 1;                     
    return RetVal;
  end function SizeOf;

  
  function "or" (L, R : NiDmaInputDataToDma_t) return NiDmaInputDataToDma_t is
    variable RetVal : NiDmaInputDataToDma_t;
  begin
    RetVal.Data := L.Data or R.Data;
    return RetVal;
  end function "or";
  
  function SizeOf(Var : NiDmaInputDataFromDma_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;                     
    RetVal := RetVal + 1;                     
    RetVal := RetVal + Var.Space'length;      
    RetVal := RetVal + Var.Channel'length;      
    RetVal := RetVal + Var.DmaChannel'length;      
    RetVal := RetVal + Var.DirectChannel'length;      
    RetVal := RetVal + Var.ByteLane'length;      
    RetVal := RetVal + Var.ByteCount'length;      
    RetVal := RetVal + 1;                     
    RetVal := RetVal + 1;                     
    RetVal := RetVal + Var.ByteEnable'length;
    RetVal := RetVal + 1;                     
    return RetVal;    
  end function SizeOf;
  
  
  function SizeOf(Var : NiDmaInputStatusFromDma_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;                     
    RetVal := RetVal + Var.Space'length;      
    RetVal := RetVal + Var.Channel'length;      
    RetVal := RetVal + Var.DmaChannel'length;      
    RetVal := RetVal + Var.DirectChannel'length;      
    RetVal := RetVal + Var.ByteCount'length;      
    RetVal := RetVal + 1;                     
    RetVal := RetVal + 1;                     
    RetVal := RetVal + 1;                     
    return RetVal;    
  end function SizeOf;
  
  
  function SizeOf(Var : NiDmaOutputDataFromDma_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;                     
    RetVal := RetVal + 1;                     
    RetVal := RetVal + Var.Space'length;      
    RetVal := RetVal + Var.Channel'length;      
    RetVal := RetVal + Var.DmaChannel'length;      
    RetVal := RetVal + Var.DirectChannel'length;      
    RetVal := RetVal + Var.ByteLane'length;      
    RetVal := RetVal + Var.ByteCount'length;      
    RetVal := RetVal + 1;                     
    RetVal := RetVal + 1;                     
    RetVal := RetVal + 1;                     
    RetVal := RetVal + Var.ByteEnable'length;
    RetVal := RetVal + 1;                     
    RetVal := RetVal + Var.Data'length;
    return RetVal;   
  end function SizeOf;
  
  
  function SizeOf(Var : NiDmaHighSpeedSinkFromDma_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + 1;                     
    RetVal := RetVal + 1;                     
    RetVal := RetVal + Var.Address'length;       
    RetVal := RetVal + Var.ByteLane'length;      
    RetVal := RetVal + Var.ByteCount'length;      
    RetVal := RetVal + Var.ByteEnable'length;   
    RetVal := RetVal + 1;                     
    RetVal := RetVal + Var.Data'length;
    return RetVal;   
  end function SizeOf;
  
  

  function SizeOf(Var : NiDmaInputWriteInfo_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + Var.Address'length;     
    RetVal := RetVal + Var.ByteCount'length;   
    RetVal := RetVal + Var.Baggage'length;     
    RetVal := RetVal + 3;                      
    return RetVal;
  end function SizeOf;

  

  function SizeOf(Var : NiDmaOutputReadInfo_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + Var.Address'length;     
    RetVal := RetVal + Var.ByteCount'length;   
    RetVal := RetVal + Var.Baggage'length;     
    RetVal := RetVal + 3;                      
    return RetVal;
  end function SizeOf;

  

  function SizeOf(Var : NiDmaInputAlignmentInfo_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + Var.ByteLane'length;    
    RetVal := RetVal + Var.ByteCount'length;   
    RetVal := RetVal + 1;                      
    RetVal := RetVal + 1;                      
    RetVal := RetVal + 1;                      
    RetVal := RetVal + 1;                      
    return RetVal;
  end function SizeOf;

  

  function SizeOf(Var : NiDmaOutputAlignmentInfo_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + Var.ByteLane'length;            
    RetVal := RetVal + Var.ByteCount'length;           
    RetVal := RetVal + 1;                              
    RetVal := RetVal + 1;                              
    RetVal := RetVal + 1;                              
    RetVal := RetVal + Var.FirstWordByteCount'length;  
    RetVal := RetVal + Var.FirstWordReadCount'length;  
    return RetVal;
  end function SizeOf;

  

  function SizeOf(Var : NiDmaInputStatusInfo_t) return integer is
    variable RetVal : integer := 0;
  begin
    RetVal := RetVal + Var.ByteCount'length;   
    RetVal := RetVal + 1;                      
    return RetVal;
  end function SizeOf;

  

  function InputDataWords(ByteCount : NiDmaInputByteCount_t;
               StartingLane : NiDmaByteLane_t) return NiDmaInputWordCount_t is
    variable ExtraWords, ReturnVal : NiDmaInputWordCount_t;
  begin
    assert ReturnVal'length = (ByteCount'length - StartingLane'length)
      report "vector size mismatch"
      severity FAILURE;
    
    
    assert ReturnVal'length >= 3
      report "NiDmaInputWordCount_t vector size too small"
      severity FAILURE;
    
    ReturnVal := ByteCount(ByteCount'high downto StartingLane'length);
    
    if (resize(ByteCount(StartingLane'range), Log2(kNiDmaDataWidthInBytes) + 1) +
        resize(StartingLane, Log2(kNiDmaDataWidthInBytes) + 1)) >
        kNiDmaDataWidthInBytes then
      ExtraWords := to_unsigned(2, ExtraWords'length);
    elsif (ByteCount(StartingLane'range) /= 0) or
          ((ByteCount(ByteCount'high downto StartingLane'length) /= 0) and
           (StartingLane /= 0)) then
      ExtraWords := to_unsigned(1, ExtraWords'length);
    else
      ExtraWords := to_unsigned(0, ExtraWords'length);
    end if;
    
    ReturnVal := ReturnVal + ExtraWords;
    return ReturnVal;
  end function InputDataWords;

  function ExtraDataWords(ByteCount : NiDmaInputByteCount_t;
               StartingLane : NiDmaByteLane_t) return NiDmaInputWordCount_t is
    variable ExtraWords, ReturnVal : NiDmaInputWordCount_t;
  begin
    assert ReturnVal'length = (ByteCount'length - StartingLane'length)
      report "vector size mismatch"
      severity FAILURE;
    
    
    assert ReturnVal'length >= 3
      report "NiDmaInputWordCount_t vector size too small"
      severity FAILURE;
    
    ReturnVal := ByteCount(ByteCount'high downto StartingLane'length);
    
    if (resize(ByteCount(StartingLane'range), Log2(kNiDmaDataWidthInBytes) + 1) +
        resize(StartingLane, Log2(kNiDmaDataWidthInBytes) + 1)) >
        kNiDmaDataWidthInBytes then
      ExtraWords := to_unsigned(2, ExtraWords'length);
    elsif (ByteCount(StartingLane'range) /= 0) or
          ((ByteCount(ByteCount'high downto StartingLane'length) /= 0) and
           (StartingLane /= 0)) then
      ExtraWords := to_unsigned(1, ExtraWords'length);
    else
      ExtraWords := to_unsigned(0, ExtraWords'length);
    end if;
    
    if ReturnVal /= 0 then
      ReturnVal := ExtraWords;
    else
      ReturnVal := ExtraWords - 1;
    end if;
    return ReturnVal;
  end function ExtraDataWords;
  
  function OutputDataWords(ByteCount : NiDmaOutputByteCount_t;
               StartingLane : NiDmaByteLane_t) return NiDmaOutputWordCount_t is
    variable ExtraWords, ReturnVal : NiDmaOutputWordCount_t;
  begin
    assert ReturnVal'length = (ByteCount'length - StartingLane'length)
      report "vector size mismatch"
      severity FAILURE;
    
    
    assert ReturnVal'length >= 3
      report "NiDmaOutputWordCount_t vector size too small"
      severity FAILURE;
    
    ReturnVal := ByteCount(ByteCount'high downto StartingLane'length);
    
    if (resize(ByteCount(StartingLane'range), Log2(kNiDmaDataWidthInBytes) + 1) +
        resize(StartingLane, Log2(kNiDmaDataWidthInBytes) + 1)) >
        kNiDmaDataWidthInBytes then
      ExtraWords := to_unsigned(2, ExtraWords'length);
    elsif (ByteCount(StartingLane'range) /= 0) or
          ((ByteCount(ByteCount'high downto StartingLane'length) /= 0) and
           (StartingLane /= 0)) then
      ExtraWords := to_unsigned(1, ExtraWords'length);
    else
      ExtraWords := to_unsigned(0, ExtraWords'length);
    end if;
    
    ReturnVal := ReturnVal + ExtraWords;
    return ReturnVal;
  end function OutputDataWords;

  function GetDmaChannelOneHot(Space : NiDmaSpace_t;
              Channel : NiDmaGeneralChannel_t) return NiDmaDmaChannelOneHot_t is
    variable ReturnVal : NiDmaDmaChannelOneHot_t;
  begin
    for i in ReturnVal'range loop
      ReturnVal(i) := ((Space = kNiDmaSpaceStream) and
                       (Channel(NiDmaDmaChannel_t'range) = i));
    end loop;
    return ReturnVal;
  end function GetDmaChannelOneHot;

  function GetDirectChannelOneHot(Space : NiDmaSpace_t;
           Channel : NiDmaGeneralChannel_t) return NiDmaDirectChannelOneHot_t is
    variable ReturnVal : NiDmaDirectChannelOneHot_t;
  begin
    for i in ReturnVal'range loop
      ReturnVal(i) := ((Space /= kNiDmaSpaceStream) and
                       (Channel(NiDmaDirectChannel_t'range) = i));
    end loop;
    return ReturnVal;
  end function GetDirectChannelOneHot;

  function GetByteEnables(StartingLane : NiDmaByteLane_t;
                          ByteCount : unsigned) return NiDmaByteEnable_t is
    variable ReturnVal : NiDmaByteEnable_t;
  begin
    assert ByteCount'length > StartingLane'length
      report "vector size mismatch"
      severity FAILURE;
    for i in ReturnVal'range loop
                      
      ReturnVal(i) := (StartingLane <= i) and
          
          ((ByteCount(ByteCount'high downto StartingLane'length) /= 0) or
           
           ((resize(StartingLane, Log2(kNiDmaDataWidthInBytes) + 1) +
             resize(ByteCount(StartingLane'range), Log2(kNiDmaDataWidthInBytes) + 1))
            > i));
    end loop;
    return ReturnVal;
  end function GetByteEnables;

  function GetWordByteCount(StartingLane : NiDmaByteLane_t;
                            ByteCount : unsigned) return NiDmaBusByteCount_t is
    variable ReturnVal : NiDmaBusByteCount_t;
  begin
    assert ByteCount'length > StartingLane'length
      report "vector size mismatch"
      severity FAILURE;
    if ByteCount(ByteCount'high downto StartingLane'length) /= 0 or
       (resize(StartingLane, ReturnVal'length) +
        resize(ByteCount(StartingLane'range), ReturnVal'length)) >=
       kNiDmaDataWidthInBytes then
      ReturnVal := to_unsigned(kNiDmaDataWidthInBytes - to_integer(StartingLane),
                               ReturnVal'length);
    else
      ReturnVal := resize(ByteCount, ReturnVal'length);
    end if;
    return ReturnVal;
  end function GetWordByteCount;

  

end PkgNiDma;