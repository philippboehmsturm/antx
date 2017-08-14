function varargout = spm_run_check_reg_adv(cmd, varargin)
% Template function to implement callbacks for an cfg_exbranch. The calling
% syntax is
% varargout = spm_run_check_reg_adv(cmd, varargin)
% where cmd is one of
% 'run'      - out = spm_run_check_reg_adv('run', job)
%              Run a job, and return its output argument
% 'vout'     - dep = spm_run_check_reg_adv('vout', job)
%              Examine a job structure with all leafs present and return an
%              array of cfg_dep objects.
% 'check'    - str = spm_run_check_reg_adv('check', subcmd, subjob)
%              Examine a part of a fully filled job structure. Return an empty
%              string if everything is ok, or a string describing the check
%              error. subcmd should be a string that identifies the part of
%              the configuration to be checked.
% 'defaults' - defval = spm_run_check_reg_adv('defaults', key)
%              Retrieve defaults value. key must be a sequence of dot
%              delimited field names into the internal def struct which is
%              kept in function local_def. An error is returned if no
%              matching field is found.
%              spm_run_check_reg_adv('defaults', key, newval)
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
% 'run'      - @(job)spm_run_check_reg_adv('run', job)
% 'vout'     - @(job)spm_run_check_reg_adv('vout', job)
% 'check'    - @(job)spm_run_check_reg_adv('check', 'subcmd', job)
% 'defaults' - @(val)spm_run_check_reg_adv('defaults', 'defstr', val{:})
%              Note the list expansion val{:} - this is used to emulate a
%              varargin call in this function handle.
%
% This code is part of a batch job configuration system for MATLAB. See 
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id: spm_run_check_reg_adv.m 664 2012-01-18 08:51:41Z vglauche $

rev = '$Rev: 664 $'; %#ok

if ischar(cmd)
    switch lower(cmd)
        case 'run'
            job = local_getjob(varargin{1});
            % do computation, return results in variable out
            % display images
            spm_check_registration(char([job.imdisp.fname]'));
            % modify settings, if necessary
            global st;
            for k = 1:numel(job.imdisp)
                st.vols{k}.mapping = job.imdisp(k).mapping;
                if isfield(job.imdisp(k).window,'auto')
                    st.vols{k}.window = 'auto';
                else
                    st.vols{k}.window = job.imdisp(k).window.manual;
                end
                switch char(fieldnames(job.imdisp(k).blobs))
                    case 'blob'
                        switch char(fieldnames(job.imdisp(k).blobs.blob.bsource))
                            case 'image'
                                spm_orthviews('addimage',k,job.imdisp(k).blobs.blob.bsource.image{1});
                            otherwise
                                warning('Unsupported blob source');
                        end
                        if isfield(job.imdisp(k).blobs.blob.window,'manual')
                            st.vols{k}.blobs{1}.min = job.imdisp(k).blobs.blob.window.manual(1);
                            st.vols{k}.blobs{1}.max = job.imdisp(k).blobs.blob.window.manual(2);
                        end
                    case 'cblob'
                        for l = 1:numel(job.imdisp(k).blobs.cblob)
                            switch char(fieldnames(job.imdisp(k).blobs.cblob(l).bsource))
                                case 'image'
                                    for cimg = 1:numel(job.imdisp(k).blobs.cblob(l).bsource.image)
                                        spm_orthviews('addcolouredimage',k,job.imdisp(k).blobs.cblob(l).bsource.image{cimg},job.imdisp(k).blobs.cblob(l).colour);
                                    end
                                otherwise
                                    warning('Unsupported blob source');
                            end
                            if isfield(job.imdisp(k).blobs.cblob(l).window,'manual')
                                st.vols{k}.blobs{l}.min = job.imdisp(k).blobs.cblob(l).window.manual(1);
                                st.vols{k}.blobs{l}.max = job.imdisp(k).blobs.cblob(l).window.manual(2);
                            end
                        end
                end
            end
            spm_orthviews('redraw');
            if nargout > 0
                varargout{1} = out;
            end
        case 'vout'
            job = local_getjob(varargin{1});
            % initialise empty cfg_dep array
            dep = cfg_dep;
            dep = dep(false);
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