function data = rfx_compute_psth(data,opts,index)
%
% computes per-stimulus time histograms for an
% entire sample
% -------------------------------------------------------------------------
% $Id: rfx_compute_psth.m 13 2010-07-15 08:38:20Z volkmar $

global defs des has_prctile has_quantile;

try
  for s = 1:length(data) % subjects
    
    fprintf('Computing event-related BOLD responses for subject %02d ... ',s);
    
    TR = des(s).RT;
    
    clear psth ci
    sem = cell(0);
    
    for r = 1:length(opts.select)
      
      sel = opts.select(r);
      
      nx = index.n(s,sel);
      sx = index.s(s,sel);
      ux = index.u(s,sel);
      px = index.p(s,sel);
      bx = index.b(s,sel);
      hx = index.h(s,sel);
      
      regtype = opts.regtype{r};
      bintype = opts.bintype{r};
      binnum  = opts.nbin{r};
      thresh  = opts.binthresh{r};
      
      % set psth to NaN if effect is missing for this subject
      if isnan(nx)
        len = round(opts.winlength/opts.binwidth)+1;
        for t = 1:binnum
          psth{r,t} = ones(1,len)*NaN;
          sem{r,t}  = ones(1,len)*NaN;
          ci{r,t}   = ones(1,len)*NaN;
        end
        continue;
      end
      
      % get data for from the session of the current selected regressor
      if strcmp(opts.adjust,'all')
        Y = data(s).Y{r,sx};
      else
        Y = data(s).Y{sx};
      end
      if opts.resample
        Y = resample(Y,TR*100,opts.binwidth*100,2);
      end
      
      
      % get onset and parametric values (if necessary)
      if strcmp(regtype,'pmod')
        % check if pmod is a user regressors
        if binnum > 1 && ux == 0
          file = spm_select(1,'mat','Select .mat file with pmod specs');
          load(file);
          val = pmod(ux).val; % think about the layout of pmod (put session in)
          ons = pmod(ux).ons;
          dur = pmod(ux).dur;
        else % get the onset and values from design structure
          val = des(s).Sess(sx).U(ux).P(px).P.^hx;
          ons = des(s).Sess(sx).U(ux).ons;
          dur = des(s).Sess(sx).U(ux).dur;
          if isscalar(dur); dur = dur*ones(size(ons));end
        end
      else % onset regressor
        ons = des(s).Sess(sx).U(ux).ons;
        dur = des(s).Sess(sx).U(ux).dur;
        if isscalar(dur); dur = dur*ones(size(ons));end
      end
      
      % convert onsets to seconds if necessary
      if strcmp(des(s).xBF.UNITS,'scans')
        ons = ons * TR;
      end
      
      % === adjust onsets to match reference slice in slice timed images
      % don't need this anymore, if we specify the FIR with T nad T0 from
      % the original design (see below), then the timings are all adjusted ...
      %adjust = des(s).xBF.T0/des(s).xBF.T * TR;
      %ons    = ons - adjust;
      
      % adjust onset to match psth window bounds (e.g. -2 secs before onset)
      ons    = ons + opts.winbound(1);
      
      % set up FIR basis set
      xBF.UNITS  = 'secs';
      % xBF.UNITS  = des(s).xBF.UNITS;
      xBF.T      = des(s).xBF.T;
      xBF.T0     = des(s).xBF.T0;
      if opts.resample
        xBF.dt   = opts.binwidth / xBF.T;
      else
        xBF.dt = des(s).xBF.dt;
      end
      xBF.name   = 'Finite Impulse Response';
      xBF.order  = round(opts.winlength/opts.binwidth)+1; % no of bins
      xBF.length = xBF.order*opts.binwidth; % = opts.winlength
      xBF        = spm_get_bf(xBF);
      xBF.bin    = xBF.length/xBF.order; % (effective) bin width
      
      j = round(xBF.length/xBF.bin);
      pst{r} = [0:j-1]*xBF.bin; % x-coordinates (=beginning of bin)
      %pst{r} = [1:j]*xBF.bin - xBF.bin/2; % x-coordinates (=middle of bin)
      pst{r} = pst{r} + opts.winbound(1);
      
      % split pmod into specified bin (if necessary)
      if opts.nbin{r} > 1
        count = 0;
        avail = ones(1,length(thresh))*NaN;
        for t = 1:length(thresh)
          clear X beta
          switch bintype
            case 'pct'
              if has_prctile
                thresh{t} = thresh{t} * 100;
                lb(r,t) = prctile(val,thresh{t}(1));
                ub(r,t) = prctile(val,thresh{t}(2));
              elseif has_quantile
                lb(r,t) = quantile(val,thresh{t}(1));
                ub(r,t) = quantile(val,thresh{t}(2));
              end
              ind{r,t} = find(val>lb(r,t)&val<=ub(r,t));
            case 'num'
              if ~isempty(strfind(thresh{t},'end'))
                thresh{t} = strrep(thresh{t},'end',num2str(length(ons)));
              end
              ind{r,t} = eval(thresh{t});
            case 'val'
              lb(r,t) = thresh{t}(1);
              ub(r,t) = thresh{t}(2);
              ind{r,t} = find(val>lb(r,t)&val<=ub(r,t));
          end
          
          % create "SPM" struct template for new FIR regressors
          % put all FIRs of each bin into one design matrix
          if ~isempty(ind{r,t})
            avail(t) = 1;
            count = count + 1;
            tmp.Sess.U(count).name = cellstr(sprintf('reg%d',t));
            tmp.Sess.U(count).ons  = ons(ind{r,t});
            tmp.Sess.U(count).dur  = zeros(size(ons(ind{r,t})));
            %tmp.Sess.U(count).dur  = dur(ind{r,t});
            tmp.Sess.U(count).P(1).name = 'none';
          end
          tmp.xBF = xBF;
          tmp.nscan = length(Y);
        end
      else
        if ~isempty(ons)
          avail = 1;
        else
          avail = NaN;
        end
        tmp.Sess.U(1).name = {'reg1'};
        tmp.Sess.U(1).ons  = ons;
        tmp.Sess.U(1).dur  = zeros(size(ons));
        %  tmp.Sess.U(1).dur  = dur;
        tmp.Sess.U(1).P(1).name = 'none';
        tmp.xBF = xBF;
        tmp.nscan = length(Y);
      end
      
      U = spm_get_ons(tmp,1);
      X = spm_Volterra(U,xBF.bf,1);
      k = tmp.nscan;
      X = X([0:(k - 1)]*xBF.T + xBF.T0 + 32,:);
      
      % remove possible overlap between scan of different events
      % which bin number corresponds to 0 (=onset)?
      bins = opts.winbound(1):opts.binwidth:opts.winbound(2);
      onsx = find(abs(bins)==min(abs(bins)));
      if length(onsx) > 1
        onsx = find(sign(bins(onsx))>0);
      end
      nbins = abs(bins-2); % subtract 2 secs to use min(abs(nbins)) to find the cutoff for begx
      cutoff = find(abs(nbins)==min(abs(nbins)));
      begx = []; endx = []; weight = [];
      for n = 1:opts.nbin{r}
        col = (n-1)*xBF.order + [1:xBF.order];
        begx = [begx col(1:cutoff)];
        endx = [endx col(cutoff+1:end)];
        weight = [weight length(cutoff+1:length(col)):-1:1];
      end
      % first we remove overlapping columns from the beginning
      % of the FIR until 2sec after the onset
      sX = sum(X,2);R=find(sX>xBF.order); %iX=rows of X that have doubles
      if ~isempty(R)
        for i = 1:length(R)
          C = find(X(R(i),:)==xBF.order);
          if ~isempty(C)
            for c = 1:length(C)
              x = find(begx==C(c));
              if ~isempty(x); X(R(i),C(c)) = 0; break; end
            end
          end
        end
      end
      % if there are still overlapping columns left
      % we remove them from the end of the FIR
      sX = sum(X,2);R=find(sX>xBF.order);
      if ~isempty(R)
        for i = 1:length(R)
          C = find(X(R(i),:)==xBF.order);
          if ~isempty(C)
            for c = 1:length(C)
              w(c) = find(endx==C(c));
            end
            x = find(weight(w)==min(weight(w)));
            X(R(i),C(x)) = 0;
          end
        end
      end
      
      
      % sanity check
      if size(Y,1) ~= size(X,1)
        error('Mismatch between data and design.')
      end
      
      xX   = spm_sp('set',X); % new design matrix
      pX   = spm_sp('x-',xX);  % pseudo-inverse
      beta = pX*Y; % pinv(X)*Y
      res  = spm_sp('r',xX,Y); % Y-X*(pinv(X)*Y)
      
      CI   = 1.6449; % = spm_invNcdf(1-0.05) ~ 90% CI
      df   = size(X,1) - rank(X);
      dt   = U(1).dt;
      j    = xBF.order * opts.nbin{r};
      bcov = pX*pX'*sum(res.^2)/df;
      beta = beta(1:j)/dt;
      se   = sqrt(diag(bcov(1:j,1:j)))/dt;
      pci  = CI*se;
      
      for t = 1:opts.nbin{r}
        if ~isnan(avail(t))
          psth{r,t} = beta((t-1)*xBF.order+[1:xBF.order])';
          sem{r,t}  = se((t-1)*xBF.order+[1:xBF.order])';
          ci{r,t}   = pci((t-1)*xBF.order+[1:xBF.order])';
          if opts.rescale
            i = find(pst{r}==0);
            if isempty(i)
              x1 = floor(pst{r}(1)):ceil(pst{r}(end));
              i = find(x1==0);
              y1 = interp1(pst{r},psth{r,t},x1);
              psth{r,t} = psth{r,t} - y1(i);
            else
              psth{r,t} = psth{r,t} - psth{r,t}(i);
            end
          end
        else
          psth{r,t} = NaN * xBF.order+[1:xBF.order];
          sem{r,t}  = NaN * xBF.order+[1:xBF.order];
          ci{r,t}   = NaN * xBF.order+[1:xBF.order];
        end
      end
    end
    
    if ~isempty(opts.repl)
      for rp = 1:max(opts.repl)
        ix = find(opts.repl==rp);
        for t = 1:size(psth,2)
          if length(ix) > 1
            data(s).psth(rp).bin(t).psth = nanmean(cat(1,psth{ix,t}));
            data(s).psth(rp).bin(t).sem  = nanmean(cat(1,sem{ix,t}));
            data(s).psth(rp).bin(t).ci   = nanmean(cat(1,ci{ix,t}));
            data(s).psth(rp).bin(t).pst  = pst{ix(1)};
          else
            data(s).psth(rp).bin(t).psth = psth{ix,t};
            data(s).psth(rp).bin(t).sem  = sem{ix,t};
            data(s).psth(rp).bin(t).ci   = ci{ix,t};
            data(s).psth(rp).bin(t).pst  = pst{ix};            
          end
        end
      end
    else
      for rp = 1:length(opts.select)
        for t = 1:size(psth,2)
          data(s).psth(rp).bin(t).psth = psth{rp,t};
          data(s).psth(rp).bin(t).sem  = sem{rp,t};
          data(s).psth(rp).bin(t).ci   = ci{rp,t};
          data(s).psth(rp).bin(t).pst  = pst{rp};
        end
      end
    end
    %data(s).X = X;
    fprintf('%s',repmat(sprintf('\b'),1,58));
  end
  fprintf('done.\n');
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
