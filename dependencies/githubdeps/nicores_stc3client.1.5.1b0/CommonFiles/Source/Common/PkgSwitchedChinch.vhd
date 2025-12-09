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
  use work.PkgChinch.all;
  use work.PkgChinchConfig.all;

package PkgSwitchedChinch is

  
  
  

  constant kMaxPayloadSize : integer := kChinchConfig.IO_MPS;
  
  
  subtype SwitchedPacketWord_t is std_logic_vector(63 downto 0);
  subtype SwitchedPacketType_t is std_logic_vector(2 downto 0);
  subtype SwitchedPacketSpc_t is std_logic_vector(1 downto 0);
  subtype SwitchedPacketCompletionStatus_t is std_logic_vector(1 downto 0);
  subtype SwitchedPacketUpperAddress_t is unsigned(31 downto 0);

  
  
  subtype SwitchedPacketEndpoint_t is unsigned(3 downto 0);
  type SwitchedPacketEndpointArray_t is array (natural range <>) of SwitchedPacketEndpoint_t;

  subtype SwitchedPacketLabel_t is unsigned(7 downto 0);
  
  subtype SwitchedPacketStream_t is unsigned(9 downto 0);

  
  
  
  
  
  
  
  subtype SwitchedPacketAddress_t is unsigned(31 downto 0);
  
  subtype SwitchedPacketLocalAddress_t is unsigned(27 downto 0);

  subtype SwitchedPacketByteLane_t is unsigned(2 downto 0);
  
  
  
  
  
  subtype SwitchedPacketLength_t is unsigned(Log2(kMaxPayloadSize) downto 0);
  
  
  constant kSwitchedPacketTypeRequestSplitRead   : SwitchedPacketType_t :=
    kChinchPacketTypeRequestSplitRead;
  constant kSwitchedPacketTypeRequestPostedWrite : SwitchedPacketType_t :=
    kChinchPacketTypeRequestPostedWrite;
  constant kSwitchedPacketTypeResponseRead       : SwitchedPacketType_t :=
    kChinchPacketTypeResponseRead;
  
  constant kSwitchedPacketTypeRetrain    : SwitchedPacketType_t :=
    "000";
  constant kSwitchedPacketTypeLinkConfig : SwitchedPacketType_t :=
    "111";
  
  
  constant kSwitchedPacketSpcExtHeader : SwitchedPacketSpc_t :=
    kChinchPacketSpcExtHeader;
  constant kSwitchedPacketSpcMemory    : SwitchedPacketSpc_t :=
    kChinchPacketSpcMemory;
  constant kSwitchedPacketSpcMessage   : SwitchedPacketSpc_t :=
    kChinchPacketSpcMessage;
  constant kSwitchedPacketSpcStream    : SwitchedPacketSpc_t :=
    kChinchPacketSpcStream;

  
  constant kSwitchedPacketComplStatUnused  : SwitchedPacketCompletionStatus_t :=
    kChinchPacketComplStatUnused;
  constant kSwitchedPacketComplStatSuccess : SwitchedPacketCompletionStatus_t :=
    kChinchPacketComplStatSuccess;
  constant kSwitchedPacketComplStatFailure : SwitchedPacketCompletionStatus_t :=
    kChinchPacketComplStatFailure;
  constant kSwitchedPacketComplStatTermCnt : SwitchedPacketCompletionStatus_t :=
    kChinchPacketComplStatTermCnt;
  constant kSwitchedPacketComplStatDisconn : SwitchedPacketCompletionStatus_t :=
    kChinchPacketComplStatDisconn;

  
  subtype SwitchedPacketLCSubtype_t is std_logic_vector(3 downto 0);

  constant kSwitchedPacketLCSubtypeRouteDefine :
    SwitchedPacketLCSubtype_t := "0000";
  constant kSwitchedPacketLCSubtypeIssueCredits :
    SwitchedPacketLCSubtype_t := "0001";
  constant kSwitchedPacketLCSubtypeConfigWrite :
    SwitchedPacketLCSubtype_t := "0010";
  constant kSwitchedPacketLCSubtypeConfigRead :
    SwitchedPacketLCSubtype_t := "0011";
  constant kSwitchedPacketLCSubtypeConfigResponse :
    SwitchedPacketLCSubtype_t := "0100";
  
  
  constant kSwitchedPacketLCSubtypeTearDown :
    SwitchedPacketLCSubtype_t := "0101";

  
  subtype SwitchedPacketPort_t is unsigned(2 downto 0);
  type SwitchedPacketRoute_t is array (3 downto 0) of
    SwitchedPacketPort_t;

  
  subtype SwitchedPacketCredits_t is unsigned(15 downto 0);
  subtype SwitchedPacketReadCredits_t is unsigned(7 downto 0);

  
  subtype SwitchedPacketConfigDevice_t is unsigned(3 downto 0);
  subtype SwitchedPacketConfigAddress_t is unsigned(7 downto 0);
  subtype SwitchedPacketConfigData_t is std_logic_vector(31 downto 0);

  
  
  
  
  

  function SwitchedPacketGetType (Header : SwitchedPacketWord_t)
    return SwitchedPacketType_t;

  function IsRequestType (PktType : SwitchedPacketType_t) return boolean;
  function IsRoutableType (PktType : SwitchedPacketType_t) return boolean;
  
  function SwitchedPacketGetSpc (Header : SwitchedPacketWord_t)
    return SwitchedPacketSpc_t;

  function SwitchedPacketGetSource (Header : SwitchedPacketWord_t)
    return SwitchedPacketEndpoint_t;
  
  function SwitchedPacketGetDestination (Header : SwitchedPacketWord_t)
    return SwitchedPacketEndpoint_t;
  
  function SwitchedPacketGetDestination (Address : SwitchedPacketAddress_t)
    return SwitchedPacketEndpoint_t;
  
  function SwitchedPacketGetLabel (Header : SwitchedPacketWord_t)
    return SwitchedPacketLabel_t;

  function SwitchedPacketGetLength (Header : SwitchedPacketWord_t)
    return SwitchedPacketLength_t;

  function SwitchedPacketUpdateLength (
    Header : SwitchedPacketWord_t;
    Length : SwitchedPacketLength_t)
    return SwitchedPacketWord_t;

  function SwitchedPacketGetHost (Header : SwitchedPacketWord_t)
    return boolean;
  
  function SwitchedPacketGetAddress (Header : SwitchedPacketWord_t)
    return SwitchedPacketAddress_t;

  function SwitchedPacketBuildLocalAddress (
    Destination  : SwitchedPacketEndpoint_t;
    LocalAddress : SwitchedPacketLocalAddress_t)
    return SwitchedPacketAddress_t;

  function SwitchedPacketGetLocalAddress (Header : SwitchedPacketWord_t)
    return SwitchedPacketLocalAddress_t;

  function SwitchedPacketGetLocalAddress (Address : SwitchedPacketAddress_t)
    return SwitchedPacketLocalAddress_t;

  function SwitchedPacketUpdateLocalAddress (
    Header   : SwitchedPacketWord_t;
    LclAddr  : SwitchedPacketLocalAddress_t)
    return SwitchedPacketWord_t;

  function SwitchedPacketGetByteLane (Header : SwitchedPacketWord_t)
    return SwitchedPacketByteLane_t;

  function SwitchedPacketUpdateByteLane (
    Header   : SwitchedPacketWord_t;
    ByteLane : SwitchedPacketByteLane_t)
    return SwitchedPacketWord_t;

  function SwitchedPacketGetCompletionStatus (Header : SwitchedPacketWord_t)
    return SwitchedPacketCompletionStatus_t;

  function SwitchedPacketGetUpperAddress (Header : SwitchedPacketWord_t)
    return SwitchedPacketUpperAddress_t;

  function SwitchedPacketGetStream (Header : SwitchedPacketWord_t)
    return SwitchedPacketStream_t;

  function SwitchedPacketGetStream (Address : SwitchedPacketAddress_t)
    return SwitchedPacketStream_t;

  function SwitchedPacketBuildStreamAddress (Stream : SwitchedPacketStream_t)
    return SwitchedPacketLocalAddress_t;

  function SwitchedPacketGetDone (Header : SwitchedPacketWord_t)
    return boolean;

  function SwitchedPacketGetEOR (Header : SwitchedPacketWord_t)
    return boolean;

  function SwitchedPacketBuildHeader (
    PktType          : SwitchedPacketType_t;
    Spc              : SwitchedPacketSpc_t;
    PktLabel         : SwitchedPacketLabel_t;
    Source           : SwitchedPacketEndpoint_t;
    Destination      : SwitchedPacketEndpoint_t;
    PktLength        : SwitchedPacketLength_t;
    Host             : boolean;
    Address          : SwitchedPacketAddress_t;
    CompletionStatus : SwitchedPacketCompletionStatus_t;
    Stream           : SwitchedPacketStream_t;
    EndOfRecordFlag  : boolean := false;
    DoneFlag         : boolean := false)
    return SwitchedPacketWord_t;

  function SwitchedPacketBuildExtendedHeader (
    UpperAddress : SwitchedPacketUpperAddress_t)
    return SwitchedPacketWord_t;

  
  function SwitchedPacketGetLinkLocal (Header : SwitchedPacketWord_t)
    return boolean;
  
  function SwitchedPacketGetLCSubtype (Header : SwitchedPacketWord_t)
    return SwitchedPacketLCSubtype_t;

  
  
  
  function SwitchedPacketBuildLinkConfig (
    LinkLocal     : boolean;
    LCSubtype     : SwitchedPacketLCSubtype_t;
    RemainingBits : SwitchedPacketWord_t)
    return SwitchedPacketWord_t;
  
  
  function SwitchedPacketGetRouteEndpoint (Header : SwitchedPacketWord_t)
    return SwitchedPacketEndpoint_t;

  function SwitchedPacketGetRouteSourceEp (Header : SwitchedPacketWord_t)
    return SwitchedPacketEndpoint_t;

  function SwitchedPacketGetNextPort (Header : SwitchedPacketWord_t)
    return SwitchedPacketPort_t;
  
  function SwitchedPacketGetRoute (Header : SwitchedPacketWord_t)
    return SwitchedPacketRoute_t;
  
  function SwitchedPacketBuildRouteDefine (
    Endpoint          : SwitchedPacketEndpoint_t;
    Route             : SwitchedPacketRoute_t;
    SourceEp          : SwitchedPacketEndpoint_t := (others => '0'))
    return SwitchedPacketWord_t;

  
  
  
  function SwitchedPacketShiftRoute (Header : SwitchedPacketWord_t)
    return SwitchedPacketWord_t;

  
    
  function SwitchedPacketGetPacketCredits (Header : SwitchedPacketWord_t)
    return SwitchedPacketCredits_t;

  function SwitchedPacketGetReadCredits (Header : SwitchedPacketWord_t)
    return SwitchedPacketReadCredits_t;

  function SwitchedPacketBuildIssueCredits (
    PacketCredits : SwitchedPacketCredits_t;
    ReadCredits   : SwitchedPacketReadCredits_t)
    return SwitchedPacketWord_t;

  

  function SwitchedPacketGetConfigDevice (Header : SwitchedPacketWord_t)
    return SwitchedPacketConfigDevice_t;

  function SwitchedPacketGetConfigAddress (Header : SwitchedPacketWord_t)
    return SwitchedPacketConfigAddress_t;

  function SwitchedPacketGetConfigData (Header : SwitchedPacketWord_t)
    return SwitchedPacketConfigData_t;

  function SwitchedPacketBuildConfigWrite (
    Route   : SwitchedPacketRoute_t;
    Device  : SwitchedPacketConfigDevice_t;
    Address : SwitchedPacketConfigAddress_t;
    Data    : SwitchedPacketConfigData_t)
    return SwitchedPacketWord_t;

  function SwitchedPacketBuildConfigRead (
    Route   : SwitchedPacketRoute_t;
    Device  : SwitchedPacketConfigDevice_t;
    Address : SwitchedPacketConfigAddress_t)
    return SwitchedPacketWord_t;

  function SwitchedPacketBuildConfigResponse (
    Data : SwitchedPacketConfigData_t)
    return SwitchedPacketWord_t;

  function SwitchedPacketShiftConfigDevice (Header : SwitchedPacketWord_t)
    return SwitchedPacketWord_t;

  
  
  
  
  
  
  
  

  type SwitchedPacketRestriction_t is record
    
    AllowReadRequest  : boolean;
    AllowReadResponse : boolean;
    AllowWriteRequest : boolean;
    AllowRouteDefine  : boolean;
    AllowConfigWrite  : boolean;
    AllowConfigRead   : boolean;
    AllowConfigResponse : boolean;

    
    AllowMemory       : boolean;
    AllowMessage      : boolean;
    AllowStream       : boolean;

    
    AllowExtended     : boolean;

    
    AllowLocal        : boolean;
    AllowHost         : boolean;

    
    AllowZeroLength   : boolean;
  end record;

  function "or" (L, R : SwitchedPacketRestriction_t)
    return SwitchedPacketRestriction_t;
  function "and" (L, R : SwitchedPacketRestriction_t)
    return SwitchedPacketRestriction_t;
  
  constant kSwitchedPacketAllowAll : SwitchedPacketRestriction_t :=
    (others => true);

  
  
  
  
  

  
  function kMaxPacketWords return integer;

  function SwitchedPacketGetPayloadWords (
    Header : SwitchedPacketWord_t;
    Width  : natural)
    return unsigned;

  function SwitchedPacketGetPacketWords (
    Header : SwitchedPacketWord_t;
    Width  : natural)
    return unsigned;

  function SwitchedPacketGetPacketWords (Header : SwitchedPacketWord_t)
    return integer;

  
  
  
  
  

  function SwitchedPacketIsReadRequest (Header : SwitchedPacketWord_t)
    return boolean;
  function SwitchedPacketIsReadResponse (Header : SwitchedPacketWord_t)
    return boolean;
  function SwitchedPacketIsWriteRequest (Header : SwitchedPacketWord_t)
    return boolean;
  function SwitchedPacketIsLinkConfig (Header : SwitchedPacketWord_t)
    return boolean;

  
  function SwitchedPacketIsMemory (Header : SwitchedPacketWord_t)
    return boolean;
  function SwitchedPacketIsMessage (Header : SwitchedPacketWord_t)
    return boolean;
  function SwitchedPacketIsStream (Header : SwitchedPacketWord_t)
    return boolean;

  function SwitchedPacketIsExtended (Header : SwitchedPacketWord_t)
    return boolean;
  
  function SwitchedPacketIsLocal (Header : SwitchedPacketWord_t)
    return boolean;
  function SwitchedPacketIsHost (Header : SwitchedPacketWord_t)
    return boolean;
  
  
  
  

  subtype RFR_Delay_t is unsigned(3 downto 0);
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  type SwitchedLinkTx_t is record
    Data      : SwitchedPacketWord_t;
    Ready     : boolean;
    LastWord  : boolean;
    RFR_Delay : RFR_Delay_t;
  end record;

  constant kSwitchedLinkTxZero : SwitchedLinkTx_t := (
    Data      => (others => '0'),
    Ready     => false,
    LastWord  => false,
    RFR_Delay => to_Unsigned(1, RFR_Delay_t'length)
    );

  
  type SwitchedLinkTxArray_t is array (natural range <>) of SwitchedLinkTx_t;
  
  
  type SwitchedLinkRx_t is record
    Accept       : boolean;
    ReadyForRead : boolean;
  end record;

  constant kSwitchedLinkRxZero : SwitchedLinkRx_t := (
    Accept       => false,
    ReadyForRead => false
    );

  
  type SwitchedLinkRxArray_t is array (natural range <>) of SwitchedLinkRx_t;

end PkgSwitchedChinch;

package body PkgSwitchedChinch is

  function SwitchedPacketGetType (Header : SwitchedPacketWord_t)
    return SwitchedPacketType_t is
  begin
    return Header(2 downto 0);
  end SwitchedPacketGetType;

  function IsRequestType (PktType : SwitchedPacketType_t) return boolean is
  begin
    return ((PktType = kSwitchedPacketTypeRequestSplitRead) or
            (PktType = kSwitchedPacketTypeRequestPostedWrite));
  end IsRequestType;
  
  function IsRoutableType (PktType : SwitchedPacketType_t) return boolean is
  begin
    return ((PktType = kSwitchedPacketTypeRequestSplitRead) or
            (PktType = kSwitchedPacketTypeRequestPostedWrite) or
            (PktType = kSwitchedPacketTypeResponseRead));
  end IsRoutableType;
  
  function SwitchedPacketGetSpc (Header : SwitchedPacketWord_t)
    return SwitchedPacketSpc_t is
    variable Result : SwitchedPacketSpc_t := Header(4 downto 3);
  begin
    return Result;
  end SwitchedPacketGetSpc;

  function SwitchedPacketGetSource (Header : SwitchedPacketWord_t)
    return SwitchedPacketEndpoint_t is
    variable Result : SwitchedPacketEndpoint_t :=
      unsigned(Header(16 downto 13));
  begin
    return Result;
  end SwitchedPacketGetSource;

  function SwitchedPacketGetDestination (Header : SwitchedPacketWord_t)
    return SwitchedPacketEndpoint_t is
    variable Result : SwitchedPacketEndpoint_t :=
      unsigned(Header(63 downto 60));
  begin
    if SwitchedPacketGetHost(Header) then
      
      return (others => '0');
    end if;

    
    return Result;
  end SwitchedPacketGetDestination;

  function SwitchedPacketGetDestination (Address : SwitchedPacketAddress_t)
    return SwitchedPacketEndpoint_t is
    variable Result : SwitchedPacketEndpoint_t := Address(31 downto 28);
  begin
    return Result;
  end SwitchedPacketGetDestination;
  
  function SwitchedPacketGetLabel (Header : SwitchedPacketWord_t)
    return SwitchedPacketLabel_t is
    variable Result : SwitchedPacketLabel_t := 
      unsigned(Header(12 downto 5));
  begin
    return Result;
  end SwitchedPacketGetLabel;

  function SwitchedPacketGetLength (Header : SwitchedPacketWord_t)
    return SwitchedPacketLength_t is
    variable Result : SwitchedPacketLength_t := 
      unsigned(Header(SwitchedPacketLength_t'length+16 downto 17));
  begin
    return Result;
  end SwitchedPacketGetLength;

  function SwitchedPacketUpdateLength (
    Header : SwitchedPacketWord_t;
    Length : SwitchedPacketLength_t)
    return SwitchedPacketWord_t is
    variable Result : SwitchedPacketWord_t := Header;
  begin
    Result(SwitchedPacketLength_t'length+16 downto 17) :=
      std_logic_vector(Length);
    return Result;
  end SwitchedPacketUpdateLength;

  function SwitchedPacketGetHost (Header : SwitchedPacketWord_t)
    return boolean is
  begin
    return to_Boolean(Header(31));
  end SwitchedPacketGetHost;
  
  function SwitchedPacketGetAddress (Header : SwitchedPacketWord_t)
    return SwitchedPacketAddress_t is
    variable Result : SwitchedPacketAddress_t := 
      unsigned(Header(63 downto 32));
  begin
    return Result;
  end SwitchedPacketGetAddress;

  function SwitchedPacketBuildLocalAddress (
    Destination  : SwitchedPacketEndpoint_t;
    LocalAddress : SwitchedPacketLocalAddress_t)
    return SwitchedPacketAddress_t is
    variable Result : SwitchedPacketAddress_t;
  begin
    Result(31 downto 28) := Destination;
    Result(27 downto 0) := LocalAddress;
    return Result;
  end SwitchedPacketBuildLocalAddress;

  function SwitchedPacketGetLocalAddress (Header : SwitchedPacketWord_t)
    return SwitchedPacketLocalAddress_t is
    variable Result : SwitchedPacketLocalAddress_t := 
      unsigned(Header(59 downto 32));
  begin
    return Result;
  end SwitchedPacketGetLocalAddress;

  function SwitchedPacketGetLocalAddress (Address : SwitchedPacketAddress_t)
    return SwitchedPacketLocalAddress_t is
    variable Result : SwitchedPacketLocalAddress_t := Address(27 downto 0);
  begin
    return Result;
  end SwitchedPacketGetLocalAddress;

  function SwitchedPacketUpdateLocalAddress (
    Header  : SwitchedPacketWord_t;
    LclAddr : SwitchedPacketLocalAddress_t)
    return SwitchedPacketWord_t is
    variable Result : SwitchedPacketWord_t := Header;
  begin
    Result(31+SwitchedPacketLocalAddress_t'length downto 32) :=
      std_logic_vector(LclAddr);
    return Result;
  end SwitchedPacketUpdateLocalAddress;

  function SwitchedPacketGetByteLane (Header : SwitchedPacketWord_t)
    return SwitchedPacketByteLane_t is
  begin
    return SwitchedPacketGetLocalAddress(Header)
      (SwitchedPacketByteLane_t'range);
  end SwitchedPacketGetByteLane;

  function SwitchedPacketUpdateByteLane (
    Header   : SwitchedPacketWord_t;
    ByteLane : SwitchedPacketByteLane_t)
    return SwitchedPacketWord_t is
    variable Result : SwitchedPacketWord_t := Header;
  begin
    Result(31+SwitchedPacketByteLane_t'length downto 32) :=
      std_logic_vector(ByteLane);
    return Result;
  end SwitchedPacketUpdateByteLane;

  function SwitchedPacketGetCompletionStatus (Header : SwitchedPacketWord_t)
    return SwitchedPacketCompletionStatus_t is
    variable Result : SwitchedPacketCompletionStatus_t := Header(59 downto 58);
  begin
    return Result;
  end SwitchedPacketGetCompletionStatus;

  function SwitchedPacketGetUpperAddress (Header : SwitchedPacketWord_t)
    return SwitchedPacketUpperAddress_t is
    variable Result : SwitchedPacketAddress_t := 
      unsigned(Header(63 downto 32));
  begin
    return Result;
  end SwitchedPacketGetUpperAddress;

  function SwitchedPacketGetStream (Header : SwitchedPacketWord_t)
    return SwitchedPacketStream_t is
    variable Result : SwitchedPacketStream_t := 
      unsigned(Header(53 downto 44));
  begin
    return Result;
  end SwitchedPacketGetStream;

  function SwitchedPacketGetStream (Address : SwitchedPacketAddress_t)
    return SwitchedPacketStream_t is
    variable Result : SwitchedPacketStream_t := Address(21 downto 12);
  begin
    return Result;
  end SwitchedPacketGetStream;

  function SwitchedPacketBuildStreamAddress (Stream : SwitchedPacketStream_t)
    return SwitchedPacketLocalAddress_t is
    variable Result : SwitchedPacketLocalAddress_t := (others => '0');
  begin
    Result(21 downto 12) := Stream;
    return Result;
  end SwitchedPacketBuildStreamAddress;

  function SwitchedPacketGetDone (Header : SwitchedPacketWord_t)
    return boolean is
  begin
    return to_boolean(Header(42));
  end SwitchedPacketGetDone;

  function SwitchedPacketGetEOR (Header : SwitchedPacketWord_t)
    return boolean is
  begin
    return to_boolean(Header(43));
  end SwitchedPacketGetEOR;

  function SwitchedPacketBuildHeader (
    PktType          : SwitchedPacketType_t;
    Spc              : SwitchedPacketSpc_t;
    PktLabel         : SwitchedPacketLabel_t;
    Source           : SwitchedPacketEndpoint_t;
    Destination      : SwitchedPacketEndpoint_t;
    PktLength        : SwitchedPacketLength_t;
    Host             : boolean;
    Address          : SwitchedPacketAddress_t;
    CompletionStatus : SwitchedPacketCompletionStatus_t;
    Stream           : SwitchedPacketStream_t;
    EndOfRecordFlag  : boolean := false;
    DoneFlag         : boolean := false)
    return SwitchedPacketWord_t is
    variable ReturnVal : SwitchedPacketWord_t := (others => '0');
  begin
    ReturnVal(2 downto 0) := PktType;
    ReturnVal(4 downto 3) := Spc;
    ReturnVal(12 downto 5) := std_logic_vector(PktLabel);
    ReturnVal(16 downto 13) := std_logic_vector(Source);
    ReturnVal(PktLength'length+16 downto 17) := std_logic_vector(PktLength);

    if Host then
      ReturnVal(31) := '1';
    end if;

    if ((PktType = kSwitchedPacketTypeRequestSplitRead) or
        (PktType = kSwitchedPacketTypeRequestPostedWrite)) then
      if Spc = kSwitchedPacketSpcStream then
        ReturnVal(34 downto 32) := std_logic_vector(Address(2 downto 0));
        ReturnVal(42) := to_StdLogic(DoneFlag);
        ReturnVal(43) := to_StdLogic(EndOfRecordFlag);
        ReturnVal(53 downto 44) := std_logic_vector(Stream);
        ReturnVal(63 downto 60) := std_logic_vector(Destination);
      else
        if Host then
          ReturnVal(63 downto 32) := std_logic_vector(Address);
        else
          ReturnVal(59 downto 32) := std_logic_vector(Address(27 downto 0));
          ReturnVal(63 downto 60) := std_logic_vector(Destination);
        end if;
      end if;
    elsif PktType = kSwitchedPacketTypeResponseRead then
      ReturnVal(34 downto 32) := std_logic_vector(Address(2 downto 0));
      if Spc = kSwitchedPacketSpcStream then
        ReturnVal(53 downto 44) := std_logic_vector(Stream);
      end if;
      ReturnVal(59 downto 58) := std_logic_vector(CompletionStatus);
      ReturnVal(63 downto 60) := std_logic_vector(Destination);
    else
      report "Invalid Packet Type" severity error;
    end if;

    return ReturnVal;
  end SwitchedPacketBuildHeader;

  function SwitchedPacketBuildExtendedHeader (
    UpperAddress : SwitchedPacketUpperAddress_t)
    return SwitchedPacketWord_t is
    variable Result : SwitchedPacketWord_t := (others => '0');
  begin
    Result(63 downto 32) := std_logic_vector(UpperAddress);
    return Result;
  end SwitchedPacketBuildExtendedHeader;

  function SwitchedPacketGetLinkLocal (Header : SwitchedPacketWord_t)
    return boolean is
  begin
    return to_boolean(Header(3));
  end SwitchedPacketGetLinkLocal;
  
  function SwitchedPacketGetLCSubtype (Header : SwitchedPacketWord_t)
    return SwitchedPacketLCSubtype_t is
    variable Result : SwitchedPacketLCSubtype_t :=
      Header(7 downto 4);
  begin
    return Result;
  end SwitchedPacketGetLCSubtype;
  
  function SwitchedPacketBuildLinkConfig (
    LinkLocal     : boolean;
    LCSubtype     : SwitchedPacketLCSubtype_t;
    RemainingBits : SwitchedPacketWord_t)
    return SwitchedPacketWord_t is
    variable Result : SwitchedPacketWord_t := RemainingBits;
  begin
    Result(2 downto 0) := kSwitchedPacketTypeLinkConfig;
    Result(3) := to_StdLogic(LinkLocal);
    Result(7 downto 4) := LCSubtype;
    return Result;
  end SwitchedPacketBuildLinkConfig;
  
  function SwitchedPacketGetRouteEndpoint (Header : SwitchedPacketWord_t)
    return SwitchedPacketEndpoint_t is
    variable Result : SwitchedPacketEndpoint_t :=
      unsigned(Header(23 downto 20));
  begin
    return Result;
  end SwitchedPacketGetRouteEndpoint;

  function SwitchedPacketGetRouteSourceEp (Header : SwitchedPacketWord_t)
    return SwitchedPacketEndpoint_t is
    variable Result : SwitchedPacketEndpoint_t :=
      unsigned(Header(27 downto 24));
  begin
    return Result;
  end SwitchedPacketGetRouteSourceEp;

  function SwitchedPacketGetNextPort (Header : SwitchedPacketWord_t)
    return SwitchedPacketPort_t is
    variable Result : SwitchedPacketPort_t :=
      unsigned(Header(10 downto 8));
  begin
    return Result;
  end SwitchedPacketGetNextPort;

  function SwitchedPacketGetRoute (Header : SwitchedPacketWord_t)
    return SwitchedPacketRoute_t is
    variable Result : SwitchedPacketRoute_t;
  begin
    for i in Result'range loop
      Result(i) := unsigned(Header(10+(3*i) downto 8+(3*i)));
    end loop;  
    return Result;
  end SwitchedPacketGetRoute;
  
  function SwitchedPacketBuildRouteDefine (
    Endpoint          : SwitchedPacketEndpoint_t;
    Route             : SwitchedPacketRoute_t;
    SourceEp          : SwitchedPacketEndpoint_t := (others => '0'))
    return SwitchedPacketWord_t is
    variable Result : SwitchedPacketWord_t := (others => '0');
  begin
    Result(2 downto 0) := kSwitchedPacketTypeLinkConfig;
    Result(7 downto 4) := kSwitchedPacketLCSubtypeRouteDefine;
    Result(23 downto 20) := std_logic_vector(Endpoint);
    Result(27 downto 24) := std_logic_vector(SourceEp);
    for i in Route'range loop
      Result(10+(3*i) downto 8+(3*i)) := std_logic_vector(Route(i));
    end loop;  
    return Result;
  end SwitchedPacketBuildRouteDefine;

  function SwitchedPacketShiftRoute (Header : SwitchedPacketWord_t)
    return SwitchedPacketWord_t is
    variable Result : SwitchedPacketWord_t := Header;
  begin
    Result(19 downto 8) := "000" & Result(19 downto 11);
    return Result;
  end SwitchedPacketShiftRoute;
  
  function SwitchedPacketGetPacketCredits (Header : SwitchedPacketWord_t)
    return SwitchedPacketCredits_t is
    variable Result : SwitchedPacketCredits_t :=
      unsigned(Header(31 downto 16));
  begin
    return Result;
  end SwitchedPacketGetPacketCredits;

  function SwitchedPacketGetReadCredits (Header : SwitchedPacketWord_t)
    return SwitchedPacketReadCredits_t is
    variable Result : SwitchedPacketReadCredits_t :=
      unsigned(Header(39 downto 32));
  begin
    return Result;
  end SwitchedPacketGetReadCredits;

  function SwitchedPacketBuildIssueCredits (
    PacketCredits : SwitchedPacketCredits_t;
    ReadCredits   : SwitchedPacketReadCredits_t)
    return SwitchedPacketWord_t is
    variable Result : SwitchedPacketWord_t := (others => '0');
  begin
    Result(2 downto 0) := kSwitchedPacketTypeLinkConfig;
    Result(7 downto 4) := kSwitchedPacketLCSubtypeIssueCredits;
    Result(31 downto 16) := std_logic_vector(PacketCredits);
    Result(39 downto 32) := std_logic_vector(ReadCredits);
    return Result;
  end SwitchedPacketBuildIssueCredits;

  function SwitchedPacketGetConfigDevice (Header : SwitchedPacketWord_t)
    return SwitchedPacketConfigDevice_t is
    variable Result : SwitchedPacketConfigDevice_t :=
      unsigned(Header(23 downto 20));
  begin
    return Result;
  end SwitchedPacketGetConfigDevice;

  function SwitchedPacketGetConfigAddress (Header : SwitchedPacketWord_t)
    return SwitchedPacketConfigAddress_t is
    variable Result : SwitchedPacketConfigAddress_t :=
      unsigned(Header(31 downto 24));
  begin
    return Result;
  end SwitchedPacketGetConfigAddress;

  function SwitchedPacketGetConfigData (Header : SwitchedPacketWord_t)
    return SwitchedPacketConfigData_t is
    variable Result : SwitchedPacketConfigData_t := Header(63 downto 32);
  begin
    return Result;
  end SwitchedPacketGetConfigData;

  function SwitchedPacketBuildConfigWrite (
    Route   : SwitchedPacketRoute_t;
    Device  : SwitchedPacketConfigDevice_t;
    Address : SwitchedPacketConfigAddress_t;
    Data    : SwitchedPacketConfigData_t)
    return SwitchedPacketWord_t is
    variable Result : SwitchedPacketWord_t := (others => '0');
  begin
    Result(2 downto 0) := kSwitchedPacketTypeLinkConfig;
    Result(7 downto 4) := kSwitchedPacketLCSubtypeConfigWrite;
    for i in Route'range loop
      Result(10+(3*i) downto 8+(3*i)) := std_logic_vector(Route(i));
    end loop;  
    Result(23 downto 20) := std_logic_vector(Device);
    Result(31 downto 24) := std_logic_vector(Address);
    Result(63 downto 32) := Data;
    return Result;
  end SwitchedPacketBuildConfigWrite;

  function SwitchedPacketBuildConfigRead (
    Route   : SwitchedPacketRoute_t;
    Device  : SwitchedPacketConfigDevice_t;
    Address : SwitchedPacketConfigAddress_t)
    return SwitchedPacketWord_t is
    variable Result : SwitchedPacketWord_t := (others => '0');
  begin
    Result(2 downto 0) := kSwitchedPacketTypeLinkConfig;
    Result(7 downto 4) := kSwitchedPacketLCSubtypeConfigRead;
    for i in Route'range loop
      Result(10+(3*i) downto 8+(3*i)) := std_logic_vector(Route(i));
    end loop;  
    Result(23 downto 20) := std_logic_vector(Device);
    Result(31 downto 24) := std_logic_vector(Address);
    return Result;
  end SwitchedPacketBuildConfigRead;

  function SwitchedPacketBuildConfigResponse (
    Data : SwitchedPacketConfigData_t)
    return SwitchedPacketWord_t is
    variable Result : SwitchedPacketWord_t := (others => '0');
  begin
    Result(2 downto 0) := kSwitchedPacketTypeLinkConfig;
    Result(7 downto 4) := kSwitchedPacketLCSubtypeConfigResponse;
    Result(63 downto 32) := Data;
    return Result;
  end SwitchedPacketBuildConfigResponse;

  function SwitchedPacketShiftConfigDevice (Header : SwitchedPacketWord_t)
    return SwitchedPacketWord_t is
    variable Result : SwitchedPacketWord_t := Header;
  begin
    Result(23 downto 20) :=
      std_logic_vector(unsigned(Header(23 downto 20)) - 1);
    return Result;
  end SwitchedPacketShiftConfigDevice;

  function "or" (L, R : SwitchedPacketRestriction_t)
    return SwitchedPacketRestriction_t is
  begin
    return (
      AllowReadRequest    => L.AllowReadRequest    or R.AllowReadRequest,
      AllowReadResponse   => L.AllowReadResponse   or R.AllowReadResponse,
      AllowWriteRequest   => L.AllowWriteRequest   or R.AllowWriteRequest,
      AllowRouteDefine    => L.AllowRouteDefine    or R.AllowRouteDefine,
      AllowConfigWrite    => L.AllowConfigWrite    or R.AllowConfigWrite,
      AllowConfigRead     => L.AllowConfigRead     or R.AllowConfigRead,
      AllowConfigResponse => L.AllowConfigResponse or R.AllowConfigResponse,
      AllowMemory         => L.AllowMemory         or R.AllowMemory,
      AllowMessage        => L.AllowMessage        or R.AllowMessage,
      AllowStream         => L.AllowStream         or R.AllowStream,
      AllowExtended       => L.AllowExtended       or R.AllowExtended,
      AllowLocal          => L.AllowLocal          or R.AllowLocal,
      AllowHost           => L.AllowHost           or R.AllowHost,
      AllowZeroLength     => L.AllowZeroLength     or R.AllowZeroLength
      );
  end "or";
  
  function "and" (L, R : SwitchedPacketRestriction_t)
    return SwitchedPacketRestriction_t is
  begin
    return (
      AllowReadRequest    => L.AllowReadRequest    and R.AllowReadRequest,
      AllowReadResponse   => L.AllowReadResponse   and R.AllowReadResponse,
      AllowWriteRequest   => L.AllowWriteRequest   and R.AllowWriteRequest,
      AllowRouteDefine    => L.AllowRouteDefine    and R.AllowRouteDefine,
      AllowConfigWrite    => L.AllowConfigWrite    and R.AllowConfigWrite,
      AllowConfigRead     => L.AllowConfigRead     and R.AllowConfigRead,
      AllowConfigResponse => L.AllowConfigResponse and R.AllowConfigResponse,
      AllowMemory         => L.AllowMemory         and R.AllowMemory,
      AllowMessage        => L.AllowMessage        and R.AllowMessage,
      AllowStream         => L.AllowStream         and R.AllowStream,
      AllowExtended       => L.AllowExtended       and R.AllowExtended,
      AllowLocal          => L.AllowLocal          and R.AllowLocal,
      AllowHost           => L.AllowHost           and R.AllowHost,
      AllowZeroLength     => L.AllowZeroLength     and R.AllowZeroLength
      );
  end "and";
  
  
  function kMaxPacketWords return integer is
  begin
    
    
    
    return 2 + (kMaxPayloadSize / 8) + 1;
  end kMaxPacketWords;
  
  function SwitchedPacketGetPayloadWords (
    Header : SwitchedPacketWord_t;
    Width  : natural)
    return unsigned is
    
    variable Length : SwitchedPacketLength_t :=
      SwitchedPacketGetLength(Header);
    
    variable IsWriteRequest : boolean := SwitchedPacketIsWriteRequest(Header);
    variable IsReadResponse : boolean := SwitchedPacketIsReadResponse(Header);
    
    variable Result : unsigned(Width-1 downto 0) := (others => '0');
  begin

    if IsWriteRequest or IsReadResponse then
      

      
      Result := ChinchPacketPayloadWords(
        PktLength => resize(Length, ChinchPacketLength_t'length),
        Address   => SwitchedPacketGetAddress(Header),
        Width     => Width
        );
      
      
      
      
      
      
      
      

      
      if Length = 0 then
        
        Result := to_unsigned(0, Result'length);
      end if;
    end if;
    
    return Result;
  end SwitchedPacketGetPayloadWords;
  
  function SwitchedPacketGetPacketWords (
    Header : SwitchedPacketWord_t;
    Width  : natural)
    return unsigned is
    
    variable IsReadRequest : boolean := SwitchedPacketIsReadRequest(Header);
    variable IsWriteRequest : boolean := SwitchedPacketIsWriteRequest(Header);
    variable Adder : integer;
    variable Result : unsigned(Width-1 downto 0) := (others => '0');
  begin

    Result := SwitchedPacketGetPayloadWords(
      Header => Header,
      Width  => Width
      );

    if ((IsWriteRequest or IsReadRequest) and
        (SwitchedPacketGetSpc(Header) = kSwitchedPacketSpcExtHeader)) then
      
      Adder := 2;
    else
      
      Adder := 1;
    end if;

    Result := Result + Adder;

    return Result;
  end SwitchedPacketGetPacketWords;
  
  function SwitchedPacketGetPacketWords (
    Header : SwitchedPacketWord_t)
    return integer is
  begin
    return to_integer(
      SwitchedPacketGetPacketWords(
        Header      => Header,
        Width       => Log2(kMaxPacketWords+1)
        ));
  end SwitchedPacketGetPacketWords;
  
  function SwitchedPacketIsReadRequest (Header : SwitchedPacketWord_t)
    return boolean is
  begin
    return (SwitchedPacketGetType(Header) =
            kSwitchedPacketTypeRequestSplitRead);
  end SwitchedPacketIsReadRequest;
  
  function SwitchedPacketIsReadResponse (Header : SwitchedPacketWord_t)
    return boolean is
  begin
    return SwitchedPacketGetType(Header) = kSwitchedPacketTypeResponseRead;
  end SwitchedPacketIsReadResponse;
  
  function SwitchedPacketIsWriteRequest (Header : SwitchedPacketWord_t)
    return boolean is
  begin
    return (SwitchedPacketGetType(Header) =
            kSwitchedPacketTypeRequestPostedWrite);
  end SwitchedPacketIsWriteRequest;
  
  function SwitchedPacketIsLinkConfig (Header : SwitchedPacketWord_t)
    return boolean is
  begin
    return SwitchedPacketGetType(Header) = kSwitchedPacketTypeLinkConfig;
  end SwitchedPacketIsLinkConfig;
  
  function SwitchedPacketIsMemory (Header : SwitchedPacketWord_t)
    return boolean is
  begin
    return SwitchedPacketGetSpc(Header) = kSwitchedPacketSpcMemory;
  end SwitchedPacketIsMemory;
  
  function SwitchedPacketIsMessage (Header : SwitchedPacketWord_t)
    return boolean is
  begin
    return SwitchedPacketGetSpc(Header) = kSwitchedPacketSpcMessage;
  end SwitchedPacketIsMessage;
  
  function SwitchedPacketIsStream (Header : SwitchedPacketWord_t)
    return boolean is
  begin
    return SwitchedPacketGetSpc(Header) = kSwitchedPacketSpcStream;
  end SwitchedPacketIsStream;
  
  function SwitchedPacketIsExtended (Header : SwitchedPacketWord_t)
    return boolean is
  begin
    return SwitchedPacketGetSpc(Header) = kSwitchedPacketSpcExtHeader;
  end SwitchedPacketIsExtended;
  
  function SwitchedPacketIsLocal (Header : SwitchedPacketWord_t)
    return boolean is
  begin
    return not SwitchedPacketGetHost(Header);
  end SwitchedPacketIsLocal;
  
  function SwitchedPacketIsHost (Header : SwitchedPacketWord_t)
    return boolean is
  begin
    return SwitchedPacketGetHost(Header);
  end SwitchedPacketIsHost;

end PkgSwitchedChinch;