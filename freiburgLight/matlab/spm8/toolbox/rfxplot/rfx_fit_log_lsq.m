function [ssq,yhat] = rfx_fit_log_lsq(p,x,y)
%
% fit logarithmic curve to data using OLS
% -------------------------------------------------------------------------
% $Id: rfx_fit_log_lsq.m 6 2009-04-07 14:20:52Z vglauche $

global defs

try
  yhat = p(1) + p(2) * log(x.^p(3));
  if nargin == 3
    ssq = sum((y-yhat).^2);
  else
    ssq = NaN;
  end
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