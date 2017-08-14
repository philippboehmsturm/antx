function rfx_defaults
%
% set up some defaults
% -------------------------------------------------------------------------
% $Id: rfx_defaults.m 13 2010-07-15 08:38:20Z volkmar $

global defs has_prctile has_quantile;

% USER CONFIGURATION SECTION ==============================================
defs.renderer = 'opengl';
defs.savemat.timeseries = true;
defs.savemat.images     = true;
defs.savemat.design     = true;

% download this toolbox at http://www.cyceron.fr/freeware/
defs.aal.display = 1;
defs.aal.image = '/usr/local/apps/spm5/toolbox/aal/ROI_MNI_V4.img';
defs.aal.table = '/usr/local/apps/spm5/toolbox/aal/ROI_MNI_V4.txt';
%defs.aal.image = '/home/glaescher/templates/aal.img';
%defs.aal.table = '/home/glaescher/templates/aal.txt';

defs.debug = 0;

% END USER CONFIGURATION SECTION ==========================================

if ~exist(defs.aal.image,'file') || ~exist(defs.aal.table,'file')
  defs.aal.display = 0;
end

% --- MENUS ---------------------------------------------------------------

% task menu
defs.task.menu = ...
    {'plot effect sizes (e.g. parameter estimates)',...
     'plot fitted event-related responses',...
     'plot PSTH (aka event-related time courses)',...
     'just extract data'};
defs.task.tag  = {'effect','fitresp','psth','extract'};
defs.task.val  = 1;

% voxel selection menu
defs.voxel.menu = ...
  {'select single-subject peak voxel in RFX search volume',...
   'define sphere around single-subject peak',...
   'select all voxels in RFX search volume'};
defs.voxel.tag  = {'peakffx','sphereffx','allrfx'};
defs.voxel.val  = 3;

defs.mask.menu = ...
  {'peak voxel in single-subject masks',...
   'all voxels in singel-subject masks'};
defs.mask.tag  = {'peakmask','allmask'};
defs.mask.val  = 2;

defs.adjust.menu = ...
  {'no adjustment','block effects (aka session constants)',...
   'block and nuisance effects (e.g. mvmt regressors)',...
   'all other regressors (except those selected)',...
   'specify manually (only if all designs are exactly identical)',...
   'F-contrast (only if present in all 1st level designs)'};
defs.adjust.tag = {'none','block','nuis','all','user','con'};
defs.adjust.val = 3; 

if has_prctile || has_quantile
  defs.bintype.menu = ...
    {'Percentile range (lower/upper thresholds)',...
     'Value range (lower/upper thresholds)',...
     'Trial range (vector of trial numbers)'};
  defs.bintype.tag = {'pct','val','num'};
  defs.bintype.val = 1;
else
  defs.bintype.menu = ...
    {'Value range (lower/upper thresholds)',...
     'Trial range (vector of trial numbers)'};
  defs.bintype.tag = {'val','num'};
  defs.bintype.val = 1;
end  

defs.color.menu1 = ...
  {'different colors for effects',...
   'different colors for bins',...
   'all columns manually'};
 defs.color.tag1 = {'effect','bin','manual'};
 defs.color.val1 = 1;

 defs.color.menu2 = ...
  {'different colors for effects',...
   'all columns manually'};
 defs.color.tag2 = {'effect','manual'};
 defs.color.val2 = 1;

 defs.scale.menu = ...
   {'Percent signal change','effect size (arbirary units)'};
 defs.scale.tag = {'pcnt','es'};
 defs.scale.val = 1;
 
 defs.fit.menu = ...
   {'linear: y = ax + b','quadratic: y = ax^2 + bx + c',...
    'exponential: y = a+b*exp(c*x)','logarithmic: y =a+b*log(x^c)'};
 defs.fit.tag = {'lin','quad','exp','log'};
 defs.fit.val = 1; 
