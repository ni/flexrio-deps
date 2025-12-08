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

  use work.PkgDmaPortCommIfcArbiter.all;

  
  
  use work.PkgCommunicationInterface.all;
  use work.PkgDmaPortCommunicationInterface.all;

  
  
  use work.PkgCommIntConfiguration.all;

  
   use work.PkgNiDmaConfig.all;

  
  use work.PkgDmaPortDmaFifos.all;
  use work.PkgDmaPortDmaFifosFlatTypes.all;

  
  
  use work.PkgNiDma.all;

  
  use work.PkgDmaPortCommIfcMasterPort.all;
  use work.PkgDmaPortCommIfcMasterPortFlatTypes.all;

  use work.PkgDmaPortCommIfcInputDataControl.all;

entity DmaPortFixedDmaCommunicationInterface is
  port(

    
    aReset : in boolean;

    
    dReset : in boolean;

    
    DmaClk : in std_logic;
    
    IrqClk : in std_logic;

    
    
    

    dNiDmaInputRequestToDma : out NiDmaInputRequestToDma_t;
    dNiDmaInputRequestFromDma : in NiDmaInputRequestFromDma_t;
    dNiDmaInputDataToDma : out NiDmaInputDataToDma_t;
    dNiDmaInputDataFromDma : in NiDmaInputDataFromDma_t;
    dNiDmaInputStatusFromDma : in NiDmaInputStatusFromDma_t;

    dNiDmaOutputRequestToDma : out NiDmaOutputRequestToDma_t;
    dNiDmaOutputRequestFromDma : in NiDmaOutputRequestFromDma_t;
    dNiDmaOutputDataFromDma : in NiDmaOutputDataFromDma_t;

    dNiDmaHighSpeedSinkFromDma : in NiDmaHighSpeedSinkFromDma_t;

    
    
    

    
    dInputStreamInterfaceFromFifo : in
      InputStreamInterfaceFromFifoArray_t(Larger(kNumberOfDmaChannels,1)-1 downto 0);
    dInputStreamInterfaceToFifo : out
      InputStreamInterfaceToFifoArray_t(Larger(kNumberOfDmaChannels,1)-1 downto 0);
    dOutputStreamInterfaceFromFifo : in
      OutputStreamInterfaceFromFifoArray_t(Larger(kNumberOfDmaChannels,1)-1 downto 0);
    dOutputStreamInterfaceToFifo : out
      OutputStreamInterfaceToFifoArray_t(Larger(kNumberOfDmaChannels,1)-1 downto 0);

    
    
    

    dNiFpgaMasterWriteRequestFromMasterArray : in
      NiFpgaMasterWriteRequestFromMasterArray_t (Larger(kNumberOfMasterPorts,1)-1 downto 0);
    dNiFpgaMasterWriteRequestToMasterArray : out
      NiFpgaMasterWriteRequestToMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);
    dNiFpgaMasterWriteDataFromMasterArray : in
      NiFpgaMasterWriteDataFromMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);
    dNiFpgaMasterWriteDataToMasterArray : out
      NiFpgaMasterWriteDataToMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);
    dNiFpgaMasterWriteStatusToMasterArray : out
      NiFpgaMasterWriteStatusToMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);

    dNiFpgaMasterReadRequestFromMasterArray : in
      NiFpgaMasterReadRequestFromMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);
    dNiFpgaMasterReadRequestToMasterArray : out
      NiFpgaMasterReadRequestToMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);
    dNiFpgaMasterReadDataToMasterArray : out
      NiFpgaMasterreadDataToMasterArray_t(Larger(kNumberOfMasterPorts,1)-1 downto 0);

    
    
    

    dNiFpgaInputRequestToDmaArray: in 
      NiDmaInputRequestToDmaArray_t (kNiFpgaFixedInputPorts-1 downto 0);
    dNiFpgaInputRequestFromDmaArray: out 
      NiDmaInputRequestFromDmaArray_t (kNiFpgaFixedInputPorts-1 downto 0);
    dNiFpgaInputDataToDmaArray: in 
      NiDmaInputDataToDmaArray_t (kNiFpgaFixedInputPorts-1 downto 0);
    dNiFpgaInputDataFromDmaArray: out 
      NiDmaInputDataFromDmaArray_t (kNiFpgaFixedInputPorts-1 downto 0);
    dNiFpgaInputStatusFromDmaArray: out 
      NiDmaInputStatusFromDmaArray_t (kNiFpgaFixedInputPorts-1 downto 0);

    dNiFpgaOutputRequestToDmaArray: in 
      NiDmaOutputRequestToDmaArray_t (kNiFpgaFixedOutputPorts-1 downto 0);
    dNiFpgaOutputRequestFromDmaArray: out 
      NiDmaOutputRequestFromDmaArray_t (kNiFpgaFixedOutputPorts-1 downto 0);
    dNiFpgaOutputDataFromDmaArray: out 
      NiDmaOutputDataFromDmaArray_t (kNiFpgaFixedOutputPorts-1 downto 0);

    dNiFpgaInputArbReq : in 
      NiDmaArbReqArray_t(kNiFpgaFixedInputPorts-1 downto 0);
    dNiFpgaInputArbGrant : out 
      NiDmaArbGrantArray_t(kNiFpgaFixedInputPorts-1 downto 0);
    dNiFpgaOutputArbReq : in 
      NiDmaArbReqArray_t(kNiFpgaFixedOutputPorts-1 downto 0);
    dNiFpgaOutputArbGrant : out 
      NiDmaArbGrantArray_t(kNiFpgaFixedOutputPorts-1 downto 0);

    
    
    

    
    iLvFpgaIrq : in IrqToInterfaceArray_t(Larger(kNumberOfIrqs,1)-1 downto 0);

    
    
    
    
    dFixedLogicDmaIrq : in IrqStatusArray_t;

    
    dIrq : out std_logic_vector(kNumberOfIrqs-1 downto 0);


    
    
    

    
    
    dRegPortIn   : in RegPortIn_t;

    
    
    dRegPortOut  : out  RegPortOut_t

  );
end DmaPortFixedDmaCommunicationInterface;

