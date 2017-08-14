function ret = spm_ov_normalise_disp(varargin)
%
% This routine is a plugin to spm_orthviews for SPM5. For general help about
% spm_orthviews and plugins type
%             help spm_orthviews
% at the matlab prompt.
%_______________________________________________________________________
%
% @(#) $Id: spm_ov_normalise_disp.m 712 2010-06-30 14:20:19Z glauche $

rev = '$Revision: 712 $';

global st;
if isempty(st)
  error(['%s: This routine can only be called as a plugin for' ...
	 ' spm_orthviews!'], mfilename);
end;

if nargin < 2
  error(['%s: Wrong number of arguments. Usage:' ...
	 ' spm_orthviews(''normalise_disp'', cmd, volhandle, varargin)'], ...
	mfilename);
end;

cmd = lower(varargin{1});
volhandle = varargin{2};
files = [];

switch cmd
  
        %-------------------------------------------------------------------------
        % Context menu and callbacks
    case 'context_menu'
	% do nothing
	% this plugin is intended to be set up using tbxvol_normalise_disp
    case 'redraw'
        % do nothing
otherwise    
        fprintf('spm_orthviews(''extract'', ...): Unknown action %s', cmd);
end;
