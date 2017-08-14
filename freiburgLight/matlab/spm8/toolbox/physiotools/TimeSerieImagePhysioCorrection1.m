function IMcfiles = TimeSerieImagePhysioCorrection1(IMfiles, PhasesOfSlices, CyclesOfSlices, WhichPhysio, Cyclic, WhichFitMethod, FITORDER, Sliceorder, Prefix)
%==========================================================================
% TIMESERIEIMAGEPHYSIOCORRECTION1: Removes Cardiac(ECGorCARD), Respiratory 
% (RESP) or PULS Signals From A fMRI Time Series (TS). This Program Uses A
% Scale Of Phases Of Physiological Signal(s) Synchronized With Times Of Ac-
% quisition Of All TS Slices.
% 
% INPUT:
%  * IMfiles        --> Cell array of image filenames to be corrected. For
%                       each input image, a new output image will be
%                       created by prefixing the image filename with the
%                       Prefix input argument.
%
%  * PHASESOFSLICES --> Phases Of Physiological Signal at Times Of Acquisi-
%                       tion Of All TS Slices.
%
%  * CYCLESOFSLICES --> Labels of Cycles Of The Physio. Signal at Times Of
%                       Acquisition Of All TS Slices.
%
%  * WHICHPHYSIO    --> Declares Which Physio Signal to Correct
%                        * WHICHPHYSIO  =  0  => CARD Correction
%                        * WHICHPHYSIO  =  1  => RESP Correction
%                        * WHICHPHYSIO  =  2  => PULS Correction
%                        * WHICHPHYSIO  =  3  => RESP+CARD Corrections
%                        * WHICHPHYSIO  =  4  => CARD+RESP Corrections
%                        * WHICHPHYSIO  =  5  => RESP+PULS Corrections
%                        * WHICHPHYSIO  =  6  => PULS+RESP Corrections
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
%  * WHICHFITMETHOD --> Sets The Fitting Method To Be Used:
%                        * WHICHFITMETHOD  = [0] => Low Fourier Series
%                        * WHICHFITMETHOD >=  1  => Polynomial
%                        
%  * FITORDER       --> Sets Low Fourier Series Or Polynomial Order(Degree)
%                        * FITORDER  = [2] => Low Fourier Series
%                        * FITORDER  =  4  => Polynomial
%
%  * SLICEORDER     --> Sets The Record Order Of TS Slices
%
%  * PREFIX         --> Filename prefix for corrected files.
%
%
% OUTPUT:
%  * IMcfiles       --> File names of corrected files (cell array).
%
%---------------------------------------------
% A. ELLA, Univ. Hospital Freiburg, Diag. Radiol, Medical Physics, 2008
% Arsene.Ella@uniklinik-freiburg.de
%==========================================================================



%============================ INITIALIZATIONS =============================
% Compute Image Sizes
Vi = spm_vol(char(IMfiles));
Nt = numel(Vi);
Nx = Vi(1).dim(1); Ny = Vi(1).dim(2); Ns = Vi(1).dim(3);

% Total Nber Of Slices In The Time Series
TotNberOfSlices = Ns * Nt;

% Set The Number And The Order (RESP-ECG or ECG-RESP) Of Correction
FITORDER(2) = 0;

if (WhichPhysio <= 2),                             % ECG or RESP or PULS
   if (WhichPhysio == 1),    FITORDER(2) = 1;    end
   NBCOR   = 1;
   NBCORmi = 1;
   
elseif ( (WhichPhysio == 3) ||(WhichPhysio == 5) ), % RESP+ECG or RESP+PULS
   FITORDER(2) = 1;                                %    * 1st: RESP
   FITORDER(3) = 0;                                %    * 2nd: ECG or PULS
   NBCOR   = 2;
   NBCORmi = 2;
   
elseif ( (WhichPhysio == 4) ||(WhichPhysio == 6) ), % ECG+RESP or PULS+RESP
   FITORDER(2) = 0;                                %    * 1st: ECG or PULS
   FITORDER(3) = 1;                                %    * 2nd: RESP
   NBCOR   = 2;
   NBCORmi = 3;
end

% Vectors Initialization
Ci2 = [];

