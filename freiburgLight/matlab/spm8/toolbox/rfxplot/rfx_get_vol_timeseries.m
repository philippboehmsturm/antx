function rfx_get_vol_timeseries(dirs,opts)
%
% loads or compiles a struct with the volume handles to
% BOLD time series and places it into global workspace
% -------------------------------------------------------------------------
% $Id: rfx_get_vol_timeseries.m 6 2009-04-07 14:20:52Z vglauche $

global ts rfxts defs;

try
  nSub = length(dirs);
  
  if ~strcmp(rfxts,opts.rfxdir)
    ts = [];
  end
  
  if isempty(ts)
    try
      fprintf('Loading image handles from rfx_timeseries.mat ... ');
      tic;
      load(fullfile(opts.rfxdir,'rfx_timeseries.mat'));
      tim = toc;
      if tim > 60
        fprintf('done (%1.2f min).\n',tim/60);
      else
        fprintf('done (%1.1f sec).\n',tim);
      end
    catch
      fprintf('failed. (Don''t worry.)\n')
      fprintf('Creating rfx_timeseries.mat ...\n');
      ts = struct;
      tic;
      for s = 1:nSub
        fprintf('%-40s',sprintf('Compiling image handles for subject %02d',s));
        load(fullfile(dirs{s},'SPM.mat'));
        ts(s).RT = SPM.xY.RT;
        ts(s).VY = SPM.xY.VY;
        fprintf('%s',repmat(sprintf('\b'),1,40));
      end
      tim = toc;
      if tim > 60
        fprintf('completed in %1.2f min.\n',tim/60);
      else
        fprintf('completed in %1.1f sec.\n',tim);
      end
      if defs.savemat.timeseries
        tic;
        fprintf('\nSaving image handles in rfx_timeseries.mat ... ')
        save(fullfile(opts.rfxdir,'rfx_timeseries.mat'),'ts');
        tim = toc;
        if tim > 60
          fprintf('done (%1.2f min).\n',tim/60);
        else
          fprintf('done (%1.1f sec).\n',tim);
        end
      else
        fprintf('\nAbort saving rfx_timeseries.mat at user request.\n');
      end
    end
  end
  
  rfxts = opts.rfxdir;
  
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
