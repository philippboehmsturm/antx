function opts = rfx_setup_opts
%
% setup the opts struct for plot configuration
% -------------------------------------------------------------------------
% $Id: rfx_setup_opts.m 6 2009-04-07 14:20:52Z vglauche $

global defs

try
  opts.rfxdir    = '';      % 2nd level analysis directory
  opts.xyz       = [];      % rfx coordinates (world space)
  opts.task      = '';      % 'effect' 'psth' fitresp' 'extract'
  opts.prefix    = '';      % image prefix
  opts.space     = '';      % rfx search volume: 'voxel' 'sphere' 'box' 'image'
  opts.dim       = [];      % rfx search volume dimensions
  opts.mask      = '';      % rfx mask image (opts.space == 'image')
  opts.limit     = 0;       % only suprathreshold voxels
  opts.limtype   = 'allrfx';% 'peakffx' 'sphereffx' 'allrfx'
  opts.ffxsphere = 0;       % radius of single subject spheres ('sphereffx')
  opts.ffxlimit  = 0;       % limit FFX sphere to RFX search volume
  opts.select    = [];      % index of selected images
  opts.selname   = cell(0); % regressor name of selected images
  opts.regtype   = cell(0); % 'reg' 'pmod'
  opts.repl      = [];      % regressors replicated
  opts.reglabel  = cell(0); % labels for regressors
  opts.nbin      = cell(0); % number of bins (splitting of pmod)
  opts.bintype   = cell(0); % 'pct' 'val' 'num'
  opts.binthresh = cell(0); % thresholfs for bins
  opts.binnames  = cell(0); % names for bins
  opts.ngroup    = 1;       % number of groups
  opts.group     = cell(0); % subject indices for groups
  opts.gname     = {''};    % group names
  opts.filter    = 'none';  % 'none' 'hpf' 'ar(1)' 'both'
  opts.indiX0    = [];      % indices for user-secified adjustments
  opts.adjust    = 'block'; % 'none' 'block' 'nuis' 'all' ...
  opts.winbound  = [];      % psth window boundary
  opts.winlength = [];      % psth window length (automatically)
  opts.binwidth  = [];      % psth bin width
  opts.resample  = 0;       % resample time series
  opts.rescale   = 0;       % rescale to 0 at simt onset?
  opts.scale     = 'es';    % 'es' (effect size) 'pcnt'
  opts.where     = '';      % 'spm' or axis command
  opts.plottype  = '';      %
  opts.overlay   = 0;       % overlay individual subject data
  opts.sublabel  = 1;       % include subject numbers
  opts.error     = '';      % 'none' 'sd' 'sem' 'ci'
  opts.errtype   = '';      % type of error ('bar','area')
  opts.errcol    = '';      % 's'ame 'blac'k'
  opts.coltype   = '';      % 'effect' 'bin'
  opts.color     = cell(0); % color specs
  opts.colgrad   = [];      % color gradient
  opts.xtick     = [];      % xticks
  opts.fit       = cell(0); % number of additional regressions
  opts.fitfun    = cell(0); % 'lin' 'quad' 'exp' log'
  opts.fitcol    = cell(0); % color of regression line
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
