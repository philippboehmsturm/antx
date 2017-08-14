function varargout = tbxvol_hist_summary(cmd, varargin)
% Compute histogramm summary
% FORMAT tbxvol_hist_summary(bch)
% ======
%
% This function is part of the volumes toolbox for SPM5. For general help
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Volumes
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: tbxvol_hist_summary.m 712 2010-06-30 14:20:19Z glauche $

rev = '$Revision: 712 $';
if ischar(cmd)
    switch lower(cmd)
        case 'run'
            job = local_getjob(varargin{1});
            out = local_hist_summary(job);
            % do computation, return results in variable out
            if nargout > 0
                varargout{1} = out;
            end
        case 'vout'
            job = local_getjob(varargin{1});
            % initialise empty cfg_dep array
            dep = cfg_dep;
            dep = dep(false);
            % determine outputs, return cfg_dep array in variable dep
            for k = 1:numel(job.subjects)
                dep(k) = cfg_dep;
                dep(k).sname = sprintf('Extracted histogramm data - Subject %d',k);
                dep(k).src_output = substruct('{}', {k});
                dep(k).tgt_spec   = cfg_findspec({{'strtype','e'}});
            end
            varargout{1} = dep;
%         case 'check'
%             if ischar(varargin{1})
%                 subcmd = lower(varargin{1});
%                 subjob = varargin{2};
%                 str = '';
%                 switch subcmd
%                     % implement checks, return status string in variable str
%                     otherwise
%                         cfg_message('unknown:check', ...
%                             'Unknown check subcmd ''%s''.', subcmd);
%                 end
%                 varargout{1} = str;
%             else
%                 cfg_message('ischar:check', 'Subcmd must be a string.');
%             end
%         case 'defaults'
%             if nargin == 2
%                 varargout{1} = local_defs(varargin{1});
%             else
%                 local_defs(varargin{1:2});
%             end
        otherwise
            cfg_message('unknown:cmd', 'Unknown command ''%s''.', cmd);
    end
else
    cfg_message('ischar:cmd', 'Cmd must be a string.');
end

function job = local_getjob(job)
if ~isstruct(job)
    cfg_message('isstruct:job', 'Job must be a struct.');
end

function varargout = local_hist_summary(bch)

% test, whether statistics toolbox is installed

stats = license('test','statistics_toolbox');

spm_progress_bar('init',numel(bch.subjects),'Subjects completed')

ext = cell(size(bch.subjects));
for k = 1:numel(bch.subjects)
    for m = 1:numel(bch.subjects(k).maskimgs)
        Vm = spm_vol(bch.subjects(k).maskimgs{m});
        for l = 1:numel(bch.subjects(k).srcimgs)
            Vi = spm_vol(bch.subjects(k).srcimgs{l});

            dat = [];
            nvx = 0;
            %-Loop over planes computing result Y
            %-----------------------------------------------------------------------
            for p = 1:Vi.dim(3),
                B = spm_matrix([0 0 -p 0 0 0 1 1 1]);
                M = inv(B/Vi.mat*Vm.mat);
                msk = logical(spm_slice_vol(Vm,M,Vi.dim(1:2),[0,0]));
                tmp = spm_slice_vol(Vi,inv(B),Vi.dim(1:2),[0,NaN]);
                msk = msk & isfinite(tmp);
                dat = [dat; tmp(msk(:))];
                nvx = nvx + nnz(msk(:));
            end;
            cext.volvx = nvx;
            cext.volmm3 = prod(sqrt(sum(Vi.mat(1:3,1:3).^2)))*nvx;
            cext.median = median(dat);
            cext.mean   = mean(dat);
            if stats
                cext.skewness = skewness(dat);
                cext.kurtosis = kurtosis(dat);
            else
                cext.skewness = [];
                cext.kurtosis = [];
            end;
            cext.std = std(dat);
            cext.hist = histc(dat,bch.bins);
            cext.low  = sum(dat<min(bch.bins));
            cext.high = sum(dat>max(bch.bins));
            ext{k}{m,l} = cext;
        end;
    end;
    spm_progress_bar('set',k);
end;
spm_progress_bar('clear');
spm_input('!DeleteInputObj');

if nargout > 0
    varargout{1}=ext;
else
    assignin('base','ext',ext);
    fprintf('extracted data saved to workspace variable ''ext''\n');
    disp(ext);
end;
