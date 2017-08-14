function varargout = tbxrend_multi_cmip(cmd, varargin)
% Template function to implement callbacks for an cfg_exbranch. The calling
% syntax is
% varargout = tbxrend_multi_cmip(cmd, varargin)
% where cmd is one of
% 'run'      - out = tbxrend_multi_cmip('run', job)
%              Run a job, return an object handle for each mip.
% 'vout'     - dep = tbxrend_multi_cmip('vout', job)
%              Examine a job structure, return a cfg_dep object for each
%              mip.
% 'check'    - str = tbxrend_multi_cmip('check', subcmd, subjob)
%              Valid subcmd
%              'spmmip' - check whether subjob.XYZ and subjob.Z have the
%                         same length
% 'defaults' - defval = tbxrend_multi_cmip('defaults', key)
%              Valid key
%              'colour' - colour for new mip
%
% This code is part of a batch job configuration system for MATLAB. See 
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id: tbxrend_multi_cmip.m 728 2012-05-31 07:52:56Z glauche $

rev = '$Rev: 728 $'; %#ok

if ischar(cmd)
    switch lower(cmd)
        case 'run'
            job = local_getjob(varargin{1});
            % do computation, return results in variable out
            out = zeros(1,numel(job.mips)+1);
            %-Display format
            %==========================================================================
            load(spm_get_defaults('stats.results.mipmat'));
            
            %-Single slice case
            %--------------------------------------------------------------------------
            if isempty(job.units{3})
                
                %-2d case
                %----------------------------------------------------------------------
                if ~job.bgopts.grid
                    grid_trans = zeros(size(grid_trans)); %#ok<NODEF>
                end
                if ~job.bgopts.outline
                    mask_trans = zeros(size(mask_trans)); %#ok<NODEF>
                end
                mip = 4*grid_trans + mask_trans;
        
            elseif job.units{3} == '%'
                
                %-3d case: Space-time
                %----------------------------------------------------------------------
                if ~job.bgopts.grid
                    grid_time = zeros(size(grid_time)); %#ok<NODEF>
                end
                if ~job.bgopts.outline
                    mask_trans = zeros(size(mask_trans)); %#ok<NODEF>
                end
                mip = 4*grid_time + mask_trans;

            else
                %-3d case: Space
                %----------------------------------------------------------------------
                if ~job.bgopts.grid
                    grid_all = zeros(size(grid_all)); %#ok<NODEF>
                end
                if ~job.bgopts.outline
                    mask_all = zeros(size(grid_all));
                end
                mip = 4*grid_all + mask_all;
            end

            % Load mip and create maximum intensity projection
            %--------------------------------------------------------------------------
            szmip = size(mip);
            mip  = rot90(mip/max(mip(:)));
            figure('color','white');
            out(end) = image('cdata',zeros([size(mip) 3]), 'alphadata',.5*mip);
            axis tight; axis off;daspect([1 1 1]);
            set(gca, 'YDir','reverse');
            hold on;
            
            for k = 1:numel(job.mips)
                switch char(fieldnames(job.mips(k).mip))
                    case 'filemip',
                        V       = spm_vol(job.mips(k).mip.filemip{1});
                        [Z XYZ] = spm_read_vols(V);
                        if min(Z(:)) >= 0
                            sel     = ~isnan(Z(:)) & Z(:) > 0;
                        else
                            sel     = ~isnan(Z(:));
                        end
                        sel     = sel & Z(:) >= job.mips(k).range(1) & Z(:) <= job.mips(k).range(2);
                        Z       = Z(sel);
                        XYZ     = XYZ(:,sel(:));
                        M       = V.mat;
                    case 'spmmip',
                        Z   = job.mips(k).mip.spmmip.Z;
                        XYZ = job.mips(k).mip.spmmip.XYZ;
                        M   = job.mips(k).mip.spmmip.M;
                end
                sel = XYZ(1,:) >= job.mips(k).bbox(1,1) & XYZ(1,:) <= job.mips(k).bbox(2,1) & ...
                    XYZ(2,:) >= job.mips(k).bbox(1,2) & XYZ(2,:) <= job.mips(k).bbox(2,2) & ...
                    XYZ(3,:) >= job.mips(k).bbox(1,3) & XYZ(3,:) <= job.mips(k).bbox(2,3);
                out(k) = local_mip(Z(sel), XYZ(:,sel), M, job.mips(k).colour, job.mips(k).alpha, job.mips(k).invert, szmip);
            end
            if nargout > 0
                varargout{1} = out;
            end
        case 'vout'
            job = local_getjob(varargin{1});
            % initialise empty cfg_dep array
            dep = cfg_dep;
            dep = dep(false);
            % determine outputs, return cfg_dep array in variable dep
            for k = 1:numel(job.mips)
                dep(k)            = cfg_dep;
                dep(k).sname      = sprintf('Graphics handle (MIP %d)', k);
                dep(k).src_output = substruct('()',{k});
                dep(k).tgt_spec   = cfg_findspec({{'strtype','e'}});
            end
            dep(numel(job.mips)+1)            = cfg_dep;
            dep(numel(job.mips)+1).sname      = 'Graphics handle (MIP outline)';
            dep(numel(job.mips)+1).src_output = substruct('()',{numel(job.mips)+1});
            dep(numel(job.mips)+1).tgt_spec   = cfg_findspec({{'strtype','e'}});            
            varargout{1} = dep;
        case 'check'
            if ischar(varargin{1})
                subcmd = lower(varargin{1});
                subjob = varargin{2};
                str = '';
                switch subcmd
                    % implement checks, return status string in variable str
                    case 'spmmip'
                        if size(subjob.Z, 2) ~= size(subjob.XYZ, 2)
                            str = sprintf('Size mismatch: size(Z,2) = %d does not match size(XYZ,2) = %d', ...
                                size(subjob.Z,1), size(subjob.XYZ, 1));
                        end
                    case 'units'
                        if ~iscellstr(subjob)
                            str = sprintf('Value for ''units'' must be a cellstr.');
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
    defs.colour = [1 0 0]';
    defs.alpha  = [.25 .9];
    defs.units  = {'mm' 'mm' 'mm'};
    defs.range  = [-Inf Inf];
    defs.bbox   = [-Inf -Inf -Inf; Inf Inf Inf];
    defs.grid   = true;
    defs.outline= true;
    defs.invert = false;
