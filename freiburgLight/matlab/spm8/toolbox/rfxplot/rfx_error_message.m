function rfx_error_message(me)
%
% outputs a "what to do next" in case of an error
%
% This function should be called within a catch statement
% -------------------------------------------------------------------------
% $Id: rfx_error_message.m 6 2009-04-07 14:20:52Z vglauche $

global defs

if ~defs.errmsg
  fprintf('\n');
  fprintf('------------------------------------------------------------------------\n');
  fprintf('RFXPLOT has terminated with an error. If you want to report this error,\n');
  fprintf('please type "rfx_debug = 1" at the MATLAB prompt and rerun rfxplot.\n');
  fprintf('------------------------------------------------------------------------\n');
  fprintf('ERROR MESSAGE:\n');
  fprintf('%s\n',me.message);
  fprintf('ERROR STACK:\n');
  for e = 1:length(me.stack)
    fprintf('%-8d%s\n',me.stack(e).line,me.stack(e).name);
  end
  fprintf('------------------------------------------------------------------------\n');
  defs.errmsg = 1;
end
