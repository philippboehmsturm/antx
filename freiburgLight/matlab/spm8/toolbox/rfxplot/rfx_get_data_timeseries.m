function data = rfx_get_data_timeseries(FFXvx,opts,sxyz,FFXeff,rfximg,rfxcon,SPM)
%
% extract data from a vol struct save in ts(:).VY
% -------------------------------------------------------------------------
% $Id: rfx_get_data_timeseries.m 6 2009-04-07 14:20:52Z vglauche $

% In preparation of the time series, first apply filter
% This (and the adjustments in rfx_adjust_timeseries) operates
% on the full time series. Session-wise data are "cut out" after
% filtering and adjustment options have been applied

global defs ts des

try
  nSub = length(des);
  
  fprintf('\n');
  tic;
  for s = 1:nSub
    fprintf('%-43s',sprintf('Extracting time courses for subject %02d ...',s));
    
    data(s).rfxxyz    = opts.xyz;
    data(s).rfximg    = rfximg;
    data(s).rfxcon    = rfxcon;
    if strcmp(opts.space,'mask')
      if length(opts.mask) == nSub
        data(s).rfxspace = spm_str_manip(opts.mask{s},'t');
      else
        data(s).rfxspace = spm_str_manip(opts.mask{1},'t');
      end
    else
      data(s).rfxspace  = opts.space;
    end
    data(s).rfxdim    = opts.dim;
    if opts.limit
      data(s).limit   = 'suprathreshold RFX voxels';
    else
      data(s).limit   = 'all RFX voxels';
    end
    data(s).maxxyz    = sxyz{s};
    data(s).maxeffect = FFXeff{s};
    data(s).xyz       = SPM.xVol.M * [FFXvx{s}; ones(1,size(FFXvx{s},2))];
    data(s).limtype   = opts.limtype;
    data(s).ffxsphere = opts.ffxsphere;
    data(s).regressor = opts.selname;
    data(s).filter    = opts.filter;
    data(s).adjust    = opts.adjust;
    if strcmp(opts.scale,'pcnt')
      data(s).scale   = 'pcnt signal change';
    elseif strcmp(opts.scale,'es')
      data(s).scale   = 'effect size';
    end
    
    if ~exist(ts(s).VY(1).fname,'file')
      disp(sprintf('Cannot locate time series of subject %d',s));
    end
    
    y = rfx_get_data(ts(s).VY,FFXvx{s});
    
    data(s).raw   = y;
    
    % filter entire time series
    switch opts.filter
      case 'hpf'
        y = spm_filter(des(s).xX.K,y);
      case 'ar1'
        y = des(s).xX.W*y;
      case 'both'
        y = spm_filter(des(s).xX.K,des(s).xX.W*y);
    end
    
    data(s).filt = y;
    if s < nSub
      fprintf('%s',repmat(sprintf('\b'),1,43));
    end
  end
  tim = toc;
  if tim > 60
    fprintf('done (%1.2f min).\n',tim/60);
  else
    fprintf('done (%1.1f sec).\n',tim);
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
