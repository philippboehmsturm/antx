function [Ic, If, COEF] = PolynomialTimePtCorrection(Io, PHY, FITORDER, NbCor)
%==========================================================================
% POLYNOMIALTIMEPTCORRECTION Computes a Polynomial Fitting Curve Over Data 
% in (PHY,Io) and Correct The Data as :
%
%                            Ic = Io - If + IoMean.
%
% Principle: the Physiological Noise Component in a Time Series Imaging Can
% Be Expressed as a Polynomial of Order M:
%
%   Y = A1.X^4 + A2.X^3 + A3.X^2 + A4.X^1 + A5  --> Polynomial of Order 4
%
%   Y = A1.X^M + A2.X^(M-1) + A3.X^(M-2) + ... + AM.X^1 + A(M+1)--> Order M
%
%
% INPUT:
%  * Io       --> Array Of Intensities Of The TS Voxel
%  * PHY      --> Array Of Phys.Signal Phases At Times Of Acquisition Of Io
%  * FITORDER --> Polynomial Order (Degree)
%  * NBCOR    --> Nber Of Physio Signal Corrections [1 or 2]
%
%
% OUTPUT:
%  * Ic       --> Array Of Corrected TS Voxel Intensities
%  * If       --> Array Of Fitting TS Voxel Intensities
%  * COEF     --> Polynomial Coefficients (Nber = FITORDER+1)
%
%
%---------------------------------------------
% A. ELLA, Univ. Hospital Freiburg, Diag. Radiol, Medical Physics, 2006
% Arsene.Ella@uniklinik-freiburg.de
%==========================================================================



%============================ INITIALIZATIONS =============================
FITORDER = FITORDER(1);

IoMean = mean(Io);
PHASE  = PHY(1,:);


%=============== POLYNOMIAL FITTING & INTENSITY CORRECTION ================
% Compute Polynomial Coefficients & Intensity Fitting Curve
COEF = polyfit(PHASE, Io, FITORDER);    % Polynomial Coefs, Order FITORDER
If   = polyval(COEF, PHASE);            % Fit Inten. By Polynom. Evaluation 

% Time Point 1st Physio Correction
Ic = Io - If + IoMean; 


%================== IF NEEDED: FIT & CORRECT ONCE AGAIN ===================
if NbCor == 2,
   PHASE  = PHY(2,:);
   
   % RE-Compute Polynomial Coefficients & Intensity Fitting Curve
   COEF = polyfit(PHASE, Ic, FITORDER);
   If   = polyval(COEF, PHASE); 

   % Time Point 2nd Physio Correction
   Ic = Ic - If + IoMean;
end
