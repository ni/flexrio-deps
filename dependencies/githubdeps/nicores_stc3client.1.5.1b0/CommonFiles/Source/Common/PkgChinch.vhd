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

package PkgChinch is

  
  
  
  
  
  
  

  type Target_t is (Simulation, Virtex2, Virtex4, Spartan3, Stratix, Stratix2,
                    Oki);



  
  
  

  type ChinchCoreConfig_t is record
    TwoClocks : boolean;          
                                  
                                  
                                  
                                  
                                  

    DMA_TYPE : natural;           
                                  

    DMA_ChannelsLog2 : natural;   
                                  
                                  

    LINKSZ_Log2 : natural;        
                                  

    IncludeInputDma : boolean;    
                                  

    IncludeOutputDma : boolean;   
                                  

    IncludeTtccr : boolean;       
                                  
                                  

    IncludeTimer : boolean;       
                                  
                                  

    IncludeIntStatPush : boolean; 
                                  

    IncludeMCU : boolean;         
                                  

    ProgRomAddressWidth : natural;    
                                      

    OnChipRamAddressWidth : natural;  
                                      
                                      
                                      

    OffChipRamAddressWidth : natural; 
                                      

    RandomAccess : boolean;       
                                  
                                  

    IO_MPS : natural;             
                                  
                                  
                                  

    HB_MPS : natural;             
                                  
                                  
                                  

    IO_MSIT : natural;            
                                  

    HB_MSIT : natural;            
                                  

    IORXBE_MP : natural;          
                                      
    IORXBE_MW : natural;          
                                      

    IOTXBE_MP : natural;          
                                      
    IOTXBE_MW : natural;          
                                      

    HBRXBE_MP : natural;          
                                      
    HBRXBE_MW : natural;          
                                      

    HBTXBE_MP : natural;          
                                      
    HBTXBE_MW : natural;          
                                      

    IO_RegProgEndian : boolean;   
                                  
                                  

    IO_RegBigEndian : boolean;    
                                  
                                  
                                  
                                  

    HB_RegProgEndian : boolean;   
                                  
                                  

    HB_RegBigEndian : boolean;    
                                  
                                  
                                  
                                  

    IO_BaggageWidth : natural;    

    HB_BaggageWidth : natural;    

    IO_Windows : natural;         

    CP_Windows : natural;         
                                  
                                  
                                  

    NumGpios : natural;           
                                  
  end record;



  
  
  
  
  
  

  type BIM_Config_t is record
    HBR_SIZE_Log2 : unsigned(4 downto 0);   
                                  
                                  
                                  
                                  
                                  

    HBR_BASE : unsigned(31 downto 0);   
                                  
                                  
                                  
                                  
                                  

    TypeIdentification : std_logic_vector(31 downto 0);   
                                  

    SingleResponse : boolean;

    MaxResponseSizeLog2 : unsigned(3 downto 0);

    MaxReadSizeLog2 : unsigned(3 downto 0);

    MaxWriteSizeLog2 : unsigned(3 downto 0);

    MaxTransacts : unsigned(11 downto 0);

    ReadReqAddressBoundaryLog2 : unsigned(3 downto 0);

    WriteReqAddressBoundaryLog2 : unsigned(3 downto 0);
  end record;



  
  
  

  type ChinchCoreStatus_t is record

    PoscStatus : std_logic_vector(1 downto 0); 

    InterruptViaMessages : boolean;  
                                     
                                     
                                     
                                     
                                     

    InterruptTrafficClass : std_logic_vector(5 downto 0);

    UnsolicitedCompletionPulse : boolean;  
                                           
                                           

    CompletionTimeOutPulse : boolean;  
                                       
                                       
                                       

    OutstandingTransactions : boolean;  
                                        
                                        
                                        
                                        

    ApplicationSepecificMode : std_logic_vector(7 downto 0);

    DebugSelect : std_logic_vector(2 downto 0);
    DebugInfo : std_logic_vector(7 downto 0);
  end record;



  

  subtype ChinchPacketWord_t is std_logic_vector(63 downto 0);

  subtype ChinchPacketType_t is std_logic_vector(2 downto 0);

  subtype ChinchPacketSpc_t is std_logic_vector(1 downto 0);

  subtype ChinchPacketLabel_t is unsigned(11 downto 0);

  subtype ChinchPacketLength_t is unsigned(14 downto 0);

  subtype ChinchPacketAddress_t is unsigned(31 downto 0);

  subtype ChinchPacketCompletionStatus_t is std_logic_vector(1 downto 0);

  subtype ChinchPacketRemainingCount_t is unsigned(14 downto 0);

  subtype ChinchPacketUpperAddress_t is unsigned(31 downto 0);

  subtype ChinchPacketStream_t is unsigned(15 downto 0);



  

  constant kChinchPacketTypeRequestSplitRead   : ChinchPacketType_t := "001";

  constant kChinchPacketTypeResponseWrite      : ChinchPacketType_t := "010";

  constant kChinchPacketTypeRequestPostedWrite : ChinchPacketType_t := "100";

  constant kChinchPacketTypeRequestSplitWrite  : ChinchPacketType_t := "101";

  constant kChinchPacketTypeResponseRead       : ChinchPacketType_t := "110";



  

  constant kChinchPacketSpcExtHeader : ChinchPacketSpc_t := "00";

  constant kChinchPacketSpcMemory    : ChinchPacketSpc_t := "01";

  constant kChinchPacketSpcMessage   : ChinchPacketSpc_t := "10";

  constant kChinchPacketSpcStream    : ChinchPacketSpc_t := "11";



  

  constant kChinchPacketComplStatUnused  : ChinchPacketCompletionStatus_t
                                                                 := "00";

  constant kChinchPacketComplStatSuccess : ChinchPacketCompletionStatus_t
                                                                 := "00";

  constant kChinchPacketComplStatFailure : ChinchPacketCompletionStatus_t
                                                                 := "01";

  constant kChinchPacketComplStatTermCnt : ChinchPacketCompletionStatus_t
                                                                 := "10";

  constant kChinchPacketComplStatDisconn : ChinchPacketCompletionStatus_t
                                                                 := "11";



  

  constant kChinchPacketRemainingCountUnused : ChinchPacketRemainingCount_t
                                                        := (others => '0');

  constant kChinchPacketStreamUnused : ChinchPacketStream_t
                                                        := (others => '0');



  

  constant kChinchDestinationLocal       : std_logic_vector := "00";

  constant kChinchDestinationBusSpecific : std_logic_vector := "01";

  constant kChinchDestinationIdentROM    : std_logic_vector := "10";

  constant kChinchDestinationFar         : std_logic_vector := "11";



  

  constant kChinchDataSize64bit : std_logic_vector := "11";

  constant kChinchDataSize32bit : std_logic_vector := "10";

  constant kChinchDataSize16bit : std_logic_vector := "01";

  constant kChinchDataSize08bit : std_logic_vector := "00";



  

  constant kCHID : std_logic_vector(31 downto 0) := X"C0107AD0";

  

  constant kChinchBuildCode : std_logic_vector(31 downto 0) := X"08050513";

  

  constant kRMV : std_logic_vector(31 downto 0) := X"00000002";



  

  subtype WindowSize_t is unsigned(4 downto 0);

  type WindowSizeArray_t is array(integer range<>) of WindowSize_t;

  type WindowBaseArray_t is array(integer range<>) of ChinchPacketAddress_t;



  

  function Pow2(Num : integer) return integer;

  function Pow2(Num : unsigned) return unsigned;

  function HowManyOnes(Vec : std_logic_vector) return natural;

  function AddressInWindow(WindowEnable : std_logic;
                           WindowSize : unsigned(4 downto 0);
                           WindowBase : unsigned(31 downto 0);
                           Address : unsigned(31 downto 0)) return boolean;

  function CropAddress(WindowSize : unsigned(4 downto 0);
                       Address : unsigned) return unsigned;

  function GetDecodeBits(WindowSize : unsigned(4 downto 0)) return unsigned;

  function PageAddress(WindowSize : unsigned(4 downto 0);
                       WindowPage : unsigned(31 downto 0);
                       Address : unsigned(31 downto 0)) return unsigned;

  function CalcSizeLimitFromAddress(Address : unsigned(15 downto 0);
                                    AddressBoundaryLog2 : unsigned(3 downto 0);
                                    ProgSizeLimit : unsigned(15 downto 0))
      return unsigned;

  function CalcCompletionLimit(Address : unsigned(15 downto 0);
                               ProgSizeLimit : unsigned(3 downto 0))
      return unsigned;



  
  

  function ChinchGetDMA_SPACE_Log2(DMA_Type : natural) return natural;

  function ChinchGetDMA_BASE(SpacePerLog2 : natural; NumChansLog2 : natural)
    return unsigned;



  

  function ChinchPacketGetType(Header : ChinchPacketWord_t)
    return ChinchPacketType_t;

  function ChinchPacketGetSpc(Header : ChinchPacketWord_t)
    return ChinchPacketSpc_t;

  function ChinchPacketGetLabel(Header : ChinchPacketWord_t)
    return ChinchPacketLabel_t;

  function ChinchPacketGetLength(Header : ChinchPacketWord_t)
    return ChinchPacketLength_t;

  function ChinchPacketGetAddress(Header : ChinchPacketWord_t)
    return ChinchPacketAddress_t;

  function ChinchPacketGetCompletionStatus(Header : ChinchPacketWord_t)
    return ChinchPacketCompletionStatus_t;

  function ChinchPacketGetRemainingCount(Header : ChinchPacketWord_t)
    return ChinchPacketRemainingCount_t;

  function ChinchPacketGetUpperAddress(Header : ChinchPacketWord_t)
    return ChinchPacketUpperAddress_t;

  function ChinchPacketGetStream(Header : ChinchPacketWord_t)
    return ChinchPacketStream_t;

  function ChinchPacketBuildHeader(
                   PktType : ChinchPacketType_t;
                   Spc : ChinchPacketSpc_t;
                   PktLabel : ChinchPacketLabel_t;
                   PktLength : ChinchPacketLength_t;
                   Address : ChinchPacketAddress_t;
                   CompletionStatus : ChinchPacketCompletionStatus_t;
                   RemainingCount : ChinchPacketRemainingCount_t;
                   Stream : ChinchPacketStream_t;
                   EndOfRecordFlag : boolean := false;
                   DoneFlag : boolean := false
                                  ) return ChinchPacketWord_t;

  function ChinchPacketBuildExtendedHeader(
                   Spc : ChinchPacketSpc_t;
                   UpperAddress : ChinchPacketUpperAddress_t
                                  ) return ChinchPacketWord_t;

  function ChinchPacketPayloadWords(PktLength : ChinchPacketLength_t;
                                    Address : unsigned;
                                    Width : natural) return unsigned;

  function ChinchPacketMaxPayloadWords(PayloadSize : natural) return natural;



  
  

  function ChinchPacketRequest(PktType : ChinchPacketType_t) return boolean;

  function ChinchPacketResponse(PktType : ChinchPacketType_t) return boolean;

  function ChinchPacketHeaderExtended(Spc : ChinchPacketSpc_t
                                     ) return boolean;
  function ChinchPacketHasPayload(Header : ChinchPacketWord_t)
    return boolean;

  function ChinchPacketIncludesPayload(PktType : ChinchPacketType_t;
                                       PktLength : ChinchPacketLength_t
                                      ) return boolean;

  function ChinchPacketRequiresResponse(PktType : ChinchPacketType_t)
                                                           return boolean;

  function ChinchPacketReqWrite(PktType : ChinchPacketType_t)
                                                           return boolean;

  function ChinchPacketReqRead(PktType : ChinchPacketType_t)
                                                           return boolean;

  function ChinchPacketResWrite(PktType : ChinchPacketType_t)
                                                           return boolean;

  function ChinchPacketResRead(PktType : ChinchPacketType_t)
                                                           return boolean;

  function ChinchPacketEndOfRecord(Header : ChinchPacketWord_t)
                                                           return boolean;

  function ChinchPacketDoneFlag(Header : ChinchPacketWord_t)
                                                           return boolean;

