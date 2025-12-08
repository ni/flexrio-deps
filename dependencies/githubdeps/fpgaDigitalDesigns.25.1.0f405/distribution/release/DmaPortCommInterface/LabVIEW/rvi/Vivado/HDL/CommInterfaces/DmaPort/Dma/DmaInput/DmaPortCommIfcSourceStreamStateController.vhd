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

  
  
  use work.PkgDmaPortCommIfcStreamStates.all;  
  
  
  
  use work.PkgCommunicationInterface.all;
  use work.PkgDmaPortCommunicationInterface.all;
  
entity DmaPortCommIfcSourceStreamStateController is

  port (

    
    aReset         : in  boolean;
    
    
    bReset         : in  boolean;
    
    
    BusClk         : in  std_logic;
    
    
    
    
    
    
    bState                        : out StreamStateValue_t;
    
    
    
    bDisable                      : out boolean;
    
    
    
    
    
    
    bDisableController            : out boolean := true;
    
    
    
    
    bFlushIrqStrobe               : out boolean;
    
    
    
    bSetEnableIrq                 : out boolean;
    
    
    
    bClearEnableIrq               : out boolean;
    
    
    
    bClearFlushingIrq             : out boolean;
    
    
    
    bSetFlushingStatus            : out boolean;
    
    
    
    bClearFlushingStatus          : out boolean;
    
    
    
    bSetFlushingFailedStatus      : out boolean;
    
    
    
    bClearFlushingFailedStatus    : out boolean;
    
    
    
    
    
    
    
    bHostEnable                     : in boolean;
    
    
    
    bHostDisable                    : in boolean;
    
    
    
    bHostFlush                      : in boolean;
    
    
    
    bStartChannelRequest            : in boolean;
    
    
    
    bStopChannelRequest             : in boolean;
    
    
    
    bStopChannelWithFlushRequest    : in boolean;
    
    
    
    
    
    
    
    bDisabled           : in boolean;
    
    
    bLinked             : in boolean;
    
    
    
    bSatcrWriteEvent    : in boolean;
    
    
    bFifoFullCount      : in unsigned;
    
    
    
    
    
    
    
    bWritesDisabled     : in boolean;
    
    
    
    bStateInDefaultClkDomain    : in StreamStateValue_t

  );
end DmaPortCommIfcSourceStreamStateController;

architecture behavior of DmaPortCommIfcSourceStreamStateController is

  signal bStreamState, bStreamStateNx : StreamState_t;
  signal bEnableReg, bEnableRegNx : boolean;
  signal bEnableRequestReg, bEnableRequestRegNx : boolean;
  signal bFlushReg, bFlushRegNx : boolean;
  signal bFlushIrqStrobeNx : boolean;
  signal bResetFirstSatcrWriteTracker : boolean;
  signal bSatcrWriteReceived : boolean;
  signal bDisableControllerNx : boolean;
  signal bFifoEmpty : boolean;
  signal bSafeToDisableController, bSafeToEnableController : boolean;
  signal bOutstandingEnableIrq : boolean;

