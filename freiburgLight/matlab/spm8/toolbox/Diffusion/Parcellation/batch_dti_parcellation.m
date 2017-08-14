%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 644 $)
%-----------------------------------------------------------------------
matlabbatch{1}.menu_cfg{1}.menu_entry{1}.conf_files.type = 'cfg_files';
matlabbatch{1}.menu_cfg{1}.menu_entry{1}.conf_files.name = 'Fibre tract images';
matlabbatch{1}.menu_cfg{1}.menu_entry{1}.conf_files.tag = 'tracts';
matlabbatch{1}.menu_cfg{1}.menu_entry{1}.conf_files.filter = 'image';
matlabbatch{1}.menu_cfg{1}.menu_entry{1}.conf_files.ufilter = '.*';
matlabbatch{1}.menu_cfg{1}.menu_entry{1}.conf_files.dir = '';
matlabbatch{1}.menu_cfg{1}.menu_entry{1}.conf_files.num = [1 Inf];
matlabbatch{1}.menu_cfg{1}.menu_entry{1}.conf_files.check = [];
matlabbatch{1}.menu_cfg{1}.menu_entry{1}.conf_files.help = {'Select the tracts as NIfTI images.'};
matlabbatch{1}.menu_cfg{1}.menu_entry{1}.conf_files.def = [];
matlabbatch{2}.menu_cfg{1}.menu_entry{1}.conf_files.type = 'cfg_files';
matlabbatch{2}.menu_cfg{1}.menu_entry{1}.conf_files.name = 'Mask image';
matlabbatch{2}.menu_cfg{1}.menu_entry{1}.conf_files.tag = 'mask';
matlabbatch{2}.menu_cfg{1}.menu_entry{1}.conf_files.filter = 'image';
matlabbatch{2}.menu_cfg{1}.menu_entry{1}.conf_files.ufilter = '.*';
matlabbatch{2}.menu_cfg{1}.menu_entry{1}.conf_files.dir = '';
matlabbatch{2}.menu_cfg{1}.menu_entry{1}.conf_files.num = [1 1];
matlabbatch{2}.menu_cfg{1}.menu_entry{1}.conf_files.check = [];
matlabbatch{2}.menu_cfg{1}.menu_entry{1}.conf_files.help = {'This image describes the regions of the tracts that are considered in clustering.'};
matlabbatch{2}.menu_cfg{1}.menu_entry{1}.conf_files.def = [];
matlabbatch{3}.menu_cfg{1}.menu_entry{1}.conf_entry.type = 'cfg_entry';
matlabbatch{3}.menu_cfg{1}.menu_entry{1}.conf_entry.name = 'Number of clusters';
matlabbatch{3}.menu_cfg{1}.menu_entry{1}.conf_entry.tag = 'nc';
matlabbatch{3}.menu_cfg{1}.menu_entry{1}.conf_entry.strtype = 'n';
matlabbatch{3}.menu_cfg{1}.menu_entry{1}.conf_entry.extras = [];
matlabbatch{3}.menu_cfg{1}.menu_entry{1}.conf_entry.num = [1 1];
matlabbatch{3}.menu_cfg{1}.menu_entry{1}.conf_entry.check = [];
matlabbatch{3}.menu_cfg{1}.menu_entry{1}.conf_entry.help = {'Enter the number of clusters to be found.'};
matlabbatch{3}.menu_cfg{1}.menu_entry{1}.conf_entry.def = [];
matlabbatch{4}.menu_cfg{1}.menu_entry{1}.conf_menu.type = 'cfg_menu';
matlabbatch{4}.menu_cfg{1}.menu_entry{1}.conf_menu.name = 'Initialisation Method';
matlabbatch{4}.menu_cfg{1}.menu_entry{1}.conf_menu.tag = 'init';
matlabbatch{4}.menu_cfg{1}.menu_entry{1}.conf_menu.labels = {
                                                             'Uniform'
                                                             'Points'
                                                             'Fixed Points (1...k)'
                                                             'Random'
                                                             }';
matlabbatch{4}.menu_cfg{1}.menu_entry{1}.conf_menu.values = {
                                                             'uniform'
                                                             'points'
                                                             'fixed-points'
                                                             'random'
                                                             }';
matlabbatch{4}.menu_cfg{1}.menu_entry{1}.conf_menu.check = [];
matlabbatch{4}.menu_cfg{1}.menu_entry{1}.conf_menu.help = {'Select initialisation method.'};
matlabbatch{4}.menu_cfg{1}.menu_entry{1}.conf_menu.def = [];
matlabbatch{5}.menu_cfg{1}.menu_entry{1}.conf_menu.type = 'cfg_menu';
matlabbatch{5}.menu_cfg{1}.menu_entry{1}.conf_menu.name = 'Return covariances';
matlabbatch{5}.menu_cfg{1}.menu_entry{1}.conf_menu.tag = 'retcov';
matlabbatch{5}.menu_cfg{1}.menu_entry{1}.conf_menu.labels = {
                                                             'Yes'
                                                             'No'
                                                             }';