end PkgChinch;

package body PkgChinch is

  
  function Pow2(Num : integer) return integer is
    variable temp, pow : integer;
  begin
    temp := Num;
    pow := 1;
    while (temp /= 0) loop
      temp := temp - 1;
      pow := pow * 2;
    end loop;
    return pow;
  end Pow2;



  
  function Pow2(Num : unsigned) return unsigned is
    variable ReturnVal : unsigned(Pow2(Num'length) - 1 downto 0);
  begin
    for i in ReturnVal'range loop
      if i = to_integer(Num) then
        ReturnVal(i) := '1';
      else
        ReturnVal(i) := '0';
      end if;
    end loop;
    return ReturnVal;
  end Pow2;



  
  function HowManyOnes(Vec : std_logic_vector) return natural is
    variable ReturnVal : natural := 0;
  begin
    for i in Vec'range loop
      if Vec(i) = '1' then
        ReturnVal := ReturnVal + 1;
      end if;
    end loop;
    return ReturnVal;
  end HowManyOnes;



  
  function AddressInWindow(WindowEnable : std_logic;
                           WindowSize : unsigned(4 downto 0);
                           WindowBase : unsigned(31 downto 0);
                           Address : unsigned(31 downto 0)) return boolean is
    variable SizeMask, ModAddress, ModWindowBase : unsigned(31 downto 3);
  begin
    for i in 31 downto 3 loop
      if i >= to_integer(WindowSize) then
        SizeMask(i) := '1';
      else
        SizeMask(i) := '0';
      end if;
    end loop;
    ModAddress := Address(31 downto 3) and SizeMask;
    ModWindowBase := WindowBase(31 downto 3) and SizeMask;
    return (WindowEnable = '1' and
            ModAddress = ModWindowBase);
  end AddressInWindow;



  function CropAddress(WindowSize : unsigned(4 downto 0);
                       Address : unsigned) return unsigned is
    variable SizeMask, ReturnVal : unsigned(Address'range);
  begin
    for i in SizeMask'range loop
      if i >= to_integer(WindowSize) then
        SizeMask(i) := '0';
      else
        SizeMask(i) := '1';
      end if;
    end loop;
    ReturnVal := Address and SizeMask;
    return ReturnVal;
  end CropAddress;



  function GetDecodeBits(WindowSize : unsigned(4 downto 0))
                                           return unsigned is
    variable SizeMask : unsigned(31 downto 0);
  begin
    for i in 31 downto 0 loop
      if i >= to_integer(WindowSize) then
        SizeMask(i) := '1';
      else
        SizeMask(i) := '0';
      end if;
    end loop;
    return SizeMask;
  end GetDecodeBits;



  function PageAddress(WindowSize : unsigned(4 downto 0);
                       WindowPage : unsigned(31 downto 0);
                       Address : unsigned(31 downto 0)) return unsigned is
    variable ReturnVal : unsigned(Address'range);
  begin
    for i in Address'range loop
      if (i > 7) and (i >= to_integer(WindowSize)) then
        ReturnVal(i) := WindowPage(i);
      else
        ReturnVal(i) := Address(i);
      end if;
    end loop;
    return ReturnVal;
  end PageAddress;



  function CalcSizeLimitFromAddress(Address : unsigned(15 downto 0);
                                    AddressBoundaryLog2 : unsigned(3 downto 0);
                                    ProgSizeLimit : unsigned(15 downto 0))
           return unsigned is
    variable CroppedAddress : unsigned(15 downto 0);
    variable ProgLimit, BoundLimit, ReturnVal : unsigned(15 downto 0);
  begin
    
    
    
    
    
    
    
    ProgLimit := ProgSizeLimit - resize(Address(1 downto 0), ProgLimit'length);
    
    
    
    CroppedAddress := CropAddress(resize(AddressBoundaryLog2, 5), Address);
    BoundLimit := Pow2(AddressBoundaryLog2) - CroppedAddress;
    if ProgLimit < BoundLimit then
      ReturnVal := ProgLimit;
    else
      ReturnVal := BoundLimit;
    end if;
    return ReturnVal;
  end CalcSizeLimitFromAddress;



  function CalcCompletionLimit(Address : unsigned(15 downto 0);
                               ProgSizeLimit : unsigned(3 downto 0))
      return unsigned is
    variable CroppedAddress, ReturnVal : unsigned(15 downto 0);
  begin
    CroppedAddress := CropAddress(resize(ProgSizeLimit, 5), Address);
    ReturnVal := Pow2(ProgSizeLimit) - CroppedAddress;
    return ReturnVal;
  end CalcCompletionLimit;



  
  
  function ChinchGetDMA_SPACE_Log2(DMA_Type : natural) return natural is
  begin
    return 8;
  end ChinchGetDMA_SPACE_Log2;



  
  
  function ChinchGetDMA_BASE(SpacePerLog2 : natural; NumChansLog2 : natural)
    return unsigned is
    variable ReturnVal : unsigned(31 downto 0);
  begin
    ReturnVal := X"00002000";
    return ReturnVal;
  end ChinchGetDMA_BASE;



  
  function ChinchPacketGetType(Header : ChinchPacketWord_t)
    return ChinchPacketType_t is
    variable ReturnVal : ChinchPacketType_t;
  begin
    ReturnVal := Header(2 downto 0);
    return ReturnVal;
  end ChinchPacketGetType;



  
  function ChinchPacketGetSpc(Header : ChinchPacketWord_t)
    return ChinchPacketSpc_t is
    variable ReturnVal : ChinchPacketSpc_t;
  begin
    ReturnVal := Header(4 downto 3);
    return ReturnVal;
  end ChinchPacketGetSpc;



  
  function ChinchPacketGetLabel(Header : ChinchPacketWord_t)
    return ChinchPacketLabel_t is
    variable ReturnVal : ChinchPacketLabel_t;
  begin
    ReturnVal := unsigned(Header(16 downto 5));
    return ReturnVal;
  end ChinchPacketGetLabel;



  
  function ChinchPacketGetLength(Header : ChinchPacketWord_t)
    return ChinchPacketLength_t is
    variable ReturnVal : ChinchPacketLength_t;
  begin
    ReturnVal := unsigned(Header(31 downto 17));
    return ReturnVal;
  end ChinchPacketGetLength;



  
  function ChinchPacketGetAddress(Header : ChinchPacketWord_t)
    return ChinchPacketAddress_t is
    variable ReturnVal : ChinchPacketAddress_t;
  begin
    ReturnVal := unsigned(Header(63 downto 32));
    return ReturnVal;
  end ChinchPacketGetAddress;



  
  function ChinchPacketGetCompletionStatus(Header : ChinchPacketWord_t)
    return ChinchPacketCompletionStatus_t is
    variable ReturnVal : ChinchPacketCompletionStatus_t;
  begin
    ReturnVal := Header(63 downto 62);
    return ReturnVal;
  end ChinchPacketGetCompletionStatus;



  
  function ChinchPacketGetRemainingCount(Header : ChinchPacketWord_t)
    return ChinchPacketRemainingCount_t is
    variable ReturnVal : ChinchPacketRemainingCount_t;
  begin
    ReturnVal := unsigned(Header(58 downto 44));
    return ReturnVal;
  end ChinchPacketGetRemainingCount;



  
  function ChinchPacketGetUpperAddress(Header : ChinchPacketWord_t)
    return ChinchPacketUpperAddress_t is
    variable ReturnVal : ChinchPacketUpperAddress_t;
  begin
    ReturnVal := unsigned(Header(63 downto 32));
    return ReturnVal;
  end ChinchPacketGetUpperAddress;



  
  function ChinchPacketGetStream(Header : ChinchPacketWord_t)
    return ChinchPacketStream_t is
    variable ReturnVal : ChinchPacketStream_t;
  begin
    ReturnVal := unsigned(Header(59 downto 44));
    return ReturnVal;
  end ChinchPacketGetStream;



  
  function ChinchPacketBuildHeader(
                   PktType : ChinchPacketType_t;
                   Spc : ChinchPacketSpc_t;
                   PktLabel : ChinchPacketLabel_t;
                   PktLength : ChinchPacketLength_t;
                   Address : ChinchPacketAddress_t;
                   CompletionStatus : ChinchPacketCompletionStatus_t;
                   RemainingCount : ChinchPacketRemainingCount_t;
                   Stream : ChinchPacketStream_t;
                   EndOfRecordFlag : boolean := false;
                   DoneFlag : boolean := false
                                  ) return ChinchPacketWord_t is
    variable ReturnVal : ChinchPacketWord_t;
  begin
    ReturnVal := (others => '0');
    ReturnVal(2 downto 0) := PktType;
    ReturnVal(4 downto 3) := Spc;
    ReturnVal(16 downto 5) := std_logic_vector(PktLabel);
    ReturnVal(31 downto 17) := std_logic_vector(PktLength);
    if ChinchPacketRequest(PktType) then
      if Spc = kChinchPacketSpcStream then
        ReturnVal(41 downto 32) :=
                          std_logic_vector(Address(9 downto 0));
        if DoneFlag then
          ReturnVal(42) := '1';   
        else
          ReturnVal(42) := '0';
        end if;
        if EndOfRecordFlag then
          ReturnVal(43) := '1';   
        else
          ReturnVal(43) := '0';
        end if;
        ReturnVal(59 downto 44) := std_logic_vector(Stream);
        ReturnVal(63 downto 60) :=
                          std_logic_vector(Address(31 downto 28));
      else
        ReturnVal(63 downto 32) := std_logic_vector(Address);
      end if;
    else
      if Spc = kChinchPacketSpcStream then
        ReturnVal(43 downto 32) :=
                          std_logic_vector(Address(11 downto 0));
        ReturnVal(59 downto 44) := std_logic_vector(Stream);
        ReturnVal(63 downto 62) := CompletionStatus;
      else
        ReturnVal(43 downto 32) :=
                          std_logic_vector(Address(11 downto 0));
        ReturnVal(58 downto 44) := std_logic_vector(RemainingCount);
        ReturnVal(63 downto 62) := CompletionStatus;
      end if;
    end if;
    return ReturnVal;
  end ChinchPacketBuildHeader;



  
  function ChinchPacketBuildExtendedHeader(
                   Spc : ChinchPacketSpc_t;
                   UpperAddress : ChinchPacketUpperAddress_t
                                          ) return ChinchPacketWord_t is
    variable ReturnVal : ChinchPacketWord_t;
  begin
    ReturnVal := (others => '0');
    ReturnVal(4 downto 3) := Spc;
    ReturnVal(63 downto 32) := std_logic_vector(UpperAddress);
    return ReturnVal;
  end ChinchPacketBuildExtendedHeader;



  
  
  
  
  function ChinchPacketPayloadWords(PktLength : ChinchPacketLength_t;
                                    Address : unsigned;
                                    Width : natural) return unsigned is
    variable ReturnVal : unsigned(Width - 1 downto 0);
  begin
    ReturnVal := PktLength(Width + 2 downto 3);   
    if (PktLength(2 downto 0) /= "000") or
       (Address(2 downto 0) /= "000") then
      ReturnVal := ReturnVal + 1;
    end if;
    if (resize(PktLength(2 downto 0), 4) +
        resize(Address(2 downto 0), 4)) > 8 then
      ReturnVal := ReturnVal + 1;
    end if;
    return ReturnVal;
  end ChinchPacketPayloadWords;



  
  
  function ChinchPacketMaxPayloadWords(PayloadSize : natural)
                                        return natural is
  begin
    if PayloadSize < 2 then
      return 1;
    elsif PayloadSize < 10 then
      return 2;
    else
      return (PayloadSize / 8) + 1;
    end if;
  end ChinchPacketMaxPayloadWords;



  
  function ChinchPacketRequest(PktType : ChinchPacketType_t)
                                            return boolean is
  begin
    return (PktType(1) = '0');
  end ChinchPacketRequest;



  
  function ChinchPacketResponse(PktType : ChinchPacketType_t)
                                            return boolean is
  begin
    return (PktType(1) = '1');
  end ChinchPacketResponse;



  
  function ChinchPacketHeaderExtended(Spc : ChinchPacketSpc_t
                                     ) return boolean is
  begin
    return (Spc = kChinchPacketSpcExtHeader);
  end ChinchPacketHeaderExtended;


  function ChinchPacketHasPayload(Header : ChinchPacketWord_t)
    return boolean is
  begin
    return (ChinchPacketGetType(Header)(2) = '1' and
            ChinchPacketGetLength(Header) > 0);
  end ChinchPacketHasPayload;

  
  function ChinchPacketIncludesPayload(PktType : ChinchPacketType_t;
                                       PktLength : ChinchPacketLength_t
                                      ) return boolean is
  begin
    return (PktType(2) = '1' and
            PktLength > 0);
  end ChinchPacketIncludesPayload;



  
  function ChinchPacketRequiresResponse(PktType : ChinchPacketType_t)
                                           return boolean is
  begin
    return (PktType(0) = '1');
  end ChinchPacketRequiresResponse;



  
  function ChinchPacketReqWrite(PktType : ChinchPacketType_t)
                                           return boolean is
  begin
    return (PktType(2) = '1');
  end ChinchPacketReqWrite;



  
  function ChinchPacketReqRead(PktType : ChinchPacketType_t)
                                           return boolean is
  begin
    return (PktType(2) = '0');
  end ChinchPacketReqRead;



  
  function ChinchPacketResWrite(PktType : ChinchPacketType_t)
                                           return boolean is
  begin
    return (PktType(2) = '0');
  end ChinchPacketResWrite;



  
  function ChinchPacketResRead(PktType : ChinchPacketType_t)
                                           return boolean is
  begin
    return (PktType(2) = '1');
  end ChinchPacketResRead;



  
  function ChinchPacketEndOfRecord(Header : ChinchPacketWord_t)
                                           return boolean is
  begin
    return (Header(43) = '1');
  end ChinchPacketEndOfRecord;



  
  function ChinchPacketDoneFlag(Header : ChinchPacketWord_t)
                                           return boolean is
  begin
    return (Header(42) = '1');
  end ChinchPacketDoneFlag;

end PkgChinch;