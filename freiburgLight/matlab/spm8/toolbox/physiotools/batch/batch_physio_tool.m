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
matlabbatch{21}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{21}.menu_cfg.menu_entry.conf_menu.name = 'Fit Method';
matlabbatch{21}.menu_cfg.menu_entry.conf_menu.tag = 'fitmethod';
matlabbatch{21}.menu_cfg.menu_entry.conf_menu.labels = {
                                                        'Fourier Series'
                                                        'Polynomial'
                                                        }';
matlabbatch{21}.menu_cfg.menu_entry.conf_menu.values = {
                                                        0
                                                        1
                                                        }';
matlabbatch{21}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{21}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{21}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{22}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{22}.menu_cfg.menu_entry.conf_menu.name = 'Fit Order';
matlabbatch{22}.menu_cfg.menu_entry.conf_menu.tag = 'fitorder';
matlabbatch{22}.menu_cfg.menu_entry.conf_menu.labels = {
                                                        '2'
                                                        '4'
                                                        }';
matlabbatch{22}.menu_cfg.menu_entry.conf_menu.values = {
                                                        2
                                                        4
                                                        }';
matlabbatch{22}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{22}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{22}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{23}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{23}.menu_cfg.menu_entry.conf_entry.name = 'Prefix';
matlabbatch{23}.menu_cfg.menu_entry.conf_entry.tag = 'prefix';
matlabbatch{23}.menu_cfg.menu_entry.conf_entry.strtype = 's';
matlabbatch{23}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{23}.menu_cfg.menu_entry.conf_entry.num = [1 Inf];
matlabbatch{23}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{23}.menu_cfg.menu_entry.conf_entry.help = {'The prefix will be prepended  to the image filenames.'};
matlabbatch{23}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{24}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{24}.menu_cfg.menu_entry.conf_entry.name = 'Number of Scans';
matlabbatch{24}.menu_cfg.menu_entry.conf_entry.tag = 'nscans';
matlabbatch{24}.menu_cfg.menu_entry.conf_entry.strtype = 'n';
matlabbatch{24}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{24}.menu_cfg.menu_entry.conf_entry.num = [1 1];
matlabbatch{24}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{24}.menu_cfg.menu_entry.conf_entry.help = {'Enter the number of scans in your time series.'};
matlabbatch{24}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{25}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{25}.menu_cfg.menu_entry.conf_entry.name = 'Number of Slices';
matlabbatch{25}.menu_cfg.menu_entry.conf_entry.tag = 'nslices';
matlabbatch{25}.menu_cfg.menu_entry.conf_entry.strtype = 'n';
matlabbatch{25}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{25}.menu_cfg.menu_entry.conf_entry.num = [1 1];
matlabbatch{25}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{25}.menu_cfg.menu_entry.conf_entry.help = {'Enter the number of slices per scan. All scans in a time series are supposed to have the same number of slices.'};
matlabbatch{25}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{26}.menu_cfg.menu_entry.conf_files.type = 'cfg_files';
matlabbatch{26}.menu_cfg.menu_entry.conf_files.name = 'Image Time Series';
matlabbatch{26}.menu_cfg.menu_entry.conf_files.tag = 'images';
matlabbatch{26}.menu_cfg.menu_entry.conf_files.filter = 'image';
matlabbatch{26}.menu_cfg.menu_entry.conf_files.ufilter = '.*';
matlabbatch{26}.menu_cfg.menu_entry.conf_files.dir = [];
matlabbatch{26}.menu_cfg.menu_entry.conf_files.num = [1 Inf];
matlabbatch{26}.menu_cfg.menu_entry.conf_files.check = [];
matlabbatch{26}.menu_cfg.menu_entry.conf_files.help = {'Enter the image time series.'};
matlabbatch{26}.menu_cfg.menu_entry.conf_files.def = [];
matlabbatch{27}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{27}.menu_cfg.menu_entry.conf_entry.name = 'TR';
matlabbatch{27}.menu_cfg.menu_entry.conf_entry.tag = 'TR';
matlabbatch{27}.menu_cfg.menu_entry.conf_entry.strtype = 'r';
matlabbatch{27}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{27}.menu_cfg.menu_entry.conf_entry.num = [1 1];
matlabbatch{27}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{27}.menu_cfg.menu_entry.conf_entry.help = {'The TR of your experiment. Note that this function assumes that the scans are acquired without any "silent" periods between scans.'};
matlabbatch{27}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{28}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{28}.menu_cfg.menu_entry.conf_entry.name = '#Dummy scans';
matlabbatch{28}.menu_cfg.menu_entry.conf_entry.tag = 'ndummy';
matlabbatch{28}.menu_cfg.menu_entry.conf_entry.strtype = 'w';
matlabbatch{28}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{28}.menu_cfg.menu_entry.conf_entry.num = [1 1];
matlabbatch{28}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{28}.menu_cfg.menu_entry.conf_entry.help = {'Enter the number of dummy scans that were acquired before the start of the image time series.'};
matlabbatch{28}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{29}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{29}.menu_cfg.menu_entry.conf_entry.name = 'Slice order';
matlabbatch{29}.menu_cfg.menu_entry.conf_entry.tag = 'sorder';
matlabbatch{29}.menu_cfg.menu_entry.conf_entry.strtype = 'n';
matlabbatch{29}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{29}.menu_cfg.menu_entry.conf_entry.num = [1 Inf];
matlabbatch{29}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{29}.menu_cfg.menu_entry.conf_entry.help = {'Enter the slice order of your acquisition.'};
matlabbatch{29}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{30}.menu_cfg.menu_entry.conf_files.type = 'cfg_files';
matlabbatch{30}.menu_cfg.menu_entry.conf_files.name = 'Data file';
matlabbatch{30}.menu_cfg.menu_entry.conf_files.tag = 'datafile';
matlabbatch{30}.menu_cfg.menu_entry.conf_files.filter = 'any';
matlabbatch{30}.menu_cfg.menu_entry.conf_files.ufilter = '.*';
matlabbatch{30}.menu_cfg.menu_entry.conf_files.dir = [];
matlabbatch{30}.menu_cfg.menu_entry.conf_files.num = [1 1];
matlabbatch{30}.menu_cfg.menu_entry.conf_files.check = [];
matlabbatch{30}.menu_cfg.menu_entry.conf_files.help = {};
matlabbatch{30}.menu_cfg.menu_entry.conf_files.def = [];
matlabbatch{31}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{31}.menu_cfg.menu_entry.conf_entry.name = 'Bandwidth';
matlabbatch{31}.menu_cfg.menu_entry.conf_entry.tag = 'bandwidth';
matlabbatch{31}.menu_cfg.menu_entry.conf_entry.strtype = 'r';
matlabbatch{31}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{31}.menu_cfg.menu_entry.conf_entry.num = [1 1];
matlabbatch{31}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{31}.menu_cfg.menu_entry.conf_entry.help = {};
matlabbatch{31}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{32}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{32}.menu_cfg.menu_entry.conf_menu.name = 'Flip sign of signal';
matlabbatch{32}.menu_cfg.menu_entry.conf_menu.tag = 'flip';
matlabbatch{32}.menu_cfg.menu_entry.conf_menu.labels = {
                                                        'No'
                                                        'Yes'
                                                        }';
matlabbatch{32}.menu_cfg.menu_entry.conf_menu.values = {
                                                        false
                                                        true
                                                        }';
