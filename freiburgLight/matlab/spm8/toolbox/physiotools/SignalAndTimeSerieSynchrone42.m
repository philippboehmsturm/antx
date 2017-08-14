function PHYSIO = SignalAndTimeSerieSynchrone42(PhysioFilename, DummyTime, TR, Ns, TimePtSpan, WhichPhysio, TimeBet2PhysioSamples, TRIGPRM, CARDchannel, SIGNALyFLIP)
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
I = RawPHY == 6000;   RawPHY(I) = [];
I = RawPHY == 5000;   RawPHY(I) = [];
Nst = length(RawPHY);

% Deal With The Fact That 2 ECG Signals Are Recorded On TIM
if ((WhichPhysio == 0) && (TimFlag == 1))
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
       
end






% =========================================================================
%                       
%         NEW
%
% =========================================================================
% Initialization
TRIG   = [];    Ntrg  = 0; 
LocMIN = [];    NLcMn = 0;
FirstTrig   = 0;
LastTrig    = 0;
FirstLocMIN = 0;
LastLocMIN  = 0;
t = (0:(Nst-1)) * TimeBet2PhysioSamples;% Times At All Physio Signal Sample
i = find(t > TimeBeforeFirstVolume);      FirstSIGindexInTS = i(1);
i = find(t<= ExpectedAcquisDuration);     LastSIGindexInTS  = i(end);


%---------- Compute Triggers (and Local Minima case RESP Signal)-----------
if (WhichPhysio == 0),      % => ECG
    
   %- Compute Interval Of Times (Star & End) At Physio Signal Band Freq. --
   %------------
   Tend = 1.30; 
   Tsta = 0.70; 
   %------------  
      
   % Physio Signal Maximum Value => First Trigger
   [PHYval,iRawPHYmax] = max( RawPHY );
   TRIG = [TRIG, iRawPHYmax];
   Ntrg = Ntrg+1;
      
   %------------ FORWARDS Triggers 
   % Time At The Current Trigger Initialization
   TimeCurrentTrig = t( iRawPHYmax );
   
   % Time Interval Around The Next Trigger Initialization
   NxTsta = TimeCurrentTrig + Tsta;
   NxTend = TimeCurrentTrig + Tend; 
   
   % Compute All Triggers (and Local Minima) 
   while ( (NxTsta < t(Nst)) && (NxTend <= t(Nst)) ),
      % Interval on Indexes Around The Next Trigger (Start & End)
      i = find(t <  NxTsta);     iNxTsta = i(end);  
      i = find(t >= NxTend);     iNxTend = i(1);
      
      % Next Trigger Index (Index)
      [PHYval, iNxTrig] = max( RawPHY(iNxTsta:iNxTend) );
      iNxTrig = iNxTsta + iNxTrig - 1;
      
      % Update The Trigger Array
      TRIG = [TRIG, iNxTrig];  
      Ntrg = Ntrg+1;
      
      % Time At The Current Trigger
      TimeCurrentTrig = t( iNxTrig );
      
      % Time Interval Around The Next Trigger (Start & End)
      NxTsta = TimeCurrentTrig + Tsta;
      NxTend = TimeCurrentTrig + Tend; 
   end
   
   
   %----- BACKWARDS Triggers
   % Time At The Current Trigger Initialization
   TimeCurrentTrig = t( iRawPHYmax );
   
   % Time Interval Around The Previous Trigger Initialization
   NxTsta = TimeCurrentTrig - Tend;
   NxTend = TimeCurrentTrig - Tsta; 
   
   % Compute All Triggers (and Local Minima) 
   while ( (NxTsta >= 0) && (NxTend > 0) ),
      % Interval on Indexes Around The Previous Trigger (Start & End)
      i = find(t >= NxTsta);     iNxTsta = i(1);  
      i = find(t <=  NxTend);    iNxTend = i(end);
      
      % Compute The Previous Trigger Index
      [PHYval, iNxTrig] = max( RawPHY(iNxTsta:iNxTend) );
      iNxTrig = iNxTsta + iNxTrig - 1;
      
      % Update The Previous Trigger Array
      TRIG = [iNxTrig, TRIG];  
      Ntrg = Ntrg+1;
      
      % Time At The Current Trigger
      TimeCurrentTrig = t( iNxTrig );
      
      % Time Interval Around The Previous Trigger (Start & End)
      NxTsta = TimeCurrentTrig - Tend;
      NxTend = TimeCurrentTrig - Tsta; 
   end
   
   %------------------------ 1st And Last Triggers ------------------------
   % Compute The 1st Trigger
   i = find(TRIG <= FirstSIGindexInTS);      
   if (isempty(i)),
      TRIG = [1, TRIG];
      Ntrg = Ntrg+1;
      FirstTrig = 1;
   else   
      FirstTrig = i(end);
   end

   % Compute The Last Trigger
   i = find(TRIG >= LastSIGindexInTS);      
   if (isempty(i)),
      TRIG = [TRIG, Nst];
      Ntrg = Ntrg+1;
      LastTrig = Ntrg;
   else   
      LastTrig = i(1);
   end
   

