function IMc = PhysioRectroCorrectInTimeSeries2(IM, TR, PhysioFilename, WhichPhysio, TimePtSpan, CYCLIC, WhichFitMethod, FITORDER, Interleave)
%==========================================================================
% PHYSIORECTROCORRECTINTIMESERIES2:Removes Cardiac(ECGorCARD), Respiratory 
% (RESP) or PULS Signals From A fMRI Time Series (TS). This Program Uses A
% Scale Of Phases Of Physiological Signal(s) Synchronized With Times Of Ac-
% quisition Of All TS Slices.
%
% 1) Phases And Cycles Of Slices Of CARD/RESP Signal(s) Are Already Compu-
%    ted And Stored In A .MAT File.
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
%  * [ CYCLIC ]     --> Checks If The Required Correction is Cyclic Or Not:
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
%  * [WHICHFITMETHOD]--> Sets The Fitting Method To Be Used:
%                         * WHICHFITMETHOD  = [0] => Low Fourier Series
%                         * WHICHFITMETHOD >=  1  => Polynomial
%                        
%  * [ FITORDER ]   --> Sets Low Fourier Series Or Polynomial Order(Degree)
%                         * FITORDER  = [2] => Low Fourier Series
%                         * FITORDER  =  4  => Polynomial
%
%  * [ INTERLEAVE ] --> Sets The Record Order Of TS Slices 
%                         * INTERLEAVE  =  0  => Normal (1,2,3,4,5...)
%                         * INTERLEAVE >= [1] => Interl (1,3,5..2,4,6..)
%
%
% OUTPUT:
%    * IMc          --> Corrected Time Series Image 
%
%---------------------------------------------
% A. ELLA, Univ. Hospital Freiburg, Diag. Radiol, Medical Physics, 2008
% Arsene.Ella@uniklinik-freiburg.de
%==========================================================================



%================== CHECK THE NUMBER OF INPUT ARGUMENTS ===================
% Check The Number Of Input Arguments
if nargin < 4,    error('Not enough arguments!'); end



%============================ INITIALIZATIONS =============================
% Compute Image Sizes
[Nx, Ny, Ns, Nt] = size(IM);


% Set Which Physio Signal is to be Corrected and, in Case of 2 Signals, Set
% in Which Order Those Signal are Corrected
if     (WhichPhysio == 0),
   WhichPhysio1 = 0;
   WhichPhysio2 = [];
   fprintf('ECG Correction Required.\n\n');   
elseif (WhichPhysio == 1),
   WhichPhysio1 = 1;
   WhichPhysio2 = [];
   fprintf('RESP Correction Required.\n\n');   
elseif (WhichPhysio == 2),
   WhichPhysio1 = 2;
   WhichPhysio2 = [];
   fprintf('PULS Correction Required.\n\n');  
elseif (WhichPhysio == 3),
   WhichPhysio1 = 1;
   WhichPhysio2 = 0;
   fprintf('RESP+ECG Corrections Required.\n\n');
elseif (WhichPhysio == 4),
   WhichPhysio1 = 0;
   WhichPhysio2 = 1;   
   fprintf('ECG+RESP Corrections Required.\n\n');
elseif (WhichPhysio == 5),
   WhichPhysio1 = 1;
   WhichPhysio2 = 2;
   fprintf('RESP+PULS Corrections Required.\n\n');
elseif (WhichPhysio == 6),
   WhichPhysio1 = 2;
   WhichPhysio2 = 1;
   fprintf('PULS+RESP Corrections Required.\n\n');
else
   error('UNKNOWN REQUIRED CORRECTION!!!!!');
end

% Init. Of Vectors
PhasesOfSlices = [];
CyclesOfSlices = [];
CYCLICflag     = -1;


%=================== SET THE OPTIONAL INPUT ARGUMENTS =====================
if nargin < 9,   Interleave = 1;      end

if nargin < 8, 
   if ( (nargin == 7) & (WhichFitMethod > 0) ),  % Case: Polynomial
      FITORDER = 4; 
   else                                          % Case: Low Fourier Series
      FITORDER = 2;
   end
end

if nargin < 7,   WhichFitMethod = 0;  end

