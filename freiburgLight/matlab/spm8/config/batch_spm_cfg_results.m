%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 217 $)
%-----------------------------------------------------------------------
matlabbatch{1}.menu_cfg.menu_entry.conf_files.type = 'cfg_files';
matlabbatch{1}.menu_cfg.menu_entry.conf_files.name = 'Select SPM.mat';
matlabbatch{1}.menu_cfg.menu_entry.conf_files.tag = 'spmmat';
matlabbatch{1}.menu_cfg.menu_entry.conf_files.filter = 'mat';
matlabbatch{1}.menu_cfg.menu_entry.conf_files.ufilter = '^SPM\.mat$';
matlabbatch{1}.menu_cfg.menu_entry.conf_files.dir = '';
matlabbatch{1}.menu_cfg.menu_entry.conf_files.num = [1 1];
matlabbatch{1}.menu_cfg.menu_entry.conf_files.check = [];
matlabbatch{1}.menu_cfg.menu_entry.conf_files.help = {'Select the SPM.mat file that contains the design specification.'};
matlabbatch{1}.menu_cfg.menu_entry.conf_files.def = [];
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.name = 'Results Title';
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.tag = 'titlestr';
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.strtype = 's';
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.num = [0 Inf];
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.help = {'Heading on results page - determined automatically if left empty'};
matlabbatch{2}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{3}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{3}.menu_cfg.menu_entry.conf_entry.name = 'Contrast(s)';
matlabbatch{3}.menu_cfg.menu_entry.conf_entry.tag = 'contrasts';
matlabbatch{3}.menu_cfg.menu_entry.conf_entry.strtype = 'n';
matlabbatch{3}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{3}.menu_cfg.menu_entry.conf_entry.num = [1 Inf];
matlabbatch{3}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{3}.menu_cfg.menu_entry.conf_entry.help = {
                                                      'Index of contrast(s). If more than one number is entered, analyse a conjunction hypothesis.'
                                                      'If only one number is entered, and this number is "Inf", then results are printed for all contrasts found in the SPM.mat file.'
                                                      }';
matlabbatch{3}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{4}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{4}.menu_cfg.menu_entry.conf_menu.name = 'Threshold type';
matlabbatch{4}.menu_cfg.menu_entry.conf_menu.tag = 'threshdesc';
matlabbatch{4}.menu_cfg.menu_entry.conf_menu.labels = {
                                                       'FWE'
                                                       'none'
                                                       }';
matlabbatch{4}.menu_cfg.menu_entry.conf_menu.values = {
                                                       'FWE'
                                                       'none'
                                                       }';
matlabbatch{4}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{4}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{4}.menu_cfg.menu_entry.conf_menu.def = @(val)spm_get_defaults('stats.results.threshtype',val{:});
matlabbatch{5}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{5}.menu_cfg.menu_entry.conf_entry.name = 'Threshold';
matlabbatch{5}.menu_cfg.menu_entry.conf_entry.tag = 'thresh';
matlabbatch{5}.menu_cfg.menu_entry.conf_entry.strtype = 'r';
matlabbatch{5}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{5}.menu_cfg.menu_entry.conf_entry.num = [1 1];
matlabbatch{5}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{5}.menu_cfg.menu_entry.conf_entry.help = {};
matlabbatch{5}.menu_cfg.menu_entry.conf_entry.def = @(val)spm_get_defaults('stats.results.thresh',val{:});
matlabbatch{6}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{6}.menu_cfg.menu_entry.conf_entry.name = 'Extent';
matlabbatch{6}.menu_cfg.menu_entry.conf_entry.tag = 'extent';
matlabbatch{6}.menu_cfg.menu_entry.conf_entry.strtype = 'w';
matlabbatch{6}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{6}.menu_cfg.menu_entry.conf_entry.num = [1 1];
matlabbatch{6}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{6}.menu_cfg.menu_entry.conf_entry.help = {};
matlabbatch{6}.menu_cfg.menu_entry.conf_entry.def = @(val)spm_get_defaults('stats.results.extent',val{:});
matlabbatch{7}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{7}.menu_cfg.menu_entry.conf_entry.name = 'Contrast(s) for Masking';
matlabbatch{7}.menu_cfg.menu_entry.conf_entry.tag = 'contrasts';
matlabbatch{7}.menu_cfg.menu_entry.conf_entry.strtype = 'n';
matlabbatch{7}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{7}.menu_cfg.menu_entry.conf_entry.num = [1 Inf];
matlabbatch{7}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{7}.menu_cfg.menu_entry.conf_entry.help = {'Index of contrast(s) for masking - leave empty for no masking.'};
matlabbatch{7}.menu_cfg.menu_entry.conf_entry.def = [];
matlabbatch{8}.menu_cfg.menu_entry.conf_entry.type = 'cfg_entry';
matlabbatch{8}.menu_cfg.menu_entry.conf_entry.name = 'Mask threshold';
matlabbatch{8}.menu_cfg.menu_entry.conf_entry.tag = 'thresh';
matlabbatch{8}.menu_cfg.menu_entry.conf_entry.strtype = 'r';
matlabbatch{8}.menu_cfg.menu_entry.conf_entry.extras = [];
matlabbatch{8}.menu_cfg.menu_entry.conf_entry.num = [1 1];
matlabbatch{8}.menu_cfg.menu_entry.conf_entry.check = [];
matlabbatch{8}.menu_cfg.menu_entry.conf_entry.help = {};
matlabbatch{8}.menu_cfg.menu_entry.conf_entry.def = @(val)spm_get_defaults('stats.results.maskthresh',val{:});
matlabbatch{9}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{9}.menu_cfg.menu_entry.conf_menu.name = 'Nature of mask';
matlabbatch{9}.menu_cfg.menu_entry.conf_menu.tag = 'mtype';
matlabbatch{9}.menu_cfg.menu_entry.conf_menu.labels = {
                                                       'Inclusive'
                                                       'Exclusive'
                                                       }';
