function varargout = dti_run_parcellation(cmd, varargin)
% Template function to implement callbacks for an cfg_exbranch. The calling
% syntax is
% varargout = cfg_run_template(cmd, varargin)
% where cmd is one of
% 'run'      - out = cfg_run_template('run', job)
%              Run a job, and return its output argument
% 'vout'     - dep = cfg_run_template('vout', job)
%              Examine a job structure with all leafs present and return an
%              array of cfg_dep objects.
% 'check'    - str = cfg_run_template('check', subcmd, subjob)
%              Examine a part of a fully filled job structure. Return an empty
%              string if everything is ok, or a string describing the check
%              error. subcmd should be a string that identifies the part of
%              the configuration to be checked.
% 'defaults' - defval = cfg_run_template('defaults', key)
%              Retrieve defaults value. key must be a sequence of dot
%              delimited field names into the internal def struct which is
%              kept in function local_def. An error is returned if no
%              matching field is found.
%              cfg_run_template('defaults', key, newval)
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
% 'run'      - @(job)cfg_run_template('run', job)
% 'vout'     - @(job)cfg_run_template('vout', job)
% 'check'    - @(job)cfg_run_template('check', 'subcmd', job)
% 'defaults' - @(val)cfg_run_template('defaults', 'defstr', val{:})
%              Note the list expansion val{:} - this is used to emulate a
%              varargin call in this function handle.
%
% This code is part of a batch job configuration system for MATLAB. See 
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id: cfg_run_template.m 315 2008-07-14 14:34:05Z glauche $

rev = '$Rev: 315 $'; %#ok

if ischar(cmd)
    switch lower(cmd)
        case 'run'
            job = local_getjob(varargin{1});
            % do computation, return results in variable out
            V = spm_vol(char(job.tracts));
            Vm= spm_vol(char(job.mask));
            spm_check_orientations([Vm;V(:)]);
            [vx vy vz] = ind2sub(Vm.dim(1:3),find(spm_read_vols(Vm)));
            dat = zeros(numel(V),numel(vx),'single');
            for k = 1:numel(V)
                tmp = spm_sample_vol(V(k), vx(:)', vy(:)', vz(:)', 0);
                tmp = tmp./max(tmp(:));%scale to max
                zind = tmp < eps|~isfinite(tmp);
                tmp = log(tmp);
                tmp(zind) = 0;
                dat(k, :) = single(tmp);%tmp*tmp';
            end
            [priors,means,covs,post] = spm_kmeans(dat,job.clustering.nc, ...
                                                  job.clustering.init,job.clustering.retcov);
            out.clustering.dat    = dat;
            out.clustering.priors = priors;
            out.clustering.means  = means;
            out.clustering.covs   = covs;
            out.clustering.post   = post;
            if isfield(job.reco,'rois')
                [ms, errStr] = maskstruct_read(job.reco.rois.maskstruct{1});
                if ~isempty(errStr)
                    error(errStr);
                end
                [sz errStr] = maskstruct_query(ms,'sizeAy');
                if ~isempty(errStr)
                    error(errStr);
                end
                if numel(job.reco.rois.ind) == 1 && ~isfinite(job.reco.rois.ind)
                    [mno errStr] = maskstruct_query(ms,'maskNo');
                    if ~isempty(errStr)
                        error(errStr);
                    end
                    ind = 1:mno;
                else
                    ind = job.reco.rois.ind;
                end
                if numel(ind) ~= size(dat,1)
                    error('Number of masks does not match number source images.');
                end
                dnc = floor(log10(job.clustering.nc))+1;
                [p n e v] = spm_fileparts(job.tracts{1});
                [mrs errStr] = maskstruct_query(ms,'getMRMask',1);
                if ~isempty(errStr)
                    error(errStr);
                end
                for k = 1:job.clustering.nc
                    out.ind{k} = ind(logical(post(:,k)));
                    cm = false(sz);
                    for l = out.ind{k}
                        [cm1 errStr] = maskstruct_query(ms,'getMask',l);
                        if ~isempty(errStr)
                            error(errStr);
                        end
                        cm = cm | cm1;
                    end
                    out.parcellation{k} = fullfile(p, sprintf('parc%d_%0*d%s%s', ...
                                                              job.clustering.nc, ...
                                                              dnc, k, n, ...
                                                              e));
                    mrs.dataAy = cm;
                    mrstruct_to_nifti(mrs, out.parcellation{k}, 'uint8');
                end
            end                    
            if nargout > 0
                varargout{1} = out;
            end
        case 'vout'
            job = local_getjob(varargin{1});
            % initialise empty cfg_dep array
            dep = cfg_dep;
            % determine outputs, return cfg_dep array in variable dep
            dep(1).sname  = 'Clustering data struct';
            dep(1).src_output = substruct('.','clustering');
            dep(1).tgt_spec   = cfg_findspec({{'strtype','e'}});
            if isfield(job.reco,'rois')
                dep(2)            = cfg_dep;
                dep(2).sname      = 'Parcellation images';
                dep(2).src_output = substruct('.','parcellation');
                dep(2).tgt_spec   = cfg_findspec({{'filter','image', ...
                                    'strtype','e'}});
            end
            if isnumeric(job.clustering.nc)
                for k = 1:job.clustering.nc
                    dep(k+2)            = cfg_dep;
                    dep(k+2).sname      = sprintf(['Selection index cluster ' ...
                    '%d'], k);
                    dep(k+2).src_output = substruct('.','ind','{}',{k});
                    dep(k+2).tgt_spec   = cfg_findspec({{'strtype','n'}});
                end
            end
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