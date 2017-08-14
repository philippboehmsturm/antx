function RespPhases = RespPhaseCycles22(PHYSIO, TotNberOfSlices, TimeForASlice, CYCLIC)
%==========================================================================
% RESPPHASECYCLE22: Computes Phases And Cycles Of The Respiration Signal At 
% Times Of Acquisition Of TS Slices Using:
%
%   1) Linear Relationship Between RESP Signal Amplitudes and Phases:
%
%                              dR
%              Phase(t) =  ---------- * Sign(dR/dt) * pi 
%                          Rmx - Rmn
%
%              with:  dR = Rt - Rmn, dt = t - t0
%
%    * Rt  = RESP Amplitude at Time Of A Slice Record 
%    * Rmx = RESP Amplitudes at Nearest Local Maximun (TRIGGER)
%    * Rmn = RESP Amplitudes at Nearest Local Minimum 
%    * t   = Time At Slice Record
%    * t0  = Time At Rmn
%
%   2) An Histogram Of RESP Signal Amplitudes
%
%                          CUMSUM( H(1:i) )
%              Phase(t) =  ---------------- * Sign(dR/dt) * pi 
%                           SUM( H(1:100) )
%
%              with:  i = Round(Rt/Rmax * 100),  dR = Rt - Rmin
%
%    * Rt     = RESP Amplitude at Time Of A Slice Record 
%    * Rmax   = Difference Between Max & Min Amplitudes Of The RESP Signal 
%    * Rmin   = Minimum Amplitude Of The RESP Signal
%    * H(b)   = Histogram Of 100 bins (b), where the bth bin is centered at
%               (b*Rmax)/100
%    * CUMSUM = Cumulative Sum
%
%
% INPUT:
%  * PHYSIO        --> Structure Of RESP Samples.
%                       * SIGNAL   => RESP samples
%                       * TRIG     => Triggers ( Array Of Local Maxima)
%                       * LOCMIN   => Array Of Local Minima
%                       * 1stTRIG  => Recorded Just Before TS Acquisition
%                       * LASTTRIG => Recorded Just After TS Acquisition
%                       * 1stLOCMIN  => Recorded Just Before TS Acquisition
%                       * LASTLOCMIN => Recorded Just After TS Acquisition
%                       * TIMEBET2RESPSAMPLES => RESP Sampling Time
%                       * DELAYBEFORESCAN  => Delay To The Start Of TS Acq.
%                       * TIMEBEFOREFIRSTVOLUME => Time To 1st Volume
%
%  * TIMEFORASLICE --> Record Time for A Single Slice
%
%  * TOTNBEROFSLICES--> Nber Of Slices For The Whole Time Series
%
%  * CYCLIC        --> Checks If RESP Phases Is Computed Linear Or If They 
%                      Are Computed Using A Histogram 
%                       * CYCLIC  = -1 => Histogram With Global Rmax
%                       * CYCLIC >=  0 => Linear
%
% OUTPUT:
%  * RESPPHASES    --> Matrice Of Phases (1st Row) And Cycles (2nd Row)
%
%---------------------------------------------
% A. ELLA, Univ. Hospital Freiburg, Diag. Radiol, Medical Physics, 2008
% Arsene.Ella@uniklinik-freiburg.de
%==========================================================================


%=========================== PHYSIO EXTRACTIONS ===========================
% Extracts The Signal
RESP = PHYSIO.signal;

% Extracts Local Maximun Parameters
TRIG      = PHYSIO.Trig;
FirstTrig = PHYSIO.FirstTrig;
LastTrig  = PHYSIO.LastTrig;

% Extracts Local Minimun Parameters
LocMIN      = PHYSIO.LocMIN;
FirstLocMIN = PHYSIO.FirstLocMIN;
LastLocMIN  = PHYSIO.LastLocMIN;

% Extracts Times
TimeBeforeFirstVolume  = PHYSIO.TimeBeforeFirstVolume;
TimeBet2RespSamples    = PHYSIO.TimeBet2PhysioSamples; 


