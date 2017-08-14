function [FFXvx,FFXeff,rfximg,sxyz] = rfx_get_ffx_voxel(opts,XYZvx,SPM,xSPM)
%
% find voxel of interest in FFX analyses
% -------------------------------------------------------------------------
% $Id: rfx_get_ffx_voxel.m 13 2010-07-15 08:38:20Z volkmar $

global defs

try
  if strcmp(opts.limtype,'maskffx')
    for m = 1:length(opts.mask)
      [y,xyz] = spm_read_vols(spm_vol(opts.mask{m}));
      idx = find(y(:));
      FFXvx{m} = SPM.xVol.M \ [xyz(:,idx); ones(1,length(idx))];
    end
    return;
  end
  
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
  nSub = size(subdir,1);
  
  
  if ~isempty(strfind(SPM.xY.P{1},'beta'))
    y = rfx_get_data(SPM.xY.VY,XYZvx);
    rfximg = 'beta';
  elseif ~isempty(strfind(SPM.xY.P{1},'con_'))
    for s = 1:length(SPM.xY.P)
      VT(s) = spm_vol(strrep(SPM.xY.P{s},'con_','spmT_'));
    end
    y = rfx_get_data(VT,XYZvx);
    rfximg = 'con';
  elseif ~isempty(strfind(SPM.xY.P{1},'ess'))
    for s = 1:length(SPM.xY.P)
      VT(s) = spm_vol(strrep(SPM.xY.P{s},'con_','spmF_'));
    end
    y = rfx_get_data(VT,XYZvx);
    rfximg = 'ess';
  end
  
  for s = 1:nSub
    ind = find(subind==s);
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
    [FFXeff{s},i] = max(eff);
    FFXvx{s} = XYZvx(:,i);
    sxyz{s} = SPM.xVol.M * [FFXvx{s}; 1];
    sxyz{s} = sxyz{s}(1:3)';
  end
  
  if strcmp(opts.limtype,'sphereffx')
    O     = ones(1,size(SPM.xVol.XYZ,2));
    FFXmm = SPM.xVol.M * [cat(2,FFXvx{:}); ones(1,length(FFXvx))];
    XYZmm = SPM.xVol.M * [SPM.xVol.XYZ; ones(1,size(SPM.xVol.XYZ,2))];
    clear FFXvx;
    for s = 1:nSub
      k     = find(sum((XYZmm - FFXmm(:,s)*O).^2) <= opts.ffxsphere^2);
      FFXvx{s} = SPM.xVol.XYZ(:,k);
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
