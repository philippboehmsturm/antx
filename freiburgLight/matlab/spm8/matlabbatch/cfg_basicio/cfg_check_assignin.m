function str = cfg_check_assignin(val)

% Check whether the name entered for the workspace variable is a proper
% variable name.
%
% This code is part of a batch job configuration system for MATLAB. See 
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id: cfg_check_assignin.m 269 2008-05-23 07:15:10Z glauche $

rev = '$Rev: 269 $'; %#ok

if isvarname(val) || strcmp(val,'<UNDEFINED>') || isempty(val) || isa(val, 'cfg_dep')
    str = '';
else
    str = sprintf('String ''%s'' is not a valid variable name.', val);
end;