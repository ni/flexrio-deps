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

use work.PkgInstructionFifo.all;

use work.PkgFlexRioAxiStream.all;

use work.PkgNiDma.all;
use work.PkgDmaPortRecordFlattening.all;
use work.PkgDmaPortCommIfcArbiter.all;

use work.PkgBaRegPort.all;


library MacallanIFifo;


entity MacallanIFifo is

  port (
    aBusReset               : in  boolean;
    
    
    
    DmaClk                  : in  std_logic;
    
    dHighSpeedSinkFromDma   : in  NiDmaHighSpeedSinkFromDma_t;
    
    dBaRegPortIn            : in  BaRegPortIn_t;
    dBaRegPortOutIFifo      : out BaRegPortOut_t;
    
    dIFifoRequestFromDma    : in  NiDmaInputRequestFromDma_t;
    dIFifoRequestToDma      : out NiDmaInputRequestToDma_t;
    dIFifoDataFromDma       : in  NiDmaInputDataFromDma_t;
    dIFifoDataToDma         : out NiDmaInputDataToDma_t;
    dIFifoStatusFromDma     : in  NiDmaInputStatusFromDma_t;
    
    dIFifoArbReq            : out NiDmaArbReq_t;
    dIFifoArbGrant          : in  NiDmaArbGrant_t;
    
    
    
    BusClk                  : in  std_logic;
    aPonReset               : in  boolean;
    
    bAxiStreamDataToCtrl    : out AxiStreamData_t;
    bAxiStreamReadyFromCtrl : in  boolean;
    
    bAxiStreamDataFromCtrl  : in  AxiStreamData_t;
    bAxiStreamReadyToCtrl   : out boolean;
    
    
    
    aDiagramReset           : in  boolean;
    
    AxiClk                  : in  std_logic;
    
    xAxiStreamDataToClip    : out AxiStreamData_t;
    xAxiStreamReadyFromClip : in  boolean;
    
    xAxiStreamDataFromClip  : in  AxiStreamData_t;
    xAxiStreamReadyToClip   : out boolean;
    
    
    
    ViClk                   : in  std_logic;
    
    vIFifoWrData            : out IFifoWriteData_t;
    vIFifoWrDataValid       : out std_logic;
    vIFifoWrReadyForOutput  : in  std_logic;
    
    vIFifoRdData            : in  IFifoReadData_t;
    vIFifoRdIsError         : in  std_logic;
    vIFifoRdDataValid       : in  std_logic;
    vIFifoRdReadyForInput   : out std_logic
    );

end entity MacallanIFifo;

architecture wrap of MacallanIFifo is

  component MacallanIFifoN
    port (
      aBusReset                  : in  boolean;
      DmaClk                     : in  std_logic;
      dFlatHighSpeedSink         : in  FlatNiDmaHighSpeedSinkFromDma_t;
      dFlatBaRegPortIn           : in  FlatBaRegPortIn_t;
      dFlatBaRegPortOutIFifo     : out FlatBaRegPortOut_t;
      dFlatIFifoRequestFromDma   : in  FlatNiDmaInputRequestFromDma_t;
      dFlatIFifoRequestToDma     : out FlatNiDmaInputRequestToDma_t;
      dFlatIFifoDataFromDma      : in  FlatNiDmaInputDataFromDma_t;
      dFlatIFifoDataToDma        : out FlatNiDmaInputDataToDma_t;
      dFlatIFifoStatusFromDma    : in  FlatNiDmaInputStatusFromDma_t;
      dIFifoArbiterDone          : out std_logic;
      dIFifoArbiterGrant         : in  std_logic;
      dIFifoArbiterReq           : out std_logic;
      BusClk                     : in  std_logic;
      aPonReset                  : in  boolean;
      bFlatAxiStreamDataToCtrl   : out FlatAxiStreamData_t;
      bAxiStreamReadyFromCtrl    : in  boolean;
      bFlatAxiStreamDataFromCtrl : in  FlatAxiStreamData_t;
      bAxiStreamReadyToCtrl      : out boolean;
      aDiagramReset              : in  boolean;
      AxiClk                     : in  std_logic;
      xFlatAxiStreamDataToClip   : out FlatAxiStreamData_t;
      xAxiStreamReadyFromClip    : in  boolean;
      xFlatAxiStreamDataFromClip : in  FlatAxiStreamData_t;
      xAxiStreamReadyToClip      : out boolean;
      ViClk                      : in  std_logic;
      vIFifoWrData               : out IFifoWriteData_t;
      vIFifoWrDataValid          : out std_logic;
      vIFifoWrReadyForOutput     : in  std_logic;
      vIFifoRdData               : in  IFifoReadData_t;
      vIFifoRdIsError            : in  std_logic;
      vIFifoRdDataValid          : in  std_logic;
      vIFifoRdReadyForInput      : out std_logic);
  end component;

  
  signal bFlatAxiStreamDataFromCtrl: FlatAxiStreamData_t;
  signal bFlatAxiStreamDataToCtrl: FlatAxiStreamData_t;
  signal dFlatBaRegPortIn: FlatBaRegPortIn_t;
  signal dFlatBaRegPortOutIFifo: FlatBaRegPortOut_t;
  signal dIFifoArbiterDone: std_logic;
  signal dIFifoArbiterGrant: std_logic;
  signal dIFifoArbiterReq: std_logic;
  signal xFlatAxiStreamDataFromClip: FlatAxiStreamData_t;
  signal xFlatAxiStreamDataToClip: FlatAxiStreamData_t;
  

  signal dFlatHighSpeedSink : FlatNiDmaHighSpeedSinkFromDma_t;

  signal dFlatIFifoDataFromDma    : FlatNiDmaInputDataFromDma_t;
  signal dFlatIFifoDataToDma      : FlatNiDmaInputDataToDma_t;
  signal dFlatIFifoRequestFromDma : FlatNiDmaInputRequestFromDma_t;
  signal dFlatIFifoRequestToDma   : FlatNiDmaInputRequestToDma_t;
  signal dFlatIFifoStatusFromDma  : FlatNiDmaInputStatusFromDma_t;

