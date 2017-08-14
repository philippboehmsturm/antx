function [PhasesOfSlices, CyclesOfSlices, SIGNALS] = PhysioSignal_Plot_PhasesAndCyclesOfSlices2(PhysioFilename, TR, Ns, TimePtSpan, WhichPhysio, CYCLIC, TRIGPRM, Store, Visual, BandWidth, DummyTime, CARDchannel, SIGNALyFLIP)
%==========================================================================
% PHYSIOSIGNAL_PLOT_PHASESANDCYCLESOFSLICES2: It Performs The Following:
% 
% 1) Synchronizes A fMRI Time Series (TS) With The Physiological Signal:
%    Cardiac (ECGorCARD), Respiration (RESP) or Puls (PULS) Recorded In
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
%                       File Extension(s): .ECG, .RESP or .PULS Are Added
%                       Later.
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
%                                             The TS Acquisiton To Compute
%                                             New Positions Of Triggers.
%                                           - NO NEED TO SET TRIGPRM(2)&(3)
%                        
%                        * TRIGPRM(1) >0 => - Uses A Threshold To Compute
%                                             New Positions Of Triggers.
%                                           - SET TRIGPRM(2) and TRIGPRM(3)
%                        
%                        * TRIGPRM(1) <0 => - ONLY FOR THE ECG SIGNAL!!!!
%                                           - Uses Only Triggers Recorded 
%                                             During The TS Acquisiton.
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
%                        * TRIGPRM(3)    => Threshold: Minimun Time(in sec)
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
%                       files). STORE May Have 2 Elements,Each For 1 Signal
%                       When 2 Signals Are Required To Be Corrected:
%                         * STORE  >  0  => Store Phases & Cycles
%                         * STORE  <= 0  => No Storage
%
%  * [ VISUAL ]     --> Checks If Signal(s), Power Spectra of Signals And 
%                       Cycles Must be Plotted. It's a 2 Elements Array:
%                         * VISUAL(1) >  0 => Plot Signal(s) And Power Spc.
%                                     <= 0 => DO NOT Plot Signal(s) And PS
%                         * VISUAL(2) >  0 => Plot Cycles On Signals
%                                     <= 0 => DO NOT Plot Cycles On Signals
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
%                         * SIGNALyFLIP <= 1 => No Y-Flipped
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
      BandWidth(1) = 400.00;
   elseif WhichPhysio == 1,      % => RESP
      BandWidth(1) =  50.00;
   elseif WhichPhysio == 2,      % => PULS
      BandWidth(1) =  50.00;
   elseif WhichPhysio == 3,      % => RESP+ECG
      BandWidth(1) =  50.00;
      BandWidth(2) = 400.00;
   elseif WhichPhysio == 4,      % => ECG+RESP
      BandWidth(1) = 400.00;
      BandWidth(2) =  50.00;
   elseif WhichPhysio == 5,      % => RESP+PULS
      BandWidth(1) =  50.00;
      BandWidth(2) =  50.00;
   elseif WhichPhysio == 6,      % => PULS+RESP
      BandWidth(1) =  50.00;
      BandWidth(2) =  50.00;
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
   PhysioFilename1 = [PhysioFilename '.ecg'];
   WhichPhysio1 = 0;
   WhichPhysio2 = [];
   fprintf('ECG Correction.\n\n');
elseif (WhichPhysio == 1),
   PhysioFilename1 = [PhysioFilename '.resp'];
   WhichPhysio1 = 1;
   WhichPhysio2 = [];
   fprintf('RESP Correction.\n\n');
elseif (WhichPhysio == 2),
   PhysioFilename1 = [PhysioFilename '.puls'];
   WhichPhysio1 = 2;
   WhichPhysio2 = [];
   fprintf('PULS Correction.\n\n');
elseif (WhichPhysio == 3),
   PhysioFilename1 = [PhysioFilename '.resp'];
   PhysioFilename2 = [PhysioFilename '.ecg'];
   WhichPhysio1 = 1;
   WhichPhysio2 = 0;
   fprintf('RESP+ECG Corrections.\n\n');
