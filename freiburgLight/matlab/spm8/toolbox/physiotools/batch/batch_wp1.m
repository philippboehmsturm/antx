%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 1 $)
%-----------------------------------------------------------------------
matlabbatch{1}.menu_cfg.menu_entry.conf_files.type = 'cfg_files';
matlabbatch{1}.menu_cfg.menu_entry.conf_files.name = 'Data file';
matlabbatch{1}.menu_cfg.menu_entry.conf_files.tag = 'datafile';
matlabbatch{1}.menu_cfg.menu_entry.conf_files.filter = 'any';
matlabbatch{1}.menu_cfg.menu_entry.conf_files.ufilter = '.*';
matlabbatch{1}.menu_cfg.menu_entry.conf_files.dir = [];
matlabbatch{1}.menu_cfg.menu_entry.conf_files.num = [1 1];
matlabbatch{1}.menu_cfg.menu_entry.conf_files.check = [];
matlabbatch{1}.menu_cfg.menu_entry.conf_files.help = {};
matlabbatch{1}.menu_cfg.menu_entry.conf_files.def = [];
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.name = 'Bandwidth';
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.tag = 'bandwidth';
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.strtype = 'r';
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.num = [1 1];
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.help = {};
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{3}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{3}.menu_cfg.menu_entry.conf_menu.name = 'Flip sign of signal';
matlabbatch{3}.menu_cfg.menu_entry.conf_menu.tag = 'flip';
matlabbatch{3}.menu_cfg.menu_entry.conf_menu.labels = {
                                                       'No'
                                                       'Yes'
                                                       }';
matlabbatch{3}.menu_cfg.menu_entry.conf_menu.values = {
                                                       false
                                                       true
                                                       }';
matlabbatch{3}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{3}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{3}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.name = 'Respiratory';
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.tag = 'resp';
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Files: Data file (cfg_files)';
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.val{2}(1).sname = 'Entry: Bandwidth (cfg_entry)';
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.val{3}(1) = cfg_dep;
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.val{3}(1).tname = 'Val Item';
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.val{3}(1).tgt_spec = {};
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.val{3}(1).sname = 'Menu: Flip sign of signal (cfg_menu)';
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_exbranch = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{5}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{5}.menu_cfg.menu_entry.conf_menu.name = 'Correction type';
matlabbatch{5}.menu_cfg.menu_entry.conf_menu.tag = 'corr';
matlabbatch{5}.menu_cfg.menu_entry.conf_menu.labels = {
                                                       'Global (histogram)'
                                                       'Global'
                                                       'Cyclic'
                                                       }';
matlabbatch{5}.menu_cfg.menu_entry.conf_menu.values = {
                                                       -1
                                                       0
                                                       1
                                                       }';
matlabbatch{5}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{5}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{5}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.name = 'Respiratory';
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.tag = 'resp';
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Branch: Respiratory (cfg_branch)';
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.val{2}(1).sname = 'Menu: Correction type (cfg_menu)';
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.help = {};
