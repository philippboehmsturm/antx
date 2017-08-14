%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 23 $)
%-----------------------------------------------------------------------
matlabbatch{1}.menu_cfg.menu_entry.conf_files.type = 'cfg_files';
matlabbatch{1}.menu_cfg.menu_entry.conf_files.name = 'Ima files';
matlabbatch{1}.menu_cfg.menu_entry.conf_files.tag = 'imaFileList';
matlabbatch{1}.menu_cfg.menu_entry.conf_files.filter = '.*\.ima$';
matlabbatch{1}.menu_cfg.menu_entry.conf_files.ufilter = '.*';
matlabbatch{1}.menu_cfg.menu_entry.conf_files.dir = '';
matlabbatch{1}.menu_cfg.menu_entry.conf_files.num = [1 Inf];
matlabbatch{1}.menu_cfg.menu_entry.conf_files.check = [];
matlabbatch{1}.menu_cfg.menu_entry.conf_files.help = {'Select the .ima files to be converted. Note that only images of one series can be converted at once (e.g. a single 3D volume or a series of mosaic volumes). The images must be in acquisition order.'};
matlabbatch{1}.menu_cfg.menu_entry.conf_files.def = [];
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.name = 'Output filename';
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.tag = 'imgFilename';
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.strtype = 's';
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.num = [1 Inf];
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.help = {'Enter the output filename. If a series of mosaic images is converted, a running index is appended to the filename. If no extension is given or the extension is none of ''.img'' or ''.nii'', the files will be saved as ''.nii''.'};
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{3}.menu_cfg.menu_entry.conf_files.type = 'cfg_files';
matlabbatch{3}.menu_cfg.menu_entry.conf_files.name = 'Output directory';
matlabbatch{3}.menu_cfg.menu_entry.conf_files.tag = 'odir';
matlabbatch{3}.menu_cfg.menu_entry.conf_files.filter = 'dir';
matlabbatch{3}.menu_cfg.menu_entry.conf_files.ufilter = '.*';
matlabbatch{3}.menu_cfg.menu_entry.conf_files.dir = '';
matlabbatch{3}.menu_cfg.menu_entry.conf_files.num = [1 1];
matlabbatch{3}.menu_cfg.menu_entry.conf_files.check = [];
matlabbatch{3}.menu_cfg.menu_entry.conf_files.help = {'The output files will be written to this directory.'};
matlabbatch{3}.menu_cfg.menu_entry.conf_files.def = [];
matlabbatch{4}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{4}.menu_cfg.menu_entry.conf_menu.name = 'Interleaved';
matlabbatch{4}.menu_cfg.menu_entry.conf_menu.tag = 'interleaved';
matlabbatch{4}.menu_cfg.menu_entry.conf_menu.labels = {
                                                       'No'
                                                       'Yes'
                                                       }';
matlabbatch{4}.menu_cfg.menu_entry.conf_menu.values = {
                                                       false
                                                       true
                                                       }';
matlabbatch{4}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{4}.menu_cfg.menu_entry.conf_menu.help = {'Indicate whether the 3D volume was acquired interleaved or not.'};
matlabbatch{4}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.type = 'cfg_exbranch';
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.name = 'Convert .ima to NIfTI';
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.tag = 'tbx_fbi_ima';
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.val{1}(1) = cfg_dep;
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).tname = 'Val Item';
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).tgt_spec = {};
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).sname = 'Files: Ima files (cfg_files)';
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.val{2}(1) = cfg_dep;
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).tname = 'Val Item';
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).tgt_spec = {};
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).sname = 'Entry: Output filename (cfg_entry)';
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.val{3}(1) = cfg_dep;
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).tname = 'Val Item';
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).tgt_spec = {};
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).sname = 'Files: Output directory (cfg_files)';
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).src_exbranch = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.val{4}(1) = cfg_dep;
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.val{4}(1).tname = 'Val Item';
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.val{4}(1).tgt_spec = {};
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.val{4}(1).sname = 'Menu: Interleaved (cfg_menu)';
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.val{4}(1).src_exbranch = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.val{4}(1).src_output = substruct('()',{1});
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.prog = @(job)tbx_run_fbi_ima('run',job);
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.vout = @(job)tbx_run_fbi_ima('vout',job);
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.check = [];
matlabbatch{5}.menu_cfg.menu_struct.conf_exbranch.help = {'This utility tries to convert SIEMENS .ima files into NIfTI images. The code is based on visionToSPM (c) Sebastian Thees, Charite Berlin. There is no guarantee that this program works as expected. The image orientation (especially R-L flips) must be checked by the user.'};
matlabbatch{6}.menu_cfg.gencode_gen.gencode_fname = 'tbx_cfg_fbi_ima.m';
matlabbatch{6}.menu_cfg.gencode_gen.gencode_dir = {'/export/spm-devel/tbxFBIDicom/trunk/toolbox/FBIDicom/'};
matlabbatch{6}.menu_cfg.gencode_gen.gencode_var(1) = cfg_dep;
matlabbatch{6}.menu_cfg.gencode_gen.gencode_var(1).tname = 'Root node of config';
matlabbatch{6}.menu_cfg.gencode_gen.gencode_var(1).tgt_spec = {};
matlabbatch{6}.menu_cfg.gencode_gen.gencode_var(1).sname = 'Exbranch: Convert .ima to NIfTI (cfg_exbranch)';
matlabbatch{6}.menu_cfg.gencode_gen.gencode_var(1).src_exbranch = substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{6}.menu_cfg.gencode_gen.gencode_var(1).src_output = substruct('()',{1});
matlabbatch{6}.menu_cfg.gencode_gen.gencode_opts.gencode_o_def = false;
matlabbatch{6}.menu_cfg.gencode_gen.gencode_opts.gencode_o_mlb = false;
matlabbatch{6}.menu_cfg.gencode_gen.gencode_opts.gencode_o_path = false;
