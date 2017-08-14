function [Ic,If] = TimePtCyclicCorrection(Io, PHY, Nt, FITORDER, WhichFitMethod, Ci1, Ci2)
%==========================================================================
% TIMEPTCYCLICCORRECTION Performs CYCLIC Polynomial Or/And Fourier Series 
% Fitting(s) and Physiological Signal Correction(s) Over Data(PHY,Io) of A 
% Time Series (TS) Voxel as : 
%
%                           Ic = Io - If + IoMean.
%
% INPUT:
%  * Io       --> Array Of Intensities Of The TS Voxel
%  * PHY      --> Array Of Phys.Signal Phases At Times Of Acquisition Of Io
%  * Nt       --> Number Of Time Points (Or Volumes).       Nt = Length(Io)
%  * FITORDER --> Array Of 3 Elements:
%                       1) Fourier Series or Polynomial Order (Degree)
%                       2) =0 -> ECG correction  OR  =1 -> RESP correction
%                       3) =0 -> ECG correction  OR  =1 -> RESP correction
%  * WHICHFITMETHOD --> Sets The Fitting Method To Be Used:
%                        * WHICHFITMETHOD  = [0] => Low Fourier Series
%                        * WHICHFITMETHOD >=  1  => Polynomial                      
%  * CI1       --> Array Of Starting Indexes Of 1st Physio Signal Cycles
%  * CI2       --> Array Of Starting Indexes Of 2nd Physio Signal Cycles
%
%
% OUTPUT:
%  * Ic       --> Array Of Corrected TS Voxel Intensities
%  * If       --> Array Of Fitting TS Voxel Intensities
%
%
%---------------------------------------------
% A. ELLA, Univ. Hospital Freiburg, Diag. Radiol, Medical Physics, 2007
% Arsene.Ella@uniklinik-freiburg.de
%==========================================================================


%============================ INITIALIZATIONS =============================
if WhichFitMethod == 0,    % FOURIER SERIES CORRECTION
   % Performs A CYCLIC Fourier Series Fitting And Noise Correction For The   
   % 1st Physio Signal
   FITORD  = FITORDER(1:2);
   [Ic,If] = TimePtPhysioFourierCycleCorrect(Io, PHY(1,:), Ci1, Nt, FITORD);

   % IF NEEDED: Case 2 Physio Are To be Corrected, Performs Once Again A  
   % CYCLIC Fourier Series Fitting And Noise Correction Over Voxel Time Ser
   if nargin > 6,
     FITORD  = [FITORDER(1), FITORDER(3)];
     [Ic,If] = TimePtPhysioFourierCycleCorrect(Ic, PHY(2,:), Ci2, Nt, FITORD);
   end
else,                     % POLYNOMIAL CORRECTION
   % Performs A CYCLIC Polynomial Fitting And Noise Correction For The 1st  
   % Physio Signal
   FITORD  = FITORDER(1:2);
   [Ic,If] = TimePtPhysioPolynomCycleCorrect(Io, PHY(1,:), Ci1, Nt, FITORD);

   % IF NEEDED: Case 2 Physio Are To be Corrected, Performs Once Again A  
   % CYCLIC Polynomial Fitting And Noise Correction Over Voxel Time Series  
   if nargin > 6,
     FITORD  = [FITORDER(1), FITORDER(3)];
     [Ic,If] = TimePtPhysioPolynomCycleCorrect(Ic, PHY(2,:), Ci2, Nt, FITORD);
   end
end    