end
if ischar(defstr)
    % construct subscript reference struct from dot delimited tag string
    tags = textscan(defstr,'%s', 'delimiter','.');
    subs = struct('type','.','subs',tags{1}');
    try
        cdefval = subsref(defs, subs);
    catch %#ok<CTCH>
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

function h = local_mip(Z, XYZ, M, col, alpha, invert, szmip)
Z    = Z - min(Z);
mx   = max(Z);
if invert
    Z = mx - Z;
end
if isempty(mx),
    Z = [];
elseif isfinite(mx) && (numel(Z) ~= 1),
    Z = (alpha(2)-alpha(1))*Z/max(Z) + alpha(1);
else
    Z = alpha(2)*ones(1,length(Z));
end

% Create maximum intensity projection
%--------------------------------------------------------------------------
c    = [0 0 0 ;
        0 0 1 ;
        0 1 0 ;
        0 1 1 ;
        1 0 0 ;
        1 0 1 ; 
        1 1 0 ; 
        1 1 1 ] - 0.5;
c    = c*M(1:3,1:3);
dim  = [(max(c) - min(c)) szmip];
adata = rot90(spm_project(Z,round(XYZ),dim));
cdata = cat(3, col(1)*ones(size(adata)), col(2)*ones(size(adata)), ...
    col(3)*ones(size(adata)));
h = image('cdata',cdata, 'alphadata',adata);
