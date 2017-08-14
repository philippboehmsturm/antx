function varargout = dti_dw_cluster_std_differences(cmd, varargin)
% Template function to implement callbacks for an cfg_exbranch. The calling
% syntax is
% varargout = dti_dw_cluster_std_differences(cmd, varargin)
% where cmd is one of
% 'run'      - out = dti_dw_cluster_std_differences('run', job)
%              Run a job, and return its output argument
% 'vout'     - dep = dti_dw_cluster_std_differences('vout', job)
%              Examine a job structure with all leafs present and return an
%              array of cfg_dep objects.
% 'check'    - str = dti_dw_cluster_std_differences('check', subcmd, subjob)
%              Examine a part of a fully filled job structure. Return an empty
%              string if everything is ok, or a string describing the check
%              error. subcmd should be a string that identifies the part of
%              the configuration to be checked.
% 'defaults' - defval = dti_dw_cluster_std_differences('defaults', key)
%              Retrieve defaults value. key must be a sequence of dot
%              delimited field names into the internal def struct which is
%              kept in function local_def. An error is returned if no
%              matching field is found.
%              dti_dw_cluster_std_differences('defaults', key, newval)
%              Set the specified field in the internal def struct to a new
%              value.
% Application specific code needs to be inserted at the following places:
% 'run'      - main switch statement: code to compute the results, based on
%              a filled job
% 'vout'     - main switch statement: code to compute cfg_dep array, based
%              on a job structure that has all leafs, but not necessarily
%              any values filled in
% 'check'    - create and populate switch subcmd switchyard
% 'defaults' - modify initialisation of defaults in subfunction local_defs
% Callbacks can be constructed using anonymous function handles like this:
% 'run'      - @(job)dti_dw_cluster_std_differences('run', job)
% 'vout'     - @(job)dti_dw_cluster_std_differences('vout', job)
% 'check'    - @(job)dti_dw_cluster_std_differences('check', 'subcmd', job)
% 'defaults' - @(val)dti_dw_cluster_std_differences('defaults', 'defstr', val{:})
%              Note the list expansion val{:} - this is used to emulate a
%              varargin call in this function handle.
%
% This code is part of a batch job configuration system for MATLAB. See 
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id: dti_dw_cluster_std_differences.m 715 2010-09-01 15:14:38Z glauche $

rev = '$Rev: 715 $'; %#ok