%=============== CYCLES OF THE WHOLE PHYSIO SIGNAL SETTING ================
Nsi = length( RESP );      % Length Of The Physio Signal Array
Ne  = FirstTrig;
N   = LastTrig;            % Length Of The Usefull Local Max Array
Nlme= FirstLocMIN;
Nlm = LastLocMIN;          % Length Of The Usefull Local Min Array (= N+1)
n   = LocMIN(Nlme);        % Value Of The 1st Local Min  % = LocMIN(1)
Cyc = [];                  % Carries Physio Signal Cycles (Length = Nsi)

% Compute Spans Between Local Max And Local Min (Or Reverses)
LengthCycPos = TRIG(Ne:N)  -  LocMIN(Nlme:(Nlm-1)); % LocMax-LocMin => Cyc Pos Parts
LengthCycNeg = LocMIN((Nlme+1):Nlm) - TRIG(Ne:N);   % LocMin-LocMax => Cyc Neg Parts

N = length( LengthCycPos );


% Fill With Zeros From The Sig. Starting To The 1st Local maximun
if n > 1
   Cyc = zeros(1,n-1);
end

% Fill Signal Cycles Between The 1st & The Last Local Minimum. For The ith
% Cycle, Values:    +i ---> Before The Current Local Maximum
%                   -i ---> After  The Current Local Maximum
for i = 1:N,    
   Cyc = [Cyc, i*ones(1, LengthCycPos(i)), -i * ones(1, LengthCycNeg(i))];    
end

Cyc = [Cyc, Nlm];     % Fill the cycle Nber at LocMIN(Nlm)


% Fill With Zeros From The Last Local Minimum To The End Of The Sig. Length
if Nsi > LocMIN(Nlm)
   n   = Nsi - LocMIN(Nlm);
   Cyc = [Cyc, zeros(1,n)];
end



%====== COMPUTE RESP INTENSITIES AT TIMES WHERE SLICES ARE RECORDED =======
% RESP Index at The First Local Minimum
FirstLocMIN = LocMIN( FirstLocMIN );

% Compute The Respiration Time at StartResp Index (index in RESP)
FirstLocMINTime = (FirstLocMIN - 1) * TimeBet2RespSamples;

% Compute All TS Slice Times In RESP Times
R = TimeBeforeFirstVolume + ([0:(TotNberOfSlices-1)] * TimeForASlice);

% Compute The Number Of RESP Samples Between Slices And The StartResp
% NB: They Are Float Values
R = (R - FirstLocMINTime)/TimeBet2RespSamples;

% Compute Sample Weighted Differences Between Slices And Their Nearest 
% Previous RESP Samples (Values Are Between 0 and 1)
IntAtSlices = R - floor(R);

% RESP Sample Indexes Before Slices (Integer Values)
R = floor(R) + FirstLocMIN;


% Check If Slice Indexes Are Out Of The Range Of The
% Physio Signal Indexes
NS = TotNberOfSlices;

if R(TotNberOfSlices) > Nsi % Should Never Happen
   i  = find(R >= Nsi);
   i  = i(1)-1;
   NS = i;
   
   R     = R(1:NS);
   IntAtSlices = IntAtSlices(1:NS);
end

% Compute RESP Intensities At Slices Times By Linear Interpolation
IntAtSlices = RESP(R) + ( (RESP(R+1) - RESP(R)).*IntAtSlices );


%================= COMPUTE THE RESPIRATION SIGNAL PHASES ==================
% Initialization
RespPhases = zeros(2, TotNberOfSlices);


% Compute RESP Phases At Times Of Acquisition Of Slices
n  = Cyc(R);