begin

  
  StreamStateRegs: process(aReset, BusClk)
  begin
    
    if aReset then
    
      
      bStreamState <= Unlinked;
      bState <= kStreamStateUnlinked;
      bEnableReg <= false;
      bEnableRequestReg <= false;
      bFlushReg <= false;
      bFlushIrqStrobe <= false;
      bDisableController <= true;
    
    elsif rising_edge(BusClk) then
    
      if bReset then
      
        
        bStreamState <= Unlinked;
        bState <= kStreamStateUnlinked;
        bEnableReg <= false;
        bEnableRequestReg <= false;
        bFlushReg <= false;
        bFlushIrqStrobe <= false;
        bDisableController <= true;
      
      else
      
        bStreamState <= bStreamStateNx;
        bEnableReg <= bEnableRegNx;
        bEnableRequestReg <= bEnableRequestRegNx;
        bFlushReg <= bFlushRegNx;
        bFlushIrqStrobe <= bFlushIrqStrobeNx;
        bDisableController <= bDisableControllerNx;
        bState <= to_StreamStateValue(bStreamStateNx);
        
      end if;
      
    end if;
    
  end process StreamStateRegs;


  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  


  
  
  
  
  
  NextStreamState: process(bStreamState, bLinked, bDisabled, bSatcrWriteReceived, 
                           bEnableRegNx, bOutstandingEnableIrq, bWritesDisabled,
                           bStateInDefaultClkDomain, bStartChannelRequest)
  begin
  
    bStreamStateNx <= bStreamState;
    bResetFirstSatcrWriteTracker <= false;
    bClearEnableIrq <= false;
    bClearFlushingIrq <= false;
    bSetEnableIrq <= false;
    bSafeToEnableController <= false;
    bSafeToDisableController <= false;
  
    case bStreamState is
    
      when Unlinked =>
        
        
        if bLinked then
          bStreamStateNx <= Disabled;
          
          
          
          
          
          bSetEnableIrq <= bOutstandingEnableIrq or bStartChannelRequest;
          
        end if;
        
        
        
        
        bSafeToEnableController <= bWritesDisabled and 
          (bStateInDefaultClkDomain = to_StreamStateValue(Disabled) or 
          bStateInDefaultClkDomain = to_StreamStateValue(Unlinked));
        
        
        bSafeToDisableController <= true;
      
      when Disabled =>
      
        
        if not bLinked then
          bStreamStateNx <= Unlinked;
        
        
        
        elsif not bDisabled and bSatcrWriteReceived and bEnableRegNx and
          bStateInDefaultClkDomain = to_StreamStateValue(Disabled) then
          
          bStreamStateNx <= Enabled;
        
        end if;
        
        
        
        
        
        
        
        
        
        if bStateInDefaultClkDomain = to_StreamStateValue(Disabled) then
          bClearFlushingIrq <= true;
        end if;
        
        
        bSetEnableIrq <= bStartChannelRequest;
        
        
        
        
        bSafeToEnableController <= bWritesDisabled and 
          (bStateInDefaultClkDomain = to_StreamStateValue(Disabled) or 
          bStateInDefaultClkDomain = to_StreamStateValue(Unlinked));
        
        
        bSafeToDisableController <= true;
      
      when Enabled =>
        
        
        
        if bDisabled and bStateInDefaultClkDomain = to_StreamStateValue(Enabled) then
        
          bStreamStateNx <= Disabled;
          
          
          
          
          bResetFirstSatcrWriteTracker <= true;
          
        
        
        elsif not bEnableRegNx and bStateInDefaultClkDomain =
          to_StreamStateValue(Enabled) then
          
          bStreamStateNx <= Flushing;
        
        end if;
        
        
        
        
        
        
        
        
        
        if bStateInDefaultClkDomain = to_StreamStateValue(Enabled) then
          bClearEnableIrq <= true;
        end if;
        
        
        bSafeToEnableController <= true;
        
        
        
        
        bSafeToDisableController <= not bWritesDisabled and (bStateInDefaultClkDomain =
          to_StreamStateValue(Enabled) or bStateInDefaultClkDomain = 
          to_StreamStateValue(Flushing));
      
      when Flushing =>
      
        
        
        if bDisabled then
        
          bStreamStateNx <= Disabled;
          
          
          
          
          bResetFirstSatcrWriteTracker <= true;
          
          
          
          
          
          bSetEnableIrq <= bOutstandingEnableIrq or bStartChannelRequest;
          
        end if;
        
        
        bSafeToEnableController <= true;
        
        
        
        
        bSafeToDisableController <= not bWritesDisabled and (bStateInDefaultClkDomain = 
          to_StreamStateValue(Enabled) or bStateInDefaultClkDomain = 
          to_StreamStateValue(Flushing));
      
      when others =>
      
        bStreamStateNx <= Unlinked;
      
    end case;
  
  end process NextStreamState;
  
  
  bDisable <= not bEnableReg;
  
  
  
  
  
  bDisableControllerNx <= (not bEnableRegNx and not bFlushRegNx) or (not bEnableRegNx
                          and bFlushRegNx and bFifoEmpty and bWritesDisabled);
  bFifoEmpty <= bFifoFullCount = 0;
  
  
  SetEnableStatus: process(bHostDisable, bStopChannelRequest, bHostFlush, 
                           bLinked, bStopChannelWithFlushRequest, bEnableRequestReg,
                           bFlushReg, bEnableReg, bEnableRequestRegNx, bWritesDisabled,
                           bSatcrWriteReceived,  bHostEnable, bSafeToEnableController,
                           bSafeToDisableController, bFifoEmpty, bDisabled)
  begin
  
    bFlushIrqStrobeNx <= false;
    bEnableRegNx <= bEnableReg;
    bEnableRequestRegNx <= bEnableRequestReg;
    bFlushRegNx <= bFlushReg;
    
    bSetFlushingStatus <= false;
    bClearFlushingStatus <= false;
    bSetFlushingFailedStatus <= false;
    bClearFlushingFailedStatus <= false;
    
    
    
    
    
    
    
    if bHostDisable or bStopChannelRequest or not bLinked then
    
      bEnableRequestRegNx <= false;
      bFlushRegNx <= false;
      
      
      
      
      
      
      
      
      if bFlushReg and not (bFifoEmpty and bWritesDisabled) and not bDisabled then
        bSetFlushingFailedStatus <= true;
      end if;
      
    
    
    
    
    elsif (bHostFlush or bStopChannelWithFlushRequest) and bEnableReg then
    
      bEnableRequestRegNx <= false;
      bFlushRegNx <= true;
      
      
      bSetFlushingStatus <= true;
      
      
      if bStopChannelWithFlushRequest then
        bFlushIrqStrobeNx <= true;
      end if;
    
    
    elsif bHostEnable then
    
      bEnableRequestRegNx <= true;
      
      
      bClearFlushingStatus <= true;
      bClearFlushingFailedStatus <= true;
      
      
      
      bFlushRegNx <= false;
      
    end if;
    
    
    
    
    if bEnableReg then
      bEnableRegNx <= bEnableRequestRegNx or not bSafeToDisableController;
      
    
    
    elsif not bEnableReg then
      bEnableRegNx <= bEnableRequestRegNx and bSafeToEnableController;
    end if;
  
  end process SetEnableStatus;
  
  
  
  
  
  TrackSatcrWriteEvent: process(aReset, BusClk)
  begin
    if aReset then
      bSatcrWriteReceived <= false;
    elsif rising_edge(BusClk) then
      if bReset then
        bSatcrWriteReceived <= false;
      else
        if bResetFirstSatcrWriteTracker then
          bSatcrWriteReceived <= false;
        elsif bSatcrWriteEvent then
          bSatcrWriteReceived <= true;
        end if;
      end if;
    end if;
  end process TrackSatcrWriteEvent;
  
  
  
  TrackOutstandingEnableIrq: process(aReset, BusClk)
  begin
    if aReset then
      bOutstandingEnableIrq <= false;
    elsif rising_edge(BusClk) then
      if bReset then
        bOutstandingEnableIrq <= false;
      else
      
        
        
        if bStreamState = Enabled then
          bOutstandingEnableIrq <= false;
          
        
        
        elsif bStartChannelRequest then
          bOutstandingEnableIrq <= true;
        
        end if;
        
      end if;
    end if;
  end process TrackOutstandingEnableIrq;

end behavior;