function rfx_save_error(me,fname)
%
% this function save the erroneous function workspace to a .mat file and
% shut off the error log (diary). It also output as user message of what to
% do next.
%
% This function should be called within a catch statement
% -------------------------------------------------------------------------
% $Id: rfx_save_error.m 6 2009-04-07 14:20:52Z vglauche $

global defs

if ~defs.saverr
  fprintf('------------------------------------------------------------------------\n');
  fprintf('ERROR MESSAGE:\n');
  fprintf('%s\n',me.message);
  fprintf('ERROR STACK:\n');
  for e = 1:length(me.stack)
    fprintf('%-8d%s\n',me.stack(e).line,me.stack(e).name);
  end
  fprintf('------------------------------------------------------------------------\n');
  fprintf('RFXPLOT saved 2 debugging files (%s, rfx_error.txt)\n',fname);
  fprintf('in the directory: %s\n',pwd);
  fprintf('Please email these files to Jan Glascher (glascher@hss.caltech.edu)\n')
  fprintf('or use the dropbox (http://dropbox.caltech.edu) if the files are too\n')
  fprintf('large for email attachments.\n')
  fprintf('------------------------------------------------------------------------\n');
  diary off;
  defs.saverr = 1;
end

return;
