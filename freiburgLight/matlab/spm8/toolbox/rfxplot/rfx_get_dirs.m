function dirs = rfx_get_dirs(SPM)
%
% extract a list of ffx directories from rfx analysis
% -------------------------------------------------------------------------
% $Id: rfx_get_dirs.m 6 2009-04-07 14:20:52Z vglauche $

global defs

try
  dirs = spm_str_manip(SPM.xY.P,'h');
  dirs = rfx_unique_unsorted(dirs);
catch me
  if defs.debug
    if ~defs.saverr
      e=1; while ~strcmp(me.stack(e).name(1:3),'rfx'); e=e+1; end
      fname = sprintf('%s_line%d.mat',me.stack(e).name,me.stack(e).line);
      save(fname);
      rfx_save_error(me,fname);
    end
  else
    rfx_error_message(me);
  end
end
return