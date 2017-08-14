function [IMc, PhasesOfSlices, CyclesOfSlices, SIGNALS] = PhysioRectroCorrectInTimeSeries3(IM, TR, PhysioFilename, WhichPhysio, CYCLIC, TRIGPRM, WhichFitMethod, FITORDER, Store, Visual, BandWidth, DummyTime, TimePtSpan, CARDchannel, SIGNALyFLIP, Interleave)
%==========================================================================
% PHYSIORECTROCORRECTINTIMESERIES3: Removes Cardiac(ECGorCARD), Respiratory 
% (RESP) or PULS Signals From A fMRI Time Series (TS). This Program Uses A
% Scale Of Phases Of Physiological Signal(s) Synchronized With Times Of Ac-
% quisition Of All TS Slices.
%
% 1) Phases And Cycles Of Slices Of CARD/RESP Signal(s) Are First Computed  
%    (They Can Also Be Stored For Further Use, And Plotted), Before Signal 
%    (s) Correction(s).
% 2) Deals Also With Complex IM (ex: MREG)
%
%
% INPUT:
%  * IM             --> TS To Be Corrected. IM Must Be A 4D Matrix Of Size
%                       [Nx,Ny,Ns,Nt]:
%                         * Nx,Ny => Sides  Of Slices
%                         * Ns    => Number Of slices
%                         * Nt    => TS Number Of Volumes (Or Time Points).
%
%  * TR             --> Repetion Time (Time Between 2 TS Time Points)
%
%  * PHYSIOFILENAME --> Path And File Name Of The Physiological Signal(s).
%                       File Extension(s): .ECG, .RESP or .PULS Are Added
%                       Later.
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
%  * [WHICHFITMETHOD]--> Sets The Fitting Method To Be Used:
%                         * WHICHFITMETHOD  = [0] => Low Fourier Series
%                         * WHICHFITMETHOD >=  1  => Polynomial
%                        
%  * [ FITORDER ]   --> Sets Low Fourier Series Or Polynomial Order(Degree)
%                         * FITORDER  = [2] => Low Fourier Series
%                         * FITORDER  =  4  => Polynomial
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
%  * [ TIMEPTSPAN ] --> The Start(START) & End(END) TS Time Points Or Vo-
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
%  * [ CARDCHANNEL ]--> Check Which CARD(ECG) signal To Choose When Several 
%                       Channels are Used During The EGG Acquisition.
%                       Several ECG Channels => Several CARD Signals.
%
%  * [ SIGNALyFLIP ]--> Checks If The Signal MustBe Y-Flipped. It Should Be
%                       A 2 Elements Array When Dealing With 2 Signals:
%                         * SIGNALyFLIP  > 0 => Y-Flipped
%                         * SIGNALyFLIP <= 1 => No Y-Flipped
%
%  * [ INTERLEAVE ] --> Sets The Record Order Of TS Slices 
%                         * INTERLEAVE  =  0  => Normal (1,2,3,4,5...)
%                         * INTERLEAVE >= [1] => Interl (1,3,5..2,4,6..)
%
%
% OUTPUT:
%  * IMc             --> Corrected fMRI Time Series
%
%  * [PHASESOFSLICES]--> Physio Signal Phases At Slice Record Times
%                         * 1 row  => if WHICHPHYSIO < 3
%                         * 2 rows => if WHICHPHYSIO > 2 
%  * [CYCLESOFSLICES]--> Physio Sig Cycles (Periods) At Slice Record Times 
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
if nargin < 5,    error('Not enough arguments!'); end


%============================ INITIALIZATIONS =============================
% Compute Image Sizes
[Nx, Ny, Ns, Nt] = size(IM)


%=================== SET THE OPTIONAL INPUT ARGUMENTS =====================
if nargin < 16,   Interleave  = 1;                        end
if nargin < 15,   SIGNALyFLIP = [0, 0];                   end
if nargin < 14,   CARDchannel = 1;                        end
if nargin < 13,   TimePtSpan  = [1 Nt Nt];                end
if nargin < 12,   DummyTime   = floor(3/TR + 1)*TR;       end

if nargin < 11,
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

