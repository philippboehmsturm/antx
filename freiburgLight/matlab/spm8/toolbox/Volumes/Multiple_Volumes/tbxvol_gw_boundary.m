function out = tbxvol_gw_boundary(cmd, job)
% Compute boundary between grey and white matter segment images
% FORMAT OUT = TBXVOL_GW_BOUNDARY(CMD,JOB)
% ======
% This function computes the gradient magnitude of both grey and white
% matter images. The minimum value of both maps is taken. Under the
% assumption that at the g/w boundary there is a high gradient in both
% maps, boundary voxels can be obtained by thresholding the minimum map.
% A mask based on the sum of the grey and white matter images will be used
% to reduce the number of voxels and to exclude regions that are not g/w
% matter.
% Input arguments:
%  cmd - string (one of 'run' - run the job, 'vout' - return dependencies)
%  job - struct with fields
%   .segments - file names of segment images (cellstr)
%   .maskexpr - imcalc expression to compute mask (eg '.4*i1+.6*i2 > .3')
%   .gradthr  - threshold for min(grad) map (eg .15)
% Output argument:
%  out - struct with fields
%   .mask     - file name of mask image
%   .boundary - file name of boundary image
%
% This function is part of the volumes toolbox for SPM. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Volumes
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: tbxvol_gw_boundary.m 674 2009-08-06 11:23:06Z glauche $

rev = '$Revision: 674 $';

switch lower(cmd)
    case 'run'
        Vc = spm_vol(char(job.segments));
        % create mask
        [p n e v]     = spm_fileparts(job.segments{1});
        out.mask      = {fullfile(p,['mask_' n e])};
        Vm            = rmfield(Vc(1),'private');
        Vm.dt(1)      = spm_type('uint8');
        Vm.pinfo(1:2) = inf;
        Vm.fname      = out.mask{1};
        Vm            = spm_imcalc(Vc, Vm, job.maskexpr);
        % read mask, get coordinates
        [Xm XYZ] = spm_read_vols(Vm);
        XYZ = XYZ(:,Xm(:)>0);
        XYZ = round(Vc(1).mat\[XYZ;ones(1,size(XYZ,2))]);
        % read gradients
        [c1,dxc1,dyc1,dzc1] = spm_sample_vol(Vc(1),XYZ(1,:),XYZ(2,:),XYZ(3,:),-3);
        [c2,dxc2,dyc2,dzc2] = spm_sample_vol(Vc(2),XYZ(1,:),XYZ(2,:),XYZ(3,:),-3);
        dc1  = sqrt(dxc1.^2+dyc1.^2+dzc1.^2);
        dc2  = sqrt(dxc2.^2+dyc2.^2+dzc2.^2);
        mdc  = min([dc1;dc2]);
        mdcb = mdc > job.gradthr;
        ixyz = sub2ind(Vc(1).dim(1:3),XYZ(1,:),XYZ(2,:),XYZ(3,:));
        % create binary boundary map
        out.boundary  = {fullfile(p,['bound_' n e])};
        Vb            = rmfield(Vc(1),'private');
        Vb.dt(1)      = spm_type('uint8');
        Vb.pinfo(1:2) = inf;
        Vb.fname      = out.boundary{1};
        Xb            = zeros(Vb.dim(1:3));
        Xb(ixyz)      = mdcb;
        spm_write_vol(Vb, Xb);
        % create min gradient map
        out.mingrad   = {fullfile(p,['mingrad_' n e])};
        Vg            = rmfield(Vc(1),'private');
        Vg.dt(1)      = spm_type('float32');
        Vg.pinfo(1:2) = inf;
        Vg.fname      = out.mingrad{1};
        Xg            = zeros(Vg.dim(1:3));
        Xg(ixyz)      = mdc;
        spm_write_vol(Vg, Xg);
    case 'vout'
        out(1)            = cfg_dep;
        out(1).sname      = 'Mask image';
        out(1).src_output = substruct('.','mask');
        out(1).tgt_spec   = cfg_findspec({{'filter','image'}});
        out(2)            = cfg_dep;
        out(2).sname      = 'Boundary image';
        out(2).src_output = substruct('.','boundary');
        out(2).tgt_spec   = cfg_findspec({{'filter','image'}});
        out(3)            = cfg_dep;
        out(3).sname      = 'Min gradient image';
        out(3).src_output = substruct('.','mingrad');
        out(3).tgt_spec   = cfg_findspec({{'filter','image'}});       
end