%=======================================
else                           % => RESP
    
   %------------------- Compute Triggers & Local Minima ------------------- 
   % Retrieve The Thresh. On Max-Mean Amplitude
   Txm = 0;      

   % Set The Median Filter Kernel
    MEDFILTKERN = 15;      % => RESP
   
   % Compute SIGNAL Local Maxima (Some Could Be Missing)
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
   
   % Initialization
   Cyc = zeros(1,Nst);
   CurrentCycle = 0;
   
   
   % Compute And Set Current Trigger And Local Minimum
   is  = A(1);
   
   for j = 1:ni,
      % Update The Current End Index
      ie  = A( i(j) );

      % Compute the Current Trigger Index
      [M,mi] = max( RawPHY(is:ie) );
      mi     = is+mi-1;
      TRIG   = [TRIG, mi];
      Ntrg   = Ntrg+1;
      
      % Set a Trigger and/or a Local Minimum At The Start Of RESP Signal
      if (j == 1),  % IF 1st TRIG
         
         if (TRIG(1) > 1),         % IF 1st TRIG > 1st RESP Sample
            %Compute the 1st Local Minimum
            [M,mi] = min( RawPY(1:TRIG(1)) ); 
            LocMIN = [mi, LocMIN]; %   Set the 1st Local Minimum
            NLcMn  = NLcMn+1;      %   Iterate The Local Minimum Counter
            
            % IF the 1st LocMin is not the RESP Signal Start,
            % Compute the 1st Trigger (Number Of TRIG = 2)
            if (mi > 1),           %   IF 1st LocMin > 1st RESP Sample
               TRIG = [1, TRIG];   %      1st TRIG index == 1
               Ntrg = Ntrg+1;      %      Iterate The TRIG Counter
            end
                        
            % Cycle Storage And 1st LocMin & Trigger setting
            if (FirstSIGindexInTS < TRIG(Ntrg)),
               if (FirstSIGindexInTS >= LocMIN(1)), % 1 LocMin & 1or2 TRIG
                  Cyc(LocMIN(1):(TRIG(Ntrg)-1)) = 1; 
                  FirstTrig    = Ntrg;
                  FirstLocMIN  = 1;
                  CurrentCycle = 1;
               else                                 % 1 LocMin & 2 TRIGs
                  Cyc(TRIG(1):(LocMIN(1)-1)) = -1;
                  Cyc(LocMIN(1):(TRIG(2)-1)) =  2;
                  FirstTrig    = 1;
                  FirstLocMIN  = 1;
                  CurrentCycle = 2;
                  LocMIN = [TRIG(1), LocMIN];       % Artificially Add The 
                  NLcMn  = NLcMn+1;                 % 1st LocMin
               end
            end
         end


         
      else         % IF NOT: Compute the Current Local Minimum
         % Compute And Store the Current Local Minimum
         [M,mi] = min( RawPHY(TRIG(Ntrg-1):TRIG(Ntrg)) );
         mi     = TRIG(Ntrg-1) + mi-1;
         LocMIN = [LocMIN, mi];
         NLcMn  = NLcMn+1;
         
         % Cycle Storage (And 1st LocMin & Trigger setting, IF Still Not)
         if (CurrentCycle > 0),   % 1st LocMin & Trigger Already Exist
             
            if( LastSIGindexInTS >= TRIG(Ntrg) ), %  Still Not The Last TS
               Cyc(TRIG(Ntrg-1):(LocMIN(NLcMn)-1)) = -CurrentCycle;
               CurrentCycle  = CurrentCycle+1;
               Cyc(LocMIN(NLcMn):(TRIG(Ntrg)-1))   =  CurrentCycle;
            else %(LastRESPindexInTS < TRIG(Ntrg)) % Last TS Index Reached
               if(LastTrig == 0),
                  if (LastSIGindexInTS >= LocMIN(NLcMn)),
                     Cyc(TRIG(Ntrg-1):(LocMIN(NLcMn)-1)) = -CurrentCycle;
                     CurrentCycle  = CurrentCycle+1;
                     Cyc(LocMIN(NLcMn):(TRIG(Ntrg)-1))   =  CurrentCycle;
                     LastTrig    = Ntrg;

                     if (TRIG(Ntrg) == Nst)
                        LastLocMIN  = Nst;
                     else
                        LastLocMIN  = NLcMn+1;
                     end
                  else 
                     Cyc(TRIG(Ntrg-1):(LocMIN(NLcMn)-1)) = -CurrentCycle;
                     LastTrig    = Ntrg-1;
                     LastLocMIN  = NLcMn;
                  end
               end
            end
         else                    % NO 1st LocMin&Trigger => Still No Cycle
            % Cycle Storage And 1st LocMin & Trigger setting
            if (FirstSIGindexInTS < TRIG(Ntrg)),
               if (FirstSIGindexInTS >= LocMIN(NLcMn)),
                  Cyc(LocMIN(NLcMn):(TRIG(Ntrg)-1)) = 1; 
                  FirstTrig    = Ntrg;
                  FirstLocMIN  = NLcMn;
                  CurrentCycle = 1;
               else                            
                  Cyc(TRIG(Ntrg-1):(LocMIN(NLcMn)-1)) = -1;
                  Cyc(LocMIN(NLcMn):(TRIG(Ntrg)-1))   =  2;
                  FirstTrig    = Ntrg-1;
                  FirstLocMIN  = NLcMn-1;
                  CurrentCycle = 2;
               end
            end
         end
      end
      

      % Update The Next Starting Index Or 
      % Set a Trigger and/or a Local Minimum At Ends Of The RESP Signal
      if (j < ni),              % IF Before The Last Trigger  
         is  = A(i(j) + 1);     %    Update The Next Starting Index
         
      else   % if (j == ni),   % IF The Last Trigger
         % Set a Trigger and/or a Local Minimum At The End Of RESP Signal
         if (TRIG(Ntrg) < Nst), %    IF Last TRIG < Last RESP Sample
            [M,mi] = min( RawPY(TRIG(Ntrg):Nst) );
            mi = TRIG(Ntrg) + mi-1; %   Compute the Last Local Minimum 
            LocMIN = [LocMIN, mi];  %   Set the Last Local Minimum
            NLcMn  = NLcMn+1;       %   Iterate The Local Minimum Counter
            
            if (mi < Nst),          %   IF Last LocMin < Last RESP Sample
               TRIG = [TRIG, Nst];  %      Last TRIG == Nst
               Ntrg = Ntrg+1;       %      Iterate The TRIG Counter
            end
            
            % Update The Cyclic Array And Set Last Trigger & LocMin
            if(LastTrig == 0),
               if (LastSIGindexInTS >= LocMIN(NLcMn)),
                  Cyc(TRIG(Ntrg-1):(LocMIN(NLcMn)-1)) = -CurrentCycle;
                  CurrentCycle  = CurrentCycle+1;
                  Cyc(LocMIN(NLcMn):TRIG(Ntrg))       =  CurrentCycle;

                  LocMIN = [LocMIN, Nst];  %   Set the Last Local Minimum
                  NLcMn  = NLcMn+1;
                  LastLocMIN = NLcMn;
                  LastTrig   = Ntrg;

               else 
                  if (LocMIN(NLcMn) > TRIG(Ntrg)),
                     Cyc(TRIG(Ntrg):(LocMIN(NLcMn)-1)) = -CurrentCycle;
                     CurrentCycle  = CurrentCycle+1;
                     Cyc( LocMIN(NLcMn) )              =  CurrentCycle;
                     LastTrig   = Ntrg;
                     LastLocMIN = NLcMn;
                  else
                     Cyc(TRIG(Ntrg-1):(LocMIN(NLcMn)-1)) = -CurrentCycle;
                     CurrentCycle  = CurrentCycle+1;
                     Cyc( LocMIN(NLcMn) )                =  CurrentCycle;
                     LastTrig   = Ntrg-1;
                     LastLocMIN = NLcMn;                        
                  end
               end
            end
                      
            
         end
      end % END: if (j < ni)
      
      
   end % END: for j = 1:ni
   