if ischar(cmd)
    switch lower(cmd)
        case 'run'
            job = local_getjob(varargin{1});
            % do computation, return results in variable out
            out.thresh=repmat(struct([]),size(job.thresh));
            for cth = 1:numel(job.thresh)
                out.thresh(cth).imsum = cell(size(job.osrcimgs));
                out.thresh(cth).nc    = zeros(size(job.osrcimgs));
                out.thresh(cth).cs    = cell(size(job.osrcimgs));
                out.thresh(cth).limgs = cell(size(job.osrcimgs));
                out.thresh(cth).mcs   = zeros(size(job.osrcimgs));
            end
            domask = ~isempty(job.maskimg) && ~isempty(job.maskimg{1});
            if domask
                VM = spm_vol(job.maskimg{1});
            end
            gmean = numel(job.msrcimgs) == 1;
            if gmean
                Vm = spm_vol(job.msrcimgs{1});
                Vs = spm_vol(job.ssrcimgs{1});
            end
            spm_progress_bar('init', numel(job.osrcimgs));
            for ci = 1:numel(job.osrcimgs)
                Vi = spm_vol(job.osrcimgs{ci});
                % create temporary standard difference file, do clustering
                % on this file
                V  = rmfield(Vi,'private');
                [p n e v] = spm_fileparts(V.fname);
                V.fname   = fullfile(p, ['SD' n '_ctmp' e]);
                if ~gmean
                    Vm = spm_vol(job.msrcimgs{ci});
                    Vs = spm_vol(job.ssrcimgs{ci});
                end
                if domask
                    V = spm_imcalc([Vm; Vi; Vs; VM], V, '(abs(i1-i2)./sqrt(i3+(i3==0))).*i4');
                else
                    V = spm_imcalc([Vm; Vi; Vs], V, 'abs(i1-i2)./sqrt(i3+(i3==0))');
                end
                odat = spm_read_vols(V);
                dat=reshape(odat,[prod(V.dim(1:2)), V.dim(3)]);
                for cth = 1:numel(job.thresh)
                    out.thresh(cth).imsum{ci} = sum(dat > job.thresh(cth).th);
                    [ldat, out.thresh(cth).nc(ci)] = spm_bwlabel(double(odat > job.thresh(cth).th),6);
                    out.thresh(cth).cs{ci} = zeros(out.thresh(cth).nc(ci),1);
                    for l = 1:out.thresh(cth).nc(ci)
                        out.thresh(cth).cs{ci}(l) = sum(ldat(:)==l);
                    end
                end
                % remove temporary file
                rmjob{1}.cfg_basicio.file_move.files = {V.fname};
                rmjob{1}.cfg_basicio.file_move.action.delete = false;
                spm_jobman('run',rmjob);
                spm_progress_bar('set', ci);
            end
            spm_progress_bar('clear');
            sel = false(numel(job.thresh),numel(job.osrcimgs));
            for cth = 1:numel(job.thresh)
                [out.thresh(cth).cs{cellfun(@isempty,out.thresh(cth).cs)}]=deal(0);
                out.thresh(cth).mcs = cellfun(@max,out.thresh(cth).cs);
                sel(cth,:) = out.thresh(cth).mcs < job.thresh(cth).csize;
                out.thresh(cth).ind = find(sel(cth,:));
            end
            out.ind = find(all(sel));
            out.goodimgs = job.osrcimgs(all(sel));
            out.badimgs  = job.osrcimgs(~all(sel));
            if nargout > 0
                varargout{1} = out;
            end
        case 'vout'
            job = local_getjob(varargin{1});
            % initialise empty cfg_dep array
            dep(1)            = cfg_dep;
            dep(1).sname      = '''Good'' images';
            dep(1).src_output = substruct('.','goodimgs');
            dep(1).tgt_spec   = cfg_findspec({{'filter','image'}});
            dep(2)            = cfg_dep;
            dep(2).sname      = '''Bad'' images';
            dep(2).src_output = substruct('.','badimgs');
            dep(2).tgt_spec   = cfg_findspec({{'filter','image'}});
            dep(3)            = cfg_dep;
            dep(3).sname      = 'Inclusion index (all thresholds)';
            dep(3).src_output = substruct('.','ind');
            dep(3).tgt_spec   = cfg_findspec({{'strtype','n'}});
            for cth = 1:numel(job.thresh)
                dep(cth                    +3)            = cfg_dep;
                dep(cth                    +3).sname      = sprintf('Inclusion index %d',cth);
                dep(cth                    +3).src_output = substruct('.','thresh','()',{cth},'.','ind');
                dep(cth                    +3).tgt_spec   = cfg_findspec({{'strtype','n'}});
                dep(cth+1*numel(job.thresh)+3)            = cfg_dep;
                dep(cth+1*numel(job.thresh)+3).sname      = sprintf('Threshold %d results', cth);
                dep(cth+1*numel(job.thresh)+3).src_output = substruct('.','thresh','()',{cth});
                dep(cth+1*numel(job.thresh)+3).tgt_spec   = cfg_findspec({{'strtype','e'}});
            end
            % determine outputs, return cfg_dep array in variable dep
            varargout{1} = dep;
        case 'check'
            if ischar(varargin{1})
                subcmd = lower(varargin{1});
                subjob = varargin{2};
                str = '';
                switch subcmd
                    % implement checks, return status string in variable str
                    case 'srcimgs'
                        nummsrc = numel(subjob.msrcimgs);
                        if nummsrc ~= numel(subjob.ssrcimgs)
                            str = '# mean images must match # std images.';
                        elseif nummsrc > 1 && nummsrc ~= numel(subjob.osrcimgs)
                            str = '# mean/std images must either be 1 or match # original images.';
                        end
                    otherwise
                        cfg_message('unknown:check', ...
                            'Unknown check subcmd ''%s''.', subcmd);
                end
                varargout{1} = str;
            else
                cfg_message('ischar:check', 'Subcmd must be a string.');
            end
        case 'defaults'
            if nargin == 2
                varargout{1} = local_defs(varargin{1});
            else
                local_defs(varargin{1:2});
            end
        otherwise
            cfg_message('unknown:cmd', 'Unknown command ''%s''.', cmd);
    end
else
    cfg_message('ischar:cmd', 'Cmd must be a string.');
end

function varargout = local_defs(defstr, defval)
persistent defs;
if isempty(defs)
    % initialise defaults
end
if ischar(defstr)
    % construct subscript reference struct from dot delimited tag string
    tags = textscan(defstr,'%s', 'delimiter','.');
    subs = struct('type','.','subs',tags{1}');
    try
        cdefval = subsref(local_def, subs);
    catch
        cdefval = [];
        cfg_message('defaults:noval', ...
            'No matching defaults value ''%s'' found.', defstr);
    end
    if nargin == 1
        varargout{1} = cdefval;
    else
        defs = subsasgn(defs, subs, defval);
    end
else
    cfg_message('ischar:defstr', 'Defaults key must be a string.');
end

function job = local_getjob(job)
if ~isstruct(job)
    cfg_message('isstruct:job', 'Job must be a struct.');
end