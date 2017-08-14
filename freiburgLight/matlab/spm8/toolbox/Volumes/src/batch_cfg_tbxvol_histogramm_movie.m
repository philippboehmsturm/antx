%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 645 $)
%-----------------------------------------------------------------------
matlabbatch{1}.menu_cfg.menu_entry.conf_files.type = 'cfg_files';
matlabbatch{1}.menu_cfg.menu_entry.conf_files.name = 'Images';
matlabbatch{1}.menu_cfg.menu_entry.conf_files.tag = 'srcimgs';
matlabbatch{1}.menu_cfg.menu_entry.conf_files.filter = 'image';
matlabbatch{1}.menu_cfg.menu_entry.conf_files.ufilter = '.*';
matlabbatch{1}.menu_cfg.menu_entry.conf_files.dir = '';
matlabbatch{1}.menu_cfg.menu_entry.conf_files.num = [1 Inf];
matlabbatch{1}.menu_cfg.menu_entry.conf_files.check = [];
matlabbatch{1}.menu_cfg.menu_entry.conf_files.help = {'These images will be read and their histogramms displayed.'};
matlabbatch{1}.menu_cfg.menu_entry.conf_files.def = [];
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.name = 'Intensity Range';
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.tag = 'int';
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.strtype = 'r';
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.num = [1 2];
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.help = {'The histogramm will only be created from voxels with intensities in this range.'};
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{3}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{3}.menu_cfg.menu_entry.conf_entry.name = 'Image #s';
matlabbatch{3}.menu_cfg.menu_entry.conf_entry.tag = 'hstart';
matlabbatch{3}.menu_cfg.menu_entry.conf_entry.strtype = 'n';
matlabbatch{3}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{3}.menu_cfg.menu_entry.conf_entry.num = [1 Inf];
matlabbatch{3}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{3}.menu_cfg.menu_entry.conf_entry.help = {'Image numbers (in the input image list) for which histogramms should be created.'};
matlabbatch{3}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{4}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{4}.menu_cfg.menu_entry.conf_entry.name = '#Averages';
matlabbatch{4}.menu_cfg.menu_entry.conf_entry.tag = 'hnum';
matlabbatch{4}.menu_cfg.menu_entry.conf_entry.strtype = 'n';
matlabbatch{4}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{4}.menu_cfg.menu_entry.conf_entry.num = [1 1];
matlabbatch{4}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{4}.menu_cfg.menu_entry.conf_entry.help = {'The number of consecutive image to average in one histogramm.'};
matlabbatch{4}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{5}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{5}.menu_cfg.menu_entry.conf_entry.name = 'Histogramm timebins';
matlabbatch{5}.menu_cfg.menu_entry.conf_entry.tag = 'nbins';
matlabbatch{5}.menu_cfg.menu_entry.conf_entry.strtype = 'n';
matlabbatch{5}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{5}.menu_cfg.menu_entry.conf_entry.num = [1 1];
matlabbatch{5}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{5}.menu_cfg.menu_entry.conf_entry.help = {};
matlabbatch{5}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{6}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{6}.menu_cfg.menu_entry.conf_menu.name = 'Reference Histogramms';
matlabbatch{6}.menu_cfg.menu_entry.conf_menu.tag = 'holdhist';
matlabbatch{6}.menu_cfg.menu_entry.conf_menu.labels = {
                                                       'First'
                                                       'Last'
                                                       'Both'
                                                       'None'
                                                       }';
matlabbatch{6}.menu_cfg.menu_entry.conf_menu.values = {
                                                       'first'
                                                       'last'
                                                       'both'
                                                       'none'
                                                       }';
matlabbatch{6}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{6}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{6}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.type = 'cfg_exbranch';
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.name = 'Histogramm movie';
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.tag = 'cfg_tbxvol_histogramm_movie';
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{1}(1) = cfg_dep;
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).tname = 'Val Item';
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).tgt_spec = {};
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).sname = 'Files: Images (cfg_files)';
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{2}(1) = cfg_dep;
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).tname = 'Val Item';
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).tgt_spec = {};
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).sname = 'Entry: Intensity Range (cfg_entry)';
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{3}(1) = cfg_dep;
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).tname = 'Val Item';
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).tgt_spec = {};
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).sname = 'Entry: Image #s (cfg_entry)';
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).src_exbranch = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{4}(1) = cfg_dep;
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{4}(1).tname = 'Val Item';
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{4}(1).tgt_spec = {};
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{4}(1).sname = 'Entry: #Averages (cfg_entry)';
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{4}(1).src_exbranch = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{4}(1).src_output = substruct('()',{1});
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{5}(1) = cfg_dep;
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{5}(1).tname = 'Val Item';
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{5}(1).tgt_spec = {};
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{5}(1).sname = 'Entry: Histogramm timebins (cfg_entry)';
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{5}(1).src_exbranch = substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{5}(1).src_output = substruct('()',{1});
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{6}(1) = cfg_dep;
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{6}(1).tname = 'Val Item';
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{6}(1).tgt_spec = {};
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{6}(1).sname = 'Menu: Reference Histogramms (cfg_menu)';
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{6}(1).src_exbranch = substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.val{6}(1).src_output = substruct('()',{1});
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.prog = @(job)tbxvol_histogramm_movie('run',job);
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.vout = @(job)tbxvol_histogramm_movie('vout',job);
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.check = @(job)tbxvol_histogramm_movie('check',job);
matlabbatch{7}.menu_cfg.menu_struct.conf_exbranch.help = {};
matlabbatch{8}.menu_cfg.gencode_gen.gencode_fname = 'cfg_tbxvol_histogramm.m';
matlabbatch{8}.menu_cfg.gencode_gen.gencode_dir = {'/tmp/'};
matlabbatch{8}.menu_cfg.gencode_gen.gencode_var(1) = cfg_dep;
matlabbatch{8}.menu_cfg.gencode_gen.gencode_var(1).tname = 'Root node of config';
matlabbatch{8}.menu_cfg.gencode_gen.gencode_var(1).tgt_spec = {};
matlabbatch{8}.menu_cfg.gencode_gen.gencode_var(1).sname = 'Exbranch: Histogramm movie (cfg_exbranch)';
matlabbatch{8}.menu_cfg.gencode_gen.gencode_var(1).src_exbranch = substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{8}.menu_cfg.gencode_gen.gencode_var(1).src_output = substruct('()',{1});
matlabbatch{8}.menu_cfg.gencode_gen.gencode_opts.gencode_o_def = false;
matlabbatch{8}.menu_cfg.gencode_gen.gencode_opts.gencode_o_mlb = false;
matlabbatch{8}.menu_cfg.gencode_gen.gencode_opts.gencode_o_path = false;