matlabbatch{9}.menu_cfg.menu_entry.conf_menu.values = {
                                                       0
                                                       1
                                                       }';
matlabbatch{9}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{9}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{9}.menu_cfg.menu_entry.conf_menu.def = [];
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.name = 'Mask definition';
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.tag = 'mask';
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Entry: Contrast(s) for Masking (cfg_entry)';
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.val{2}(1).sname = 'Entry: Mask threshold (cfg_entry)';
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{8}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.val{3}(1) = cfg_dep;
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.val{3}(1).tname = 'Val Item';
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.val{3}(1).tgt_spec = {};
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.val{3}(1).sname = 'Menu: Nature of mask (cfg_menu)';
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_exbranch = substruct('.','val', '{}',{9}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{10}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{11}.menu_cfg.menu_struct.conf_repeat.type = 'cfg_repeat';
matlabbatch{11}.menu_cfg.menu_struct.conf_repeat.name = 'Masking';
matlabbatch{11}.menu_cfg.menu_struct.conf_repeat.tag = 'masking';
matlabbatch{11}.menu_cfg.menu_struct.conf_repeat.values{1}(1) = cfg_dep;
matlabbatch{11}.menu_cfg.menu_struct.conf_repeat.values{1}(1).tname = 'Values Item';
matlabbatch{11}.menu_cfg.menu_struct.conf_repeat.values{1}(1).tgt_spec = {};
matlabbatch{11}.menu_cfg.menu_struct.conf_repeat.values{1}(1).sname = 'Branch: Mask definition (cfg_branch)';
matlabbatch{11}.menu_cfg.menu_struct.conf_repeat.values{1}(1).src_exbranch = substruct('.','val', '{}',{10}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{11}.menu_cfg.menu_struct.conf_repeat.values{1}(1).src_output = substruct('()',{1});
matlabbatch{11}.menu_cfg.menu_struct.conf_repeat.num = [0 1];
matlabbatch{11}.menu_cfg.menu_struct.conf_repeat.forcestruct = false;
matlabbatch{11}.menu_cfg.menu_struct.conf_repeat.check = [];
matlabbatch{11}.menu_cfg.menu_struct.conf_repeat.help = {};
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.type = 'cfg_branch';
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.name = 'Contrast query';
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.tag = 'conspec';
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{1}(1).sname = 'Entry: Results Title (cfg_entry)';
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{2}(1).sname = 'Entry: Contrast(s) (cfg_entry)';
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{3}(1) = cfg_dep;
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{3}(1).tname = 'Val Item';
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{3}(1).tgt_spec = {};
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{3}(1).sname = 'Menu: Threshold type (cfg_menu)';
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_exbranch = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{4}(1) = cfg_dep;
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{4}(1).tname = 'Val Item';
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{4}(1).tgt_spec = {};
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{4}(1).sname = 'Entry: Threshold (cfg_entry)';
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{4}(1).src_exbranch = substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{4}(1).src_output = substruct('()',{1});
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{5}(1) = cfg_dep;
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{5}(1).tname = 'Val Item';
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{5}(1).tgt_spec = {};
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{5}(1).sname = 'Entry: Extent (cfg_entry)';
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{5}(1).src_exbranch = substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{5}(1).src_output = substruct('()',{1});
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{6}(1) = cfg_dep;
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{6}(1).tname = 'Val Item';
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{6}(1).tgt_spec = {};
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{6}(1).sname = 'Repeat: Masking (cfg_repeat)';
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{6}(1).src_exbranch = substruct('.','val', '{}',{11}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.val{6}(1).src_output = substruct('()',{1});
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.check = [];
matlabbatch{12}.menu_cfg.menu_struct.conf_branch.help = {};
matlabbatch{13}.menu_cfg.menu_struct.conf_repeat.type = 'cfg_repeat';
matlabbatch{13}.menu_cfg.menu_struct.conf_repeat.name = 'Contrasts';
matlabbatch{13}.menu_cfg.menu_struct.conf_repeat.tag = 'contrasts';
matlabbatch{13}.menu_cfg.menu_struct.conf_repeat.values{1}(1) = cfg_dep;
matlabbatch{13}.menu_cfg.menu_struct.conf_repeat.values{1}(1).tname = 'Values Item';
matlabbatch{13}.menu_cfg.menu_struct.conf_repeat.values{1}(1).tgt_spec = {};
matlabbatch{13}.menu_cfg.menu_struct.conf_repeat.values{1}(1).sname = 'Branch: Contrast query (cfg_branch)';
matlabbatch{13}.menu_cfg.menu_struct.conf_repeat.values{1}(1).src_exbranch = substruct('.','val', '{}',{12}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{13}.menu_cfg.menu_struct.conf_repeat.values{1}(1).src_output = substruct('()',{1});
matlabbatch{13}.menu_cfg.menu_struct.conf_repeat.num = [1 Inf];
matlabbatch{13}.menu_cfg.menu_struct.conf_repeat.forcestruct = false;
matlabbatch{13}.menu_cfg.menu_struct.conf_repeat.check = [];
matlabbatch{13}.menu_cfg.menu_struct.conf_repeat.help = {};
matlabbatch{14}.menu_cfg.menu_entry.conf_menu.type = 'cfg_menu';
matlabbatch{14}.menu_cfg.menu_entry.conf_menu.name = 'Print results';
matlabbatch{14}.menu_cfg.menu_entry.conf_menu.tag = 'print';
matlabbatch{14}.menu_cfg.menu_entry.conf_menu.labels = {
                                                        'Yes'
                                                        'No'
                                                        }';
matlabbatch{14}.menu_cfg.menu_entry.conf_menu.values = {
                                                        true
                                                        false
                                                        }';
matlabbatch{14}.menu_cfg.menu_entry.conf_menu.check = [];
matlabbatch{14}.menu_cfg.menu_entry.conf_menu.help = {};
matlabbatch{14}.menu_cfg.menu_entry.conf_menu.def = @(val)spm_get_defaults('stats.results.print',val{:});
matlabbatch{15}.menu_cfg.menu_struct.conf_exbranch.type = 'cfg_exbranch';
matlabbatch{15}.menu_cfg.menu_struct.conf_exbranch.name = 'Results Report';
matlabbatch{15}.menu_cfg.menu_struct.conf_exbranch.tag = 'results';
matlabbatch{15}.menu_cfg.menu_struct.conf_exbranch.val{1}(1) = cfg_dep;
matlabbatch{15}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).tname = 'Val Item';
matlabbatch{15}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).tgt_spec = {};
matlabbatch{15}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).sname = 'Files: Select SPM.mat (cfg_files)';
matlabbatch{15}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{15}.menu_cfg.menu_struct.conf_exbranch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{15}.menu_cfg.menu_struct.conf_exbranch.val{2}(1) = cfg_dep;
matlabbatch{15}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).tname = 'Val Item';
matlabbatch{15}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).tgt_spec = {};
matlabbatch{15}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).sname = 'Repeat: Contrasts (cfg_repeat)';
matlabbatch{15}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).src_exbranch = substruct('.','val', '{}',{13}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{15}.menu_cfg.menu_struct.conf_exbranch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{15}.menu_cfg.menu_struct.conf_exbranch.val{3}(1) = cfg_dep;
matlabbatch{15}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).tname = 'Val Item';
matlabbatch{15}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).tgt_spec = {};
matlabbatch{15}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).sname = 'Menu: Print results (cfg_menu)';
matlabbatch{15}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).src_exbranch = substruct('.','val', '{}',{14}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{15}.menu_cfg.menu_struct.conf_exbranch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{15}.menu_cfg.menu_struct.conf_exbranch.prog = @spm_run_results;
matlabbatch{15}.menu_cfg.menu_struct.conf_exbranch.vout = [];
matlabbatch{15}.menu_cfg.menu_struct.conf_exbranch.check = [];
matlabbatch{15}.menu_cfg.menu_struct.conf_exbranch.help = {};
