function varargout=tbxvol_extract(bch)
% read an intensity profile along a given trajectory
% FORMAT extr=tbxvol_extract(bch)
% ======
% Read intensity values from a set of images within one or more given
% regions of interest. The images to be sampled can be specified by an
% SPM.mat or a list of images.
% Multiple ROIs can be defined on the same image set. ROIs can be
% specified as images (all voxels of the mask image with intensities
% other than 0 will be included), sphere around a certain point,
% pointlist, or a line through the image defined by start point, end
% point and sampling distance.
% Note, that all coordinates need to be given in mm coordinates. However,
% for mask images and spheres the sampled coordinates will be determined
% in each image's voxel space (such that all voxels within the scope of
% the mask or sphere will be sampled exactly once), whereas for point
% lists and trajectories the given mm coordinates will be translated into
% voxel coordinates, regardless of whether two of them specify the same
% voxel or the sampling will miss out voxels in between the specified
% points.
%
% If an SPM.mat is given, the extracted data will be saved in an
% 1-by-#ROI struct array with fields 
%  .posmm - mm positions sampled in ROI
%  .posvx - voxel positions sampled in ROI
%  .raw   - raw data, read from images (scaled as in the SPM.mat)
%  .adj   - SPM.xX.X*beta fitted data
% If images are given as a list of filenames, the extracted data will be
% saved as a #imgs-by-#ROI struct array as described above, but with an
% empty .adj field.
%
% If no output argument is given, extracted data will be saved into
% Matlab's standard workspace and can be treatead as any other Matlab
% variable. 
% To access the extracted data in a SPM batch job, use "Pass Output to
% Workspace" or "Save Variables" from BasicIO.
%
% This function is part of the volumes toolbox for SPM. For general help
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Volumes
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: tbxvol_extract.m 722 2011-10-18 12:21:24Z glauche $

rev = '$Revision: 722 $';
funcname = 'Extract Trajectory/ROI';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

res = struct('raw',[], 'adj',[], 'posmm',[], 'Vspace',[]);

if isfield(bch.src, 'srcspm')
    opwd = pwd;
    p = fileparts(bch.src.srcspm{1});
    cd(p);
    load(bch.src.srcspm{1});
    
    for l = 1:numel(bch.roispec)
        spm_progress_bar('init', numel(SPM.Vbeta),...
            'ROI - Fitted data',...
            'Volumes sampled');
        % assume all images of one analysis are in the same space
        res(1,l).Vspace = rmfield(SPM.Vbeta(1),{'fname','private'});
        [res(1,l).posmm res(1,l).posvx] = get_pos(bch.roispec{l}, res(1,l).Vspace);
        beta = zeros(numel(SPM.Vbeta),size(res(1,l).posvx,2));
        for k = 1:numel(SPM.Vbeta)
            beta(k,:) = spm_sample_vol(SPM.Vbeta(k), ...
                res(1,l).posvx(1,:),res(1,l).posvx(2,:),res(1,l).posvx(3,:), bch.interp);
            spm_progress_bar('set',k);
        end;
        adj = SPM.xX.X*beta;
        clear beta;
        switch bch.avg
            case 'none'
                res(1,l).adj = adj;
            case 'vox'
                res(1,l).adj.mean = zeros(size(adj,1),1);
                res(1,l).adj.std  = zeros(size(adj,1),1);
                spm_progress_bar('init', size(adj,1), 'ROI - Adjusted data',...
                    'Averaging');
                for k = 1:size(adj,1)
                    res(1,l).adj.mean(k) = mean(adj(k,:));
                    res(1,l).adj.std(k)  = std(adj(k,:));
                    spm_progress_bar('set',k);
                end;
        end;
        clear adj;
        spm_progress_bar('init', numel(SPM.xY.VY), 'ROI - Raw data',...
            'Volumes sampled');
        switch bch.avg
            case 'none'
                res(1,l).raw = zeros(numel(SPM.xY.VY),size(res(1,l).posvx, ...
                    2));
            case 'vox'
                res(1,l).raw.mean = zeros(numel(SPM.xY.VY),1);
                res(1,l).raw.std = zeros(numel(SPM.xY.VY),1);
        end;
        for k = 1:numel(SPM.xY.VY)
            raw = spm_sample_vol(SPM.xY.VY(k),...
                res(1,l).posvx(1,:),res(1,l).posvx(2,:),res(1,l).posvx(3,:), ...
                bch.interp);
            switch bch.avg
                case 'none'
                    res(1,l).raw(k,:) = raw;
                case 'vox',
                    res(1,l).raw.mean(k) = mean(raw);
                    res(1,l).raw.std(k)  = std(raw);
                    spm_progress_bar('set',k);
            end;
        end;
    end;
    cd(opwd);