begin  

  
  
  
  
  dFlatHighSpeedSink       <= Flatten(dHighSpeedSinkFromDma);
  
  dFlatIFifoRequestFromDma <= Flatten(dIFifoRequestFromDma);
  dFlatIFifoDataFromDma    <= Flatten(dIFifoDataFromDma);
  dFlatIFifoStatusFromDma  <= Flatten(dIFifoStatusFromDma);
  
  dIFifoRequestToDma       <= UnFlatten(dFlatIFifoRequestToDma);
  dIFifoDataToDma          <= UnFlatten(dFlatIFifoDataToDma);
  
  dFlatBaRegPortIn         <= Flatten(dBaRegPortIn);
  dBaRegPortOutIFifo       <= UnFlatten(dFlatBaRegPortOutIFifo);
  
  dIFifoArbiterGrant       <= dIFifoArbGrant.Grant;
  dIFifoArbReq <= (NormalReq    => dIFifoArbiterReq,
                   EmergencyReq => '0',
                   DoneStrb     => dIFifoArbiterDone);

  
  
  
  

  
  bAxiStreamDataToCtrl       <= UnFlatten(bFlatAxiStreamDataToCtrl);
  
  bFlatAxiStreamDataFromCtrl <= Flatten(bAxiStreamDataFromCtrl);

  
  xAxiStreamDataToClip       <= UnFlatten(xFlatAxiStreamDataToClip);
  
  xFlatAxiStreamDataFromClip <= Flatten(xAxiStreamDataFromClip);


  
  
  

  
  IFifoNetlistx: MacallanIFifoN
    port map (
      aBusReset                  => aBusReset,                   
      DmaClk                     => DmaClk,                      
      dFlatHighSpeedSink         => dFlatHighSpeedSink,          
      dFlatBaRegPortIn           => dFlatBaRegPortIn,            
      dFlatBaRegPortOutIFifo     => dFlatBaRegPortOutIFifo,      
      dFlatIFifoRequestFromDma   => dFlatIFifoRequestFromDma,    
      dFlatIFifoRequestToDma     => dFlatIFifoRequestToDma,      
      dFlatIFifoDataFromDma      => dFlatIFifoDataFromDma,       
      dFlatIFifoDataToDma        => dFlatIFifoDataToDma,         
      dFlatIFifoStatusFromDma    => dFlatIFifoStatusFromDma,     
      dIFifoArbiterDone          => dIFifoArbiterDone,           
      dIFifoArbiterGrant         => dIFifoArbiterGrant,          
      dIFifoArbiterReq           => dIFifoArbiterReq,            
      BusClk                     => BusClk,                      
      aPonReset                  => aPonReset,                   
      bFlatAxiStreamDataToCtrl   => bFlatAxiStreamDataToCtrl,    
      bAxiStreamReadyFromCtrl    => bAxiStreamReadyFromCtrl,     
      bFlatAxiStreamDataFromCtrl => bFlatAxiStreamDataFromCtrl,  
      bAxiStreamReadyToCtrl      => bAxiStreamReadyToCtrl,       
      aDiagramReset              => aDiagramReset,               
      AxiClk                     => AxiClk,                      
      xFlatAxiStreamDataToClip   => xFlatAxiStreamDataToClip,    
      xAxiStreamReadyFromClip    => xAxiStreamReadyFromClip,     
      xFlatAxiStreamDataFromClip => xFlatAxiStreamDataFromClip,  
      xAxiStreamReadyToClip      => xAxiStreamReadyToClip,       
      ViClk                      => ViClk,                       
      vIFifoWrData               => vIFifoWrData,                
      vIFifoWrDataValid          => vIFifoWrDataValid,           
      vIFifoWrReadyForOutput     => vIFifoWrReadyForOutput,      
      vIFifoRdData               => vIFifoRdData,                
      vIFifoRdIsError            => vIFifoRdIsError,             
      vIFifoRdDataValid          => vIFifoRdDataValid,           
      vIFifoRdReadyForInput      => vIFifoRdReadyForInput);      

end architecture wrap;