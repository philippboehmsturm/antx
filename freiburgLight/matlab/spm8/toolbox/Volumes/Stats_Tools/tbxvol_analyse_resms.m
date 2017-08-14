function varargout = tbxvol_analyse_resms(bch)
% Analyse Goodness of Fit of SPM.mat
% FORMAT tbxvol_analyse_resms(bch)
% ======
% Input arguments:
% bch.srcspm - file name of SPM.mat
% bch.maskimg - optional brain mask image
%
% This function is part of the volumes toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Volumes
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: tbxvol_analyse_resms.m 149 2006-11-09 15:01:15Z glauche $

% ToDo:
% k-means clustering of ResMS image (which one is better: whole image or
% separately for in-brain/out-brain?) instead of using global mean as marker
% bwlabeling of spatially connected clusters
% extract from really raw data (using inv_sn.mat and specified raw images)

rev = '$Revision: 149 $';
funcname = 'Compute laterality index';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

load(bch.srcspm{1});
% cd into SPM analysis dir, save old pwd
opwd = pwd;
cd(SPM.swd);

if ~isempty(bch.maskimg{1})
    VM = spm_vol(bch.maskimg{1});
    VResMS = SPM.VResMS;
    [p n e v] = spm_fileparts(VResMS.fname);
    VResMS.fname = fullfile(p, [n '_masked' e]);
    VResMS = spm_imcalc([SPM.VResMS, VM],VResMS,'i1.*i2');
else
    VResMS = SPM.VResMS;
    VM = SPM.VM;
end;
% get mean for thresholding ResMS.img
res.g = spm_global(VResMS);

% create mask for ResMS above/below res.g
VResMSa = VResMS;
[p n e v] = spm_fileparts(VResMSa.fname);
VResMSa.fname = fullfile(p, [n '_a' e]);
VResMSa = spm_imcalc(VResMS,VResMSa,sprintf('i1>%d', res.g+bch.dist*res.g));
VResMSb = VResMS;
[p n e v] = spm_fileparts(VResMSb.fname);
VResMSb.fname = fullfile(p, [n '_b' e]);
VResMSb = spm_imcalc(VResMS,VResMSb,sprintf('i1<%d', res.g-bch.dist*res.g));
% create mask for brain externals
VMext = VM;
[p n e v] = spm_fileparts(VMext.fname);
VMext.fname = fullfile(p, [n '_ext' e]);
VMext = spm_imcalc(VM, VMext, '~i1');

% batch for tbxvol_extract
tbxbch.interp = 0;
tbxbch.avg = 'vox';
tbxbch.src.srcspm = bch.srcspm;
tbxbch.roispec{1}.srcimg{1} = VResMSa.fname;
tbxbch.roispec{2}.srcimg{1} = VResMSb.fname;
tbxbch.roispec{3}.srcimg{1} = VMext.fname;
res.ext = tbxvol_extract(tbxbch);

if bch.graphics
    ylabels = {sprintf('ResMS > %d', res.g+bch.dist*res.g), ...
               sprintf('ResMS < %d', res.g-bch.dist*res.g), ...
               'Outside brain'};
    f = figure;
    for k=1:3
        ax(k)=subplot(3,1,k);
        plot(res.ext(k).raw.mean);
        hold on;
        plot(res.ext(k).raw.mean+res.ext(k).raw.std/2,'r');
        plot(res.ext(k).raw.mean-res.ext(k).raw.std/2,'r');
        ylabel(ylabels{k});
    end;
    title(sprintf('Signal averaged over region - %s',bch.srcspm{1}));
    xlabel('Scan or Time');
end;
if nargout > 0
  varargout{1}=res;
else
  assignin('base','ext',res);
  fprintf('extracted data saved to workspace variable ''ext''\n');
  disp(res);
end;
cd(opwd);