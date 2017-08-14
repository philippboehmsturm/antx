function rfx_plot_fitresp(gdata,opts,index,xyzstr,limstr,dimstr)
%
% compute and plot event-related fitted response
% -------------------------------------------------------------------------
% $Id: rfx_plot_fitresp.m 13 2010-07-15 08:38:20Z volkmar $

global des defs;

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
  
  % now compute the fitted response (plus errors)
  for g = 1:length(gdata)
    
    M = nanmean(gdata{g});
    M = M(:);
    switch opts.error
      case 'sd'
        S = nanstd(gdata{g});
      case 'sem'
        S = nansem(gdata{g});
      case 'ci'
        S = nansem(gdata{g})*spm_invNcdf(0.95);
      case 'none'
        S = [];
    end
    S = S(:);
    
    % Compute the fitted response from the mean betas
    clear tmp
    for r = 1:length(opts.reglabel)
      if ~isempty(opts.repl)
        ix = find(opts.repl==r,1);
      else
        ix = r;
      end
      
      sx = index.s(1,opts.select(ix));
      ux = index.u(1,opts.select(ix));
      
      % create a single event with the current durations
      % and basis set
      tmp.Sess.U.name = {'dummy'};
      tmp.Sess.U.ons  = 1;
      if strcmp(des(1).xBF.UNITS,'scans')
        tmp.Sess.U.dur  = des(1).Sess(sx).U(ux).dur(1) * des(1).RT;
      else
        tmp.Sess.U.dur  = des(1).Sess(sx).U(ux).dur(1);
      end
      tmp.Sess.U.P.name = 'none';
      tmp.xBF       = des(1).xBF; % use the current basis set
      tmp.xBF.dt    = 0.1; % but increase temporal resolution
      tmp.xBF.UNITS = 'secs';
      tmp.nscan     = 100; % some arbitrary number of scans
      
      % create regressor
      U = spm_get_ons(tmp,1);
      X = spm_Volterra(U,tmp.xBF.bf,1);
      
      step = size(tmp.xBF.bf,2);
      for b = 1:opts.nbin{r}
        fitresp{g}{r}{b} = X * M(1:step);
        if ~isempty(S)
          fiterru{g}{r}{b} = X * (M(1:step)+S(1));
          fiterrl{g}{r}{b} = X * (M(1:step)-S(1));
          %         fiterru{g}{r}{b}  = fitresp{g}{r}{b} + ...
          %           repmat(S(1),size(fitresp{g}{r}{b}));
          %         fiterrl{g}{r}{b}  = fitresp{g}{r}{b} - ...
          %           repmat(S(1),size(fitresp{g}{r}{b}));
        else
          fiterru{g}{r}{b} = []; fiterrl{r}{b} = [];
        end
        M(1:step) = []; if ~isempty(S); S(1:step) = []; end
        first = find(fitresp{g}{r}{b},1,'first'); % start of bf
        last  = find(fitresp{g}{r}{b},1,'last');  % end of bf
        fitresp{g}{r}{b} = fitresp{g}{r}{b}(first:last);
        if ~strcmp(opts.error,'none')
          fiterrl{g}{r}{b} = fiterrl{g}{r}{b}(first:last);
          fiterru{g}{r}{b} = fiterru{g}{r}{b}(first:last);
        end
      end
    end
    
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
    %set(fhdl,'renderer','painters');
  end
  
  cnt = 0; leg = {};
  for g = 1:length(gdata)
    for r = 1:length(opts.reglabel)
      for b = 1:opts.nbin{r}
        cnt = cnt + 1;
        hold on;
        plot(fitresp{g}{r}{b},...
          'linestyle','-','color',cols{cnt},'linewidth',2);
        if opts.nbin{r} == 1
          leg{end+1} = sprintf('%s',opts.reglabel{r});
        else
          leg{end+1} = sprintf('%s: %s',opts.reglabel{r},opts.binnames{r}{b});
        end
      end
    end
  end
  
  % error lines
  if ~strcmp(opts.error,'none')
    if strcmp(opts.errtype,'line')
      cnt = 0;
      for g = 1:length(gdata)
        for r = 1:length(opts.reglabel)
          for b = 1:opts.nbin{r}
            cnt = cnt + 1;
            plot(fiterru{g}{r}{b},'linestyle','-.','color',cols{cnt},'linewidth',1);
            plot(fiterrl{g}{r}{b},'linestyle','-.','color',cols{cnt},'linewidth',1);
          end
        end
      end
    elseif strcmp(opts.errtype,'area')
      cnt = 0;
      for g = 1:length(gdata)
        for r = 1:length(opts.reglabel)
          for b = 1:opts.nbin{r}
            cnt = cnt + 1;
            x = [1:length(fitresp{g}{r}{b}) length(fitresp{g}{r}{b}):-1:1];
            y = [fiterrl{g}{r}{b}' fiterru{g}{r}{b}(end:-1:1)'];
            p(b) = patch(x,y,cols{cnt});
            set(p(b),'facealpha',0.2,'edgecolor',cols{cnt},'linestyle','-.');
          end
        end
      end
    end
  end
  
  legend(leg,'location','best');
  
  set(hdl,'xlim',[0 length(fitresp{1}{1}{1})]);
  set(hdl,'box','on');
  xt = get(hdl,'xtick');
  xtl = xt/10;
  set(hdl,'xticklabel',xtl);
  
  % adjust axis size
  set(hdl,'box','on');
  pos = get(hdl,'position');
  pos(4) = pos(4) - 0.04; %make some room for the 2-line title
  set(hdl,'position',pos);
  
  % axis labels
  xlabel('Seconds')
  ylabel('Fitted Response')
  
  % title issues
  str1 =''; str2 = ''; str3 = '';
  if ~strcmp(opts.error,'none')
    % str1 = sprintf('Fitted Response %s (errors: %s)',xyzstr,opts.error);
    str1 = sprintf('Fitted Response %s',xyzstr);
  else
    str1 = sprintf('Fitted Response %s',xyzstr);
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
    title(sprintf('Fitted Response %s',xyzstr),'fontsize',14)
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