if nargin < 6,
   CYCLICflag = 1;
   NBCOR      = 1;
   CYCLIC     = [];
     
   %------------- If Only One Signal ------------- 
   % Set Physio Phases & Cycles Matrix File Name
   if     WhichPhysio1 == 0,     % => Case: ECG
      PhasesCyclesFilename = [PhysioFilename 'PhasCyclECG'];
   elseif WhichPhysio1 == 1,     % => Case: RESP    
      PhasesCyclesFilename = [PhysioFilename 'PhasCyclRESP'];
   elseif WhichPhysio1 == 2,      % => Case: PULS
      PhasesCyclesFilename = [PhysioFilename 'PhasCyclPULS'];
   end
      
   % Load The Physio Phases & Cycles Matrix
   load( PhasesCyclesFilename );         
   fprintf('\n\n1st PHASES&CYCLES MATRIX LOADED.\n\n');   

   % Set Phases Of Slices
   PhasesOfSlices = PhysioPhases1Cycles2ofSlices(1,:); 
   
            
   % Retrieve End Cycles
   Cs = abs( PhysioPhases1Cycles2ofSlices(2,1) )   + 1;
   Ce = abs( PhysioPhases1Cycles2ofSlices(2,end) ) - 1;
          
   % Compare The Nber of SAMPLES per Each CYCLE With The FIT ORDER
   ChCY2 = 0;     ChCYf = 0;     ChCYp = 0;
   
   for i = Cs:Ce,
      j = find( abs( PhysioPhases1Cycles2ofSlices(2,:) ) == i );
      Lj = length(j);
      
      if    (Lj < 2),
         ChCY2 = ChCY2 + 1;
      elseif (Lj  < FITORDER), 
         ChCYf = ChCYf + 1;
      elseif (Lj == FITORDER), 
         ChCYp = ChCYp + 1;
      end            
   end                
      
   % Set The Correction Mode And Store The Cycles
   CYCLIC = 0;
   
   if (ChCY2 > 0),                          % Existe At Least 1 Cycle where: NBER OF SAMPLES < 2
      fprintf('\n\n THE 1st SIGNAL CORRECTION IS SET TO: GLOBAL.\n\n');
   else,
      if WhichFitMethod <= 0,     % Case: Fourier Fit
         if (ChCYf == 0),                   % NO Cycle where: NBER OF SAMPLES < FITORDER
            % Set The Correction Mode
            CYCLIC = CYCLIC + 1;
            
            % Store The Cycles
            CyclesOfSlices = PhysioPhases1Cycles2ofSlices(2,:);
            
            % Display The Correction Mode
            fprintf('\n\n THE 1st SIGNAL CORRECTION IS SET TO: CYCLIC.\n\n');
         else,
            fprintf('\n\n THE 1st SIGNAL CORRECTION IS SET TO: GLOBAL.\n\n');
         end
      else,                       % Case: Polynomial Fit
         if ((ChCYf == 0) & (ChCYp == 0)),  % NO Cycle where: NBER OF SAMPLES <= FITORDER
            % Set The Correction Mode
            CYCLIC = CYCLIC + 1;
            
            % Store The Cycles
            CyclesOfSlices = PhysioPhases1Cycles2ofSlices(2,:);
            
            % Display The Correction Mode
            fprintf('\n\n THE 1st SIGNAL CORRECTION IS SET TO: CYCLIC.\n\n');
         else,
            fprintf('\n\n THE 1st SIGNAL CORRECTION IS SET TO: GLOBAL.\n\n');            
         end
      end
   end
   
   
   %--------------- If Two Signal ---------------- 
   % Set Physio Phases & Cycles Matrix File Name
   if WhichPhysio > 2,
      NBCOR = 2;
      
      if     WhichPhysio2 == 0,     % => Case: ECG
         PhasesCyclesFilename = [PhysioFilename 'PhasCyclECG'];
      elseif WhichPhysio2 == 1,     % => Case: RESP    
         PhasesCyclesFilename = [PhysioFilename 'PhasCyclRESP'];
      elseif WhichPhysio2 == 2,      % => Case: PULS
         PhasesCyclesFilename = [PhysioFilename 'PhasCyclPULS'];
      end
      
      % Load The Physio Phases & Cycles Matrix
      load( PhasesCyclesFilename );         
      fprintf('\n\n2nd PHASES&CYCLES MATRIX LOADED.\n\n');   
      
      % Set Phases Of Slices
      PhasesOfSlices = [PhasesOfSlices; PhysioPhases1Cycles2ofSlices(1,:)];
               
      % Retrieve End Cycles
      Cs = abs( PhysioPhases1Cycles2ofSlices(2,1) )   + 1;
      Ce = abs( PhysioPhases1Cycles2ofSlices(2,end) ) - 1;
             
      % Compare The Nber of SAMPLES per Each CYCLE With The FIT ORDER
      ChCY2 = 0;     ChCYf = 0;     ChCYp = 0;
      
      for i = Cs:Ce,
         j = find( abs( PhysioPhases1Cycles2ofSlices(2,:) ) == i );
         Lj = length(j);
         
         if    (Lj < 2),
            ChCY2 = ChCY2 + 1;
         elseif (Lj  < FITORDER), 
            ChCYf = ChCYf + 1;
         elseif (Lj == FITORDER), 
            ChCYp = ChCYp + 1;
         end            
      end                
       
      % Set The Correction Mode And The Cycles 
      if (ChCY2 > 0),                          % Existe At Least 1 Cycle where: NBER OF SAMPLES < 2
         fprintf('\n\n THE 2nd SIGNAL CORRECTION IS SET TO: GLOBAL.\n\n');
      else,
         if WhichFitMethod <= 0,     % Case: Fourier Fit
            if (ChCYf == 0),                   % NO Cycle where: NBER OF SAMPLES < FITORDER
               % Set The Correction Mode
               CYCLIC = CYCLIC + 1;
               
               % Store The Cycles
               CyclesOfSlices = [CyclesOfSlices; PhysioPhases1Cycles2ofSlices(2,:)];
               
               % Display The Correction Mode
               fprintf('\n\n THE 2nd SIGNAL CORRECTION IS SET TO: CYCLIC.\n\n');
               
               % Set The Number Of Correction
               if ( (CYCLIC == 1) & (WhichPhysio2 == 1) )   
                  NBCOR = 3;
               end               
            else,
               fprintf('\n\n THE 2nd SIGNAL CORRECTION IS SET TO: GLOBAL.\n\n');                        
            end
         else,                       % Case: Polynomial Fit
            if ((ChCYf == 0) & (ChCYp == 0)),  % NO Cycle where: NBER OF SAMPLES <= FITORDER
               % Set The Correction Mode
               CYCLIC = CYCLIC + 1;
               
               % Store The Cycles
               CyclesOfSlices = [CyclesOfSlices; PhysioPhases1Cycles2ofSlices(2,:)];
               
               % Display The Correction Mode
               fprintf('\n\n THE 2nd SIGNAL CORRECTION IS SET TO: CYCLIC.\n\n');
               
               % Set The Number Of Correction
               if ( (CYCLIC == 1) & (WhichPhysio2 == 1) )   
                  NBCOR = 3;
               end               
            else,
               fprintf('\n\n THE 2nd SIGNAL CORRECTION IS SET TO: GLOBAL.\n\n');                                    
            end
         end 
      end
   end
   %---------------
   
   % Display the Mode
   if CYCLIC <= 0,
      fprintf('\n\n ONLY GLOBAL CORRECTION(S) ARE PERFORMED.\n\n');
   elseif CYCLIC == 1,
      if NBCOR == 1,
          fprintf('\n\n A CYCLIC CORRECTION IS PERFORMED.\n\n');
      elseif NBCOR == 2,
         fprintf('\n\n 2 CORRECTIONS ARE REQUIRED (SEMI-CYCLIC): the 1st IS CYCLIC(RESP) and the 2nd IS GLOBAL.\n\n');
      else  %NBCOR == 3 
         fprintf('\n\n 2 CORRECTIONS ARE REQUIRED (SEMI-CYCLIC): the 1st IS GLOBAL and the 2nd IS CYCLIC(RESP).\n\n');
      end
   else,
      fprintf('\n\n 2 CORRECTIONS ARE REQUIRED: both are CYCLIC.\n\n');
   end
