function out=dti_init_dtidata(bch)
% Initialise userdata of diffusion weighted images
%
% This routine allows to (re)set diffusion and orientation information 
% for a series of diffusion weighted images (the orientation part can be 
% used for other image series as well).
% Diffusion information needs to be given for each individual image as a 
% vector of b values and a number-of-images-by-3 matrix of diffusion 
% gradient directions. This toolbox assumes that gradient directions are 
% given in "world space". spm_input will read diffusion information from 
% workspace  variables if you type the variable name in the input 
% field or even load it from a file. So, if you have to set diffusion 
% information for a set of repeated measurements with diffusion 
% information for one measurement stored in 'dti.txt', you could use the 
% syntax
%        repmat(load('dti.txt'),nrep,1)
% where dti.txt contains gradient information for all images within a 
% repetition (one row with 3 columns per direction).
% This routine is useful to initialise diffusion weighted images that 
% have no diffusion information available in its DICOM header or to 
% re-initialise images that have already been processed (e.g. to redo 
% realignment).
%
% Batch processing:
% FORMAT dti_init_dtidata(bch)
% ======
% Input argument:
%   bch struct with fields
%/*\begin{description}*/
%/*\item[*/       .srcimgs/*]*/ cell array of file names
%/*\item[*/       .b/*]*/       numel(files)-by-1 vector of b values
%/*\item[*/       .g/*]*/       numel(files)-by-3 matrix of diffusion weighting 
%                directions
%/*\item[*/       .M/*]*/       4x4 transformation matrix. If not set, and position 
%                should be reset, then the space will be reset to the 
%                saved information from DTI userdata. If this information 
%                is not available, the space of the first image is 
%                taken as reference.
%/*\end{description}*/
% To add .M to DTI userdata, no additional input is necessary. In this 
% case, the current .mat information (obtained from spm_get_space) will 
% be saved if DTI userdata exists.
% Note that re-setting .b or .g does not re-set the saved reference 
% .mat. However, if no diffusion information was present before, also 
% .mat will be created with the current space information. This occurs 
% after a .M has been processed, so that redoing reorientation and 
% setting diffusion information can be done in one step per image.
%
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id$

rev = '$Revision$';
funcname = '(Re)Set DTI/Orientation';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
spm_input('!DeleteInputObj');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here


spm_progress_bar('init', numel(bch.srcimgs), ...
                 '(Re)setting diffusion information', 'volumes completed'); 
M1 = spm_get_space(bch.srcimgs{1});
try
    tmp = dti_get_dtidata(bch.srcimgs{1});
    R1  = tmp.ref;
catch
    prms = spm_imatrix(M1);
    R1   = diag([sign(prms(7)) -1 1 1]);
end
for k=1:numel(bch.srcimgs)
    if isfield(bch.initopts,'setM') % only save current space to userdata
        try
            tmp = dti_get_dtidata(bch.srcimgs{k});
            tmp.mat = spm_get_space(bch.srcimgs{k});
            dti_get_dtidata(bch.srcimgs{k},tmp);
        catch
            disp(lasterr);
        end;
    elseif isfield(bch.initopts,'setR') 
        % add reference coordinate information, assume y flipping has
        % been done and determine x flipping from L-R information from
        % spm_get_space
        try
            tmp     = dti_get_dtidata(bch.srcimgs{k});
            prms    = spm_imatrix(spm_get_space(bch.srcimgs{k}));
            tmp.ref = diag([sign(prms(7)) 1 1 1]);
            dti_get_dtidata(bch.srcimgs{k},tmp);
        catch
            disp(lasterr);
        end
    else
        fn = fieldnames(bch.initopts);
        reset = bch.initopts.(fn{1});
        if isfield(reset, 'M') % needs to be done before re-setting diffusion data
            try
                % Do we have userdata?
                tmp = dti_get_dtidata(bch.srcimgs{k});
                if ~isfield(tmp,'mat') 
                    tmp.mat=M1; % set .mat, if not present
                    dti_get_dtidata(bch.srcimgs{k},tmp);
                end;
                spm_get_space(bch.srcimgs{k},tmp.mat);
            catch
                spm_get_space(bch.srcimgs{k},M1);
            end;
        end;
        if isfield(reset, 'b') || ...
                isfield(reset, 'g')
            try
                tmp = dti_get_dtidata(bch.srcimgs{k});
            catch
                tmp = [];
            end;
            if ~isstruct(tmp)
                M    = spm_get_space(bch.srcimgs{k});
                prms = spm_imatrix(M);
                % Assume DICOM reference coordinate system for gradients
                tmp  = struct('b',0, 'g',[0 0 0], 'mat',M, ...
                              'ref',diag([sign(prms(7)) -1 1 1]));
            end;
            if isfield(reset, 'b')
                tmp.b=reset.b(k);
            end;
            if isfield(reset, 'g')
                tmp.g   = reset.g(k,:);
                tmp.ref = R1;
            end;
            dti_get_dtidata(bch.srcimgs{k},tmp);
        end;
    end;
    spm_progress_bar('set',k);
end;
out.files = bch.srcimgs;
spm_progress_bar('clear');
