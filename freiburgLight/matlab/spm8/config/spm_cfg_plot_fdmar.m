function cfg = spm_cfg_plot_fdmar
spmmat        = cfg_files;
spmmat.name   = 'SPM.mat file';
spmmat.tag    = 'spmmat';
spmmat.num    = [1 1];
spmmat.filter = '^SPM.mat$';
spmmat.help   = {'Select SPM.mat file.'};
%spmmat.check  = @has_arfit;

ana      = cfg_const;
ana.name = 'SPM analysis mask';
ana.tag  = 'ana';
ana.val  = {true};
ana.help = {'Plot arfit for all voxels in an analysis.'};

ext        = cfg_files;
ext.name   = 'External analysis mask';
ext.tag    = 'ext';
ext.filter = 'image';
ext.num    = [1 1];
ext.help   = {['Plot arfit for all voxels in an analysis, that are in the ' ...
             'external mask.']};

mask        = cfg_choice;
mask.name   = 'Masking';
mask.tag    = 'mask';
mask.values = {ana ext};
mask.help   = {'Specify mask to use'};

sess         = cfg_entry;
sess.name    = 'Session #';
sess.tag     = 'sess';
sess.strtype = 'n';
sess.num     = [1 1];
sess.help    = {['arfit results can be plotted for only one session at a ' ...
                 'time.']};

pflag        = cfg_menu;
pflag.name   = 'Print results to PNG';
pflag.tag    = 'pflag';
pflag.labels = {'Yes'; 'No'};
pflag.values = {true; false};

cfg      = cfg_exbranch;
cfg.name = 'Plot arfit diagnostics';
cfg.tag  = 'plot_fdmar';
cfg.val  = {spmmat,mask,sess,pflag};
cfg.prog = @spm_run_plot_fdmar;

function str = has_arfit(spmmat)
try
    load(spmmat{1},'SPM');
    SPM.xVi.arfit;
    str = '';
catch
    str = sprintf(['File ''%s'' does not contain a SPM.mat file with arfit ' ...
                   'information.'], spmmat{1});
end