function [PhasesOfSlices, CyclesOfSlices, SIGNALS] = PhysioSignal_Plot_PhasesAndCyclesOfSlices23(PhysioFilename, TR, Ns, TimePtSpan, WhichPhysio, CYCLIC, TRIGPRM, Store, BandWidth, DummyTime, CARDchannel, SIGNALyFLIP)
%==========================================================================
% PHYSIOSIGNAL_PLOT_PHASESANDCYCLESOFSLICES2: 
% 1) Synchronizes A fMRI Time Series (TS) With The Physiological Signal:
%    Cardiac (ECG or CARD), Respiration (RESP) or Puls (PULS) Recorded In
%    Parallel.
%
%    As Physiological Signals Are Quasi-Periodic, This Function Also:
%
% 2) Computes Phases Of The Signal At Times Of Acquisition Of TS Slices
%    (Output As: PHASESOFSLICES)
%
% 3) Assigns A Number At Each Phase Corresponding To The Cycle OfThe Signal    
%    Where This Phase Was Computed (Output As: CYCLESOFSLICES).
%
% PS: This Function Can Also Handle 2 Physiological Signals like: CARD&RESP
%     or PULS&RESP
%
%
% INPUT:
%  * PHYSIOFILENAME --> Path And File Name Of The Physiological Signal(s)
%                       A cell array of one or 2 files (including full path
%                       and extension). The semantics of each file is
%                       determined based on WHICHPHYSIO.
%
%  * TR             --> Repetion Time (Time Between 2 TS Time Points)
%
%  * NS             --> Nber Of Slices In Each Volume Of The TS
%
%  * TIMEPTSPAN     --> The Start(START) & End(END) TS Time Points Or Vo-
%                       lumes Involved In The Required Signal Phases And  
%                       Cycles Cumputation. START And END Are Taken Among
%                       The Whole Range Of Acquired Volumes Spanned Bet-
%                       ween 1 and ALLTPS. 
%                         * TIMEPTSPAN == [START END ALLTPS] =>Only Volumes 
%                                   From START to END Are Used Among ALLTPS
%                             
%                         * TIMEPTSPAN == [1  ALLTPS ALLTPS] => All Volumes 
%                                   From  1 to ALLTPS Are Used Among ALLTPS
%                       
%  * WHICHPHYSIO    --> Declares Which Physio Signal to Correct
%                         * WHICHPHYSIO  =  0  => CARD Correction
%                         * WHICHPHYSIO  =  1  => RESP Correction
%                         * WHICHPHYSIO  =  2  => PULS Correction
%                         * WHICHPHYSIO  =  3  => RESP+CARD Corrections
%                         * WHICHPHYSIO  =  4  => CARD+RESP Corrections
%                         * WHICHPHYSIO  =  5  => RESP+PULS Corrections
%                         * WHICHPHYSIO  =  6  => PULS+RESP Corrections
%
%  * CYCLIC         --> Checks If The Required Correction is Cyclic Or Not:
%                       * CYCLIC  < 0 : 1or2 Signals 
%                                    -> 1 is (or Both are)Global-RECTROICOR
%                       * CYCLIC  = 0 : 1or2 Signals 
%                                    -> 1 is (or Both are) Global
%                       * CYCLIC  = 1 : 1 Signal 
%                                    -> 1 Cyclic Correction
%                       * CYCLIC  = 1 : 2 Signals 
%                                    -> 1st Cyclic(RESP) & 2nd Global(CARD)
%                       * CYCLIC  = 1 : 2 Signals 
%                                    -> 1st Global(CARD) & 2nd Cyclic(RESP)
%                       * CYCLIC >= 2 : 2 Signals 
%                                    -> 1st Cyclic & 2nd Cyclic Corrected
%                       
%  * [ TRIGPRM ]    --> Array Of 3 Elements (or a 2x3 matrix when 2 signals
%                       are required to be corrected) Used To Set Triggers:
%                        * TRIGPRM(1)==0 => - Uses Triggers Recorded During 
%                                             The TS Acquisition To Compute
%                                             New Positions Of Triggers.
%                                           - NO NEED TO SET TRIGPRM(2)&(3)
%                        
%                        * TRIGPRM(1) >0 => - Uses A Threshold To Compute
%                                             New Positions Of Triggers.
%                                           - SET TRIGPRM(2) and TRIGPRM(3)
%                        
%                        * TRIGPRM(1) <0 => - ONLY FOR THE ECG SIGNAL!!!!
%                                           - Uses Only Triggers Recorded 
%                                             During The TS Acquisition.
%                                           - NO NEED TO SET new Positions
%                                             Of Triggers.
%                                           - NO NEED TO SET TRIGPRM(2)&(3)
%                        
%                        * TRIGPRM(2) (%)=> Threshold: A Percentage Of The
%                                           Amplitude Between The Maximum &
%                                           The Mean Of The Signal Required
%                                           To Be Corrected. 
%                                           - It Can Be Set To:   
%                                                 *        0% -> RESP
%                                                 * 50 to 60% -> CARD
%                                           
%                        * TRIGPRM(3)    => Threshold: Minimum Time(in sec)
%                                           Expected Between 2 Triggers In
%                                           CARD(ECG) Signal.
%                                           - Need To Remove Trig. Outliers
%                                           - NOT USED For RESP!!!!
%                                           - It Can Be Set To 0.3
%                                           
%                        * To Handle 2 Signals, TRIGPRM is A 2x3 Matrix
%                              
%                             Ex:   TRIGPRM = [1,  0, 0.0;
%                                              1, 50, 0.3]
%                                   To Handle RESP+ECG Corrections
%
%  * [ STORE ]      --> Checks If Phases & Cycles Must be Stored (in a .MAT
%                       file). STORE May Have 2 Elements,Each For 1 Signal
%                       When 2 Signals Are Required To Be Corrected:
%                         * STORE  >  0  => Store Phases & Cycles
%                         * STORE  <= 0  => No Storage
%                       This input is obsolete and a warning is issued
%                       instead of storing anything.
%
%  * [ BANDWIDTH  ] --> Inverse Of Time (in Sec) Between 2 PHYSIO Samples
%                       It Should Be A 2 Elements Array When Dealing With 2
%                       Signals.
%
%  * [ DUMMYTIME  ] --> Dummy Measurement Time = Time Before TS Acquisition
%
%  * [ CARDCHANNEL ]--> Check Which CARD(ECG) signal To Choose When Several
%                       Channels are Used During The EGG Acquisition.
%                       Several ECG Channels => Several CARD Signals.
%
%  * [ SIGNALyFLIP ]--> Checks If The Signal MustBe Y-Flipped. It Should Be
%                       A 2 Elements Array When Dealing With 2 Signals:
%                         * SIGNALyFLIP  > 0 => Y-Flipped
%                         * SIGNALyFLIP <= 0 => No Y-Flipped
%
%
% OUTPUT:
%  * PHASESOFSLICES --> Physio Signal Phases At Slice Record Times
%                         * 1 row  => if WHICHPHYSIO < 3
%                         * 2 rows => if WHICHPHYSIO > 2 
%  * CYCLESOFSLICES --> Physio Sig Cycles (Periods) At Slice Record Times 
%                         * 0 row  => CYCLIC == 0
%                         * 1 rows => CYCLIC == 1 
%                         * 2 rows => CYCLIC == 2
%  * [ SIGNALS ]    --> Optional Structure, Stores Elements Of Signal(s)
%    - SIGNALS.Sig1      ->  Array of PHYSIO Signal At TS Interval
%    - SIGNALS.Time1     ->  PHYSIO Signal Time Scale, Spanned TS Interval
%    - SIGNALS.Trig1     ->  Array of Local Max (Triggers) In TS Interval
%    - SIGNALS.LocMn1    ->  Array of Local Min In The TS Interval
%    if 2 PHYSIO Signals:
%    - SIGNALS.Sig2      -> 
%    - SIGNALS.Time2     -> 
%    - SIGNALS.Trig2     -> 
%    - SIGNALS.LocMn2    -> 
%
%---------------------------------------------
% A. ELLA, Univ. Hospital Freiburg, Diag. Radiol, Medical Physics, 2008
% Arsene.Ella@uniklinik-freiburg.de
%==========================================================================



