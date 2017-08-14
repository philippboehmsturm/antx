function tbxvol_flip(bch)
% Flip volumes by reordering voxels on disk
% FORMAT tbxvol_flip(bch)
% ======
% This tool flips volumes by reordering their voxels. This means that the 
% flipped image will appear flipped in non-SPM programs too. The .mat 
% file of the image will not be touched. The original image will be 
% replaced by the flipped version or a new image will be created 
% depending on user input.
% This tool is potentially dangerous when used for left-right flips, 
% because there is no secure way to determine whether an image has been 
% flipped by reordering voxels somewhere in an SPM analysis.
%
% This function is part of the volumes toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Volumes
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: tbxvol_flip.m 712 2010-06-30 14:20:19Z glauche $

rev = '$Revision: 712 $';
funcname = 'Flip volumes';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

dirs = 'XYZ';
spm_progress_bar('Init',numel(bch.srcimgs),funcname,'Volumes completed');
for k=1:numel(bch.srcimgs)
	V = spm_vol(bch.srcimgs{k});
	Y = spm_read_vols(V);
	if ~bch.overwrite
                [p n e v] = spm_fileparts(V.fname);
                V.fname = fullfile(p,[bch.prefix dirs(bch.flipdir) n e v]);
                V = spm_create_vol(V);
	end;
	spm_write_vol(V,flipdim(Y,bch.flipdir));
	spm_progress_bar('set',k);
end;
spm_progress_bar('clear');
