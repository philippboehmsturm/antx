function reg = rfx_fit_regression(gdata,opts,gtick)
%
% fits a use-specified regression to data
% -------------------------------------------------------------------------
% $Id: rfx_fit_regression.m 6 2009-04-07 14:20:52Z vglauche $

global defs

try
  for g = 1:length(gdata)
    
    for r = 1:length(opts.fit)
      x = 1:length(opts.fit{r});
      xval = x(1)-0.5:0.1:x(end)+0.5;
      
      switch opts.fitfun{r}
        case {'lin','quad'}
          if strcmp(opts.fitfun{r},'lin')
            e = 1;
          elseif strcmp(opts.fitfun{r},'quad')
            e = 2;
          end
          % first the individual fit
          for s = 1:size(gdata{g},1)
            reg(g).sub(s).type{r}  = opts.fitfun{r};
            reg(g).sub(s).y{r}     = gdata{g}(s,opts.fit{r});
            reg(g).sub(s).param{r} = polyfit(x,reg(g).sub(s).y{r},e);
            reg(g).sub(s).yhat{r}  = polyval(reg(g).sub(s).param{r},x);
            reg(g).sub(s).ssq{r}   = sum((reg(g).sub(s).y{r}-reg(g).sub(s).yhat{r}).^2);
          end
          % then the fit for the group
          reg(g).group.type{r}  = opts.fitfun{r};
          reg(g).group.y{r}     = nanmean(gdata{g}(:,opts.fit{r}));
          reg(g).group.param{r} = polyfit(x,reg(g).group.y{r},e);
          reg(g).group.yhat{r}  = polyval(reg(g).group.param{r},x);
          reg(g).group.ssq{r}   = sum((reg(g).group.y{r}-reg(g).group.yhat{r}).^2);
        case {'exp','log'}
          x0 = [1 1 1];
          if strcmp(opts.fitfun{r},'exp')
            fun = 'rfx_fit_exp_lsq';
          elseif strcmp(opts.fitfun{r},'log')
            fun = 'rfx_fit_log_lsq';
          end
          % first the individual fits
          for s = 1:size(gdata{g},1)
            reg(g).sub(s).type = opts.fitfun{r};
            reg(g).sub(s).y{r} = gdata{g}(s,opts.fit{r});
            reg(g).sub(s).param{r} = fminsearch(fun,x0,[],x,reg(g).sub(s).y{r});
            [tmp1,tmp2] = feval(fun,reg(g).sub(s).param{r},x,reg(g).sub(s).y{r});
            reg(g).sub(s).ssq{r} = tmp1;
            reg(g).sub(s).yhat{r} = tmp2;
          end
          % then the group fit
          reg(g).group.type = opts.fitfun{r};
          reg(g).group.y{r} = nanmean(gdata{g}(:,opts.fit{r}));
          reg(g).group.param{r} = fminsearch(fun,x0,[],x,reg(g).group.y{r});
          [tmp1,tmp2] = feval(fun,reg(g).group.param{r},x,reg(g).group.y{r});
          reg(g).group.ssq{r} = tmp1;
          reg(g).group.yhat{r} = tmp2;
      end
    end
  end
  
  % plot the regression in the figure
  for g = 1:length(gdata)
    for r = 1:length(opts.fit)
      switch opts.fitfun{r}
        case {'lin','quad'}
          ypnt = polyval(reg(g).group.param{r},xval);
        case 'exp'
          [tmp,ypnt] = rfx_fit_exp_lsq(reg(g).group.param{r},xval);
        case 'log'
          [tmp,ypnt] = rfx_fit_log_lsq(reg(g).group.param{r},xval);
      end
      tmp = gtick{g}(opts.fit{r});
      xpnt = tmp(1)-0.5:0.1:tmp(end)+0.5;
      plot(xpnt,ypnt,...
        'linewidth',2,'linestyle','-','color',opts.fitcol{r});
    end
  end
  
  assignin('base','reg',reg);
  
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
