function out = tbxvol_get_integrals(cmd, bch)
% Integrate the values in an image.
% FORMAT out = tbxvol_get_integrals(cmd, bch)
% ======
% This tool simply reads in images slice by slice and sums up the values of 
% each pixel. Voxels with non-finite (NaN, +/-Inf) values will not be
% summed up.
% The reported volume will be given in liters (in variable out.gl) and count
% of non-zero voxels will be returned (in variable out.gv). In addition, a
% voxel-to-litre scaling factor (computed from the transformation matrix
% of each image) will be returned, such that gl./vs is the sum over all
% finite voxel values in the image.
% 
% This function is part of the volumes toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Volumes
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: tbxvol_get_integrals.m 671 2009-07-17 10:52:42Z glauche $

rev = '$Revision: 671 $';
funcname = 'Integrate over image';

switch lower(cmd)
    case 'run'
        % function preliminaries
        Finter=spm_figure('GetWin','Interactive');
        Finter=spm('FigName',funcname,Finter);
        SPMid = spm('FnBanner',mfilename,rev);
        % function code starts here
        
        V = spm_vol(char(bch.srcimgs));
        out.gl = zeros(size(V));
        out.vs = zeros(size(V));
        out.gv = zeros(size(V));
        spm_progress_bar('init',numel(out.gl),'','Volumes completed');
        for i=1:numel(out.gl),
            for z=1:V(i).dim(3),
                img   = spm_slice_vol(V(i),spm_matrix(...
                    [0 0 z]),V(i).dim(1:2),0);
                out.gl(i) = out.gl(i) + sum(img(isfinite(img(:))));
                out.gv(i) = out.gv(i) + sum(isfinite(img(:))&(img(:)~=0));
                spm_progress_bar('set',i-1+z/V(i).dim(3));
            end;
            out.vs(i) = abs(det(V(i).mat))/100^3; % Voxel-to-Liter scaling
        end;
        spm_progress_bar('clear');
        out.gl = out.gl.*out.vs;
        if nargout == 0
            assignin('base','integrals',gl)
            assignin('base','voxels',gv)
            assignin('base','volscal',vs)
            disp('Integrals assigned to variable ''integrals'' in MATLAB workspace.');
            disp('Voxel counts assigned to variable ''voxels'' in MATLAB workspace.');
            disp('Volume scalings assigned to variable ''volscal'' in MATLAB workspace.');
        end;
    case 'vout'
        out(1)            = cfg_dep;
        out(1).sname      = 'Volume (liters)';
        out(1).src_output = substruct('.','gl');
        out(1).tgt_spec   = cfg_findspec({{'strtype','r'}});
        out(2)            = cfg_dep;
        out(2).sname      = 'Volume (non-zero voxel count)';
        out(2).src_output = substruct('.','gv');
        out(2).tgt_spec   = cfg_findspec({{'strtype','r'}});
        out(3)            = cfg_dep;
        out(3).sname      = 'Volume per voxel';
        out(3).src_output = substruct('.','vs');
        out(3).tgt_spec   = cfg_findspec({{'strtype','r'}});
end