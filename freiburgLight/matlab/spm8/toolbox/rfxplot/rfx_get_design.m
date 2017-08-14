function des = rfx_get_design(dirs,opts)
%
% loads or compiles a struct with ffx design matrices and session
% information
% -------------------------------------------------------------------------
% $Id: rfx_get_design.m 6 2009-04-07 14:20:52Z vglauche $

global defs des rfxdes;

try
  nSub = length(dirs);
  
  % if the currently selected RFX analysis (opts.rfxdir) is not equal to that from
  % which the des struct in global workspace was extracted, then delete des struct
  % and have it reloaded from the current rfx analysis ...
  if ~strcmp(rfxdes,opts.rfxdir)
    des = [];
  end
  
  if isempty(des)
    try
      fprintf('Loading design information from rfx_design.mat ... ')
      tic;
      load(fullfile(opts.rfxdir,'rfx_design.mat'));
      tim = toc;
      if tim > 60
        fprintf('done (%1.2f min).\n',tim/60);
      else
        fprintf('done (%1.1f sec).\n',tim);
      end
    catch
      fprintf('failed. (Don''t worry.)\n');
      fprintf('Creating rfx_design.mat ...\n');
      des = struct;
      tic;
      for s = 1:nSub
        fprintf('%-31s',sprintf('Compiling design for subject %02d',s));
        load(fullfile(dirs{s},'SPM.mat'));
        des(s).Sess = SPM.Sess;
        for ses = 1:length(des(s).Sess)
          des(s).Sess(ses).U = rmfield(des(s).Sess(ses).U,{'u','pst'});
          for u = 1:length(des(s).Sess(ses).U)
            if ~isfield(des(s).Sess(ses).U(u),'P')
              des(s).Sess(ses).U(u).P.name = 'none';
              des(s).Sess(ses).U(u).P.P = [];
              des(s).Sess(ses).U(u).P.h = [];
            else
              for p = 1:length(des(s).Sess(ses).U(u).P)
                if ~isfield(des(s).Sess(ses).U(u).P(p),'name')
                  des(s).Sess(ses).U(u).P(p).name = 'none';
                end
                if ~isfield(des(s).Sess(ses).U(u).P(p),'P')
                  des(s).Sess(ses).U(u).P(p).P = [];
                end
                if ~isfield(des(s).Sess(ses).U(u).P(p),'h')
                  des(s).Sess(ses).U(u).P(p).h = [];
                end                
              end
            end
          end
        end
        des(s).xX   = rmfield(SPM.xX,{'V','pKX','nKX','trRV','trRVRV','erdf'});
        des(s).xCon = SPM.xCon;
        des(s).xBF  = SPM.xBF;
        des(s).nscan= SPM.nscan;
        des(s).RT   = SPM.xY.RT;
        fprintf('%s',repmat(sprintf('\b'),1,31))
      end
      tim = toc;
      if tim > 60
        fprintf('completed in %1.2f min.\n',tim/60);
      else
        fprintf('completed in %1.1f sec.\n',tim);
      end
      if defs.savemat.design
        fprintf('\nSaving design information to rfx_design.mat ... ');
        tic;
        save(fullfile(opts.rfxdir,'rfx_design.mat'),'des');
        tim = toc;
        if tim > 60
          fprintf('done (%1.2f min).\n',tim/60);
        else
          fprintf('done (%1.1f sec).\n',tim);
        end
      else
        fprintf('\nAbort saving design information at user request.\n');
      end
    end
  end
  
  rfxdes = opts.rfxdir;
  
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
