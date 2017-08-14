function EcgPhases = EcgPhasesCycles2(PHYSIO, TotNberOfSlices, TimeForASlice)
%==========================================================================
% ECGPHASESCYCLES: Computes Phases And Cycles Of The Cardiac (CARDorECG) At 
% Times Of Acquisition Of TS Slices As following:
%
%
%               (Current Slice Record Time - Current Trigger Time)
%  TimePhase =  -------------------------------------------------- * (2*pi) 
%               (Next Trigger Time         - Current Trigger Time)
%
%
% INPUT:
%  * PHYSIO         --> Structure Of ECG Samples With Following Fields:
%                        * SIGNAL   => ECG samples
%                        * TRIG     => R-Waves Triggers
%                        * 1stTRIG  => Recorded Just Before TS Acquisition
%                        * LASTTRIG => Recorded Just After  TS Acquisition
%                        * TIMEBET2RESPSAMPLES => ECG Sampling Time
%                        * DELAYBEFORESCAN => Delay To The Start Of TS Acq.
%                        * TIMEBEFOREFIRSTVOLUME => Time To 1st Volume
%
%  * TOTNBEROFSLICES--> Nber Of Slices In The Whole Time Series
%
%  * TIMEFORASLICE  --> Record Time for A Single Slice
%
%
% OUTPUT:
%  * ECGPHASES      --> Matrice Of Phases (1st Row) And Cycles (2nd Row)
%
%---------------------------------------------
% A. ELLA, Univ. Hospital Freiburg, Diag. Radiol, Medical Physics, 2008
% Arsene.Ella@uniklinik-freiburg.de
%==========================================================================



%=========================== PHYSIO EXTRACTIONS ===========================
% Extracts Triggers Parameters
TRIG      = PHYSIO.Trig;
FirstTrig = PHYSIO.FirstTrig;
LastTrig  = PHYSIO.LastTrig;

% Extracts Times
TimeBeforeFirstVolume = PHYSIO.TimeBeforeFirstVolume;
TimeBet2RespSamples   = PHYSIO.TimeBet2PhysioSamples; 


%================ SETTING CYCLES OF THE WHOLE ECG SIGNAL ==================
Nsi = length(PHYSIO.signal);  % Length Of The Physio Signal Array
N   = LastTrig - FirstTrig;   % Number Of ECG Cycles During TS Acqusition
ns  = TRIG( FirstTrig );      % ECG Index at The 1st TRIGGER
ne  = TRIG( LastTrig  );      % ECG Index at The Last TRIGGER
Cyc = [];                     % Carries Physio Signal Cycles (Length = Nsi)

% Compute The Length (in Pts) Of All ECG Cycles Between 1st And Last TRIG
CySl = TRIG( (FirstTrig+1):LastTrig )  -  TRIG( FirstTrig:(LastTrig-1) );
CySl = floor(CySl);

% Fill With Zeros From The Beginning Of The ECG Signal To The 1st TRIGGER
if ns > 1,       Cyc = zeros(1, ns-1);   end

% Fill Signal Cycles Between The 1st & The Last TRIGGER
for i = 1:N,    Cyc = [Cyc, i*ones(1, CySl(i))];   end    %CySl(i),

Cyc = [Cyc, N+1];              % Fill The Cycle Nber at The Last TRIGGER

% Fill With Zeros From The Last TRIGGER To The End Of The ECG Signal
if Nsi > ne,    Cyc = [Cyc, zeros(1, (Nsi-ne))];   end


%====== COMPUTE RESP INTENSITIES AT TIMES WHERE SLICES ARE RECORDED =======
% Compute Times At All TRIGGER
TRIG = (TRIG - 1) * TimeBet2RespSamples;

% Compute The Time At The First TRIGGER (Just Before The Start Of TS Acq.)
TimeAtFirstTRIG = TRIG( FirstTrig );
%TimeAtFirstTRIG = (ns - 1) * TimeBet2RespSamples;

% Compute Times (ECG Signal Times) At All TS Slice Acquisition
Ts = TimeBeforeFirstVolume + ([0:(TotNberOfSlices-1)] * TimeForASlice);

% Compute The Number Of ECG Samples Between Each Slice And The 1st TRIGGER 
% NB: They Can Be Float Values
CySl = (Ts - TimeAtFirstTRIG)/TimeBet2RespSamples;

% Compute The Number Of ECG Samples Between Each Slice And The Beginning Of 
% The ECG Signal Record (ECG Signal Indexes At Each TS Slice Acquisition)
% NB: They Are Integer Values
CySl = floor( CySl ) + ns;

% Find ECG Cycles At Times Of Acquisition Of TS Slices
CySl = Cyc( CySl );
Cyc  = [];


%================ COMPUTE THE CARDIAC (ECG) SIGNAL PHASES =================
% Find Times At All TRIGGER Between The 1st And The Last TRIGGERS
TRIG = TRIG(FirstTrig:LastTrig);

% Compute The Time Differences Between TS Slice Samples And Their Nearest 
% TRIGGERS
Ts = Ts - TRIG(CySl);

% Compute The Time Differences Between Consecutive TRIGGERS, From Of The 
% 1st To The Last TRIGGER
TRIG = TRIG(2:(N+1)) - TRIG(1:N);
TRIG = TRIG( CySl );

% Compute & Store All Phases At TS Slice Acquisition
EcgPhases = (Ts./TRIG)*(2*pi);
i = find(EcgPhases <= pi);

% Store All Cycles At TS Slice Acquisition
EcgPhases(2,:) = CySl;
EcgPhases(2,i) = -CySl(i);











