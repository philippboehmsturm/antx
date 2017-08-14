function [Ic,If] = TimePtPhysioFourierCycleCorrect(Io, dP, Ci, Nt, FITORDER)
%==========================================================================
% TIMEPTPHYSIOFOURIERCYCLECORRECT Computes a CYCLIC Fourier Series Fitting   
% Curve Over Data in (PHY,Io) and Correct The Data as : 
%
%                      Icorrect = Io - Ifit + IoMean
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
%  * dP       --> Array Of Phys.Signal Phases At Times Of Acquisition Of Io
%  * Ci       --> Array Of Starting Indexes Of Physio Signal Cycles
%  * Nt       --> Number Of Time Points (Or Volumes).    Nt == Length(Io)
%  * FITORDER --> Array Of 2 Elements Containing:
%                 - FITORDER(1): Fourier Series Order (or Degree)
%                 - FITORDER(2): The Physio Signal To Be Handled:
%                                + FITORDER(2) == 0 => ECG
%                                + FITORDER(2) == 1 => RESP
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
IoMean  = mean(Io);
Ncycles = length(Ci);
Ic      = zeros(1,Nt);
If      = zeros(1,Nt);

WhichPhysio = FITORDER(2);
FITORDER    = FITORDER(1);


%================== START SIGNAL TIP CYCLIC CORRECTION ====================
% Retrive The 1st Cycle Signal Intensities & Phases
is  = Ci(1);
ie  = Ci(2) - 1;
dPc = dP(is:ie);

% Retrive The 2nd Cycle Signal Intensities & Phases
i1  = Ci(2);
i2  = Ci(3) - 1;

dPc2 = dP(i1:i2);                    % 2nd Cycle Phase Array
IoC  = Io(i1:i2);                    % 2nd Cycle Intensity Array

% Add A Piece of The 2nd Cycle Intensities & Phases into The 1st Cycle
% Start Tip
if (WhichPhysio == 1),               % Case RESP
   
   if dP(1) < 0,         % => 2nd Half The Cycle

      i    = find( (dPc2 < 0) & (dPc2 < dP(1)) );
      Ni   = length(i);

      if Ni > 0,
         Ni = i(Ni);
      else
         i  = find(dPc2 > 0);
         Ni = length(i);
      end
      
      dPc2 = [dPc2(1:Ni), dPc];         % Current Phase Array
      IoC  = [IoC(1:Ni), Io(is:ie)];    % Current Intensity Array
      Ni   = Ni+1;
  
   else                  % dP(1) > 0 => 1st Half The Cycle
      i    = find( (dPc2 > 0) & (dPc2 < dP(1)) );
      Ni   = length(i);
      
      if Ni > 0,
         dPc2 = [dPc2(1:Ni), dPc];         % Current Phase Array
         IoC  = [IoC(1:Ni), Io(is:ie)];    % Current Intensity Array
         Ni   = Ni+1;
      else
         dPc2 = dPc;                       % Current Phase Array
         IoC  = Io(is:ie);                 % Current Intensity Array
         Ni   = 1;
      end
   end
   
else,                                % Case ECG
   
   i  = find( dPc2 < dP(1) );
   Ni = length(i);

   if Ni > 0,
      Ni   = i(Ni);
      dPc2 = [dPc2(1:Ni), dPc];         % Current Phase Array
      IoC  = [IoC(1:Ni), Io(is:ie)];    % Current Intensity Array
      Ni   = Ni+1;
   else
      dPc2 = dPc;          % Current Phase Array
      IoC  = Io(is:ie);    % Current Intensity Array
      Ni   = 1;
   end
end


% Compute The Mean Of The 1st Cycle Tip
Nc = length(dPc2);
IcMean = mean( IoC );

% Mix 1st-2nd Physio Signal Start Tip Intensities Fourier Fitting 
[IfC, COEF] = FourierSeriesDataFit(dPc2, IoC, FITORDER); 
IfC = IfC(Ni:Nc);
IoC = Io(is:ie);

% Compute The Corrected Intensities of The 1st Cycle Tip
Ic(is:ie) = IoC - IfC + IcMean;
  
% Store The Fitted Intensities of The 1st Cycle Tip
If(is:ie) = IfC;


