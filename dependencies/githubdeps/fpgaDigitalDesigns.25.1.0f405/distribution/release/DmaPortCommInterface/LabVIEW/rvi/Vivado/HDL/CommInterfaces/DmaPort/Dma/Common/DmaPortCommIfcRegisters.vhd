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

  
  
  use work.PkgDmaPortCommIfcRegs.all;

  
  
  use work.PkgCommunicationInterface.all;
  use work.PkgDmaPortCommunicationInterface.all;

  use work.PkgDmaPortCommIfcStreamStates.all;

  use work.PkgNiDma.all;

entity DmaPortCommIfcRegisters is
  generic (
    kBaseOffset : natural := 16#50#;
    kInputStream : boolean := false;
    kPeerToPeerStream : boolean := false;
    kMaxTransfer: natural
  );
  port (

    
    
    aReset         : in  boolean;

    
    
    bReset         : in  boolean;

    
    BusClk         : in  std_logic;


    
    
    

    
    
    bRegPortIn     : in  RegPortIn_t;

    
    
    
    
    bRegPortOut    : out RegPortOut_t;


    
    
    

    
    
    bHostEnable    : out boolean;

    
    
    bHostDisable   : out boolean;

    
    
    bHostFlush     : out boolean;

    
    
    
    
    bDisabled      : in  boolean;

    
    
    
    
    
    
    bDmaReset      : out boolean;

    
    
    
    bResetDone     : in  boolean;

    
    
    bFifoOverflow  : in  boolean;

    
    
    bFifoUnderflow : in boolean;

    
    
    bStartChannelRequest : in boolean;

    
    
    bStopChannelRequest : in boolean;

    
    
    
    bFlushIrqStrobe : in boolean;

    
    
    bClearEnableIrq : in boolean;

    
    
    bClearDisableIrq : in boolean;

    
    
    bClearFlushingIrq : in boolean;

    
    
    bSetFlushingStatus    : in boolean;

    
    
    bClearFlushingStatus    : in boolean;

    
    
    bSetFlushingFailedStatus    : in boolean;

    
    
    bClearFlushingFailedStatus    : in boolean;

    
    
    
    bSatcrWriteEvent : out boolean;

    
    
    bClearSatcr : in boolean;

    
    
    
    bStreamError    : in boolean;


    
    
    

    
    
    
    bMaxPktSize        : out unsigned(Log2(kMaxTransfer) downto 0);

    
    
    bSatcrWriteStrobe  : in boolean;

    
    
    bReqWriteSpaces    : in unsigned(Log2(kMaxTransfer) downto 0);


    
    
    

    
    
    bFifoCount         : in unsigned;

    
    
    
    bPeerAddress       : out NiDmaAddress_t;

    
    bState             : in StreamStateValue_t;

    
    
    bLinked            : out boolean;

    
    
    
    bSatcrUpdatesEnabled : out boolean;

    
    
    

    
    
    bIrq               : out IrqStatusToInterface_t

  );
end DmaPortCommIfcRegisters;

