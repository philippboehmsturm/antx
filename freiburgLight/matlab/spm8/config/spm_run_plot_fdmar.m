function out = spm_run_plot_fdmar(job)
load(job.spmmat{1},'SPM');
switch char(fieldnames(job.mask))
    case 'ana'
        [m xyz] = spm_read_vols(SPM.xM.VM);
        xyz     = xyz(:,m(:));
    case 'ext'
        VM = spm_vol(job.mask.ext{1});
        spm_check_orientations([SPM.xM.VM,VM]);
        [m xyz] = spm_read_vols([SPM.xM.VM,VM]);
        m       = all(m,4);
        xyz     = xyz(:,m(:));
end
out.glmar = spm_plot_fdmar([],SPM,xyz,job.sess,job.pflag);
