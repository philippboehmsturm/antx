function revol_xcon(dirs)
%
% runs spm_vol on the con/ess images and spmT/spmF images in all
% 1st level analyses specified in dirs
%
% ARGS
% dirs - a cell array with directories of 1st level analyses
%        can be obtained by running: dirs = rfx_get_dirs(SPM)
%        where SPM is the SPM struct of a 2nd level analysis
% -------------------------------------------------------------------------
% $Id: revol_xcon.m 2 2009-01-19 15:12:13Z vglauche $

oldpwd = pwd;
spm('defaults','fmri');

for d = 1:length(dirs)
  fprintf('Working on subject %d (%s)\n',d,dirs{d});
  cd(dirs{d});
  clear SPM
  load SPM.mat
  
  for c = 1:length(SPM.xCon)
    
    if strcmp(SPM.xCon(c).STAT,'T') && ...
        (isempty(SPM.xCon(c).Vcon) || isempty(SPM.xCon(c).Vspm))
      cname = sprintf('con_%04d.img',c);
      tname = sprintf('spmT_%04d.img',c);
      if exist(sprintf(cname),'file')
        SPM.xCon(c).Vcon = spm_vol(cname);
      else
        disp('Mismatch between xCon struct and available con-image.')
        disp('Please inspect manually or regenerate all your contrasts.');
        return;
      end
      if exist(sprintf(tname),'file')
        SPM.xCon(c).Vspm = spm_vol(tname);
      else
        disp('Mismatch between xCon struct and available spmT-image.');
        disp('Please inspect manually or regenerate all your contrasts.');
        return;
      end
    elseif strcmp(SPM.xCon(c).STAT,'F') && ...
        (isempty(SPM.xCon(c).Vcon) || isempty(SPM.xCon(c).Vspm))
      cname = sprintf('ess_%04d.img',c);
      tname = sprintf('spmF_%04d.img',c);
      if exist(sprintf(cname),'file')
        SPM.xCon(c).Vcon = spm_vol(cname);
      else
        disp('Mismatch between xCon struct and available ess-image.');
        disp('Please inspect manually or regenerate all your contrasts.');
        return;
      end
      if exist(sprintf(tname),'file')
        SPM.xCon(c).Vspm = spm_vol(tname);
      else
        disp('Mismatch between xCon struct and available spmF-image.');
        disp('Please inspect manually or regenerate all your contrasts.');
        return;
      end
    end
    
    save SPM.mat SPM
    
  end
  
end

cd(oldpwd);
fprintf('\nAll operations successfully completed.\n');
return;
      