if      CYCLIC >= 0                  % Local Rmax CYCLIC(>0) or NOT(0)
   % Compute Positive Resp Phases At Times Of Acquisition Of Slices
   i    = find(n > 0);               % Find Indexes Of Positive Phases
   j    = n(i);                      % Store These Positive Phases
   Lmn  = RESP( LocMIN(j) );         % LocalMins Of Positive Phases
   
   Rmax = RESP( TRIG(j) ) - Lmn;     % Rmax Of Positive Phases
   sgndRdt = 1;                      % Signe Of Positive Phases
   RespPhases(1,i) = ( (IntAtSlices(i) - Lmn)./Rmax ) * sgndRdt * pi;

   % Compute Negative Resp Phases At Times Of Acquisition Of Slices
   i    = find(n <= 0);              % Find Indexes Of Negative Phases
   j    = n(i);                      % Store These Negative Phases
   j    = abs(j);
   Lmn  = RESP( LocMIN(j+1) );       % LocalMins Of Negative Phases
   
      
   Rmax = RESP( TRIG(j) ) - Lmn;     % Rmax Of Negative Phases
   sgndRdt = -1;                     % Signe Of Negative Phases
   RespPhases(1,i) = ( (IntAtSlices(i) - Lmn)./Rmax ) * sgndRdt * pi;
         
   % End Message Settting  
   MESSAGEOUT = '\n\nLinear RESP Phases/Cycles Computed.\n\n';   
      
else  % CYCLIC <  0;                 % Global Rmax With HISTO  (RectroIcor)
   FirstLocMIN = PHYSIO.FirstLocMIN;
   
   % RESP Global Maximum & Minimum Intensity Values
   if      CYCLIC == -1,                  % Rmax = SigMax - SigMin  
      MaxResp = max( RESP( TRIG(FirstTrig:LastTrig) ) );         % Max(TRIG)
      MinResp = min( RESP( LocMIN(FirstLocMIN:LastLocMIN) ) );   % Min(LocMIN)      
      
      % End Message Settting         
      MESSAGEOUT = '\n\nHisto RESP Phases/Cycles with Rmax = max(TRIG) - min(LocMIN) Computed.\n\n';
   else  % CYCLIC <= -2;                 % Rmax = Mean(TRIG) - Mean(LocMIN)
      MaxResp = mean( RESP( TRIG(FirstTrig:LastTrig) ) );        % Mean(TRIG)
      MinResp = mean( RESP( LocMIN(FirstLocMIN:LastLocMIN) ) );  % Mean(LocMIN)                        
               
      % End Message Settting  
      MESSAGEOUT = '\n\nHisto RESP Phases/Cycles with Rmax = mean(TRIG) - mean(LocMIN) Computed.\n\n';
   end
   
   % Compute The Rmax
   Rmax = MaxResp - MinResp;              % RESP Amplitude Span
      
   % Set The Start & End RESP Indexes For the Histogram
   Ft = TRIG(FirstTrig);         
   Lt = TRIG(LastTrig);
   Fm = LocMIN(FirstLocMIN);     
   Lm = LocMIN(LastLocMIN);
   
   if Ft > Fm,    si = Fm;    else,     si = Ft;    end;
   if Lt > Lm,    se = Lt;    else,     se = Lm;    end;
   
   % Compute The RESP Histogram Bins:  b = (R(t)/Rmax)*100 (float)
   H = round(  ( (RESP(si:se) - MinResp)/Rmax ) * 100  );
   i = find(H  <=  0);         H(i) = 1;
   i = find(H  > 100);         H(i) = 100;
   
   % Compute The RESP Histogram
   H    = hist(H,100);   
   SumH = sum(H);     %             SUM( H(1:100) )
   CumH = cumsum(H);  % Cummulative SUM( H(1:i)   )   for All i = 1,...,100
   
   % Compute Bins At Times Of Slice Record, From Relative RESP Amplitudes 
   % R(t):  B = R(t)*100 (float)
   R = round(  ( (IntAtSlices - MinResp)/Rmax ) * 100  );
   i = find(R <= 0);           R(i) = 1;
   i = find(R > 100);          R(i) = 100;
   
   % Set The Sign Array
   sgndRdt = n./abs(n);
      
   % Compute:  PHASE(t) = pi * ( SUM( H(1:i) )/SUM( H(1:100) ) ) * Sign(dR/dt)
   % With   :  i = INT( R(t) * 100)
   RespPhases(1,:) = ( (CumH(R)/SumH).*sgndRdt ) * pi;
end


% Store Resp Cycles At Times Of Acquisition Of Slices
RespPhases(2,:) = n;

% End Message Display 
fprintf( MESSAGEOUT );
