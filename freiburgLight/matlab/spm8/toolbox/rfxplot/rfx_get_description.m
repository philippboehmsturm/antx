function [dlist,dnum,index] = rfx_get_description(imgs,opts)
%
% compiles a unique list of image descriptions and count the
% number of occurrences
% -------------------------------------------------------------------------
% $Id: rfx_get_description.m 13 2010-07-15 08:38:20Z volkmar $

global defs des;

try
  nSub = length(imgs);
  desc = {};
  
  switch opts.prefix
    
    case 'beta'
      for s = 1:nSub
        for i = 1:length(imgs(s).beta)
          ix = strfind(imgs(s).beta(i).descrip,' - ');
          desc{end+1} = imgs(s).beta(i).descrip(ix+3:end);
        end
      end
    case {'con','ess','spmT','spmF'}
      for s=1:nSub
        for i = 1:length(imgs(s).xcon)
          if strcmp(imgs(s).xcon(i).STAT,'T')
            %ix = strfind(imgs(s).xcon(i).Vcon.descrip,': ');
            %desc{end+1} = imgs(s).xcon(i).Vcon.descrip(ix+2:end);
            desc{end+1} = imgs(s).xcon(i).name;
          end
        end
      end
    otherwise
      for s = 1:nSub
        for i = 1:length(imgs(s).(opts.prefix))
          desc{end+1} = imgs(s).(opts.prefix)(i).descrip;
        end
      end
      
  end
  
  [dlist,dnum] = rfx_unique_unsorted(desc);
  
  % create an index matrix that maps each unique description back onto
  % individual FFX regressor numbers ...
  
  len = length(dlist);
  
  index = struct('n', ones(nSub,len)*NaN, ...
    's', zeros(nSub,len), ...
    'u', zeros(nSub,len), ...
    'p', zeros(nSub,len), ...
    'b', zeros(nSub,len), ...
    'h', zeros(nSub,len));
  
  switch opts.prefix
    case 'beta'
      for s = 1:nSub
        
        for d = 1:length(dlist)
          
          stcore = strfind(dlist{d},') ') + 2;
          %len    = length(dlist{d}) - 1;
          
          for b = 1:length(imgs(s).beta)
            if strcmp(imgs(s).beta(b).descrip(23:end),dlist{d})
              % beta description strings start with:
              % "spm_spm:beta (0001) - ". The length is of this string is 22.
              % Therefore, the real name starts at index 23
              index.s(s,d) = str2double(dlist{d}(4:stcore-3)); % session
              index.n(s,d) = b;                   % regressor
              core = '';
              
              bb = strfind(dlist{d},'*bf(');      % basis function?
              if ~isempty(bb)
                index.b(s,d) = str2double(dlist{d}(bb+4));
                core = dlist{d}(stcore:bb-1);          % core name
              end
              
              if isempty(core)
                core = dlist{d}(stcore:end);           % core name (failback)
              end
              
              ses  = index.s(s,d);
              U = des(s).Sess(ses).U;
              for u = 1:length(U)
                % setup and internal numbering of pmods within the reg
                p = 0;
                if ~isempty(U(u).P(1).P)
                  for pp = 1:length(U(u).P)
                    p = [p repmat(pp,1,U(u).P(pp).h)];
                  end
                end
                
                for n = 1:length(U(u).name)
                  if strcmp(U(u).name{n},core)
                    index.u(s,d) = u;
                    index.p(s,d) = p(n);
                    break;
                  end
                end
              end
              
              p = strfind(dlist{d},'^');          % pmod?
              if ~isempty(p)
                index.h(s,d) = str2double(dlist{d}(p+1));
                %                 core = dlist{d}(stcore:p-1);           % core name
              end
              
            end
          end
        end
      end
    case {'con','ess','spmT','spmF'}
      for s = 1:nSub
        for d = 1:length(dlist)
          index.n(s,d) = NaN;
          ind = strmatch(dlist{d},cellstr(strvcat(imgs(s).xcon(:).name)),'exact');
          if ~isempty(ind)
            if length(ind) > 1
              fprintf('Warning! Duplicate contrast specification in subject %d:\n',s);
              fprintf('"%s"\n',dlist{d});
              fprintf('Continuing using the first of these duplicate contrasts ...\n');
              index.n(s,d) = ind(1);
            else
              index.n(s,d) = ind;
            end
          end
        end
      end
    otherwise
      for s = 1:nSub
        for d = 1:length(dlist)
          index.n(s,d) = NaN;
          ind = strmatch(dlist{d},cellstr(strvcat(imgs(s).(opts.prefix)(:).descrip)),'exact');
          if ~isempty(ind)
            if length(ind) > 1
              fprintf('Warning! Duplicate image naming in subject %d:\n',s);
              fprintf('"%s"\n',dlist{d});
              fprintf('Continuing using the first image ...\n');
              index.n(s,d) = ind(1);
            else
              index.n(s,d) = ind;
            end
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