%================== CHECK THE NUMBER OF INPUT ARGUMENTS ===================
% Check The Number Of Input Arguments
if nargin < 6,    error('Not enough arguments!'); end


%================= CHECK INPUT AND SET DEFAULT ARGUMENTS ==================
if nargin < 13,   SIGNALyFLIP = [0,0];                end
if nargin < 12,   CARDchannel = 1;                    end
if nargin < 11,   DummyTime   = floor(3/TR + 1)*TR;   end

if nargin < 10,
   if     WhichPhysio == 0,      % => ECG
      BandWidth(1) = 400.00;               % BandWidth(1) = 398.66;
   elseif WhichPhysio == 1,      % => RESP
      BandWidth(1) =  50.00;               % BandWidth(1) =  49.83;
   elseif WhichPhysio == 2,      % => PULS
      BandWidth(1) =  50.00;               % BandWidth(1) =  49.83;
   elseif WhichPhysio == 3,      % => RESP+ECG
      BandWidth(1) =  50.00;               % BandWidth(1) =  49.83;
      BandWidth(2) = 400.00;               % BandWidth(2) = 398.66;
   elseif WhichPhysio == 4,      % => ECG+RESP
      BandWidth(1) = 400.00;               % BandWidth(1) = 398.66;
      BandWidth(2) =  50.00;               % BandWidth(2) =  49.83;
   elseif WhichPhysio == 5,      % => RESP+PULS
      BandWidth(1) =  50.00;               % BandWidth(1) = 49.83;
      BandWidth(2) =  50.00;               % BandWidth(2) = 49.83;
   elseif WhichPhysio == 6,      % => PULS+RESP
      BandWidth(1) =  50.00;               % BandWidth(2) = 49.83;
      BandWidth(2) =  50.00;               % BandWidth(2) = 49.83;
   else
      error('UNKNOWN REQUIRED PHYSIO!!!!!');
   end