architecture struct of DmaPortFixedDmaCommunicationInterface is

  constant kNumOfInStrms : natural := NumOfInStrms(kDmaFifoConfArray);
  constant kNumOfOutStrms : natural := NumOfOutStrms(kDmaFifoConfArray);
  constant kNumOfSinkStrms : natural := NumOfSinkStrms(kDmaFifoConfArray);
  constant kNumOfWriteMasterPorts : natural := NumOfWriteMasterPorts(kMasterPortConfArray);
  constant kNumOfReadMasterPorts : natural := NumOfReadMasterPorts(kMasterPortConfArray);

  
  
  
  
  
  
  
  
  
  
  constant kInputStreamEvictionTimeout : natural := 128;


  
  constant kFifoDepthInSamples : DmaChannelConfArray_t(kDmaFifoConfArray'range)
     := GetFifoDepthsInSamples(kDmaFifoConfArray);

  signal dInStrmsRegPortOut: RegPortOutArray_t(ArbVecMSB(kNumOfInStrms) downto 0);
  signal dOutStrmsRegPortOut: RegPortOutArray_t(ArbVecMSB(kNumOfOutStrms) downto 0);
  signal dSinkStrmsRegPortOut: RegPortOutArray_t(ArbVecMSB(kNumOfSinkStrms) downto 0);
  signal dDmaIrq: IrqStatusArray_t(Larger(kNumberOfDmaChannels, 1)-1 downto 0);

  signal dMasterWriteAccDoneStrbArray:
    AccDoneStrbArray_t(ArbVecMSB(kNumOfWriteMasterPorts) downto 0);
  signal dMasterReadAccDoneStrbArray:
    AccDoneStrbArray_t(ArbVecMSB(kNumOfReadMasterPorts) downto 0);

  signal dInStrmsAccDoneStrbArray:
    AccDoneStrbArray_t(ArbVecMSB(kNumOfInStrms) downto 0);
  signal dOutStrmsAccDoneStrbArray:
    AccDoneStrbArray_t(ArbVecMSB(kNumOfOutStrms) downto 0);
  signal dSinkStrmsAccDoneStrbArray:
    AccDoneStrbArray_t(ArbVecMSB(kNumOfSinkStrms) downto 0);

  signal dNiFpgaMasterWriteRequestToDmaArray: NiDmaInputRequestToDmaArray_t
    (Larger(kNumOfWriteMasterPorts,1)-1 downto 0);
  signal dNiFpgaMasterReadRequestToDmaArray: NiDmaOutputRequestToDmaArray_t
    (Larger(kNumOfReadMasterPorts,1)-1 downto 0);

  signal dNiDmaInputRequestToDmaArray: NiDmaInputRequestToDmaArray_t
    (Larger(kNumOfInStrms,1)-1 downto 0);
  signal dNiDmaOutputRequestToDmaArray: NiDmaOutputRequestToDmaArray_t
    (Larger(kNumOfOutStrms,1)-1 downto 0);
  signal dNiDmaSinkRequestToDmaArray: NiDmaInputRequestToDmaArray_t
    (Larger(kNumOfSinkStrms,1)-1 downto 0);

  signal dNiDmaOutputDataFromDmaArray: NiDmaOutputDataFromDmaArray_t
    (Larger(kNumOfOutStrms,1)-1 downto 0);

    signal dNiFpgaMasterWriteDataToDmaArray: NiDmaInputDataToDmaArray_t
    (Larger(kNumOfWriteMasterPorts,1)-1 downto 0);

  signal dInStrmsAccEmergencyReq: std_logic_vector(ArbVecMSB(kNumOfInStrms)downto 0);
  signal dOutStrmsAccEmergencyReq: std_logic_vector(ArbVecMSB(kNumOfOutStrms)downto 0);
  signal dSinkStrmsAccEmergencyReq: std_logic_vector(ArbVecMSB(kNumOfSinkStrms)downto 0);
  signal dInStrmsAccNormalReq: std_logic_vector(ArbVecMSB(kNumOfInStrms)downto 0);
  signal dOutStrmsAccNormalReq: std_logic_vector(ArbVecMSB(kNumOfOutStrms)downto 0);
  signal dSinkStrmsAccNormalReq: std_logic_vector(ArbVecMSB(kNumOfSinkStrms)downto 0);
  signal dMasterWriteAccEmergencyReq: std_logic_vector(ArbVecMSB(kNumOfWriteMasterPorts)downto 0);
  signal dMasterReadAccEmergencyReq: std_logic_vector(ArbVecMSB(kNumOfReadMasterPorts)downto 0);
  signal dMasterWriteAccGrant: std_logic_vector(ArbVecMSB(kNumOfWriteMasterPorts)downto 0);
  signal dMasterReadAccGrant: std_logic_vector(ArbVecMSB(kNumOfReadMasterPorts)downto 0);
  signal dNiFpgaMasterWriteDataToDmaValidArray: BooleanVector(ArbVecMSB(kNumOfWriteMasterPorts)downto 0);
  signal dRegPortOutArray : RegPortOutArray_t(2 downto 0);
  signal dSinkStreamDataToDmaValid : boolean;
  signal dSinkArbAccGrant : std_logic_vector(ArbVecMSB(kNumOfSinkStrms)downto 0);
  signal dRegPortInReg : RegPortIn_t;
  signal dRegPortInReg2 : RegPortIn_t;
  signal dRegPortOutToReg : RegPortOut_t;
  signal dNiDmaOutputDataFromDmaReg : NiDmaOutputDataFromDma_t;
  signal dNiDmaInputStatusFromDmaReg : NiDmaInputStatusFromDma_t;
  signal dNiDmaHighSpeedSinkFromDmaReg : NiDmaHighSpeedSinkFromDma_t;
  signal dInArbAccDoneStrb: std_logic;
  signal dOutArbAccDoneStrb: std_logic;

  signal dInArbAccEmergencyReq: std_logic_vector(ArbVecMSB(
                                kNiFpgaFixedInputPorts
                              + Larger(kNumOfInStrms,1)
                              + Larger(kNumOfWriteMasterPorts,1)
                              + Larger(kNumOfSinkStrms,1))
                              downto 0);

  signal dInArbAccGrant: std_logic_vector(ArbVecMSB(
                                kNiFpgaFixedInputPorts
                              + Larger(kNumOfInStrms,1)
                              + Larger(kNumOfWriteMasterPorts,1)
                              + Larger(kNumOfSinkStrms,1))
                              downto 0);

  signal dInArbAccNormalReq: std_logic_vector(ArbVecMSB(
                                kNiFpgaFixedInputPorts
                              + Larger(kNumOfInStrms,1)
                              + Larger(kNumOfWriteMasterPorts,1)
                              + Larger(kNumOfSinkStrms,1))
                              downto 0);

  signal dOutArbAccEmergencyReq: std_logic_vector(ArbVecMSB(
                                kNiFpgaFixedOutputPorts 
                              + Larger(kNumOfOutStrms,1)
                              + Larger(kNumOfReadMasterPorts,1))
                              downto 0);

  signal dOutArbAccNormalReq: std_logic_vector(ArbVecMSB(
                                kNiFpgaFixedOutputPorts 
                              + Larger(kNumOfOutStrms,1)
                              + Larger(kNumOfReadMasterPorts,1))
                              downto 0);

  signal dOutArbAccGrant: std_logic_vector(ArbVecMSB(
                                kNiFpgaFixedOutputPorts 
                              + Larger(kNumOfOutStrms,1)
                              + Larger(kNumOfReadMasterPorts,1))
                              downto 0);

  
  signal dInputDataFromSinkStreamArray: NiDmaInputDataToDmaArray_t(Larger(kNumOfSinkStrms,1)-1 downto 0);
  signal dInputDataFromSinkStreamValidArray: BooleanVector(Larger(kNumOfSinkStrms,1)-1 downto 0);
  signal dInputDataInterfaceFromFifoArray: NiDmaInputDataToDmaArray_t(Larger(kNumOfInStrms,1)-1 downto 0);
  signal dInputDataInterfaceToFifoArray: NiDmaInputDataFromDmaArray_t(Larger(kNumOfInStrms,1)-1 downto 0);
  signal dInputStreamDataFromDma: NiDmaInputDataFromDma_t;
  signal dInputStreamDataToDma: NiDmaInputDataToDma_t;
  signal dNiFpgaInputDataToDmaDelayed: NiDmaInputDataToDma_t ;
  signal dSinkStreamDataToDma: NiDmaInputDataToDma_t;
  

  
  
  
  
  

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  function GetInStrmIndex return StrmIndex_t is
    variable rVal : StrmIndex_t(kNumberOfDmaChannels-1 downto 0);
    variable StrmCount : natural;
  begin

    
    
    for i in kNumberOfDmaChannels-1 downto 0 loop
      StrmCount := 0;
      for j in i-1 downto 0 loop
        if kDmaFifoConfArray(j).Mode = NiFpgaTargetToHost or kDmaFifoConfArray(j).Mode
           = NiFpgaPeerToPeerWriter then
          StrmCount := StrmCount + 1;
        end if;
      end loop;
      rVal(i) := StrmCount;
    end loop;

    return rVal;

  end GetInStrmIndex;

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  function GetOutStrmIndex return StrmIndex_t is
    variable rVal : StrmIndex_t(kNumberOfDmaChannels-1 downto 0);
    variable StrmCount : natural;
  begin

    for i in kNumberOfDmaChannels-1 downto 0 loop
      StrmCount := 0;
      for j in i-1 downto 0 loop
        if kDmaFifoConfArray(j).Mode = NiFpgaHostToTarget then
          StrmCount := StrmCount + 1;
        end if;
      end loop;
      rVal(i) := StrmCount;
    end loop;

    return rVal;

  end GetOutStrmIndex;

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  function GetSinkStrmIndex return StrmIndex_t is
    variable rVal : StrmIndex_t(kNumberOfDmaChannels-1 downto 0);
    variable StrmCount : natural;
  begin

    
    
    for i in kNumberOfDmaChannels-1 downto 0 loop
      StrmCount := 0;
      for j in i-1 downto 0 loop
        if kDmaFifoConfArray(j).Mode = NiFpgaPeerToPeerReader then
          StrmCount := StrmCount + 1;
        end if;
      end loop;
      rVal(i) := StrmCount;
    end loop;

    return rVal;

  end GetSinkStrmIndex;


  
  
  
  
  
  
  
  
  
  
  
  
  
  

  function GetWriteMasterPortIndex return StrmIndex_t is
    variable rVal : StrmIndex_t(kNumberOfMasterPorts-1 downto 0);
    variable MasterPortCount : natural;
  begin

    for i in kNumberOfMasterPorts-1 downto 0 loop
      MasterPortCount := 0;
      for j in i-1 downto 0 loop
        if kMasterPortConfArray(j).Mode = NiFpgaMasterPortWriteRead or
           kMasterPortConfArray(j).Mode = NiFpgaMasterPortWrite then

          MasterPortCount := MasterPortCount + 1;
        end if;
      end loop;
      rVal(i) := MasterPortCount;
    end loop;

    return rVal;

  end GetWriteMasterPortIndex;

  
  
  
  
  
  
  
  
  
  
  
  
  
  

  function GetReadMasterPortIndex return StrmIndex_t is
    variable rVal : StrmIndex_t(kNumberOfMasterPorts-1 downto 0);
    variable MasterPortCount : natural;
  begin

    for i in kNumberOfMasterPorts-1 downto 0 loop
      MasterPortCount := 0;
      for j in i-1 downto 0 loop
        if kMasterPortConfArray(j).Mode = NiFpgaMasterPortWriteRead or
           kMasterPortConfArray(j).Mode = NiFpgaMasterPortRead then

          MasterPortCount := MasterPortCount + 1;
        end if;
      end loop;
      rVal(i) := MasterPortCount;
    end loop;

    return rVal;

  end GetReadMasterPortIndex;

  constant kInStrmIndex : StrmIndex_t(kNumberOfDmaChannels-1 downto 0) := GetInStrmIndex;
  constant kOutStrmIndex : StrmIndex_t(kNumberOfDmaChannels-1 downto 0) :=
    GetOutStrmIndex;
  constant kSinkStrmIndex : StrmIndex_t(kNumberOfDmaChannels-1 downto 0) :=
    GetSinkStrmIndex;
  constant kMasterWriteIndex : StrmIndex_t(kNumberOfMasterPorts-1 downto 0) :=
    GetWriteMasterPortIndex;
  constant kMasterReadIndex : StrmIndex_t(kNumberOfMasterPorts-1 downto 0) :=
    GetReadMasterPortIndex;

begin

  
  
  
  
  
  
  
  
  RegPort: process (aReset, DmaClk)
  begin
    if aReset then
      dRegPortInReg2.Data <= kRegPortInZero.Data;
      dRegPortInReg2.Rd <= kRegPortInZero.Rd;
      dRegPortInReg2.Wt <= kRegPortInZero.Wt;
      dRegPortInReg <= kRegPortInZero;
      dRegPortOut <= kRegPortOutZero;
    elsif rising_edge(DmaClk) then
      dRegPortInReg2.Data <= dRegPortInReg.Data;
      dRegPortInReg2.Rd <= dRegPortInReg.Rd;
      dRegPortInReg2.Wt <= dRegPortInReg.Wt;
      
      dRegPortInReg <= dRegPortIn;
      
      dRegPortOut.Data <= dRegPortOutToReg.Data;
      dRegPortOut.DataValid <= dRegPortOutToReg.DataValid;
      dRegPortOut.Ready <= dRegPortOutToReg.Ready and (not dRegPortInReg.Wt) and (not dRegPortInReg.Rd)
                                                  and (not dRegPortInReg2.Wt) and (not dRegPortInReg2.Rd);
    end if;
  end process;
  
  
  dRegPortInReg2.Address <= dRegPortInReg.Address;

  
  
  
  
  RegOutputDataFromDma: process (aReset, DmaClk)
  begin
    if aReset then
      dNiDmaOutputDataFromDmaReg <= kNiDmaOutputDataFromDmaZero;
    elsif rising_edge(DmaClk) then
      dNiDmaOutputDataFromDmaReg <= dNiDmaOutputDataFromDma;
    end if;
  end process;
  
  
  
  
  DmaInputStatusRegProc : process (aReset, DmaClk)
  begin
    if aReset then
      dNiDmaInputStatusFromDmaReg <= kNiDmaInputStatusFromDmaZero;
    elsif rising_edge(DmaClk) then
      dNiDmaInputStatusFromDmaReg <= dNiDmaInputStatusFromDma;
    end if;
  end process DmaInputStatusRegProc;

  
  
  
  DmaHighSpeedSinkRegProc : process (aReset, DmaClk)
  begin
    if aReset then
      dNiDmaHighSpeedSinkFromDmaReg <= kNiDmaHighSpeedSinkFromDmaZero;
    elsif rising_edge(DmaClk) then
      dNiDmaHighSpeedSinkFromDmaReg <= dNiDmaHighSpeedSinkFromDma;
    end if;
  end process DmaHighSpeedSinkRegProc;

  
  
  DmaBlk:block
  begin

    NoInStrms: if kNumOfInStrms = 0 generate

      dNiDmaInputRequestToDmaArray(0) <= kNiDmaInputRequestToDmaZero;
      dInputDataInterfaceFromFifoArray(0) <= kNiDmaInputDataToDmaZero;
      dInStrmsRegPortOut(0) <= kRegPortOutZero;
      dInStrmsAccDoneStrbArray(0) <= '0';
      dInStrmsAccNormalReq(0) <= '0';
      dInStrmsAccEmergencyReq(0) <= '0';

    end generate; 

    NoOutStrms: if kNumOfOutStrms = 0 generate

      dNiDmaOutputRequestToDmaArray(0) <= kNiDmaOutputRequestToDmaZero;
      dOutStrmsRegPortOut(0) <= kRegPortOutZero;
      dOutStrmsAccDoneStrbArray(0) <= '0';
      dOutStrmsAccNormalReq(0) <= '0';
      dOutStrmsAccEmergencyReq(0) <= '0';

    end generate; 

    NoSinkStrms: if kNumOfSinkStrms = 0 generate

      dNiDmaSinkRequestToDmaArray(0) <= kNiDmaInputRequestToDmaZero;
      dInputDataFromSinkStreamValidArray(0) <= false;
      dSinkStrmsRegPortOut(0) <= kRegPortOutZero;
      dSinkStrmsAccDoneStrbArray(0) <= '0';
      dSinkStrmsAccNormalReq(0) <= '0';
      dSinkStrmsAccEmergencyReq(0) <= '0';

    end generate; 

    NoDmaPorts: if kNumberOfDmaChannels = 0 generate
      dDmaIrq(0) <= kIrqStatusToInterfaceZero;
    end generate; 

    DmaComponents: for i in 0 to kNumberOfDmaChannels - 1 generate

      DmaInput: if kDmaFifoConfArray(i).Mode = NiFpgaTargetToHost or
                   kDmaFifoConfArray(i).Mode = NiFpgaPeerToPeerWriter generate

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        DmaPortCommIfcInputStreamx: entity work.DmaPortCommIfcInputStream (structure)
          generic map (
            kFifoDepth        => kFifoDepthInSamples(i).FifoDepth,
            kSampleWidth      => kDmaFifoConfArray(i).FifoWidth,
            kBaseOffset       => kDmaFifoConfArray(i).BaseAddress,
            kStreamNumber     => i,
            kEvictionTimeout  => kInputStreamEvictionTimeout,
            kPeerToPeerStream => (kDmaFifoConfArray(i).Mode = NiFpgaPeerToPeerWriter),
            kFxpType          => kDmaFifoConfArray(i).FxpType)
          port map (
            aReset                        => aReset,                                     
            bReset                        => dReset,                                     
            BusClk                        => DmaClk,                                     
            bNiDmaInputRequestToDma       => dNiDmaInputRequestToDmaArray(kInStrmIndex(i)),
            bNiDmaInputRequestFromDma     => dNiDmaInputRequestFromDma,                  
            bNiDmaInputStatusFromDma      => dNiDmaInputStatusFromDmaReg,                
            bInputDataInterfaceFromFifo   => dInputDataInterfaceFromFifoArray(kInStrmIndex(i)),
            bInputDataInterfaceToFifo     => dInputDataInterfaceToFifoArray(kInStrmIndex(i)),
            bArbiterNormalReq             => dInStrmsAccNormalReq(kInStrmIndex(i)),      
            bArbiterEmergencyReq          => dInStrmsAccEmergencyReq(kInStrmIndex(i)),
            bArbiterDone                  => dInStrmsAccDoneStrbArray(kInStrmIndex(i)),
            bArbiterGrant                 => dInArbAccGrant(kInStrmIndex(i)),            
            bRegPortIn                    => dRegPortInReg2,                             
            bRegPortOut                   => dInStrmsRegPortOut(kInStrmIndex(i)),        
            bInputStreamInterfaceToFifo   => dInputStreamInterfaceToFifo(i),             
            bInputStreamInterfaceFromFifo => dInputStreamInterfaceFromFifo(i),           
            bIrq                          => dDmaIrq(i));                                


        dOutputStreamInterfaceToFifo(i) <= kOutputStreamInterfaceToFifoZero;

      end generate; 

      DmaOutputP2P: if kDmaFifoConfArray(i).Mode = NiFpgaPeerToPeerReader generate

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        DmaPortCommIfcSinkStreamx: entity work.DmaPortCommIfcSinkStream (structure)
          generic map (
            kFifoDepth      => kFifoDepthInSamples(i).FifoDepth,        
            kFifoBaseOffset => kDmaFifoConfArray(i).WriteWindowOffset,  
            kWriteWindow    => kFifoWriteWindow,                        
            kSampleWidth    => kDmaFifoConfArray(i).FifoWidth,          
            kBaseOffset     => kDmaFifoConfArray(i).BaseAddress,        
            kStreamNumber   => i,                                       
            kFxpType        => kDmaFifoConfArray(i).FxpType)            
          port map (
            aReset                         => aReset,                                    
            bReset                         => dReset,                                    
            BusClk                         => DmaClk,                                    
            bNiDmaInputRequestToDma        => dNiDmaSinkRequestToDmaArray(kSinkStrmIndex(i)),
            bNiDmaInputRequestFromDma      => dNiDmaInputRequestFromDma,                 
            bNiDmaInputDataFromDma         => dNiDmaInputDataFromDma,                    
            bNiDmaInputDataToDma           => dInputDataFromSinkStreamArray(kSinkStrmIndex(i)),
            bNiDmaHighSpeedSinkFromDma     => dNiDmaHighSpeedSinkFromDmaReg,             
            bNiDmaInputDataToDmaValid      => dInputDataFromSinkStreamValidArray(kSinkStrmIndex(i)),
            bArbiterNormalReq              => dSinkStrmsAccNormalReq(kSinkStrmIndex(i)),
            bArbiterEmergencyReq           => dSinkStrmsAccEmergencyReq(kSinkStrmIndex(i)),
            bArbiterDone                   => dSinkStrmsAccDoneStrbArray(kSinkStrmIndex(i)),
            bArbiterGrant                  => dSinkArbAccGrant(kSinkStrmIndex(i)),       
            bRegPortIn                     => dRegPortInReg2,                            
            bRegPortOut                    => dSinkStrmsRegPortOut(kSinkStrmIndex(i)),
            bOutputStreamInterfaceToFifo   => dOutputStreamInterfaceToFifo(i),           
            bOutputStreamInterfaceFromFifo => dOutputStreamInterfaceFromFifo(i),         
            bIrq                           => dDmaIrq(i));                               

        dInputStreamInterfaceToFifo(i) <= kInputStreamInterfaceToFifoZero;

      end generate;


      HostOutputStream: if kDmaFifoConfArray(i).Mode = NiFpgaHostToTarget generate

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        DmaPortCommIfcOutputStreamx: entity work.DmaPortCommIfcOutputStream (structure)
          generic map (
            kSampleWidth  => kDmaFifoConfArray(i).FifoWidth,    
            kFifoDepth    => kFifoDepthInSamples(i).FifoDepth,  
            kBaseOffset   => kDmaFifoConfArray(i).BaseAddress,  
            kStreamNumber => i,                                 
            kFxpType      => kDmaFifoConfArray(i).FxpType)      
          port map (
            aReset                         => aReset,                                    
            bReset                         => dReset,                                    
            BusClk                         => DmaClk,                                    
            bNiDmaOutputRequestToDma       => dNiDmaOutputRequestToDmaArray(kOutStrmIndex(i)),
            bNiDmaOutputRequestFromDma     => dNiDmaOutputRequestFromDma,                
            bNiDmaOutputDataFromDma        => dNiDmaOutputDataFromDmaArray(kOutStrmIndex(i)),
            bArbiterNormalReq              => dOutStrmsAccNormalReq(kOutStrmIndex(i)),
            bArbiterEmergencyReq           => dOutStrmsAccEmergencyReq(kOutStrmIndex(i)),
            bArbiterDone                   => dOutStrmsAccDoneStrbArray(kOutStrmIndex(i)),
            bArbiterGrant                  => dOutArbAccGrant(kOutStrmIndex(i)),         
            bRegPortIn                     => dRegPortInReg2,                            
            bRegPortOut                    => dOutStrmsRegPortOut(kOutStrmIndex(i)),     
            bOutputStreamInterfaceToFifo   => dOutputStreamInterfaceToFifo(i),           
            bOutputStreamInterfaceFromFifo => dOutputStreamInterfaceFromFifo(i),         
            bIrq                           => dDmaIrq(i));                               

        dInputStreamInterfaceToFifo(i) <= kInputStreamInterfaceToFifoZero;

      end generate; 

      DmaUnused: if kDmaFifoConfArray(i).Mode = Disabled generate

        dOutputStreamInterfaceToFifo(i) <= kOutputStreamInterfaceToFifoZero;
        dInputStreamInterfaceToFifo(i) <= kInputStreamInterfaceToFifoZero;
        dDmaIrq(i) <= kIrqStatusToInterfaceZero;

      end generate; 

    end generate; 

  end block DmaBlk;


  MasterPortBlk: block
  begin

    NoWriteMasterPort: if kNumOfWriteMasterPorts = 0 generate

      dNiFpgaMasterWriteRequestToDmaArray(0) <= kNiDmaInputRequestToDmaZero;
      dNiFpgaMasterWriteDataToDmaArray(0) <= kNiDmaInputDataToDmaZero;
      dMasterWriteAccDoneStrbArray(0) <= '0';
      dMasterWriteAccEmergencyReq(0) <= '0';

    end generate; 

    NoReadMasterPort: if kNumOfReadMasterPorts = 0 generate

      dNiFpgaMasterReadRequestToDmaArray(0) <= kNiDmaOutputRequestToDmaZero;
      dMasterReadAccDoneStrbArray(0) <= '0';
      dMasterReadAccEmergencyReq(0) <= '0';

    end generate; 

    MasterPortComponents: for i in 0 to kNumberOfMasterPorts - 1 generate

      WriteMasterPorts: if kMasterPortConfArray(i).Mode = NiFpgaMasterPortWriteRead or 
                           kMasterPortConfArray(i).Mode = NiFpgaMasterPortWrite generate

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        DmaPortCommIfcMasterWriteInterfacex: entity work.DmaPortCommIfcMasterWriteInterface (rtl)
          generic map (
            kWriteMasterPortNumber => kNumberOfDmaChannels+i)  
          port map (
            aReset                              => aReset,                               
            BusClk                              => DmaClk,                               
            bNiFpgaMasterWriteRequestToDma      => dNiFpgaMasterWriteRequestToDmaArray(kMasterWriteIndex(i)),
            bNiFpgaMasterWriteRequestFromDma    => dNiDmaInputRequestFromDma,            
            bNiFpgaMasterWriteDataFromDma       => dNiDmaInputDataFromDma,               
            bNiFpgaMasterWriteDataToDma         => dNiFpgaMasterWriteDataToDmaArray(kMasterWriteIndex(i)),
            bNiFpgaMasterWriteStatusFromDma     => dNiDmaInputStatusFromDmaReg,          
            bNiFpgaMasterWriteDataToDmaValid    => dNiFpgaMasterWriteDataToDmaValidArray(kMasterWriteIndex(i)),
            bNiFpgaMasterWriteRequestFromMaster => dNiFpgaMasterWriteRequestFromMasterArray(i),
            bNiFpgaMasterWriteRequestToMaster   => dNiFpgaMasterWriteRequestToMasterArray(i),
            bNiFpgaMasterWriteDataFromMaster    => dNiFpgaMasterWriteDataFromMasterArray(i),
            bNiFpgaMasterWriteDataToMaster      => dNiFpgaMasterWriteDataToMasterArray(i),
            bNiFpgaMasterWriteStatusToMaster    => dNiFpgaMasterWriteStatusToMasterArray(i),
            bMasterWriteArbiterReq              => dMasterWriteAccEmergencyReq(kMasterWriteIndex(i)),
            bMasterWriteArbiterDone             => dMasterWriteAccDoneStrbArray(kMasterWriteIndex(i)),
            bMasterWriteArbiterGrant            => dMasterWriteAccGrant(kMasterWriteIndex(i)));


        NullReadMasterPort: if kMasterPortConfArray(i).Mode = NiFpgaMasterPortWrite generate
          dNiFpgaMasterReadRequestToMasterArray(i) <= kNiFpgaMasterReadRequestToMasterZero;
          dNiFpgaMasterReadDataToMasterArray(i) <= kNiFpgaMasterReadDataToMasterZero;
        end generate;

      end generate; 

      ReadMasterPorts: if kMasterPortConfArray(i).Mode = NiFpgaMasterPortWriteRead or 
                          kMasterPortConfArray(i).Mode = NiFpgaMasterPortRead generate

        
        
        
        
        
        
        
        
        
        
        
        
        DmaPortCommIfcMasterReadInterfacex: entity work.DmaPortCommIfcMasterReadInterface (rtl)
          generic map (
            kReadMasterPortNumber => kNumberOfDmaChannels+i)  
          port map (
            aReset                             => aReset,                                
            BusClk                             => DmaClk,                                
            bNiFpgaMasterReadRequestToDma      => dNiFpgaMasterReadRequestToDmaArray(kMasterReadIndex(i)),
            bNiFpgaMasterReadRequestFromDma    => dNiDmaOutputRequestFromDma,            
            bNiFpgaMasterReadDataFromDma       => dNiDmaOutputDataFromDmaReg,            
            bNiFpgaMasterReadRequestFromMaster => dNiFpgaMasterReadRequestFromMasterArray(i),
            bNiFpgaMasterReadRequestToMaster   => dNiFpgaMasterReadRequestToMasterArray(i),
            bNiFpgaMasterReadDataToMaster      => dNiFpgaMasterReadDataToMasterArray(i),
            bMasterReadArbiterReq              => dMasterReadAccEmergencyReq(kMasterReadIndex(i)),
            bMasterReadArbiterDone             => dMasterReadAccDoneStrbArray(kMasterReadIndex(i)),
            bMasterReadArbiterGrant            => dMasterReadAccGrant(kMasterReadIndex(i)));


        NullWriteMasterPort: if kMasterPortConfArray(i).Mode = NiFpgaMasterPortRead generate
          dNiFpgaMasterWriteRequestToMasterArray(i) <= kNiFpgaMasterWriteRequestToMasterZero;
          dNiFpgaMasterWriteDataToMasterArray(i) <= kNiFpgaMasterWriteDataToMasterZero;
          dNiFpgaMasterWriteStatusToMasterArray(i) <=kNiFpgaMasterWriteStatusToMasterZero;
        end generate;

      end generate; 

      MasterPortsUnused: if kMasterPortConfArray(i).Mode = Disabled generate

        dNiFpgaMasterWriteRequestToMasterArray(i) <= kNiFpgaMasterWriteRequestToMasterZero;
        dNiFpgaMasterWriteDataToMasterArray(i) <= kNiFpgaMasterWriteDataToMasterZero;
        dNiFpgaMasterWriteStatusToMasterArray(i) <=kNiFpgaMasterWriteStatusToMasterZero;

        dNiFpgaMasterReadRequestToMasterArray(i) <= kNiFpgaMasterReadRequestToMasterZero;
        dNiFpgaMasterReadDataToMasterArray(i) <= kNiFpgaMasterReadDataToMasterZero;

      end generate; 

    end generate; 

  end block MasterPortBlk;


  
  
  assert kNumberOfIrqs <= 1
    report "A maximum of 1 IRQ is supported by this communication interface." & LF &
           "Number of requested IRQs = " & integer'image(kNumberOfIrqs)
    severity error;

  IrqUsed: if kNumberOfIrqs = 1 generate

    
    
    
    
    
    
    
    DmaPortCommIfcIrqInterfacex: entity work.DmaPortCommIfcIrqInterface (rtl)
      generic map (
        kNumDmaIrqPorts => kNumberOfDmaChannels)  
      port map (
        aReset            => aReset,             
        bReset            => dReset,             
        BusClk            => DmaClk,             
        IrqClk            => IrqClk,             
        bIrq              => dIrq(0),            
        iLvFpgaIrq        => iLvFpgaIrq,         
        bFixedLogicDmaIrq => dFixedLogicDmaIrq,  
        bDmaIrq           => dDmaIrq);           


  end generate; 

  IrqUnused: if kNumberOfIrqs = 0 generate
    dIrq(0) <= '0';
  end generate; 

  
  
  
  dInArbAccEmergencyReq <= GetEmergencyReq(dNiFpgaInputArbReq) 
                         & dMasterWriteAccEmergencyReq 
                         & dSinkStrmsAccEmergencyReq 
                         & dInStrmsAccEmergencyReq ;

  dInArbAccNormalReq <= GetNormalReq(dNiFpgaInputArbReq)
                      & Zeros(Larger(kNumOfWriteMasterPorts,1)) 
                      & dSinkStrmsAccNormalReq 
                      & dInStrmsAccNormalReq ;

  
  
  
  
  
  
  
  
  DmaPortCommIfcInputArbiterx: entity work.DmaPortCommIfcInputArbiter (rtl)
    generic map (
      kNumOfInStrms => Larger(kNumOfInStrms,1) + Larger(kNumOfWriteMasterPorts,1) + Larger(kNumOfSinkStrms,1) + kNiFpgaFixedInputPorts)
    port map (
      aReset                  => aReset,                         
      BusClk                  => DmaClk,                         
      bReset                  => dReset,                         
      bInStrmsAccNormalReq    => dInArbAccNormalReq,             
      bInStrmsAccEmergencyReq => dInArbAccEmergencyReq,          
      bInStrmsAccDoneStrb     => to_boolean(dInArbAccDoneStrb),  
      bInStrmsAccGrant        => dInArbAccGrant);                

  dNiFpgaInputArbGrant <= 
    to_NiDmaArbGrantArray_t (
    dInArbAccGrant( kNiFpgaFixedInputPorts
                  + Larger(kNumOfWriteMasterPorts,1) 
                  + Larger(kNumOfSinkStrms,1) 
                  + Larger(kNumOfInStrms,1) - 1
                   downto 
                   Larger(kNumOfWriteMasterPorts,1) 
                 + Larger(kNumOfSinkStrms,1) 
                 + Larger(kNumOfInStrms,1) ) );

  
  dMasterWriteAccGrant <= (others => '0') when kNumOfWriteMasterPorts = 0 else
    dInArbAccGrant( Larger(kNumOfWriteMasterPorts,1) 
                  + Larger(kNumOfSinkStrms,1) 
                  + Larger(kNumOfInStrms,1) - 1
                  downto 
                  Larger(kNumOfSinkStrms,1) 
                + Larger(kNumOfInStrms,1) );

  
  dSinkArbAccGrant <= (others => '0') when kNumOfSinkStrms = 0 else
    dInArbAccGrant( Larger(kNumOfSinkStrms,1) 
                  + Larger(kNumOfInStrms,1) - 1  
                  downto 
                  Larger(kNumOfInStrms,1) );

  
  
  
  
  dNiDmaInputRequestToDma <= OrArray (  dNiDmaInputRequestToDmaArray 
                                      & dNiFpgaMasterWriteRequestToDmaArray
                                      & dNiDmaSinkRequestToDmaArray 
                                      & dNiFpgaInputRequestToDmaArray
                                     );

  dInputStreamDataFromDma <= dNiDmaInputDataFromDma;

  
  
  
  
  
  
  DmaPortCommIfcInputDataControlx: entity work.DmaPortCommIfcInputDataControl (rtl)
    generic map (
      kNumOfInStrms => kNumOfInStrms,  
      kInStrmIndex  => kInStrmIndex)   
    port map (
      aReset                           => aReset,                            
      BusClk                           => DmaClk,                            
      bNiDmaInputDataFromDma           => dInputStreamDataFromDma,           
      bNiDmaInputDataToDma             => dInputStreamDataToDma,             
      bInputDataInterfaceFromFifoArray => dInputDataInterfaceFromFifoArray,  
      bInputDataInterfaceToFifoArray   => dInputDataInterfaceToFifoArray);   

  
  
  
  
  
  
  DmaPortCommIfcSinkDataControlx: entity work.DmaPortCommIfcSinkDataControl (rtl)
    generic map (
      kNumOfSinkStrms => kNumOfSinkStrms)  
    port map (
      aReset                             => aReset,                              
      BusClk                             => DmaClk,                              
      bNiDmaInputDataToDma               => dSinkStreamDataToDma,                
      bNiDmaInputDataToDmaValid          => dSinkStreamDataToDmaValid,           
      bInputDataFromSinkStreamArray      => dInputDataFromSinkStreamArray,       
      bInputDataFromSinkStreamValidArray => dInputDataFromSinkStreamValidArray); 


  
  
  

  
  
  
  
  
  DmaPortInputDataToDmaDelayx: entity work.DmaPortInputDataToDmaDelay (RTL)
    generic map (
      kDelay => kInputDataDelay)  
    port map (
      Clk                         => DmaClk,                                  
      cNiDmaInputDataToDma        => OrArray ( dNiFpgaInputDataToDmaArray ),  
      cNiDmaInputDataToDmaDelayed => dNiFpgaInputDataToDmaDelayed);           


  
  
  InputDataToDma: process (dNiFpgaMasterWriteDataToDmaArray,
                           dNiFpgaMasterWriteDataToDmaValidArray, dInputStreamDataToDma,
                           dSinkStreamDataToDma, dSinkStreamDataToDmaValid,
                           dNiFpgaInputDataToDmaDelayed)
    variable MasterWriteDataToDmaVar : NiDmaInputDataToDma_t;
    variable MasterWriteDataToDmaValidVar : boolean;

  begin

    MasterWriteDataToDmaVar := kNiDmaInputDataToDmaZero;
    MasterWriteDataToDmaValidVar := false;

    for i in 0 to kNumOfWriteMasterPorts-1 loop
      if dNiFpgaMasterWriteDataToDmaValidArray(i) then
        MasterWriteDataToDmaVar := dNiFpgaMasterWriteDataToDmaArray(i);
      end if;

      MasterWriteDataToDmaValidVar := MasterWriteDataToDmaValidVar or
                                      dNiFpgaMasterWriteDataToDmaValidArray(i);

    end loop;

    if MasterWriteDataToDmaValidVar then
      dNiDmaInputDataToDma <= MasterWriteDataToDmaVar;
    elsif dSinkStreamDataToDmaValid then
      dNiDmaInputDataToDma <= dSinkStreamDataToDma;
    else
      dNiDmaInputDataToDma <= OrArray (
                              dInputStreamDataToDma
                            & dNiFpgaInputDataToDmaDelayed
                          );
    end if;
  end process InputDataToDma;

  
  
  
  dOutArbAccEmergencyReq <= GetEmergencyReq(dNiFpgaOutputArbReq)
                          & dMasterReadAccEmergencyReq 
                          & dOutStrmsAccEmergencyReq;

  dOutArbAccNormalReq <= GetNormalReq(dNiFpgaOutputArbReq)
                       & Zeros(Larger(kNumOfReadMasterPorts,1)) 
                       & dOutStrmsAccNormalReq;

  
  
  
  
  
  
  
  
  DmaPortCommIfcOutputArbiterx: entity work.DmaPortCommIfcOutputArbiter (rtl)
    generic map (
      kNumOfOutStrms => Larger(kNumOfOutStrms,1) + Larger(kNumOfReadMasterPorts,1) + kNiFpgaFixedOutputPorts)
    port map (
      aReset                   => aReset,                          
      BusClk                   => DmaClk,                          
      bReset                   => dReset,                          
      bOutStrmsAccNormalReq    => dOutArbAccNormalReq,             
      bOutStrmsAccEmergencyReq => dOutArbAccEmergencyReq,          
      bOutStrmsAccDoneStrb     => to_boolean(dOutArbAccDoneStrb),  
      bOutStrmsAccGrant        => dOutArbAccGrant);                


  
  dMasterReadAccGrant <= (others => '0') when kNumOfReadMasterPorts = 0 else
    dOutArbAccGrant((Larger(kNumOfOutStrms,1) 
                   + Larger(kNumOfReadMasterPorts,1) - 1) 
                    downto 
                     Larger(kNumOfOutStrms,1));

  dNiFpgaOutputArbGrant <=
    to_NiDmaArbGrantArray_t (
    dOutArbAccGrant((kNiFpgaFixedOutputPorts
                   + Larger(kNumOfOutStrms,1) 
                   + Larger(kNumOfReadMasterPorts,1) - 1) 
                    downto 
                     Larger(kNumOfOutStrms,1) 
                   + Larger(kNumOfReadMasterPorts,1)));

  
  
  
  
  dNiDmaOutputRequestToDma <= OrArray (  dNiDmaOutputRequestToDmaArray
                                       & dNiFpgaMasterReadRequestToDmaArray 
                                       & dNiFpgaOutputRequestToDmaArray
                                      );

  GenerateOutputDataArray: for i in 0 to kNumOfOutStrms-1 generate
    dNiDmaOutputDataFromDmaArray(i)  <= dNiDmaOutputDataFromDmaReg;
  end generate GenerateOutputDataArray;


  
  
  dRegPortOutArray(0) <= SelectPort(dInStrmsRegPortOut);
  dRegPortOutArray(1) <= SelectPort(dOutStrmsRegPortOut);
  dRegPortOutArray(2) <= SelectPort(dSinkStrmsRegPortOut);
  dRegPortOutToReg <= SelectPort(dRegPortOutArray);


  OrInDoneStrobes:
  dInArbAccDoneStrb <= OrVector ( 
                       GetDoneStrb(dNiFpgaInputArbReq ) 
                     & dMasterWriteAccDoneStrbArray 
                     & dSinkStrmsAccDoneStrbArray 
                     & dInStrmsAccDoneStrbArray 
                     );

  OrOutDoneStrobes:
  dOutArbAccDoneStrb <= OrVector (
                        GetDoneStrb ( dNiFpgaOutputArbReq )
                      & dMasterReadAccDoneStrbArray
                      & dOutStrmsAccDoneStrbArray
                        );

  dNiFpgaInputStatusFromDmaArray <= (others => dNiDmaInputStatusFromDmaReg);
  dNiFpgaInputRequestFromDmaArray <= (others => dNiDmaInputRequestFromDma);
  dNiFpgaOutputRequestFromDmaArray <= (others => dNiDmaOutputRequestFromDma);
  dNiFpgaInputDataFromDmaArray <= (others => dNiDmaInputDataFromDma);
  dNiFpgaOutputDataFromDmaArray <= (others => dNiDmaOutputDataFromDma);

end struct;