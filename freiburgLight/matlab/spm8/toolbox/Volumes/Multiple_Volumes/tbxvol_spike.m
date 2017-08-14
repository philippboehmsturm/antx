function tbxvol_spike(bch)
% Detect slices with abnormal intensities or standard deviations
% FORMAT tbxvol_spike(bch)
% ======
% For each volume, normalised mean signal and standard deviation are computed per 
% slice. These values are then compared to their mean over all volumes, 
% and slices that deviate from these means by more than a given threshold 
% are reported a suspicious.
% This function is part of the volumes toolbox for SPM. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Volumes
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: tbxvol_spike.m 714 2010-07-30 14:28:55Z glauche $

rev = '$Revision: 714 $';
funcname = 'Spike detection';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
Fgraph=spm_figure('GetWin','Graphics');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

spm('pointer','watch');

% map image files into memory
Vin 	= spm_vol(char(bch.srcimgs));
nimg	= numel(bch.srcimgs);

Mean_result = zeros(Vin(1).dim(3),nimg);
Std_result =  zeros(Vin(1).dim(3),nimg);

spm_progress_bar('Init',nimg,'Images',' ');

for m=1:nimg,
    d = spm_read_vols(Vin(m));
    Mean_result(:,m) = squeeze(mean(mean(d)));
    Std_result(:,m)  = squeeze(std(std(d)));
    spm_progress_bar('Set',m);
end;

spm_progress_bar('Clear');

%Normalize to mean = 0, std = 1
%---------------------
Nmean = normit(Mean_result');
Nstd  = normit(Std_result');

MNmean = repmat(mean(Nmean),nimg,1);
MNstd  = repmat(mean(Nstd),nimg,1);

Gt_MNmean = abs(Nmean-MNmean) > bch.spikethr; 
Gt_MNstd  = abs(Nstd-MNstd) > bch.spikethr;

GtMask_MNmean = zeros(size(Nmean));
GtMask_MNstd  = zeros(size(Nstd));

GtMask_MNmean(Gt_MNmean) = 1;
GtMask_MNstd(Gt_MNstd)   = 1;

%display results
%--------------------------------------

%Mean
%----
figure(Fgraph); spm_clf; 
colormap hot;
subplot(4,1,1);
imagesc(Nmean');
caxis([-bch.spikethr bch.spikethr]);
colorbar;
xlabel('scan');
ylabel('slice');
title('Mean');


%Std
%---
subplot(4,1,2);
imagesc(Nstd');
caxis([-bch.spikethr bch.spikethr]);
colorbar;
xlabel('scan');
ylabel('slice');
title('Std');

%Nmean-MNmean
%----
subplot(4,1,3);
imagesc(Nmean'-MNmean');
caxis([-bch.spikethr bch.spikethr]);
colorbar;
xlabel('scan');
ylabel('slice');
title('Mean-Mean(Mean) per slice');


%NStd-MNstd
%---
subplot(4,1,4);
imagesc(Nstd'-MNstd');
caxis([-bch.spikethr bch.spikethr]);
colorbar;
xlabel('scan');
ylabel('slice');
title('Std-Mean(Std) per slice');

cs = 0;
spikes = struct('fnames',{{}}, 'slices',{[]});
for j = 1:nimg
    if any(GtMask_MNmean(j,:)) || any(GtMask_MNstd(j,:))
        cs = cs+1;
        spikes.fnames{cs} = bch.srcimgs{j};
        spikes.slices{cs} = find(GtMask_MNmean(j,:) | GtMask_MNstd(j,:));
    end
end
disp('Information about suspicious scans and slices has been saved to workspace variable ''spikes'':');
disp(spikes);
assignin('base','spikes',spikes);
spm('pointer','arrow');

function ret = normit(in)
szin = size(in);
meanin = in - repmat(mean(in,2),1,szin(2));
ret = meanin./repmat(std(meanin,[],2),1,szin(2));