if nargin < 10,   Visual  = [1,0];        end
if nargin < 9,    Store   = [0,0];        end
if nargin < 8, 
   if ( (nargin == 7) & (WhichFitMethod > 0) ),  % Case: Polynomial
      FITORDER = 4; 
   else                                          % Case: Low Fourier Series
      FITORDER = 2;
   end
end

if nargin < 7,    WhichFitMethod = 0;     end
if nargin < 6,    TRIGPRM    = [0;0];     end



%=========== CHECK THE VOLUME SPAN & ITS CORRESPONDENCY WITH NT ===========
% Check The Correspondency Between The Volume Span And Nt
if (    ( (TimePtSpan(1) <= 0)  |  (TimePtSpan(1) > Nt) )...   %
     |  ( (TimePtSpan(2) <= 0)  |  (TimePtSpan(2) > Nt) )...   %
   ),
   fprintf('\n\n =========== INCOMPATIBILITY BETWEEN: TimePtSpan & Nr ==========='); 
   fprintf('\n                  0 < TimePtSpan(1) <= Nt !!!!!!                   '); 
   fprintf('\n                  0 < TimePtSpan(2) <= Nt !!!!!!                   ');
   fprintf('\n <<              Press any key to quit the program               >>');
   fprintf('\n ==================================================================\n\n');
   pause;
   error('Check the correspondency between TIMEPTSPAN and NR parameters');
end

% Check The Volume Span
if (TimePtSpan(1) > TimePtSpan(2)),
   fprintf('\n\n ============== ERROR IN THE PARAMETER: TimePtSpan =============='); 
   fprintf('\n                  TimePtSpan(1) <= TimePtSpan(2)                   ');
   fprintf('\n <<              Press any key to quit the program               >>');
   fprintf('\n ==================================================================\n\n');
   pause;
   error('Check The TIMEPTSPAN parameter');
end


%================= COMPUTE PHYSIO SIGNAL PHASES & CYCLES  =================
if (nargout == 4),
   [PhasesOfSlices, CyclesOfSlices, SIGNALS] = PhysioSignal_Plot_PhasesAndCyclesOfSlices2(PhysioFilename, TR, Ns, TimePtSpan, WhichPhysio, CYCLIC, TRIGPRM, Store, Visual, BandWidth, DummyTime, CARDchannel, SIGNALyFLIP);
else
   [PhasesOfSlices, CyclesOfSlices         ] = PhysioSignal_Plot_PhasesAndCyclesOfSlices2(PhysioFilename, TR, Ns, TimePtSpan, WhichPhysio, CYCLIC, TRIGPRM, Store, Visual, BandWidth, DummyTime, CARDchannel, SIGNALyFLIP);
end

fprintf('\n\nPHASES & CYCLES OF SLICES COMPUTED.\n\n');



