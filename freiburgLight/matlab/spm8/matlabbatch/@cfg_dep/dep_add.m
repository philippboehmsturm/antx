function dep = dep_add(cdep, dep, ntgt_input, njtsubs)

% augment cdep tsubs references, and add them to dependency list
%
% This code is part of a batch job configuration system for MATLAB. See 
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id: dep_add.m 359 2008-11-18 11:38:19Z glauche $

rev = '$Rev: 359 $'; %#ok

for k = 1:numel(cdep)
    cdep(k).tgt_input = [ntgt_input cdep(k).tgt_input];
    cdep(k).jtsubs = [njtsubs cdep(k).jtsubs];
end;
if isempty(dep)
    dep = cdep(:);
else
    dep = [dep(:); cdep(:)];
end;