matlabbatch{5}.menu_cfg{1}.menu_entry{1}.conf_menu.values = {
                                                             true
                                                             false
                                                             }';
matlabbatch{5}.menu_cfg{1}.menu_entry{1}.conf_menu.check = [];
matlabbatch{5}.menu_cfg{1}.menu_entry{1}.conf_menu.help = {};
matlabbatch{5}.menu_cfg{1}.menu_entry{1}.conf_menu.def = [];
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_branch.type = 'cfg_branch';
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_branch.name = 'Clustering options';
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_branch.tag = 'clustering';
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_branch.val{1}(1).sname = 'Entry: Number of clusters (cfg_entry)';
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_branch.val{2}(1).sname = 'Menu: Initialisation Method (cfg_menu)';
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_branch.val{3}(1) = cfg_dep;
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_branch.val{3}(1).tname = 'Val Item';
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_branch.val{3}(1).tgt_spec = {};
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_branch.val{3}(1).sname = 'Menu: Return covariances (cfg_menu)';
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_branch.val{3}(1).src_exbranch = substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_branch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_branch.check = [];
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_branch.help = {};
matlabbatch{7}.menu_cfg{1}.menu_entry{1}.conf_files.type = 'cfg_files';
matlabbatch{7}.menu_cfg{1}.menu_entry{1}.conf_files.name = 'Maskstruct File';
matlabbatch{7}.menu_cfg{1}.menu_entry{1}.conf_files.tag = 'maskstruct';
matlabbatch{7}.menu_cfg{1}.menu_entry{1}.conf_files.filter = 'mat';
matlabbatch{7}.menu_cfg{1}.menu_entry{1}.conf_files.ufilter = '.*';
matlabbatch{7}.menu_cfg{1}.menu_entry{1}.conf_files.dir = '';
matlabbatch{7}.menu_cfg{1}.menu_entry{1}.conf_files.num = [1 1];
matlabbatch{7}.menu_cfg{1}.menu_entry{1}.conf_files.check = [];
matlabbatch{7}.menu_cfg{1}.menu_entry{1}.conf_files.help = {'Select the maskstruct file that contains the seed regions.'};
matlabbatch{7}.menu_cfg{1}.menu_entry{1}.conf_files.def = [];
matlabbatch{8}.menu_cfg{1}.menu_entry{1}.conf_entry.type = 'cfg_entry';
matlabbatch{8}.menu_cfg{1}.menu_entry{1}.conf_entry.name = 'Mask numbers';
matlabbatch{8}.menu_cfg{1}.menu_entry{1}.conf_entry.tag = 'ind';
matlabbatch{8}.menu_cfg{1}.menu_entry{1}.conf_entry.strtype = 'n';
matlabbatch{8}.menu_cfg{1}.menu_entry{1}.conf_entry.extras = [];
matlabbatch{8}.menu_cfg{1}.menu_entry{1}.conf_entry.num = [1 Inf];
matlabbatch{8}.menu_cfg{1}.menu_entry{1}.conf_entry.check = [];
matlabbatch{8}.menu_cfg{1}.menu_entry{1}.conf_entry.help = {'Enter the index numbers of the masks or "Inf" to select all masks in the file.'};
matlabbatch{8}.menu_cfg{1}.menu_entry{1}.conf_entry.def = [];
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.type = 'cfg_branch';
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.name = 'Mask source';
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.tag = 'rois';
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{1}(1).sname = 'Files: Maskstruct File (cfg_files)';
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{2}(1).sname = 'Entry: Mask numbers (cfg_entry)';
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{8}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.check = [];
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.help = {};
matlabbatch{10}.menu_cfg{1}.menu_entry{1}.conf_const.type = 'cfg_const';
matlabbatch{10}.menu_cfg{1}.menu_entry{1}.conf_const.name = 'Don''t reconstruct';
matlabbatch{10}.menu_cfg{1}.menu_entry{1}.conf_const.tag = 'noreco';
matlabbatch{10}.menu_cfg{1}.menu_entry{1}.conf_const.val = {false};
matlabbatch{10}.menu_cfg{1}.menu_entry{1}.conf_const.check = [];
matlabbatch{10}.menu_cfg{1}.menu_entry{1}.conf_const.help = {};
matlabbatch{10}.menu_cfg{1}.menu_entry{1}.conf_const.def = [];
matlabbatch{11}.menu_cfg{1}.menu_struct{1}.conf_choice.type = 'cfg_choice';
matlabbatch{11}.menu_cfg{1}.menu_struct{1}.conf_choice.name = 'Reconstruct parcellation images';
matlabbatch{11}.menu_cfg{1}.menu_struct{1}.conf_choice.tag = 'reco';
matlabbatch{11}.menu_cfg{1}.menu_struct{1}.conf_choice.values{1}(1) = cfg_dep;
matlabbatch{11}.menu_cfg{1}.menu_struct{1}.conf_choice.values{1}(1).tname = 'Values Item';
matlabbatch{11}.menu_cfg{1}.menu_struct{1}.conf_choice.values{1}(1).tgt_spec = {};
matlabbatch{11}.menu_cfg{1}.menu_struct{1}.conf_choice.values{1}(1).sname = 'Branch: Mask source (cfg_branch)';
matlabbatch{11}.menu_cfg{1}.menu_struct{1}.conf_choice.values{1}(1).src_exbranch = substruct('.','val', '{}',{9}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{11}.menu_cfg{1}.menu_struct{1}.conf_choice.values{1}(1).src_output = substruct('()',{1});
matlabbatch{11}.menu_cfg{1}.menu_struct{1}.conf_choice.values{2}(1) = cfg_dep;
matlabbatch{11}.menu_cfg{1}.menu_struct{1}.conf_choice.values{2}(1).tname = 'Values Item';
matlabbatch{11}.menu_cfg{1}.menu_struct{1}.conf_choice.values{2}(1).tgt_spec = {};
matlabbatch{11}.menu_cfg{1}.menu_struct{1}.conf_choice.values{2}(1).sname = 'Const: Don''t reconstruct (cfg_const)';
matlabbatch{11}.menu_cfg{1}.menu_struct{1}.conf_choice.values{2}(1).src_exbranch = substruct('.','val', '{}',{10}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{11}.menu_cfg{1}.menu_struct{1}.conf_choice.values{2}(1).src_output = substruct('()',{1});
matlabbatch{11}.menu_cfg{1}.menu_struct{1}.conf_choice.check = [];
matlabbatch{11}.menu_cfg{1}.menu_struct{1}.conf_choice.help = {};
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.type = 'cfg_exbranch';
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.name = 'GM Parcellation';
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.tag = 'dti_parcellation';
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{1}(1) = cfg_dep;
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{1}(1).tname = 'Val Item';
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{1}(1).tgt_spec = {};
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{1}(1).sname = 'Files: Fibre tract images (cfg_files)';
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{1}(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{2}(1) = cfg_dep;
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{2}(1).tname = 'Val Item';
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{2}(1).tgt_spec = {};
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{2}(1).sname = 'Files: Mask image (cfg_files)';
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{2}(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{3}(1) = cfg_dep;
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{3}(1).tname = 'Val Item';
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{3}(1).tgt_spec = {};
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{3}(1).sname = 'Branch: Clustering options (cfg_branch)';
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{3}(1).src_exbranch = substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{4}(1) = cfg_dep;
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{4}(1).tname = 'Val Item';
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{4}(1).tgt_spec = {};
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{4}(1).sname = 'Choice: Reconstruct parcellation images (cfg_choice)';
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{4}(1).src_exbranch = substruct('.','val', '{}',{11}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{4}(1).src_output = substruct('()',{1});
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.prog = @(job)dti_run_parcellation('run',job);
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.vout = @(job)dti_run_parcellation('vout',job);
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.check = [];
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.help = {};
matlabbatch{13}.menu_cfg{1}.gencode_gen.gencode_fname = 'dti_cfg_parcellation.m';
matlabbatch{13}.menu_cfg{1}.gencode_gen.gencode_dir = {'/afs/fbi.ukl.uni-freiburg.de/projects/spm-devel/spmtools/tbxDiffusion/trunk/toolbox/Diffusion/Parcellation/'};
matlabbatch{13}.menu_cfg{1}.gencode_gen.gencode_var(1) = cfg_dep;
matlabbatch{13}.menu_cfg{1}.gencode_gen.gencode_var(1).tname = 'Root node of config';
matlabbatch{13}.menu_cfg{1}.gencode_gen.gencode_var(1).tgt_spec = {};
matlabbatch{13}.menu_cfg{1}.gencode_gen.gencode_var(1).sname = 'Exbranch: GM Parcellation (cfg_exbranch)';
matlabbatch{13}.menu_cfg{1}.gencode_gen.gencode_var(1).src_exbranch = substruct('.','val', '{}',{12}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{13}.menu_cfg{1}.gencode_gen.gencode_var(1).src_output = substruct('()',{1});
matlabbatch{13}.menu_cfg{1}.gencode_gen.gencode_opts.gencode_o_def = false;
matlabbatch{13}.menu_cfg{1}.gencode_gen.gencode_opts.gencode_o_mlb = false;
matlabbatch{13}.menu_cfg{1}.gencode_gen.gencode_opts.gencode_o_path = false;
