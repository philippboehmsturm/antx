function [data,opts] = rfx_main(SPM,xSPM,hReg,opts,reuse)
%
% the main function of the rfxplot toolbox for SPM5. For help on
% installation and usage, please consult the accompanying manual
% file.
%
%
% This function manages the acquisition of various user inputs
% and calls different toolbox function to do the actual work...
% -------------------------------------------------------------------------
% $Id: rfx_main.m 13 2010-07-15 08:38:20Z volkmar $

global defs has_resample;

try
  % get coordinates (always get them, even when reusing)
  if ishandle(hReg)
    XYZmm = spm_XYZreg('GetCoords',hReg);
    XYZmm = XYZmm(:);
    opts.xyz = XYZmm';
  else
    opts.xyz = hReg(:)';
  end
  xyzstr = sprintf(' at %g %g %g',opts.xyz(1),opts.xyz(2),opts.xyz(3));
  
  % determine what to do?
  if ~reuse
    opts.task = spm_input('What do you want to do?',1,'m',...
      defs.task.menu,defs.task.tag,defs.task.val);
    opts.task = opts.task{1};
  end
  
  if defs.aal.display
    V   = spm_vol(defs.aal.image);
    [num,aallab,longnum] = textread(defs.aal.table,'%s%s%d');
    vx = inv(V.mat)*[opts.xyz 1]';
    aalind = spm_sample_vol(V,vx(1),vx(2),vx(3),0);
    if aalind > 2000
      i = find(longnum==aalind);
      xyzstr = strcat(xyzstr,' (',aallab{i},')');
    elseif aalind > 0
      xyzstr = strcat(xyzstr,' (',aallab{aalind},')');
    end
  end
  
  % ========================================================================
  % SELECT IMAGES AND DEFINE SEARCH VOLUMES
  % ========================================================================
  % what images to work on?
  if ~reuse || isempty(opts.prefix)
    if strcmp(opts.task,'psth') || strcmp(opts.task,'fitresp')
      opts.prefix = 'beta';
    else
      opts.prefix = spm_input('File prefix',...
        1,'b','beta|con|other',{'beta','con','other'},1);
      if strcmp(opts.prefix{1},'other')
        opts.prefix = spm_input('Enter file prefix',1,'s',[]);
      else
        opts.prefix = opts.prefix{1};
      end
    end
  end
  
  % what search volume?
  if ~reuse || isempty(opts.space)
    opts.space = spm_input('RFX search volume...',1,'m',...
      {'Single Voxel',['Sphere ',xyzstr],['Box ',xyzstr],'Mask Image'},...
      {'voxel','sphere','box','image'});
    opts.space = opts.space{1};
    
    switch opts.space
      
      case 'voxel'
        opts.dim  = [];
        opts.mask = '';
        dimstr = 'single voxel';
      case 'sphere'
        opts.dim  = spm_input('Radius of RFX sphere {mm}',1);
        opts.mask = '';
        dimstr = sprintf('%0.1fmm sphere',opts.dim);
      case 'box'
        opts.dim  = spm_input('Box dimensions [x y z] {mm}',1);
        opts.mask = '';
        dimstr = sprintf('%0.1fx%0.1fx%0.1fmm box',opts.dim(1),...
          opts.dim(2),opts.dim(3));
      case 'image'
        opts.dim = [];
        opts.mask = {};
        nSub = size(unique(spm_str_manip(strvcat(SPM.xY.P{:}),'h'),'rows'),1);
        if spm_input('Individual masks',1,'y/n',[1 0],0);
          opts.mask = cellstr(spm_select(nSub,'image','Select individual mask images'));
        else
          opts.mask = cellstr(spm_select(1,'image','Select RFX mask image (for all subjects)'));
        end
        dimstr = sprintf('image mask: %s',spm_str_manip(opts.mask{1},'t'));
    end
    
    % Limit to supra-threshold voxels
    if strcmp(SPM.swd,xSPM.swd)
      if ~strcmp(opts.space,'voxel')
        if strcmp(opts.space,'image') && length(opts.mask) > 1
          opts.limtype = spm_input('Select',1,'m',...
            defs.mask.menu,defs.mask.tag,defs.mask.val);
        else % sphere or box or image(rfx mask)
          opts.limit = spm_input('Limit to suprathreshold voxels?',...
            1,'y/n',[1 0],2);
          opts.limtype = spm_input('Voxel selection',1,'m',...
            defs.voxel.menu,defs.voxel.tag,defs.voxel.val);
          opts.limtype = opts.limtype{1};
        end
      end
      % radius for individual spheres
      if strcmp(opts.limtype,'sphereffx')
        opts.ffxsphere = spm_input('Radius of single-subject sphere {mm}',1);
        opts.ffxlimit  = spm_input('Limit to RFX search volume?',1,'y/n',[1 0],1);
      end
    end
  else
    switch opts.space
      case 'voxel'
        dimstr = 'single voxel';
      case 'sphere'
        dimstr = sprintf('%0.1fmm sphere',opts.dim);
      case 'box'
        dimstr = sprintf('%0.1fx%0.1fx%0.1fmm box',opts.dim(1),...
          opts.dim(2),opts.dim(3));
      case 'image'
        dimstr = sprintf('image mask: %s',spm_str_manip(opts.mask{1},'t'));
    end
  end
  
  % get FFX directories and designs
  dirs = rfx_get_dirs(SPM);
  des = rfx_get_design(dirs,opts);
  
  % get volume handles for images
  imgs = rfx_get_vol_img(dirs,opts);
  
  nSub = length(des);
  
  % compile a list of image descriptions
  [dlist,dnum,index] = rfx_get_description(imgs,opts);
  
  % table for interactive image selection
  if ~reuse || isempty(opts.select)
    if strcmp(opts.space,'image')
      titstr = sprintf('(%s)',dimstr);
    else
      titstr = sprintf('(%s%s)',dimstr,xyzstr);
    end
    rfx_display_img_table(dlist,dnum,opts,titstr);
    if ~strcmp(opts.task,'psth')
      opts.select = spm_input(...
        'Index number(s) for effects plot',1,'e',[]);
      opts.selname = cellstr(dlist(opts.select));
    else
      opts.select = spm_input(...
        'Index number(s) for time course plot',1,'e',[]);
      opts.selname = cellstr(dlist(opts.select));
    end
  end
  
  if ~reuse || isempty(opts.regtype)
    for f = 1:length(opts.select)
      if strcmp(opts.prefix,'beta')
        opts.regtype{f} = spm_input(...
          sprintf('Regressor type of index %d',opts.select(f)),1,...
          'b','onset|pmod',{'reg' 'pmod'});
        opts.regtype(f) = opts.regtype{f};
      else
        opts.regtype{f} = opts.prefix;
      end
    end
  end
  
  % replications
  if ~reuse || isempty(opts.reglabel)
    if strcmp(opts.prefix,'beta')
      if length(opts.select) > 1 && spm_input('Are selected regs replications?',...
          1,'y/n',[1 0],0);
        opts.repl = spm_input('Indicate replications',1,'e',[],...
          [1,length(opts.select)]);
        for r = 1:max(opts.repl)
          ind = find(opts.repl==r);
          rtype = opts.regtype{ind(1)};
          for i = 1:length(ind)
            if ~strcmp(opts.regtype{ind(i)},rtype)
              disp('Trying to combine different regressor types. Bailing out.')
              return;
            end
          end
          lab = 'Label for repl. effect %d (%s)';
          opts.reglabel{r} = spm_input(sprintf(lab,r,opts.regtype{r}),1,'s');
        end
      else
        opts.repl = [];
        for e = 1:length(opts.select)
          lab = 'Label for effect %d (%s)';
          opts.reglabel{e} = spm_input(sprintf(lab,e,opts.regtype{e}),1,'s');
        end
      end
    else
      opts.repl = [];
      for e = 1:length(opts.select)
        lab = 'Label for effect %d (con)';
        opts.reglabel{e} = spm_input(sprintf(lab,e),1,'s',opts.selname{e});
      end
    end
  end
  
  % obtain RFX voxel indices
  [XYZvx,limstr] = rfx_get_voxel(SPM,xSPM,opts);
  if ~isempty(strfind(opts.limtype,'mask'))
    [FFXvx,FFXeff,rfximg,sxyz] = rfx_get_ffx_voxel_mask(SPM,xSPM,opts);
  else
    [FFXvx,FFXeff,rfximg,sxyz] = rfx_get_ffx_voxel_max(XYZvx,SPM,xSPM);
    if strcmp(opts.limtype,'sphereffx')
      FFXvx = rfx_get_ffx_voxel_sphere(opts,SPM,FFXvx,XYZvx,nSub);
    elseif strcmp(opts.limtype,'allrfx')
      for s = 1:nSub
        sxyz{s} = SPM.xVol.M * [FFXvx{s}; 1];
        sxyz{s} = sxyz{s}(1:3)';
        FFXvx{s} = XYZvx;
      end
    end
  end
  
  % ========================================================================
  % SPLIT REGRESSORS INTO BINS
  % ========================================================================
  % get configuration for splitting regressors
  if ~reuse || isempty(opts.nbin)
    % Are images replicated?
    if ~isempty(opts.repl)
      R = max(opts.repl); rep = 1;
    else
      R = length(opts.select); rep = 0;
    end
    
    for r = 1:R
      % If so, find indices for current replication
      if rep
        i = find(opts.repl==r);
        len = length(i);
      else
        i = r;
        len = length(i);
      end
      
      % splitting of pmod for beta images only
      if strcmp(opts.prefix,'beta')
        str = 'Split %s into n bins (1=none)';
        opts.nbin(i) = repmat({spm_input(sprintf(str,opts.reglabel{r}),1,'e',[])},1,len);
        
        if all(cat(2,opts.nbin{i})>1)
          if strcmp(opts.regtype{i(1)},'pmod')
            opts.bintype(i) = repmat({spm_input('Specify bins as',1,'m',...
              defs.bintype.menu,defs.bintype.tag,defs.bintype.val)},1,len);
            for k=1:len
              opts.bintype(i(k)) = opts.bintype{i(k)};
            end
          else
            opts.bintype(i) = repmat({'num'},1,len);
          end
          
          switch opts.bintype{i(1)}
            case {'pct','val'}
              str  = sprintf('%d threshold(s) for %s',opts.nbin{r}*2,opts.reglabel{r});
              nstr = sprintf('%d bin names for %s',opts.nbin{r},opts.reglabel{r});
              fstr = repmat('%f',1,opts.nbin{i(1)}*2);
            case 'num'
              str = sprintf('%d trial ranges for %s',opts.nbin{r},opts.reglabel{r});
              nstr = sprintf('%d bin names for %s',opts.nbin{r},opts.reglabel{r});
              fstr = repmat('%s',1,opts.nbin{i(1)});
          end
          
          thrsh = strtrim(spm_input(str,1,'s',[]));
          if ~isempty(strfind(thrsh,'|'));delim='|';else delim=' ';end
          out = textscan(thrsh,fstr,'delimiter',delim);
          if ~strcmp(opts.bintype{r},'num')
            for k = 1:len
              for nb = 1:opts.nbin{i(1)}
                opts.binthresh{i(k)}{nb} = cell2mat(out((nb-1)*2+[1:2]));
              end
            end
          else
            for k = 1:len
              for nb = 1:opts.nbin{i(1)}
                opts.binthresh{i(k)}{nb} = out{nb}{:};
                %opts.binthresh{r}{nb} = out{nb}{:};
              end
            end
          end
          
          nam = strtrim(spm_input(sprintf(nstr,opts.nbin{r},r),1,'s',[]));
          fstr = repmat('%s',1,opts.nbin{i(1)});
          if ~isempty(strfind(nam,'|'));delim='|';else delim=' ';end
          names = textscan(nam,fstr,'delimiter',delim);
          %for k = 1:len
          for nb = 1:opts.nbin{i(1)}
            %opts.binnames{i(k)}{nb} = names{nb}{:};
            opts.binnames{r}{nb} = names{nb}{:};
          end
          %end
        else
          opts.bintype(i)   = repmat({'none'},1,len);
          opts.binthresh(i) = repmat({[]},1,len);
          opts.binnames{r}  = '';
          %opts.binnames(i)  = repmat({''},1,len);
        end
      else
        opts.nbin(i)      = repmat({0},1,len);
        opts.bintype(i)   = repmat({'none'},1,len);
        opts.binthresh(i) = repmat({[]},1,len);
        opts.binnames{r}  = '';
        %opts.binnames(i)  = repmat({''},1,len);
      end
    end
  end
  
  % ========================================================================
  % SELECT SUBJECT OR DEFINE GROUPS
  % ========================================================================
  % split sample into groups?
  if ~reuse || isempty(opts.group)
    rfx_display_subj_table(dirs,opts,xyzstr);
    if spm_input('Split sample into groups?',1,'y/n',[1 0],2)
      opts.ngroup = spm_input('Enter number of groups',1,'e');
      for g = 1:opts.ngroup
        opts.gname{g} = spm_input(sprintf('Enter name for group %d',g),1,'s','');
        opts.group{g} = spm_input(sprintf('Subject numbers for "%s"',...
          opts.gname{g}),1,'e',[]);
      end
    else
      opts.group{1} = spm_input('Subjects numbers to include',1,'s',...
        sprintf('1:%d',length(dirs)));
      opts.group{1} = eval(strcat('[',opts.group{1},']'));
    end
  end
  
  % ========================================================================
  % USER INPUT: FILTER, ADJUSTMENT, PSTH WINDOWS
  % ========================================================================
  % filter and adjustment (only if nbins > 1)
  if ~reuse
    if any(cat(2,opts.nbin{:})>1) || strcmp(opts.task,'extract') || strcmp(opts.task,'psth')
      opts.filter = spm_input('Apply SPM design filters?',1,'b',...
        'none|HPF|AR(1)|both',{'none','hpf','ar1','both'},4);
      opts.filter = opts.filter{1};
      opts.adjust   = spm_input('Adjust data for ...',1,'m',...
        defs.adjust.menu,defs.adjust.tag,defs.adjust.val);
      opts.adjust = opts.adjust{1};
      if strcmp(opts.adjust,'user')
        rfx_display_img_table(dlist,dnum,opts,xyzstr);
        opts.indiX0 = spm_input('Enter indices for adjustments',1,'e');
      elseif strcmp(opts.adjust,'con')
        cons = {}; conno = [];
        for cn = 1:length(des(1).xCon)
          if strcmp(des(1).xCon(cn).STAT,'F')
            cons{end+1} = des(1).xCon(cn).name;
            conno(end+1) = cn;
          end
        end
        rfx_display_con_table(cons,opts,xyzstr);
        tmp = spm_input('Index number for adjustment contrast',1,'e',[]);
        opts.iX0 = des(1).xCon(conno(tmp)).iX0;
      end
    end
  end
  
  % psth configuration
  if ~reuse || isempty(opts.winbound)
    if strcmp(opts.task,'psth')
      opts.winbound = spm_input('PSTH win bounds (wrt ons=0) (s)',1,'e',[]);
      if opts.winbound(1) < 0
        opts.winlength = abs(opts.winbound(1)) + opts.winbound(2);
      else
        opts.winlength = opts.winbound(2) - opts.winbound(1);
      end
      %opts.winlength = length(opts.winbound(1):opts.winbound(2));
      opts.binwidth = spm_input('PSTH bin width (s)',1,'e',des(1).xX.K(1).RT);
      if has_resample && opts.binwidth ~= des(1).xX.K(1).RT
        opts.resample = spm_input(sprintf('Resample data to %1.1f sec?',...
          opts.binwidth),1,'y/n',[1 0],1);
      end
      opts.rescale = spm_input('Rescale PSTH to 0 at onset',1,'y/n',[1 0],1);
    end
  end
  
  % scale configuration
  if ~reuse
    % check if all selected images have bf(1) in their names -> compute PSC
    % with full basis set (see rfx_get_data_img)
    tmp = strfind(opts.selname,'bf(1)');
    for f=1:length(tmp);if isempty(tmp{f});tmp{f}=NaN;end;end
    if strcmp(opts.task,'effect') && strcmp(opts.prefix,'beta') && ...
        ~strcmp(opts.adjust,'none') && all(~isnan(cat(2,tmp{:})))
      opts.scale = spm_input('Plot data as',1,'m',...
        defs.scale.menu,defs.scale.tag,defs.scale.val);
      opts.scale = opts.scale{1};
    end
  end
  
  % export opts struct to workspace
  assignin('base','opts',opts);
  
  % ========================================================================
  % EXTRACT DATA AND ESTIMATE EFFECTS OR PSTH
  % ========================================================================
  if strcmp(opts.task,'psth') || strcmp(opts.task,'extract')
    rfx_get_vol_timeseries(dirs,opts);
    data = rfx_get_data_timeseries(FFXvx,opts,sxyz,FFXeff,rfximg,xSPM.title,SPM);
    [data,opts] = rfx_adjust_timeseries(data,opts,index,FFXvx);
    if strcmp(opts.task,'psth')
      data = rfx_compute_psth(data,opts,index);
    end
  elseif strcmp(opts.task,'effect') || strcmp(opts.task,'fitresp')
    if strcmp(opts.prefix,'beta')
      if any(cat(2,opts.nbin{:})> 1)
        rfx_get_vol_timeseries(dirs,opts);
        data = rfx_get_data_timeseries(FFXvx,opts,sxyz,FFXeff,rfximg,xSPM.title,SPM);
        [data,opts] = rfx_adjust_timeseries(data,opts,index,FFXvx);
        data = rfx_reestimate_beta(data,opts,index,FFXvx);
      else
        data = rfx_get_data_img(FFXvx,opts,index,sxyz,FFXeff,rfximg,xSPM.title,SPM);
      end
    else
      data = rfx_get_data_img(FFXvx,opts,index,sxyz,FFXeff,rfximg,xSPM.title,SPM);
    end
  end
  
  % apply group parcellation
  if ~strcmp(opts.task,'psth')
    gdata = rfx_apply_group(data,opts);
    assignin('base','gdata',gdata);
    if strcmp(opts.task,'extract')
      return;
    end
  end
  
  % ========================================================================
  % CONFIGURE PLOT OPTIONS
  % ========================================================================
  if ~reuse || isempty(opts.where)
    % where to plot
    if  spm_input('Plot data where?',1,'b','SPM|other',[0 1],0)
      opts.where = spm_input('axes command (eg figure(5))',1,'s');
    else
      opts.where = 'spm';
    end
    
    if strcmp(opts.task,'effect')
      
      % plot type ?
      opts.plottype = spm_input('Plot data as ...',1,'b','bar|dot|dotline',...
        [],1);
      
      % error bars
      opts.error = spm_input('Error bars are ...',1,'b','none|sd|sem|CI',...
        {'none','sd','sem','ci'},3);
      opts.error = opts.error{1};
      
      opts.errtype = 'bar';
      
      % error bar color
      if ~strcmp(opts.error,'none')
        opts.errcol = spm_input('Error bar color',1,'b','same|black',{'s','k'},2);
        opts.errcol = opts.errcol{1};
      else
        opts.errcol = 's';
      end
      
      % color specs
      if strcmp(opts.prefix,'beta')
        if any(cat(2,opts.nbin{:})> 1)
          opts.coltype = spm_input('Specify colors as ...',1,'m',...
            defs.color.menu1,defs.color.tag1,defs.color.val1);
        else
          opts.coltype = spm_input('Specify colors as ...',1,'m',...
            defs.color.menu2,defs.color.tag2,defs.color.val2);
        end
      else
        opts.coltype = spm_input('Specify colors as ...',1,'m',...
          defs.color.menu2,defs.color.tag2,defs.color.val2);
      end
      opts.coltype = opts.coltype{1};
      
      switch opts.coltype
        case 'effect'
          if ~isempty(opts.repl)
            ncol = max(opts.repl);
          else
            ncol = length(opts.reglabel);
          end
        case 'bin'
          for l=1:length(data(1).effect);len(l)=length(data(1).effect{l});end
          if ~all(len==len(1))
            disp('Warning: Unequal number of bin for different effects.')
          end
          ncol = max(len);
        case 'manual'
          ncol = size(gdata{1},2);
      end
      str = '%d color specs';
      col = strtrim(spm_input(sprintf(str,ncol),1,'s'));
      fstr = repmat('%s',1,ncol);
      if ~isempty(strfind(col,'|'));delim='|';else delim=' ';end
      cols = textscan(col,fstr,'delimiter',delim);
      for nb = 1:ncol
        opts.color{nb} = cols{nb}{:};
        if ~isempty(strfind(opts.color{nb},'['))
          opts.color{nb} = eval(opts.color{nb});
        end
      end
      
      if strcmp(opts.coltype,'effect') && any(cat(2,opts.nbin{:})>1)
        opts.colgrad = spm_input('Color gradient for bins',1,'y/n',...
          [1 0],1);
      else
        opts.colgrad = 0;
      end
      
      % XTicks
      if opts.ngroup > 1
        opts.xtick = spm_input('XTick (1 group only)',1,'e',[],...
          [1,size(gdata{1},2)]);
      else
        opts.xtick = spm_input('Specify XTick positions',1,'e',[],...
          [1,size(gdata{1},2)]);
      end
      
      % overlay individual data
      opts.overlay = spm_input('Overlay individual data?',1,'y/n',...
        [1 0],0);
      
      % omit subject labels in overlay
      if opts.overlay
        opts.sublabel = spm_input('Include subject numbers?',1,'y/n',...
          [1 0],1);
      end
      
      % Fit regression to data
      if spm_input('Fit regression curve(s) to data?',1,'y/n',[1 0],0);
        tot = 0;
        for n = 1:length(opts.reglabel)
          str = sprintf('%s: %d bins (columns %d:%d)',opts.reglabel{n},...
            opts.nbin{n},tot+1,tot+opts.nbin{n});
          tot = tot + opts.nbin{n};
          spm_input(str,n,'d');
        end
        line = n+1;
        nfit = spm_input('How many regressions?',line,'e');
        for n = 1:nfit
          opts.fit{n} = spm_input(sprintf('Regression %d: which columns',n),...
            line,'e');
          opts.fitfun{n} = spm_input('Type of regression',line,'m',...
            defs.fit.menu,defs.fit.tag,defs.fit.val);
          opts.fitfun{n} = opts.fitfun{n}{1};
          opts.fitcol{n} = spm_input('Color of regression line',line,'s');
        end
      else
        opts.fit = {};
        opts.fitfun = {};
        opts.fitcol = {};
      end
      % === PSTH and fitted responses ============================================================
    elseif strcmp(opts.task,'psth') || strcmp(opts.task,'fitresp')
      opts.plottype = opts.task;
      % error bars
      opts.error = spm_input('Error bars are ...',1,'b','none|sd|sem|90% CI',...
        {'none','sd','sem','ci'},3);
      opts.error = opts.error{1};
      
      % error type
      opts.errtype = spm_input('Plot errors as ...',1,'b','line|area',[],2);
      opts.errcol = 's';
      
      % color specs
      if any(cat(2,opts.nbin{:})> 1)
        opts.coltype = spm_input('Specify colors as ...',1,'m',...
          defs.color.menu1,defs.color.tag1,defs.color.val1);
      else
        opts.coltype = spm_input('Specify colors as ...',1,'m',...
          defs.color.menu2,defs.color.tag2,defs.color.val2);
      end
      opts.coltype = opts.coltype{1};
      str = '%d color specs';
      switch opts.coltype
        case 'effect'
          if ~isempty(opts.repl)
            ncol = max(opts.repl);
          else
            ncol = length(opts.select);
          end
        case 'bin'
          ncol = max(cat(2,opts.nbin{:}));
        case 'manual'
          ncol = size(gdata{1},2)*size(gdata{1},3);
      end
      str = '%d color specs';
      col = strtrim(spm_input(sprintf(str,ncol),1,'s'));
      fstr = repmat('%s',1,ncol);
      if ~isempty(strfind(col,'|'));delim='|';else delim=' ';end
      cols = textscan(col,fstr,'delimiter',delim);
      for nb = 1:ncol
        opts.color{nb} = cols{nb}{:};
        if ~isempty(strfind(opts.color{nb},'['))
          opts.color{nb} = eval(opts.color{nb});
        end
      end
      
      if strcmp(opts.coltype,'effect') && any(cat(2,opts.nbin{:})>1)
        opts.colgrad = spm_input('Color gradient for bins',1,'y/n',...
          [1 0],1);
      else
        opts.colgrad = 0;
      end
    end
  end
  
  % save plot configuration
  if ~isfield(opts,'name') || isempty(opts.name)
    if spm_input('Save plot configuration?',1,'y/n',[1 0],1)
      opts.name = spm_input('Enter name for plot configuration',...
        1,'s',[]);
      if exist(fullfile(opts.rfxdir,'rfx_opts.mat'),'file')
        cfg = load(fullfile(opts.rfxdir,'rfx_opts.mat'));
        cfg.opts(end+1) = opts;
        bkg = opts; clear opts;
        opts = cfg.opts;
        save(fullfile(opts(1).rfxdir,'rfx_opts.mat'),'opts');
        clear opts; opts = bkg;
      else
        save(fullfile(opts.rfxdir,'rfx_opts.mat'),'opts');
      end
    end
  end
  
  % export opts strcut to workspace
  assignin('base','opts',opts);
  
  % plot the data
  if strcmp(opts.task,'effect')
    rfx_plot_effect(gdata,opts,xyzstr,limstr,dimstr);
  elseif strcmp(opts.task,'fitresp')
    rfx_plot_fitresp(gdata,opts,index,xyzstr,limstr,dimstr);
  elseif strcmp(opts.task,'psth')
    rfx_plot_psth(data,opts,xyzstr,limstr,dimstr);
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
