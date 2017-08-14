function SI = InterleaveIndexes(Ns, Nt)
%==========================================================================
% INTERLEAVEINDEXES: Finds Indexes Of Record Positions Of All Time Series (  
% TS) Slices Acquired In Interleave Mode. 
%
%
% INPUT:
%     * NS --> Number Of Slices in One TS Volume
%     * NT --> Number Of TS Time Points (Or Volumes) 
%
% OUTPUT:
%     * SI --> Index Sequence In Interleave Mode
% 
%
%---------------------------------------------
% A. ELLA, Univ. Hospital Freiburg, Diag. Radiol, Medical Physics, 2006
% Arsene.Ella@uniklinik-freiburg.de
%==========================================================================





% SliceTrigDiffTime = [0.8, 1.2, 0.4, 0.7, 0.7,|1.3, 1.4, 0.5, 0.2, 1.0,|0.9, 0.6, 1.3, 0.5, 1.1,|0.9, 0.1, 0.9, 1.5, 0.3]
% SliceIndexInTSeri = [  1,   2,   3,   4,   5,|  1,   2,   3,   4,   5,|  1,   2,   3,   4,   5,|  1,   2,   3,   4,   5]
% SliceIndexInTotSl = [  1,   2,   3,   4,   5,|  6,   7,   8,   9,  10,| 11,  12,  13,  14,  15,| 16,  17,  18,  19,  20]
% SlIndInTSerRecord = [  1,   3,   5,   2,   4,|  1,   3,   5,   2,   4,|  1,   3,   5,   2,   4,|  1,   3,   5,   2,   4]
% SliIndTotSlRecord = [  1,   3,   5,   2,   4,|  6,   8,  10,   7,   9,| 11,  13,  15,  12,  14,| 16,  18,  20,  17,  19]
% 
% 
% CS = 2;   % Current slice
% Slice2IndexInTSer = [  .,   2,   .,   .,   .,|  .,   2,   .,   .,   .,|  .,   2,   .,   .,   .,|  .,   2,   .,   .,   .]
% Slice2IndeInTotSl = [  .,   2,   .,   .,   .,|  .,   7,   .,   .,   .,|  .,  12,   .,   .,   .,|  .,  17,   .,   .,   .]
% SlIndInTSerRecord = [  .,   3,   .,   .,   .,|  .,   3,   .,   .,   .,|  .,   .,   .,   .,   .,|  .,   3,   .,   .,   .]
% Sl2IndTotSlRecord = [  .,   3,   .,   .,   .,|  .,   8,   .,   .,   .,|  .,  13,   .,   .,   .,|  .,  18,   .,   .,   .]
% Slic2TrigDiffTime = [  .,   ., 0.4,   .,   .,|  .,   ., 0.5,   .,   .,|  .,   ., 1.3,   .,   .,|  .,   ., 0.9,   .,   .]


% Initialize The Slice Record Index Parameters
TNs = Ns*Nt;              % Total Number Of Slices  (In The Whole TS)  
HS  = ceil(Ns/2);         % Half Number Of Slices (+1 if ODD)
HSf = floor(Ns/2);        % Half Number Of Slices    
OD  = HS - HSf;           % OD = 1 if Ns is ODD, else:  OD = 0
SI  = zeros(1, TNs);      % Initialize

% Compute The Interleave Index Sequence
if OD == 0,
   for i = 1:HS,
      ks = 2*i;    ke = ks-1;
      
      for j = 0:(Nt-1),
          t = Ns*j;        
          SI(ks+t) = i+t;
          SI(ke+t) = HS+i+t;
      end,
   end,
else,
   for i = 1:HS,
      ke = 2*i;    ks = ke-1;
      
      for j = 0:(Nt-1),
          t = Ns*j;        
          SI(ks+t) = i+t;
          
          if i<HS,
             SI(ke+t) = HS+i+t;
          end,
      end,
   end,
end,
