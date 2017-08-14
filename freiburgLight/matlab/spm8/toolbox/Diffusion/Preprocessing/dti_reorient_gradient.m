function varargout=dti_reorient_gradient(bch)
% Apply image reorientation information to diffusion gradients
% 
% This function needs to be called once after all image realignment, 
% coregistration or normalisation steps have been performed, i.e. after 
% the images have been resliced or written normalised. Without calling 
% this function immediately after reslicing or normalisation, all 
% diffusion information is lost. /*\textbf{*/This is a major change to the 
% functionality of the toolbox compared to SPM2!/*}*/
% It applies the rotations performed during realignment, coregistration 
% and affine normalisation to the gradient direction vectors. This is 
% done by comparing the original orientation information (saved in the 
% images userdata by dti_init_dtidata) with the current image 
% orientation.
% After applying this correction a reset of DTI information will not be 
% able to recover the initial gradient or orientation values, since the 
% original orientation matrix will be lost.
%
% Batch processing:
% FORMAT dti_reorient_gradient(bch)
% ======
% Input argument
%   bch struct with fields:
%/*\begin{description}*/
%/*\item[*/      .srcimgs/*]*/  cell array of file names (usually the un-resliced, 
%                 un-normalised images)
%/*\item[*/       .tgtimgs/*]*/  target images (can be the same files as srcimgs, 
%                 but usually the resliced or normalised images).
%/*\item[*/       .snparams/*]*/ optional normalisation parameters file used to 
%                 write the images normalised.
%/*\end{description}*/
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: dti_reorient_gradient.m 659M 2009-12-11 08:53:55Z (lokal) $

rev = '$Revision: 659M $';
funcname = 'Reorient gradients';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
spm_input('!DeleteInputObj');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

spm_progress_bar('init', numel(bch.srcimgs), ...
                 'Reorient gradients', 'volumes completed'); 
for k=1:numel(bch.srcimgs)
    % copy DTI information after applying SPM
    % reslice/write_sn functions and apply affine
    % normalisation parameters to gradient directions
    if k==1
        if ~isempty(bch.snparams) && ~isempty(bch.snparams{1})
            Maff = ...
                dti_get_snaffine(bch.snparams{1});
        else
            Maff = eye(4);
        end;
    end;
    ud = dti_get_dtidata(bch.srcimgs{k});
    Mnew = spm_get_space(bch.srcimgs{k});
    prm = spm_imatrix(Maff*Mnew/ud.mat); %??
    newprm = [zeros(1,6) ones(1,3) zeros(1,3)];
    if bch.useaff.rot
        newprm(4:6) = prm(4:6);
    end;
    if bch.useaff.zoom == 1
        newprm(7:9) = sign(prm(7:9));
    elseif bch.useaff.zoom == 2
        newprm(7:9) = prm(7:9);
    end;
    if bch.useaff.shear
        newprm(10:12) = prm(10:12);
    end;
    Mrot = spm_matrix(newprm);
    Mrot = ud.ref\sqrtm(Mrot*Mrot')\Mrot*ud.ref; % Rotation in gradient space
    ud.g = (Mrot(1:3,1:3)*ud.g')'; % Rotate gradient vector
    ud.mat = Mnew; % Update reference space
    dti_get_dtidata(bch.tgtimgs{k},ud);
    spm_progress_bar('set',k);
end;
spm_progress_bar('clear');
res.tgtimgs = bch.tgtimgs;
varargout{1} = res;
