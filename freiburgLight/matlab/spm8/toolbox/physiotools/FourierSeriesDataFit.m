function [Y, COEF] = FourierSeriesDataFit(PHYt, Yt, M)
%======================================================================
% FOURIERSERIESDATAFIT Computes A Fourier Series Fitting Curve Over Data in
% (PHYt,Yt) by Computing 2xM+1 Coefficients Of The Fourier Series Function.
% 
% Ex: the Physiological Noise Component in a Time Series Imaging Can Be
%     Expressed as a Low Fourier Series Expanded in Terms of Phases By:
%
%  Yf = A1.*cos(X) + B1.*sin(X) + A2.*cos(2*X) + B2.*sin(2*X) + Ct
%
%
% INPUT:
%     * PHYt --> Array Of Phys.Signal Phases At Times Of Acquisition Of Yt
%     * Yt   --> Array Of Intensities Of The TS Voxel
%     * M    --> Fourier Series Order (or Degree), often Low (== 2)
%
% OUTPUT:
%     * Y    --> Curve Fitting TS Voxel Intensities in Yt
%     * COEF --> Fourier Series Coefficients (Matrix Of Size: Mx2)
%
%
%---------------------------------------------
% A. ELLA, Univ. Hospital Freiburg, Diag. Radiol, Medical Physics, 2006
% Arsene.Ella@uniklinik-freiburg.de
%==========================================================================


%===================== STARTs & ENDs INITIALIZATIONS ======================

% Vectors Initialization
Nt       = length(Yt);
dY       = zeros(1, Nt);
FOUmPHYt = zeros(1, Nt);
COEF     = zeros(M, 2);
              
% Zeroes The Current Time Point Intensities
YtMean = mean(Yt);
Y = Yt - YtMean;
            
% Compute Fourier Series Coefficients & The Physio Noise Component dY
for m = 1:M
   % Compute The COS Component Of The mth Order
   FOUmPHYt = cos(m * PHYt);
   CO = sum( Y.*FOUmPHYt )/sum( FOUmPHYt.*FOUmPHYt );  % Am
   dY = dY + (CO * FOUmPHYt);
   COEF(m,1) = CO;

   % Compute The SIN Component Of The mth Order
   FOUmPHYt = sin(m * PHYt);
   CO = sum( Y.*FOUmPHYt )/sum( FOUmPHYt.*FOUmPHYt );  % Bm
   dY = dY + (CO * FOUmPHYt);
   COEF(m,2) = CO;
end            
    
% Compute The Curve Fitting The Time Point Intensities
Y = dY + YtMean;