else
    spm_progress_bar('init', numel(bch.src.srcimgs), ...
        'Trajectory/ROI', 'volumes completed');
    for k=1:numel(bch.src.srcimgs)
        V = spm_vol(bch.src.srcimgs{k});
        for l = 1:numel(bch.roispec)
            res(k,l).Vspace = rmfield(V,{'fname','private'});
            [res(k,l).posmm res(k,l).posvx] = get_pos(bch.roispec{l},V);
            raw = spm_sample_vol(V, res(k,l).posvx(1,:), ...
                res(k,l).posvx(2,:), res(k,l).posvx(3,:), ...
                bch.interp);
            switch bch.avg
                case 'none'
                    res(k,l).raw = raw;
                case 'vox'
                    res(k,l).raw.mean = mean(raw);
                    res(k,l).raw.std  = std(raw);
            end;
        end;
        spm_progress_bar('set',k);
    end;
end;
spm_progress_bar('clear');

if nargout > 0
    varargout{1}=res;
else
    assignin('base','ext',res);
    fprintf('extracted data saved to workspace variable ''ext''\n');
    disp(res);
end;

function [posmm, posvx] = get_pos(roispec, V)

if isfield(roispec, 'roiline')
    % get points in mm space, then convert to voxel space
    dt = roispec.roiline.roiend-roispec.roiline.roistart;
    ldt = sqrt(sum(dt.^2));
    posmm = dt*(0:roispec.roiline.roistep/ldt:1) +...
        repmat(roispec.roiline.roistart, [1 length(0:roispec.roiline.roistep:ldt)]);
    posvx = V.mat\[posmm; ones(1,size(posmm,2))];
    posvx = posvx(1:3,:);
elseif isfield(roispec, 'roilineparam')
    % get points in mm space, then convert to voxel space
    dt = roispec.roilineparam.roilinep1-roispec.roilineparam.roilinep2;
    ldt = sqrt(sum(dt.^2));
    posmm = (dt/ldt)*roispec.roilineparam.roilinecoords + ...
        repmat(roispec.roilineparam.roilinep1, ...
        size(roispec.roilineparam.roilinecoords));
    posvx = V.mat\[posmm; ones(1,size(posmm,2))];
    posvx = posvx(1:3,:);
elseif isfield(roispec, 'srcimg')
    % resample mask VM in space of current image V
    VM = spm_vol(roispec.srcimg{1});
    x = []; y = []; z = [];
    [x1 y1] = ndgrid(1:V.dim(1),1:V.dim(2));
    for p = 1:V.dim(3)
        B = spm_matrix([0 0 -p 0 0 0 1 1 1]);
        M = VM.mat\(V.mat/B);
        msk = find(spm_slice_vol(VM,M,V.dim(1:2),0));
        if ~isempty(msk)
            z1 = p*ones(size(msk(:)));
            x = [x; x1(msk(:))];
            y = [y; y1(msk(:))];
            z = [z; z1];
        end;
    end;
    posvx = [x'; y'; z'];
    xyzmm = V.mat*[posvx;ones(1,size(posvx,2))];
    posmm = xyzmm(1:3,:);
elseif isfield(roispec, 'roisphere')
    cent = round(V.mat\[roispec.roisphere.roicent; 1]);
    tmp = spm_imatrix(V.mat);
    vdim = tmp(7:9);
    vxrad = ceil((roispec.roisphere.roirad*ones(1,3))./ ...
        vdim)';
    [x y z] = ndgrid(-vxrad(1):sign(vdim(1)):vxrad(1), ...
        -vxrad(2):sign(vdim(2)):vxrad(2), ...
        -vxrad(3):sign(vdim(3)):vxrad(3));
    sel = (x./vxrad(1)).^2 + (y./vxrad(2)).^2 + (z./vxrad(3)).^2 <= 1;
    x = cent(1)+x(sel(:));
    y = cent(2)+y(sel(:));
    z = cent(3)+z(sel(:));
    posvx = [x y z]';
    xyzmm = V.mat*[posvx;ones(1,size(posvx,2))];
    posmm = xyzmm(1:3,:);
elseif isfield(roispec, 'roilist')
    posmm = roispec.roilist;
    posvx = V.mat\[posmm; ones(1,size(posmm,2))];
    posvx = posvx(1:3,:);
end;