%=== CHECK NberOfTimePoint/SignalCycle & The Correction Mode in CYCLIC ====
%------------- If Only One Signal -------------
if CYCLIC > 0,
   if (   ( CYCLIC == 2                                              )...   % 1) ECG  is Cyclic   And   2) RESP is Cyclic   (Or the Reverse)
        | ((CYCLIC == 1) &  (WhichPhysio  < 3)                       )...   % 1) ECG  is Cyclic   Or    1) RESP is Cyclic
        | ((CYCLIC == 1) & ((WhichPhysio == 3) | (WhichPhysio == 5)) )...   % 1) RESP is Cyclic   And   2) ECG  is Global
      ),                  
      % Retrieve End Cycles
      Cs = abs( CyclesOfSlices(1,1) )   + 1;
      Ce = abs( CyclesOfSlices(1,end) ) - 1;
            
      % Compare The Nber of SAMPLES In Each CYCLE With The FIT ORDER
      ChCYf = 0;     ChCYp = 0;
      
      for i = Cs:Ce,
         j = find( abs( CyclesOfSlices(1,:) ) == i );
         Lj = length(j);
         
         if    (Lj < 2),
            fprintf('\n\n ============= 1st SIGNAL CORRECTION =============='); 
            fprintf('\n NUMBER OF SIGNAL SAMPLES/CYCLE found < 2!!!!!!'); 
            fprintf('\n THE 1st SIGNAL CORRECTION CAN ONLY BE GLOBAL');
            fprintf('\n <<    Press any key to quit the program     >>');
            fprintf('\n ====================================================\n\n');
            pause;
            error('The 1st SIGNAL CORRECTION cannot be CYCLIC');
         elseif (Lj  < FITORDER), 
             ChCYf = ChCYf + 1;
         elseif (Lj == FITORDER), 
             ChCYp = ChCYp + 1;
         end            
      end                
         
      fprintf('\n\n1st SIGNAL CORRECTION IS CYCLIC.\n\n');
      
      % Check the Correspondence Between The Nber of SAMPLES per CYCLE And
      % The Correction Mode (CYCLIC Or Not)
      if WhichFitMethod <= 0,     % Case: Fourier Fit
         % Existe At Least 1 Cycle where: NBER OF SIG SAMPLES < FITORDER
         if (ChCYf > 0),     
            fprintf('\n\n ==================== 1st SIGNAL ===================='); 
            fprintf('\n NUMBER OF SIGNAL SAMPLES/CYCLE is  <  FITORDER!!!!!!'); 
            fprintf('\n NUMBER OF SIGNAL SAMPLES/CYCLE should be >= FITORDER');
            fprintf('\n THE RESULT OF THE CORRECTION COULD BE UNEXPECTED!!!!');
            fprintf('\n ====================================================\n\n');
            reply = input('<<    Do you want to quit the program? Y/N [Y]:    \n\n>>', 's');
            if (reply == 'Y'),
               error('Check the correspondency between the NUMBER OF SIGNAL SAMPLES/CYCLE and The FITORDER!');            
            end
         end
         
      else,                       % Case: Polynomial Fit
         % Existe At Least 1 Cycle where: NBER OF SIG SAMPLES <= FITORDER
         if ((ChCYf > 0) | (ChCYp > 0)),
            fprintf('\n\n ==================== 1st SIGNAL ===================='); 
            fprintf('\n NUMBER OF SIGNAL SAMPLES/CYCLE is  <= FITORDER!!!!!!'); 
            fprintf('\n NUMBER OF SIGNAL SAMPLES/CYCLE should be  > FITORDER');
            fprintf('\n THE RESULT OF THE CORRECTION COULD BE UNEXPECTED!!!!');
            fprintf('\n ====================================================\n\n');
            reply = input('<<    Do you want to quit the program? Y/N [Y]:    \n\n>>', 's');
            if (reply == 'Y'),
               error('Check the correspondency between the NUMBER OF SIGNAL SAMPLES/CYCLE and The FITORDER!');            
            end
         end
      end
   end
end


