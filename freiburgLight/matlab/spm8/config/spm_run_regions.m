function varargout = spm_run_regions(cmd, varargin)
% Batch callback to extract data from a ROI - This is Freiburg specific!!
% varargout = spm_run_regions(cmd, varargin)
% where cmd is one of
% 'run'      - out = spm_run_regions('run', job)
%              Run extract job. Extracted data are both saved into VOI .mat
%              file in the SPM.mat directory and returned as output
%              arguments.
%              out is a 1-by-#VOI struct array with fields
%              .fname - cell string containing file name of VOI .mat file
%              .Y     - eigenvariate of filtered data for VOI
%              .xY    - VOI description as returned from spm_regions
% 'vout'     - dep = spm_run_regions('vout', job)
%              Create virtual output descriptions for each VOI.
%
% This code is part of a batch job configuration system for MATLAB. See 
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id: spm_run_regions.m 662 2011-09-13 08:01:25Z vglauche $

rev = '$Rev: 662 $'; %#ok

cfg_message('spm-freiburg:deprecated', 'This function is deprecated and will be removed from future releases of SPM(Freiburg). Please use "Batch->Util->Volume of Interest" instead.');

if ischar(cmd)
    switch lower(cmd)
        case 'run'
            opwd = pwd;
            job = local_getjob(varargin{1});
            % get SPM and contrast-based mask
            if isfield(job.srcspm.smask,'conspec')
                % code taken from spm_run_results.m
                xSPM.swd        = spm_str_manip(job.srcspm.spmmat{1},'H');
                xSPM.Ic         = job.srcspm.smask.conspec.contrasts;
                xSPM.u          = job.srcspm.smask.conspec.thresh;
                xSPM.Im         = [];
                if ~isempty(job.srcspm.smask.conspec.mask)
                    xSPM.Im     = job.srcspm.smask.conspec.mask.contrasts;
                    xSPM.pm     = job.srcspm.smask.conspec.mask.thresh;
                    xSPM.Ex     = job.srcspm.smask.conspec.mask.mtype;
                end
                xSPM.thresDesc  = job.srcspm.smask.conspec.threshdesc;
                xSPM.title      = '';
                xSPM.k          = job.srcspm.smask.conspec.extent;
                [SPM xSPM] = spm_getSPM(xSPM);
            else
                % get all inmask voxels
                tmp          = load(job.srcspm.spmmat{1});
                SPM          = tmp.SPM;
                cd(SPM.swd);
                [msk, XYZmm] = spm_read_vols(SPM.VM);
                xSPM.XYZmm   = XYZmm(:,msk(:)~=0);
                XYZ          = SPM.VM.mat\[xSPM.XYZmm;ones(1,size(xSPM.XYZmm,2))];
                xSPM.XYZ     = XYZ(1:3,:);
                xSPM.M       = SPM.VM.mat;
            end
            nVOI = numel(job.xY);
            out = repmat(struct('fname',{{}},'Y',[],'xY',struct([])),1,nVOI);
            for cVOI = 1:nVOI
                xY = rmfield(job.xY(cVOI),'voi');
                % go to nearest coordinate
                xyzvx = round(SPM.VM.mat\[xY.xyz; 1]);
                xyzvx(xyzvx<1) = 1;
                xyzvx = min(xyzvx,[SPM.VM.dim(1:3)';1]);
                xyz = SPM.VM.mat*xyzvx;
                xY.xyz=xyz(1:3);
                % decompose cfg_choice for VOI type
                xY.def = char(fieldnames(job.xY(cVOI).voi));
                xY.spec = job.xY(cVOI).voi.(xY.def);
                [out(cVOI).Y, out(cVOI).xY] = spm_regions(xSPM, SPM, [], xY);
                % code taken from spm_regions.m
                out(cVOI).fname = {fullfile(SPM.swd, sprintf('VOI_%s_%i.mat',out(cVOI).xY.name,out(cVOI).xY.Sess))};
            end
            cd(opwd);
            if nargout > 0
                varargout{1} = out;
            end
        case 'vout'
            job = local_getjob(varargin{1});
            % initialise cfg_dep array
            nVOI = numel(job.xY);
            dep = repmat(cfg_dep,1,3*nVOI);
            % determine outputs, return cfg_dep array in variable dep
            for cVOI = 1:nVOI
                if ischar(job.xY(cVOI).name) && ~strcmp(job.xY(cVOI).name, '<UNDEFINED>')
                    VOIname = sprintf('VOI(%d): ''%s''', cVOI, job.xY(cVOI).name);
                else
                    VOIname = sprintf('VOI(%d)', cVOI);
                end
                dep(3*(cVOI-1)+1).sname      = sprintf('%s - VOI file', VOIname);
                dep(3*(cVOI-1)+1).src_output = substruct('()',{cVOI},'.','fname');
                dep(3*(cVOI-1)+1).tgt_spec   = cfg_findspec({{'filter','mat','strtype','e'}});
                dep(3*(cVOI-1)+2).sname      = sprintf('%s - Eigenvariate', VOIname);
                dep(3*(cVOI-1)+2).src_output = substruct('()',{cVOI},'.','Y');
                dep(3*(cVOI-1)+2).tgt_spec   = cfg_findspec({{'strtype','r'}});
                dep(3*(cVOI-1)+3).sname      = sprintf('%s - VOI struct', VOIname);
                dep(3*(cVOI-1)+3).src_output = substruct('()',{cVOI},'.','xY');
                dep(3*(cVOI-1)+3).tgt_spec   = cfg_findspec({{'strtype','e'}});
            end
            varargout{1} = dep;
        case 'check'
            if ischar(varargin{1})
                subcmd = lower(varargin{1});
                subjob = varargin{2};
                str = '';
                switch subcmd
                    % implement checks, return status string in variable str
                    case 'contrasts'
                        if ~all(isfinite(subjob))
                            str = 'Contrast number must be a finite number.';
                        end
                    case 'srcspm'
                        % check whether specified contrasts exist in SPM.mat
                        if isfield(subjob.smask, 'conspec')
                            tmp = load(subjob.spmmat{1});
                            if ~isempty(subjob.smask.conspec.mask)
                                mxc  = max([subjob.smask.conspec.contrasts subjob.smask.conspec.mask.contrasts]);
                            else
                                mxc = max(subjob.smask.conspec.contrasts);
                            end
                            if mxc > numel(tmp.SPM.xCon)
                                str = sprintf('Contrast numbers must be in the range [1 %d]', numel(tmp.SPM.xCon));
                            end
                        end
                    case 'regions'
                        % check whether Ic refers to an F contrast
                        Ics = [subjob.xY.Ic];
                        Ics = Ics(Ics>0); % find non-zero Ic's
                        if ~isempty(Ics)
                            tmp = load(subjob.srcspm.spmmat{1});
                            if max(Ics) > numel(tmp.SPM.xCon)
                                str = sprintf('Contrast numbers must be in the range [1 %d]', numel(tmp.SPM.xCon));
                            elseif ~all(strcmp({tmp.SPM.xCon(Ics).STAT},'F'))
                                str = 'Contrasts for adjustment must be F contrasts.';
                            end
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