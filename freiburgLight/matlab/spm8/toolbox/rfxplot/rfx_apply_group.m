function gdata = rfx_apply_group(data,opts)
%
% sort data into specified groups
% -------------------------------------------------------------------------
% $Id: rfx_apply_group.m 6 2009-04-07 14:20:52Z vglauche $

global defs

try
  for g = 1:opts.ngroup
    
    gdata{g} = [];
    
    for s = 1:length(opts.group{g})
      sub = opts.group{g}(s);
      
      if strcmp(opts.task,'effect') || strcmp(opts.task,'fitresp')
        gdata{g}(s,:) = cat(2,data(sub).effect{:});
      elseif strcmp(opts.task,'psth')
        for e = 1:length(data(sub).psth)
          for b = 1:length(data(sub).psth(e).bin)
            gdata{g,e,b}(s,:) = data(sub).psth(e).bin(b).psth;
          end
        end
      end
    end
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

return;
