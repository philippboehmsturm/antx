function tbx_Icc = tbx_cfg_tbx_Icc
% Russ Poldrack and Volkmar Glauche
% $Id: tbx_cfg_tbx_Icc.m,v 1.1 2008-04-14 08:53:10 vglauche Exp $
 
%_______________________________________________________________________
 
rev='$Revision: 1.1 $';

addpath(fullfile(spm('dir'),'toolbox','icc'));

% see how we are called - if no output argument, then start spm_jobman UI

if nargout == 0
        spm_jobman('interactive');
        return;
end;

% MATLABBATCH Configuration file for toolbox 'Icc Calculation'
% This code has been automatically generated.
% ---------------------------------------------------------------------
% srcimgs Source Images
% ---------------------------------------------------------------------
srcimgs         = cfg_files;
srcimgs.tag     = 'srcimgs';
srcimgs.name    = 'Source Images';
srcimgs.help    = {'Enter all images from the same observation. Subject ordering must be consistent over all observations.'};
srcimgs.filter = 'image';
srcimgs.ufilter = '.*';
srcimgs.num     = [1 Inf];
% ---------------------------------------------------------------------
% obs Observations
% ---------------------------------------------------------------------
obs         = cfg_repeat;
obs.tag     = 'obs';
obs.name    = 'Observations';
obs.help    = {'Enter images from at least two observations for the same sample of subjects.'};
obs.values  = {srcimgs };
obs.num     = [2 Inf];
obs.check   = @check_obs;
% ---------------------------------------------------------------------
% tbx_Icc Icc Calculation
% ---------------------------------------------------------------------
tbx_Icc         = cfg_exbranch;
tbx_Icc.tag     = 'tbx_Icc';
tbx_Icc.name    = 'Icc Calculation';
tbx_Icc.val     = {obs };
tbx_Icc.help    = {''};
tbx_Icc.prog = @comp_icc;
tbx_Icc.vout = @vout_icc;
% ---------------------------------------------------------------------
% local functions
% ---------------------------------------------------------------------
function out = comp_icc(job)

nobs = numel(job.srcimgs);
nsub = numel(job.srcimgs{1});

V = spm_vol(job.srcimgs);
spm_check_orientations(cat(1,subsref(cat(1,V{:}),...
				     struct('type','{}','subs',{{':'}}))));

iccm = zeros(V{1}{1}.dim(1:3));

spm_progress_bar('init', V{1}{1}.dim(3), 'Icc computation', 'Planes completed');
for z=1:V{1}{1}.dim(3)
    M = spm_matrix([0 0 z 0 0 0 1 1 1]);
    dat = zeros([nsub,nobs,V{1}{1}.dim(1:2)]);
    for cs = 1:nsub
	for co = 1:nobs
	    dat(cs,co,:,:) = spm_slice_vol(V{co}{cs},M,V{1}{1}.dim(1:2),[0,NaN]);
	end;
    end;
    for x = 1:V{1}{1}.dim(1)
	for y = 1:V{1}{1}.dim(2)
	    iccm(x,y,z)=icc(dat(:,:,x,y));
	end
    end
    spm_progress_bar('Set',z);
end
iccm(isnan(iccm)) = 0;

Vo = rmfield(V{1}{1},'private');
[p n e v] = spm_fileparts(Vo.fname);
Vo.fname = fullfile(p,['icc_' n e]);

spm_write_vol(Vo,iccm);
spm_progress_bar('clear');
out.iccfile = {Vo.fname};
return

function dep = vout_icc(job)
dep = cfg_dep;
dep.sname = 'ICC volume';
dep.src_output = substruct('.','iccfile');
dep.tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
return;

function cstr = check_obs(srcimgs)
cstr = '';
nobs = numel(srcimgs);
nsub1 = numel(srcimgs{1});
for k = 1:nobs
    if numel(srcimgs{k}) ~= nsub1
        cstr = sprintf(['Number of subjects in observation 1 and %d differ ' ...
                        '(%d/%d)'], k, nsub1, numel(srcimgs{k}));
        return;
    end;
end;
V = spm_vol(srcimgs);
try
    spm_check_orientations(cat(1,subsref(cat(1,V{:}),...
                                         struct('type','{}','subs',{{':'}}))));
catch
    cstr = 'Images do not all have same orientation or voxel size.';
end;