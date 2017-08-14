function disp(varargin)

% function disp(varargin)
% This class should not display any information about its structure.
%
% This code is part of a batch job configuration system for MATLAB. See 
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id: disp.m 269 2008-05-23 07:15:10Z glauche $

rev = '$Rev: 269 $'; %#ok

disp(class(varargin{1}))