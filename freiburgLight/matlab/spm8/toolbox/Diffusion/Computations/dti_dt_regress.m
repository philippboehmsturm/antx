function varargout=dti_dt_regress(bch)
% Tensor(regression)
% 
% Compute diffusion tensor components from at least 6 diffusion weighted 
% images + 1 b0 image. Gradient directions and strength are read from the 
% corresponding .mat files. The resulting B matrix is then given to 
% spm_spm as design matrix for a multiple regression analysis.
%
% If there are repeated measurements or one measurement, but different b 
% value levels, then options for non-sphericity correction will be 
% offered. The rationale behind this is the different amount of error 
% variance contained in images with different diffusion weighting. 
% If you want to take advantage of non-spericity correction, you should 
% use an explicit mask to exclude any non-brain voxels from analysis, 
% because the high noise level in non-brain-areas of diffusion weighted 
% images will render the estimation of variance components invalid.
%
% If there are more than 6 diffusion weighting directions in the data 
% set, tensors of higher order can be estimated. This allows to model 
% diffusivity  profiles in voxels with e.g. fibre crossings more 
% accurately than with order-2 tensors.
%
% Output images are saved as D*_basename.img, where basename is derived 
% from the original filenames. Directionality components are encoded by 
% 'x', 'y', 'z' letters in the filename.
%
%/* The algorithm used to determine the design matrix for SPM stats in this */ 
%/* routine is based on \cite{basser94}  and is developed for the general */ 
%/* order-n tensors in \cite{Orszalan2003}, although the direction scheme */ 
%/* actually used depends on the applied diffusion imaging sequence. */
%
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id$

rev = '$Revision$';
funcname = 'Tensor regression';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
spm_input('!DeleteInputObj');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

% save working directory
cwd=pwd;
cd(bch.swd{1});

% get beta filename stub
[p betafname e] = spm_fileparts(bch.srcimgs{1});

% get B and G, compute design matrix
if isfield(bch.errorvar,'errauto')
        % ltol, dtol and sep can be set using the GUI and need to
        % be present in extbch
        extbch = bch.errorvar.errauto;
else
        % only need allb & allg, no differentiation necessary
        extbch.ltol = 10000;
        extbch.dtol = 0;
        extbch.sep  = 0;
end;
extbch.srcimgs=bch.srcimgs;
extbch.ref.refscanner=1;
extbch.saveinf=0;
extres=dti_extract_dirs(extbch);

tmp = sqrt(sum(extres.allg.*extres.allg,2)); % get length of G vectors
if (abs(max(tmp)-1)>1e-3)||(abs(min(tmp(tmp~=0))-1)>1e-3)
        warning('spm_tbx_Diffusion:dti_dt_regress_ScaleGradients',...
                'Scaling non-unit-length gradient vectors and adjusting b values');
        % make G vectors unit length
        extres.allg(tmp ~= 0,:) = ...
            extres.allg(tmp ~= 0,:)./(tmp(tmp ~= 0)*ones(1,3)); 
        extres.allb = extres.allb.*tmp.^2;
end;

% compute design matrix structure for tensors of arbitrary order
[Hind mult] = dti_dt_order(bch.dtorder);
dirs = 'xyz';
Cfiles = cell(1,(bch.dtorder+1)*(bch.dtorder+2)/2);
mcov = struct('c',[],'cname','','iCC',num2cell(5*ones(1,(bch.dtorder+1)*(bch.dtorder+2)/2)));
for j=1:(bch.dtorder+1)*(bch.dtorder+2)/2
        Cfiles{j}=sprintf('D%s_%s.img',dirs(Hind(:,j)),betafname);
        mcov(j).c = (-extres.allb*mult(j)).*prod(extres.allg(:,Hind(:,j)),2);
        mcov(j).cname = sprintf('D_{%s}', dirs(Hind(:,j)));
        mcov(j).iCC = 5;
end;

% mean regressor included by spm_config_factorial design.m
Hfiles{1} = sprintf('lnA0_%s.img', betafname);