% Original Image Buffer Initialization - one plane per image at a time
IM  = zeros(Nx, Ny, Nt);
% Corrected Image Buffer Initialization - one plane per image at a time
IMc = zeros(Nx, Ny, Nt);
% Corrected Image Initialisation
Vc = rmfield(Vi,'private');
for k = 1:numel(Vi)
    [p n e v] = spm_fileparts(Vi(k).fname);
    Vc(k).fname = fullfile(p, [Prefix n e v]);
end
Vc = spm_create_vol(Vc);
IMcfiles = {Vc.fname}';

%======= TIME SERIES SLICE RECORDING ORDER(indexes) INITIALIZATION ========
% Scan# (starting at 0) + Slice# within scan
SR = kron((0:(Nt-1))*Ns,ones(1,Ns)) + repmat(Sliceorder,1,Nt); 


%======== CORRECTION OF PHYSIO. INFLUENCES IN A TIME SERIES IMAGE =========
if (Cyclic <= 0),        % NORMAL CORRECTION (Even For 2 Physio Types)
   
   fprintf('\n\nSTART OF THE GLOBAL CORRECTION.\n\n');
   
   for s = 1:Ns,
      % Retrieve TS Volume Indexes Of Current Slices s, From The Whole TS 
      % Array Of Indexes Stored In The Sequential Order (Image Scale)
      k = s:Ns:TotNberOfSlices;    
      
      % Retrieve TS Volume Indexes Of Current Slices s, From The Whole TS 
      % Array Of Indexes Stored in The Record Order (Record Scale, Inter-
      % leave)
      k = SR( k );
                  
      % Retrieve Phases At Current Slices s, From The Whole TS Array Of
      % Phases (Record Scale)
      PHY = PhasesOfSlices(1:NBCOR, k);
      
      % Read data from all images
      M = spm_matrix([0 0 -s 0 0 0 1 1 1]);
      for j = 1:Nt
          IM(:,:,j) = spm_slice_vol(Vi(j), M, [Nx Ny], [0 NaN]);
      end
      
      % TS Physiological Signal Correction
      for i = 1:Nx,
         for j = 1:Ny,                 
            if (IM(i, j, 1) ~= 0)
               % Retrive The Current TS Voxel Intensities
               % From All TS Volumes
               Io = reshape(IM(i, j, :), 1, Nt);
               
               % Correction Of The Current TS Voxel Intensities 
               [Ic,If] = TimePointCorrection(Io, PHY, Nt, FITORDER, WhichFitMethod, NBCOR);
                           
               % Store The Current TS Voxel Back In Corrected TS
               IMc(i, j, :) = Ic;                                    
            end  
         end
      end
      
      % Write data plane by plane
      for j = 1:Nt
          Vc(j) = spm_write_plane(Vc(j), IMc(:,:,j), s);
      end
   end
   
   fprintf('\n\nEND OF THE GLOBAL CORRECTION.\n\n');
   
   
elseif (Cyclic == 1)     % MI-CYCLIC CORRECTION (1st Cylic, 2nd is Normal)
   
   fprintf('\n\nSTART OF THE MI-CYCLIC CORRECTION.\n\n'); 
    
   for s = 1:Ns,
      % Retrieve TS Volume Indexes Of Current Slices s, From The Whole TS 
      % Array Of Indexes Stored In The Sequential Order (Image Scale)
      k = s:Ns:TotNberOfSlices;
      
      % Retrieve TS Volume Indexes Of Current Slices s, From The Whole TS 
      % Array Of Indexes Stored in The Record Order (Record Scale, Inter-
      % leave)
      k = SR( k );
      
      % Retrieve Phases At Current Slices s, From The Whole TS Array Of
      % Phases (Record Scale)
      PHY = PhasesOfSlices(1:NBCOR, k);
      
      % Retrieve Cycles At Current Slices s, From The Whole TS Array Of
      % Phases (Record Scale)
      CYC = CyclesOfSlices(k);
            
      % Compute Starting Indexes Of Cycles At Current Slices s
      c1 = abs( CYC(1,1)  );
      c2 = abs( CYC(1,Nt) );
      Ncycles = c2-c1+1;
      Ci1     = zeros(1, Ncycles);
      for i = c1:c2,   
         j = find(abs( CYC(1,:) ) == i);    
         Ci1(i-c1+1) = j(1);    
      end
                  
      % Read data from all images
      M = spm_matrix([0 0 -s 0 0 0 1 1 1]);
      for j = 1:Nt
          IM(:,:,j) = spm_slice_vol(Vi(j), M, [Nx Ny], [0 NaN]);
      end
      
      % TS Physiological Signal Correction
      for i = 1:Nx,
         for j = 1:Ny,                 
            if (IM(i, j, 1) ~= 0)
               % Retrive The Current TS Voxel Intensities
               % From All TS Volumes
               Io = reshape(IM(i, j, :), 1, Nt);
               
               % Correction Of The Current TS Voxel Intensities
               [Ic,If] = TimePtMiCyclicCorrection(Io, PHY, Nt, FITORDER, WhichFitMethod, Ci1, NBCORmi);
               
               % Store The Current TS Voxel Back In Corrected TS
               IMc(i, j, :) = Ic;                                    
            end  
         end
      end
      
      % Write data plane by plane
      for j = 1:Nt
          Vc(j) = spm_write_plane(Vc(j), IMc(:,:,j), s);
      end
   end
   
   fprintf('\n\nEND OF THE MI-CYCLIC CORRECTION.\n\n');
   
   
