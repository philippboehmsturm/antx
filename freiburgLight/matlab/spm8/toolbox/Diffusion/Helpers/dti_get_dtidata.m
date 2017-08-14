function D = dti_get_dtidata(P,D)
% Get/set the diffusion information of an image
% FORMAT D = dti_get_dtidata(P)
%            dti_get_dtidata(P,D)
% D - struct containing fields - struct array for multi-volume data
%      .b   - b value
%      .g   - gradient direction
%      .mat - optional saved original orientation information
% P - image filename
% 
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id$

% The diffusion information will be stored in the .extras part of the header

[pth,nam,ext,v] = spm_fileparts(P);
n = [1 1];
if ~isempty(v),
    n   = str2num(v);
end;

N = nifti(P);
n1 = unique(n);
if nargin==2,
    if numel(n1) ~= numel(D)
        error(['# dti information structures does not match ' ...
               '# image frames.']);
    end;
    if isstruct(D) && isfield(D,'b') && isfield(D,'g')
        N.extras.userdata(n1) = D;
    else
        error(['Second argument does not represent dti information ' ...
               'structure.']);
    end
    create(N);
else
    if ~isempty(N.extras) && isstruct(N.extras) && isfield(N.extras,'userdata')
        D(n1) = N.extras.userdata(n1);
    else
        error('No DTI information found for image %s',P);
    end;
end;

