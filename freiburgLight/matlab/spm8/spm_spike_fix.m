function [Mean_result, Std_result] = spm_spike_fix(correct);
% function [Mean_result, Std_result] = spm_spike_fix(correct);
% If correct = 1 whole volumes will be corrected
% If correct = 0 the routine reports suspicious slices only 
% Report 0th and 1st order moments of scans (slice by slice)
% Uses raw data and finited differenced data.
% comes up with spm_get
% works only for transaxially oriented scans
% Christian Buechel and Oliver Josephs


if nargin < 1
 correct = 0;
end 


SPMid = spm('FnBanner',mfilename,'2.7');
[Finter,Fgraph,CmdLine] = spm('FnUIsetup','spm spike');
spm_help('!ContextHelp',mfilename);

Fgraph = spm_figure('FindWin','Graphics');

str      = sprintf('select scans');
P        = spm_get(Inf,'.img',str);


thr      = spm_input('threshold in sd',1);

q      = size(P,1);

% map image files into memory
Vin 	= spm_vol(P);
nimgo	= size(P,1);
nslices	= Vin(1).dim(3);


Mean_result = zeros(Vin(1).dim(3),q);
Min_result =  zeros(Vin(1).dim(3),q);
Max_result =  zeros(Vin(1).dim(3),q);
Std_result =  zeros(Vin(1).dim(3),q);


spm_progress_bar('Init',100,'Spike',' ');


sx = round(Vin(1).dim(1)/4);
ex = sx + round(Vin(1).dim(1)/2);


for k = 1:nslices,
	% Read in slice data
	B  = spm_matrix([0 0 k]);
        for m=1:nimgo,
	 d = spm_slice_vol(Vin(m),B,Vin(1).dim(1:2),1);
	 d = d(sx:ex,:);
	 %if k>10
	 % keyboard;
	 %end
	 Mean_result(k,m) = mean(mean(d));
	 Std_result(k,m)  = std(std(d));
	end;
spm_progress_bar('Set',k*100/nslices);
end;

spm_progress_bar('Clear');




%Normalize to mean = 0, std = 1
%---------------------
SLmean = mean(Mean_result');
SLstd  = std(Mean_result');

Nmean = meancor(Mean_result');
Nstd  = (ones(size(Nmean,1),1).*thr)*SLstd;

Mask_mean = ones(size(Nmean));

Mask_mean(find(Nmean<Nstd & Nmean>-Nstd)) = 0;



%display results
%--------------------------------------

%sqrt of mean corrected data
%----
figure(Fgraph); spm_clf; 
colormap hot;
subplot(4,1,1);
imagesc(sqrt(abs(Nmean')));
colorbar;
xlabel('scan');
ylabel('slice');
title('Sqrt of abs(Mean)');


%Std
%---
subplot(4,1,2);
plot(Nmean);
xlim([1 size(Nmean,1)]);
colorbar;
xlabel('scan');
title('Mean');

%Mask
%----
colormap hot;
subplot(4,1,3);
imagesc(Mask_mean')
colorbar;
xlabel('scan');
ylabel('slice');
title('above threshold');

%Mask
%----
subplot(4,1,4);
bar(sum(Mask_mean'))
xlim([1 size(Nmean,1)]);
colorbar;
xlabel('scan');
ylabel('# of slices');
title('above threshold');

badrow        = 5;
broken_slices = 2; 
fprintf('Suspicious scans and slices (threshold = %1.1f, more than %1.1f slices affected): \n\n',thr,broken_slices); 

[pa,na,ex] = fileparts(P(1,:));

if correct 
 res = mkdir(pa,'spike_cor');
 if res == 0
  error('Cannot create directory for moved files');
 end
end


affected = find(sum(Mask_mean') > broken_slices);



for j = affected;
 fprintf(['\nScan: %1.0f [' P(j,:) ']' '\nSlices: '], j); 
 [pa,na,ex] = fileparts(P(j,:)); 
 if correct
  % save original file 
  copyfile([pa filesep na '.img'],[pa filesep 'spike_cor']);
  copyfile([pa filesep na '.hdr'],[pa filesep 'spike_cor']);
  copyfile([pa filesep na '.mat'],[pa filesep 'spike_cor']);
  dist = -1;
  success = 0;
  while abs(dist) < badrow
   % go back first
   repl = j+dist;
   if (repl > 0) & (repl <= nimgo) & (~ismember(repl,affected))
    success = 1;
    break;
   else
    if dist < 0 
     dist = dist * (-1);
    else 
     dist = (dist + 1) * (-1);
    end 
   end 
  end 
  if ~success
   error(fprintf('More than %1.0f faulty scans in a row\n',badrow));
  else
   [rpa,rna,rex] = fileparts(P(repl,:));
   fprintf(['Correcting ' na '.img with ' rna '.img\n']);  
   copyfile([pa filesep rna '.img'],[pa filesep na '.img']);
   copyfile([pa filesep rna '.hdr'],[pa filesep na '.hdr']);
   copyfile([pa filesep rna '.mat'],[pa filesep na '.mat']);
  end 
 end 
 for i = 1:nslices
  if Mask_mean(j,i)
   fprintf(['%1.0f '],i);
  end
 end
end
 

fprintf('\n');


function Y = meancor(X);
% function Y = meancor(X);
% if columns of zeros untouched

Y = X - ones(size(X,1),1)*mean(X); %zero mean

