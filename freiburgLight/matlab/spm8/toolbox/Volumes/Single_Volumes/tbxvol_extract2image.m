function varargout = tbxvol_extract2image(cmd, varargin)
% Place output from tbxvol_extract back into an image
% varargout = tbxvol_extract2image(cmd, varargin)
% where cmd is one of
% 'run'      - out = tbxvol_extract2image('run', job)
%              Run a job, and return its output argument
%              job has the following fields
%              .outdir
%              .outfilename
%              .dtype
%              .extsrc
%                  either .extspec or .extvar. extvar is a extraction
%                  variable, .extspec is a struct with fields
%                      .fname file name of image defining reference space
%                      .raw   data
%                      .posvx position of voxels in voxel space
% 'vout'     - dep = tbxvol_extract2image('vout', job)
%              Examine a job structure with all leafs present and return an
%              array of cfg_dep objects.
% 'check'    - str = tbxvol_extract2image('check', subcmd, subjob)
%              Examine a part of a fully filled job structure. Return an empty
%              string if everything is ok, or a string describing the check
%              error. subcmd should be a string that identifies the part of
%              the configuration to be checked.
% 'defaults' - defval = tbxvol_extract2image('defaults', key)
%              Retrieve defaults value. key must be a sequence of dot
%              delimited field names into the internal def struct which is
%              kept in function local_def. An error is returned if no
%              matching field is found.
%              tbxvol_extract2image('defaults', key, newval)
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
% 'run'      - @(job)tbxvol_extract2image('run', job)
% 'vout'     - @(job)tbxvol_extract2image('vout', job)
% 'check'    - @(job)tbxvol_extract2image('check', 'subcmd', job)
% 'defaults' - @(val)tbxvol_extract2image('defaults', 'defstr', val{:})
%              Note the list expansion val{:} - this is used to emulate a
%              varargin call in this function handle.
%
% This code is part of a batch job configuration system for MATLAB. See 
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id: tbxvol_extract2image.m 680 2009-09-15 12:56:30Z glauche $

rev = '$Rev: 680 $'; %#ok

if ischar(cmd)
    switch lower(cmd)
        case 'run'
            job = local_getjob(varargin{1});
            % do computation, return results in variable out
            % get volume information for output image - must be the same
            % orientation and voxel size as the extraction space
            if isfield(job.extsrc,'extspec')
                ext = job.extsrc.extspec;
                ext.Vspace = rmfield(spm_vol(job.extsrc.extspec.fspace),'private');
            elseif isfield(job.extsrc,'extvar')
                ext = job.extsrc.extvar;
            end
            % set new filename and scaling
            [p n e v] = spm_fileparts(job.outfilename);
            if ~any(strcmpi(e,{'.img','.nii'}))
                e = '.nii';
            end
            if job.dtype > 0
                ext.Vspace.dt(1) = job.dtype;
            end
            ext.Vspace.fname = fullfile(job.outdir{1}, [n e v]);
            ext.Vspace.pinfo(1:2) = inf;
            % create output array
            dat = zeros(ext.Vspace.dim);
            % ext is the extraction structure - use its position
            % information to get a linear index into the data array
            ind = sub2ind(ext.Vspace.dim(1:3), round(ext.posvx(1,:)), ...
                round(ext.posvx(:,2)), round(ext.posvx(:,3)));
            % put back all raw data - this will work only for single-volume
            % extracted data
            dat(ind) = ext.raw;
            % write the image
            spm_create_vol(ext.Vspace);
            spm_write_vol(ext.Vspace,dat);
            out.image = {ext.Vspace.fname};
            if nargout > 0
                varargout{1} = out;
            end
        case 'vout'
            job = local_getjob(varargin{1});
            % initialise empty cfg_dep array
            dep = cfg_dep;
            dep.sname = 'Exported image';
            dep.src_output = substruct('.','image');
            dep.tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
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