end


if nargin <  5,   TimePtSpan = [1 Nt Nt];   end




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
   error('Check the TIMEPTSPAN parameter');
end



%================ PHYSIO SIGNAL PHASES & CYCLES RETRIEVING ================
%=== CHECK NberOfTimePoint/SignalCycle & The Correction Mode in CYCLIC ====

% IF Nber Of Function Arguments > 6  => CYCLIC is Given => CYCLICflag = -1

%------------- If Only One Signal -------------
if CYCLICflag < 0,
    
    if     WhichPhysio1 == 0,                               % => Case: ECG
   
      % Set The File Name Of The Matrix Of Phases & Cycles
      PhasesCyclesFilename = [PhysioFilename 'PhasCyclECG'];
      
      % Load The Phases & Cycles Matrix(PhysioPhases1Cycles2ofSlices)
      % Where Signal Phases Are Stored In Row No1 & Cycles in Row No2
      load( PhasesCyclesFilename );         
      
      fprintf('\n\n1st PHASES&CYCLES MATRIX LOADED (ECG).\n\n');
      
   elseif WhichPhysio1 == 1,                                % => Case: RESP
      
      % Set The File Name Of The Matrix Of Phases & Cycles
      if    CYCLIC >= 0,                   % RESP Linear Phases
         PhasesCyclesFilename = [PhysioFilename 'PhasCyclRESP'];
      else% CYCLIC <  0;                   % RESP Histo Phases (RectroIcor)
         PhasesCyclesFilename = [PhysioFilename 'PhasHistRESP'];
      end
      
      % Load The Phases & Cycles Matrix(PhysioPhases1Cycles2ofSlices)
      % Where Signal Phases Are Stored In Row No1 & Cycles in Row No2
      load( PhasesCyclesFilename );         
      
      fprintf('\n\n1st PHASES&CYCLES MATRIX LOADED (RESP).\n\n');
      
   elseif WhichPhysio1 == 2,                                % => Case: PULS
      
      % Set The File Name Of The Matrix Of Phases & Cycles
      PhasesCyclesFilename = [PhysioFilename 'PhasCyclPULS'];
      
      % Load The Phases & Cycles Matrix(PhysioPhases1Cycles2ofSlices)
      % Where Signal Phases Are Stored In Row No1 & Cycles in Row No2
      load( PhasesCyclesFilename );         
      
      fprintf('\n\n1st PHASES&CYCLES MATRIX LOADED (PULS).\n\n');   
   end
   
   % Set Phases Of Slices
   PhasesOfSlices = PhysioPhases1Cycles2ofSlices(1,:);
   
   
   % Set The Cycles Of Slices If The Cyclic Process Is Needed
   if CYCLIC > 0,
      if (   ( CYCLIC == 2                                            )...   % 1) ECG  is Cyclic   And   2) RESP is Cyclic   (Or the Reverse)
           | ((CYCLIC == 1) & (WhichPhysio < 3)                       )...   % 1) ECG  is Cyclic   Or    1) RESP is Cyclic
           | ((CYCLIC == 1) & (WhichPhysio > 2) & (WhichPhysio1 == 1) )...   % 1) RESP is Cyclic   And   2) ECG  is Global
          ),                  
         % Retrieve End Cycles
         Cs = abs( PhysioPhases1Cycles2ofSlices(2,1) )   + 1;
         Ce = abs( PhysioPhases1Cycles2ofSlices(2,end) ) - 1;
                
         % Compare The Nber of SAMPLES per Each CYCLE With The FIT ORDER
         ChCYf = 0;     ChCYp = 0;
         
         for i = Cs:Ce,
            j = find( abs( PhysioPhases1Cycles2ofSlices(2,:) ) == i );
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
         
         % Check the Correspondence Between The Nber of SAMPLESperCYCLE And
         % The Correction Mode
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
         
         % Store The Cycles
         CyclesOfSlices = PhysioPhases1Cycles2ofSlices(2,:);        
      end
   end

   % Delete The Physio Phases & Cycles Matrix
   PhysioPhases1Cycles2ofSlices = [];
