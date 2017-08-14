function PHYSIO = SignalAndTimeSerieSynchrone4(PhysioFilename, DummyTime, TR, TimePtSpan, WhichPhysio, TimeBet2PhysioSamples, TRIGPRM, CARDchannel, SIGNALyFLIP)
%==========================================================================
% SIGNALANDTIMESERIESYNCHRONE4: Synchronize a fMRI Time Series (TS) Scan   
% With A Physiological (PHYSIO) Signal Curve Recorded In Parallel. It Per-
% forms The Following:
%  1) Opens and Retrives The Signal From the PHYSIO Signal File
%     
%  2) Discards the Beginning Of The PHYSIO Signal Until the Signalization 
%     Of The Start Of TS Acquisition
%  3) Retrieves Or Computes Positions Of PHYSIO Signal Triggers (On Top Of
%     R-waves in A ECG Or On Top Of RESP&PULS Waves) And Local Maxima (Down
%     Positions Of RESP Waves)
%  4) Stores Triggers And Local Maxima
%
%
% INPUT:
%  * PHYSIOFILENAME --> Physiological Signal File Name With Path&Extension 
%
%  * DUMMYTIME      --> Dummy Measurement Time = Time Before TS Acquisition
%                       In Second
%
%  * TR             --> Repetion Time (Time Between 2 TS Time Points)
%
%  * TIMEPTSPAN     --> The Start(START) & End(END) TS Time Points Or Vo-
%                       lumes Involved In The Required Signal Phases And  
%                       Cycles Cumputation. START And END Are Taken Among
%                       The Whole Range Of Acquired Volumes Spanned Between
%                       1 and ALLTPS. 
%                         * TIMEPTSPAN == [START END ALLTPS] =>Only Volumes 
%                                   From START to END Are Used Among ALLTPS
%                             
%                         * TIMEPTSPAN == [1  ALLTPS ALLTPS] => All Volumes 
%                                   From  1 to ALLTPS Are Used Among ALLTPS
%
%  * WHICHPHYSIO    --> Flag Checking Which Physio Signal to Be Corrected
%                         * WHICHPHYSIO == 0      => ECG 
%                         * WHICHPHYSIO == 1 or 2 => RESP or PULS
%
%  * TIMEBET2PHY-   --> Signal Sample Period. Siemems Tim TRIO Values are:
%    SIOSAMPLES           * TIMEBET2PHYSIOSAMPLES = 1/400 => ECG 
%                         * TIMEBET2PHYSIOSAMPLES = 1/50  => RESP or PULS
%
%  *  TRIGPRM       --> Array Of 3 Elements (or a 2x3 matrix when 2 signals
%                       are required to be corrected) Used To Set Triggers:
%                        * TRIGPRM(1)==0 => - Uses Triggers Recorded During 
%                                             The TS Acquisiton To Compute
%                                             New Positions Of Triggers.
%                                           - NO NEED TO SET TRIGPRM(2)&(3
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
%  * CARDCHANNEL    --> Check Which CARD(ECG) signal To Choose When Several 
%                       Channels are Used During The EGG Acquisition.
%                       Several ECG Channels => Several CARD Signals.
%
%  * SIGNALyFLIP    --> Checks If The Signal MustBe Y-Flipped. It Should Be
%                       A 2 Elements Array When Dealing With 2 Signals:
%                         * SIGNALyFLIP  > 0 => Y-Flipped
%                         * SIGNALyFLIP <= 1 => No Y-Flipped
%
%
% OUTPUT:
%    * PHYSIO(Structure)
%     - PHYSIO.SIGNAL      -> Array of A Cleaned PHYSIO Signal
%     - PHYSIO.TRIG        -> Array of Trigger (R-Waves Or Local Max)
%     - PHYSIO.FirstTrig   -> 1st Trigger Before Image Real Acquisition
%     - PHYSIO.LastTrig    -> Last Trigger After Image Real Acquisition
%     - PHYSIO.FirstLocMIN -> 1st LocalMin Before Image Real Acquisition
%     - PHYSIO.LastLocMIN  -> Last LocalMin After Image Real Acquisition
%     - PHYSIO.StartDelay  -> Delay to the fMRImage Dummy Mesure Start
%     - PHYSIO.DelayBeforeScan       -> DummyTime + StartDelay
%     - PHYSIO.TimeBeforeFirstVolume -> DelayBeforeScan + TimePtSpan(1)*TR
%     - PHYSIO.TimeBet2PhysioSamples -> Time Between 2 PHYSIO Samples (Sec)
%     - PHYSIO.FirstSignalIndexInTS  -> First Signal Index In Time Series
%     - PHYSIO.LastSignalIndexInTS   -> Last  Signal Index In Time Series
%
%---------------------------------------------
% A. ELLA, Univ. Hospital Freiburg, Diag. Radiol, Medical Physics, 2008
% Arsene.Ella@uniklinik-freiburg.de
%==========================================================================


%------------ OPEN & READ THE PHYSIO SIGNAL FILE INTO AN ARRAY ------------
% Open the PHYSIO File in the READ mode
fid = fopen(PhysioFilename, 'r');
if (fid == -1)
   disp('Cannot Open The Physio File');
   return;
end

% READ PHYSIO FILE: with no Offset( 0 ) and Starting at the beginning of  
% the File (Bof), Read a whole Line until the End. The Line terminator (\)
% is NOT INCLUDED!!!!
fseek(fid, 0, 'bof');        % Set The Cursor at the beginning of the File
RawPHY = fgetl( fid );       % Read the Line until the End, WITHOUT (\)!
fclose( fid );               % Close the Physio File

%------------ REMOVE THE STARTING TIPS FROM THE PHYSIO SIGNAL -------------
N = length( RawPHY );

% Finds The beginning of the Warning String ("xSecToStart")
StEndFlag = strfind(RawPHY, '5002');             
Nst       = length( StEndFlag );

i  = find(StEndFlag < floor(N/2));     
NS = length(i);      
i  = i(end);

% Set The TIM Flag
TimFlag = 0;      

if NS > 1,   
   TimFlag = 1;    
end

% Retrives the number of Seconds to Start Recording Images
StartDelay = str2num( RawPHY(StEndFlag(i) + 5) );

% Finds The End of the Warning String ("xSecToStart")
StartFlag  = strfind(RawPHY, '6002');

% Retrives & Transforms Into an Array of Numbers PHYSIO Values 
% Recorded After the Starting of Image Acquistion
if (Nst == NS),                                
   RawPHY = str2num( RawPHY((StartFlag(i)+4):(N-5)) );    
else
   RawPHY = str2num( RawPHY((StartFlag(i)+4):(StEndFlag(Nst)-2)) );
end

% Compute The Delay Before the Scan And the Total Duration Of Acquisition
% TS Time Of Acquisition
TSS = TimePtSpan(1);                                         % First Time Point (Volume) Used In The TS
TSE = TimePtSpan(2);                                         % Last  Time Point (Volume) Used In The TS
Ntt                    = TSE - TSS + 1;                      % Number Of Time Points (Volumes) Used In The TS
AcqDuration            = TR*Ntt;                             % TS Acquisition Duration
DelayBeforeScan        = StartDelay      + DummyTime;         % (in Seconds)
TimeBeforeFirstVolume  = DelayBeforeScan + ((TSS-1)*TR);      % (in Seconds)
ExpectedAcquisDuration = TimeBeforeFirstVolume + AcqDuration; % (in Seconds)


%-------- REMOVE RECORDED TRIGGERS (5000 & 6000) FROM THE SIGNAL ----------
I = find(RawPHY == 6000);   RawPHY(I) = [];
I = find(RawPHY == 5000);   RawPHY(I) = [];
N = length( I );            Nst = length(RawPHY);
I = reshape(I, 1, N);

% Deal With The Fact That 2 ECG Signals Are Recorded On TIM
if ((WhichPhysio == 0) & (TimFlag == 1))
   % Deal Case Odd Nber Of Elts
   if (rem(Nst,2) == 1),
      RawPHY(Nst+1) = RawPHY(Nst-1);
      Nst = Nst+1;
   end    
    
   % Transform In 2 Arrays Of Signals
   Nst    = round(Nst/2);
   RawPHY = reshape(RawPHY, 2, Nst); 
   
   % Choose The Signal With Lower Values
   RawPHY = RawPHY(CARDchannel,:);
       
   % Set Trigger Indexes
   I = round( (I - [1:N])/2 ) + 1;
else
   I = (I - [1:N]) + 1;
end


% Y-flipped the signal (SIGyFLIP>0) or not (SIGyFLIP<=0)
if (SIGNALyFLIP > 0)
   MeanRawPHY = mean(RawPHY);
   RawPHY     = RawPHY - MeanRawPHY;
   RawPHY     = MeanRawPHY - RawPHY;
end


% Plot The Original Signal & Trigger For An overview
t = [0:(Nst-1)] * TimeBet2PhysioSamples;

if (WhichPhysio == 0)      % => ECG
   figure;     plot(t, RawPHY, '-b', t(I), RawPHY(I), 'or');      xlabel('Time (sec)', 'Color', 'b');       ylabel('Intensity', 'Color', 'b');      title('ECG Signal As Aquired',  'Color', 'b');    legend('Signal', 'Triggers');    grid on
else                       % => RESP
   figure;     plot(t, RawPHY, '-b', t(I), RawPHY(I), 'or');      xlabel('Time (sec)', 'Color', 'b');       ylabel('Intensity', 'Color', 'b');      title('RESP Signal As Aquired', 'Color', 'b');    legend('Signal', 'Triggers');    grid on   
end
t = [];


% Check The Accordance Between The Physio Signal 
% Duration And The Duration Of The TS Acquisition 
PhysioSignalDuration  = (Nst-1) * TimeBet2PhysioSamples;

% Display a Warning Message In case Of a Short Physio Signal
if ExpectedAcquisDuration > PhysioSignalDuration,    
   warning('DURATION OF TS ACQUISITION + DELAY BEFORE THE SCAN should be < PHYSIO SIGNAL DURATION!!!! Please check STARTDELAY & DUMMYTIME');
   warning('This could be a source of further ERROR MESSAGES!!!!');
end


%------------ COMPUTE TRIGGERS (ECG) OR LOCAL MAX&MIN (RESP) --------------

if (TRIGPRM(1) == 0),   % ===> Computes Triggers Using Acquired One

   %=======================================
   if (WhichPhysio == 0)           % => ECG
      n = 60;

      % Center Recorded Triggers at Maximum Of R-Waves 
      for i = 1:N
         js = I(i)-n;    
         je = I(i)+n;
         
         if (js < 1),    js = 1;     end;
         if (je > Nst),  je = Nst;   end;
         
         [M,j] = max( RawPHY(js:je) );
         I(i) = js+j-1;
      end
      
      % Finds The First Trigger
      M = find( ((I-1)*TimeBet2PhysioSamples) <= TimeBeforeFirstVolume );
      FirstTrig = M( length(M) );
      
      % Check If The LastTrig Doesn't Occur After The ExpectedAcquiDuration
      j      = I(N);                         % LastTrig Index In The ECG
      TimeMn = (j-1) * TimeBet2PhysioSamples;% ECG Time At LastTrig
      
      if (TimeMn >= ExpectedAcquisDuration), % NORMAL CASE: LastTrig Occurs 
                                             % After The ExpectedAcquisDura
         % Find The Trigger Just After The Total ExpectedAcquisDuration
         M = find(((I-1)*TimeBet2PhysioSamples) >= ExpectedAcquisDuration);
         LastTrig = M(1);
      else,                                  % ABNORM CASE: LastTrig Occurs
                                             % Before The ExpectedAcquisDur
         % Display A Warning Message                                   
         warning('\n\nTHIS CASE SHOULD NORMALLY NOT HAPPEN!!! In the future, please Try to acquire the ECG signal much longer after the TS Image Acquisition.\n\n'); 
         
         % Compute The Mean ECG Samples Between
         %  Every 2 Consecutive Triggers
         dTrig = I(2:N) - I(1:(N-1));
         MeandTrig   = mean( dTrig );
         TimeEndTrig = TimeMn;
         Ns          = length( RawPHY );
         
         % Artificialy Adds Missing Triggers
         while (TimeEndTrig < ExpectedAcquisDuration)
            j = I(N) + MeandTrig;           % Computes A New Trigger
            I = [I, j];                     % Adds The New Trigger Into I
            N = N+1;                        % Increments The Nber Of I
            TimeEndTrig = (j-1) * TimeBet2PhysioSamples; % Time At Trig j
         end
         
         LastTrig = N;
      end
      
      % Storage
      TRIG        =  I;
      LocMIN      = [];
      FirstLocMIN = [];
      LastLocMIN  = [];
     
   %=======================================
   else                           % => RESP
       
      % Threshold Number Of RESP Samples Between 2 Triggers
      dTrig = I(2:N) - I(1:(N-1));
      MeandTrig  = mean( dTrig );
      ThreshTrig = MeandTrig + (max(dTrig) - MeandTrig)/2;
      
      % Initialization
      LocMAX = [];
      LocMIN = [];
      
      % Compute Local Maxima & Minima From Acquired Triggers
      for i = 2:N
         ic = i-1;
         
         if (dTrig(ic) <= ThreshTrig),         % NORMAL CASE
            % Find The Current Local Maximum
            js = I(ic);
            je = I(i)-1;
            [M,j] = max( RawPHY(js:je) );
            j = js+j-1;
            LocMAX = [LocMAX, j];
            
            % Find The Current Local Minimum
            [M,j] = min( RawPHY(js:j) );
            LocMIN = [LocMIN, js+j-1];
         else                                  % ABNORMAL CASE
            js = I(ic);
            je = I(i)-1;
            jm = js + floor( (je-js)/2 );
            TdSM = ceil((jm-js)/4);
                        
            [M,j] = max( RawPHY(js:jm) );
            j = js+j-1;
            dXM = jm-j;
            
            if ( (j == js) | (j == jm) | (dXM <= TdSM) )  % No Missing Trig
               % Find The Current Local Maximum
               [M,j] = max( RawPHY(js:je) );
               j = js+j-1;
               LocMAX = [LocMAX, j];
               
               % Find The Current Local Minimum
               [M,j] = min( RawPHY(js:j) );
               LocMIN = [LocMIN, js+j-1];
            else                                          % Missing Trigger
               % Find The Current Local Maximum
               [M,j] = max( RawPHY(js:(jm-1)) );
               j = js+j-1;
               LocMAX = [LocMAX, j];
               
               % Find The Current Local Minimum
               [M,j] = min( RawPHY(js:j) );
               LocMIN = [LocMIN, js+j-1];
                
               % Find The Current Local Maximum
               [M,j] = max( RawPHY(jm:je) );
               j = jm+j-1;
               LocMAX = [LocMAX, j];
               
               % Find The Current Local Minimum
               [M,j] = min( RawPHY(jm:j) );
               LocMIN = [LocMIN, jm+j-1];
            end
         end
      end
      
      % Check If The First LocMIN Doesn't Occur Before The TimeBeforeFirstVolume
      j = LocMIN(1);
      TimeMn = (j-1) * TimeBet2PhysioSamples;
      
      if (TimeMn > TimeBeforeFirstVolume),  % ABNORMAL CASE: FirstLocMIN Occurs 
                                            % After The Delay TimeBeforeFirstVolume
         % Display A Warning Message                                   
         warning('\n\nTHIS CASE SHOULD NORMALLY NOT HAPPEN!!! In the future, please Try to acquire the RESP signal much longer (at least 1 RESP period) before the TS Image Acquisition.\n\n'); 
         
         [M,jm] = max( RawPHY(1:j) );
         LocMAX = [jm, LocMAX];
         FirstLocMAX = 1;
         
         [M,jm] = min( RawPHY(1:jm) );
         LocMIN = [jm, LocMIN];
         FirstLocMIN = 1;    
      else,                            % NORMAL CASE: FirstLocMIN Occurs 
                                       % Before The TimeBeforeFirstVolume
         TimeAtMxn = (LocMIN-1)*TimeBet2PhysioSamples;
         M = find(TimeAtMxn <= TimeBeforeFirstVolume );
         N = length(M);
         FirstLocMIN = M(N);
         TimeAtMxn = TimeAtMxn( FirstLocMIN );
         
         % Find FirstLocMAX
         M = find( ((LocMAX-1)*TimeBet2PhysioSamples) > TimeAtMxn );
         FirstLocMAX = M(1);      
      end
      
      % Check If The Last LocMIN Doesn't Occur After The ExpectedAcquisDura
      NbLmn  = length( LocMIN );
      j      = LocMIN( NbLmn );
      TimeMn = (j-1) * TimeBet2PhysioSamples;
      
      if (TimeMn < ExpectedAcquisDuration) % ABNORM CASE: LastLocMIN Occurs 
                                           % Before The ExpectedAcquisDurat
         % Display A Warning Message                                   
         warning('\n\nTHIS CASE SHOULD NORMALLY NOT HAPPEN!!! In the future, please Try to acquire the RESP signal much longer (at least 1 RESP period) After the TS Image Acquisition.\n\n'); 
         
         k = 0;
         N = length( RawPHY );
         ThreshTrig = floor( MeandTrig + (max(dTrig) - MeandTrig)/4 );
         
         while (k == 0),
            js = LocMAX(end);    je = js+ThreshTrig;
            
            if (je < N),
               
               [M,jm] = min( RawPHY(js:je) );
               jm     = js+jm-1;
               LocMIN = [LocMIN, jm];
               NbLmn  = NbLmn+1;               
               M      = (jm-1) * TimeBet2PhysioSamples;  
               
               if (M >= ExpectedAcquisDuration),
                  break;
               else
                  js = jm;     je =  floor( js+MeandTrig );
                  
                  if (je < N),
                     [M,jm] = max( RawPHY(js:je) );
                     jm     = js+jm-1;
                     LocMAX = [LocMAX, jm];
                  else   
                     [M,jm] = max( RawPHY(js:N) );
                     jm     = js+jm-1;
                     LocMAX = [LocMAX, jm];
                     
                     if (jm < N),
                        js     = jm;
                        [M,jm] = min( RawPHY(js:N) );
                        jm     = js+jm-1;
                        LocMIN = [LocMIN, jm];
                        NbLmn  = NbLmn+1;
                        break;
                     end
                  end
               end
               
            else  
               
               [M,jm] = min( RawPHY(js:N) );
               jm     = js+jm-1;
               LocMIN = [LocMIN, jm];
               NbLmn = NbLmn+1;  
               break;
               
            end
         end
         
         LastLocMIN = NbLmn;
                  
         % Find LastLocMAX
         LastLocMAX = length( LocMAX );          
      else,                               % NORMAL CASE: LastLocMIN Occurs 
                                          % After ExpectedAcquisDuration
         TimeAtMxn = (LocMIN-1)*TimeBet2PhysioSamples;
         M = find( TimeAtMxn >= ExpectedAcquisDuration );
         LastLocMIN = M(1);
         TimeAtMxn = TimeAtMxn( LastLocMIN );
         
         % Find LastLocMAX
         M = find( ((LocMAX-1)*TimeBet2PhysioSamples) < TimeAtMxn );
         N = length(M);
         LastLocMAX = M(N);
      end   
      
      FirstTrig = FirstLocMAX;
      LastTrig  = LastLocMAX;
      TRIG      = LocMAX;
   end
   %=======================================
   
elseif (TRIGPRM(1) > 0),    % ===> Compute TRIG Without Using Acquired Ones
   
   %=======================================
   % Retrieve The Thresh. On Max-Mean Amplitude
   Txm = TRIGPRM(2);      

   % Set The Median Filter Kernel
   if (WhichPhysio == 0),    % => ECG
      MEDFILTKERN = 9;   
   else,   
      MEDFILTKERN = 15;      % => RESP
   end
   
   % Compute SIGNAL Triggers  (Could Contains OUTLIERS) ==> ECG
   % Compute SIGNAL Local Maxima (Some Coud Be Missing) ==> RESP
   RawPY = RawPHY;                         % Duplicate The Signal
   RawPY = medfilt1(RawPY, MEDFILTKERN);   % Filter The Signal by A Median
   MnS   = mean(RawPY);                    % Compute The Mean Signal
   MxS   = max(RawPY);                     % Compute The Max Signal
   dxm   = MxS - MnS;                      % Compute The Max-Mean Amplitude
   VTxm  = MnS + (dxm/100)*Txm;            % Intensity At Thresh. Max-Mean
      
   A  = find(RawPY >= VTxm);
   nA = length(A);
   dA = A(2:nA) - A(1:(nA-1));
   i  = find(dA > 1);
   if (i(end) < nA),    i = [i, nA];     end;
   ni = length(i);
   
   I = []; 
   is  = A(1);
   for j = 1:ni,
      ie  = A( i(j) );
      [M,mi] = max( RawPY(is:ie) );
      I = [I,  is+mi-1];
      if (j < ni),    is  = A(i(j) + 1);   end
   end  
   
   %=======================================   
   if (WhichPhysio == 0)      % => ECG
      % Remove Triggers Outliers
      nA  = length(I);
      OutlierThresh = round( TRIGPRM(3)/TimeBet2PhysioSamples );      
      A   = I(2:nA) - I(1:(nA-1));           % Left  dTRIG   [2.....n]
      dA  = abs( I(1:(nA-1)) - I(2:nA) );    % Rigth dTRIG   [1.....n-1]
      ndA = nA-1;
      
      for j = 1:ndA,                         % for j = 1:(ndA-1),
         if (A(j) <= OutlierThresh),         % if ( (A(j) > OutlierThresh) & (dA(j+1) > OutlierThresh) ),    
            I(j+1) = 0;   
         end
      end    
      
      i = find(I == 0);   I(i) = [];         % Delete Outliers
      N = length(I);
      dA = [];          % RawPY = [];        % Clear A, dA & RawPY
      
      % Adjust Trigger Places
      A = length(RawPHY);
      for i=1:N,
         is  = I(i)-5;    if (is <= 0),    is = 1;   end
         ie  = I(i)+5;    if (ie >  A),    ie = A;   end
         [M,mi] = max( RawPHY(is:ie) );
         I(i) = is+mi-1;
      end
      
      % Finds The First Trigger
      M = find( ((I-1)*TimeBet2PhysioSamples) <= TimeBeforeFirstVolume );
      FirstTrig = M( length(M) );
      
      % Check If The Last Trigger Doesn't Occur After The ExpectedAcquisDuration
      j      = I(N);
      TimeMn = (j-1) * TimeBet2PhysioSamples;
      
      if (TimeMn >= ExpectedAcquisDuration), % LastLocMIN Occurs After The ExpectedAcquisDuration
                                             % NORMAL CASE
         % Find The Trigger Just After The Total ExpectedAcquisDuration
         M = find( ((I-1)*TimeBet2PhysioSamples) >= ExpectedAcquisDuration );
         LastTrig = M(1);
      else,                                  % LastLocMIN Occurs Before The ExpectedAcquisDuration
                                             % THIS CASE SHOULD NORMALLY NOT HAPPEN!!
         dTrig = I(2:N) - I(1:(N-1));
         MeandTrig   = mean( dTrig );
         TimeEndTrig = TimeMn;
         Ns          = length( RawPHY );
         
         % Artificialy Adds The Mean Trigger Number Of Samples
         while (TimeEndTrig < ExpectedAcquisDuration),
            j = I(N) + MeandTrig;           % Computes A New Trigger
            I = [I, j];                     % Adds The New Trigger Into I
            N = N+1;                        % Increments The Nber Of I
            TimeEndTrig = (j-1) * TimeBet2PhysioSamples; % Time At Trigger j
         end
         
         LastTrig = N;
      end
            
      % Storage
      TRIG        =  I;
      LocMIN      = [];
      FirstLocMIN = [];
      LastLocMIN  = [];
   
   %=======================================
   else,                      % => RESP      
      % Compute Local Minima From Local Maxima
      N = length(I);
      LocMIN = [];
     
      for i = 2:N,
         is = I(i-1);
         ie = I(i);
         [M,j]  = min( RawPY(is:ie) );
         LocMIN = [LocMIN, is+j-1];
      end
            
      % Check If The First LocMIN Doesn't Occur Before The TimeBeforeFirstVolume
      j = LocMIN(1);
      TimeMn = (j-1) * TimeBet2PhysioSamples;
      
      if (TimeMn > TimeBeforeFirstVolume),    % FirstLocMIN Occurs After The TimeBeforeFirstVolume (Should Be Rare)
         FirstLocMAX = 1;
         
         [M,jm] = min( RawPY(1:I(1)) );
         LocMIN = [jm, LocMIN];
         FirstLocMIN = 1;    
      else,                                   % FirstLocMIN Occurs Before The TimeBeforeFirstVolume (Expected)
         TimeAtMxn = (LocMIN-1)*TimeBet2PhysioSamples;
         M = find(TimeAtMxn <= TimeBeforeFirstVolume);
         N = length(M);
         FirstLocMIN = M(N);
         TimeAtMxn = TimeAtMxn( FirstLocMIN );
         
         % Find FirstLocMAX
         M = find( ((I-1)*TimeBet2PhysioSamples) > TimeAtMxn );
         FirstLocMAX = M(1);      
      end

      % Check If The Last LocMIN Doesn't Occur After The ExpectedAcquisDuration
      NbLmn  = length( LocMIN );
      j      = LocMIN( NbLmn );
      TimeMn = (j-1) * TimeBet2PhysioSamples;
      
      if (TimeMn < ExpectedAcquisDuration), % LastLocMIN Occurs Before The ExpectedAcquisDuration (Should Be Rare)
         N      = length( RawPY );
         j      = I( length(I) );
         [M,jm] = min( RawPY(j:N) );
         jm     = j+jm-1;
         LocMIN = [LocMIN, jm];
         LastLocMIN = NbLmn+1;
         
         % Find LastLocMAX
         LastLocMAX = length( I );          
      else,                                % LastLocMIN Occurs After The ExpectedAcquisDuration (Expected)
         TimeAtMxn = (LocMIN-1)*TimeBet2PhysioSamples;
         M = find( TimeAtMxn >= ExpectedAcquisDuration );
         LastLocMIN = M(1);
         TimeAtMxn = TimeAtMxn( LastLocMIN );
         
         % Find LastLocMAX
         M = find( ((I-1)*TimeBet2PhysioSamples) < TimeAtMxn );
         N = length(M);
         LastLocMAX = M(N);
      end

      % Adjust Trigger Places
      N = length(I);
      M = length(RawPHY);
      
      for i=1:N,
         is  = I(i)-7;    if (is <= 0),    is = 1;   end
         ie  = I(i)+7;    if (ie >  M),    ie = M;   end
         [jm,mi] = max( RawPHY(is:ie) );
         I(i) = is+mi-1;
      end
            
      % Storage
      FirstTrig = FirstLocMAX;
      LastTrig  = LastLocMAX;
      TRIG      = I;
   end
   %=======================================
   
   
else,   % TRIGPRM(1) < 0 ===> Use Recorded TRIG (only for ECG)

   %=======================================
   if (WhichPhysio == 0),           % => ECG      
      % Finds The First Trigger
      M = find( ((I-1)*TimeBet2PhysioSamples) <= TimeBeforeFirstVolume );
      FirstTrig = M( length(M) );
      
      % Check If The LastTrig Doesn't Occur After The ExpectedAcquiDuration
      j      = I(N);                         % LastTrig Index In The ECG
      TimeMn = (j-1) * TimeBet2PhysioSamples;% ECG Time At LastTrig
      
      if (TimeMn >= ExpectedAcquisDuration), % NORMAL CASE: LastTrig Occurs 
                                             % After The ExpectedAcquisDura
         % Find The Trigger Just After The Total ExpectedAcquisDuration
         M = find(((I-1)*TimeBet2PhysioSamples) >= ExpectedAcquisDuration);
         LastTrig = M(1);
      else,                                  % ABNORM CASE: LastTrig Occurs
                                             % Before The ExpectedAcquisDur
         % Display A Warning Message                                   
         warning('\n\nTHIS CASE SHOULD NORMALLY NOT HAPPEN!!! In the future, please Try to acquire the ECG signal much longer after the TS Image Acquisition.\n\n'); 
         
         % Compute The Mean ECG Samples Between
         %  Every 2 Consecutive Triggers
         dTrig = I(2:N) - I(1:(N-1));
         MeandTrig   = mean( dTrig );
         TimeEndTrig = TimeMn;
         Ns          = length( RawPHY );
         
         % Artificialy Adds Missing Triggers
         while (TimeEndTrig < ExpectedAcquisDuration),
            j = I(N) + MeandTrig;           % Computes A New Trigger
            I = [I, j];                     % Adds The New Trigger Into I
            N = N+1;                        % Increments The Nber Of I
            TimeEndTrig = (j-1) * TimeBet2PhysioSamples; % Time At Trig j
         end
         
         LastTrig = N;
      end
      
      % Storage
      TRIG        =  I;
      LocMIN      = [];
      FirstLocMIN = [];
      LastLocMIN  = [];
     
   %=======================================
   else,
      % Display An Error Message                                   
      error('\n\nTRIGPRM(1)<0 should be used only of the ECG signal => WhichPhysio==0!!!\n\n'); 
   end
   
   
end



%---- RETRIEVES SIGNAL INDEXES BETWEEN: TimePtSpan(1) & TimePtSpan(2) -----
% Compute The Time Scale At all Signal Samples
N = length(RawPHY);
RawPY = [0:(N-1)] * TimeBet2PhysioSamples;

% Find The First Signal Point Index Involves In The Time Series Acquisition
i = find(RawPY <= TimeBeforeFirstVolume);    Ni = length(i);
FirstSignalIndexInTS = i(Ni) + 1;

% Find The Last Signal Point Index Involves In The Time Series Acquisition
i = find(RawPY > ExpectedAcquisDuration);
if (length(i) ~= 0),
   LastSignalIndexInTS  = i(1) - 1;
else,
   LastSignalIndexInTS  = N;
end

% Clear RawPY
RawPY = [];


%---- RETRIEVES TRIGGER INDEXES BETWEEN: TimePtSpan(1) & TimePtSpan(2) ----
% Find The Index Of The First Trigger Found Between TimePtSpan(1) & TimePtSpan(2)
i = find(TRIG >= FirstSignalIndexInTS);
FirstTriggerIndexInTS = i(1);

% Find The Index Of The Last  Trigger Found Between TimePtSpan(1) & TimePtSpan(2)
i = find(TRIG <= LastSignalIndexInTS);       Ni = length(i);
LastTriggerIndexInTS = i(Ni);



%---- RETRIEVES LocMin INDEXES BETWEEN: TimePtSpan(1) & TimePtSpan(2) -----
FirstLocMinIndexInTS = [];
LastLocMinIndexInTS  = [];

if (length(LocMIN) ~= 0),
   % Find The Index Of The First Trigger Found Between TimePtSpan(1) & TimePtSpan(2)
   i = find(LocMIN >= FirstSignalIndexInTS);
   FirstLocMinIndexInTS = i(1);
   
   % Find The Index Of The Last  Trigger Found Between TimePtSpan(1) & TimePtSpan(2)
   i = find(LocMIN <= LastSignalIndexInTS);       Ni = length(i);
   LastLocMinIndexInTS = i(Ni);
end



%-------------------------------- STORAGES --------------------------------
% Store The Signal
PHYSIO.signal = RawPHY;

% Remove Zero Paddings at The End of The Trigger Array & Store
PHYSIO.Trig      = floor( TRIG );
PHYSIO.FirstTrig = FirstTrig;
PHYSIO.LastTrig  = LastTrig;
PHYSIO.FirstTriggerIndexInTS = FirstTriggerIndexInTS;
PHYSIO.LastTriggerIndexInTS  = LastTriggerIndexInTS;

% Store The Local Minimun (Empty For ECG signal)
PHYSIO.LocMIN      = LocMIN;
PHYSIO.FirstLocMIN = FirstLocMIN;
PHYSIO.LastLocMIN  = LastLocMIN;
PHYSIO.FirstLocMinIndexInTS = FirstLocMinIndexInTS;
PHYSIO.LastLocMinIndexInTS  = LastLocMinIndexInTS;

% Store Delay
PHYSIO.StartDelay            = StartDelay;
PHYSIO.DelayBeforeScan       = DelayBeforeScan;
PHYSIO.TimeBeforeFirstVolume = TimeBeforeFirstVolume;

% Store Start & End Of Signal Indexes In Time Series 
PHYSIO.FirstSignalIndexInTS = FirstSignalIndexInTS;
PHYSIO.LastSignalIndexInTS  = LastSignalIndexInTS;

% Set The Time between 2 PHYSIO Samples (in Seconds)
PHYSIO.TimeBet2PhysioSamples = TimeBet2PhysioSamples;        % (in Seconds)






















