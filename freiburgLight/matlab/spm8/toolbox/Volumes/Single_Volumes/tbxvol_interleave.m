function tbxvol_interleave(bch)
% Shuffle planes in a image volume
% FORMAT tbxvol_interleave(bch)
% ======
% This tool allows to reorder slices within an image volume. It is a 
% useful tool to correct problems during conversion of images that were 
% acquired in interleaved order.
% 
% This function is part of the volumes toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Volumes
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: tbxvol_interleave.m 712 2010-06-30 14:20:19Z glauche $

rev = '$Revision: 712 $';
funcname = '(De)interleave volumes';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

if isfield(bch.sliceorder,'userdef') 
        so = bch.sliceorder.userdef;
end;
spm_progress_bar('Init',numel(bch.srcimgs),'Sorting','volumes completed');

for k=1:numel(bch.srcimgs)
        V = spm_vol(bch.srcimgs{k});
        if isfield(bch.sliceorder,'interleaved') 
                so = [1:2:V.dim(3) 2:2:V.dim(3)];
        end;
        [tmp perm]=sort(so);

        X=spm_read_vols(V); % Lies ein Bild ein
        if ~bch.overwrite
                [p n e v] = spm_fileparts(V.fname);
                V.fname = fullfile(p, [bch.prefix n e v]);
                V = spm_create_vol(V);
        end;
        V = spm_write_vol(V,X(:,:,perm));
        spm_progress_bar('Set',k);
end;
spm_progress_bar('Clear');
