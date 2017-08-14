function tbxvol_normalise(varargin)
job    = varargin{1};
eflags = job.eoptions.iteration;

for i=1:numel(job.subj.source),
	[pth,nam,ext,ind] = spm_fileparts(char(job.subj.source{i}));
	matname{i} = fullfile(pth,[nam '_gr_sn.mat']);
end;
if isfield(job.eoptions.starting,'stempl')
    VG = char(job.eoptions.starting.stempl.template{:});
    VWG = char(job.eoptions.starting.stempl.weight{:});
    sparams = '';
else
    VG = '';
    VWG = '';
    sparams = job.eoptions.starting.sparams;
end;
vg_normalise(VG,...
	     char(job.subj.source{:}), matname,...
	     VWG, char(job.subj.wtsrc{:}), ...
	     eflags, sparams);
return;



function params = vg_normalise(VG,VF,matname,VWG,VWF,flags,starting)
% Spatial (stereotactic) normalization
%
% FORMAT params = spm_normalise(VG,VF,matname,VWG,VWF,flags)
% VG        - template handle(s)
% VF        - handle of image to estimate params from
% matname   - name of file to store deformation definitions
% VWG       - template weighting image
% VWF       - source weighting image
% flags     - flags.  If any field is not passed, then defaults are assumed.
%             smosrc - smoothing of source image (FWHM of Gaussian in mm).
%                      Defaults to 8.
%             smoref - smoothing of template image (defaults to 0).
%             regtype - regularisation type for affine registration
%                       See spm_affreg.m (default = 'mni').
%             cutoff  - Cutoff of the DCT bases.  Lower values mean more
%                       basis functions are used (default = 30mm).
%             nits    - number of nonlinear iterations (default=16).
%             reg     - amount of regularisation (default=0.1)
% starting  - (optional) list of parameters for initial normalisation
%             step - e.g. obtained from segmentation - one file per VF image
% ___________________________________________________________________________
% 
% This module spatially (stereotactically) normalizes MRI, PET or SPECT
% images into a standard space defined by some ideal model or template
% image[s].  The template images supplied with SPM conform to the space
% defined by the ICBM, NIH P-20 project, and approximate that of the
% the space described in the atlas of Talairach and Tournoux (1988).
% The transformation can also be applied to any other image that has
% been coregistered with these scans.
%
% 
% Mechanism
% Generally, the algorithms work by minimising the sum of squares
% difference between the image which is to be normalised, and a linear
% combination of one or more template images.  For the least squares
% registration to produce an unbiased estimate of the spatial
% transformation, the image contrast in the templates (or linear
% combination of templates) should be similar to that of the image from
% which the spatial normalization is derived.  The registration simply
% searches for an optimum solution.  If the starting estimates are not
% good, then the optimum it finds may not find the global optimum.
% 
% The first step of the normalization is to determine the optimum
% 12-parameter affine transformation.  Initially, the registration is
% performed by matching the whole of the head (including the scalp) to
% the template.  Following this, the registration proceeded by only
% matching the brains together, by appropriate weighting of the template
% voxels.  This is a completely automated procedure (that does not
% require ``scalp editing'') that discounts the confounding effects of
% skull and scalp differences.   A Bayesian framework is used, such that
% the registration searches for the solution that maximizes the a
% posteriori probability of it being correct.  i.e., it maximizes the
% product of the likelihood function (derived from the residual squared
% difference) and the prior function (which is based on the probability
% of obtaining a particular set of zooms and shears).
% 
% The affine registration is followed by estimating nonlinear deformations,
% whereby the deformations are defined by a linear combination of three
% dimensional discrete cosine transform (DCT) basis functions.
% The parameters represent coefficients of the deformations in
% three orthogonal directions.  The matching involved simultaneously
% minimizing the bending energies of the deformation fields and the
% residual squared difference between the images and template(s).
% 
% An option is provided for allowing weighting images (consisting of pixel
% values between the range of zero to one) to be used for registering
% abnormal or lesioned brains.  These images should match the dimensions
% of the image from which the parameters are estimated, and should contain
% zeros corresponding to regions of abnormal tissue.
% 
% 
% Uses
% Primarily for stereotactic normalization to facilitate inter-subject
% averaging and precise characterization of functional anatomy.  It is
% not necessary to spatially normalise the data (this is only a
% pre-requisite  for  intersubject averaging or reporting in the
% Talairach space).
% 
% Inputs
% The first input is the image which is to be normalised. This image
% should be of the same modality (and MRI sequence etc) as the template
% which is specified. The same spatial transformation can then be
% applied to any other images of the same subject.  These files should
% conform to the SPM data format (See 'Data Format'). Many subjects can
% be entered at once, and there is no restriction on image dimensions
% or voxel size.
% 
% Providing that the images have a correct ".mat" file associated with
% them, which describes the spatial relationship between them, it is
% possible to spatially normalise the images without having first
% resliced them all into the same space. The ".mat" files are generated
% by "spm_realign" or "spm_coregister".
% 
% Default values of parameters pertaining to the extent and sampling of
% the standard space can be changed, including the model or template
% image[s].
% 
% 
% Outputs
% All normalized *.img scans are written to the same subdirectory as
% the original *.img, prefixed with a 'n' (i.e. n*.img).  The details
% of the transformations are displayed in the results window, and the
% parameters are saved in the "*_sn.mat" file.
% 
% 
%____________________________________________________________________________
% Refs:
% K.J. Friston, J. Ashburner, C.D. Frith, J.-B. Poline,
% J.D. Heather, and R.S.J. Frackowiak
% Spatial Registration and Normalization of Images.
% Human Brain Mapping 2:165-189(1995)
% 
% J. Ashburner, P. Neelin, D.L. Collins, A.C. Evans and K. J. Friston
% Incorporating Prior Knowledge into Image Registration.
% NeuroImage 6:344-352 (1997)
%
% J. Ashburner and K. J. Friston
% Nonlinear Spatial Normalization using Basis Functions.
% Human Brain Mapping 7(4):in press (1999)
%_______________________________________________________________________
% Copyright (C) 2005 Wellcome Department of Imaging Neuroscience

