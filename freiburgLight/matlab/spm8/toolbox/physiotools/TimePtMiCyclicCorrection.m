function [Ic,If] = TimePtMiCyclicCorrection(Io, PHY, Nt, FITORDER, WhichFitMethod, Ci1, NbCor)
%==========================================================================
% TIMEPTMICYCLICCORRECTION Performs CYCLIC (1 Signal To Be Corrected) or 
% SEMI-CYCLIC (2 Signals: 1 Is Global & 1 Is Cyclic Corrected) Polynomial
% Or/And Fourier Series Fitting(s) And Physiological Signal Correction(s) 
% Over Data(PHY,Io) Of A Time Serie (TS) Voxel as : 
%
%                          Ic = Io - Ifit + IoMean.
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
%  * CI1      --> Array Of Starting Indexes Of 1st Physio Signal Cycles
%  * NBCOR    --> Nber Of Physio Signal Corrections [1 or 2]
%
%
% OUTPUT:
%  * Ic       --> Array Of Corrected TS Voxel Intensities
%  * If       --> Array Of Fitting TS Voxel Intensities
%
%
%---------------------------------------------
% A. ELLA, Univ. Hospital Freiburg, Diag. Radiol, Medical Physics, 2008
% Arsene.Ella@uniklinik-freiburg.de
%==========================================================================


%============================ INITIALIZATIONS =============================
% FIRST: Performs A Low Fourier Series CYCLIC Intensity Fitting And The  
% 1st Physio Correction Over  The Time Point Intensities
% SECOND,IF NEEDED: Case 2 Physio To Correct, Performs Once Again Low 
% Fourier Series NORMAL Fitting And Physio Correction Over Time Point
% Intensities
if WhichFitMethod == 0,    % FOURIER SERIES CORRECTION
   if     NbCor == 1,   % => One Correction  -> CYCLIC 
     [Ic,If] = TimePtPhysioFourierCycleCorrect(Io, PHY(1,:), Ci1, Nt, FITORDER);
     
   elseif NbCor == 2,   % => Two Corrections -> 1st CYCLIC / 2nd NORMAL: case RESP-ECG
       FITORD  = FITORDER(1:2);
       [Ic,If] = TimePtPhysioFourierCycleCorrect(Io, PHY(1,:), Ci1, Nt, FITORD);
       [Ic,If,COEF] = FourierSerieTimePtCorrection(Ic, PHY(2,:), Nt, FITORD, 1);
       
   else                 % => Two Corrections -> 1st NORMAL / 2nd CYCLIC: case ECG-RESP
       FITORD = [FITORDER(1), FITORDER(3)];
       [Ic,If,COEF] = FourierSerieTimePtCorrection(Io, PHY(1,:), Nt, FITORD, 1);
       [Ic,If] = TimePtPhysioFourierCycleCorrect(Ic, PHY(2,:), Ci1, Nt, FITORD);
   end   
else,                     % POLYNOMIAL CORRECTION
   if     NbCor == 1,   % => One Correction  -> CYCLIC 
     [Ic,If] = TimePtPhysioPolynomCycleCorrect(Io, PHY(1,:), Ci1, Nt, FITORDER);
     
   elseif NbCor == 2,   % => Two Corrections -> 1st CYCLIC / 2nd NORMAL: case RESP-ECG
       FITORD  = FITORDER(1:2);
       [Ic,If] = TimePtPhysioPolynomCycleCorrect(Io, PHY(1,:), Ci1, Nt, FITORD);
       [Ic,If, COEF] = PolynomialTimePtCorrection(Ic, PHY(2,:), FITORD, 1);
       
   else                 % => Two Corrections -> 1st NORMAL / 2nd CYCLIC: case ECG-RESP
       FITORD = [FITORDER(1), FITORDER(3)];
       [Ic,If, COEF] = PolynomialTimePtCorrection(Io, PHY(1,:), FITORD, 1);
       [Ic,If] = TimePtPhysioPolynomCycleCorrect(Ic, PHY(2,:), Ci1, Nt, FITORD);
   end
end