end

if nargin < 9,   Visual     = [1,0];                end
if nargin < 8,   Store      = [0,0];                end
if nargin < 7,   TRIGPRM    = [0;0];                end



%============================ INITIALIZATIONS =============================
% Compute The Number Of Time Points (or Volumes) Involved In The Required
% Signal Phases And Cycles Cumputation
Nt = TimePtSpan(2) - TimePtSpan(1) + 1;

% Total Nber Of Slices In The Time Series
TotNberOfSlices = Ns * Nt;

% Time Needed To Record A Slice
TimeForASlice = TR/Ns;

% TS Time Of Acquisition
AcqDuration = TR*Nt;

% Set The Physio File Name Extension
if     (WhichPhysio == 0),
    WhichPhysio1 = 0;
    WhichPhysio2 = Inf;
    fprintf('ECG Correction.\n\n');
elseif (WhichPhysio == 1),
    WhichPhysio1 = 1;
    WhichPhysio2 = Inf;
    fprintf('RESP Correction.\n\n');
elseif (WhichPhysio == 2),
    WhichPhysio1 = 2;
    WhichPhysio2 = Inf;
    fprintf('PULS Correction.\n\n');
elseif (WhichPhysio == 3),
    WhichPhysio1 = 1;
    WhichPhysio2 = 0;
    fprintf('RESP+ECG Corrections.\n\n');
elseif (WhichPhysio == 4),
    WhichPhysio1 = 0;
    WhichPhysio2 = 1;
    fprintf('ECG+RESP Corrections.\n\n');
elseif (WhichPhysio == 5),
    WhichPhysio1 = 1;
    WhichPhysio2 = 2;
    fprintf('RESP+PULS Corrections.\n\n');