%=======================================

end
   

   
   
   
   

% 
% 
% 
% if (WhichPhysio == 0),      % => ECG
%    figure;    plot(t, RawPHY, '-b');                                       xlabel('Time (sec)', 'Color', 'b');       ylabel('Intensity', 'Color', 'b');      title('ECG Signal As Aquired',  'Color', 'b');    grid on
%    hold on;
%               plot(t( TRIG ), RawPHY( TRIG ), 'or');     legend('Signal', 'Triggers');
%               
%               plot(t( TRIG(FirstTrig) ), RawPHY( TRIG(FirstTrig) ), '*k', t( TRIG(LastTrig) ), RawPHY( TRIG(LastTrig) ), '*k'); 
%               
%    hold off;
% else,  
%    
%    figure;     plot(t, RawPHY, '-b');                                                          xlabel('Time (sec)', 'Color', 'b');       ylabel('Intensity', 'Color', 'b');      title('ECG Signal As Aquired',  'Color', 'b');    grid on
%    hold on;
%               plot(t( TRIG ), RawPHY( TRIG ), 'or', t( LocMIN ), RawPHY( LocMIN ), 'og');     legend('Signal', 'Triggers', 'Local Min');
%               
%               plot(t( TRIG(FirstTrig) ), RawPHY( TRIG(FirstTrig) ), '*c', t( TRIG(LastTrig) ), RawPHY( TRIG(LastTrig) ), '*c'); 
%               plot(t( LocMIN(FirstLocMIN) ), RawPHY( LocMIN(FirstLocMIN) ), '*k',  t( LocMIN(LastLocMIN) ), RawPHY( LocMIN(LastLocMIN) ), '*k'); 
%               
%    hold off;
%     
% %    figure;     plot(t, RawPY, '-b');                                                          xlabel('Time (sec)', 'Color', 'b');       ylabel('Intensity', 'Color', 'b');      title('ECG Signal As Aquired',  'Color', 'b');    grid on
% %    hold on;
% %               plot(t( TRIG ), RawPY( TRIG ), 'or', t( LocMIN ), RawPY( LocMIN ), 'og');     legend('Signal', 'Triggers', 'Local Min');
% %    hold off;
%    
%    
%end