end


%--------------- If Two Signal ----------------
if ( (CYCLICflag < 0) & (WhichPhysio > 2) ),
    
    if     WhichPhysio2 == 0,                               % => Case: ECG
         
      % Set The File Name Of The Matrix Of Phases & Cycles
      PhasesCyclesFilename = [PhysioFilename 'PhasCyclECG'];
      
      % Load The Phases & Cycles Matrix(PhysioPhases1Cycles2ofSlices)
      % Where Signal Phases Are Stored In Row No1 & Cycles in Row No2
      load( PhasesCyclesFilename );         
      
      fprintf('\n\n2nd PHASES&CYCLES MATRIX LOADED (ECG).\n\n');
      
   elseif WhichPhysio2 == 1,                                % => Case: RESP
      
      % Set The File Name Of The Matrix Of Phases & Cycles
      if    CYCLIC >= 0,                   % RESP Linear Phases
         PhasesCyclesFilename = [PhysioFilename 'PhasCyclRESP'];
      else% CYCLIC <  0;                   % RESP Histo Phases (RectroIcor)
         PhasesCyclesFilename = [PhysioFilename 'PhasHistRESP'];
      end
      
      % Load The Phases & Cycles Matrix(PhysioPhases1Cycles2ofSlices)
      % Where Signal Phases Are Stored In Row No1 & Cycles in Row No2
      load( PhasesCyclesFilename );         
      
      fprintf('\n\n2nd PHASES&CYCLES MATRIX LOADED (RESP).\n\n');
      
   elseif WhichPhysio2 == 2,                                % => Case: PULS
      
      % Set The File Name Of The Matrix Of Phases & Cycles
      PhasesCyclesFilename = [PhysioFilename 'PhasCyclPULS'];
      
      % Load The Phases & Cycles Matrix(PhysioPhases1Cycles2ofSlices)
      % Where Signal Phases Are Stored In Row No1 & Cycles in Row No2
      load( PhasesCyclesFilename );         
      
      fprintf('\n\n2nd PHASES&CYCLES MATRIX LOADED (PULS).\n\n');   
   end
   
   % Set Phases Of Slices
   PhasesOfSlices = [PhasesOfSlices; PhysioPhases1Cycles2ofSlices(1,:)];
      
   
   % Set The Cycles Of Slices If The Fine Cyclic Process Is Needed
   if CYCLIC > 0,
      % Both Signals Were Required Cyclic, OR Only 
      % the 2nd Signal (RESP) is Required Cyclic
      if ( (CYCLIC == 2) | ((CYCLIC == 1) & (WhichPhysio2 == 1)) ),   
         % Retrieve End Cycles
         Cs = abs( PhysioPhases1Cycles2ofSlices(2,1) )   + 1;
         Ce = abs( PhysioPhases1Cycles2ofSlices(2,end) ) - 1;
                
         % Compare The Nber of SAMPLES per Each CYCLE With The FIT ORDER
         ChCYf = 0;     ChCYp = 0;
         
         for i = Cs:Ce,
            j = find( abs( PhysioPhases1Cycles2ofSlices(2,:) ) == i );
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
         
         % Store The Cycles
         CyclesOfSlices = [CyclesOfSlices; PhysioPhases1Cycles2ofSlices(2,:)];
      end
   end
      
   % Delete The Physio Phases & Cycles Matrix
   PhysioPhases1Cycles2ofSlices = [];
end



%======= REMOVE THE PHYSIOLOGICAL SIGNAL FROM THE TIME SERIES (TS) ========
% Corrects RESP, CARD or both  RESP/CARD Influences In A Time Series Using 
% Phases Of RESP or CARD Signals Synchronized With Record Times Of Slices
% In The TS  

% Retrieves Required Volumes (Time Points) Phases & Cycles, IF Necessary
if ( (TimePtSpan(1) > 1) | (TimePtSpan(2) < Nt) ),
   IM = IM(:, :, :, TimePtSpan(1):TimePtSpan(2));
   
   NberPhasesOfSlices = length( PhasesOfSlices(1,:) );
   NTPS               = TimePtSpan(2) - TimePtSpan(1) + 1;
   
   if (NberPhasesOfSlices > NTPS),
      PhasesOfSlices = PhasesOfSlices(:, TimePtSpan(1):TimePtSpan(2));
      CyclesOfSlices = CyclesOfSlices(:, TimePtSpan(1):TimePtSpan(2));
   end
end


 % Check If IM is A Complex Matrix (Case MREG)
C = isreal( IM );

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