elseif (WhichPhysio == 6),
    WhichPhysio1 = 2;
    WhichPhysio2 = 1;
    fprintf('PULS+RESP Corrections.\n\n');
else
    error('UNKNOWN REQUIRED PHYSIO!!!!!');
end

% Init. Of Vectors
PhasesOfSlices = [];
CyclesOfSlices = [];


%======= PHYSIO SIGNAL PHASE & CYCLES COMPUTING: If Only One Signal =======

% Time Between 2 Physio Samples
TimeBet2PhysioSamples1 = 1/BandWidth(1);

%---------- Compute Physio Signal Phases & Cycles ----------
% Synchronize A TS Scan with The PhysioSignal Curve Recorded During TS Scan
TRIGparam    = TRIGPRM(1,:);
SIGNALyFLIP1 = SIGNALyFLIP(1);
SIG = SignalAndTimeSerieSynchrone42(PhysioFilename{1}, DummyTime, TR, Ns, TimePtSpan, WhichPhysio1, TimeBet2PhysioSamples1, TRIGparam, CARDchannel, SIGNALyFLIP1);

% Computes The 1st Signal Phases(Function Of Time) And Cycles Indexes At
% Record Times Of All Slices Of A TS 
if (WhichPhysio1 == 1),              % Compute RESP Phases And Cycles
   PhasesOfSlices1 = RespPhaseCycles22(SIG, TotNberOfSlices, TimeForASlice, CYCLIC);   
else                                % Compute CARDorPULS Phases And Cycles
   PhasesOfSlices1 = EcgPhasesCycles2(SIG, TotNberOfSlices, TimeForASlice);   
end


% Store Phases & Cycles In Output And File Matrices
 PhasesOfSlices = PhasesOfSlices1(1,:);                                                       % Store Phases In The Output Matrix

if (  (CYCLIC >= 2) || ((CYCLIC == 1) && WhichPhysio2 ~= 1)  ),   % CYCLIC==2, CYCLIC==1 & 1Correction, CYCLIC==1 & 2Corrections & RESP as 1st Signal
   CyclesOfSlices = PhasesOfSlices1(2,:);                                                     %   * Store Cycles In The Output Matrix
end


%--- Store Physio Signal Phases & Cycles In A .MAT File ----
if (Store(1) > 0)
    warning('physiotools:deprecated', 'Store option is disabled.');
end


%------------- Prepare Ouput Parameters  --------------
% Retrieve Physio Signal During The TS (Between TimePtSpan(1) & TimePtSpan(2))
ss  = SIG.FirstSignalIndexInTS;       % First Signal Index In TS
se  = SIG.LastSignalIndexInTS;        % Last  Signal Index In TS

% Retrieve Signal Triggers During The TS
s    = SIG.FirstTriggerIndexInTS;     % First Trigger Index In TS
e    = SIG.LastTriggerIndexInTS;      % Last  Trigger Index In TS
TRIG = SIG.Trig(s:e) - (ss-1);        % Retrieve Trigger & Adjust Positions 

% Retrieve Signal Local Minima During The TS
LocMIN = [];
if WhichPhysio1 == 1,
   s = SIG.FirstLocMinIndexInTS;      % First Local Minimum Index In TS
   e = SIG.LastLocMinIndexInTS;       % Last  Local Minimum Index In TS
   LocMIN = SIG.LocMIN(s:e) - (ss-1); % Retrieve Trigger & Adjust Positions
end

SIG = SIG.signal(ss:se);              % Retrieve Physio Signal
N   = length( SIG ); 

% Compute The Signal Time Scale
SIGtime = (0:(N-1)) * TimeBet2PhysioSamples1;


%--------------- Initialization Of Outputs  ----------------   
% Store Signal Elements For The 3rd Output
if (nargout == 3),
   SIGNALS.Sig1   = SIG;
   SIGNALS.Time1  = SIGtime;
   SIGNALS.Trig1  = TRIG;
   SIGNALS.LocMn1 = LocMIN;
end

% Delete Array
clear SIG SIGtime TRIG LocMIN PhasesOfSlices1





