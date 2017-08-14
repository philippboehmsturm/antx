function rfxplot(rfxxyz,opts,SPM,xSPM)
%
% this is the caller function of the rfxplot toolbox
%
% this function
% 1. checks for some necessary variables in the base workspace
% 2. checks for some suport programs
% 3. sets up the defaults (menus and stuff)
% 4. checks for previous plot configurations
% 5. calls rfx_main which handles the user input
% -------------------------------------------------------------------------
% $Id: rfxplot.m 16 2010-07-15 12:38:50Z volkmar $

try
  % do some checks on support functions and load defaults
  rfx_check;
  rfx_defaults;
  
  % setup error handling
  global defs;
  defs.errmsg = 0;
  defs.saverr = 0;
  
  if evalin('base','exist(''rfx_debug'',''var'')')
    rfx_debug = evalin('base','rfx_debug');
    defs.debug = rfx_debug;
  end
  if defs.debug
    if exist('rfx_error.txt','file')
      delete('rfx_error.txt')
    end
    diary rfx_error.txt;
    diary on;
  end
    
  % parse input args
  if nargin < 4
    input_xSPM = false;
  else
    input_xSPM = true;
  end
  
  if nargin < 3
    input_SPM = false;
  else
    input_SPM = true;
  end
  
  if nargin < 2
    input_opts = false;
  else
    input_opts = true;
  end
  
  if nargin < 1
    input_xyz = false;
  else
    input_xyz = true;
  end
  rfxroot = spm_str_manip(which('rfxplot'),'h');
  revision = textread(fullfile(rfxroot,'REVISION'),'%d');
  comp = computer; 
  % STARTUP MESSAGE (similar to spm('fnbanner',...)
  tmp = clock;
  tim = sprintf('%02d:%02d:%02d - %02d/%02d/%4d',...
    tmp(4),tmp(5),floor(tmp(6)),tmp(3),tmp(2),tmp(1));
  %str = sprintf('rfxplot (v%s)',version);
  str = sprintf('rfxplot (Rev %d)',revision);
  wid = 72;
  lch = '=';
  
  fprintf('\n%s',str);
  fprintf('%c',repmat(' ',1,wid-length([str,tim])));
  fprintf('%s\n%s',tim);
  % now SPM and MATLAB version
  spmver  = sprintf('%s : %s',comp,spm('ver'));
  mlabver = sprintf('MATLAB %s',version);
  fprintf('%s',spmver);
  fprintf('%c',repmat(' ',1,wid-length([spmver,mlabver])))
  fprintf('%s\n',mlabver);
  fprintf('%c',repmat(lch,1,wid)),fprintf('\n')
  
  % Check for inconsistency between revsion and MATLAB version
  v = version;
  if revision >= 19 && spm_matlab_version_chk('7.5') < 0
    fprintf('RFXPLOT (Rev %d) requires MATLAB 7.5 (R2007b) or higher. Bailing out.\n',revision);
    return;
  end
  
  % Check for necessary variables in workspace
  if ~input_SPM
    if evalin('base','exist(''SPM'',''var'')')
      SPM = evalin('base','SPM');
    else
      disp(['No SPM struct found in workspace. Please start SPM and open an analysis'])
      disp(['via "Results".']);
      return;
    end
  end
  
  if isfield(SPM,'Sess')
    disp('The current analysis is not an RFX analysis. Please open');
    disp('a second level analysis via the "Results" button.');
    return;
  end
  
  if ~input_xSPM
    if evalin('base','exist(''xSPM'',''var'')')
      xSPM = evalin('base','xSPM');
    else
      disp(['No xSPM found in workspace. Please open and analysis ' ...
        ' via "Results".']);
      return;
    end
    if evalin('base','exist(''hReg'',''var'')')
      hReg = evalin('base','hReg');
    else
      disp(['No hReg found in workspace. Please open and analysis ' ...
        ' via "Results".']);
      return;
    end
  end
  
  % do we have a plot configuration?
  if ~input_opts
    has_opts = evalin('base','exist(''opts'',''var'')');
    has_optsmat = exist(fullfile(SPM.swd,'rfx_opts.mat'),'file');
    
    % check for previous plot configuration
    if has_opts
      reuse = spm_input('Re-use previous plot config?',1,'y/n',[1 0],1);
      if reuse
        opts = evalin('base','opts');
      else
        opts = rfx_setup_opts;
      end
    else
      reuse = 0;
      opts = rfx_setup_opts;
    end
  else
    reuse = 1;
  end
  
  % use a saved plot configuration
  if ~reuse && has_optsmat
    if spm_input('Use saved plot configutation?',1,'y/n',[1 0],1)
      load(fullfile(SPM.swd,'rfx_opts.mat'));
      str   = cellstr(strvcat('none',opts(:).name));
      tmp   = spm_input('Select plot configuration',1,'m',str,0:length(str)-1);
      if tmp == 0
        reuse = 0;
        opts = rfx_setup_opts;
      else
        opts  = opts(tmp);
        reuse = 1;
      end
    end
  end
  
  % use current RFX analysis for accessing FFX data?
  if ~reuse
    if length(SPM.swd) > 50
      str = strcat('...',SPM.swd(end-49:end));
    else
      str = SPM.swd;
    end
    spm_input(str,1,'d');
    if spm_input('Use this RFX analysis?',...
        2,'y/n',[1 0],1)
      if isfield(SPM,'Sess')
        spm('alert*','This is not an RFX analysis. Bailing out.');
        return;
      end
      opts.rfxdir = SPM.swd;
    else
      origSPM = SPM;
      load(spm_select(1,'SPM.mat','Select alternative SPM.mat as RFX analysis.'));
      if isfield(SPM,'Sess')
        spm('alert*','This is not an RFX analysis. Bailing out.');
        return;
      end
      opts.rfxdir = SPM.swd;
    end
  else
    if ~strcmp(SPM.swd,fullfile(opts.rfxdir,'SPM.mat'))
      origSPM = SPM;
      load(fullfile(opts.rfxdir,'SPM.mat'))
      if isfield(SPM,'Sess')
        spm('alert*','This is not an RFX analysis. Bailing out.');
        return;
      end
    end
  end
  
  fprintf('RFX analysis:\n');
  fprintf('%s\n',SPM.swd);
  
  % call rfx_main to do the work ...
  if ~input_xSPM && ~input_opts
    [data,opts] = rfx_main(SPM,xSPM,hReg,opts,reuse);
  else
    [data,opts] = rfx_main(SPM,xSPM,rfxxyz,opts,reuse);
  end
  
  if exist('origSPM','var') && ~strcmp(origSPM.swd,SPM.swd)
    SPM = origSPM;
  end
  
  assignin('base','SPM',SPM);
  assignin('base','data',data);
  assignin('base','opts',opts);
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
