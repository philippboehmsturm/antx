function ret = spm_ov_tracepath(varargin)
% Wrapper for dti_tracepath
% This function provides an interface to dti_tracepath from
% an spm_orthviews display. The main features include:
% ROI selection alternatives
% - cross hair selection for start and end point of a profile line
% (after selection, the line will be added as a yellow blob to the
% displayed image)
% - ROI specification based on displayed blobs (1 ROI per blob set)
% - ROI specification from active ROI tool
% - ROI specification from saved files (1 ROI per file)
% - Current crosshair position
% - Sphere at current crosshair position
% Paths are displayed as coloured blob overlays.
%
% This routine is a plugin to spm_orthviews for SPM5. For general help about
% spm_orthviews and plugins type
%             help spm_orthviews
% at the matlab prompt.
%_______________________________________________________________________
%
% @(#) $Id: spm_ov_extract.m 151 2006-11-22 17:24:12Z glauche $

rev = '$Revision: 151 $';

global st;
if isempty(st)
    error(['%s: This routine can only be called as a plugin for' ...
        ' spm_orthviews!'], mfilename);
end;

if nargin < 2
    error(['%s: Wrong number of arguments. Usage:' ...
        ' spm_orthviews(''extract'', cmd, volhandle, varargin)'], ...
        mfilename);
end;

cmd = lower(varargin{1});
volhandle = varargin{2};

switch cmd

    %-------------------------------------------------------------------------
    % Context menu and callbacks
    case 'context_menu'
        if ~any(exist('dti_tracepath')==2:6)
            warning([mfilename ':init'], 'function dti_tracepath not found!');
            return;
        end;
        item0 = uimenu(varargin{3}, 'Label', 'DTI Trace Path', ...
            'Callback', sprintf(...
            'feval(''%s'',''context_init'', %d);', ...
            mfilename, volhandle),...
            'Tag', sprintf('%s_0_%d', upper(mfilename),...
            num2str(volhandle)));
    case 'context_init'
        possel = {'Sphere at Current Point','Current Point','ROI file(s)'};
        posselsrc = {'sphere','point','froi'};
        if isfield(st.vols{volhandle},'roi')
            possel{end+1} = 'Current ROI';
            posselsrc{end+1} = 'croi';
        elseif isfield(st.vols{volhandle},'blobs')
            possel{end+1} = 'Current blobs';
            posselsrc{end+1} = 'blobs';
        end;
        possel = char(spm_input('Voxels to start backtracing from', '+1', 'm', possel, ...
            posselsrc));
        bch.prefix = ''; % Want to have path returned as 3D array
        bch.trace{1} = spm_select([1 1], 'image', 'Select trace file');
        VT = spm_vol(bch.trace{1});
        switch possel
            case 'croi'
                roilist = round(VT.mat\st.vols{volhandle}.roi.Vroi.mat*...
                    [st.vols{volhandle}.roi.xyz; ...
                    ones(1,size(st.vols{volhandle}.roi.xyz,2))]);
                roiind = sub2ind(VT.dim, roilist(1,:), roilist(2,:), roilist(3,:));
                bch.sroi = zeros(VT.dim);
                bch.sroi(roiind) = 1;
            case 'froi'
                [froiname sts] = spm_select([1 Inf], 'image', 'Select ROI file(s)');
                if ~sts
                    warning('%s: No ROI file selected - exiting\n', mfilename);
                    return;
                end;
                froiname = cellstr(froiname);
                bch.sroi = zeros(VT.dim);
                [x  y z]=ndgrid(1:VT.dim(1),1:VT.dim(2),1:VT.dim(3));
                xyzvx = [x(:)';y(:)';z(:)'; ones(1,numel(x))];
                xyzmm = VT.mat*xyzvx;
                for k = 1:numel(froiname)
                    V = spm_vol(froiname{k});
                    xyzvx = V.mat\xyzmm;
                    bch(k) = bch(1);
                    bch(k).sroi = reshape(spm_sample_vol(V ,xyzvx(1,:),xyzvx(2,:),xyzvx(3,:),0),...
                        VT.dim(1:3));
                end;
            case 'blobs'
                nroi = numel(st.vols{volhandle}.blobs);
                for k = 1:nroi
                    if isstruct(st.vols{volhandle}.blobs{k}.vol)
                        dat=spm_read_vols(st.vols{volhandle}.blobs{k}.vol);
                    else
                        dat=st.vols{volhandle}.blobs{k}.vol;
                    end;
                    dat(isnan(dat))=0;
                    [x y z] = ind2sub(size(dat), find(dat));
                    roilist = round(VT.mat\st.vols{volhandle}.blobs{k}.mat*...
                        [x(:)'; y(:)'; z(:)'; ones(size(x(:)'))]);
                    roiind = sub2ind(VT.dim, roilist(1,:), roilist(2,:), roilist(3,:));
                    bch(k) = bch(1);
                    bch(k).sroi = zeros(VT.dim);
                    bch(k).sroi(roiind) = 1;                    
                end;
            case 'point',
                roilist = round(VT.mat\[spm_orthviews('pos');1]);
                roiind = sub2ind(VT.dim, roilist(1,:), roilist(2,:), roilist(3,:));
                bch.sroi = zeros(VT.dim);
                bch.sroi(roiind) = 1;                
            case 'sphere',
                tmp = spm_imatrix(VT.mat);
                vdim = tmp(7:9);
                roicent = round(VT.mat\[spm_orthviews('pos');1]);
                roirad  = ceil(spm_input(...
                    'Radius of sphere (mm)', '!+1', 'e', '10', [1 1])./vdim);
                [x y z] = ndgrid(-roirad(1):sign(vdim(1)):roirad(1), ...
                    -roirad(2):sign(vdim(2)):roirad(2), ...
                    -roirad(3):sign(vdim(3)):roirad(3));
                sel = (x./roirad(1)).^2 + (y./roirad(2)).^2 + (z./roirad(3)).^2 <= 1;
                x = roicent(1)+x(sel(:));
                y = roicent(2)+y(sel(:));
                z = roicent(3)+z(sel(:));
                roiind = sub2ind(VT.dim, x, y, z);
                bch.sroi = zeros(VT.dim);
                bch.sroi(roiind) = 1;                
        end;
        for k = 1:numel(bch)
            res = dti_tracepath(bch(k));
            xyzvx = cat(2, res.lines.xyzvx);
            spm_orthviews('addcolouredblobs', volhandle, xyzvx(1:3,:), ones(1,size(xyzvx,2)), VT.mat, [1 0 0], sprintf('Trace %d',k));
        end;
        spm_orthviews('redraw');
    case 'redraw'
        % do nothing
    otherwise
        fprintf('spm_orthviews(''extract'', ...): Unknown action %s', cmd);
end;
spm('pointer','arrow');