matlabbatch{32}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{32}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{32}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{33}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{33}.menu_cfg.menu_entry.conf_entry.name = 'Channel';
matlabbatch{33}.menu_cfg.menu_entry.conf_entry.tag = 'channel';
matlabbatch{33}.menu_cfg.menu_entry.conf_entry.strtype = 'n';
matlabbatch{33}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{33}.menu_cfg.menu_entry.conf_entry.num = [1 1];
matlabbatch{33}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{33}.menu_cfg.menu_entry.conf_entry.help = {};
matlabbatch{33}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.name = 'Cardiac';
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.tag = 'cardiac';
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Files: Data file (cfg_files)';
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{30}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.val{2}(1).sname = 'Entry: Bandwidth (cfg_entry)';
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{31}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.val{3}(1) = cfg_dep;
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.val{3}(1).tname = 'Val Item';
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.val{3}(1).tgt_spec = {};
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.val{3}(1).sname = 'Menu: Flip sign of signal (cfg_menu)';
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_exbranch = substruct('.','val', '{}',{32}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.val{4}(1) = cfg_dep;
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.val{4}(1).tname = 'Val Item';
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.val{4}(1).tgt_spec = {};
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.val{4}(1).sname = 'Entry: Channel (cfg_entry)';
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.val{4}(1).src_exbranch = substruct('.','val', '{}',{33}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.val{4}(1).src_output = substruct('()',{1});
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{34}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{35}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{35}.menu_cfg.menu_entry.conf_menu.name = 'Correction type';
matlabbatch{35}.menu_cfg.menu_entry.conf_menu.tag = 'corr';
matlabbatch{35}.menu_cfg.menu_entry.conf_menu.labels = {
                                                        'Global'
                                                        'Cyclic'
                                                        }';
matlabbatch{35}.menu_cfg.menu_entry.conf_menu.values = {
                                                        0
                                                        1
                                                        }';
matlabbatch{35}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{35}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{35}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{36}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{36}.menu_cfg.menu_struct.conf_branch.name = 'Cardiac';
matlabbatch{36}.menu_cfg.menu_struct.conf_branch.tag = 'cardiac';
matlabbatch{36}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{36}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{36}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{36}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Branch: Cardiac (cfg_branch)';
matlabbatch{36}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{34}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{36}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{36}.menu_cfg.menu_struct.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{36}.menu_cfg.menu_struct.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{36}.menu_cfg.menu_struct.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{36}.menu_cfg.menu_struct.conf_branch.val{2}(1).sname = 'Menu: Correction type (cfg_menu)';
matlabbatch{36}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{35}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{36}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{36}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{36}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{37}.menu_cfg.menu_entry.conf_files.type = 'cfg_files';
matlabbatch{37}.menu_cfg.menu_entry.conf_files.name = 'Data file';
matlabbatch{37}.menu_cfg.menu_entry.conf_files.tag = 'datafile';
matlabbatch{37}.menu_cfg.menu_entry.conf_files.filter = 'any';
matlabbatch{37}.menu_cfg.menu_entry.conf_files.ufilter = '.*';
matlabbatch{37}.menu_cfg.menu_entry.conf_files.dir = [];
matlabbatch{37}.menu_cfg.menu_entry.conf_files.num = [1 1];
matlabbatch{37}.menu_cfg.menu_entry.conf_files.check = [];
matlabbatch{37}.menu_cfg.menu_entry.conf_files.help = {};
matlabbatch{37}.menu_cfg.menu_entry.conf_files.def = [];
matlabbatch{38}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{38}.menu_cfg.menu_entry.conf_entry.name = 'Bandwidth';
matlabbatch{38}.menu_cfg.menu_entry.conf_entry.tag = 'bandwidth';
matlabbatch{38}.menu_cfg.menu_entry.conf_entry.strtype = 'r';
matlabbatch{38}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{38}.menu_cfg.menu_entry.conf_entry.num = [1 1];
matlabbatch{38}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{38}.menu_cfg.menu_entry.conf_entry.help = {};
matlabbatch{38}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{39}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{39}.menu_cfg.menu_entry.conf_menu.name = 'Flip sign of signal';
matlabbatch{39}.menu_cfg.menu_entry.conf_menu.tag = 'flip';
matlabbatch{39}.menu_cfg.menu_entry.conf_menu.labels = {
                                                        'No'
                                                        'Yes'
                                                        }';
matlabbatch{39}.menu_cfg.menu_entry.conf_menu.values = {
                                                        false
                                                        true
                                                        }';
matlabbatch{39}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{39}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{39}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{40}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{40}.menu_cfg.menu_struct.conf_branch.name = 'Respiratory';
matlabbatch{40}.menu_cfg.menu_struct.conf_branch.tag = 'resp';
matlabbatch{40}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{40}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{40}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{40}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Files: Data file (cfg_files)';
matlabbatch{40}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{37}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{40}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{40}.menu_cfg.menu_struct.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{40}.menu_cfg.menu_struct.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{40}.menu_cfg.menu_struct.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{40}.menu_cfg.menu_struct.conf_branch.val{2}(1).sname = 'Entry: Bandwidth (cfg_entry)';
matlabbatch{40}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{38}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{40}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{40}.menu_cfg.menu_struct.conf_branch.val{3}(1) = cfg_dep;
matlabbatch{40}.menu_cfg.menu_struct.conf_branch.val{3}(1).tname = 'Val Item';
matlabbatch{40}.menu_cfg.menu_struct.conf_branch.val{3}(1).tgt_spec = {};
matlabbatch{40}.menu_cfg.menu_struct.conf_branch.val{3}(1).sname = 'Menu: Flip sign of signal (cfg_menu)';
matlabbatch{40}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_exbranch = substruct('.','val', '{}',{39}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{40}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{40}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{40}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{41}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{41}.menu_cfg.menu_entry.conf_menu.name = 'Correction type';
matlabbatch{41}.menu_cfg.menu_entry.conf_menu.tag = 'corr';
matlabbatch{41}.menu_cfg.menu_entry.conf_menu.labels = {
                                                        'Global (histogram)'
                                                        'Global'
                                                        'Cyclic'
                                                        }';
matlabbatch{41}.menu_cfg.menu_entry.conf_menu.values = {
                                                        -1
                                                        0
                                                        1
                                                        }';
matlabbatch{41}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{41}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{41}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{42}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{42}.menu_cfg.menu_struct.conf_branch.name = 'Respiratory';
matlabbatch{42}.menu_cfg.menu_struct.conf_branch.tag = 'resp';
matlabbatch{42}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{42}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{42}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{42}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Branch: Respiratory (cfg_branch)';
matlabbatch{42}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{40}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{42}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{42}.menu_cfg.menu_struct.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{42}.menu_cfg.menu_struct.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{42}.menu_cfg.menu_struct.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{42}.menu_cfg.menu_struct.conf_branch.val{2}(1).sname = 'Menu: Correction type (cfg_menu)';
matlabbatch{42}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{41}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{42}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{42}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{42}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{43}.menu_cfg.menu_entry.conf_files.type = 'cfg_files';
matlabbatch{43}.menu_cfg.menu_entry.conf_files.name = 'Data file';
matlabbatch{43}.menu_cfg.menu_entry.conf_files.tag = 'datafile';
matlabbatch{43}.menu_cfg.menu_entry.conf_files.filter = 'any';
matlabbatch{43}.menu_cfg.menu_entry.conf_files.ufilter = '.*';
matlabbatch{43}.menu_cfg.menu_entry.conf_files.dir = [];
matlabbatch{43}.menu_cfg.menu_entry.conf_files.num = [1 1];
matlabbatch{43}.menu_cfg.menu_entry.conf_files.check = [];
matlabbatch{43}.menu_cfg.menu_entry.conf_files.help = {};
matlabbatch{43}.menu_cfg.menu_entry.conf_files.def = [];
matlabbatch{44}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{44}.menu_cfg.menu_entry.conf_entry.name = 'Bandwidth';
matlabbatch{44}.menu_cfg.menu_entry.conf_entry.tag = 'bandwidth';
matlabbatch{44}.menu_cfg.menu_entry.conf_entry.strtype = 'r';
matlabbatch{44}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{44}.menu_cfg.menu_entry.conf_entry.num = [1 1];
matlabbatch{44}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{44}.menu_cfg.menu_entry.conf_entry.help = {};
matlabbatch{44}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{45}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{45}.menu_cfg.menu_entry.conf_menu.name = 'Flip sign of signal';
matlabbatch{45}.menu_cfg.menu_entry.conf_menu.tag = 'flip';
matlabbatch{45}.menu_cfg.menu_entry.conf_menu.labels = {
                                                        'No'
                                                        'Yes'
                                                        }';
matlabbatch{45}.menu_cfg.menu_entry.conf_menu.values = {
                                                        false
                                                        true
                                                        }';
matlabbatch{45}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{45}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{45}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{46}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{46}.menu_cfg.menu_struct.conf_branch.name = 'Pulse';
matlabbatch{46}.menu_cfg.menu_struct.conf_branch.tag = 'pulse';
matlabbatch{46}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{46}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{46}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{46}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Files: Data file (cfg_files)';
matlabbatch{46}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{43}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{46}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{46}.menu_cfg.menu_struct.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{46}.menu_cfg.menu_struct.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{46}.menu_cfg.menu_struct.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{46}.menu_cfg.menu_struct.conf_branch.val{2}(1).sname = 'Entry: Bandwidth (cfg_entry)';
matlabbatch{46}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{44}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{46}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{46}.menu_cfg.menu_struct.conf_branch.val{3}(1) = cfg_dep;
matlabbatch{46}.menu_cfg.menu_struct.conf_branch.val{3}(1).tname = 'Val Item';
matlabbatch{46}.menu_cfg.menu_struct.conf_branch.val{3}(1).tgt_spec = {};
matlabbatch{46}.menu_cfg.menu_struct.conf_branch.val{3}(1).sname = 'Menu: Flip sign of signal (cfg_menu)';
matlabbatch{46}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_exbranch = substruct('.','val', '{}',{45}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{46}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{46}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{46}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{47}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{47}.menu_cfg.menu_entry.conf_menu.name = 'Correction type';
matlabbatch{47}.menu_cfg.menu_entry.conf_menu.tag = 'corr';
matlabbatch{47}.menu_cfg.menu_entry.conf_menu.labels = {
                                                        'Global'
                                                        'Cyclic'
                                                        }';
matlabbatch{47}.menu_cfg.menu_entry.conf_menu.values = {
                                                        0
                                                        1
                                                        }';
matlabbatch{47}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{47}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{47}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{48}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{48}.menu_cfg.menu_struct.conf_branch.name = 'Pulse';
matlabbatch{48}.menu_cfg.menu_struct.conf_branch.tag = 'pulse';
matlabbatch{48}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{48}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{48}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{48}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Branch: Pulse (cfg_branch)';
matlabbatch{48}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{46}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{48}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{48}.menu_cfg.menu_struct.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{48}.menu_cfg.menu_struct.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{48}.menu_cfg.menu_struct.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{48}.menu_cfg.menu_struct.conf_branch.val{2}(1).sname = 'Menu: Correction type (cfg_menu)';
matlabbatch{48}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{47}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{48}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{48}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{48}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{49}.menu_cfg.menu_entry.conf_files.type = 'cfg_files';
matlabbatch{49}.menu_cfg.menu_entry.conf_files.name = 'Data file';
matlabbatch{49}.menu_cfg.menu_entry.conf_files.tag = 'datafile';
matlabbatch{49}.menu_cfg.menu_entry.conf_files.filter = 'any';
matlabbatch{49}.menu_cfg.menu_entry.conf_files.ufilter = '.*';
matlabbatch{49}.menu_cfg.menu_entry.conf_files.dir = [];
matlabbatch{49}.menu_cfg.menu_entry.conf_files.num = [1 1];
matlabbatch{49}.menu_cfg.menu_entry.conf_files.check = [];
matlabbatch{49}.menu_cfg.menu_entry.conf_files.help = {};
matlabbatch{49}.menu_cfg.menu_entry.conf_files.def = [];
matlabbatch{50}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{50}.menu_cfg.menu_entry.conf_entry.name = 'Bandwidth';
matlabbatch{50}.menu_cfg.menu_entry.conf_entry.tag = 'bandwidth';
matlabbatch{50}.menu_cfg.menu_entry.conf_entry.strtype = 'r';
matlabbatch{50}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{50}.menu_cfg.menu_entry.conf_entry.num = [1 1];
matlabbatch{50}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{50}.menu_cfg.menu_entry.conf_entry.help = {};
matlabbatch{50}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{51}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{51}.menu_cfg.menu_entry.conf_menu.name = 'Flip sign of signal';
matlabbatch{51}.menu_cfg.menu_entry.conf_menu.tag = 'flip';
matlabbatch{51}.menu_cfg.menu_entry.conf_menu.labels = {
                                                        'No'
                                                        'Yes'
                                                        }';
matlabbatch{51}.menu_cfg.menu_entry.conf_menu.values = {
                                                        false
                                                        true
                                                        }';
matlabbatch{51}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{51}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{51}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{52}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{52}.menu_cfg.menu_struct.conf_branch.name = 'Respiratory';
matlabbatch{52}.menu_cfg.menu_struct.conf_branch.tag = 'resp';
matlabbatch{52}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{52}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{52}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{52}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Files: Data file (cfg_files)';
matlabbatch{52}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{49}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{52}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{52}.menu_cfg.menu_struct.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{52}.menu_cfg.menu_struct.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{52}.menu_cfg.menu_struct.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{52}.menu_cfg.menu_struct.conf_branch.val{2}(1).sname = 'Entry: Bandwidth (cfg_entry)';
matlabbatch{52}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{50}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{52}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{52}.menu_cfg.menu_struct.conf_branch.val{3}(1) = cfg_dep;
matlabbatch{52}.menu_cfg.menu_struct.conf_branch.val{3}(1).tname = 'Val Item';
matlabbatch{52}.menu_cfg.menu_struct.conf_branch.val{3}(1).tgt_spec = {};
matlabbatch{52}.menu_cfg.menu_struct.conf_branch.val{3}(1).sname = 'Menu: Flip sign of signal (cfg_menu)';
matlabbatch{52}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_exbranch = substruct('.','val', '{}',{51}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{52}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{52}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{52}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{53}.menu_cfg.menu_entry.conf_files.type = 'cfg_files';
matlabbatch{53}.menu_cfg.menu_entry.conf_files.name = 'Data file';
matlabbatch{53}.menu_cfg.menu_entry.conf_files.tag = 'datafile';
matlabbatch{53}.menu_cfg.menu_entry.conf_files.filter = 'any';
matlabbatch{53}.menu_cfg.menu_entry.conf_files.ufilter = '.*';
matlabbatch{53}.menu_cfg.menu_entry.conf_files.dir = [];
matlabbatch{53}.menu_cfg.menu_entry.conf_files.num = [1 1];
matlabbatch{53}.menu_cfg.menu_entry.conf_files.check = [];
matlabbatch{53}.menu_cfg.menu_entry.conf_files.help = {};
matlabbatch{53}.menu_cfg.menu_entry.conf_files.def = [];
matlabbatch{54}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{54}.menu_cfg.menu_entry.conf_entry.name = 'Bandwidth';
matlabbatch{54}.menu_cfg.menu_entry.conf_entry.tag = 'bandwidth';
matlabbatch{54}.menu_cfg.menu_entry.conf_entry.strtype = 'r';
matlabbatch{54}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{54}.menu_cfg.menu_entry.conf_entry.num = [1 1];
matlabbatch{54}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{54}.menu_cfg.menu_entry.conf_entry.help = {};
matlabbatch{54}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{55}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{55}.menu_cfg.menu_entry.conf_menu.name = 'Flip sign of signal';
matlabbatch{55}.menu_cfg.menu_entry.conf_menu.tag = 'flip';
matlabbatch{55}.menu_cfg.menu_entry.conf_menu.labels = {
                                                        'No'
                                                        'Yes'
                                                        }';
matlabbatch{55}.menu_cfg.menu_entry.conf_menu.values = {
                                                        false
                                                        true
                                                        }';
matlabbatch{55}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{55}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{55}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{56}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{56}.menu_cfg.menu_entry.conf_entry.name = 'Channel';
matlabbatch{56}.menu_cfg.menu_entry.conf_entry.tag = 'channel';
matlabbatch{56}.menu_cfg.menu_entry.conf_entry.strtype = 'n';
matlabbatch{56}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{56}.menu_cfg.menu_entry.conf_entry.num = [1 1];
matlabbatch{56}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{56}.menu_cfg.menu_entry.conf_entry.help = {};
matlabbatch{56}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.name = 'Cardiac';
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.tag = 'cardiac';
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Files: Data file (cfg_files)';
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{53}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.val{2}(1).sname = 'Entry: Bandwidth (cfg_entry)';
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{54}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.val{3}(1) = cfg_dep;
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.val{3}(1).tname = 'Val Item';
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.val{3}(1).tgt_spec = {};
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.val{3}(1).sname = 'Menu: Flip sign of signal (cfg_menu)';
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_exbranch = substruct('.','val', '{}',{55}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.val{4}(1) = cfg_dep;
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.val{4}(1).tname = 'Val Item';
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.val{4}(1).tgt_spec = {};
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.val{4}(1).sname = 'Entry: Channel (cfg_entry)';
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.val{4}(1).src_exbranch = substruct('.','val', '{}',{56}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.val{4}(1).src_output = substruct('()',{1});
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{57}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{58}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{58}.menu_cfg.menu_entry.conf_menu.name = 'Correction type';
matlabbatch{58}.menu_cfg.menu_entry.conf_menu.tag = 'corr';
matlabbatch{58}.menu_cfg.menu_entry.conf_menu.labels = {
                                                        'Global (Resp histogram)'
                                                        'Both global'
                                                        'Global (Resp cyclic)'
                                                        'Both cyclic'
                                                        }';
matlabbatch{58}.menu_cfg.menu_entry.conf_menu.values = {
                                                        -1
                                                        0
                                                        1
                                                        2
                                                        }';
matlabbatch{58}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{58}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{58}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{59}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{59}.menu_cfg.menu_struct.conf_branch.name = 'Respiratory+Cardiac';
matlabbatch{59}.menu_cfg.menu_struct.conf_branch.tag = 'respcard';
matlabbatch{59}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{59}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{59}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{59}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Branch: Respiratory (cfg_branch)';
matlabbatch{59}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{52}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{59}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{59}.menu_cfg.menu_struct.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{59}.menu_cfg.menu_struct.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{59}.menu_cfg.menu_struct.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{59}.menu_cfg.menu_struct.conf_branch.val{2}(1).sname = 'Branch: Cardiac (cfg_branch)';
matlabbatch{59}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{57}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{59}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{59}.menu_cfg.menu_struct.conf_branch.val{3}(1) = cfg_dep;
matlabbatch{59}.menu_cfg.menu_struct.conf_branch.val{3}(1).tname = 'Val Item';
matlabbatch{59}.menu_cfg.menu_struct.conf_branch.val{3}(1).tgt_spec = {};
matlabbatch{59}.menu_cfg.menu_struct.conf_branch.val{3}(1).sname = 'Menu: Correction type (cfg_menu)';
matlabbatch{59}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_exbranch = substruct('.','val', '{}',{58}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{59}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{59}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{59}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{60}.menu_cfg.menu_entry.conf_files.type = 'cfg_files';
matlabbatch{60}.menu_cfg.menu_entry.conf_files.name = 'Data file';
matlabbatch{60}.menu_cfg.menu_entry.conf_files.tag = 'datafile';
matlabbatch{60}.menu_cfg.menu_entry.conf_files.filter = 'any';
matlabbatch{60}.menu_cfg.menu_entry.conf_files.ufilter = '.*';
matlabbatch{60}.menu_cfg.menu_entry.conf_files.dir = [];
matlabbatch{60}.menu_cfg.menu_entry.conf_files.num = [1 1];
matlabbatch{60}.menu_cfg.menu_entry.conf_files.check = [];
matlabbatch{60}.menu_cfg.menu_entry.conf_files.help = {};
matlabbatch{60}.menu_cfg.menu_entry.conf_files.def = [];
matlabbatch{61}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{61}.menu_cfg.menu_entry.conf_entry.name = 'Bandwidth';
matlabbatch{61}.menu_cfg.menu_entry.conf_entry.tag = 'bandwidth';
matlabbatch{61}.menu_cfg.menu_entry.conf_entry.strtype = 'r';
matlabbatch{61}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{61}.menu_cfg.menu_entry.conf_entry.num = [1 1];
matlabbatch{61}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{61}.menu_cfg.menu_entry.conf_entry.help = {};
matlabbatch{61}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{62}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{62}.menu_cfg.menu_entry.conf_menu.name = 'Flip sign of signal';
matlabbatch{62}.menu_cfg.menu_entry.conf_menu.tag = 'flip';
matlabbatch{62}.menu_cfg.menu_entry.conf_menu.labels = {
                                                        'No'
                                                        'Yes'
                                                        }';
matlabbatch{62}.menu_cfg.menu_entry.conf_menu.values = {
                                                        false
                                                        true
                                                        }';
matlabbatch{62}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{62}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{62}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{63}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{63}.menu_cfg.menu_struct.conf_branch.name = 'Respiratory';
matlabbatch{63}.menu_cfg.menu_struct.conf_branch.tag = 'resp';
matlabbatch{63}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{63}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{63}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{63}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Files: Data file (cfg_files)';
matlabbatch{63}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{60}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{63}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{63}.menu_cfg.menu_struct.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{63}.menu_cfg.menu_struct.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{63}.menu_cfg.menu_struct.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{63}.menu_cfg.menu_struct.conf_branch.val{2}(1).sname = 'Entry: Bandwidth (cfg_entry)';
matlabbatch{63}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{61}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{63}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{63}.menu_cfg.menu_struct.conf_branch.val{3}(1) = cfg_dep;
matlabbatch{63}.menu_cfg.menu_struct.conf_branch.val{3}(1).tname = 'Val Item';
matlabbatch{63}.menu_cfg.menu_struct.conf_branch.val{3}(1).tgt_spec = {};
matlabbatch{63}.menu_cfg.menu_struct.conf_branch.val{3}(1).sname = 'Menu: Flip sign of signal (cfg_menu)';
matlabbatch{63}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_exbranch = substruct('.','val', '{}',{62}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{63}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{63}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{63}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{64}.menu_cfg.menu_entry.conf_files.type = 'cfg_files';
matlabbatch{64}.menu_cfg.menu_entry.conf_files.name = 'Data file';
matlabbatch{64}.menu_cfg.menu_entry.conf_files.tag = 'datafile';
matlabbatch{64}.menu_cfg.menu_entry.conf_files.filter = 'any';
matlabbatch{64}.menu_cfg.menu_entry.conf_files.ufilter = '.*';
matlabbatch{64}.menu_cfg.menu_entry.conf_files.dir = [];
matlabbatch{64}.menu_cfg.menu_entry.conf_files.num = [1 1];
matlabbatch{64}.menu_cfg.menu_entry.conf_files.check = [];
matlabbatch{64}.menu_cfg.menu_entry.conf_files.help = {};
matlabbatch{64}.menu_cfg.menu_entry.conf_files.def = [];
matlabbatch{65}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{65}.menu_cfg.menu_entry.conf_entry.name = 'Bandwidth';
matlabbatch{65}.menu_cfg.menu_entry.conf_entry.tag = 'bandwidth';
matlabbatch{65}.menu_cfg.menu_entry.conf_entry.strtype = 'r';
matlabbatch{65}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{65}.menu_cfg.menu_entry.conf_entry.num = [1 1];
matlabbatch{65}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{65}.menu_cfg.menu_entry.conf_entry.help = {};
matlabbatch{65}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{66}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{66}.menu_cfg.menu_entry.conf_menu.name = 'Flip sign of signal';
matlabbatch{66}.menu_cfg.menu_entry.conf_menu.tag = 'flip';
matlabbatch{66}.menu_cfg.menu_entry.conf_menu.labels = {
                                                        'No'
                                                        'Yes'
                                                        }';
matlabbatch{66}.menu_cfg.menu_entry.conf_menu.values = {
                                                        false
                                                        true
                                                        }';
matlabbatch{66}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{66}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{66}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{67}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{67}.menu_cfg.menu_entry.conf_entry.name = 'Channel';
matlabbatch{67}.menu_cfg.menu_entry.conf_entry.tag = 'channel';
matlabbatch{67}.menu_cfg.menu_entry.conf_entry.strtype = 'n';
matlabbatch{67}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{67}.menu_cfg.menu_entry.conf_entry.num = [1 1];
matlabbatch{67}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{67}.menu_cfg.menu_entry.conf_entry.help = {};
matlabbatch{67}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.name = 'Cardiac';
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.tag = 'cardiac';
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Files: Data file (cfg_files)';
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{64}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.val{2}(1).sname = 'Entry: Bandwidth (cfg_entry)';
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{65}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.val{3}(1) = cfg_dep;
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.val{3}(1).tname = 'Val Item';
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.val{3}(1).tgt_spec = {};
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.val{3}(1).sname = 'Menu: Flip sign of signal (cfg_menu)';
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_exbranch = substruct('.','val', '{}',{66}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.val{4}(1) = cfg_dep;
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.val{4}(1).tname = 'Val Item';
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.val{4}(1).tgt_spec = {};
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.val{4}(1).sname = 'Entry: Channel (cfg_entry)';
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.val{4}(1).src_exbranch = substruct('.','val', '{}',{67}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.val{4}(1).src_output = substruct('()',{1});
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{68}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{69}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{69}.menu_cfg.menu_entry.conf_menu.name = 'Correction type';
matlabbatch{69}.menu_cfg.menu_entry.conf_menu.tag = 'corr';
matlabbatch{69}.menu_cfg.menu_entry.conf_menu.labels = {
                                                        'Global (Resp histogram)'
                                                        'Both global'
                                                        'Global (Resp cyclic)'
                                                        'Both cyclic'
                                                        }';
matlabbatch{69}.menu_cfg.menu_entry.conf_menu.values = {
                                                        -1
                                                        0
                                                        1
                                                        2
                                                        }';
matlabbatch{69}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{69}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{69}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{70}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{70}.menu_cfg.menu_struct.conf_branch.name = 'Cardiac+Respiratory';
matlabbatch{70}.menu_cfg.menu_struct.conf_branch.tag = 'cardresp';
matlabbatch{70}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{70}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{70}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{70}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Branch: Cardiac (cfg_branch)';
matlabbatch{70}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{68}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{70}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{70}.menu_cfg.menu_struct.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{70}.menu_cfg.menu_struct.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{70}.menu_cfg.menu_struct.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{70}.menu_cfg.menu_struct.conf_branch.val{2}(1).sname = 'Branch: Respiratory (cfg_branch)';
matlabbatch{70}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{63}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{70}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{70}.menu_cfg.menu_struct.conf_branch.val{3}(1) = cfg_dep;
matlabbatch{70}.menu_cfg.menu_struct.conf_branch.val{3}(1).tname = 'Val Item';
matlabbatch{70}.menu_cfg.menu_struct.conf_branch.val{3}(1).tgt_spec = {};
matlabbatch{70}.menu_cfg.menu_struct.conf_branch.val{3}(1).sname = 'Menu: Correction type (cfg_menu)';
matlabbatch{70}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_exbranch = substruct('.','val', '{}',{69}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{70}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{70}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{70}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{71}.menu_cfg.menu_entry.conf_files.type = 'cfg_files';
matlabbatch{71}.menu_cfg.menu_entry.conf_files.name = 'Data file';
matlabbatch{71}.menu_cfg.menu_entry.conf_files.tag = 'datafile';
matlabbatch{71}.menu_cfg.menu_entry.conf_files.filter = 'any';
matlabbatch{71}.menu_cfg.menu_entry.conf_files.ufilter = '.*';
matlabbatch{71}.menu_cfg.menu_entry.conf_files.dir = [];
matlabbatch{71}.menu_cfg.menu_entry.conf_files.num = [1 1];
matlabbatch{71}.menu_cfg.menu_entry.conf_files.check = [];
matlabbatch{71}.menu_cfg.menu_entry.conf_files.help = {};
matlabbatch{71}.menu_cfg.menu_entry.conf_files.def = [];
matlabbatch{72}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{72}.menu_cfg.menu_entry.conf_entry.name = 'Bandwidth';
matlabbatch{72}.menu_cfg.menu_entry.conf_entry.tag = 'bandwidth';
matlabbatch{72}.menu_cfg.menu_entry.conf_entry.strtype = 'r';
matlabbatch{72}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{72}.menu_cfg.menu_entry.conf_entry.num = [1 1];
matlabbatch{72}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{72}.menu_cfg.menu_entry.conf_entry.help = {};
matlabbatch{72}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{73}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{73}.menu_cfg.menu_entry.conf_menu.name = 'Flip sign of signal';
matlabbatch{73}.menu_cfg.menu_entry.conf_menu.tag = 'flip';
matlabbatch{73}.menu_cfg.menu_entry.conf_menu.labels = {
                                                        'No'
                                                        'Yes'
                                                        }';
matlabbatch{73}.menu_cfg.menu_entry.conf_menu.values = {
                                                        false
                                                        true
                                                        }';
matlabbatch{73}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{73}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{73}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{74}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{74}.menu_cfg.menu_struct.conf_branch.name = 'Respiratory';
matlabbatch{74}.menu_cfg.menu_struct.conf_branch.tag = 'resp';
matlabbatch{74}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{74}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{74}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{74}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Files: Data file (cfg_files)';
matlabbatch{74}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{71}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{74}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{74}.menu_cfg.menu_struct.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{74}.menu_cfg.menu_struct.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{74}.menu_cfg.menu_struct.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{74}.menu_cfg.menu_struct.conf_branch.val{2}(1).sname = 'Entry: Bandwidth (cfg_entry)';
matlabbatch{74}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{72}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{74}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{74}.menu_cfg.menu_struct.conf_branch.val{3}(1) = cfg_dep;
matlabbatch{74}.menu_cfg.menu_struct.conf_branch.val{3}(1).tname = 'Val Item';
matlabbatch{74}.menu_cfg.menu_struct.conf_branch.val{3}(1).tgt_spec = {};
matlabbatch{74}.menu_cfg.menu_struct.conf_branch.val{3}(1).sname = 'Menu: Flip sign of signal (cfg_menu)';
matlabbatch{74}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_exbranch = substruct('.','val', '{}',{73}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{74}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{74}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{74}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{75}.menu_cfg.menu_entry.conf_files.type = 'cfg_files';
matlabbatch{75}.menu_cfg.menu_entry.conf_files.name = 'Data file';
matlabbatch{75}.menu_cfg.menu_entry.conf_files.tag = 'datafile';
matlabbatch{75}.menu_cfg.menu_entry.conf_files.filter = 'any';
matlabbatch{75}.menu_cfg.menu_entry.conf_files.ufilter = '.*';
matlabbatch{75}.menu_cfg.menu_entry.conf_files.dir = [];
matlabbatch{75}.menu_cfg.menu_entry.conf_files.num = [1 1];
matlabbatch{75}.menu_cfg.menu_entry.conf_files.check = [];
matlabbatch{75}.menu_cfg.menu_entry.conf_files.help = {};
matlabbatch{75}.menu_cfg.menu_entry.conf_files.def = [];
matlabbatch{76}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{76}.menu_cfg.menu_entry.conf_entry.name = 'Bandwidth';
matlabbatch{76}.menu_cfg.menu_entry.conf_entry.tag = 'bandwidth';
matlabbatch{76}.menu_cfg.menu_entry.conf_entry.strtype = 'r';
matlabbatch{76}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{76}.menu_cfg.menu_entry.conf_entry.num = [1 1];
matlabbatch{76}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{76}.menu_cfg.menu_entry.conf_entry.help = {};
matlabbatch{76}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{77}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{77}.menu_cfg.menu_entry.conf_menu.name = 'Flip sign of signal';
matlabbatch{77}.menu_cfg.menu_entry.conf_menu.tag = 'flip';
matlabbatch{77}.menu_cfg.menu_entry.conf_menu.labels = {
                                                        'No'
                                                        'Yes'
                                                        }';
matlabbatch{77}.menu_cfg.menu_entry.conf_menu.values = {
                                                        false
                                                        true
                                                        }';
matlabbatch{77}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{77}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{77}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{78}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{78}.menu_cfg.menu_struct.conf_branch.name = 'Pulse';
matlabbatch{78}.menu_cfg.menu_struct.conf_branch.tag = 'pulse';
matlabbatch{78}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{78}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{78}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{78}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Files: Data file (cfg_files)';
matlabbatch{78}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{75}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{78}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{78}.menu_cfg.menu_struct.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{78}.menu_cfg.menu_struct.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{78}.menu_cfg.menu_struct.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{78}.menu_cfg.menu_struct.conf_branch.val{2}(1).sname = 'Entry: Bandwidth (cfg_entry)';
matlabbatch{78}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{76}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{78}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{78}.menu_cfg.menu_struct.conf_branch.val{3}(1) = cfg_dep;
matlabbatch{78}.menu_cfg.menu_struct.conf_branch.val{3}(1).tname = 'Val Item';
matlabbatch{78}.menu_cfg.menu_struct.conf_branch.val{3}(1).tgt_spec = {};
matlabbatch{78}.menu_cfg.menu_struct.conf_branch.val{3}(1).sname = 'Menu: Flip sign of signal (cfg_menu)';
matlabbatch{78}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_exbranch = substruct('.','val', '{}',{77}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{78}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{78}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{78}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{79}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{79}.menu_cfg.menu_entry.conf_menu.name = 'Correction type';
matlabbatch{79}.menu_cfg.menu_entry.conf_menu.tag = 'corr';
matlabbatch{79}.menu_cfg.menu_entry.conf_menu.labels = {
                                                        'Global (Resp histogram)'
                                                        'Both global'
                                                        'Global (Resp cyclic)'
                                                        'Both cyclic'
                                                        }';
matlabbatch{79}.menu_cfg.menu_entry.conf_menu.values = {
                                                        -1
                                                        0
                                                        1
                                                        2
                                                        }';
matlabbatch{79}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{79}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{79}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{80}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{80}.menu_cfg.menu_struct.conf_branch.name = 'Respiratory+Pulse';
matlabbatch{80}.menu_cfg.menu_struct.conf_branch.tag = 'resppulse';
matlabbatch{80}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{80}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{80}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{80}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Branch: Respiratory (cfg_branch)';
matlabbatch{80}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{74}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{80}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{80}.menu_cfg.menu_struct.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{80}.menu_cfg.menu_struct.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{80}.menu_cfg.menu_struct.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{80}.menu_cfg.menu_struct.conf_branch.val{2}(1).sname = 'Branch: Pulse (cfg_branch)';
matlabbatch{80}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{78}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{80}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{80}.menu_cfg.menu_struct.conf_branch.val{3}(1) = cfg_dep;
matlabbatch{80}.menu_cfg.menu_struct.conf_branch.val{3}(1).tname = 'Val Item';
matlabbatch{80}.menu_cfg.menu_struct.conf_branch.val{3}(1).tgt_spec = {};
matlabbatch{80}.menu_cfg.menu_struct.conf_branch.val{3}(1).sname = 'Menu: Correction type (cfg_menu)';
matlabbatch{80}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_exbranch = substruct('.','val', '{}',{79}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{80}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{80}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{80}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{81}.menu_cfg.menu_entry.conf_files.type = 'cfg_files';
matlabbatch{81}.menu_cfg.menu_entry.conf_files.name = 'Data file';
matlabbatch{81}.menu_cfg.menu_entry.conf_files.tag = 'datafile';
matlabbatch{81}.menu_cfg.menu_entry.conf_files.filter = 'any';
matlabbatch{81}.menu_cfg.menu_entry.conf_files.ufilter = '.*';
matlabbatch{81}.menu_cfg.menu_entry.conf_files.dir = [];
matlabbatch{81}.menu_cfg.menu_entry.conf_files.num = [1 1];
matlabbatch{81}.menu_cfg.menu_entry.conf_files.check = [];
matlabbatch{81}.menu_cfg.menu_entry.conf_files.help = {};
matlabbatch{81}.menu_cfg.menu_entry.conf_files.def = [];
matlabbatch{82}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{82}.menu_cfg.menu_entry.conf_entry.name = 'Bandwidth';
matlabbatch{82}.menu_cfg.menu_entry.conf_entry.tag = 'bandwidth';
matlabbatch{82}.menu_cfg.menu_entry.conf_entry.strtype = 'r';
matlabbatch{82}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{82}.menu_cfg.menu_entry.conf_entry.num = [1 1];
matlabbatch{82}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{82}.menu_cfg.menu_entry.conf_entry.help = {};
matlabbatch{82}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{83}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{83}.menu_cfg.menu_entry.conf_menu.name = 'Flip sign of signal';
matlabbatch{83}.menu_cfg.menu_entry.conf_menu.tag = 'flip';
matlabbatch{83}.menu_cfg.menu_entry.conf_menu.labels = {
                                                        'No'
                                                        'Yes'
                                                        }';
matlabbatch{83}.menu_cfg.menu_entry.conf_menu.values = {
                                                        false
                                                        true
                                                        }';
matlabbatch{83}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{83}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{83}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{84}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{84}.menu_cfg.menu_struct.conf_branch.name = 'Respiratory';
matlabbatch{84}.menu_cfg.menu_struct.conf_branch.tag = 'resp';
matlabbatch{84}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{84}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{84}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{84}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Files: Data file (cfg_files)';
matlabbatch{84}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{81}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{84}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{84}.menu_cfg.menu_struct.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{84}.menu_cfg.menu_struct.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{84}.menu_cfg.menu_struct.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{84}.menu_cfg.menu_struct.conf_branch.val{2}(1).sname = 'Entry: Bandwidth (cfg_entry)';
matlabbatch{84}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{82}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{84}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{84}.menu_cfg.menu_struct.conf_branch.val{3}(1) = cfg_dep;
matlabbatch{84}.menu_cfg.menu_struct.conf_branch.val{3}(1).tname = 'Val Item';
matlabbatch{84}.menu_cfg.menu_struct.conf_branch.val{3}(1).tgt_spec = {};
matlabbatch{84}.menu_cfg.menu_struct.conf_branch.val{3}(1).sname = 'Menu: Flip sign of signal (cfg_menu)';
matlabbatch{84}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_exbranch = substruct('.','val', '{}',{83}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{84}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{84}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{84}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{85}.menu_cfg.menu_entry.conf_files.type = 'cfg_files';
matlabbatch{85}.menu_cfg.menu_entry.conf_files.name = 'Data file';
matlabbatch{85}.menu_cfg.menu_entry.conf_files.tag = 'datafile';
matlabbatch{85}.menu_cfg.menu_entry.conf_files.filter = 'any';
matlabbatch{85}.menu_cfg.menu_entry.conf_files.ufilter = '.*';
matlabbatch{85}.menu_cfg.menu_entry.conf_files.dir = [];
matlabbatch{85}.menu_cfg.menu_entry.conf_files.num = [1 1];
matlabbatch{85}.menu_cfg.menu_entry.conf_files.check = [];
matlabbatch{85}.menu_cfg.menu_entry.conf_files.help = {};
matlabbatch{85}.menu_cfg.menu_entry.conf_files.def = [];
matlabbatch{86}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{86}.menu_cfg.menu_entry.conf_entry.name = 'Bandwidth';
matlabbatch{86}.menu_cfg.menu_entry.conf_entry.tag = 'bandwidth';
matlabbatch{86}.menu_cfg.menu_entry.conf_entry.strtype = 'r';
matlabbatch{86}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{86}.menu_cfg.menu_entry.conf_entry.num = [1 1];
matlabbatch{86}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{86}.menu_cfg.menu_entry.conf_entry.help = {};
matlabbatch{86}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{87}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{87}.menu_cfg.menu_entry.conf_menu.name = 'Flip sign of signal';
matlabbatch{87}.menu_cfg.menu_entry.conf_menu.tag = 'flip';
matlabbatch{87}.menu_cfg.menu_entry.conf_menu.labels = {
                                                        'No'
                                                        'Yes'
                                                        }';
matlabbatch{87}.menu_cfg.menu_entry.conf_menu.values = {
                                                        false
                                                        true
                                                        }';
matlabbatch{87}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{87}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{87}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{88}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{88}.menu_cfg.menu_struct.conf_branch.name = 'Pulse';
matlabbatch{88}.menu_cfg.menu_struct.conf_branch.tag = 'pulse';
matlabbatch{88}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{88}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{88}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{88}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Files: Data file (cfg_files)';
matlabbatch{88}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{85}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{88}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{88}.menu_cfg.menu_struct.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{88}.menu_cfg.menu_struct.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{88}.menu_cfg.menu_struct.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{88}.menu_cfg.menu_struct.conf_branch.val{2}(1).sname = 'Entry: Bandwidth (cfg_entry)';
matlabbatch{88}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{86}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{88}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{88}.menu_cfg.menu_struct.conf_branch.val{3}(1) = cfg_dep;
matlabbatch{88}.menu_cfg.menu_struct.conf_branch.val{3}(1).tname = 'Val Item';
matlabbatch{88}.menu_cfg.menu_struct.conf_branch.val{3}(1).tgt_spec = {};
matlabbatch{88}.menu_cfg.menu_struct.conf_branch.val{3}(1).sname = 'Menu: Flip sign of signal (cfg_menu)';
matlabbatch{88}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_exbranch = substruct('.','val', '{}',{87}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{88}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{88}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{88}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{89}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{89}.menu_cfg.menu_entry.conf_menu.name = 'Correction type';
matlabbatch{89}.menu_cfg.menu_entry.conf_menu.tag = 'corr';
matlabbatch{89}.menu_cfg.menu_entry.conf_menu.labels = {
                                                        'Global (Resp histogram)'
                                                        'Both global'
                                                        'Global (Resp cyclic)'
                                                        'Both cyclic'
                                                        }';
matlabbatch{89}.menu_cfg.menu_entry.conf_menu.values = {
                                                        -1
                                                        0
                                                        1
                                                        2
                                                        }';
matlabbatch{89}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{89}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{89}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{90}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{90}.menu_cfg.menu_struct.conf_branch.name = 'Pulse+Respiratory';
matlabbatch{90}.menu_cfg.menu_struct.conf_branch.tag = 'pulseresp';
matlabbatch{90}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{90}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{90}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{90}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Branch: Pulse (cfg_branch)';
matlabbatch{90}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{88}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{90}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{90}.menu_cfg.menu_struct.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{90}.menu_cfg.menu_struct.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{90}.menu_cfg.menu_struct.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{90}.menu_cfg.menu_struct.conf_branch.val{2}(1).sname = 'Branch: Respiratory (cfg_branch)';
matlabbatch{90}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{84}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{90}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{90}.menu_cfg.menu_struct.conf_branch.val{3}(1) = cfg_dep;
matlabbatch{90}.menu_cfg.menu_struct.conf_branch.val{3}(1).tname = 'Val Item';
matlabbatch{90}.menu_cfg.menu_struct.conf_branch.val{3}(1).tgt_spec = {};
matlabbatch{90}.menu_cfg.menu_struct.conf_branch.val{3}(1).sname = 'Menu: Correction type (cfg_menu)';
matlabbatch{90}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_exbranch = substruct('.','val', '{}',{89}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{90}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{90}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{90}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.type = 'cfg_choice';
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.name = 'Data for correction';
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.tag = 'which';
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{1}(1) = cfg_dep;
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{1}(1).tname = 'Values Item';
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{1}(1).tgt_spec = {};
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{1}(1).sname = 'Branch: Cardiac (cfg_branch)';
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{1}(1).src_exbranch = substruct('.','val', '{}',{36}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{1}(1).src_output = substruct('()',{1});
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{2}(1) = cfg_dep;
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{2}(1).tname = 'Values Item';
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{2}(1).tgt_spec = {};
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{2}(1).sname = 'Branch: Respiratory (cfg_branch)';
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{2}(1).src_exbranch = substruct('.','val', '{}',{42}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{2}(1).src_output = substruct('()',{1});
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{3}(1) = cfg_dep;
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{3}(1).tname = 'Values Item';
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{3}(1).tgt_spec = {};
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{3}(1).sname = 'Branch: Pulse (cfg_branch)';
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{3}(1).src_exbranch = substruct('.','val', '{}',{48}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{3}(1).src_output = substruct('()',{1});
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{4}(1) = cfg_dep;
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{4}(1).tname = 'Values Item';
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{4}(1).tgt_spec = {};
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{4}(1).sname = 'Branch: Respiratory+Cardiac (cfg_branch)';
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{4}(1).src_exbranch = substruct('.','val', '{}',{59}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{4}(1).src_output = substruct('()',{1});
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{5}(1) = cfg_dep;
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{5}(1).tname = 'Values Item';
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{5}(1).tgt_spec = {};
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{5}(1).sname = 'Branch: Cardiac+Respiratory (cfg_branch)';
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{5}(1).src_exbranch = substruct('.','val', '{}',{70}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{5}(1).src_output = substruct('()',{1});
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{6}(1) = cfg_dep;
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{6}(1).tname = 'Values Item';
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{6}(1).tgt_spec = {};
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{6}(1).sname = 'Branch: Respiratory+Pulse (cfg_branch)';
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{6}(1).src_exbranch = substruct('.','val', '{}',{80}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{6}(1).src_output = substruct('()',{1});
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{7}(1) = cfg_dep;
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{7}(1).tname = 'Values Item';
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{7}(1).tgt_spec = {};
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{7}(1).sname = 'Branch: Pulse+Respiratory (cfg_branch)';
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{7}(1).src_exbranch = substruct('.','val', '{}',{90}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.values{7}(1).src_output = substruct('()',{1});
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.check = [];
matlabbatch{91}.menu_cfg.menu_struct.conf_choice.help = {};
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.type = 'cfg_exbranch';
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.name = 'Estimate Phases and Cycles';
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.tag = 'corr_phases_and_cycles';
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{1}(1) = cfg_dep;
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).tname = 'Val Item';
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).tgt_spec = {};
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).sname = 'Entry: Number of Scans (cfg_entry)';
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).src_exbranch = substruct('.','val', '{}',{24}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{2}(1) = cfg_dep;
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).tname = 'Val Item';
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).tgt_spec = {};
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).sname = 'Entry: Number of Slices (cfg_entry)';
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).src_exbranch = substruct('.','val', '{}',{25}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{3}(1) = cfg_dep;
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).tname = 'Val Item';
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).tgt_spec = {};
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).sname = 'Entry: TR (cfg_entry)';
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).src_exbranch = substruct('.','val', '{}',{27}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{4}(1) = cfg_dep;
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{4}(1).tname = 'Val Item';
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{4}(1).tgt_spec = {};
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{4}(1).sname = 'Entry: #Dummy scans (cfg_entry)';
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{4}(1).src_exbranch = substruct('.','val', '{}',{28}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{4}(1).src_output = substruct('()',{1});
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{5}(1) = cfg_dep;
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{5}(1).tname = 'Val Item';
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{5}(1).tgt_spec = {};
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{5}(1).sname = 'Choice: Data for correction (cfg_choice)';
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{5}(1).src_exbranch = substruct('.','val', '{}',{91}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.val{5}(1).src_output = substruct('()',{1});
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.prog = @(job)run_phases_and_cycles('run',job);
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.vout = @(job)run_phases_and_cycles('vout',job);
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.check = [];
matlabbatch{92}.menu_cfg.menu_struct.conf_exbranch.help = {};
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.type = 'cfg_exbranch';
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.name = 'Apply Correction';
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.tag = 'corr_correction';
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{1}(1) = cfg_dep;
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).tname = 'Val Item';
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).tgt_spec = {};
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).sname = 'Files: Image Time Series (cfg_files)';
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).src_exbranch = substruct('.','val', '{}',{26}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{2}(1) = cfg_dep;
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).tname = 'Val Item';
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).tgt_spec = {};
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).sname = 'Entry: TR (cfg_entry)';
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).src_exbranch = substruct('.','val', '{}',{27}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{3}(1) = cfg_dep;
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).tname = 'Val Item';
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).tgt_spec = {};
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).sname = 'Entry: #Dummy scans (cfg_entry)';
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).src_exbranch = substruct('.','val', '{}',{28}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{4}(1) = cfg_dep;
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{4}(1).tname = 'Val Item';
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{4}(1).tgt_spec = {};
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{4}(1).sname = 'Entry: Slice order (cfg_entry)';
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{4}(1).src_exbranch = substruct('.','val', '{}',{29}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{4}(1).src_output = substruct('()',{1});
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{5}(1) = cfg_dep;
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{5}(1).tname = 'Val Item';
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{5}(1).tgt_spec = {};
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{5}(1).sname = 'Choice: Correction Data (cfg_choice)';
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{5}(1).src_exbranch = substruct('.','val', '{}',{20}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{5}(1).src_output = substruct('()',{1});
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{6}(1) = cfg_dep;
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{6}(1).tname = 'Val Item';
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{6}(1).tgt_spec = {};
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{6}(1).sname = 'Menu: Fit Method (cfg_menu)';
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{6}(1).src_exbranch = substruct('.','val', '{}',{21}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{6}(1).src_output = substruct('()',{1});
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{7}(1) = cfg_dep;
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{7}(1).tname = 'Val Item';
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{7}(1).tgt_spec = {};
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{7}(1).sname = 'Menu: Fit Order (cfg_menu)';
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{7}(1).src_exbranch = substruct('.','val', '{}',{22}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{7}(1).src_output = substruct('()',{1});
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{8}(1) = cfg_dep;
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{8}(1).tname = 'Val Item';
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{8}(1).tgt_spec = {};
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{8}(1).sname = 'Entry: Prefix (cfg_entry)';
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{8}(1).src_exbranch = substruct('.','val', '{}',{23}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.val{8}(1).src_output = substruct('()',{1});
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.prog = @(job)run_correction('run',job);
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.vout = @(job)run_correction('vout',job);
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.check = [];
matlabbatch{93}.menu_cfg.menu_struct.conf_exbranch.help = {};
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.type = 'cfg_exbranch';
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.name = 'Estimate+Apply Correction';
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.tag = 'corr_est_apply';
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{1}(1) = cfg_dep;
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).tname = 'Val Item';
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).tgt_spec = {};
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).sname = 'Files: Image Time Series (cfg_files)';
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).src_exbranch = substruct('.','val', '{}',{26}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{2}(1) = cfg_dep;
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).tname = 'Val Item';
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).tgt_spec = {};
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).sname = 'Entry: TR (cfg_entry)';
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).src_exbranch = substruct('.','val', '{}',{27}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{3}(1) = cfg_dep;
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).tname = 'Val Item';
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).tgt_spec = {};
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).sname = 'Entry: #Dummy scans (cfg_entry)';
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).src_exbranch = substruct('.','val', '{}',{28}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{4}(1) = cfg_dep;
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{4}(1).tname = 'Val Item';
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{4}(1).tgt_spec = {};
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{4}(1).sname = 'Entry: Slice order (cfg_entry)';
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{4}(1).src_exbranch = substruct('.','val', '{}',{29}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{4}(1).src_output = substruct('()',{1});
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{5}(1) = cfg_dep;
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{5}(1).tname = 'Val Item';
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{5}(1).tgt_spec = {};
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{5}(1).sname = 'Choice: Data for correction (cfg_choice)';
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{5}(1).src_exbranch = substruct('.','val', '{}',{91}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{5}(1).src_output = substruct('()',{1});
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{6}(1) = cfg_dep;
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{6}(1).tname = 'Val Item';
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{6}(1).tgt_spec = {};
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{6}(1).sname = 'Menu: Fit Method (cfg_menu)';
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{6}(1).src_exbranch = substruct('.','val', '{}',{21}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{6}(1).src_output = substruct('()',{1});
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{7}(1) = cfg_dep;
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{7}(1).tname = 'Val Item';
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{7}(1).tgt_spec = {};
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{7}(1).sname = 'Menu: Fit Order (cfg_menu)';
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{7}(1).src_exbranch = substruct('.','val', '{}',{22}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{7}(1).src_output = substruct('()',{1});
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{8}(1) = cfg_dep;
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{8}(1).tname = 'Val Item';
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{8}(1).tgt_spec = {};
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{8}(1).sname = 'Entry: Prefix (cfg_entry)';
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{8}(1).src_exbranch = substruct('.','val', '{}',{23}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.val{8}(1).src_output = substruct('()',{1});
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.prog = @(job)run_est_apply('run',job);
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.vout = @(job)run_est_apply('vout',job);
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.check = [];
matlabbatch{94}.menu_cfg.menu_struct.conf_exbranch.help = {};
matlabbatch{95}.menu_cfg.menu_struct.conf_choice.type = 'cfg_choice';
matlabbatch{95}.menu_cfg.menu_struct.conf_choice.name = 'PhysioTool';
matlabbatch{95}.menu_cfg.menu_struct.conf_choice.tag = 'physiotool';
matlabbatch{95}.menu_cfg.menu_struct.conf_choice.values{1}(1) = cfg_dep;
matlabbatch{95}.menu_cfg.menu_struct.conf_choice.values{1}(1).tname = 'Values Item';
matlabbatch{95}.menu_cfg.menu_struct.conf_choice.values{1}(1).tgt_spec = {};
matlabbatch{95}.menu_cfg.menu_struct.conf_choice.values{1}(1).sname = 'Exbranch: Estimate Phases and Cycles (cfg_exbranch)';
matlabbatch{95}.menu_cfg.menu_struct.conf_choice.values{1}(1).src_exbranch = substruct('.','val', '{}',{92}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{95}.menu_cfg.menu_struct.conf_choice.values{1}(1).src_output = substruct('()',{1});
matlabbatch{95}.menu_cfg.menu_struct.conf_choice.values{2}(1) = cfg_dep;
matlabbatch{95}.menu_cfg.menu_struct.conf_choice.values{2}(1).tname = 'Values Item';
matlabbatch{95}.menu_cfg.menu_struct.conf_choice.values{2}(1).tgt_spec = {};
matlabbatch{95}.menu_cfg.menu_struct.conf_choice.values{2}(1).sname = 'Exbranch: Apply Correction (cfg_exbranch)';
matlabbatch{95}.menu_cfg.menu_struct.conf_choice.values{2}(1).src_exbranch = substruct('.','val', '{}',{93}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{95}.menu_cfg.menu_struct.conf_choice.values{2}(1).src_output = substruct('()',{1});
matlabbatch{95}.menu_cfg.menu_struct.conf_choice.values{3}(1) = cfg_dep;
matlabbatch{95}.menu_cfg.menu_struct.conf_choice.values{3}(1).tname = 'Values Item';
matlabbatch{95}.menu_cfg.menu_struct.conf_choice.values{3}(1).tgt_spec = {};
matlabbatch{95}.menu_cfg.menu_struct.conf_choice.values{3}(1).sname = 'Exbranch: Estimate+Apply Correction (cfg_exbranch)';
matlabbatch{95}.menu_cfg.menu_struct.conf_choice.values{3}(1).src_exbranch = substruct('.','val', '{}',{94}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{95}.menu_cfg.menu_struct.conf_choice.values{3}(1).src_output = substruct('()',{1});
matlabbatch{95}.menu_cfg.menu_struct.conf_choice.check = [];
matlabbatch{95}.menu_cfg.menu_struct.conf_choice.help = {};
matlabbatch{96}.menu_cfg.gencode_gen.gencode_fname = 'tbx_cfg_physio_tool.m';
matlabbatch{96}.menu_cfg.gencode_gen.gencode_dir = {'/export/spm-devel/spmphysiotools/trunk/toolbox/physiotools/'};
matlabbatch{96}.menu_cfg.gencode_gen.gencode_var(1) = cfg_dep;
matlabbatch{96}.menu_cfg.gencode_gen.gencode_var(1).tname = 'Root node of config';
matlabbatch{96}.menu_cfg.gencode_gen.gencode_var(1).tgt_spec = {};
matlabbatch{96}.menu_cfg.gencode_gen.gencode_var(1).sname = 'Choice: PhysioTool (cfg_choice)';
matlabbatch{96}.menu_cfg.gencode_gen.gencode_var(1).src_exbranch = substruct('.','val', '{}',{95}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{96}.menu_cfg.gencode_gen.gencode_var(1).src_output = substruct('()',{1});
matlabbatch{96}.menu_cfg.gencode_gen.gencode_opts.gencode_o_def = false;
matlabbatch{96}.menu_cfg.gencode_gen.gencode_opts.gencode_o_mlb = false;
matlabbatch{96}.menu_cfg.gencode_gen.gencode_opts.gencode_o_path = true;