architecture behavior of DmaPortCommIfcRegisters is

  constant kSinkStream : boolean := (not kInputStream) and kPeerToPeerStream;
  constant kSourceStream : boolean := kInputStream and kPeerToPeerStream;

  
  
  signal bDmaResetReg : boolean;

  signal bInterruptStatusReg : InterfaceData_t;

  
  
  
  signal bSatcr : unsigned(31 downto 0);

  signal bSatcrResetNx : boolean;
  signal bSatcrReset : boolean;

  signal bStatusDecode, bSatcrDecode, bControlDecode, bFifoCountDecode,
         bInterruptStatusDecode, bInterruptMaskDecode,
         bPeerAddressHighDecode, bPeerAddressLowDecode, bPacketAlignmentDecode,
         bMaxPayloadSizeDecode : boolean;
         
  signal bStatusDecodeNx, bSatcrDecodeNx, bControlDecodeNx, bFifoCountDecodeNx,
         bInterruptStatusDecodeNx, bInterruptMaskDecodeNx,
         bPeerAddressHighDecodeNx, bPeerAddressLowDecodeNx, bPacketAlignmentDecodeNx,
         bMaxPayloadSizeDecodeNx : boolean;

  signal bMaskRegReadValue : InterfaceData_t;

  signal bPeerAddressReg : NiDmaAddress_t;

  signal bOverflowStatusReg, bUnderflowStatusReg : boolean;

  signal bSatcrUpdatesEnabledReg : boolean := BitFieldInitValue(SatcrUpdateStatus);
  signal bFlushingStatus : boolean := BitFieldInitValue(FlushingStatus);
  signal bFlushingFailedStatus : boolean := BitFieldInitValue(FlushingFailedStatus);
  signal bStreamErrorStatusReg : boolean := BitFieldInitValue(StreamErrorStatus);
  signal bEnableAlignment : boolean := BitFieldInitValue(EnableAlignment);
  signal bMaxPayloadSize : unsigned(bMaxPktSize'range)
    := to_unsigned(kMaxTransfer, bMaxPktSize'length);
  signal bSatcrWriteEventLcl: std_logic;
  signal bBytesToAlignment : unsigned(Log2(kMaxTransfer) downto 0) :=
    to_unsigned(kMaxTransfer, Log2(kMaxTransfer)+1);
    
  signal bDisabledReg : boolean;

begin

  
  
  
  
  
  
  bDmaReset <= bDmaResetReg and bDisabledReg;
  
  process (aReset, BusClk)
  begin
    if aReset then
      bDisabledReg <= false;
    elsif rising_edge(BusClk) then
      bDisabledReg <= bDisabled;
    end if;
  end process;


  
  
  
  InterruptRegister: block is

    
    signal bOverflowStatus, bOverflowStatusNx : boolean;
    signal bUnderflowStatus, bUnderflowStatusNx : boolean;
    signal bStartStreamStatus, bStartStreamStatusNx : boolean;
    signal bStopStreamStatus, bStopStreamStatusNx : boolean;
    signal bFlushingStatus, bFlushingStatusNx : boolean;
    signal bStreamErrorStatus, bStreamErrorStatusNx : boolean;

    
    signal bOverflowMask, bOverflowMaskNx : boolean;
    signal bUnderflowMask, bUnderflowMaskNx : boolean;
    signal bStartStreamMask, bStartStreamMaskNx : boolean;
    signal bStopStreamMask, bStopStreamMaskNx : boolean;
    signal bFlushingMask, bFlushingMaskNx : boolean;
    signal bStreamErrorMask, bStreamErrorMaskNx : boolean;

    signal bIrqNx : IrqStatusToInterface_t;

  begin

    WriteInterruptRegs: process(aReset, BusClk)
    begin
      if aReset then

        
        bOverflowStatus <= BitFieldInitValue(OverflowIrq);
        bUnderflowStatus <= BitFieldInitValue(UnderflowIrq);
        bStartStreamStatus <= BitFieldInitValue(StartStreamIrq);
        bStopStreamStatus <= BitFieldInitValue(StopStreamIrq);
        bFlushingStatus <= BitFieldInitValue(FlushingIrq);
        bStreamErrorStatus <= BitFieldInitValue(StreamErrorIrq);

        
        bOverflowMask <= false;
        bUnderflowMask <= false;
        bStartStreamMask <= false;
        bStopStreamMask <= false;
        bFlushingMask <= false;
        bStreamErrorMask <= false;

        bIrq <= kIrqStatusToInterfaceZero;

      elsif rising_edge(BusClk) then

        
        
        if bReset then
          bOverflowStatus <= BitFieldInitValue(OverflowIrq);
          bUnderflowStatus <= BitFieldInitValue(UnderflowIrq);
          bStartStreamStatus <= BitFieldInitValue(StartStreamIrq);
          bStopStreamStatus <= BitFieldInitValue(StopStreamIrq);
          bFlushingStatus <= BitFieldInitValue(FlushingIrq);
          bStreamErrorStatus <= BitFieldInitValue(StreamErrorIrq);
          bOverflowMask <= false;
          bUnderflowMask <= false;
          bStartStreamMask <= false;
          bStopStreamMask <= false;
          bFlushingMask <= false;
          bStreamErrorMask <= false;
          bIrq <= kIrqStatusToInterfaceZero;
        else
          bOverflowStatus <= bOverflowStatusNx;
          bUnderflowStatus <= bUnderflowStatusNx;
          bStartStreamStatus <= bStartStreamStatusNx;
          bStopStreamStatus <= bStopStreamStatusNx;
          bFlushingStatus <= bFlushingStatusNx;
          bStreamErrorStatus <= bStreamErrorStatusNx;
          bOverflowMask <= bOverflowMaskNx;
          bUnderflowMask <= bUnderflowMaskNx;
          bStartStreamMask <= bStartStreamMaskNx;
          bStopStreamMask <= bStopStreamMaskNx;
          bFlushingMask <= bFlushingMaskNx;
          bStreamErrorMask <= bStreamErrorMaskNx;
          bIrq <= bIrqNx;
        end if;

      end if;
    end process WriteInterruptRegs;

    
    WriteInterruptRegsNx: process(bRegPortIn, bStartChannelRequest, bStopChannelRequest,
                         bFlushIrqStrobe, bOverflowStatus, bUnderflowStatus,
                         bStartStreamStatus, bStopStreamStatus, bFlushingStatus,
                         bOverflowMask, bUnderflowMask, bStartStreamMask,
                         bStopStreamMask, bFlushingMask, bDmaResetReg,
                         bInterruptStatusDecode, bFifoOverflow, bFifoUnderflow,
                         bInterruptMaskDecode, bStreamErrorMask, bStreamErrorStatus,
                         bStreamError, bClearEnableIrq, bClearDisableIrq,
                         bClearFlushingIrq)
    begin

      bOverflowStatusNx <= bOverflowStatus;
      bUnderflowStatusNx <= bUnderflowStatus;
      bStartStreamStatusNx <= bStartStreamStatus;
      bStopStreamStatusNx <= bStopStreamStatus;
      bFlushingStatusNx <= bFlushingStatus;
      bStreamErrorStatusNx <= bStreamErrorStatus;

      bOverflowMaskNx <= bOverflowMask;
      bUnderflowMaskNx <= bUnderflowMask;
      bStartStreamMaskNx <= bStartStreamMask;
      bStopStreamMaskNx <= bStopStreamMask;
      bFlushingMaskNx <= bFlushingMask;
      bStreamErrorMaskNx <= bStreamErrorMask;

      bIrqNx.Clear <= '0';

      
      if bDmaResetReg then

        bOverflowStatusNx <= BitFieldInitValue(OverflowIrq);
        bUnderflowStatusNx <= BitFieldInitValue(UnderflowIrq);
        bStartStreamStatusNx <= BitFieldInitValue(StartStreamIrq);
        bStopStreamStatusNx <= BitFieldInitValue(StopStreamIrq);
        bFlushingStatusNx <= BitFieldInitValue(FlushingIrq);
        bStreamErrorStatusNx <= BitFieldInitValue(StreamErrorIrq);

        bOverflowMaskNx <= false;
        bUnderflowMaskNx <= false;
        bStartStreamMaskNx <= false;
        bStopStreamMaskNx <= false;
        bFlushingMaskNx <= false;
        bStreamErrorMaskNx <= false;

        bIrqNx.Clear <= '0';

      else

        
        if bRegPortIn.Wt and bInterruptStatusDecode then

          
          
          bIrqNx.Clear <= '1';

          if(bRegPortIn.Data(BitFieldIndex(OverflowIrq)) = '1') then
            bOverflowStatusNx <= false;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(UnderflowIrq)) = '1') then
            bUnderflowStatusNx <= false;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(StartStreamIrq)) = '1') then
            bStartStreamStatusNx <= false;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(StopStreamIrq)) = '1') then
            bStopStreamStatusNx <= false;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(FlushingIrq)) = '1') then
            bFlushingStatusNx <= false;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(StreamErrorIrq)) = '1') then
            bStreamErrorStatusNx <= false;
          end if;

        end if;


        
        
        
        if bFifoOverflow then
          bOverflowStatusNx <= true;
        end if;
        if bFifoUnderflow then
          bUnderflowStatusNx <= true;
        end if;
        if bStartChannelRequest then
          bStartStreamStatusNx <= true;
        end if;
        if bStopChannelRequest then
          bStopStreamStatusNx <= true;
        end if;
        if bFlushIrqStrobe then
          bFlushingStatusNx <= true;
        end if;
        if bStreamError then
          bStreamErrorStatusNx <= true;
        end if;

        
        
        
        if bClearEnableIrq then
          bStartStreamStatusNx <= false;
        end if;
        if bClearDisableIrq then
          bStopStreamStatusNx <= false;
        end if;
        if bClearFlushingIrq then
          bFlushingStatusNx <= false;
        end if;


        
        if bRegPortIn.Wt and bInterruptMaskDecode then

          if(bRegPortIn.Data(BitFieldIndex(EnableOverflowIrq)) = '1') then
            bOverflowMaskNx <= true;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(EnableUnderflowIrq)) = '1') then
            bUnderflowMaskNx <= true;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(EnableStartStreamIrq)) = '1') then
            bStartStreamMaskNx <= true;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(EnableStopStreamIrq)) = '1') then
            bStopStreamMaskNx <= true;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(EnableFlushingIrq)) = '1') then
            bFlushingMaskNx <= true;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(EnableStreamErrorIrq)) = '1') then
            bStreamErrorMaskNx <= true;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(DisableOverflowIrq)) = '1') then
            bOverflowMaskNx <= false;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(DisableUnderflowIrq)) = '1') then
            bUnderflowMaskNx <= false;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(DisableStartStreamIrq)) = '1') then
            bStartStreamMaskNx <= false;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(DisableStopStreamIrq)) = '1') then
            bStopStreamMaskNx <= false;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(DisableFlushingIrq)) = '1') then
            bFlushingMaskNx <= false;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(DisableStreamErrorIrq)) = '1') then
            bStreamErrorMaskNx <= false;
          end if;

        end if;

      end if;
    end process WriteInterruptRegsNx;

    
    SetInterruptStatusValue: process(bOverflowStatus, bUnderflowStatus,
                                     bStartStreamStatus, bStopStreamStatus,
                                     bFlushingStatus, bStreamErrorStatus, bOverflowMask,
                                     bUnderflowMask, bStartStreamMask, bStopStreamMask,
                                     bFlushingMask, bStreamErrorMask)
    begin
      bInterruptStatusReg <= (others=>'0');
      bInterruptStatusReg(BitFieldIndex(OverflowIrq)) <=
        to_StdLogic(bOverflowStatus and bOverflowMask);
      bInterruptStatusReg(BitFieldIndex(UnderflowIrq)) <=
        to_StdLogic(bUnderflowStatus and bUnderflowMask);
      bInterruptStatusReg(BitFieldIndex(StartStreamIrq)) <=
        to_StdLogic(bStartStreamStatus and bStartStreamMask);
      bInterruptStatusReg(BitFieldIndex(StopStreamIrq)) <=
        to_StdLogic(bStopStreamStatus and bStopStreamMask);
      bInterruptStatusReg(BitFieldIndex(FlushingIrq)) <=
        to_StdLogic(bFlushingStatus and bFlushingMask);
      bInterruptStatusReg(BitFieldIndex(StreamErrorIrq)) <=
        to_StdLogic(bStreamErrorStatus and bStreamErrorMask);
    end process SetInterruptStatusValue;

    
    bIrqNx.Status <= to_StdLogic((bOverflowStatus and bOverflowMask) or
                                 (bUnderflowStatus and bUnderflowMask) or
                                 (bStartStreamStatus and bStartStreamMask) or
                                 (bStopStreamStatus and bStopStreamMask) or
                                 (bFlushingStatus and bFlushingMask) or
                                 (bStreamErrorStatus and bStreamErrorMask));


    
    SetMaskRegReadValue: process(bOverflowMask, bUnderflowMask, bStartStreamMask,
                                 bStopStreamMask, bFlushingMask, bStreamErrorMask)
    begin
      bMaskRegReadValue <= (others=>'0');
      bMaskRegReadValue(BitFieldIndex(OverflowIrqMaskStatus)) <=
        to_StdLogic(bOverflowMask);
      bMaskRegReadValue(BitFieldIndex(UnderflowIrqMaskStatus)) <=
        to_StdLogic(bUnderflowMask);
      bMaskRegReadValue(BitFieldIndex(StartStreamIrqMaskStatus)) <=
        to_StdLogic(bStartStreamMask);
      bMaskRegReadValue(BitFieldIndex(StopStreamIrqMaskStatus)) <=
        to_StdLogic(bStopStreamMask);
      bMaskRegReadValue(BitFieldIndex(FlushingIrqMaskStatus)) <=
        to_StdLogic(bFlushingMask);
      bMaskRegReadValue(BitFieldIndex(StreamErrorIrqMaskStatus)) <=
        to_StdLogic(bStreamErrorMask);
    end process SetMaskRegReadValue;

  end block InterruptRegister;



  
  
  
  ControlStatusRegister: block is

    signal bDmaResetRegNx : boolean;
    signal bLinkedReg, bLinkedRegNx : boolean;
    signal bHostEnableReg, bHostEnableRegNx : boolean;
    signal bHostDisableReg, bHostDisableRegNx : boolean;
    signal bHostFlushReg, bHostFlushRegNx : boolean;
    signal bOverflowStatusRegNx, bUnderflowStatusRegNx : boolean;
    signal bSatcrUpdatesEnabledRegNx : boolean;
    signal bFlushingStatusNx, bFlushingFailedStatusNx : boolean;
    signal bStreamErrorStatusRegNx : boolean;

  begin

    bLinked <= bLinkedReg;
    bHostEnable <= bHostEnableReg;
    bHostDisable <= bHostDisableReg;
    bHostFlush <= bHostFlushReg;
    bSatcrUpdatesEnabled <= bSatcrUpdatesEnabledReg;

    ControlStatusWriteRegs: process(aReset, BusClk)
    begin
      if aReset then

        
        bDmaResetReg <= BitFieldInitValue(ResetStatus);
        bLinkedReg <= false;
        bHostEnableReg <= false;
        bHostDisableReg <= false;
        bHostFlushReg <= false;
        bOverflowStatusReg <= false;
        bUnderflowStatusReg <= false;
        bSatcrUpdatesEnabledReg <= BitFieldInitValue(SatcrUpdateStatus);
        bFlushingStatus <= BitFieldInitValue(FlushingStatus);
        bFlushingFailedStatus <= BitFieldInitValue(FlushingFailedStatus);
        bStreamErrorStatusReg <= BitFieldInitValue(StreamErrorStatus);

      elsif rising_edge(BusClk) then

        
        
        if bReset then
          bDmaResetReg <= BitFieldInitValue(ResetStatus);
          bLinkedReg <= false;
          bHostEnableReg <= false;
          bHostDisableReg <= false;
          bHostFlushReg <= false;
          bOverflowStatusReg <= false;
          bUnderflowStatusReg <= false;
          bSatcrUpdatesEnabledReg <= BitFieldInitValue(SatcrUpdateStatus);
          bFlushingStatus <= BitFieldInitValue(FlushingStatus);
          bFlushingFailedStatus <= BitFieldInitValue(FlushingFailedStatus);
          bStreamErrorStatusReg <= BitFieldInitValue(StreamErrorStatus);
        else
          bDmaResetReg <= bDmaResetRegNx;
          bLinkedReg <= bLinkedRegNx;
          bHostEnableReg <= bHostEnableRegNx;
          bHostDisableReg <= bHostDisableRegNx;
          bHostFlushReg <= bHostFlushRegNx;
          bOverflowStatusReg <= bOverflowStatusRegNx;
          bUnderflowStatusReg <= bUnderflowStatusRegNx;
          bSatcrUpdatesEnabledReg <= bSatcrUpdatesEnabledRegNx;
          bFlushingStatus <= bFlushingStatusNx;
          bFlushingFailedStatus <= bFlushingFailedStatusNx;
          bStreamErrorStatusReg <= bStreamErrorStatusRegNx;
        end if;

      end if;
    end process ControlStatusWriteRegs;

    
    ControlStatusWriteRegsNx: process(bDmaResetReg, bResetDone, bDisabled,
                                      bFifoOverflow, bFifoUnderflow, bRegPortIn,
                                      bControlDecode, bReqWriteSpaces, bLinkedReg,
                                      bOverflowStatusReg, bUnderflowStatusReg,
                                      bSatcrUpdatesEnabledReg, bClearFlushingStatus,
                                      bSetFlushingStatus, bClearFlushingFailedStatus,
                                      bSetFlushingFailedStatus, bFlushingStatus,
                                      bFlushingFailedStatus, bStreamError,
                                      bStreamErrorStatusReg)
    begin

      bDmaResetRegNx <= bDmaResetReg;
      bSatcrResetNx <= false;
      bLinkedRegNx <= bLinkedReg;
      bOverflowStatusRegNx <= bOverflowStatusReg;
      bUnderflowStatusRegNx <= bUnderflowStatusReg;
      bSatcrUpdatesEnabledRegNx <= bSatcrUpdatesEnabledReg;
      bFlushingStatusNx <= bFlushingStatus;
      bFlushingFailedStatusNx <= bFlushingFailedStatus;
      bStreamErrorStatusRegNx <= bStreamErrorStatusReg;

      
      
      bHostEnableRegNx <= false;
      bHostDisableRegNx <= false;
      bHostFlushRegNx <= false;

      
      if bResetDone then
        bDmaResetRegNx <= false;
      end if;

      
      
      
      if bDmaResetReg then

        bLinkedRegNx <= false;
        bSatcrResetNx <= true;
        bOverflowStatusRegNx <= false;
        bUnderflowStatusRegNx <= false;
        bSatcrUpdatesEnabledRegNx <= BitFieldInitValue(SatcrUpdateStatus);
        bStreamErrorStatusRegNx <= BitFieldInitValue(StreamErrorStatus);

      else

        
        if bRegPortIn.Wt and bControlDecode then

          
          
          
          
          if bRegPortIn.Data(BitFieldIndex(StopChannel)) = '1' then
            bHostDisableRegNx <= true;
          elsif bRegPortIn.Data(BitFieldIndex(StopChannelWithFlush)) = '1' then
            bHostFlushRegNx <= true;
          elsif bRegPortIn.Data(BitFieldIndex(StartChannel)) = '1' then
            bHostEnableRegNx <= true;

            
            
            bLinkedRegNx <= true;

          end if;

          
          if(bRegPortIn.Data(BitFieldIndex(Reset)) = '1') then
            bDmaResetRegNx <= true;
          end if;

          
          
          if(bRegPortIn.Data(BitFieldIndex(ResetSatcr)) = '1' and bDisabled) then
            bSatcrResetNx <= true;
          end if;

          
          if(bRegPortIn.Data(BitFieldIndex(UnlinkStream)) = '1') then
            bLinkedRegNx <= false;
          elsif(bRegPortIn.Data(BitFieldIndex(LinkStream)) = '1') then
            bLinkedRegNx <= true;
          end if;

          
          
          if(bRegPortIn.Data(BitFieldIndex(ClearOverflowStatus)) = '1') then
            bOverflowStatusRegNx <= false;
          end if;
          if(bRegPortIn.Data(BitFieldIndex(ClearUnderflowStatus)) = '1') then
            bUnderflowStatusRegNx <= false;
          end if;

          
          
          if bRegPortIn.Data(BitFieldIndex(ClearFlushingStatus)) = '1' then
            bFlushingStatusNx <= false;
          end if;
          if bRegPortIn.Data(BitFieldIndex(ClearFlushingFailedStatus)) = '1' then
            bFlushingFailedStatusNx <= false;
          end if;

          
          
          
          
          
          if kSinkStream or not kPeerToPeerStream then
            if(bRegPortIn.Data(BitFieldIndex(EnableSatcrUpdates)) = '1') then
              bSatcrUpdatesEnabledRegNx <= true;
            end if;
            if(bRegPortIn.Data(BitFieldIndex(DisableSatcrUpdates)) = '1') then
              bSatcrUpdatesEnabledRegNx <= false;
            end if;
          end if;

          if bRegPortIn.Data(BitFieldIndex(ClearStreamErrorStatus)) = '1' then
            bStreamErrorStatusRegNx <= false;
          end if;

        end if;

        
        
        if bFifoOverflow then
          bOverflowStatusRegNx <= true;
        end if;
        if bFifoUnderflow then
          bUnderflowStatusRegNx <= true;
        end if;

        
        if bClearFlushingStatus then
          bFlushingStatusNx <= false;
        elsif bSetFlushingStatus then
          bFlushingStatusNx <= true;
        end if;

        if bClearFlushingFailedStatus then
          bFlushingFailedStatusNx <= false;
        elsif bSetFlushingFailedStatus then
          bFlushingFailedStatusNx <= true;
        end if;

        if bStreamError then
          bStreamErrorStatusRegNx <= true;
        end if;

      end if;

    end process ControlStatusWriteRegsNx;

  end block ControlStatusRegister;
  
  
  
  
  SatcrResetReg : process(aReset, BusClk)
  begin
    if aReset then
      bSatcrReset <= false;
    elsif rising_edge(BusClk) then
      bSatcrReset <= bSatcrResetNx;
    end if;
  end process SatcrResetReg;


  
  
  
  SinkStreamRegs: if kSinkStream generate

    signal bPeerAddressRegNx : NiDmaAddress_t;

  begin

    WritePeerRegs: process(aReset, BusClk)
    begin
      if aReset then
        
        bPeerAddressReg <= (others => '0');
      elsif rising_edge(BusClk) then
        
        
        if bReset then
          bPeerAddressReg <= (others => '0');
        else
          bPeerAddressReg <= bPeerAddressRegNx;
        end if;
      end if;
    end process WritePeerRegs;

    
    WritePeerRegsNx: process(bPeerAddressReg, bDmaResetReg, bRegPortIn, bPeerAddressRegNx,
                             bPeerAddressHighDecode, bPeerAddressLowDecode)
    begin

      bPeerAddressRegNx <= bPeerAddressReg;

      
      
      
      if bDmaResetReg then

        bPeerAddressRegNx <= (others=>'0');

      else

        
        if bRegPortIn.Wt and bPeerAddressLowDecode then
          bPeerAddressRegNx(Smaller(bRegPortIn.Data'left, bPeerAddressRegNx'left) downto 0) <= 
            unsigned(bRegPortIn.Data(Smaller(bRegPortIn.Data'left, bPeerAddressRegNx'left) downto 0));
        elsif bRegPortIn.Wt and bPeerAddressHighDecode then
          bPeerAddressRegNx <= resize(unsigned(bRegPortIn.Data) &
                               bPeerAddressReg(bRegPortIn.Data'left downto 0),
                               bPeerAddressRegNx'length);
        end if;

      end if;

    end process WritePeerRegsNx;

  end generate;

  NoSinkStreamRegs: if not kSinkStream generate
  begin

    bPeerAddressReg <= (others=>'0');

  end generate;

  bPeerAddress <= bPeerAddressReg;


  
  
  
  PacketAlignmentRegister: block is
    signal bEnableAlignmentNx : boolean;
  begin
  
    PacketAlignmentWriteRegs: process(aReset, BusClk)
    begin
      if aReset then
      
        
        bEnableAlignment <= BitFieldInitValue(EnableAlignment);
      elsif rising_edge(BusClk) then
      
        if bReset then
          bEnableAlignment <= BitFieldInitValue(EnableAlignment);
        else
          bEnableAlignment <= bEnableAlignmentNx;
        end if;
    
      end if;
    end process PacketAlignmentWriteRegs;

    
    PacketAlignmentWrite: process(bDmaResetReg, bEnableAlignment, bRegPortIn, 
      bPacketAlignmentDecode)
    begin
    
      bEnableAlignmentNx <= bEnableAlignment;

      if bDmaResetReg then

        bEnableAlignmentNx <= BitFieldInitValue(EnableAlignment);

      else

        
        if bRegPortIn.Wt and bPacketAlignmentDecode then
        
          bEnableAlignmentNx <= to_Boolean(bRegPortIn.Data(
            BitFieldIndex(EnableAlignment)));

        end if;

      end if;

    end process PacketAlignmentWrite;
  
  end block PacketAlignmentRegister;


  
  
  
  MaxPayloadSizeRegister: block is
    signal bMaxPayloadSizeNx : unsigned(bMaxPayloadSize'range);
  begin

    MaxPayloadSizeRegs: process(aReset, BusClk)
    begin
      if aReset then

        
        bMaxPayloadSize <= to_unsigned(kMaxTransfer, bMaxPayloadSize'length);

      elsif rising_edge(BusClk) then

        if bReset then
          bMaxPayloadSize <= to_unsigned(kMaxTransfer, bMaxPayloadSize'length);
        else
          bMaxPayloadSize <= bMaxPayloadSizeNx;
        end if;

      end if;
    end process MaxPayloadSizeRegs;

    
    SetMaxPayloadSize: process(bDmaResetReg, bMaxPayloadSize, bRegPortIn,
      bMaxPayloadSizeDecode)
    begin

      bMaxPayloadSizeNx <= bMaxPayloadSize;

      if bDmaResetReg then

        bMaxPayloadSizeNx <= to_unsigned(kMaxTransfer, bMaxPayloadSize'length);

      else
        
        if bRegPortIn.Wt and bMaxPayloadSizeDecode then

          bMaxPayloadSizeNx <= resize(unsigned(bRegPortIn.Data(
            BitFieldUpperIndex(MaxPayloadSize) downto BitFieldIndex(MaxPayloadSize))),
            bMaxPayloadSizeNx'length);

        end if;

      end if;

    end process SetMaxPayloadSize;

  end block MaxPayloadSizeRegister;


  
  
  
  SatcrRegister: if not kSinkStream generate

    signal bSatcrNx : unsigned(bSatcr'range);
    signal bSatcrRegWrite : boolean;

    
    
    
    signal bSatcrAddAmt, bSatcrAddAmtNx : unsigned (bSatcr'range);

    signal bBytesToAlignmentNx : unsigned(bBytesToAlignment'range) :=
      to_unsigned(kMaxTransfer, bBytesToAlignment'length);

    signal bMaxPktSizeNx : unsigned(bMaxPktSize'range);

  begin

    
    
    
    
    
    RegWriteStrobe: process(aReset, BusClk)
    begin
      if aReset then
        bSatcrRegWrite <= false;
      elsif rising_edge(BusClk) then
        if bReset then
          bSatcrRegWrite <= false;
        else
          if (bSatcrRegWrite and not bSatcrWriteStrobe) or bSatcrReset or bClearSatcr
          then
            bSatcrRegWrite <= false;
          elsif bRegPortIn.Wt and bSatcrDecode then
            bSatcrRegWrite <= true;
          else
            bSatcrRegWrite <= bSatcrRegWrite;
          end if;
        end if;
      end if;
    end process RegWriteStrobe;

    
    
    
    bRegPortOut.Ready <= not bSatcrRegWrite;

    bSatcrNx <= (others=>'0') when bSatcrReset or bClearSatcr else
                bSatcr - bReqWriteSpaces when bSatcrWriteStrobe else
                bSatcr + bSatcrAddAmt when bSatcrRegWrite else
                bSatcr;

    
    
    
    
    
    FindMaxPktSize: process(bSatcrUpdatesEnabledReg, bSatcr, bBytesToAlignment)
    begin
      if (not bSatcrUpdatesEnabledReg and not kPeerToPeerStream) or
        bSatcr >= bBytesToAlignment then
        bMaxPktSizeNx <= bBytesToAlignment;
      else
        bMaxPktSizeNx <= resize(bSatcr, bMaxPktSize'length);
      end if;
    end process FindMaxPktSize;

    
    FindBytesToAlignment: process(bSatcrWriteStrobe, bSatcrReset, bClearSatcr,
      bBytesToAlignment, bReqWriteSpaces, bDmaResetReg, bEnableAlignment,
      bMaxPayloadSize, bRegPortIn, bPacketAlignmentDecode)
    begin
      if bDmaResetReg then
        bBytesToAlignmentNx <= to_unsigned(kMaxTransfer, bBytesToAlignment'length);

      
      
      elsif bRegPortIn.Wt and bPacketAlignmentDecode then
        bBytesToAlignmentNx <= resize(unsigned(bRegPortIn.Data(
          BitFieldUpperIndex(NextBoundary) downto BitFieldIndex(NextBoundary))),
          bBytesToAlignment'length);

      elsif bSatcrWriteStrobe and not (bSatcrReset or bClearSatcr) then

        
        
        if not bEnableAlignment or bBytesToAlignment = bReqWriteSpaces then
          bBytesToAlignmentNx <= resize(bMaxPayloadSize, bBytesToAlignment'length);
        else
          bBytesToAlignmentNx <= bBytesToAlignment - bReqWriteSpaces;
        end if;

      elsif not bEnableAlignment then
        bBytesToAlignmentNx <= resize(bMaxPayloadSize, bBytesToAlignment'length);

      else
        bBytesToAlignmentNx <= bBytesToAlignment;
      end if;
    end process;

    SatcrWriteRegs: process(aReset, BusClk)
    begin
      if aReset then
        
        bSatcr <= (others => '0');
        bSatcrAddAmt <= (others => '0');
        bBytesToAlignment <= to_unsigned(kMaxTransfer, bBytesToAlignment'length);
      elsif rising_edge(BusClk) then
        if bReset then
          bSatcr <= (others => '0');
          bSatcrAddAmt <= (others => '0');
          bBytesToAlignment <= to_unsigned(kMaxTransfer, bBytesToAlignment'length);
        else
          bSatcr <= bSatcrNx;
          bSatcrAddAmt <= bSatcrAddAmtNx;
          bBytesToAlignment <= bBytesToAlignmentNx;
        end if;
      end if;
    end process SatcrWriteRegs;

    MaxPktSize: process(aReset, BusClk)
    begin
      if aReset then
        bMaxPktSize <= (others => '0');
      elsif rising_edge(BusClk) then
        if bReset or bSatcrReset or bClearSatcr then
          bMaxPktSize <= (others => '0');
        else
          bMaxPktSize <= bMaxPktSizeNx;
        end if;
      end if;
    end process MaxPktSize;

    
    SatcrWriteRegsNx: process(bDmaResetReg, bRegPortIn, bSatcrDecode, bSatcrAddAmt)
    begin

      bSatcrAddAmtNx <= bSatcrAddAmt;
      bSatcrWriteEventLcl <= '0';

        
        if bRegPortIn.Wt and bSatcrDecode then
          bSatcrAddAmtNx <= unsigned(bRegPortIn.Data);
          bSatcrWriteEventLcl <= '1';
        end if;

    end process SatcrWriteRegsNx;

  end generate SatcrRegister;

  
  
  
  NoSatcrRegister: if kSinkStream generate
  begin

    bRegPortOut.Ready <= true;
    bSatcr <= (others=>'0');
    bMaxPktSize <= to_unsigned(kMaxTransfer, bMaxPktSize'length);
    bSatcrWriteEventLcl <= '0';

  end generate NoSatcrRegister;

  bSatcrWriteEvent <= to_boolean(bSatcrWriteEventLcl);
  
  
  
  ReadRegisters: block is

    signal bDmaRegReadDecode : boolean;

  begin

    
    
    ReadDelay: process(BusClk, aReset)
    begin
      if aReset then
        bRegPortOut.DataValid <= false;
      elsif rising_edge(BusClk) then

        bRegPortOut.DataValid <= false;

        
        
        if bRegPortIn.Rd and bDmaRegReadDecode then
          bRegPortOut.DataValid <= true;
        end if;

      end if;
    end process ReadDelay;

    ReadRegs: process(BusClk, aReset)
      variable bRegDataOut : InterfaceData_t;
    begin

      
      
      
      if aReset then
        bRegPortOut.Data <= (others => '0');
      elsif rising_edge(BusClk) then

        bRegPortOut.Data <= (others => '0');

        if bRegPortIn.Rd then

          
          if bSatcrDecode then

            bRegPortOut.Data <= std_logic_vector(bSatcr);

          elsif bStatusDecode then

            
            
            
            
            
            

            bRegDataOut := (others=>'0');
            bRegDataOut(BitFieldIndex(UnderflowStatus)) :=
              to_StdLogic(bUnderflowStatusReg);
            bRegDataOut(BitFieldIndex(OverflowStatus)) :=
              to_StdLogic(bOverflowStatusReg);
            bRegDataOut(BitFieldIndex(DisableStatus)) :=
              to_StdLogic(bDisabled);
            bRegDataOut(BitFieldIndex(ResetStatus)) :=
              to_StdLogic(not bDmaResetReg);
            bRegDataOut(BitFieldUpperIndex(State) downto BitFieldIndex(State)) :=
              bState;
            bRegDataOut(BitFieldIndex(SatcrUpdateStatus)) :=
              to_StdLogic(bSatcrUpdatesEnabledReg);
            bRegDataOut(BitFieldIndex(FlushingStatus)) :=
              to_StdLogic(bFlushingStatus);
            bRegDataOut(BitFieldIndex(FlushingFailedStatus)) :=
              to_StdLogic(bFlushingFailedStatus);
            bRegDataOut(BitFieldIndex(StreamErrorStatus)) :=
              to_StdLogic(bStreamErrorStatusReg);

            bRegPortOut.Data <= bRegDataOut;

          elsif bInterruptStatusDecode then

            bRegPortOut.Data <= bInterruptStatusReg;

          elsif bInterruptMaskDecode then

            bRegPortOut.Data <= bMaskRegReadValue;

          elsif bFifoCountDecode then

            bRegPortOut.Data <= std_logic_vector(resize(bFifoCount,
                                bRegPortOut.Data'length));

          elsif kSinkStream and bPeerAddressHighDecode then

            bRegPortOut.Data <= std_logic_vector(resize(shift_right(bPeerAddressReg,
                                bRegPortOut.Data'length),bRegPortOut.Data'length));

          elsif kSinkStream and bPeerAddressLowDecode then

            bRegPortOut.Data <= std_logic_vector(resize(bPeerAddressReg,
                                bRegPortOut.Data'length));

          elsif bPacketAlignmentDecode then

            bRegDataOut := (others=>'0');
            bRegDataOut(BitFieldIndex(EnableAlignment)) :=
              to_StdLogic(bEnableAlignment);
            bRegDataOut(BitFieldUpperIndex(NextBoundary) downto
              BitFieldIndex(NextBoundary)) := std_logic_vector(resize(bBytesToAlignment,
              BitFieldSize(NextBoundary)));

            bRegPortOut.Data <= bRegDataOut;

          elsif bMaxPayloadSizeDecode then

            bRegDataOut := (others=>'0');
            bRegDataOut(BitFieldUpperIndex(MaxPayloadSize) downto
                BitFieldIndex(MaxPayloadSize)) := std_logic_vector(resize(bMaxPayloadSize, BitFieldSize(MaxPayloadSize)));


            bRegPortOut.Data <= bRegDataOut;

          end if;

        end if;

      end if;

    end process ReadRegs;

    
    bDmaRegReadDecode <= bSatcrDecode or bStatusDecode or bInterruptStatusDecode or
                         bInterruptMaskDecode or bFifoCountDecode or
                         (kSinkStream and (bPeerAddressLowDecode or
                         bPeerAddressHighDecode)) or bPacketAlignmentDecode or
                         bMaxPayloadSizeDecode;

  end block ReadRegisters;


  
  
  

  bSatcrDecodeNx <= bRegPortIn.Address & "00" = OffsetValue(Satcr) +
                  to_unsigned(kBaseOffset,bRegPortIn.Address'length+2);
  bStatusDecodeNx <= bRegPortIn.Address & "00" = OffsetValue(Status) +
                   to_unsigned(kBaseOffset,bRegPortIn.Address'length+2);
  bControlDecodeNx <= bRegPortIn.Address & "00" = OffsetValue(Control) +
                    to_unsigned(kBaseOffset,bRegPortIn.Address'length+2);
  bPeerAddressLowDecodeNx <= bRegPortIn.Address & "00" = OffsetValue(PeerAddressLow) +
                          to_unsigned(kBaseOffset,bRegPortIn.Address'length+2);
  bPeerAddressHighDecodeNx <= bRegPortIn.Address & "00" = OffsetValue(PeerAddressHigh) +
                            to_unsigned(kBaseOffset,bRegPortIn.Address'length+2);
  bInterruptStatusDecodeNx <= bRegPortIn.Address & "00" = OffsetValue(InterruptStatus) +
                            to_unsigned(kBaseOffset,bRegPortIn.Address'length+2);
  bInterruptMaskDecodeNx <= bRegPortIn.Address & "00" = OffsetValue(InterruptMask) +
                            to_unsigned(kBaseOffset,bRegPortIn.Address'length+2);
  bFifoCountDecodeNx <= bRegPortIn.Address & "00" = OffsetValue(FifoCount) +
                      to_unsigned(kBaseOffset,bRegPortIn.Address'length+2);
  bPacketAlignmentDecodeNx <= bRegPortIn.Address & "00" = OffsetValue(PacketAlignment) +
                            to_unsigned(kBaseOffset,bRegPortIn.Address'length+2);
  bMaxPayloadSizeDecodeNx <= bRegPortIn.Address & "00" = OffsetValue(TransferLimit) +
                           to_unsigned(kBaseOffset,bRegPortIn.Address'length+2);
                           
  process (aReset, BusClk)
  begin
    if aReset then
      bSatcrDecode <= false;
      bStatusDecode <= false;
      bControlDecode <= false;
      bPeerAddressLowDecode <= false; 
      bPeerAddressHighDecode <= false;
      bInterruptStatusDecode <= false;
      bInterruptMaskDecode <= false;
      bFifoCountDecode <= false;
      bPacketAlignmentDecode <= false;
      bMaxPayloadSizeDecode <= false;
    elsif rising_edge(BusClk) then
      bSatcrDecode <= bSatcrDecodeNx;
      bStatusDecode <= bStatusDecodeNx;
      bControlDecode <= bControlDecodeNx;
      bPeerAddressLowDecode <= bPeerAddressLowDecodeNx;
      bPeerAddressHighDecode <= bPeerAddressHighDecodeNx;
      bInterruptStatusDecode <= bInterruptStatusDecodeNx;
      bInterruptMaskDecode <= bInterruptMaskDecodeNx;
      bFifoCountDecode <= bFifoCountDecodeNx;
      bPacketAlignmentDecode <= bPacketAlignmentDecodeNx;
      bMaxPayloadSizeDecode <= bMaxPayloadSizeDecodeNx;
    end if;
  end process;

end behavior;