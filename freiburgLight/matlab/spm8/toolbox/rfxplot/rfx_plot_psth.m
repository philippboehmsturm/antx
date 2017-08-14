function rfx_plot_psth(data,opts,xyzstr,limstr,dimstr)
%
% compute and plot average time course
% -------------------------------------------------------------------------
% $Id: rfx_plot_psth.m 13 2010-07-15 08:38:20Z volkmar $

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
  
  darkest = 0.5;
  
  % compile color etc. from options
  cols   = {};
  if strcmp(opts.coltype,'effect')
    for e = 1:length(opts.color)
      if opts.nbin{e} > 1
        tmp = strmatch(opts.color{e},stdcol(:,1));
        if ~isempty(tmp)
          scol = stdcol{tmp,2};
        else
          scol = opts.color{e};
        end
        lightest = max(scol);
        rg = lightest - darkest;
        step = rg ./ (opts.nbin{e}-1);
        grad = darkest:step:lightest;
        for b = 1:opts.nbin{e}
          cols{end+1} = scol.*grad(b);
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
  
  cnt = 0;
  for g = 1:opts.ngroup
    for r = 1:length(opts.reglabel)
      for b = 1:opts.nbin{r}
        cnt = cnt + 1;
        if opts.nbin{r} == 1
          if opts.ngroup > 1
            leg{cnt} = sprintf('%s: %s',opts.gname{g},opts.reglabel{r});
          else
            leg{cnt} = sprintf('%s',opts.reglabel{r});
          end
        else
          if opts.ngroup > 1
            leg{cnt} = sprintf('%s: %s - %s',opts.gname{g},...
              opts.reglabel{r},opts.binnames{r}{b});
          else
            leg{cnt} = sprintf('%s: %s',opts.reglabel{r},opts.binnames{r}{b});
          end
        end
        for s = 1:length(opts.group{g})
          tc{cnt}(s,:) = data(opts.group{g}(s)).psth(r).bin(b).psth;
        end
      end
    end
  end

  if opts.ngroup > 1
    cols = repmat(cols,1,opts.ngroup);
  end
  
  % sanity check
  if ~isequal(length(tc),length(cols))
    error('Mismatch between number of color and number of time courses')
  end
  
  % now do the plotting
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
    Fgraph = spm_figure('GetWin','Graphics');
    spm_results_ui('Clear',Fgraph);
    fhdl = Fgraph;
    figure(Fgraph)
    hdl = subplot(2,2,3:4);
    hold on;
  end
  
  if strcmp(opts.errtype,'area')
    set(fhdl,'renderer',defs.renderer);
  else
    set(fhdl,'renderer','painters');
  end
  
  pst = data(1).psth(1).bin(1).pst;
  
  for t = 1:length(tc)
    M = nanmean(tc{t});
    plot(pst,M,'linestyle','-','color',cols{t},'linewidth',2);
  end
  
  for t = 1:length(tc)
    M = nanmean(tc{t});
    switch opts.error
      case 'sd'
        S = nanstd(tc{t});
      case 'sem'
        S = nansem(tc{t});
      case 'ci'
        S = nansem(tc{t}) * spm_invNcdf(0.95);
      case 'none'
        S = [];
    end
    if ~strcmp(opts.error,'none')
      if strcmp(opts.errtype,'line')
        plot(pst,[M+S],'linestyle','-.','color',cols{t},'linewidth',1);
        plot(pst,[M-S],'linestyle','-.','color',cols{t},'linewidth',1);
      elseif strcmp(opts.errtype,'area')
        x = [pst pst(end:-1:1)];
        y = [M-S M(end:-1:1)+S(end:-1:1)];
        p = patch(x,y,cols{t});
        set(p,'facealpha',0.2,'edgecolor',cols{t});
      end
    end
  end
  
  legend(leg,'location','best')
  
  set(hdl,'xlim',[floor(pst(1))-1 ceil(pst(end))+1]);
  set(hdl,'xtick',[floor(pst(1)):ceil(pst(end))]);
  set(hdl,'xticklabel',[floor(pst(1)):ceil(pst(end))]);
  
  % adjust axis size
  set(hdl,'box','on');
  pos = get(hdl,'position');
  pos(4) = pos(4) - 0.04; %make some room for the 2-line title
  set(hdl,'position',pos);
  
  % axis labels
  ylabel('Evoked Response');
  xlabel('Seconds');
  
  % title issues
  str1 =''; str2 = ''; str3 = '';
  if ~strcmp(opts.error,'none')
    %   str1 = sprintf('Peri-Stimulus Time Histogram %s (errors: %s)',xyzstr,opts.error);
    str1 = sprintf('Peri-Stimulus Time Histogram %s',xyzstr);
  else
    str1 = sprintf('Peri-Stimulus Time Histogram %s',xyzstr);
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
  elseif strcmp(opts.limtype,'allrfx')
    str3 = sprintf('in RFX search volume (%s)',dimstr);
  end
  
  if ~strcmp(opts.where,'spm')
    title(sprintf('BOLD response %s',xyzstr),'fontsize',14)
  else
    title(sprintf('%s\n%s%s',str1,str2,str3),'fontsize',14)
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
