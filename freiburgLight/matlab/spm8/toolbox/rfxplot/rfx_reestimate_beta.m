function data = rfx_reestimate_beta(data,opts,index,FFXvx)
%
% re-estimates the parameter(s) for a discretized parametric
% modulation, e.g. a binarized value regressor (low vs high value),
% as pure onset regressor. The event are binned according to the
% specified thresholds.
%
% The original regressor (onset + pm, or parametric user regressor)
% are removed from the design matrix and new onset regressors are
% inserted. The betas are then re-estimated using OLS.
% -------------------------------------------------------------------------
% $Id: rfx_reestimate_beta.m 13 2010-07-15 08:38:20Z volkmar $

global defs des imgs has_prctile has_quantile;

try
  for s = 1:length(data)
    for r = 1:length(opts.select)
      regtype = opts.regtype{r};
      bintype = opts.bintype{r};
      binnum  = opts.nbin{r};
      thresh  = opts.binthresh{r};
      
      nx = index.n(s,opts.select(r));
      sx = index.s(s,opts.select(r));
      ux = index.u(s,opts.select(r));
      px = index.p(s,opts.select(r));
      bx = index.b(s,opts.select(r));
      hx = index.h(s,opts.select(r));
      
      % set beta{r} to NaN if effect is missing for this subject
      if isnan(nx)
        beta{r} = ones(binnum,1)*NaN;
        continue;
      end
      
      % extract session constant for selected voxels (for pcnt sig change)
      if strcmp(opts.scale,'pcnt')
        cnum = des(s).xX.iB(sx);
        const = spm_sample_vol(imgs(s).beta(cnum),FFXvx{s}(1,:),...
          FFXvx{s}(2,:),FFXvx{s}(3,:),0);
        const = mean(const);
      end
      
      % check if pmod is a user regressors
      if strcmp(regtype,'pmod')
        if binnum > 1 && (ux == 0)
          disp('It seems that your parametric modulator was manually defined')
          disp('(i.e. not within the conditions framework of SPM, but as a')
          disp('user regressor). Please contact me at glascher@hss.caltech.edu')
          disp('for a solution.')
          return;
          %file = spm_select(1,'mat','Select .mat file with pmod specs');
          %load(file);
          %val = pmod(ux).val; % think about the layout of pmod (put session in)
          %ons = pmod(ux).ons;
          %dur = pmod(ux).dur;
        else
          val = des(s).Sess(sx).U(ux).P(px).P.^hx;
          ons = des(s).Sess(sx).U(ux).ons;
          dur = des(s).Sess(sx).U(ux).dur;
          if isscalar(dur); dur = dur*ones(size(ons));end
        end
      else
        ons = des(s).Sess(sx).U(ux).ons;
        dur = des(s).Sess(sx).U(ux).dur;
        if isscalar(dur); dur = dur*ones(size(ons));end
      end
      
      if ~isempty(thresh)
        clear tmp ind lb ub
        count = 0;
        avail = ones(1,length(thresh))*NaN;
        for t = 1:length(thresh)
          switch bintype
            case 'pct'
              if has_prctile
                thresh{t} = thresh{t} * 100;
                lb(t) = prctile(val,thresh{t}(1));
                ub(t) = prctile(val,thresh{t}(2));
              elseif has_quantile
                lb(t) = quantile(val,thresh{t}(1));
                ub(t) = quantile(val,thresh{t}(2));
              end
              if t == 1
                ind{t} = find(val>=lb(t)&val<=ub(t));
              else
                ind{t} = find(val>lb(t)&val<=ub(t));
              end
            case 'num'
              if ~isempty(strfind(thresh{t},'end'))
                thresh{t} = strrep(thresh{t},'end',num2str(length(ons)));
              end
              ind{t} = eval(thresh{t});
            case 'val'
              lb(t) = thresh{t}(1);
              ub(t) = thresh{t}(2);
              ind{t} = find(val>lb(t)&val<=ub(t));
          end
          if ~isempty(ind{t})
            avail(t) = 1;
            count = count + 1;
            tmp.Sess.U(count).name = cellstr(sprintf('reg%d',t));
            tmp.Sess.U(count).ons  = ons(ind{t});
            tmp.Sess.U(count).dur  = dur(ind{t});
            tmp.Sess.U(count).P(1).name = 'none';
          end
          tmp.xBF   = des(s).xBF; % take the original basis set and onset timings
          tmp.nscan = des(s).nscan(sx);
        end
      else
        clear tmp
        tmp.Sess.U(1).name = {'dummy'};
        tmp.Sess.U(1).ons  = ons;
        tmp.Sess.U(1).dur  = dur;
        tmp.Sess.U(1).P(1).name = 'none';
        tmp.xBF   = des(s).xBF;
        tmp.nscan = des(s).nscan(sx);
      end
      
      % micro-time onsets for new regressors
      U = spm_get_ons(tmp,1);
      % design matrix for new regressors
      X = spm_Volterra(U,tmp.xBF.bf,1);
      k = tmp.nscan;
      % resample to specified time resolution
      X = X([0:(k - 1)]*tmp.xBF.T + tmp.xBF.T0 + 32,:);
      row = des(s).Sess(sx).row;
      
      % apply ar(1) filter if configured
      if strcmp(opts.filter,'ar1') || strcmp(opts.filter,'both')
        X = des(s).xX.W(row,row)*X;
      end
      
      % reestimate betas
      xX = spm_sp('set',X);
      pX = spm_sp('x-',xX);
      
      if size(data(s).Y,1) > 1
        btmp = pX*data(s).Y{r,sx};
      else
        btmp = pX*data(s).Y{sx};
      end
      
      if strcmp(opts.task,'effect') && strcmp(opts.scale,'pcnt')
        % check if we have uniform event durations
        for u = 1:length(tmp.Sess.U)
          du(u) = all(tmp.Sess.U(u).dur==tmp.Sess.U(u).dur(1));
        end
        if any(du~=1)
          disp('Warning: Re-estimated regressors contain events with');
          disp('unequal durations. Using duration of first event.');
        end
        
        % create a regressor with a single event
        tmp2.Sess.U.name = {'dummy'};
        tmp2.Sess.U.ons  = 1;
        tmp2.Sess.U.dur  = tmp.Sess.U(1).dur(1);
        tmp2.Sess.U.P.name = 'none';
        tmp2.xBF = tmp.xBF; % use the current basis set
        tmp2.nscan = 100;
        
        % create regressor
        U2 = spm_get_ons(tmp2,1);
        X2 = spm_Volterra(U2,tmp2.xBF.bf,1);
        
        % scale to PSC (but respect multiple BFs)
        nbf  = size(tmp2.xBF.bf,2);
        for nb = 1:opts.nbin{r}
          if ~isnan(avail(nb))
            if btmp(1) >= 0
              beta{r}(nb) = (max(X2*btmp(1:nbf)) .* 100) ./ const;
            else
              beta{r}(nb) = (min(X2*btmp(1:nbf)) .* 100) ./ const;
            end              
            btmp(1:nbf) = [];
          else
            beta{r}(nb) = NaN;
          end
        end
      else
        tmp3 = avail;
        tmp3(~isnan(tmp3)) = tmp3(~isnan(tmp3)) .* btmp(:)';
        beta{r} = tmp3;
      end
      
    end % opts.select
    
    % evaluate replications
    if ~isempty(opts.repl)
      for r = 1:max(opts.repl)
        ind = find(opts.repl==r);
        for t = 1:size(beta{ind(1)}(:),1)
          y = [];
          for i = 1:length(ind)
            y = [y beta{ind(i)}(t)];
          end
          data(s).effect{r}(t) = nanmean(y);
        end
      end
    else
      for r = 1:length(beta)
        data(s).effect{r} = beta{r};
      end
    end
  end % subjects
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