elseif (WhichPhysio == 4),
   PhysioFilename1 = [PhysioFilename '.ecg'];
   PhysioFilename2 = [PhysioFilename '.resp'];
   WhichPhysio1 = 0;
   WhichPhysio2 = 1;   
   fprintf('ECG+RESP Corrections.\n\n');
elseif (WhichPhysio == 5),
   PhysioFilename1 = [PhysioFilename '.resp'];
   PhysioFilename2 = [PhysioFilename '.puls'];
   WhichPhysio1 = 1;
   WhichPhysio2 = 2;
   fprintf('RESP+PULS Corrections.\n\n');
elseif (WhichPhysio == 6),
   PhysioFilename1 = [PhysioFilename '.puls'];
   PhysioFilename2 = [PhysioFilename '.resp'];
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
NBCOR = 1;

% Time Between 2 Physio Samples
TimeBet2PhysioSamples1 = 1/BandWidth(1);

%---------- Compute Physio Signal Phases & Cycles ----------
% Synchronize A TS Scan with The PhysioSignal Curve Recorded During TS Scan
TRIGparam    = TRIGPRM(1,:);
SIGNALyFLIP1 = SIGNALyFLIP(1);
SIG = SignalAndTimeSerieSynchrone4(PhysioFilename1, DummyTime, TR, TimePtSpan, WhichPhysio1, TimeBet2PhysioSamples1, TRIGparam, CARDchannel, SIGNALyFLIP1);

% Computes The 1st Signal Phases(Function Of Time) And Cycles Indexes At
% Record Times Of All Slices Of A TS 
if (WhichPhysio1 == 1),              % Compute RESP Phases And Cycles
   PhasesOfSlices1 = RespPhaseCycles22(SIG, TotNberOfSlices, TimeForASlice, CYCLIC);   
   
   % Create .MAT File Mame To Store Phases And Cycles
   if     CYCLIC >= 0         % Linear Phases
      PhasesCyclesFilename = [PhysioFilename 'PhasCyclRESP.mat'];
   else, %CYCLIC <  0;        % Histo. Phases   (RectroIcor)
      PhasesCyclesFilename = [PhysioFilename 'PhasHistRESP.mat'];
   end

   % Store The OUTPUT Message
   MESSAGEOUT = '\n\nRESP Arrays Of Phases/Cycles Stored.\n\n';
   
else,                                % Compute CARDorPULS Phases And Cycles
   PhasesOfSlices1 = EcgPhasesCycles2(SIG, TotNberOfSlices, TimeForASlice);
   
   % Create .MAT File Mame To Store Phases And Cycles
   if     (WhichPhysio1 == 0),      % => Case: ECG
      PhasesCyclesFilename = [PhysioFilename 'PhasCyclECG.mat']
      MESSAGEOUT = '\n\nECG Arrays Of Phases/Cycles Stored.\n\n';
   elseif (WhichPhysio1 == 2),      % => Case: PULS
      PhasesCyclesFilename = [PhysioFilename 'PhasCyclPULS.mat']
      MESSAGEOUT = '\n\nPULS Arrays Of Phases/Cycles Stored.\n\n';      
   else
      fprintf('\n\nStore Only ECG, RESP or PULS Phases & Cycles!!!!\n\n');
   end
end


% Store Phases & Cycles In Output And File Matrices
PhasesOfSlices = PhasesOfSlices1(1,:);

if (  (CYCLIC >= 2) | ((CYCLIC == 1) & ((isempty(WhichPhysio2)) | (WhichPhysio2 ~= 1)))  ),   % CYCLIC==2, CYCLIC==1 & 1Correction, CYCLIC==1 & 2Corrections & RESP as 1st Signal
   CyclesOfSlices = PhasesOfSlices1(2,:);                                                     %   * Store Cycles In The Output Matrix
   PhysioPhases1Cycles2ofSlices = [PhasesOfSlices; CyclesOfSlices];                           %   * Store Phases & Cycles In The File Matrix
else,                                                                                         % CYCLIC<=0  or CYCLIC==1 & 2Corrections & CARDorPULS as 1st Signal
   PhysioPhases1Cycles2ofSlices = PhasesOfSlices;                                             %   * Store Phases In The File Matrix
