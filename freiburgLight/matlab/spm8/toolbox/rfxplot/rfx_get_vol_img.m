function imgs = rfx_get_vol_img(dirs,opts)
%
% loads or compiles a struct array of SPM images (beta,con,spmT,
% spmF,mask,ResMS) and places it into global workspace
% -------------------------------------------------------------------------
% $Id: rfx_get_vol_img.m 13 2010-07-15 08:38:20Z volkmar $

global imgs rfximgs defs;

std_prefix = {'beta','con','ess','spmT','spmF','ResMS'};

nSub     = length(dirs);
addmyimg = false;
regen    = false;

try % for rfxplot debug system
  
  if ~strcmp(rfximgs,opts.rfxdir) % regenerate if rfxdirs don't match
    regen = true;
  end
  
  if regen || isempty(imgs)
    try % try load rfx_images
      fprintf('Loading image handles from rfx_images.mat ... ')
      tic;
      load(fullfile(opts.rfxdir,'rfx_images.mat'));
      tim = toc;
      if tim > 60
        fprintf('done (%1.2f min).\n',tim/60);
      else
        fprintf('done (%1.1f sec).\n',tim);
      end
      regen = false;
    catch % regenerate rfx_images.mat later
      fprintf('failed. (Don''t worry.)\n');
      fprintf('Creating rfx_images.mat ...\n');
      regen = true;
    end
  end
  
  if isempty(strmatch(lower(opts.prefix),lower(std_prefix)))
    if ~isfield(imgs,opts.prefix)
      addmyimg = true;
      str = {'none',std_prefix{:}};
      tmp = spm_input(sprintf('Duplicate descriptions for %s images from',...
        opts.prefix),1,'m',str,0:length(str)-1);
    end
  end

  tim = 0;
  % now compile imgs struct as needed
  if regen
    tic;
    if ~isstruct(imgs)
      imgs = struct;
    end
    
    for s = 1:nSub
      fprintf('%-40s',sprintf('Compiling image handles for subject %02d',s));
      load(fullfile(dirs{s},'SPM.mat'));
      pth = SPM.swd;
      
      % beta images
      imgs(s).beta  = SPM.Vbeta;
      for i = 1:length(imgs(s).beta)
        if isempty(strfind(imgs(s).beta(i).fname,filesep))
          imgs(s).beta(i).fname = fullfile(pth,imgs(s).beta(i).fname);
        end
      end
      
      % con,ess images, spmT,spmT images
      imgs(s).xcon  = SPM.xCon;
      
      for i = 1:length(imgs(s).xcon)
        if isempty(imgs(s).xcon(i).Vcon) || isempty(imgs(s).xcon(i).Vspm)
          fprintf('I could not find an valid image handle for contrast "%s"',...
            imgs(s).xcon(i).name);
          disp('Please download the function "revol_xcon.m" from the Support section');
          disp('at http://rfxplot.sourceforge.net and do the following:');
          disp('1. change directory to your 2nd level analysis');
          disp('2. type: load SPM.mat');
          disp('3. type: dirs = rfx_get_dirs(SPM);');
          disp('4. type: revol_xcon(dirs);');
          disp('5. type: delete(''rfx*.mat'')');
          disp('6. type: close all; clear all');
          disp('7. Restart SPM, select 2nd level analysis, and restart rfxplot')
          disp('If you still get the same error message, please file a bug report')
          disp('at http://rfxplot.sourceforge.net. Thanks.')
          return;
        end
        if isempty(strfind(imgs(s).xcon(i).Vcon.fname,filesep))
          imgs(s).xcon(i).Vcon.fname = fullfile(pth,imgs(s).xcon(i).Vcon.fname);
          imgs(s).xcon(i).Vspm.fname = fullfile(pth,imgs(s).xcon(i).Vspm.fname);
        end
      end
      
      % ResMS images
      imgs(s).resms = SPM.VResMS;
      imgs(s).resms.fname = fullfile(pth,imgs(s).resms.fname);
      
      fprintf('%s',repmat(sprintf('\b'),1,40));
      t = toc;
      tim = tim + t;
    end
  end
  
  % user-defined images
  if addmyimg
    tic;
    fprintf('\nI couldn''t find valid handles for %s images\n',opts.prefix)
    for s = 1:nSub
      fprintf('%-45s',sprintf('Adding %s image handles for subject %02d',...
        opts.prefix,s));
      myimgs = rfx_lselect(dirs{s},sprintf('^%s.*\\.img',opts.prefix));
      imgs(s).(opts.prefix) = spm_vol(myimgs);
      for i = 1:length(imgs(s).(opts.prefix))
        if isempty(strfind(imgs(s).(opts.prefix)(i).fname,filesep))
          imgs(s).(opts.prefix)(i).fname = fullfile(dirs{s},imgs(s).(opts.prefix(i).fname));
        end
      end
      if tmp > 0
        switch std_prefix{tmp}
          case 'beta'
            if length(imgs(s).(opts.prefix)) == length(imgs(s).beta)
              for d = 1:length(imgs(s).beta)
                imgs(s).(opts.prefix)(d).descrip = imgs(s).beta(d).descrip;
              end
            else
              error('Unequal number of %s images and %s images',...
                opts.prefix,std_prefix{tmp});
            end
          case {'con','ess','spmT','spmF'}
            if length(imgs(s).(opts.prefix)) == length(imgs(s).xcon)
              for d = 1:length(imgs(s).xcon)
                imgs(s).(opts.prefix)(d).descrip = imgs(s).xcon(d).name;
              end
            else
              error('Unequal number of %s images and %s images',...
                opts.prefix,std_prefix{tmp});
            end
          case 'ResMS'
            imgs(s).(opts.prefix).descrip = imgs(s).resms.descrip;
        end
      end
      fprintf('%s',repmat(sprintf('\b'),1,45));
    end
    t   = toc;
    tim = tim + t;
  end
  
  if regen || addmyimg
    
    if tim > 60
      fprintf('Completed in %1.2f min.\n',tim/60);
    else
      fprintf('Completed in %1.1f sec.\n',tim);
    end
    
    if defs.savemat.images
      fprintf('\nSaving image handles to rfx_images.mat ... ');
      tic;
      save(fullfile(opts.rfxdir,'rfx_images.mat'),'imgs');
      tim = toc;
      if tim > 60
        fprintf('done (%1.2f min).\n',tim/60);
      else
        fprintf('done (%1.1f sec).\n',tim);
      end
    else
      fprintf('\nAbort saving image handles at user request.\n')
    end
  end
  
  rfximgs = opts.rfxdir;
  
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
