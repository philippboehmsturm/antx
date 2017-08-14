function FFXvx = rfx_get_ffx_voxel_sphere(opts,SPM,FFXvx,XYZvx,nSub)
%
% get voxel indices from a spherical search volume centered around
% the individual peak in FFXvx
% -------------------------------------------------------------------------
% $Id: rfx_get_ffx_voxel_sphere.m 6 2009-04-07 14:20:52Z vglauche $

global defs

try
  O     = ones(1,size(SPM.xVol.XYZ,2));
  FFXmm = SPM.xVol.M * [cat(2,FFXvx{:}); ones(1,length(FFXvx))];
  XYZmm = SPM.xVol.M * [SPM.xVol.XYZ; ones(1,size(SPM.xVol.XYZ,2))];
  clear FFXvx;
  for s = 1:nSub
    k     = find(sum((XYZmm - FFXmm(:,s)*O).^2) <= opts.ffxsphere^2);
    FFXvx{s} = SPM.xVol.XYZ(:,k);
    if opts.ffxlimit
      for vx = length(k):-1:1
        if ~any(XYZvx(1,:)==FFXvx{s}(1,vx)&XYZvx(2,:)==FFXvx{s}(2,vx)&XYZvx(3,:)==FFXvx{s}(3,vx))
          FFXvx{s}(:,vx) = [];
        end
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