end



%------------- Prepare Parameters For Display --------------
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
SIGtime = [0:(N-1)] * TimeBet2PhysioSamples1;



%---------- DISPLAY ASSOCIATED TO THE 1st SIGNAL -----------
if Visual(1),
   %------------
   % Set X Coordinate Limits
   Xls = SIGtime(1);  Xle = SIGtime(N);
   
   % Set Signal Intensity Limites Of Display (Y Coordinate Limits)
   YIm = floor( max( SIG ) );
   YI  = num2str( YIm );
   nYI = length(YI);
   YI(nYI) = [];
   nYI = nYI-1;
   YI(1) = '2';
   for k = 2:nYI,   YI(k) = '0';   end
   dYI = round( str2num(YI)/1 );
   Yle = YIm + dYI;
   Yls = floor( min( SIG ) ) - dYI;
   
   %------------  
   % Frequency Initialization
   F  = BandWidth(1);              % Signal Frequency
   f  = F*[0:(N-1)]/N;             % Array Of Frequency Scale
   N2 = floor(N/2)+rem(N,2);       % Nber Of Pts At Half Of Frequency Scale
   
   % Power Spectra Computation
   fS  = fft( SIG );               % Compute fft( Intensities )
   PSo = fS .* conj( fS )/N;       % Compute Power Spectrum fft(Intensities)   
   is  = 1;         ie = N2;
   
   % Find The MAX Power Spectrum Value (Set PS YLim)
   YLm = floor( max( PSo(2:ie) ) );
   YL  = num2str( YLm );
   nYL = length(YL);
   YL(1) = '1';
   for k = 2:nYL,   YL(k) = '0';   end     
   YL = YLm + round( str2num(YL)/8 );
   %------------
   
   
   % Signal & Triggers Display
   if WhichPhysio1 == 1,
      figure;    plot(SIGtime, SIG, '-b',   SIGtime(TRIG), SIG(TRIG), 'or',   SIGtime(LocMIN), SIG(LocMIN), 'og');       xlim([Xls, Xle]);     ylim([Yls, Yle]);      xlabel('Time (sec)', 'Color', 'b');       ylabel('Intensity', 'Color', 'b');      title('RESP Signal And Local Maxima', 'Color', 'b');      legend('Signal', 'LocalMax', 'LocalMin');     grid on;
            
      % Superimpose Cycles To The First Signal    
      if Visual(2) > 0,
         n = length( CyclesOfSlices );
         
         if n,
            M  = mean(SIG) + ((mean(SIG(TRIG)) - mean(SIG))/100)*90;            
            FC = 3; 
            t  = [0:(TotNberOfSlices-1)] * TimeForASlice;
            
            hold on
               plot(t, (CyclesOfSlices*FC)+M, '-m');
               t = [];
            hold off
         end
      end
      
      % Power Spectrum
      figure;    plot(f(is:ie), PSo(is:ie), '-b');     xlim([f(is) f(ie)]);    ylim([0 YL]);     xlabel('Frequency (Hz)', 'Color', 'b');      title('RESP Signal Power Spectrum', 'Color', 'b');   grid on;
   else
      figure;    plot(SIGtime, SIG, '-b',   SIGtime(TRIG), SIG(TRIG), 'or');      xlim([Xls, Xle]);     ylim([Yls, Yle]);      xlabel('Time (sec)', 'Color', 'b');       ylabel('Intensity', 'Color', 'b');      title('ECG Signal And Triggers', 'Color', 'b');      legend('Signal', 'Triggers');     grid on;
            
      % Superimpose Cycles To The First Signal
      if Visual(2) > 0,
         n = length( CyclesOfSlices );
         
         if n,
            M  = mean(SIG) + ((mean(SIG(TRIG)) - mean(SIG))/100)*90;         
            FC = 1;
            t  = [0:(TotNberOfSlices-1)] * TimeForASlice;
                            
            hold on
               plot(t, (CyclesOfSlices*FC)+M, '-m');
               t = [];
            hold off
         end
      end
      
      % Power Spectrum
      figure;    plot(f(is:ie), PSo(is:ie), '-b');     xlim([f(is) f(ie)]);    ylim([0 YL]);     xlabel('Frequency (Hz)', 'Color', 'b');      title('ECG Signal Power Spectrum', 'Color', 'b');    grid on;
   end
