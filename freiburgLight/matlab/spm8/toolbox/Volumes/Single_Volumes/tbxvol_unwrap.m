function tbxvol_unwrap(bch)
% Correct phase encode wrap-around
% FORMAT tbxvol_unwrap
% ======
%
% This tool shifts voxels in phase-encode direction by a positive or 
% negative number of voxels to correct for wrap-around during acquisition.
% The image dimension to wrap can be choosen (in voxel space). To keep 
% unwrapped images in the correct spatial position relative to other 
% images it is possible to adjust the .mat-file of the unwrapped image.
%
% This function is part of the volumes toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Volumes
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: tbxvol_unwrap.m 712 2010-06-30 14:20:19Z glauche $

rev = '$Revision: 712 $';
funcname = 'Unwrap volumes';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

Mc=eye(4);
if bch.cor_orig
  Mc(bch.wrapdir,4) = -bch.npix;
end;
    
spm_progress_bar('Init',numel(bch.srcimgs),'Unwrap','Volumes completed');
for k=1:numel(bch.srcimgs)
        V = spm_vol(bch.srcimgs{k});
	X = spm_read_vols(V);
	switch(bch.wrapdir)
	  case 1,
	    X(1+mod(bch.npix+(0:(V.dim(1)-1)), V.dim(1)),:,:)=X;
	  case 2,
	    X(:,1+mod(bch.npix+(0:(V.dim(2)-1)), V.dim(2)),:)=X;
	  case 3,
	    X(:,:,1+mod(bch.npix+(0:(V.dim(3)-1)), V.dim(3)))=X;
	end;
	V.mat=V.mat*Mc;
        if ~bch.overwrite
                [p n e v] = spm_fileparts(V.fname);
                V.fname = fullfile(p, [bch.prefix n e v]);
                V = spm_create_vol(V);
        end;
	V = spm_write_vol(V,X);
	spm_progress_bar('set',k);
end;
spm_progress_bar('clear');
