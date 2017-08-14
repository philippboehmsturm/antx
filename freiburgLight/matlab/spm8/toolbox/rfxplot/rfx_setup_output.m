function rfx = rfx_setup_output
%
% setup rfx output struct
% ------------------------------------------------------------------------
% $Id: rfx_setup_output.m 6 2009-04-07 14:20:52Z vglauche $

global defs

try
  rfx.xyz        = [];
  rfx.space      = '';
  rfx.image      = '';
  rfx.conname    = '';
  rfx.dim        = [];
  rfx.limtype    = '';
  rfx.ffxsphere  = [];
  rfx.regressor  = [];
  rfx.scale      = '';
  
  rfx.data.xyz           = [];
  rfx.data.maxeffect     = [];
  rfx.data.filter        = '';
  rfx.data.adjust        = '';
  rfx.data.raw           = [];
  rfx.data.filt          = [];
  rfx.data.adjust        = [];
  rfx.data.tc            = [];
  rfx.data.Y             = {};
  rfx.data.prefix        = [];
  rfx.data.effect        = [];
  
  rfx.effect             = {};
  
  rfx.psth.bin.psth      = [];
  rfx.psth.bin.sem       = [];
  rfx.psth.bin.ci        = [];
  rfx.psth.bin.pst       = [];
  
  rfx.reg.group.type     = '';
  rfx.reg.group.y        = [];
  rfx.reg.group.yhat     = [];
  rfx.reg.group.param    = [];
  rfx.reg.group.ssq      = [];
  
  rfx.reg.sub.type       = '';
  rfx.reg.sub.y          = [];
  rfx.reg.sub.yhat       = [];
  rfx.reg.sub.param      = [];
  rfx.reg.sub.ssq        = [];
  
  rfx.opts               = struct;
  
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