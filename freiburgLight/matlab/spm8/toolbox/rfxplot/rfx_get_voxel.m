function [XYZvx,limstr] = rfx_get_voxel(SPM,xSPM,opts)
%
% compute voxel indices and coordinates (in voxel space)
% based on VOI definition
% -------------------------------------------------------------------------
% $Id: rfx_get_voxel.m 6 2009-04-07 14:20:52Z vglauche $

global defs

try
  XYZmm   = SPM.xVol.M(1:3,:)*[SPM.xVol.XYZ; ones(1, SPM.xVol.S)];
  O        = ones(1,size(XYZmm,2));
  Q        = ones(1,size(xSPM.XYZmm,2));
  
  xyzmm = opts.xyz';
  
  switch opts.space
    
    case 'voxel'
      %--------------------------------------------------------------------
      XYZvx      = SPM.xVol.M \ [xyzmm(:); 1];
      XYZvx(end) = [];
      limstr     = ' 1 voxel';
      
    case 'sphere'
      %--------------------------------------------------------------------
      j          = find(sum((xSPM.XYZmm - xyzmm*Q).^2) <= opts.dim^2);
      k          = find(sum((     XYZmm - xyzmm*O).^2) <= opts.dim^2);
      
    case 'box'
      %--------------------------------------------------------------------
      j          = find(all(abs(xSPM.XYZmm - xyzmm*Q) <= opts.dim(:)*Q/2));
      k          = find(all(abs(     XYZmm - xyzmm*O) <= opts.dim(:)*O/2));
      
    case 'image'
      %--------------------------------------------------------------------
      if length(opts.mask) == 1
        D        = spm_vol(opts.mask{1});
        % find all supra-threshold RFX voxels
        XYZ      = D.mat \ [xSPM.XYZmm; ones(1, size(xSPM.XYZmm, 2))];
        % find all RFX voxels
        tXYZ     = D.mat \ [     XYZmm; ones(1, size(     XYZmm, 2))];
        % among all supra-threshold RFX voxels, find those that are in the mask
        j        = find(spm_sample_vol(D, XYZ(1,:), XYZ(2,:), XYZ(3,:),0) > 0);
        % among all RFX voxels find those that are in the mask
        k        = find(spm_sample_vol(D,tXYZ(1,:),tXYZ(2,:),tXYZ(3,:),0) > 0);
      else
        XYZvx    = SPM.xVol.M \ [xyzmm(:); 1];
        limstr   = '';
        return;
      end
  end
  
  if ~strcmp(opts.space,'voxel')
    if opts.limit
      XYZvx  = xSPM.XYZ(:,j);
      limstr = sprintf(' %d/%d supra-threshold voxels',length(j),length(k));
    else
      XYZvx  = SPM.xVol.XYZ(:,k);
      limstr = sprintf(' %d voxels',length(k));
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
