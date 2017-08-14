function [FFXvx,FFXeff,rfximg,sxyz] = rfx_get_ffx_voxel_mask(SPM,xSPM,opts)
%
% obtain voxel indices from either a single of nSub anatomical
% mask images
% -------------------------------------------------------------------------
% $Id: rfx_get_ffx_voxel_mask.m 13 2010-07-15 08:38:20Z volkmar $

global defs imgs;

try
  nSub = length(imgs);
  
  for m = 1:length(opts.mask)
    [y,xyz] = spm_read_vols(spm_vol(opts.mask{m}));
    idx = find(y(:));
    FFXvx{m} = SPM.xVol.M \ [xyz(:,idx); ones(1,length(idx))];
    FFXvx{m}(4:end,:) = [];
  end
  
  if length(FFXvx) == 1
    FFXvx = repmat(FFXvx,1,nSub);
  end
  
  % --- now figure out the peak in the mask
  if length(xSPM.Ic) == 1
    weights = SPM.xX.X * SPM.xCon(xSPM.Ic).c;
  else
    % figure out what to do for RFX conjunctions
    for w = 1:length(xSPM.Ic)
      weights(:,w) = SPM.xX.X * SPM.xCon(xSPM.Ic(w)).c;
    end
  end
  
  % create index of images in rfx analysis
  [subdir,junk,subind] = rfx_unique_unsorted(cellstr(...
    spm_str_manip(strvcat(SPM.xY.P),'h')));
  
  for sub = 1:nSub
    
    if ~isempty(strfind(SPM.xY.P{1},'beta'))
      y = rfx_get_data(SPM.xY.VY,FFXvx{sub});
      rfximg = 'beta';
    elseif ~isempty(strfind(SPM.xY.P{1},'con_'))
      for s = 1:length(SPM.xY.P)
        VT(s) = spm_vol(strrep(SPM.xY.P{s},'con_','spmT_'));
      end
      y = rfx_get_data(VT,FFXvx{sub});
      rfximg = 'con';
    elseif ~isempty(strfind(SPM.xY.P{1},'ess'))
      for s = 1:length(SPM.xY.P)
        VT(s) = spm_vol(strrep(SPM.xY.P{s},'con_','spmF_'));
      end
      y = rfx_get_data(VT,FFXvx{sub});
      rfximg = 'ess';
    end
    
    ind = find(subind==sub);
    clear eff;
    for v = 1:size(y,2) %run over voxel
      if size(weights,2) > 1
        for w = 1:size(weights,2)
          tmp(w) = y(ind,v)' * weights(ind,w);
          eff(v) = sum(tmp);
        end
      else
        eff(v) = y(ind,v)' * weights(ind);
      end
    end
    [FFXeff{sub},i] = max(eff);
    
    if strcmp(opts.limtype,'peakmask')
      FFXvx{sub} = FFXvx{sub}(:,i);
      sxyz{sub} = SPM.xVol.M * [FFXvx{sub}; 1];
    else
      sxyz{sub} = SPM.xVol.M * [FFXvx{sub}(:,i); 1];
    end
    sxyz{sub} = sxyz{sub}(1:3)';
    
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
