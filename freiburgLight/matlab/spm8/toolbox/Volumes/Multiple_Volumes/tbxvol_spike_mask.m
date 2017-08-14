function varargout = tbxvol_spike_mask(cmd, varargin)
% Template function to implement callbacks for an cfg_exbranch. The calling
% syntax is
% varargout = tbxvol_spike_mask(cmd, varargin)
% where cmd is one of
% 'run'      - out = tbxvol_spike_mask('run', job)
%              Run a job, and return its output argument
% 'vout'     - dep = tbxvol_spike_mask('vout', job)
%              Examine a job structure with all leafs present and return an
%              array of cfg_dep objects.
% 'check'    - str = tbxvol_spike_mask('check', subcmd, subjob)
%              Examine a part of a fully filled job structure. Return an empty
%              string if everything is ok, or a string describing the check
%              error. subcmd should be a string that identifies the part of
%              the configuration to be checked.
% 'defaults' - defval = tbxvol_spike_mask('defaults', key)
%              Retrieve defaults value. key must be a sequence of dot
%              delimited field names into the internal def struct which is
%              kept in function local_def. An error is returned if no
%              matching field is found.
%              tbxvol_spike_mask('defaults', key, newval)
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
% 'run'      - @(job)tbxvol_spike_mask('run', job)
% 'vout'     - @(job)tbxvol_spike_mask('vout', job)
% 'check'    - @(job)tbxvol_spike_mask('check', 'subcmd', job)
% 'defaults' - @(val)tbxvol_spike_mask('defaults', 'defstr', val{:})
%              Note the list expansion val{:} - this is used to emulate a
%              varargin call in this function handle.
%
% This code is part of a batch job configuration system for MATLAB. See 
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id: tbxvol_spike_mask.m 720 2011-09-27 05:11:51Z glauche $

rev = '$Rev: 720 $'; %#ok

if ischar(cmd)
    switch lower(cmd)
        case 'run'
            job = local_getjob(varargin{1});
            % do computation, return results in variable out
            spm_progress_bar('Init',numel(job.srcimgs),'','images completed');
            VM = spm_vol(job.masking.maskimg{1});
            sel = true(size(job.srcimgs));
            for ci = 1:numel(job.srcimgs)
                Vi = [spm_vol(job.srcimgs{ci}) VM];
                %-Loop over planes
                %-----------------------------------------------------------------------
                for p = 1:Vi(1).dim(3),
                    B = spm_matrix([0 0 -p 0 0 0 1 1 1]);
                    X=zeros(2,prod(Vi(1).dim(1:2)));
                    for i = 1:2
                        M = inv(B*inv(Vi(1).mat)*Vi(i).mat);
                        d = spm_slice_vol(Vi(i),M,Vi(1).dim(1:2),[0,NaN]);
                        d(isnan(d))=0;
                        X(i,:) = d(:)';
                    end
                    if job.masking.invert
                        sel(ci) = sum(X(1,:).*(1-X(2,:)) > job.crit.thresh)./sum(1-X(2,:)) < job.crit.ratio;
                    else
                        sel(ci) = sum(X(1,:).*X(2,:) > job.crit.thresh)./sum(X(2,:)) < job.crit.ratio;
                    end
                    if ~sel(ci)
                        % found a bad slice
                        break
                    end
                end
                spm_progress_bar('set',ci);
            end
            spm_progress_bar('clear');
            out.goodimgs = job.srcimgs(sel);
            out.badimgs  = job.srcimgs(~sel);
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
            % determine outputs, return cfg_dep array in variable dep
            varargout{1} = dep;
        case 'check'
            if ischar(varargin{1})
                subcmd = lower(varargin{1});
                subjob = varargin{2};
                str = '';
                switch subcmd
                    % implement checks, return status string in variable str
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
        cdefval = subsref(defs, subs);
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