% =========================================================================


%---- RETRIEVES TRIGGER INDEXES BETWEEN: TimePtSpan(1) & TimePtSpan(2) ----
% Find The Index Of The First Trigger Found Between TimePtSpan(1) & TimePtSpan(2)
i = find(TRIG >= FirstSIGindexInTS);
FirstTriggerIndexInTS = i(1);

% Find The Index Of The Last  Trigger Found Between TimePtSpan(1) & TimePtSpan(2)
i = find(TRIG <= LastSIGindexInTS);       Ni = length(i);
LastTriggerIndexInTS = i(Ni);



%---- RETRIEVES LocMin INDEXES BETWEEN: TimePtSpan(1) & TimePtSpan(2) -----
FirstLocMinIndexInTS = [];
LastLocMinIndexInTS  = [];

if (~isempty(LocMIN)),
   % Find The Index Of The First Trigger Found Between TimePtSpan(1) & TimePtSpan(2)
   i = find(LocMIN >= FirstSIGindexInTS);
   FirstLocMinIndexInTS = i(1);
   
   % Find The Index Of The Last  Trigger Found Between TimePtSpan(1) & TimePtSpan(2)
   i = find(LocMIN <= LastSIGindexInTS);       Ni = length(i);
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
PHYSIO.FirstSignalIndexInTS = FirstSIGindexInTS;
PHYSIO.LastSignalIndexInTS  = LastSIGindexInTS;

% Set The Time between 2 PHYSIO Samples (in Seconds)
PHYSIO.TimeBet2PhysioSamples = TimeBet2PhysioSamples;        % (in Seconds)






















