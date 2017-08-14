function [Ic, If, COEF] = FourierSerieTimePtCorrection(Io, PHY, Nt, FITORDER, NbCor)
%==========================================================================
% FOURIERSERIETIMEPTCORRECTION Computes a Fourier Series Fitting Curve Over  
% Data in (PHY,Io) and Correct The Data as : 
%
%                            Ic = Io - If + IoMean.
%
% Principle: the Physiological Noise Component in a Time Series Imaging Can 
% Be Expressed as a Low Fourier Series Expanded in Terms of Phases.
%
%     * Example Of 2 Physio. Noises Cardia(c) & Respiration(r):
%
%
%           dY = SUM[m=1:M](   Acm.COS(m*PHYc) + Bcm.SIN(m*PHYc) 
%                            + Arm.COS(m*PHYr) + Brm.SIN(m*PHYr) )
%
%
%     * Acm & Bcm, coefs Of The Cardiac Component at Fourier Series Order m
%       are Computed as:
%
%
%                  SUM[n=1:Nt]( [Io(tn)-IoMean] * COS(m * PHYc(tn)) )
%           Acm =  --------------------------------------------------
%                  SUM[n=1:Nt](        COS^2(m * PHYc(tn))          )
%
%
%                  SUM[n=1:Nt]( [Io(tn)-IoMean] * SIN(m * PHYc(tn)) )
%           Bcm =  --------------------------------------------------
%                  SUM[n=1:Nt](        SIN^2(m * PHYc(tn))          )
%
%
%     * Arm & Brm, coefs Of The Respiration Component at Order m, are
%       Computed Using Both Equations Above, but Replacing c by r.
%
%
% INPUT:
%  * Io       --> Array Of Intensities Of The TS Voxel
%  * PHY      --> Array Of Phys.Signal Phases At Times Of Acquisition Of Io
%  * Nt       --> Number Of Time Points (Or Volumes) = Length(Io)
%  * FITORDER --> Fourier Series Order (Degree), often Low (== 2)
%  * NBCOR    --> Nber Of Physio Signal Corrections [1 or 2]
%
%
% OUTPUT:
%  * Ic       --> Array Of Corrected TS Voxel Intensities
%  * If       --> Array Of Fitting TS Voxel Intensities
%  * COEF     --> Fourier Series Coefficients, Only For 1st Physio Signal
%
%
%---------------------------------------------
% A. ELLA, Univ. Hospital Freiburg, Diag. Radiol, Medical Physics, 2006
% Arsene.Ella@uniklinik-freiburg.de
%==========================================================================


%============================ INITIALIZATIONS =============================
FITORDER = FITORDER(1);

IoMean = mean(Io);
I      = Io - IoMean;           % Zeroes The Current Time Point Intensities
COEF   = zeros(1, 2*FITORDER);
dY     = zeros(1, Nt);

%================= COMPUTE NOISE COMPONENT & FITTING COEFs ================
%================ IF NEEDED (case ECG+RESP): PROCEED AGAIN ================
for m = 1:FITORDER
   n      = 2*m;
   
   % Compute Coefs & The Noise Component (dY) Of The 1st Physio At Order m
   PHASE     = PHY(1,:);
   
   FOUmPHY   = cos(m * PHASE);
   CO        = sum( I.*FOUmPHY )/sum( FOUmPHY.*FOUmPHY );    % COS Coef: Am
   dY        = dY + (CO * FOUmPHY);
   COEF(n-1) = CO;
                                    
   %-----------------------
   FOUmPHY   = sin(m * PHASE);
   CO        = sum( I.*FOUmPHY )/sum( FOUmPHY.*FOUmPHY );    % SIN Coef: Bm
   dY        = dY + (CO * FOUmPHY);
   COEF(n)   = CO;
                                         
   % Compute Coefs & The Noise Component (dY) Of The 2nd Physio At Order m          
   if NbCor == 2,
      PHASE   = PHY(2,:);
                  
      FOUmPHY = cos(m * PHASE);
      CO      = sum( I.*FOUmPHY )/sum( FOUmPHY.*FOUmPHY );   % COS Coef: Am
      dY      = dY + (CO * FOUmPHY);
                  
      %-----------------------
      FOUmPHY = sin(m * PHASE);
      CO      = sum( I.*FOUmPHY )/sum( FOUmPHY.*FOUmPHY );   % SIN Coef: Bm
      dY      = dY + (CO * FOUmPHY);
   end            
end

%============ FOURIER SERIES TIME POINT INTENSITY CORRECTION ==============
Ic = Io - dY;
If = Io - Ic + IoMean;
