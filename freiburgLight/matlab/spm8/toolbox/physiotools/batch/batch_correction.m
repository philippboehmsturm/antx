%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 1 $)
%-----------------------------------------------------------------------
matlabbatch{1}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{1}.menu_cfg.menu_entry.conf_menu.name = 'Correction type';
matlabbatch{1}.menu_cfg.menu_entry.conf_menu.tag = 'corr';
matlabbatch{1}.menu_cfg.menu_entry.conf_menu.labels = {
                                                       'Global (Resp histogram)'
                                                       'Both global'
                                                       'Global (Resp cyclic)'
                                                       'Both cyclic'
                                                       }';
matlabbatch{1}.menu_cfg.menu_entry.conf_menu.values = {
                                                       -1
                                                       0
                                                       1
                                                       2
                                                       }';
matlabbatch{1}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{1}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{1}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{2}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{2}.menu_cfg.menu_struct.conf_branch.name = 'Respiratory';
matlabbatch{2}.menu_cfg.menu_struct.conf_branch.tag = 'resp';
matlabbatch{2}.menu_cfg.menu_struct.conf_branch.val{1} = '<UNDEFINED>';
matlabbatch{2}.menu_cfg.menu_struct.conf_branch.val{2} = '<UNDEFINED>';
matlabbatch{2}.menu_cfg.menu_struct.conf_branch.val{3}(1) = cfg_dep;
matlabbatch{2}.menu_cfg.menu_struct.conf_branch.val{3}(1).tname = 'Val Item';
matlabbatch{2}.menu_cfg.menu_struct.conf_branch.val{3}(1).tgt_spec = {};
matlabbatch{2}.menu_cfg.menu_struct.conf_branch.val{3}(1).sname = 'Menu: Correction type (cfg_menu)';
matlabbatch{2}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{2}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{2}.menu_cfg.menu_struct.conf_branch.help = {};