%========== PHYSIO SIGNAL PHASE & CYCLES COMPUTING: If 2 Signals ==========
if isfinite(WhichPhysio2),
   % Time Between 2 Physio Samples
   TimeBet2PhysioSamples2 = 1/BandWidth(2);
   
   
   %---------- Compute Physio Signal Phases & Cycles ----------
   % Synchronize A TS Scan with The PhysioSignal Curve Recorded During TS Scan
   TRIGparam    = TRIGPRM(2,:);
   SIGNALyFLIP2 = SIGNALyFLIP(2);
   SIG = SignalAndTimeSerieSynchrone42(PhysioFilename{2}, DummyTime, TR, Ns, TimePtSpan, WhichPhysio2, TimeBet2PhysioSamples2, TRIGparam, CARDchannel, SIGNALyFLIP2);

   % Computes Physiological Phases( Function Of Time) And Cycles Indexes At
   % Record Time Of All Slices Of A TS Image 
   if WhichPhysio2 == 1,             % Compute RESP Phases And Cycles
      % Compute RESP Phases And Cycles
      PhasesOfSlices1 = RespPhaseCycles22(SIG, TotNberOfSlices, TimeForASlice, CYCLIC);
    
   else                             % Compute CARDorPULS Phases And Cycles
      % Compute Phases And Cycles 
      PhasesOfSlices1 = EcgPhasesCycles2(SIG, TotNberOfSlices, TimeForASlice);
   end
   
   
   % Store Phases & Cycles In Output And File Matrices
   PhasesOfSlices = [PhasesOfSlices; PhasesOfSlices1(1,:)];                        % Store Phases In The Output Matrix
   
   if (  (CYCLIC >= 2) || ((CYCLIC == 1) && (WhichPhysio2 == 1))  ),                 % CYCLIC==2 OR CYCLIC==1 & 2Corrections & RESP as 2nd Signal
      CyclesOfSlices = [CyclesOfSlices; PhasesOfSlices1(2,:)];                     %   * Store Cycles In The Output Matrix
   end
      
   
   %--- Store Physio Signal Phases & Cycles In A .MAT File ----
   % Store Phases And Cycles In A .MAT File 
   if (Store(2) > 0)
       warning('physiotools:deprecated', 'Store option is disabled.');
   end
   
   
   %------------- Prepare Ouput Parameters  --------------
   % Retrieve Physio Signal During The TS (Between TimePtSpan(1) & TimePtSpan(2))
   ss  = SIG.FirstSignalIndexInTS;       % First Signal Index In TS
   se  = SIG.LastSignalIndexInTS;        % Last  Signal Index In TS
   
   % Retrieve Signal Triggers During The TS
   s    = SIG.FirstTriggerIndexInTS;     % First Trigger Index In TS
   e    = SIG.LastTriggerIndexInTS;      % Last  Trigger Index In TS
   TRIG = SIG.Trig(s:e) - (ss-1);        % Retrieve Trigger & Adjust Positions 
   
   % Retrieve Signal Local Minima During The TS
   if WhichPhysio2 == 1,
      s = SIG.FirstLocMinIndexInTS;      % First Local Minimum Index In TS
      e = SIG.LastLocMinIndexInTS;       % Last  Local Minimum Index In TS
      LocMIN = SIG.LocMIN(s:e) - (ss-1); % Retrieve Trigger & Adjust Positions
   else
       LocMIN = [];
   end

   SIG = SIG.signal(ss:se);              % Retrieve Physio Signal
   N   = length( SIG ); 

   % Compute The Signal Time Scale
   SIGtime = (0:(N-1)) * TimeBet2PhysioSamples2;
   
   
   %--------------- Initialization Of Outputs  ----------------   
   % Store Signal Elements For The 3rd Output
   if (nargout == 3),
      SIGNALS.Sig2   = SIG;
      SIGNALS.Time2  = SIGtime;
      SIGNALS.Trig2  = TRIG;
      SIGNALS.LocMn2 = LocMIN;
   end

end