end
%=====================
% Signal Time Scale
SIGtime = [0:(N-1)] * TimeBet2PhysioSamples1;    



%--------------- Break Point: Check TRIGGER ----------------
% Break Point To Check If TRIGGER (and Local Minima) Are Well Positionned
fprintf('\n\n ==================== 1st SIGNAL ===================='); 
fprintf('\n INSPECT THE SIGNAL CAREFULLY, CHECKING IF TRIGGERS AND'); 
fprintf('\n           LOCAL MINIMA ARE WELL POSITIONNED.          ');
fprintf('\n IF NOT, YOU COULD EVENTUALLY QUIT THE PROGRAM OR DECIDE');
fprintf('\n                  TO CONTINUE ANYWAYS                   ');
fprintf('\n ====================================================\n\n');
reply = input('<<    Do you want to quit the program? Y/N [N]:    \n\n>>', 's');
if (reply == 'Y'),
   error('You have decide to left the program.....!');            
end



%--- Store Physio Signal Phases & Cycles In A .MAT File ----
if (Store(1) > 0)
   save(PhasesCyclesFilename, 'PhysioPhases1Cycles2ofSlices');
   fprintf( MESSAGEOUT );     
end
PhysioPhases1Cycles2ofSlices = [];


%--------------- Initialization Of Outputs  ----------------
% Store Signal Elements For The 3rd Output
if (nargout == 3),
   SIGNALS.Sig1   = SIG;
   SIGNALS.Time1  = SIGtime;
   SIGNALS.Trig1  = TRIG;
   SIGNALS.LocMn1 = LocMIN;
end

% Delete Array
SIG     = [];  
SIGtime = [];    
TRIG    = [];   
LocMIN  = [];  
PhasesOfSlices1 = [];