%=================== END SIGNAL TIP CYCLIC CORRECTION =====================
% Retrive The Last Cycle Signal Intensities & Phases
is  = Ci(Ncycles);
ie  = Nt;
dPc = dP(is:ie);

% Retrive The Preview (before the last) Cycle Signal Intensities & Phases
i1   = Ci(Ncycles - 1);
i2   = Ci(Ncycles) - 1;
dPc2 = dP(i1:i2);                % Preview Cycle Phase Array
IoC  = Io(i1:i2);                % Preview Cycle Intensity Array
Nc   = length(dPc2);

% Add A Piece of The Preview Cycle Intensities & Phases At The End Of The 
% Last Cycle Tip If Needed
if (WhichPhysio == 1),               % Case RESP
   
   if dP(Nt) > 0,         % => End At The 1st Half Of The Cycle
      i  = find( (dPc2 > 0) & (dPc2 > dP(Nt)) );
      Ni = length(i);
      
      if Ni > 0,
         Ni = i(1);
      else
         i  = find(dPc2 < 0);
         Ni = i(1); 
      end
      
      dPc2 = [dPc, dPc2(Ni:Nc)];        % Current Phase Array
      IoC  = [Io(is:ie), IoC(Ni:Nc)];   % Current Intensity Array
   else                   % dP(Nt) < 0 => End At The 2nd Half Of The Cycle  
      i  = find( (dPc2 < 0) & (dPc2 > dP(1)) );
      Ni = length(i);
        
      if Ni > 0,
         Ni   = i(1);
         dPc2 = [dPc, dPc2(Ni:Nc)];         % Current Phase Array
         IoC  = [Io(is:ie), IoC(Ni:Nc)];    % Current Intensity Array
      else
         dPc2 = dPc;                        % Current Phase Array
         IoC  = Io(is:ie);                  % Current Intensity Array
      end
   end
   
else                                % Case ECG
   
   i  = find( dPc2 > dP(Nt) );
   Ni = length(i);

   if Ni > 0,
      Ni   = i(1);
      dPc2 = [dPc,      dPc2(Ni:Nc)];       % Current Phase Array
      IoC  = [Io(is:ie), IoC(Ni:Nc)];       % Current Intensity Array
   else
      dPc2 = dPc;                           % Current Phase Array
      IoC  = Io(is:ie);                     % Current Intensity Array
   end
   
end

% Current The Cycle Mean Of Pt Intensities
Ni = ie-is+1;
IcMean = mean( IoC );

% Fourier Fitting In The Current Cycle
[IfC, COEF] = FourierSeriesDataFit(dPc2, IoC, FITORDER); 
IfC = IfC(1:Ni);
IoC = Io(is:ie);

% Compute And Store The Corrected Intensities of The Current Cycle
Ic(is:ie) = IoC - IfC + IcMean;

% Store The Fitted Intensities of The Current Cycle
If(is:ie) = IfC;


%====================== MID SIGNAL CYCLIC FITTING =========================
k = 2;

for i = 2:(Ncycles-1),
   ks = k;
   ke = k;
   is = Ci(i)         - ks;             % Current Start Index Of The Cycle
   ie = (Ci(i+1) - 1) + ke;             % Current End   Index Of The Cycle
   
   if is < 1,
      while is < 1,
         ks = ks-1;
         is = is+1;
      end
   end
   
   if ie > Nt,
      while ie > Nt,
         ke = ke-1;
         ie = ie-1;
      end
   end

   Nc = ie-is+1;                          % Nber Of Cycle Pts
   
   % Retrive The Current Cycle Pt Intensities & Phases
   IoC = Io(is:ie);
   dPc = dP(is:ie);
   
   % Fit In The Current Cycle With The Fourier Method
   [IfC, COEF] = FourierSeriesDataFit(dPc, IoC, FITORDER);
      
   % Current The Cycle Mean Of Pt Intensities   
    IcMean = mean(IoC);  
   
   % Compute And Store The Corrected Intensities of The Current Cycle
   IcC = IoC - IfC + IcMean;
   is = is + ks;
   ie = ie - ke;
   Ic(is:ie) = IcC((ks+1):(Nc-ke));
   IfC       = IfC((ks+1):(Nc-ke));
   
   % Store The Fitted Intensities of The Current Cycle
   If(is:ie) = IfC;
end