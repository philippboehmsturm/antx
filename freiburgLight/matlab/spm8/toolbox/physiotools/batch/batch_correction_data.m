%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 7 $)
%-----------------------------------------------------------------------
matlabbatch{1}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{1}.menu_cfg.menu_entry.conf_menu.name = 'Correction type';
matlabbatch{1}.menu_cfg.menu_entry.conf_menu.tag = 'corr';
matlabbatch{1}.menu_cfg.menu_entry.conf_menu.labels = {
                                                       'Global'
                                                       'Cyclic'
                                                       }';
matlabbatch{1}.menu_cfg.menu_entry.conf_menu.values = {
                                                       0
                                                       1
                                                       }';
matlabbatch{1}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{1}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{1}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{2}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{2}.menu_cfg.menu_struct.conf_branch.name = 'Cardiac';
matlabbatch{2}.menu_cfg.menu_struct.conf_branch.tag = 'cardiac';
matlabbatch{2}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{2}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{2}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{2}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Menu: Correction type (cfg_menu)';
matlabbatch{2}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{2}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{2}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{3}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{3}.menu_cfg.menu_entry.conf_menu.name = 'Correction type';
matlabbatch{3}.menu_cfg.menu_entry.conf_menu.tag = 'corr';
matlabbatch{3}.menu_cfg.menu_entry.conf_menu.labels = {
                                                       'Global (histogram)'
                                                       'Global'
                                                       'Cyclic'
                                                       }';