%========== PHYSIO SIGNAL PHASE & CYCLES COMPUTING: If 2 Signals ==========
if length( WhichPhysio2 ) ~= 0,
   NBCOR = 2;
      
   % Time Between 2 Physio Samples
   TimeBet2PhysioSamples2 = 1/BandWidth(2);
   
   
   %---------- Compute Physio Signal Phases & Cycles ----------
   % Synchronize A TS Scan with The PhysioSignal Curve Recorded During TS Scan
   TRIGparam    = TRIGPRM(2,:);
   SIGNALyFLIP2 = SIGNALyFLIP(2);
   SIG = SignalAndTimeSerieSynchrone4(PhysioFilename2, DummyTime, TR, TimePtSpan, WhichPhysio2, TimeBet2PhysioSamples2, TRIGparam, CARDchannel, SIGNALyFLIP2);

   % Computes Physiological Phases( Function Of Time) And Cycles Indexes At
   % Record Time Of All Slices Of A TS Image 
   if WhichPhysio2 == 1,             % Compute RESP Phases And Cycles
      % Compute RESP Phases And Cycles
      PhasesOfSlices1 = RespPhaseCycles22(SIG, TotNberOfSlices, TimeForASlice, CYCLIC);
    
      % Create .MAT File Mame To Store Phases And Cycles
      if     CYCLIC >= 0         % Linear Phases
         PhasesCyclesFilename = [PhysioFilename 'PhasCyclRESP.mat'];
      else, %CYCLIC <  0;        % Histo. Phases   (RectroIcor)
         PhasesCyclesFilename = [PhysioFilename 'PhasHistRESP.mat'];
      end
      
      % Store The OUTPUT Message
      MESSAGEOUT = '\n\nRESP Arrays Of Phases/Cycles Stored.\n\n';
             
   else,                             % Compute CARDorPULS Phases And Cycles
      % Compute Phases And Cycles 
      PhasesOfSlices1 = EcgPhasesCycles2(SIG, TotNberOfSlices, TimeForASlice);
            
      % Create .MAT File Mame To Store Phases And Cycles
      if     (WhichPhysio2 == 0),      % => Case: ECG
         PhasesCyclesFilename = [PhysioFilename 'PhasCyclECG.mat'];
         MESSAGEOUT = '\n\nECG Arrays Of Phases/Cycles Stored.\n\n';
      elseif (WhichPhysio2 == 2),      % => Case: PULS
         PhasesCyclesFilename = [PhysioFilename 'PhasCyclPULS.mat'];
         MESSAGEOUT = '\n\nPULS Arrays Of Phases/Cycles Stored.\n\n';      
      else
         fprintf('\n\nStore Only ECG, RESP or PULS Phases & Cycles!!!!\n\n');
      end
   end
   
      
   % Store Phases & Cycles In Output And File Matrices
   PhasesOfSlices = [PhasesOfSlices; PhasesOfSlices1(1,:)];                        % Store Phases In The Output Matrix
   
   if (  (CYCLIC >= 2) | ((CYCLIC == 1) & (WhichPhysio2 == 1))  ),                 % CYCLIC==2 OR CYCLIC==1 & 2Corrections & RESP as 2nd Signal
      CyclesOfSlices = [CyclesOfSlices; PhasesOfSlices1(2,:)];                     %   * Store Cycles In The Output Matrix
      PhysioPhases1Cycles2ofSlices = [PhasesOfSlices(2,:);  PhasesOfSlices1(2,:)]; %   * Store Phases & Cycles In The File Matrix
   else,                                                                           % CYCLIC<=0  or CYCLIC==1 & 2Corrections & CARDorPULS as 2nd Signal
      PhysioPhases1Cycles2ofSlices =  PhasesOfSlices(2,:);                         %   * Store Phases In The File Matrix
   end
      
   
   %------------- Prepare Parameters For Display --------------
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
   end

   SIG = SIG.signal(ss:se);              % Retrieve Physio Signal
   N   = length( SIG ); 

   % Compute The Signal Time Scale
   SIGtime = [0:(N-1)] * TimeBet2PhysioSamples2;
   
   
   %---------- DISPLAY ASSOCIATED TO THE 2nd SIGNAL -----------
   if (Visual(1) > 0),
      %------------
      % Frequency Initialization
      F  = BandWidth(2);              % Signal Frequency
      f  = F*[0:(N-1)]/N;             % Array Of Frequency Scale
      N2 = floor(N/2)+rem(N,2);       % Nber Of Pts At Half Of Frequency Scale
      
      % Power Spectra Computation
      fS  = fft( SIG );               % Compute fft( Intensities )
      PSo = fS .* conj( fS )/N;       % Compute Power Spectrum fft(Intensities)   
      is  = 1;         ie = N2;
      
      % Find The MAX Power Spectrum Value (Set PS YLim)
      YLm = floor( max( PSo(2:ie) ) );
      YL  = num2str( YLm );
      nYL = length(YL);
      YL(1) = '1';
      for k = 2:nYL,   YL(k) = '0';   end     
      YL = YLm + round( str2num(YL)/5 );
      %------------
      
      % Set X Coordinate Limits
      Xls = SIGtime(1);  Xle = SIGtime(N);
      
      % Set Signal Intensity Limites Of Display (Y Coordinate Limits)
      YIm = floor( max( SIG ) );
      YI  = num2str( YIm );
      nYI = length(YI);
      YI(nYI) = [];
      nYI = nYI-1;
      YI(1) = '2';
      for k = 2:nYI,   YI(k) = '0';   end
      dYI = round( str2num(YI)/8 );
      Yle = YIm + dYI;
      Yls = floor( min( SIG ) ) - dYI;
      %------------
      
      % Signal & Triggers Display
      if WhichPhysio2 == 1,
         figure;    plot(SIGtime, SIG, '-b',   SIGtime(TRIG), SIG(TRIG), 'or',   SIGtime(LocMIN), SIG(LocMIN), 'og');       xlim([Xls, Xle]);     ylim([Yls, Yle]);      xlabel('Time (sec)', 'Color', 'b');       ylabel('Intensity', 'Color', 'b');      title('RESP Signal And Local Maxima', 'Color', 'b');      legend('Signal', 'LocalMax', 'LocalMin');     grid on;
         
         % Superimpose Cycles To The Second Signal
         if Visual(2) > 0,
            n = size( CyclesOfSlices );
            if n,
               n  = n(1);            
               M  = mean(SIG) + ((mean(SIG(TRIG)) - mean(SIG))/100)*90;            
               FC = 3; 
               t  = [0:(TotNberOfSlices-1)] * TimeForASlice;
               
               hold on
                  plot(t, (( CyclesOfSlices(n,:) )*FC)+M, '-m');
                  t = [];
               hold off
            end
         end
         
         % Power Spectrum
         figure;    plot(f(is:ie), PSo(is:ie), '-b');     xlim([f(is) f(ie)]);    ylim([0 YL]);     xlabel('Frequency (Hz)', 'Color', 'b');      title('RESP Signal Power Spectrum', 'Color', 'b');   grid on;
      
      else
         figure;    plot(SIGtime, SIG, '-b',   SIGtime(TRIG), SIG(TRIG), 'or');      xlim([Xls, Xle]);     ylim([Yls, Yle]);      xlabel('Time (sec)', 'Color', 'b');       ylabel('Intensity', 'Color', 'b');      title('ECG Signal And Triggers', 'Color', 'b');      legend('Signal', 'Triggers');     grid on;         

         % Superimpose Cycles To The Second Signal
         if Visual(2) > 0,
            n = size( CyclesOfSlices );
            if n,
               n  = n(1);            
               M  = mean(SIG) + ((mean(SIG(TRIG)) - mean(SIG))/100)*90;            
               FC = 1; 
               t  = [0:(TotNberOfSlices-1)] * TimeForASlice;
               
               hold on
                  plot(t, (( CyclesOfSlices(n,:) )*FC)+M, '-m');
                  t = [];
               hold off
            end
         end
                  
         % Power Spectrum
         figure;    plot(f(is:ie), PSo(is:ie), '-b');     xlim([f(is) f(ie)]);    ylim([0 YL]);     xlabel('Frequency (Hz)', 'Color', 'b');      title('ECG Signal Power Spectrum', 'Color', 'b');    grid on;
      end
   end
   %=====================   
   
   
   
 
   %--------------- Break Point: Check TRIGGER ----------------
   % Break Point To Check If TRIGGER (and Local Minima) Are Well Positionned
   fprintf('\n\n ==================== 2nd SIGNAL ===================='); 
   fprintf('\n INSPECT THE SIGNAL CAREFULLY, CHECKING IF TRIGGERS AND'); 
   fprintf('\n           LOCAL MINIMA ARE WELL POSITIONNED.          ');
   fprintf('\n IF NOT, YOU COULD EVENTUALLY QUIT THE PROGRAM OR DECIDE');
   fprintf('\n                  TO CONTINUE ANYWAYS                   ');
   fprintf('\n ====================================================\n\n');
   reply = input('<<    Do you want to quit the program? Y/N [N]:    \n\n>>', 's');
   if (reply == 'Y'),
      error('You have decide to left the program.....!');            
   end
   
   
   
   %--- Store Physio Signal Phases & Cycles In A .MAT File ----
   % Store Phases And Cycles In A .MAT File 
   if (Store(2) > 0)
      save(PhasesCyclesFilename, 'PhysioPhases1Cycles2ofSlices');
      fprintf( MESSAGEOUT );     
   end
   PhysioPhases1Cycles2ofSlices = [];
   
   
   %--------------- Initialization Of Outputs  ----------------
   % Store Signal Elements For The 3rd Output
   if (nargout == 3),
      SIGNALS.Sig2   = SIG;
      SIGNALS.Time2  = SIGtime;
      SIGNALS.Trig2  = TRIG;
      SIGNALS.LocMn2 = LocMIN;
   end

   % Delete Array
   % clear SIG SIGtime TRIG LocMIN PhasesOfSlices1
end





