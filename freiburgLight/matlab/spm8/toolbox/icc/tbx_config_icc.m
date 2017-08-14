function opts = spm_config_Icc
%_______________________________________________________________________
% Copyright (C) 2005 Wellcome Department of Imaging Neuroscience

% Russ Poldrack and Volkmar Glauche
% $Id: tbx_config_icc.m,v 1.2 2007-03-30 07:58:52 glauche Exp $

 
%_______________________________________________________________________
 
rev='$Revision: 1.2 $';

addpath(fullfile(spm('dir'),'toolbox','icc'));

% see how we are called - if no output argument, then start spm_jobman UI

if nargout == 0
        spm_jobman('interactive','','jobs.tools.tbx_Icc');
        return;
end;


srcimgs.type = 'files';
srcimgs.name = 'Source Images';
srcimgs.tag  = 'srcimgs';
srcimgs.filter = 'image';
srcimgs.num  = [1 Inf];
srcimgs.help = {['Enter all images from the same observation. Subject' ...
		 ' ordering must be consistent over all observations.']};
		
obs.type = 'repeat';
obs.name = 'Observations';
obs.tag  = 'obs';
obs.num  = [2 Inf];
obs.values = {srcimgs};
obs.help = {['Enter images from at least two observations for the same sample' ...
	     ' of subjects.']};



opts.type = 'branch';
opts.name = 'Icc Calculation';
opts.tag  = 'tbx_Icc';
opts.val  = {obs};
opts.prog = @comp_icc;
%opts.vfiles = @vfiles;
return;

function comp_icc(job)

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
return

function vf = vfiles(job)
[p n e v] = spm_fileparts(job.srcimgs{1}{1});
vf{1} = fullfile(p,['icc_' n e]);
return;

