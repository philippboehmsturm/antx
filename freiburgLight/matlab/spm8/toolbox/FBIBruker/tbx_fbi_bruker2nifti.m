function varargout = tbx_fbi_bruker2nifti(cmd, varargin)
% Convert bruker 2dseq files to NIfTI. The calling
% syntax is
% varargout = tbx_fbi_bruker2nifti(cmd, varargin)
% where cmd is one of
% 'run'      - out = tbx_fbi_bruker2nifti('run', job)
%              Convert data.
% 'vout'     - dep = tbx_fbi_bruker2nifti('vout', job)
%              Return virtual output objects. For each 2dseq file, a
%              separate output will be created. This output will contain
%              the list of NIfTI files converted from the 2dseq file.
% 'check'    - str = tbx_fbi_bruker2nifti('check', subcmd, subjob)
% 'defaults' - defval = tbx_fbi_bruker2nifti('defaults', key)
%  not implemented
%
% This code is part of a toolbox for SPM. It requires bruker read routines
% and mrstruct read/write routines from MedPhys.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id: tbx_fbi_bruker2nifti.m 1 2011-01-19 13:04:16Z volkmar $

rev = '$Rev: 1 $'; %#ok

if ischar(cmd)
    switch lower(cmd)
        case 'run'
            job = local_getjob(varargin{1});
            out.images = cell(size(job.infiles));
            % do computation, return results in variable out
            for ci = 1:numel(job.infiles)
                dirStr = fileparts(job.infiles{ci});
                dirStr = sprintf('%s%s', dirStr, filesep); % read_*_bruker assumes filesep at end of dirStr
                % read bruker data into mrstruct - see bruker_read_model
                % 255ff
                try
                    infoStruct = read_info_bruker(dirStr);
                catch
                    error('tbx_fbi_bruker2nifti:read_info_bruker',...
                        'Could not read header information for file ''%s''.',job.infiles{ci});
                end
                if isempty(infoStruct)
                    error('tbx_fbi_bruker2nifti:read_info_bruker',...
                        'Could not read header information for file ''%s''.',job.infiles{ci});
                end                    
                [mrStruct, errStr] = read_bruker(dirStr, infoStruct.byte_order);
                if ~isempty(errStr)
                    error('tbx_fbi_bruker2nifti:read_bruker', 'File ''%s'': error ''%s''.', job.infiles{ci}, errStr);
                end
                if isempty(mrStruct)
                    error('tbx_fbi_bruker2nifti:read_bruker',...
                        'No data found in file ''%s''.',job.infiles{ci});
                end
                switch char(fieldnames(job.createsubdir))
                    case 'useoutdir'
                        outdir = job.outdir{1};
                    case 'usefilepath'
                        % assume [<subject>]/<seq#>/pdata/<seq1#>/2dseq path
                        str = textscan(job.infiles{ci},'%s','delimiter',filesep);
                        if numel(str{1}) >= 5
                            outdir = fullfile(job.outdir{1}, sprintf('%s_%s_%s', str{1}{end-4}, str{1}{end-3}, str{1}{end-1}));
                        else
                            outdir = fullfile(job.outdir{1}, sprintf('%s_%s', str{1}{end-3}, str{1}{end-1}));
                        end
                    case 'newsubdir'
                        outdir = fullfile(job.outdir{1}, sprintf('%s%0*d', job.createsubdir.newsubdir, floor(log10(numel(job.infiles)))+1, ci));                            
                end
                if ~exist(outdir,'dir')
                    mkdir(outdir);
                end
                [imgs errstr] = mrstruct_to_nifti(mrStruct, fullfile(outdir,'image.nii'), job.dt);
                if ~isempty(errstr)
                    error('tbx_fbi_bruker2nifti:mrstruct_to_nifti',errstr);
                end
                imgs = [imgs{:}];
                out.images{ci} = {imgs.fname}';
            end
            if nargout > 0
                varargout{1} = out;
            end
        case 'vout'
            job = local_getjob(varargin{1});
            % initialise empty cfg_dep array
            dep = repmat(cfg_dep,size(job.infiles));
            % determine outputs, return cfg_dep array in variable dep
            for ci = 1:numel(job.infiles)
                dep(ci).sname      = sprintf('Converted Images - Source File %d', ci);
                dep(ci).src_output = substruct('.','images','{}',{ci});
                dep(ci).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
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