matlabbatch{3}.menu_cfg.menu_entry.conf_menu.values = {
                                                       -1
                                                       0
                                                       1
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
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Menu: Correction type (cfg_menu)';
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{4}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{5}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{5}.menu_cfg.menu_entry.conf_menu.name = 'Correction type';
matlabbatch{5}.menu_cfg.menu_entry.conf_menu.tag = 'corr';
matlabbatch{5}.menu_cfg.menu_entry.conf_menu.labels = {
                                                       'Global'
                                                       'Cyclic'
                                                       }';
matlabbatch{5}.menu_cfg.menu_entry.conf_menu.values = {
                                                       0
                                                       1
                                                       }';
matlabbatch{5}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{5}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{5}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.name = 'Pulse';
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.tag = 'pulse';
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Menu: Correction type (cfg_menu)';
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{6}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{7}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{7}.menu_cfg.menu_entry.conf_menu.name = 'Correction type';
matlabbatch{7}.menu_cfg.menu_entry.conf_menu.tag = 'corr';
matlabbatch{7}.menu_cfg.menu_entry.conf_menu.labels = {
                                                       'Global (Resp histogram)'
                                                       'Both global'
                                                       'Global (Resp cyclic)'
                                                       'Both cyclic'
                                                       }';
matlabbatch{7}.menu_cfg.menu_entry.conf_menu.values = {
                                                       -1
                                                       0
                                                       1
                                                       2
                                                       }';
matlabbatch{7}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{7}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{7}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{8}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{8}.menu_cfg.menu_struct.conf_branch.name = 'Respiratory+Cardiac';
matlabbatch{8}.menu_cfg.menu_struct.conf_branch.tag = 'respcard';
matlabbatch{8}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{8}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{8}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{8}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Menu: Correction type (cfg_menu)';
matlabbatch{8}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{8}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{8}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{8}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{9}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{9}.menu_cfg.menu_entry.conf_menu.name = 'Correction type';
matlabbatch{9}.menu_cfg.menu_entry.conf_menu.tag = 'corr';
matlabbatch{9}.menu_cfg.menu_entry.conf_menu.labels = {
                                                       'Global (Resp histogram)'
                                                       'Both global'
                                                       'Global (Resp cyclic)'
                                                       'Both cyclic'
                                                       }';
matlabbatch{9}.menu_cfg.menu_entry.conf_menu.values = {
                                                       -1
                                                       0
                                                       1
                                                       2
                                                       }';
matlabbatch{9}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{9}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{9}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.name = 'Cardiac+Respiratory';
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.tag = 'cardresp';
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Menu: Correction type (cfg_menu)';
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{9}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{11}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{11}.menu_cfg.menu_entry.conf_menu.name = 'Correction type';
matlabbatch{11}.menu_cfg.menu_entry.conf_menu.tag = 'corr';
matlabbatch{11}.menu_cfg.menu_entry.conf_menu.labels = {
                                                        'Global (Resp histogram)'
                                                        'Both global'
                                                        'Global (Resp cyclic)'
                                                        'Both cyclic'
                                                        }';
matlabbatch{11}.menu_cfg.menu_entry.conf_menu.values = {
                                                        -1
                                                        0
                                                        1
                                                        2
                                                        }';
matlabbatch{11}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{11}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{11}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.name = 'Respiratory+Pulse';
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.tag = 'resp';
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Menu: Correction type (cfg_menu)';
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{11}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{13}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{13}.menu_cfg.menu_entry.conf_menu.name = 'Correction type';
matlabbatch{13}.menu_cfg.menu_entry.conf_menu.tag = 'corr';
matlabbatch{13}.menu_cfg.menu_entry.conf_menu.labels = {
                                                        'Global (Resp histogram)'
                                                        'Both global'
                                                        'Global (Resp cyclic)'
                                                        'Both cyclic'
                                                        }';
matlabbatch{13}.menu_cfg.menu_entry.conf_menu.values = {
                                                        -1
                                                        0
                                                        1
                                                        2
                                                        }';
matlabbatch{13}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{13}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{13}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{14}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{14}.menu_cfg.menu_struct.conf_branch.name = 'Pulse+Respiratory';
matlabbatch{14}.menu_cfg.menu_struct.conf_branch.tag = 'resp';
matlabbatch{14}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{14}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{14}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{14}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Menu: Correction type (cfg_menu)';
matlabbatch{14}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{13}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{14}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{14}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{14}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.type = 'cfg_choice';
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.name = 'Data Source and Correction Method';
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.tag = 'which';
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{1}(1) = cfg_dep;
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{1}(1).tname = 'Values Item';
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{1}(1).tgt_spec = {};
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{1}(1).sname = 'Branch: Cardiac (cfg_branch)';
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{1}(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{1}(1).src_output = substruct('()',{1});
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{2}(1) = cfg_dep;
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{2}(1).tname = 'Values Item';
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{2}(1).tgt_spec = {};
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{2}(1).sname = 'Branch: Respiratory (cfg_branch)';
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{2}(1).src_exbranch = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{2}(1).src_output = substruct('()',{1});
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{3}(1) = cfg_dep;
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{3}(1).tname = 'Values Item';
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{3}(1).tgt_spec = {};
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{3}(1).sname = 'Branch: Pulse (cfg_branch)';
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{3}(1).src_exbranch = substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{3}(1).src_output = substruct('()',{1});
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{4}(1) = cfg_dep;
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{4}(1).tname = 'Values Item';
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{4}(1).tgt_spec = {};
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{4}(1).sname = 'Branch: Respiratory+Cardiac (cfg_branch)';
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{4}(1).src_exbranch = substruct('.','val', '{}',{8}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{4}(1).src_output = substruct('()',{1});
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{5}(1) = cfg_dep;
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{5}(1).tname = 'Values Item';
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{5}(1).tgt_spec = {};
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{5}(1).sname = 'Branch: Cardiac+Respiratory (cfg_branch)';
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{5}(1).src_exbranch = substruct('.','val', '{}',{10}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{5}(1).src_output = substruct('()',{1});
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{6}(1) = cfg_dep;
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{6}(1).tname = 'Values Item';
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{6}(1).tgt_spec = {};
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{6}(1).sname = 'Branch: Respiratory+Pulse (cfg_branch)';
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{6}(1).src_exbranch = substruct('.','val', '{}',{12}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{6}(1).src_output = substruct('()',{1});
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{7}(1) = cfg_dep;
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{7}(1).tname = 'Values Item';
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{7}(1).tgt_spec = {};
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{7}(1).sname = 'Branch: Pulse+Respiratory (cfg_branch)';
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{7}(1).src_exbranch = substruct('.','val', '{}',{14}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.values{7}(1).src_output = substruct('()',{1});
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.check = [];
matlabbatch{15}.menu_cfg.menu_struct.conf_choice.help = {};
matlabbatch{16}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{16}.menu_cfg.menu_entry.conf_entry.name = 'Phases of Slices';
matlabbatch{16}.menu_cfg.menu_entry.conf_entry.tag = 'PhasesOfSlices';
matlabbatch{16}.menu_cfg.menu_entry.conf_entry.strtype = 'r';
matlabbatch{16}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{16}.menu_cfg.menu_entry.conf_entry.num = [];
matlabbatch{16}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{16}.menu_cfg.menu_entry.conf_entry.help = {};
matlabbatch{16}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{17}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{17}.menu_cfg.menu_entry.conf_entry.name = 'Cycles of Slices';
matlabbatch{17}.menu_cfg.menu_entry.conf_entry.tag = 'CyclesOfSlices';
matlabbatch{17}.menu_cfg.menu_entry.conf_entry.strtype = 'r';
matlabbatch{17}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{17}.menu_cfg.menu_entry.conf_entry.num = [];
matlabbatch{17}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{17}.menu_cfg.menu_entry.conf_entry.help = {};
matlabbatch{17}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{18}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{18}.menu_cfg.menu_struct.conf_branch.name = 'Specify Data';
matlabbatch{18}.menu_cfg.menu_struct.conf_branch.tag = 'var';
matlabbatch{18}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{18}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{18}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{18}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Entry: Phases of Slices (cfg_entry)';
matlabbatch{18}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{16}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{18}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{18}.menu_cfg.menu_struct.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{18}.menu_cfg.menu_struct.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{18}.menu_cfg.menu_struct.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{18}.menu_cfg.menu_struct.conf_branch.val{2}(1).sname = 'Entry: Cycles of Slices (cfg_entry)';
matlabbatch{18}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{17}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{18}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{18}.menu_cfg.menu_struct.conf_branch.val{3}(1) = cfg_dep;
matlabbatch{18}.menu_cfg.menu_struct.conf_branch.val{3}(1).tname = 'Val Item';
matlabbatch{18}.menu_cfg.menu_struct.conf_branch.val{3}(1).tgt_spec = {};
matlabbatch{18}.menu_cfg.menu_struct.conf_branch.val{3}(1).sname = 'Choice: Data Source and Correction Method (cfg_choice)';
matlabbatch{18}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_exbranch = substruct('.','val', '{}',{15}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{18}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{18}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{18}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{19}.menu_cfg.menu_entry.conf_files.type = 'cfg_files';
matlabbatch{19}.menu_cfg.menu_entry.conf_files.name = 'Specify .mat File';
matlabbatch{19}.menu_cfg.menu_entry.conf_files.tag = 'matfile';
matlabbatch{19}.menu_cfg.menu_entry.conf_files.filter = 'mat';
matlabbatch{19}.menu_cfg.menu_entry.conf_files.ufilter = '.*';
matlabbatch{19}.menu_cfg.menu_entry.conf_files.dir = '';
matlabbatch{19}.menu_cfg.menu_entry.conf_files.num = [1 1];
matlabbatch{19}.menu_cfg.menu_entry.conf_files.check = [];
matlabbatch{19}.menu_cfg.menu_entry.conf_files.help = {};
matlabbatch{19}.menu_cfg.menu_entry.conf_files.def = [];
matlabbatch{20}.menu_cfg.menu_struct.conf_choice.type = 'cfg_choice';
matlabbatch{20}.menu_cfg.menu_struct.conf_choice.name = 'Correction Data';
matlabbatch{20}.menu_cfg.menu_struct.conf_choice.tag = 'corrdata';
matlabbatch{20}.menu_cfg.menu_struct.conf_choice.values{1}(1) = cfg_dep;
matlabbatch{20}.menu_cfg.menu_struct.conf_choice.values{1}(1).tname = 'Values Item';
matlabbatch{20}.menu_cfg.menu_struct.conf_choice.values{1}(1).tgt_spec = {};
matlabbatch{20}.menu_cfg.menu_struct.conf_choice.values{1}(1).sname = 'Branch: Specify Data (cfg_branch)';
matlabbatch{20}.menu_cfg.menu_struct.conf_choice.values{1}(1).src_exbranch = substruct('.','val', '{}',{18}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{20}.menu_cfg.menu_struct.conf_choice.values{1}(1).src_output = substruct('()',{1});
matlabbatch{20}.menu_cfg.menu_struct.conf_choice.values{2}(1) = cfg_dep;
matlabbatch{20}.menu_cfg.menu_struct.conf_choice.values{2}(1).tname = 'Values Item';
matlabbatch{20}.menu_cfg.menu_struct.conf_choice.values{2}(1).tgt_spec = {};
matlabbatch{20}.menu_cfg.menu_struct.conf_choice.values{2}(1).sname = 'Files: Specify .mat File (cfg_files)';
matlabbatch{20}.menu_cfg.menu_struct.conf_choice.values{2}(1).src_exbranch = substruct('.','val', '{}',{19}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{20}.menu_cfg.menu_struct.conf_choice.values{2}(1).src_output = substruct('()',{1});
matlabbatch{20}.menu_cfg.menu_struct.conf_choice.check = [];
matlabbatch{20}.menu_cfg.menu_struct.conf_choice.help = {};
