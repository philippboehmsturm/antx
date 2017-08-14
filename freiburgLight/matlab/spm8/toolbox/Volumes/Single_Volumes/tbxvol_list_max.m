function out = tbxvol_list_max(job)

% This function is part of the volumes toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Volumes
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: tbxvol_list_max.m -1M 2012-07-02 14:42:56Z (lokal) $

rev = '$Revision: -1M $';

out.txtfile = cell(size(job.srcimgs));
for ci = 1:numel(job.srcimgs)
    [p n]          = spm_fileparts(job.srcimgs{ci});
    out.txtfile{ci} = fullfile(p, sprintf('%s_locmax.txt', n));

    V              = spm_vol(job.srcimgs{ci});
    dat            = spm_read_vols(V);
    [x, y, z]      = ndgrid(1:V.dim(1), 1:V.dim(2), 1:V.dim(3));
    xyz            = [x(:) y(:) z(:)]';
    sel            = isfinite(dat(:));
    [~, Z, XYZ A]    = spm_max(dat(sel), xyz(:,sel));
    XYZmm          = (V.mat*[XYZ;ones(1, size(XYZ,2))]);
    fid            = fopen(out.txtfile{ci}, 'w');
    for k = 1:size(XYZmm,2)
        fprintf(fid, '%d %1.2f %4.2d %4.2d %4.2d\n', A(k), Z(k), XYZmm(1, k), XYZmm(2, k), XYZmm(3, k));
    end
    fclose(fid);
end