fprintf('Creating error covariance specification\n');
if isfield(bch.errorvar,'errspec')
    % create implicit replications factor and one explicit factor
    cSPM.xVi.I = zeros(bch.errorvar.errspec.nrep*bch.errorvar.errspec.ndw,2);
    switch(bch.errorvar.errspec.inorder)
        case 'repl',
            for k=1:bch.errorvar.errspec.nrep
                for l=1:bch.errorvar.errspec.ndw
                    cSPM.xVi.I((k-1)*bch.errorvar.errspec.ndw+l,1) = k;
                    cSPM.xVi.I((k-1)*bch.errorvar.errspec.ndw+l,2) = l;
                end;
            end;
        case 'bval',  % b values first
            for k=1:bch.errorvar.errspec.ndw
                for l=1:bch.errorvar.errspec.nrep
                    cSPM.xVi.I((k-1)*bch.errorvar.errspec.nrep+l,1) = l;
                    cSPM.xVi.I((k-1)*bch.errorvar.errspec.nrep+l,2) = k;
                end;
            end,
    end;
    % set unequal variance for explicit factor
    cSPM.factor(1).variance = 1;
    cSPM.factor(1).dept     = 0;
    cSPM = spm_get_vc(cSPM);
    xVi  = cSPM.xVi;
elseif isfield(bch.errorvar,'errauto') 
    if max(extres.ubj) > 1
        nb = max(extres.ubj);
        spm_progress_bar('init', nb,...
            'Create Covariance Components', ...
            'b values');
    else
        nb = 0;
    end;
    for k = 1:nb
        ind = find(extres.ubj==k);
        xVi.Vi{k}=sparse(ind, ind, ones(size(ind)),...
            numel(extres.ubj), numel(extres.ubj));
        spm_progress_bar('set',k);
    end;
    spm_progress_bar('clear');
    if max(extres.ugj) > 1
        ng = max(extres.ugj);
        spm_progress_bar('init', ng,...
            'Create Covariance Components', ...
            'gradient directions');
    else
        ng = 0;
    end;
    for k = 1:ng
        ind = find(extres.ugj==k);
        xVi.Vi{nb+k}=sparse(ind, ind, ones(size(ind)),...
            numel(extres.ugj),numel(extres.ugj));
        spm_progress_bar('set',k);
    end;
    spm_progress_bar('clear');
    if nb > 0 && ng > 0
        sel = ones(1,numel(xVi.Vi));
        spm_progress_bar('init', numel(xVi.Vi),...
            'Remove duplicate Covariance Components');
        for k = 1:numel(xVi.Vi)
            for j=1:k-1
                if xVi.Vi{j}==xVi.Vi{k}
                    sel(j) = 0;
                end;
            end;
            spm_progress_bar('set',k);
        end;
        spm_progress_bar('clear');
        xVi.Vi=xVi.Vi(logical(sel));
    end;
end;

% -cfgbch 
%  \-cfgbch{1}
%    \-stats 
%      \-stats{1}
%        \-factorial_design
%          |-des
%          | \-mreg
%          |   |-scans ............. 1-x-11 char
%          |   \-mcov 
%          |     \-mcov(1)
%          |       |-c ................. 4-x-1 double
%          |       \-cname ............. 1-x-4 char
%          |-masking
%          | |-tm
%          | | \-tm_none ........... []
%          | |-im ................ 1-x-1 double
%          | \-em 
%          |   \-em{1} ............. []
%          |-globalc
%          | \-g_omit ............ []
%          |-globalm
%          | |-gmsca
%          | | \-gmsca_no .......... []
%          | \-glonorm ........... 1-x-1 double
%          \-dir 
%            \-dir{1} ............ 1-x-29 char
if strcmp(bch.srcscaling, 'raw')
    lnbch.files = bch.srcimgs;
    lnbch.minS = 1;
    lnres=dti_ln(lnbch);
    cfgbch{1}.spm.stats.factorial_design.des.mreg.scans = lnres.ln;
elseif strcmp(bch.srcscaling, 'log')
    cfgbch{1}.spm.stats.factorial_design.des.mreg.scans = bch.srcimgs;