else                     % CYCLIC CORRECTION (Even For 2 Physio Types)
   
   fprintf('\n\nSTART OF THE CYCLIC CORRECTION.\n\n');
    
   for s = 1:Ns,
      % Retrieve TS Volume Indexes Of Current Slices s, From The Whole TS 
      % Array Of Indexes Stored In The Sequential Order (Image Scale)
      k = s:Ns:TotNberOfSlices;
      
      % Retrieve TS Volume Indexes Of Current Slices s, From The Whole TS 
      % Array Of Indexes Stored in The Record Order (Record Scale, Inter-
      % leave)
      k = SR( k );
            
      % Retrieve Phases At Current Slices s, From The Whole TS Array Of
      % Phases (Record Scale)
      PHY = PhasesOfSlices(1:NBCOR, k);
      
      % Retrieve Cycles At Current Slices s, From The Whole TS Array Of
      % Phases (Record Scale)
      CYC = CyclesOfSlices(1:NBCOR, k);
      
      % Compute Starting Indexes Of Cycles At 
      % Current Slices s For The 1st Signal
      c1 = abs( CYC(1,1)  );
      c2 = abs( CYC(1,Nt) );
      Ncycles = c2-c1+1;
      Ci1     = zeros(1, Ncycles);
      for i = c1:c2,   
         j = find(abs( CYC(1,:) ) == i);    
         Ci1(i-c1+1) = j(1);    
      end
      
      % Compute Starting Indexes Of Cycles At 
      % Current Slices s For The 2nd Signal
      if (NBCOR == 2)
         c1 = abs( CYC(2,1)  );
         c2 = abs( CYC(2,Nt) );
         Ncycles = c2-c1+1;
         Ci2     = zeros(1, Ncycles);
         
         for i = c1:c2,   
            j = find(abs( CYC(2,:) ) == i);    
            Ci2(i-c1+1) = j(1);    
         end
      end
      
      % Read data from all images
      M = spm_matrix([0 0 -s 0 0 0 1 1 1]);
      for j = 1:Nt
          IM(:,:,j) = spm_slice_vol(Vi(j), M, [Nx Ny], [0 NaN]);
      end
      
      % TS Physiological Signal Correction
      for i = 1:Nx,
         for j = 1:Ny,                 
            if (IM(i, j, 1) ~= 0)
               % Retrive The Current TS Voxel Intensities
               % From All TS Volumes
               Io = reshape(IM(i, j, :), 1, Nt);

               % Correction Of The Current TS Voxel Intensities
               [Ic,If] = TimePtCyclicCorrection(Io, PHY, Nt, FITORDER, WhichFitMethod, Ci1, Ci2);
               
               % Store The Current TS Voxel Back In Corrected TS
               IMc(i, j, :) = Ic;                                    
            end  
         end
      end
      
      % Write data plane by plane
      for j = 1:Nt
          Vc(j) = spm_write_plane(Vc(j), IMc(:,:,j), s);
      end
   end
   
   fprintf('\n\nEND OF THE CYCLIC CORRECTION.\n\n');
   
end





















