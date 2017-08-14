function tbxvol_split(bch)
% Split a multi-image volume into single volumes
% FORMAT tbxvol_split(bch)
% ======
% This tool can be used to split images that were converted into a single 
% Analyze volume into seperate volumes. The input image can be in one of 
% two formats:
% - Volume order: subsequent slices belong to the same volume
% - Slice order: subsequent slices belong to the same slice
%
% This function is part of the volumes toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Volumes
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: tbxvol_split.m 712 2010-06-30 14:20:19Z glauche $

rev = '$Revision: 712 $';
funcname = 'Split volumes';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

spm('pointer','watch');
for l=1:numel(bch.srcimgs)
        Vi = spm_vol(bch.srcimgs{l});

        if rem(Vi.dim(3),bch.noutput) ~= 0
                error('#Input slices %d not a multiple of #output volumes %d',...
                      Vi.dim(3),bch.noutput);
        end;

        Vtmp = repmat(rmfield(Vi,'private'),bch.noutput,1);
        [p n e v] = spm_fileparts(Vi.fname);
        fs = sprintf('_%%0%dd',ceil(log10(bch.noutput)));
        for k = 1:bch.noutput
                Vtmp(k).dim(3)=Vi.dim(3)/bch.noutput;
                Vtmp(k).fname = fullfile(p,[n sprintf(fs,k) e v]);
                if bch.thickcorr==1
                        prms = spm_imatrix(Vtmp(k).mat);
                        Vtmp(k).mat = spm_matrix([prms(1:8) bch.noutput*prms(9) ...
                                            prms(10:12)]);
                end;
                Vo(k) = spm_create_vol(Vtmp(k));
        end;

        X = spm_read_vols(Vi);

        spm_progress_bar('Init',bch.noutput,'Writing','volumes completed');
        if isempty(strfind(bch.sliceorder,'vrev'))
                vind = 1:bch.noutput;
        else
                vind = bch.noutput:-1:1;
        end;
        switch bch.sliceorder
        case {'volume','volume_vrev'}
            for k=1:bch.noutput,
                Y = X(:,:,(vind(k)-1)*Vi.dim(3)/bch.noutput+1:vind(k)*Vi.dim(3)/bch.noutput);
                %-Create and write image
                %-----------------------------------------------------------------------
                for p=1:Vo(k).dim(3),
                    Vo(k) = spm_write_plane(Vo(k),Y(:,:,p),p);
                end;
                spm_progress_bar('Set',k);
            end,
        case {'slice','slice_vrev'}
            for k=1:bch.noutput
                Y = X(:,:,vind(k):bch.noutput:Vi.dim(3));
                %-Create and write image
                %-----------------------------------------------------------------------
                for p=1:Vo(k).dim(3),
                    Vo(k) = spm_write_plane(Vo(k),Y(:,:,p),p);
                end;
                spm_progress_bar('Set',k);
            end;
        end;
        spm_progress_bar('Clear');
end;
spm('pointer','arrow');
