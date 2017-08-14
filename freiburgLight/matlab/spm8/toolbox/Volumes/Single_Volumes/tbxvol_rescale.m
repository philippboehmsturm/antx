function out = tbxvol_rescale(bch)
% Rescale SPM images
% FORMAT tbxvol_rescale(bch)
% ======
% Reset scaling factors and create new images. This tool is useful 
% if one wants to use Analyze format images created with SPM with 
% other programs since they usually ignore SPM's setting of scaling 
% factor and offset. By default, scaling will be set to the maximum 
% scaling factor found in the images and offset to zero.
% New files will be created with a prefix 'S' to the original file 
% name. If bch.overwrite is set to 1 (Yes), original files will be 
% replaced by the rescaled ones. This option should be used with great 
% care, since it may mess up other SPM routines which are using cached 
% volume information (e.g. from a SPM.mat file).
%
% Input argument:
%   bch - struct with batch descriptions. Possible fields are:
%         .srcimgs   - cell array of file names
%         .overwrite - flag whether to overwrite files - if set to 0, a 
%                      'S' will be prefixed to the rescaled images
%         .scale     - new scaling factor (set this to NaN to rescale 
%                      per subject/session, Inf to rescale per image)
%         .offset    - new offset
%
% This function is part of the volumes toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Volumes
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: tbxvol_rescale.m 712 2010-06-30 14:20:19Z glauche $

rev = '$Revision: 712 $';
funcname = '(Re)Scale Images';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

spm_progress_bar('init', numel(bch.srcimgs), ...
                 funcname, 'volumes completed'); 
V = spm_vol(char(bch.srcimgs));
maxscal = max(subsref(cat(2,V.pinfo),...
                      struct('type','()','subs',{{1,':'}})));
if isnan(bch.scale)
        scale = maxscal;
else
        scale = bch.scale;
end;
for k=1:numel(bch.srcimgs)
        V1=V(k);
        if bch.dtype ~= 0
            V1.dt(1) = bch.dtype;
        end;
        V1.pinfo(1)=scale;
        V1.pinfo(2)=bch.offset;
        if ~bch.overwrite
                [p n e v] = spm_fileparts(V(k).fname);
                V1.fname = fullfile(p,[bch.prefix, n, e, v]);
        end
        out.rimgs{k} = V1.fname;
        Y=spm_read_vols(V(k));
        %-Create and write image
        %-----------------------------------------------------------------------
        V1 = spm_write_vol(V1,Y);
        spm_progress_bar('set',k);
end;
spm_progress_bar('clear');