%--------------- If Two Signal ----------------
% Both Signals Were Required Cyclic, OR Only the 2nd Signal(RESP) is Required Cyclic
if (   (  CYCLIC == 2                                              ) ...   % 1) ECG  is Cyclic   And   2) RESP is Cyclic   (Or the Reverse)
     | ( (CYCLIC == 1) & ((WhichPhysio == 4) | (WhichPhysio == 6)) ) ...   % 1) ECG  is Global   And   2) RESP is Cyclic
   ),
   % Retrieve Cycles
   if (CYCLIC == 2),
      Cycles = CyclesOfSlices(2,:);
   else,
      Cycles = CyclesOfSlices(1,:);
   end
    
   % Retrieve End Cycles
   Cs = abs( Cycles(1) )   + 1;
   Ce = abs( Cycles(end) ) - 1;
         
   % Compare The Nber of SAMPLES per Each CYCLE With The FIT ORDER
   ChCYf = 0;     ChCYp = 0;
   
   for i = Cs:Ce,
      j = find( abs( Cycles ) == i );
      Lj = length(j);
      
      if    (Lj < 2),
         fprintf('\n\n ============= 2nd SIGNAL CORRECTION =============='); 
         fprintf('\n NUMBER OF SIGNAL SAMPLES/CYCLE found < 2!!!!!!'); 
         fprintf('\n THE 2nd SIGNAL CORRECTION CAN ONLY BE GLOBAL');
         fprintf('\n <<    Press any key to quit the program     >>');
         fprintf('\n ====================================================\n\n');
         pause;
         error('The 2nd SIGNAL CORRECTION cannot be CYCLIC');
      elseif (Lj  < FITORDER), 
          ChCYf = ChCYf + 1;
      elseif (Lj == FITORDER), 
          ChCYp = ChCYp + 1;
      end            
   end                
         
   fprintf('\n\n2nd SIGNAL CORRECTION IS CYCLIC.\n\n');
         
   % Check the Correspondence Between The Nber of SAMPLESperCYCLE And
   % The Correction Mode
   if WhichFitMethod <= 0,     % Case: Fourier Fit
      % Existe At Least 1 Cycle where: NBER OF SIG SAMPLES < FITORDER
      if (ChCYf > 0),     
         fprintf('\n\n ==================== 2nd SIGNAL ===================='); 
         fprintf('\n NUMBER OF SIGNAL SAMPLES/CYCLE is  <  FITORDER!!!!!!'); 
         fprintf('\n NUMBER OF SIGNAL SAMPLES/CYCLE should be >= FITORDER');
         fprintf('\n THE RESULT OF THE CORRECTION COULD BE UNEXPECTED!!!!');
         fprintf('\n ====================================================\n\n');
         reply = input('<<    Do you want to quit the program? Y/N [Y]:    \n\n>>', 's');
         if (reply == 'Y'),
            error('Check the correspondency between the NUMBER OF SIGNAL SAMPLES/CYCLE and The FITORDER!');            
         end
      end
            
   else,                       % Case: Polynomial Fit
            % Existe At Least 1 Cycle where: NBER OF SIG SAMPLES <= FITORDER
      if ((ChCYf > 0) | (ChCYp > 0)),
         fprintf('\n\n ==================== 2nd SIGNAL ===================='); 
         fprintf('\n NUMBER OF SIGNAL SAMPLES/CYCLE is  <= FITORDER!!!!!!'); 
         fprintf('\n NUMBER OF SIGNAL SAMPLES/CYCLE should be  > FITORDER');
         fprintf('\n THE RESULT OF THE CORRECTION COULD BE UNEXPECTED!!!!');
         fprintf('\n ====================================================\n\n');
         reply = input('<<    Do you want to quit the program? Y/N [Y]:    \n\n>>', 's');
         if (reply == 'Y'),
            error('Check the correspondency between the NUMBER OF SIGNAL SAMPLES/CYCLE and The FITORDER!');            
         end
      end
   end         
end

% Delete The Cycles Array
Cycles = [];


%======= REMOVE THE PHYSIOLOGICAL SIGNAL FROM THE TIME SERIES (TS) ========
% Corrects RESP, CARD or both  RESP/CARD Influences In A Time Series Using 
% Phases Of RESP or CARD Signals Synchronized With Record Times Of Slices
% In The TS  

% Retrieves Required Volumes (Time Points) IF Necessary
if ( (TimePtSpan(1) > 1) | (TimePtSpan(2) < Nt) ),
   IM = IM(:, :, :, TimePtSpan(1):TimePtSpan(2));
end

% Check If IM is A Complex Matrix (Case MREG)
C = isreal( IM);

% Perform The Physio Noise Correction
if (C ~= 0),  % IM Is Not Complex
   IMc = TimeSerieImagePhysioCorrection1(IM, PhasesOfSlices, CyclesOfSlices, WhichPhysio, CYCLIC, WhichFitMethod, FITORDER, Interleave);
   
else,         % IM Is Complex
   % Perform The Noise Correction On The Real Part 
   IMc = IM;
   IMc = real( IM );
   IMc = TimeSerieImagePhysioCorrection1(IMc, PhasesOfSlices, CyclesOfSlices, WhichPhysio, CYCLIC, WhichFitMethod, FITORDER, Interleave);
   
   % Perform The Noise Correction On The Imaginary Part
   IM = imag( IM );   
   IM = TimeSerieImagePhysioCorrection1(IM, PhasesOfSlices, CyclesOfSlices, WhichPhysio, CYCLIC, WhichFitMethod, FITORDER, Interleave);
   
   % Set Back The Complex Corrected Data In The Structure
   IMc = complex(IMc, IM);  
end











