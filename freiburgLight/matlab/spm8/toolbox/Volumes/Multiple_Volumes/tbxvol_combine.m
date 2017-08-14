function Vo = tbxvol_combine(bch)
% Combine multiple volumes into a single volume
% FORMAT tbxvol_combine(bch)
% ======
% Input argument:
% bch.srcimgs - File names of images to combine
% bch.prefix  - Output filename prefix
% bch.voxsz   - Output voxel size (mm)
% bch.interp  - Interpolation hold
%
% Reslice multiple input volumes into a single output volume. If there is 
% spatial overlap in two or more image volumes, output voxel values are 
% the mean of the input voxel values. Regardless of NaN representation in 
% the image volumes, zeros are always treated as missing and not included 
% in mean computation.
% The output image will be written with transversal slices. The image 
% size will be determined automatically based on the spatial extent of 
% the input images.
%
% This function is part of the volumes toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Volumes
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: tbxvol_combine.m 712 2010-06-30 14:20:19Z glauche $

rev = '$Revision: 712 $';
funcname = 'Combine volumes';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

Vi = spm_vol(char(bch.srcimgs));
[p n e] = spm_fileparts(Vi(1).fname);
Vo.fname = fullfile(p,[bch.prefix n e]);
if bch.dtype == 0
    Vo.dt = Vi(1).dt;
else
    Vo.dt = bch.dtype;
end;
mx = [];
mn = [];
for k=1:numel(Vi)
  mx = max([mx Vi(k).mat*ones(4,1) Vi(k).mat*[Vi(k).dim(1:3) 1]'],[],2);
  mn = min([mn Vi(k).mat*ones(4,1) Vi(k).mat*[Vi(k).dim(1:3) 1]'],[],2);
end;
Vo.dim = ceil((mx(1:3)'-mn(1:3)')./bch.voxsz);

Vo.mat = spm_matrix([(-Vo.dim(1:3)./2).*bch.voxsz 0 0 0 bch.voxsz]);
Vo.pinfo = zeros(3,1);
Vo = spm_create_vol(Vo);
X = NaN*ones(Vo.dim(1:3));
spm_input('!DeleteInputObj');
spm_progress_bar('Init',Vo.dim(3),'Reslice','planes completed');

for z = 1:Vo.dim(3)
  X1=NaN*ones([Vo.dim(1:2) length(Vi)]);
  for k = 1:length(Vi)
    X1(:,:,k) = spm_slice_vol(Vi(k), ...
	Vi(k).mat\Vo.mat*spm_matrix([0 0 z]),Vo.dim(1:2), bch.interp);
  end;
  X1(isnan(X1))=0;
  sel = X1 ~= 0;
  ssel = sum(sel,3);
  ssel(ssel == 0) = 1;
  X(:,:,z) = mean(X1,3);
  X(:,:,z) = X(:,:,z) .* (length(Vi)./ssel);
  X(:,:,ssel==0)=NaN;
  spm_progress_bar('Set',z);
end
Vo = spm_write_vol(Vo,X);
spm_progress_bar('Clear');
