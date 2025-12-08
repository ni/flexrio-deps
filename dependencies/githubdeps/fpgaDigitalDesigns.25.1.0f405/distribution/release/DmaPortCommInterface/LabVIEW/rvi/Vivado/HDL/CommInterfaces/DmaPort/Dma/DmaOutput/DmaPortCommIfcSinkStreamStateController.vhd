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
  
entity DmaPortCommIfcSinkStreamStateController is
  port (

    
    aReset         : in  boolean;
    
    
    bReset         : in  boolean;
    
    
    BusClk         : in  std_logic;
    
    
    
    
    
    
    bState                : out StreamStateValue_t;
    
    
    
    
    
    
    bReportDisabledToDiagram    : out boolean;
    
    
    
    bDisable              : out boolean;
    
    
    
    bResetFifo            : out boolean;
    
    
    
    bSetEnableIrq         : out boolean;
    
    
    
    bClearEnableIrq       : out boolean;
    
    
    
    bClearDisableIrq      : out boolean;
    
    
    
    
    
    
    
    
    
    bDisabledStatusForHost    : out boolean;
    
    
    
    
    
    
    
    bHostEnable                     : in boolean;
    
    
    
    bHostDisable                    : in boolean;
    
    
    
    bStopChannelRequest             : in boolean;
    
    
    
    bStartChannelRequest            : in boolean;
    
    
    
    
    
    
    
    bDisabled           : in boolean;
    
    
    bLinked             : in boolean;
    
    
    
    bResetDone          : in boolean;
    
    
    
    bStreamError        : in boolean;
    
    
    
    bStateInDefaultClkDomain    : in StreamStateValue_t

  );
end DmaPortCommIfcSinkStreamStateController;

architecture behavior of DmaPortCommIfcSinkStreamStateController is

  signal bStreamState, bStreamStateNx : StreamState_t;
  signal bEnableReg, bEnableRegNx : boolean;
  signal bStateEnableReg, bStateEnableRegNx : boolean;
  signal bDisableNx : boolean;
  signal bWaitOnFifoReset, bWaitOnFifoResetNx : boolean;
  signal bOutstandingEnableIrq : boolean;
  signal bDisableLoc : boolean := true;
begin

  bResetFifo <= bWaitOnFifoReset;
  bState <= to_StreamStateValue(bStreamState);
  bDisable <= bDisableLoc;
  
  
  StreamStateRegs: process(aReset, BusClk)
  begin
    
    if aReset then
    
      
      bStreamState <= Unlinked;
      bEnableReg <= false;
      bStateEnableReg <= false;
      bDisableLoc <= true;
      bWaitOnFifoReset <= false;
    
    elsif rising_edge(BusClk) then
    
      if bReset then
      
        
        bStreamState <= Unlinked;
        bEnableReg <= false;
        bStateEnableReg <= false;
        bDisableLoc <= true;
        bWaitOnFifoReset <= false;
      
      else
      
        bStreamState <= bStreamStateNx;
        bEnableReg <= bEnableRegNx;
        bStateEnableReg <= bStateEnableRegNx;
        bDisableLoc <= bDisableNx;
        bWaitOnFifoReset <= bWaitOnFifoResetNx;
      
      end if;
      
    end if;
    
  end process StreamStateRegs;


  
  
  
  
  
  NextStreamState: process(bStreamState, bLinked, bDisabled, bStateEnableRegNx, 
                           bOutstandingEnableIrq, bEnableReg, bStateInDefaultClkDomain,
                           bStartChannelRequest)
  begin
  
    bStreamStateNx <= bStreamState;
    bSetEnableIrq <= false;
    bClearEnableIrq <= false;
    bClearDisableIrq <= false;
    bReportDisabledToDiagram <= false;
    
    case bStreamState is
    
      when Unlinked =>
        
        
        if bLinked then
          bStreamStateNx <= Disabled;
          
          
          
          
          
          bSetEnableIrq <= bOutstandingEnableIrq;
          
        end if;
      
      when Disabled =>
      
        
        if not bLinked then
        
          bStreamStateNx <= Unlinked;
        
        
        
        
        
        
        elsif not bDisabled and bStateEnableRegNx and bStateInDefaultClkDomain = 
          to_StreamStateValue(Disabled) then
          
          bStreamStateNx <= Enabled;
        
        end if;
        
        
        bSetEnableIrq <= bStartChannelRequest;
        
        
        
        
        
        
        
        
        
        if bStateInDefaultClkDomain = to_StreamStateValue(Disabled) then
          bClearDisableIrq <= true;
        end if;
      
      when Enabled =>
        
        
        
        
        
        
        if bDisabled and not bStateEnableRegNx and bStateInDefaultClkDomain = 
          to_StreamStateValue(Enabled) then
          
          bStreamStateNx <= Disabled;
          
        end if;
        
        
        
        
        
        
        
        
        
        if bStateInDefaultClkDomain = to_StreamStateValue(Enabled) then
          bClearEnableIrq <= true;
        end if;
        
        
        
        
        
        
        
        bReportDisabledToDiagram <= not bEnableReg;
      
      when others =>
      
        bStreamStateNx <= Unlinked;
      
    end case;
  
  end process NextStreamState;

  
  bDisableNx <= not bEnableRegNx;

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  SetEnableStatus: process(bHostDisable, bStopChannelRequest, bLinked, bEnableReg, 
                           bHostEnable, bStateEnableReg, bWaitOnFifoReset, bResetDone,
                           bStreamError)
  begin
  
    bEnableRegNx <= bEnableReg;
    bStateEnableRegNx <= bStateEnableReg;
    bWaitOnFifoResetNx <= bWaitOnFifoReset;
    
    
    
    
    if bHostDisable or bStopChannelRequest or bStreamError or not bLinked then
    
      bEnableRegNx <= false;
      bWaitOnFifoResetNx <= false;
    
      
      if bHostDisable or not bLinked then
        bStateEnableRegNx <= false;
      end if;
      
    elsif bHostEnable then
      
      
      bWaitOnFifoResetNx <= true;
    
    elsif bWaitOnFifoReset and bResetDone then
    
      
      bEnableRegNx <= true;
      bStateEnableRegNx <= true;
      bWaitOnFifoResetNx <= false;
      
    end if;
  
  end process SetEnableStatus;
 
  
  
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
 
  
  
  
  
  
  
  bDisabledStatusForHost <= bDisabled and bStreamState /= Enabled;

end behavior;