% John Ashburner
% $Id: tbxvol_normalise.m 712 2010-06-30 14:20:19Z glauche $


if nargin<2, error('Incorrect usage.'); end;
if ischar(VF), VF = spm_vol(VF); end;
if ischar(VG), VG = spm_vol(VG); end;
if nargin<3,
    if nargout==0,
	for k = 1:numel(VF)
	    [pth,nm,xt,vr] = spm_fileparts(deblank(VF(k).fname));
	    matname{k}     = fullfile(pth,[nm '_sn.mat']);
	end;
    else
	matname = '';
    end;
end;
if nargin<4, VWG = ''; end;
if nargin<5, VWF = ''; end;
if ischar(VWG), VWG=spm_vol(VWG); end;
if ischar(VWF), VWF=spm_vol(VWF); end;                                                                     


def_flags = struct('smosrc',4,'smoref',4,'regtype','mni',...
	'cutoff',15,'nits',16,'reg',0.01,'graphics',0);
if nargin < 6,
    flags = def_flags;
else
    fnms  = fieldnames(def_flags);
    for i=1:length(fnms),
        if ~isfield(flags,fnms{i}),
            for k = 1:numel(flags)
                flags(k).(fnms{i}) = def_flags.(fnms{i});
            end;
        end;
    end;
end;

fprintf('Smoothing by %g & %gmm..\n', flags(1).smoref, flags(1).smosrc);
for k = 1:numel(VF)
    VF1(k) = spm_smoothto8bit(VF(k),flags(1).smosrc);

    % Rescale images so that globals are better conditioned
    VF1(k).pinfo(1:2,:) = VF1(k).pinfo(1:2,:)/spm_global(VF1(k));
end;

