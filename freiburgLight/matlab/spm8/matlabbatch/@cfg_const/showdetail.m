function str = showdetail(item)

% function str = showdetail(item)
% Display details for a cfg_const item.
%
% This code is part of a batch job configuration system for MATLAB. See 
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id: showdetail.m 557 2012-06-05 07:14:03Z glauche $

rev = '$Rev: 557 $'; %#ok

str = showdetail(item.cfg_item);
str{end+1} = ['This item has a constant value which can not be modified.'];
