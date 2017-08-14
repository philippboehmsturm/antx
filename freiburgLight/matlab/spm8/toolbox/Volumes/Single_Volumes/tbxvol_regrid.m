function out = tbxvol_regrid(job)
% Resample image
% FORMAT out = regrid(job)
% Resample image to a different resolution, keeping orientation and
% FOV (approximately).
% job.srcimgs   - name of files to be regridded (cellstr)
% job.dtype     - data type - if not supported, datatype of input will be
%                 used
% job.interp    - interpolation method. Set to NaN for integration
% job.sctype.ndim - new image dimensions
% job.sctype.vxsz - new voxel size
% job.sctype.vxsc - voxel scaling: vxsz_new = vxsz.*vxsc; 
% job.prefix    - prefix for regridded file
% out.outimgs   - name of regridded file(s) (cellstr)

for k = 1:numel(job.srcimgs)
    Vi          = spm_vol(job.srcimgs{k});
    
    Vo          = rmfield(Vi,'private');
    [p n e v]   = spm_fileparts(Vo.fname);
    Vo.fname    = fullfile(p, [job.prefix n e v]);
    if ~strcmp(spm_type(job.dtype), 'unknown')
        Vo.dt(1)    = job.dtype;
    end
    Vo.pinfo    = [Inf Inf 0]';
    switch char(fieldnames(job.sctype))
        case 'ndim'
            Vo.dim(1:3) = job.sctype.ndim;
            vxscale     = Vi.dim(1:3)./Vo.dim(1:3);
        case 'vxsz'
            prms        = spm_imatrix(Vi.mat);
            vxscale     = abs(job.sctype.vxsz./prms(7:9));
            Vo.dim(1:3) = ceil(Vi.dim(1:3)./vxscale);
        case 'vxsc'
            vxscale     = job.sctype.vxsc;
            Vo.dim(1:3) = ceil(Vi.dim(1:3)./vxscale);
    end
    Vo.mat      = Vo.mat*diag([vxscale 1]);
    
    if ~isfinite(job.interp)
        if any(vxscale < 1)
            error('Integration not supported when upsampling data.');
        else
            % get original data & coordinates
            [Xi,XYZi] = spm_read_vols(Vi);
            
            % round original coordinates to new voxel coordinates
            % get unique indices
            [unvx un2 ind] = unique(round(Vo.mat\[XYZi; ones(1, size(XYZi,2))])','rows');
            unvx = unvx';
            
            Xo = zeros(Vo.dim(1:3));
            for k = 1:numel(Xo)
                Xo(unvx(1,k),unvx(2,k),unvx(3,k)) = sum(Xi(ind == k));
            end
            
            spm_write_vol(Vo,Xo);
        end
    else
        Vo = spm_imcalc(Vi, Vo, 'i1', {0, 0, job.interp});
    end
    out.outimgs{k} = Vo.fname;
end