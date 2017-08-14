function files = rfx_lselect(dir,filt)
%
% usage: tbxrfx_lselect(dir,filt)
% 
% wrapper script for spm_select('list',...) which
% returns the full path names, ...
%
% because the original spm_select('list'...) only returns 
% the filenames (without paths). How annoying!
% -------------------------------------------------------------------------
% $Id: rfx_lselect.m 2 2009-01-19 15:12:13Z vglauche $

files = spm_select('list',dir,filt);
dirs = repmat([spm_select('cpath',dir)],size(files,1),1);
files = strcat(dirs,filesep,deblank(files));
