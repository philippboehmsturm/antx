function [Ic,If] = TimePointCorrection(Io, PHY, Nt, FITORDER, WhichFitMethod, NbCor)
%==========================================================================
% TIMEPOINTCORRECTION Performs GLOBAL Polynomial or Fourier Series Fitting 
% and Physiological Signal Correction Over Data (PHY,Io) In A Time Series
% (TS) Voxel as :
%
%                           Ic = Io - If + IoMean.
%
% INPUT:
%  * Io           --> Array Of Intensities Of The TS Voxel
%  * PHY          --> Array Of Physio Signal Phases At Times Of Acquisition
%                     Of Io
%  * Nt           --> Number Of Time Points (Or Volumes)
%  * FITORDER     --> Array Of 3 Elements:
%                       1) Fourier Series or Polynomial Order (Degree)
%                       2) =0 -> ECG correction  OR  =1 -> RESP correction
%                       3) =0 -> ECG correction  OR  =1 -> RESP correction
%  * WhichFitMethod --> Sets The Fitting Method To Be Used:
%                           * WhichFitMethod  = [0] => Low Fourier Series
%                           * WhichFitMethod >=  1  => Polynomial
%  * NBCOR        --> Nber Of Physio Signal Corrections [1 or 2]
%
% OUTPUT:
%     * Ic        --> Array Of Corrected TS Voxel Intensities
%     * If        --> Array Of Fitting TS Voxel Intensities
%
%---------------------------------------------
% A. ELLA, Univ. Hospital Freiburg, Diag. Radiol, Medical Physics, 2008
% Arsene.Ella@uniklinik-freiburg.de
%==========================================================================



%============================ INITIALIZATIONS =============================
if WhichFitMethod == 0,    % FOURIER SERIES CORRECTION
   % Performs A GLOBAL Fourier Series Fitting And Physio Signal Correction
   % Over The Time Series Voxel (can deal with 2 Physio Signal corrections)
   [Ic, If, COEF] = FourierSerieTimePtCorrection(Io, PHY, Nt, FITORDER, NbCor);
   
else,                     % POLYNOMIAL CORRECTION
   % Performs A NORMAL Polynomial Fitting And Physio Signal Correction Over
   % The Time Series Voxel (can deal with 2 Physio Signal corrections)
   [Ic, If, COEF] = PolynomialTimePtCorrection(Io, PHY, FITORDER, NbCor);
end    
