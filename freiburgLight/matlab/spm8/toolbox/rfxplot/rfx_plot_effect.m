function rfx_plot_effect(gdata,opts,xyzstr,limstr,dimstr)
%
% plots the effects
% -------------------------------------------------------------------------
% $Id: rfx_plot_effect.m 13 2010-07-15 08:38:20Z volkmar $

global defs

try
  % standard color definitions
  stdcol(1,:) = {'r',[1 0 0]};
  stdcol(2,:) = {'g',[0 1 0]};
  stdcol(3,:) = {'b',[0 0 1]};
  stdcol(4,:) = {'c',[0 1 1]};
  stdcol(5,:) = {'m',[1 0 1]};
  stdcol(6,:) = {'y',[1 1 0]};
  stdcol(7,:) = {'k',[0 0 0]};
  stdcol(8,:) = {'w',[1 1 1]};
  
  darkest = 0.4;
  
  % xtick and xticklabels
  xtlabel = {};
  elabel  = {};
  % xtick, etick, gtick, and labels
  xtick = opts.xtick;
  if all(cat(2,opts.nbin{:})>1)
    xtlabel = cat(2,opts.binnames{:});
    elabel = opts.reglabel;
    tot = 0;
    for e = 1:length(opts.reglabel)
      if ~isempty(opts.repl)
        ix = find(opts.repl==e,1);
      else
        ix = e;
      end
      ind = tot+1:tot+opts.nbin{ix};
      xt  = opts.xtick(ind);
      etick(e) = xt(1)+(xt(end)-xt(1))/2;
      tot = tot + opts.nbin{ix};
    end;
  elseif any(cat(2,opts.nbin{:})>1)
    tot = 0;
    for r = 1:length(opts.reglabel)
      if ~isempty(opts.repl)
        ix = find(opts.repl==r,1);
      else
        ix = r;
      end
      if opts.nbin{ix} > 1
        xtlabel = [xtlabel opts.binnames{r}];
        elabel  = [elabel opts.reglabel{r}];
      else
        xtlabel = [xtlabel {''}];
        elabel  = [elabel opts.reglabel{r}];
      end
      ind = tot+1:tot+opts.nbin{ix};
      xt  = opts.xtick(ind);
      etick(r) = xt(1)+(xt(end)-xt(1))/2;
      tot = tot + opts.nbin{ix};
    end
  else
    xtlabel = opts.reglabel;
    elabel = {};
    etick = [];
  end
  % group label
  if opts.ngroup > 1
    glabel = opts.gname;
    gtick  = opts.xtick(1) + (opts.xtick(end)-opts.xtick(1))/2;
  else
    glabel = {};
    gtick = [];
  end
  
  
  % colors
  cols   = {};
  if strcmp(opts.coltype,'effect')
    for e = 1:length(opts.reglabel)
      if opts.nbin{e} > 1
        if opts.colgrad
          if ischar(opts.color{e})
            tmp = strmatch(opts.color{e},stdcol(:,1));
            if ~isempty(tmp)
              scol = stdcol{tmp,2};
            else
              disp('Unknown color specification. Choosing red as default.');
              scol = [1 0 0];
            end
          else
            scol = opts.color{e};
          end
          lightest = max(scol);
          rg = lightest - darkest;
          step = rg ./ (opts.nbin{e}-1);
          grad = darkest:step:lightest;
          for b = 1:opts.nbin{e}
            cl = scol .* grad(b);
            cl(cl<0) = 0; cl(cl>1) = 1;
            cols{end+1} = cl;
          end
        else
          for b = 1:opts.nbin{e}
            cols{end+1} = opts.color{e};
          end
        end
      else
        cols{end+1} = opts.color{e};
      end
    end
  elseif strcmp(opts.coltype,'bin')
    for e = 1:length(opts.reglabel)
      for b = 1:opts.nbin{e}
        cols{end+1} = opts.color{b};
      end
    end
  elseif strcmp(opts.coltype,'manual')
    cols = opts.color;
  end
  % sanity check
  if ~isequal(length(cols),size(gdata{1},2))
    error('Mismatch between num effect and num colors.');
  end
  
  if opts.ngroup > 1
    fitgtick{1} = xtick;
    for g = 2:opts.ngroup
      offset  = max(xtick)+2;
      cols    = [cols cols];
      xtlabel = [xtlabel xtlabel];
      if ~isempty(elabel); elabel = [elabel elabel]; end
      if ~isempty(etick); etick = [etick offset+etick]; end
      if ~isempty(gtick); gtick = [gtick offset+gtick]; end
      xtick = [xtick offset+opts.xtick];
      fitgtick{g} = offset + xtick;
    end
  else
    fitgtick{1} = xtick;
  end
  
  % === PLOTTING ===========================================================
  
  % setup axes
  if ~strcmp(opts.where,'spm')
    eval(['fhdl = ' opts.where ';']);
    if isempty(get(fhdl,'children')) % no axes yet (and none specified in opts.where)
      hdl = axes;
      hold on;
    else
      hdl = gca;
      hold on;
    end
  else
    % setup SPM windows
    Fgraph = spm_figure('GetWin','Graphics');
    spm_results_ui('Clear',Fgraph);
    fhdl = Fgraph;
    figure(Fgraph)
    hdl = subplot(2,2,3:4);
  end
  
  % plot the data
  for g = 1:opts.ngroup
    ind = (g-1)*size(gdata{g},2) + [1:size(gdata{g},2)];
    switch opts.error
      case 'sd'
        S = 0;
      case 'sem'
        S = 1;
      case 'ci'
        S = 2;
      otherwise
        S = -1;
    end
    if opts.sublabel
      rfx_plot_error(gdata{g},[],xtick(ind),opts.plottype,S,cols,opts.errcol,...
        opts.overlay,opts.group{g});
    else
      rfx_plot_error(gdata{g},[],xtick(ind),opts.plottype,S,cols,opts.errcol,...
        opts.overlay);
    end
  end
  
  % fit regression lines
  if ~isempty(opts.fit)
    reg = rfx_fit_regression(gdata,opts,fitgtick);
    assignin('base','reg',reg);
  end
  
  set(hdl,'xlim',[xtick(1)-1 xtick(end)+1]);
  set(hdl,'xtick',xtick);
  set(hdl,'box','on');
  pos = get(hdl,'position');
  pos(4) = pos(4) - 0.04; %make some room for the 2-line title
  if ~isempty(etick) && ~isempty(gtick)
    set(hdl,'fontsize',8);
    efs = 10;
    gfs = 12;
    if ~strcmp(opts.where,'spm')
      pos(2) = pos(2) + 0.04;
      pos(4) = pos(4) - 0.04;
    end
    set(hdl,'position',pos);
    yl  = get(hdl,'ylim');
    ey     = yl(1) - (yl(2)-yl(1))/8;
    gy     = yl(1) - (yl(2)-yl(1))/6;
  elseif ~isempty(etick) || ~isempty(gtick)
    set(hdl,'fontsize',10);
    efs = 12;
    gfs = 12;
    if ~strcmp(opts.where,'spm')
      pos(2) = pos(2) + 0.02;
      pos(4) = pos(4) - 0.02;
    end
    set(hdl,'position',pos);
    yl  = get(hdl,'ylim');
    ey     = yl(1) - (yl(2)-yl(1))/8;
    gy     = yl(1) - (yl(2)-yl(1))/8;
  else
    set(hdl,'fontsize',12);
  end
  
  % figure out axis labeling
  set(hdl,'xticklabel',xtlabel,'box','on');
  if ~isempty(etick)
    for e = 1:length(etick)
      text(etick(e),ey,elabel{e},'fontsize',efs,'fontweight','bold',...
        'horizontalalignment','center','verticalalignment','middle');
    end
  end
  if ~isempty(gtick)
    for g = 1:length(gtick)
      text(gtick(g),gy,glabel{g},'fontsize',gfs,'fontweight','bold',...
        'fontangle','italic','horizontalalignment','center',...
        'verticalalignment','middle');
    end
  end
  
  % title and ylabel
  str0 = ''; str1 =''; str2 = ''; str3 = '';
  switch lower(opts.prefix)
    case 'beta'
      if strcmp(opts.scale,'pcnt')
        str0 = 'Percent Signal Change';
        ylabel('Percent Signal Change');
      else
        str0 = 'Parameter Estimate';
        ylabel('Parameter Estimate (a.u.)');
      end
    case 'con'
      str0 = 'Contrast Estimate';
      ylabel('Contrast Estimate (a.u.)');
    case 'resms'
      str0 = 'Residual Mean Square';
      ylabel('Residual Mean Square');
    case 'spmt'
      str0 = 'T-value';
      ylabel('T-value');
    case 'spmf'
      str0 = 'F-value';
      ylabel('F-value');
    case 'ess'
      str0 = 'Extra Sum of Squares';
      ylabel('Extra sum of Squares');
    otherwise
      str0 = sprintf('Intensity in %s images',opts.prefix);
      ylabel('Image Intensity');
  end
  
  if ~strcmp(opts.error,'none')
    %   str1 = sprintf(' %s (errors: %s)',xyzstr,opts.error);
    str1 = sprintf(' %s',xyzstr);
  else
    str1 = sprintf(' %s',xyzstr);
  end
  
  if strcmp(opts.limtype,'peakffx')
    str2 = 'Individual peaks ';
  elseif strcmp(opts.limtype,'sphereffx')
    str2 = sprintf('Individual %1.1fmm spheres ',opts.ffxsphere);
  elseif ~isempty(strfind(opts.limtype,'mask'))
    str2 = sprintf('Individual masks (%s)',spm_str_manip(opts.mask{1},'t'));
  elseif strcmp(opts.limtype,'allrfx')
    str2 = limstr;
  end
  if strcmp(opts.limtype,'peakffx') || strcmp(opts.limtype,'sphereffx')
    str3 = sprintf('within RFX search volume (%s)',dimstr);
  end
  
  if ~strcmp(opts.where,'spm')
    title(sprintf('%s%s',str0,xyzstr),'fontsize',14)
  else
    title(sprintf('%s%s\n%s%s',str0,str1,str2,str3),'fontsize',14)
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

