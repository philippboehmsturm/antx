function varargout = dti_dw_wmean_variance(cmd, varargin)
% Generate a series of weighted mean and variance images from a DWI series
% varargout = dti_dw_wmean_variance(cmd, varargin)
% where cmd is one of
% 'run'      - out = dti_dw_wmean_variance('run', job)
%              Run a job, and return its output argument
% 'vout'     - dep = dti_dw_wmean_variance('vout', job)
%              Examine a job structure with all leafs present and return an
%              array of cfg_dep objects.
% 'check'    - str = dti_dw_wmean_variance('check', subcmd, subjob)
%              Examine a part of a fully filled job structure. Return an empty
%              string if everything is ok, or a string describing the check
%              error. subcmd should be a string that identifies the part of
%              the configuration to be checked.
% 'defaults' - defval = dti_dw_wmean_variance('defaults', key)
%              Retrieve defaults value. key must be a sequence of dot
%              delimited field names into the internal def struct which is
%              kept in function local_def. An error is returned if no
%              matching field is found.
%              dti_dw_wmean_variance('defaults', key, newval)
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
% 'run'      - @(job)dti_dw_wmean_variance('run', job)
% 'vout'     - @(job)dti_dw_wmean_variance('vout', job)
% 'check'    - @(job)dti_dw_wmean_variance('check', 'subcmd', job)
% 'defaults' - @(val)dti_dw_wmean_variance('defaults', 'defstr', val{:})
%              Note the list expansion val{:} - this is used to emulate a
%              varargin call in this function handle.
%
% This code is part of a batch job configuration system for MATLAB. See 
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id: dti_dw_wmean_variance.m 715 2010-09-01 15:14:38Z glauche $

rev = '$Rev: 715 $'; %#ok

if ischar(cmd)
    switch lower(cmd)
        case 'run'
            job = local_getjob(varargin{1});
            % do computation, return results in variable out
            Vi = spm_vol(char(job.srcimgs));
            Vm = rmfield(Vi,'private');
            [Vm.private] = deal([]);
            [Vm.descrip] = deal('weighted mean');
            [Vm.pinfo]   = deal([1;0;0]);
            [Vm.dt]      = deal([spm_type('float32') spm_platform('bigend')]);
            Vs = rmfield(Vi,'private');
            [Vs.private] = deal([]);
            [Vs.descrip] = deal('unbiased sample variance');
            [Vs.pinfo]   = deal([1;0;0]);
            [Vs.dt]      = deal([spm_type('float32') spm_platform('bigend')]);
            if false %isfield(bch.errorvar,'errauto')
                % ltol, dtol and sep can be set using the GUI and need to
                % be present in extbch
                extbch = bch.errorvar.errauto;
            else
                % only need to sort for b values
                extbch.ltol = 1;
                extbch.dtol = 0;
                extbch.sep  = 0;
            end;
            extbch.srcimgs = job.srcimgs;
            extbch.ref.refscanner = 1;
            extbch.saveinf = 0;
            extres = dti_extract_dirs(extbch);
            for cb = 1:numel(extres.ub)
                bsel = find(extres.ubj == cb);
                % angle between between diffusion directions - maximum
                % weight for angle zero, exp decay to angle pi/2
                cg = exp(-acos(abs(extres.allg(bsel,:)*extres.allg(bsel,:)')));
                cg = cg - min(cg(:));
                % or: cos(angle between between diffusion directions)
                % cg = abs(extres.allg(bsel,:)*extres.allg(bsel,:)');
                nsrc = numel(bsel);
                for k = 1:nsrc
                    [p n e] = spm_fileparts(Vi(bsel(k)).fname);
                    % weights according to angle between diffusion
                    % directions
                    if all(cg(k,:) == 0)
                        % no weighting in case of all-zero weights (b0
                        % images)
                        w = ones(size(cg(k,:)));
                    else
                        w = cg(k,:);
                    end
                    w = w./sum(w);
                    % compute weighted mean
                    Vm(bsel(k)).fname = fullfile(p, ['m' job.infix n e]);
                    Vm(bsel(k)) = spm_imcalc(Vi(bsel),Vm(bsel(k)),'w*X',{1},w);
                    % compute unbiased weighted sample variance - see
                    % http://en.wikipedia.org/wiki/Weighted_mean#Weighted_sample_variance
                    Vs(bsel(k)).fname = fullfile(p, ['s' job.infix n e]);
                    u  = 1/(1-sum(w.^2)); % unbiased weighting
                    Vs(bsel(k)) = spm_imcalc([Vm(bsel(k)); Vi(bsel)], ...
                                             Vs(bsel(k)),'u*w*(X(2:end,:)-repmat(X(1,:),nsrc,1)).^2',{1},u,w,nsrc);
                end
            end
            out.wmean = {Vm.fname};
            out.wvar  = {Vs.fname};
            if nargout > 0
                varargout{1} = out;
            end
        case 'vout'
            job = local_getjob(varargin{1});
            % initialise empty cfg_dep array
            dep(1)            = cfg_dep;
            dep(1).sname      = 'Weighted mean images';
            dep(1).src_output = substruct('.','wmean');
            dep(1).tgt_spec   = cfg_findspec({{'filter','image'}});
            dep(2)            = cfg_dep;
            dep(2).sname      = 'Weighted variance images';
            dep(2).src_output = substruct('.','wvar');
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