end
cfgbch{1}.spm.stats.factorial_design.des.mreg.mcov = mcov;
cfgbch{1}.spm.stats.factorial_design.cov = struct([]);
cfgbch{1}.spm.stats.factorial_design.masking.tm.tm_none = [];
cfgbch{1}.spm.stats.factorial_design.masking.im = 1;
cfgbch{1}.spm.stats.factorial_design.masking.em = bch.maskimg;
cfgbch{1}.spm.stats.factorial_design.globalc.g_omit = [];
cfgbch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = [];
cfgbch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
cfgbch{1}.spm.stats.factorial_design.dir = bch.swd;

spm_jobman('run',cfgbch);

% reset non-sphericity options before estimation

% estimate design
% -jobs 
%  \-jobs{1}
%    \-stats 
%      \-stats{1}
%        \-fmri_est
%          |-spmmat ............ 1-x-11 char
%          \-method
%            \-Classical ......... 1-x-1 double
estbch{1}.spm.stats.fmri_est.spmmat = {fullfile(bch.swd{1}, 'SPM.mat')};
estbch{1}.spm.stats.fmri_est.method.Classical = 1;

if exist('xVi','var')
        load(estbch{1}.spm.stats.fmri_est.spmmat{1});
        SPM.xVi = xVi;
        save(estbch{1}.spm.stats.fmri_est.spmmat{1},'SPM');
end;

if ~bch.spatsm
        load(estbch{1}.spm.stats.fmri_est.spmmat{1});
        SPM.xVol.FWHM = [];
        SPM.xVol.VRpv = [];
        SPM.xVol.R    = [];
        save(estbch{1}.spm.stats.fmri_est.spmmat{1},'SPM');
end;  

spm_jobman('run',estbch);
load(estbch{1}.spm.stats.fmri_est.spmmat{1});
% rename betas
betafnames = [ Hfiles(:)' Cfiles(:)'];
betaind    = [false(size(Hfiles(:)')) true(size(Cfiles(:)'))];
% sort files according to SPM partition indices
% in SPM8 prior r4111, constant is in iB, starting r4111 in iH. 
% Either iB or iH is empty in any case.
betasort   = [SPM.xX.iH SPM.xX.iB SPM.xX.iC];
betafnames = betafnames(betasort);
betaind    = betaind(betasort);
res.dt = {};
res.ln = {};
for k = 1:numel(betafnames);
    [np nf ne nv]=spm_fileparts(betafnames{k});
    [op of oe ov]=spm_fileparts(SPM.Vbeta(k).fname);
    if strcmp(oe(1:4),'.img')
        movefile(fullfile(op, [of '.hdr' ov]),...
                 fullfile(np, [nf '.hdr' nv]));
        movefile(fullfile(op, [of '.img' ov]),...
                 fullfile(np, [nf '.img' nv]));
        SPM.Vbeta(k).fname = fullfile(np, [nf '.img' ov]);
    else
        movefile(SPM.Vbeta(k).fname, betafnames{k});
        SPM.Vbeta(k).fname = betafnames{k};
    end;
    if betaind(k)
        res.dt{end+1} = fullfile(SPM.swd,SPM.Vbeta(k).fname);
    else
        res.ln{end+1} = fullfile(SPM.swd,SPM.Vbeta(k).fname);
    end;
end;
res.spmmat = estbch{1}.spm.stats.fmri_est.spmmat;
%-Save SPM.mat and set output argument
%-------------------------------------------------------------------
fprintf('%-40s: ','Saving SPM configuration')                    %-#

if spm_matlab_version_chk('7.1')>=0,
    save('SPM', 'SPM', '-V6');
else
    save('SPM', 'SPM');
end;
fprintf('%30s\n','...SPM.mat saved')                             %-#

if nargout > 0
    varargout{1} = res;
end;

% Set reference coordinate system for tensor images
ud = dti_get_dtidata(bch.srcimgs{1});
ud.b = NaN;
ud.g = [NaN NaN NaN];
for k = 1:numel(res.dt)
    dti_get_dtidata(res.dt{k}, ud);
end

% cleanup

if strcmp(bch.srcscaling, 'raw')
    for k = 1:numel(lnres.ln)
        [p n e]=spm_fileparts(lnres.ln{k});
        spm_unlink(fullfile(p,[n e]));
        if strcmp(e(1:4),'.img')
            spm_unlink(fullfile(p,[n '.hdr']));
        end
    end;
end
cd(cwd); % restore wd
