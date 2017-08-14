function [data,opts] = rfx_adjust_timeseries(data,opts,index,FFXvx)
%
% adjusts time series for HPF and AR(1)
% -------------------------------------------------------------------------
% $Id: rfx_adjust_timeseries.m 13 2010-07-15 08:38:20Z volkmar $

global defs des imgs;

try
  tic;
  fprintf('Adjusting all time series ... ');
  for sub = 1:length(data)
    
    % if we want to adjust for all other effects, then we have
    % compute an adjusted time course for each selected image
    % in opts.select. If not, we only have to loop once to get
    % the adjusted time course (for all selected images)
    if strcmp(opts.adjust,'all')
      len = length(opts.select);
    else
      len = 1;
    end
    
    for r = 1:len
      
      iG = [];
      if isempty(des(sub).xX.iG)
        % do we have some movement parameters specified via
        % "multiple regressors"?
        mnames = {'R1','R2','R3','R4','R5','R6'};
        found = zeros(1,6);
        for reg = 1:6
          for nam = 1:length(des(sub).xX.name)
            if ~isempty(strfind(des(sub).xX.name{nam},mnames{reg})) && ...
                (length(des(sub).xX.name{nam}) == 8)
              found(reg) = nam;
              break;
            end
          end
        end
        if all(found)
          iG = found;
        end
      end
      
      
      % configure null space (columns for reduced design)
      switch opts.adjust
        case 'none' % no adjustment
          iX0 = [];
        case 'block' % only block effects
          iX0 = des(sub).xX.iB;
        case 'nuis' % block and nuisance effects
          if ~isempty(iG)
            iX0 = [iG des(sub).xX.iB];
          else
            iX0 = [des(sub).xX.iG des(sub).xX.iB];
          end
        case 'all' % all other effects
          iX0 = 1:size(des(sub).xX.X,2);
          iX0(find(iX0==index.n(sub,opts.select(r)))) = [];
        case 'user'
          iX0 = index.n(sub,opts.indiX0);
          iX0 = iX0(~isnan(iX0));
        case 'con'
          %iX0 = des(sub).xCon(Fc).iX0;
          iX0 = opts.iX0;
      end
      
      % build F-contrast and adjust time series
      if ~isempty(iX0)
        if strcmp(opts.filter,'ar1') || strcmp(opts.filter,'both')
          Fc = spm_FcUtil('set','adjust','F','iX0',iX0,des(sub).xX.xKXs);
          beta = rfx_get_data(imgs(sub).beta,FFXvx{sub});
          data(sub).adj{r} = data(sub).filt - spm_FcUtil('Y0',Fc,des(sub).xX.xKXs,beta);
        else
          Fc = spm_FcUtil('set','adjust','F','iX0',iX0,des(sub).xX.X);
          beta = rfx_get_data(imgs(sub).beta,FFXvx{sub});
          data(sub).adj{r} = data(sub).filt - spm_FcUtil('Y0',Fc,des(sub).xX.X,beta);
        end
      else
        data(sub).adj{r} = data(sub).filt;
      end
      
      % now compute a representative time course (for all sessions) via svd
      if size(data(sub).adj{r},2) > 1
        y = data(sub).adj{r};
        [m n] = size(y);
        if m > n
          [v s v] = svd(y'*y);
          s = diag(s);
          v = v(:,1);
          u = y*v/sqrt(s(1));
        else
          [u s u] = svd(y*y');
          s = diag(s);
          u = u(:,1);
          v = y'*u/sqrt(s(1));
        end
        d = sign(sum(v));
        u = u*d;
        v = v*d;
        data(sub).tc{r} = u*sqrt(s(1)/n);
      else
        data(sub).tc{r} = data(sub).adj{r};
      end
      % split time course into sessions
      for ses = 1:length(des(sub).Sess)
        data(sub).Y{r,ses} = data(sub).tc{r}(des(sub).Sess(ses).row);
      end
    end
  end
  tim = toc;
  if tim > 60
    fprintf('done (%1.2f min).\n',tim/60);
  else
    fprintf('done (%1.1f sec).\n',tim);
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
