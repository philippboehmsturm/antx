function data = rfx_get_data_img(FFXvx,opts,index,sxyz,FFXeff,rfximg,rfxcon,SPM)
%
% extract the data from the images from the selected voxels for
% plotting the effects
% -------------------------------------------------------------------------
% $Id: rfx_get_data_img.m 13 2010-07-15 08:38:20Z volkmar $

global defs des imgs;

try
  nSub = length(imgs);
  nImg = length(opts.select);
  
  for s = 1:nSub
    xyz = FFXvx{s};
    nbf = size(des(s).xBF.bf,2);
    
    data(s).rfxxyz    = opts.xyz;
    data(s).rfximg    = rfximg;
    data(s).rfxcon    = rfxcon;
    if strcmp(opts.space,'mask')
      if length(opts.mask) == nSub
        data(s).rfxspace = spm_str_manip(opts.mask{s},'t');
      else
        data(s).rfxspace = spm_str_manip(opts.mask{1},'t');
      end
    else
      data(s).rfxspace  = opts.space;
    end
    data(s).rfxdim    = opts.dim;
    if opts.limit
      data(s).limit   = 'suprathreshold RFX voxels';
    else
      data(s).limit   = 'all RFX voxels';
    end
    data(s).maxxyz    = sxyz{s};
    data(s).maxeffect = FFXeff{s};
    data(s).xyz       = SPM.xVol.M * [FFXvx{s}; ones(1,size(FFXvx{s},2))];
    data(s).limtype   = opts.limtype;
    data(s).ffxsphere = opts.ffxsphere;
    data(s).regressor = opts.selname;
    data(s).filter    = opts.filter;
    data(s).adjust    = opts.adjust;
    if strcmp(opts.scale,'pcnt')
      data(s).scale   = 'percent signal change';
    elseif strcmp(opts.scale,'es')
      data(s).scale   = 'effect size';
    end
    
    for i = 1:nImg
      
      if strcmp(opts.prefix,'beta')
        regtype = opts.regtype{i};
        
        nx = index.n(s,opts.select(i));
        sx = index.s(s,opts.select(i));
        ux = index.u(s,opts.select(i));
        px = index.p(s,opts.select(i));
        bx = index.b(s,opts.select(i));
        
        % extract session constant for selected voxels (for pnct sig change)
        if ~isnan(nx) && strcmp(opts.scale,'pcnt') && strcmp(opts.prefix,'beta')
          cnum = des(s).xX.iB(sx);
          tmp = spm_sample_vol(imgs(s).beta(cnum),xyz(1,:),xyz(2,:),xyz(3,:),0);
          const = mean(tmp);
          
          clear tmp
          tmp.Sess.U.name = {'dummy'};
          tmp.Sess.U.ons  = 1;
          tmp.Sess.U.dur  = des(1).Sess(1).U(1).dur(1);
          tmp.Sess.U.P.name = 'none';
          tmp.xBF = des(1).xBF; % use the current basis set
          tmp.nscan = 100;
          
          % create regressor
          U2 = spm_get_ons(tmp,1);
          X2 = spm_Volterra(U2,tmp.xBF.bf,1);
          
        end
      end
      
      imgdata{i} = [];
      switch lower(opts.prefix)
        case 'beta'
          found = 0;
          for b = 1:length(imgs(s).beta)
            if ~isempty(strfind(imgs(s).beta(b).descrip,opts.selname{i}))
              found = 1;
              imgdata{i} = nanmean(spm_sample_vol(imgs(s).beta(b),...
                xyz(1,:),xyz(2,:),xyz(3,:),0),2);
              if ~isempty(strfind(opts.selname{i},'bf(1)')) && nbf > 1
                for f = 0:nbf-1
                  allbeta(f+1,1) = nanmean(spm_sample_vol(imgs(s).beta(b+f),...
                    xyz(1,:),xyz(2,:),xyz(3,:),0),2);
                end
              else
%                 imgdata{i} = nanmean(spm_sample_vol(imgs(s).beta(b),...
%                   xyz(1,:),xyz(2,:),xyz(3,:),0),2);
                allbeta = imgdata{i};
              end
              break;
            end
          end
          if ~found
            imgdata{i} = NaN;
          end
          
          data(s).beta((i-1)*nbf+(1:nbf)) = allbeta';
          
          if strcmp(opts.scale,'pcnt')
            if imgdata{i}(1) >=0 % sing of first beta is important!
              imgdata{i} = (max(X2*allbeta) * 100) / const;
            else
              imgdata{i} = (min(X2*allbeta) * 100) / const;
            end
          else
            imgdata{i} = allbeta';
          end
          
        case {'con','ess','spmt','spmf'}
          found = 0;
          for c = 1:length(imgs(s).xcon)
            if strcmp(imgs(s).xcon(c).name,opts.selname{i})
              found = 1;
              if strcmp(opts.prefix,'con') || strcmp(opts.prefix,'ess')
                imgdata{i} = nanmean(spm_sample_vol(imgs(s).xcon(c).Vcon,...
                  xyz(1,:),xyz(2,:),xyz(3,:),0));
                break;
              elseif strcmpi(opts.prefix,'spmt') || strcmpi(opts.prefix,'spmf')
                imgdata{i} = nanmean(spm_sample_vol(imgs(s).xcon(c).Vspm,...
                  xyz(1,:),xyz(2,:),xyz(3,:),0));
                break;
              end
            end
          end
          if ~found
            imgdata{i} = NaN;
          end
        case 'resms'
          found = 0;
          for c = 1:length(imgs(s).resms)
            if strcmp(imgs(s).resms(c).descrip,opts.selname{i})
              found = 1;
              imgdata{i} = nanmean(spm_sample_vol(imgs(s).resms(c),...
                xyz(1,:),xyz(2,:),xyz(3,:),0));
              break;
            end
          end
          if ~found
            imgdata{i} = NaN;
          end
        otherwise
          found = 0;
          for c = 1:length(imgs(s).(opts.prefix))
            if strcmp(imgs(s).(opts.prefix)(c).descrip,opts.selname{i})
              found = 1;
              imgdata{i} = nanmean(spm_sample_vol(imgs(s).(opts.prefix)(c),...
                xyz(1,:),xyz(2,:),xyz(3,:),0));
            end
          end
          if ~found
            imgdata{i} = NaN;
          end
      end
    end
    % assign imgdata to data(s).(opts.prefix) and to data(s).effect
    if ~strcmp(opts.prefix,'beta') % only for non-beta images, for beta s.a.
      data(s).(opts.prefix) = cat(2,imgdata{:});
    end
    if ~isempty(opts.repl)
      for rp = 1:max(opts.repl)
        ix = opts.repl==rp;
        data(s).effect{rp} = nanmean(cat(2,imgdata{ix}));
      end
    else
      for rp = 1:length(imgdata)
        data(s).effect{rp} = imgdata{rp};
      end
    end
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
