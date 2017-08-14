function varargout = tbxvol_orth_conditions(cmd, varargin)
% Orthogonalise conditions in an SPM design matrix.
% By default, SPM does not orthogonalise timeseries of different
% conditions. Under some conditions two conditions may be highly correlated
% (usually due to an imperfect experimental design). If only one of them is
% of interest, then the remaining ones can be orthogonalised with respect
% to this condition. The regressors of the orthogonalised conditions are
% no longer meaningful in itself, they only describe extra variance not
% caught by the regressors for the condition of interest.
%
% varargout = tbxvol_orth_conditions(cmd, varargin)
% where cmd is one of
% 'run'      - out = tbxvol_orth_conditions('run', job)
%              Run a job, and return its output argument
% 'vout'     - dep = tbxvol_orth_conditions('vout', job)
%              Examine a job structure with all leafs present and return an
%              array of cfg_dep objects.
% 'check'    - str = tbxvol_orth_conditions('check', subcmd, subjob)
%              Examine a part of a fully filled job structure. Return an empty
%              string if everything is ok, or a string describing the check
%              error. subcmd should be a string that identifies the part of
%              the configuration to be checked.
% 'defaults' - defval = tbxvol_orth_conditions('defaults', key)
%              Retrieve defaults value. key must be a sequence of dot
%              delimited field names into the internal def struct which is
%              kept in function local_def. An error is returned if no
%              matching field is found.
%              tbxvol_orth_conditions('defaults', key, newval)
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
% 'run'      - @(job)tbxvol_orth_conditions('run', job)
% 'vout'     - @(job)tbxvol_orth_conditions('vout', job)
% 'check'    - @(job)tbxvol_orth_conditions('check', 'subcmd', job)
% 'defaults' - @(val)tbxvol_orth_conditions('defaults', 'defstr', val{:})
%              Note the list expansion val{:} - this is used to emulate a
%              varargin call in this function handle.
%
% This code is part of a batch job configuration system for MATLAB. See 
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id: tbxvol_orth_conditions.m 631 2008-09-02 12:18:36Z glauche $

rev = '$Rev: 631 $'; %#ok

if ischar(cmd)
    switch lower(cmd)
        case 'run'
            job = local_getjob(varargin{1});
            % do computation, return results in variable out
            load(job.srcspm{1});
            for k=1:numel(job.Sess)
                Fcind = SPM.Sess(job.Sess(k).num).col(cat(2,SPM.Sess(job.Sess(k).num).Fc(job.Sess(k).c).i));
                SPM.xX.X(:,Fcind) = spm_orth(SPM.xX.X(:,Fcind));
            end
            out.outspm = job.srcspm;
            copyfile(job.srcspm{1}, sprintf('%s.save',job.srcspm{1}));
            save(out.outspm{1},'SPM','-v7')
            if nargout > 0
                varargout{1} = out;
            end
        case 'vout'
            job = local_getjob(varargin{1});
            % initialise empty cfg_dep array
            dep = cfg_dep;
            % determine outputs, return cfg_dep array in variable dep
            dep(1).sname      = 'SPM.mat (orthogonalised)';
            dep(1).src_output = substruct('.','outspm');
            dep(1).tgt_spec   = cfg_findspec({{'strtype','e','filter','mat'}});
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