if (nargin < 7) || isempty(starting)
    % use specified template
    for i=1:numel(VG),
	VG1(i) = spm_smoothto8bit(VG(i),flags(1).smoref);
	VG1(i).pinfo(1:2,:) = VG1(i).pinfo(1:2,:)/spm_global(VG(i));
    end;

    % Affine Normalisation
    %-----------------------------------------------------------------------
    for k = 1:numel(VF1)
	fprintf('Coarse Affine Registration..\n');
	aflags    = struct('sep',max(flags(1).smoref,flags(1).smosrc), 'regtype',flags(1).regtype,...
			   'WG',[],'WF',[],'globnorm',0);
	aflags.sep = max(aflags.sep,max(sqrt(sum(VG(1).mat(1:3,1:3).^2))));
	aflags.sep = max(aflags.sep,max(sqrt(sum(VF(k).mat(1:3,1:3).^2))));
	
	M         = eye(4); %spm_matrix(prms');
	spm_chi2_plot('Init','Affine Registration','Mean squared difference','Iteration');
	[M,scal]  = spm_affreg(VG1, VF1(k), aflags, M);
	
	fprintf('Fine Affine Registration..\n');
	aflags.WG  = VWG;
	aflags.WF  = VWF;
	aflags.sep = aflags.sep/2;
	[M,scal]   = spm_affreg(VG1, VF1(k), aflags, M,scal);
	Affine{k}     = inv(VG(1).mat\M*VF1(k).mat);
	spm_chi2_plot('Clear');
    end;
    Tr(1:numel(VF1)) = {[]};
    bb = Inf*ones(2,3);
    vox = Inf*ones(1,3);
else
    for k = 1:numel(VF1)
	prm = load(starting{k});
	Affine{k} = prm.Affine;
	Tr{k}     = prm.Tr;
	VGtmp(k)  = prm.VG(1);
    end;
    try
	spm_check_orientations(VGtmp);
    catch
	error(['Templates for initial normalisation step do not have same' ...
	       ' orientation and voxel size.\n']);
    end;
    [bb vox] = bbvox_from_V(VGtmp(1));
    fprintf('Computing template image for iteration 1.\n');
    for k = 1:numel(VF1)
	VN(k) = spm_write_sn(VF(k),starting{k},...
			     struct('interp',4,...
				    'bb',bb,...
				    'vox',vox));
    end;
    VGnew = rmfield(VN(1),'dat');
    [p n e v] = spm_fileparts(VGnew.fname);
    VGnew.fname = fullfile(p,sprintf('mean%d%s%s',1,n,e));
    VGnew = spm_imcalc(VN,VGnew,'mean(X)',{1,0,-4});
    VG1 = spm_smoothto8bit(VGnew,flags(1).smoref);
    VG1.pinfo(1:2,:) = VG1.pinfo(1:2,:)/spm_global(VGnew);
end;
    
% Basis function Normalisation
%-----------------------------------------------------------------------
spm_progress_bar('init', 100, 'Parameter Estimation', '% completed');
for it = 1:numel(flags)
    for k = 1:numel(VF1)
	fov = VF1(k).dim(1:3).*sqrt(sum(VF1(k).mat(1:3,1:3).^2));
	if any(fov<15*flags(it).smosrc/2 & VF1(k).dim(1:3)<15),
	    fprintf('Field of view too small for nonlinear registration\n');
	    Tr{k} = [];
	elseif isfinite(flags(it).cutoff) && flags(it).nits && ~isinf(flags(it).reg),
	    fprintf('3D CT Norm...\n');
	    Tr{k} = snbasis(VG1,VF1(k),VWG,VWF,Affine{k},...
			    max(flags(it).smoref,flags(it).smosrc),flags(it).cutoff, ...
			    flags(it).nits,flags(it).reg, Tr{k});
	else
	    Tr{k} = [];
	end;
	params = struct('Affine',Affine{k}, 'Tr',Tr{k}, 'VF',VF(k), 'VG',VG, ...
			'flags',flags(it));
	VN(k) = spm_write_sn(VF(k),params,struct('interp',4,...
						 'bb',bb,...
						 'vox',vox));
	spm_progress_bar('set', 100*((it-1)*numel(VF1)+k)/ ...
			 (numel(flags)*numel(VF1))); 
    end;
    if it < numel(flags)
	fprintf('Computing template image for iteration %d.\n',it+1);
	VWF = [];
	VWG = [];
	VGnew = rmfield(VN(1),'dat');
	[p n e v] = spm_fileparts(VGnew.fname);
	VGnew.fname = fullfile(p,sprintf('mean%d%s%s',it+1,n,e));
	VGnew = spm_imcalc(VN,VGnew,'mean(X)',{1,0,-4});
	VG1 = spm_smoothto8bit(VGnew,flags(it+1).smoref);
	VG1.pinfo(1:2,:) = VG1.pinfo(1:2,:)/spm_global(VGnew);
    end;
end;
clear VF1 VG1


% Remove dat fields before saving
%-----------------------------------------------------------------------
if isfield(VF,'dat'), VF = rmfield(VF,'dat'); end;
if isfield(VG,'dat'), VG = rmfield(VG,'dat'); end;
if ~isempty(matname),
    AffineList = Affine;
    TrList = Tr;
    VFList = VF;
    spm_progress_bar('init', numel(VFList), 'Saving Parameters');
    for k = 1:numel(VFList)
        fprintf('Saving Parameters..\n');
        Affine = AffineList{k};
        Tr = TrList{k};
        VF = VFList(k);
        if spm_matlab_version_chk('7') >= 0,
            save(matname{k},'-V6','Affine','Tr','VF','VG','flags');
        else
            save(matname{k},'Affine','Tr','VF','VG','flags');
        end;
	spm_progress_bar('set', k);
    end;
end;
spm_progress_bar('clear');
return;
%_______________________________________________________________________

%_______________________________________________________________________
function Tr = snbasis(VG,VF,VWG,VWF,Affine,fwhm,cutoff,nits,reg,Tr)
% 3D Basis Function Normalization
% FORMAT Tr = snbasis(VG,VF,VWG,VWF,Affine,fwhm,cutoff,nits,reg)
% VG        - Template volumes (see spm_vol).
% VF        - Volume to normalize.
% VWG       - weighting Volume - for template.
% VWF       - weighting Volume - for object.
% Affine    - A 4x4 transformation (in voxel space).
% fwhm      - smoothness of images.
% cutoff    - frequency cutoff of basis functions.
% nits      - number of iterations.
% reg       - regularisation.
% Tr - Discrete cosine transform of the warps in X, Y & Z.
%
% snbasis performs a spatial normalization based upon a 3D
% discrete cosine transform.
%
%______________________________________________________________________

fwhm    = [fwhm 30];

% Number of basis functions for x, y & z
%-----------------------------------------------------------------------
tmp  = sqrt(sum(VG(1).mat(1:3,1:3).^2));
k    = max(round((VG(1).dim(1:3).*tmp)/cutoff),[1 1 1]);

if ~isempty(Tr)
    % take at least same number of parameters as before, set
    % uninitialised parameters to zero
    k1 = size(Tr);
    k  = max(k,k1(1:3));
    Tr((end+1):k(1),(end+1):k(2),(end+1):k(3),:) = 0;
end;

% Scaling is to improve stability.
%-----------------------------------------------------------------------
stabilise = 8;
basX = spm_dctmtx(VG(1).dim(1),k(1))*stabilise;
basY = spm_dctmtx(VG(1).dim(2),k(2))*stabilise;
basZ = spm_dctmtx(VG(1).dim(3),k(3))*stabilise;

dbasX = spm_dctmtx(VG(1).dim(1),k(1),'diff')*stabilise;
dbasY = spm_dctmtx(VG(1).dim(2),k(2),'diff')*stabilise;
dbasZ = spm_dctmtx(VG(1).dim(3),k(3),'diff')*stabilise;

vx1 = sqrt(sum(VG(1).mat(1:3,1:3).^2));
vx2 = vx1;
kx = (pi*((1:k(1))'-1)/VG(1).dim(1)/vx1(1)).^2; ox=ones(k(1),1);
ky = (pi*((1:k(2))'-1)/VG(1).dim(2)/vx1(2)).^2; oy=ones(k(2),1);
kz = (pi*((1:k(3))'-1)/VG(1).dim(3)/vx1(3)).^2; oz=ones(k(3),1);

if 1,
        % BENDING ENERGY REGULARIZATION
        % Estimate a suitable sparse diagonal inverse covariance matrix for
        % the parameters (IC0).
        %-----------------------------------------------------------------------
	IC0 = (1*kron(kz.^2,kron(ky.^0,kx.^0)) +...
	       1*kron(kz.^0,kron(ky.^2,kx.^0)) +...
	       1*kron(kz.^0,kron(ky.^0,kx.^2)) +...
	       2*kron(kz.^1,kron(ky.^1,kx.^0)) +...
	       2*kron(kz.^1,kron(ky.^0,kx.^1)) +...
	       2*kron(kz.^0,kron(ky.^1,kx.^1)) );
        IC0 = reg*IC0*stabilise^6;
        IC0 = [IC0*vx2(1)^4 ; IC0*vx2(2)^4 ; IC0*vx2(3)^4 ; zeros(numel(VG)*4,1)];
        IC0 = sparse(1:length(IC0),1:length(IC0),IC0,length(IC0),length(IC0));
else
        % MEMBRANE ENERGY (LAPLACIAN) REGULARIZATION
        %-----------------------------------------------------------------------
        IC0 = kron(kron(oz,oy),kx) + kron(kron(oz,ky),ox) + kron(kron(kz,oy),ox);
        IC0 = reg*IC0*stabilise^6;
        IC0 = [IC0*vx2(1)^2 ; IC0*vx2(2)^2 ; IC0*vx2(3)^2 ; zeros(prod(size(VG))*4,1)];
        IC0 = sparse(1:length(IC0),1:length(IC0),IC0,length(IC0),length(IC0));
end;

% Generate starting estimates.
%-----------------------------------------------------------------------
s1 = 3*prod(k);
s2 = s1 + numel(VG)*4;
T  = zeros(s2,1);
T(s1+(1:4:numel(VG)*4)) = 1;
if exist('Tr','var') && ~isempty(Tr)
    T(1:s1) = Tr(:)/stabilise.^3;
end;

pVar = Inf;
for iter=1:nits,
	fprintf(' iteration %2d: ', iter);
	[Alpha,Beta,Var,fw] = spm_brainwarp(VG,VF,Affine,basX,basY,basZ,dbasX,dbasY,dbasZ,T,fwhm,VWG, VWF);
	if Var>pVar, scal = pVar/Var ; Var = pVar; else scal = 1; end;
	pVar = Var;
	T = (Alpha + IC0*scal)\(Alpha*T + Beta);
	fwhm(2) = min([fw fwhm(2)]);
	fprintf(' FWHM = %6.4g Var = %g\n', fw,Var);
end;

% Values of the 3D-DCT - for some bizarre reason, this needs to be done
% as two seperate statements in Matlab 6.5...
%-----------------------------------------------------------------------
Tr = reshape(T(1:s1),[k 3]);
drawnow;
Tr = Tr*stabilise.^3;
return;

%_______________________________________________________________________

%_______________________________________________________________________
function [bb,vx] = bbvox_from_V(V)
vx = sqrt(sum(V.mat(1:3,1:3).^2));
if det(V.mat(1:3,1:3))<0, vx(1) = -vx(1); end;

o  = V.mat\[0 0 0 1]';
o  = o(1:3)';
bb = [-vx.*(o-1) ; vx.*(V.dim(1:3)-o)]; 
return;
