function physiotool = tbx_cfg_physio_tool
% 'PhysioTool' - MATLABBATCH configuration
% This MATLABBATCH configuration file has been generated automatically
% by MATLABBATCH using ConfGUI. It describes menu structure, validity
% constraints and links to run time code.
% Changes to this file will be overwritten if the ConfGUI batch is executed again.
% Created at 2009-07-31 09:14:32.
% ---------------------------------------------------------------------
% nscans Number of Scans
% ---------------------------------------------------------------------
nscans         = cfg_entry;
nscans.tag     = 'nscans';
nscans.name    = 'Number of Scans';
nscans.help    = {'Enter the number of scans in your time series.'};
nscans.strtype = 'n';
nscans.num     = [1  1];
% ---------------------------------------------------------------------
% nslices Number of Slices
% ---------------------------------------------------------------------
nslices         = cfg_entry;
nslices.tag     = 'nslices';
nslices.name    = 'Number of Slices';
nslices.help    = {'Enter the number of slices per scan. All scans in a time series are supposed to have the same number of slices.'};
nslices.strtype = 'n';
nslices.num     = [1  1];
% ---------------------------------------------------------------------
% TR TR
% ---------------------------------------------------------------------
TR         = cfg_entry;
TR.tag     = 'TR';
TR.name    = 'TR';
TR.help    = {'The TR of your experiment. Note that this function assumes that the scans are acquired without any "silent" periods between scans.'};
TR.strtype = 'r';
TR.num     = [1  1];
% ---------------------------------------------------------------------
% ndummy #Dummy scans
% ---------------------------------------------------------------------
ndummy         = cfg_entry;
ndummy.tag     = 'ndummy';
ndummy.name    = '#Dummy scans';
ndummy.help    = {'Enter the number of dummy scans that were acquired before the start of the image time series.'};
ndummy.strtype = 'w';
ndummy.num     = [1  1];
% ---------------------------------------------------------------------
% datafile Data file
% ---------------------------------------------------------------------
datafile         = cfg_files;
datafile.tag     = 'datafile';
datafile.name    = 'Data file';
datafile.filter = 'any';
datafile.ufilter = '.*';
datafile.num     = [1 1];
% ---------------------------------------------------------------------
% bandwidth Bandwidth
% ---------------------------------------------------------------------
bandwidth         = cfg_entry;
bandwidth.tag     = 'bandwidth';
bandwidth.name    = 'Bandwidth';
bandwidth.strtype = 'r';
bandwidth.num     = [1  1];
% ---------------------------------------------------------------------
% flip Flip sign of signal
% ---------------------------------------------------------------------
flip         = cfg_menu;
flip.tag     = 'flip';
flip.name    = 'Flip sign of signal';
flip.labels = {
               'No'
               'Yes'
               }';
flip.values = {
               false
               true
               }';
% ---------------------------------------------------------------------
% channel Channel
% ---------------------------------------------------------------------
channel         = cfg_entry;
channel.tag     = 'channel';
channel.name    = 'Channel';
channel.strtype = 'n';
channel.num     = [1  1];
% ---------------------------------------------------------------------
% cardiac Cardiac
% ---------------------------------------------------------------------
cardiac1         = cfg_branch;
cardiac1.tag     = 'cardiac';
cardiac1.name    = 'Cardiac';
cardiac1.val     = {datafile bandwidth flip channel };
% ---------------------------------------------------------------------
% corr Correction type
% ---------------------------------------------------------------------
corr         = cfg_menu;
corr.tag     = 'corr';
corr.name    = 'Correction type';
corr.labels = {
               'Global'
               'Cyclic'
               }';
corr.values = {
               0
               1
               }';
% ---------------------------------------------------------------------
% cardiac Cardiac
% ---------------------------------------------------------------------
cardiac         = cfg_branch;
cardiac.tag     = 'cardiac';
cardiac.name    = 'Cardiac';
cardiac.val     = {cardiac1 corr };
% ---------------------------------------------------------------------
% datafile Data file
% ---------------------------------------------------------------------
datafile         = cfg_files;
datafile.tag     = 'datafile';
datafile.name    = 'Data file';
datafile.filter = 'any';
datafile.ufilter = '.*';
datafile.num     = [1 1];
% ---------------------------------------------------------------------
% bandwidth Bandwidth
% ---------------------------------------------------------------------
bandwidth         = cfg_entry;
bandwidth.tag     = 'bandwidth';
bandwidth.name    = 'Bandwidth';
bandwidth.strtype = 'r';
bandwidth.num     = [1  1];
% ---------------------------------------------------------------------
% flip Flip sign of signal
% ---------------------------------------------------------------------
flip         = cfg_menu;
flip.tag     = 'flip';
flip.name    = 'Flip sign of signal';
flip.labels = {
               'No'
               'Yes'
               }';
flip.values = {
               false
               true
               }';
% ---------------------------------------------------------------------
% resp Respiratory
% ---------------------------------------------------------------------
resp1         = cfg_branch;
resp1.tag     = 'resp';
resp1.name    = 'Respiratory';
resp1.val     = {datafile bandwidth flip };
% ---------------------------------------------------------------------
% corr Correction type
% ---------------------------------------------------------------------
corr         = cfg_menu;
corr.tag     = 'corr';
corr.name    = 'Correction type';
corr.labels = {
               'Global (histogram)'
               'Global'
               'Cyclic'
               }';
corr.values = {
               -1
               0
               1
               }';
% ---------------------------------------------------------------------
% resp Respiratory
% ---------------------------------------------------------------------
resp         = cfg_branch;
resp.tag     = 'resp';
resp.name    = 'Respiratory';
resp.val     = {resp1 corr };
% ---------------------------------------------------------------------
% datafile Data file
% ---------------------------------------------------------------------
datafile         = cfg_files;
datafile.tag     = 'datafile';
datafile.name    = 'Data file';
datafile.filter = 'any';
datafile.ufilter = '.*';
datafile.num     = [1 1];
% ---------------------------------------------------------------------
% bandwidth Bandwidth
% ---------------------------------------------------------------------
bandwidth         = cfg_entry;
bandwidth.tag     = 'bandwidth';
bandwidth.name    = 'Bandwidth';
bandwidth.strtype = 'r';
bandwidth.num     = [1  1];
% ---------------------------------------------------------------------
% flip Flip sign of signal
% ---------------------------------------------------------------------
flip         = cfg_menu;
flip.tag     = 'flip';
flip.name    = 'Flip sign of signal';
flip.labels = {
               'No'
               'Yes'
               }';
flip.values = {
               false
               true
               }';
% ---------------------------------------------------------------------
% pulse Pulse
% ---------------------------------------------------------------------
pulse1         = cfg_branch;
pulse1.tag     = 'pulse';
pulse1.name    = 'Pulse';
pulse1.val     = {datafile bandwidth flip };
% ---------------------------------------------------------------------
% corr Correction type
% ---------------------------------------------------------------------
corr         = cfg_menu;
corr.tag     = 'corr';
corr.name    = 'Correction type';
corr.labels = {
               'Global'
               'Cyclic'
               }';
corr.values = {
               0
               1
               }';
% ---------------------------------------------------------------------
% pulse Pulse
% ---------------------------------------------------------------------
pulse         = cfg_branch;
pulse.tag     = 'pulse';
pulse.name    = 'Pulse';
pulse.val     = {pulse1 corr };
% ---------------------------------------------------------------------
% datafile Data file
% ---------------------------------------------------------------------
datafile         = cfg_files;
datafile.tag     = 'datafile';
datafile.name    = 'Data file';
datafile.filter = 'any';
datafile.ufilter = '.*';
datafile.num     = [1 1];
% ---------------------------------------------------------------------
% bandwidth Bandwidth
% ---------------------------------------------------------------------
bandwidth         = cfg_entry;
bandwidth.tag     = 'bandwidth';
bandwidth.name    = 'Bandwidth';
bandwidth.strtype = 'r';
bandwidth.num     = [1  1];
% ---------------------------------------------------------------------
% flip Flip sign of signal
% ---------------------------------------------------------------------
flip         = cfg_menu;
flip.tag     = 'flip';
flip.name    = 'Flip sign of signal';
flip.labels = {
               'No'
               'Yes'
               }';
flip.values = {
               false
               true
               }';
% ---------------------------------------------------------------------
% resp Respiratory
% ---------------------------------------------------------------------
resp1         = cfg_branch;
resp1.tag     = 'resp';
resp1.name    = 'Respiratory';
resp1.val     = {datafile bandwidth flip };
% ---------------------------------------------------------------------
% datafile Data file
% ---------------------------------------------------------------------
datafile         = cfg_files;
datafile.tag     = 'datafile';
datafile.name    = 'Data file';
datafile.filter = 'any';
datafile.ufilter = '.*';
datafile.num     = [1 1];
% ---------------------------------------------------------------------
% bandwidth Bandwidth
% ---------------------------------------------------------------------
bandwidth         = cfg_entry;
bandwidth.tag     = 'bandwidth';
bandwidth.name    = 'Bandwidth';
bandwidth.strtype = 'r';
bandwidth.num     = [1  1];
% ---------------------------------------------------------------------
% flip Flip sign of signal
% ---------------------------------------------------------------------
flip         = cfg_menu;
flip.tag     = 'flip';
flip.name    = 'Flip sign of signal';
flip.labels = {
               'No'
               'Yes'
               }';
flip.values = {
               false
               true
               }';
% ---------------------------------------------------------------------
% channel Channel
% ---------------------------------------------------------------------
channel         = cfg_entry;
channel.tag     = 'channel';
channel.name    = 'Channel';
channel.strtype = 'n';
channel.num     = [1  1];
% ---------------------------------------------------------------------
% cardiac Cardiac
% ---------------------------------------------------------------------
cardiac1         = cfg_branch;
cardiac1.tag     = 'cardiac';
cardiac1.name    = 'Cardiac';
cardiac1.val     = {datafile bandwidth flip channel };
% ---------------------------------------------------------------------
% corr Correction type
% ---------------------------------------------------------------------
corr         = cfg_menu;
corr.tag     = 'corr';
corr.name    = 'Correction type';
corr.labels = {
               'Global (Resp histogram)'
               'Both global'
               'Global (Resp cyclic)'
               'Both cyclic'
               }';
corr.values = {
               -1
               0
               1
               2
               }';
% ---------------------------------------------------------------------
% respcard Respiratory+Cardiac
% ---------------------------------------------------------------------
respcard         = cfg_branch;
respcard.tag     = 'respcard';
respcard.name    = 'Respiratory+Cardiac';
respcard.val     = {resp1 cardiac1 corr };
% ---------------------------------------------------------------------
% datafile Data file
% ---------------------------------------------------------------------
datafile         = cfg_files;
datafile.tag     = 'datafile';
datafile.name    = 'Data file';
datafile.filter = 'any';
datafile.ufilter = '.*';
datafile.num     = [1 1];
% ---------------------------------------------------------------------
% bandwidth Bandwidth
% ---------------------------------------------------------------------
bandwidth         = cfg_entry;
bandwidth.tag     = 'bandwidth';
bandwidth.name    = 'Bandwidth';
bandwidth.strtype = 'r';
bandwidth.num     = [1  1];
% ---------------------------------------------------------------------
% flip Flip sign of signal
% ---------------------------------------------------------------------
flip         = cfg_menu;
flip.tag     = 'flip';
flip.name    = 'Flip sign of signal';
flip.labels = {
               'No'
               'Yes'
               }';
flip.values = {
               false
               true
               }';
% ---------------------------------------------------------------------
% channel Channel
% ---------------------------------------------------------------------
channel         = cfg_entry;
channel.tag     = 'channel';
channel.name    = 'Channel';
channel.strtype = 'n';
channel.num     = [1  1];
% ---------------------------------------------------------------------
% cardiac Cardiac
% ---------------------------------------------------------------------
cardiac1         = cfg_branch;
cardiac1.tag     = 'cardiac';
cardiac1.name    = 'Cardiac';
cardiac1.val     = {datafile bandwidth flip channel };
% ---------------------------------------------------------------------
% datafile Data file
% ---------------------------------------------------------------------
datafile         = cfg_files;
datafile.tag     = 'datafile';
datafile.name    = 'Data file';
datafile.filter = 'any';
datafile.ufilter = '.*';
datafile.num     = [1 1];
% ---------------------------------------------------------------------
% bandwidth Bandwidth
% ---------------------------------------------------------------------
bandwidth         = cfg_entry;
bandwidth.tag     = 'bandwidth';
bandwidth.name    = 'Bandwidth';
bandwidth.strtype = 'r';
bandwidth.num     = [1  1];
% ---------------------------------------------------------------------
% flip Flip sign of signal
% ---------------------------------------------------------------------
flip         = cfg_menu;
flip.tag     = 'flip';
flip.name    = 'Flip sign of signal';
flip.labels = {
               'No'
               'Yes'
               }';
flip.values = {
               false
               true
               }';
% ---------------------------------------------------------------------
% resp Respiratory
% ---------------------------------------------------------------------
resp1         = cfg_branch;
resp1.tag     = 'resp';
resp1.name    = 'Respiratory';
resp1.val     = {datafile bandwidth flip };
% ---------------------------------------------------------------------
% corr Correction type
% ---------------------------------------------------------------------
corr         = cfg_menu;
corr.tag     = 'corr';
corr.name    = 'Correction type';
corr.labels = {
               'Global (Resp histogram)'
               'Both global'
               'Global (Resp cyclic)'
               'Both cyclic'
               }';
corr.values = {
               -1
               0
               1
               2
               }';
% ---------------------------------------------------------------------
% cardresp Cardiac+Respiratory
% ---------------------------------------------------------------------
cardresp         = cfg_branch;
cardresp.tag     = 'cardresp';
cardresp.name    = 'Cardiac+Respiratory';
cardresp.val     = {cardiac1 resp1 corr };
% ---------------------------------------------------------------------
% datafile Data file
% ---------------------------------------------------------------------
datafile         = cfg_files;
datafile.tag     = 'datafile';
datafile.name    = 'Data file';
datafile.filter = 'any';
datafile.ufilter = '.*';
datafile.num     = [1 1];
% ---------------------------------------------------------------------
% bandwidth Bandwidth
% ---------------------------------------------------------------------
bandwidth         = cfg_entry;
bandwidth.tag     = 'bandwidth';
bandwidth.name    = 'Bandwidth';
bandwidth.strtype = 'r';
bandwidth.num     = [1  1];
% ---------------------------------------------------------------------
% flip Flip sign of signal
% ---------------------------------------------------------------------
flip         = cfg_menu;
flip.tag     = 'flip';
flip.name    = 'Flip sign of signal';
flip.labels = {
               'No'
               'Yes'
               }';
flip.values = {
               false
               true
               }';
% ---------------------------------------------------------------------
% resp Respiratory
% ---------------------------------------------------------------------
resp1         = cfg_branch;
resp1.tag     = 'resp';
resp1.name    = 'Respiratory';
resp1.val     = {datafile bandwidth flip };
% ---------------------------------------------------------------------
% datafile Data file
% ---------------------------------------------------------------------
datafile         = cfg_files;
datafile.tag     = 'datafile';
datafile.name    = 'Data file';
datafile.filter = 'any';
datafile.ufilter = '.*';
datafile.num     = [1 1];
% ---------------------------------------------------------------------
% bandwidth Bandwidth
% ---------------------------------------------------------------------
bandwidth         = cfg_entry;
bandwidth.tag     = 'bandwidth';
bandwidth.name    = 'Bandwidth';
bandwidth.strtype = 'r';
bandwidth.num     = [1  1];
% ---------------------------------------------------------------------
% flip Flip sign of signal
% ---------------------------------------------------------------------
flip         = cfg_menu;
flip.tag     = 'flip';
flip.name    = 'Flip sign of signal';
flip.labels = {
               'No'
               'Yes'
               }';
flip.values = {
               false
               true
               }';
% ---------------------------------------------------------------------
% pulse Pulse
% ---------------------------------------------------------------------
pulse1         = cfg_branch;
pulse1.tag     = 'pulse';
pulse1.name    = 'Pulse';
pulse1.val     = {datafile bandwidth flip };
% ---------------------------------------------------------------------
% corr Correction type
% ---------------------------------------------------------------------
corr         = cfg_menu;
corr.tag     = 'corr';
corr.name    = 'Correction type';
corr.labels = {
               'Global (Resp histogram)'
               'Both global'
               'Global (Resp cyclic)'
               'Both cyclic'
               }';
corr.values = {
               -1
               0
               1
               2
               }';
% ---------------------------------------------------------------------
% resppulse Respiratory+Pulse
% ---------------------------------------------------------------------
resppulse         = cfg_branch;
resppulse.tag     = 'resppulse';
resppulse.name    = 'Respiratory+Pulse';
resppulse.val     = {resp1 pulse1 corr };
% ---------------------------------------------------------------------
% datafile Data file
% ---------------------------------------------------------------------
datafile         = cfg_files;
datafile.tag     = 'datafile';
datafile.name    = 'Data file';
datafile.filter = 'any';
datafile.ufilter = '.*';
datafile.num     = [1 1];
% ---------------------------------------------------------------------
% bandwidth Bandwidth
% ---------------------------------------------------------------------
bandwidth         = cfg_entry;
bandwidth.tag     = 'bandwidth';
bandwidth.name    = 'Bandwidth';
bandwidth.strtype = 'r';
bandwidth.num     = [1  1];
% ---------------------------------------------------------------------
% flip Flip sign of signal
% ---------------------------------------------------------------------
flip         = cfg_menu;
flip.tag     = 'flip';
flip.name    = 'Flip sign of signal';
flip.labels = {
               'No'
               'Yes'
               }';
flip.values = {
               false
               true
               }';
% ---------------------------------------------------------------------
% pulse Pulse
% ---------------------------------------------------------------------
pulse1         = cfg_branch;
pulse1.tag     = 'pulse';
pulse1.name    = 'Pulse';
pulse1.val     = {datafile bandwidth flip };
% ---------------------------------------------------------------------
% datafile Data file
% ---------------------------------------------------------------------
datafile         = cfg_files;
datafile.tag     = 'datafile';
datafile.name    = 'Data file';
datafile.filter = 'any';
datafile.ufilter = '.*';
datafile.num     = [1 1];
% ---------------------------------------------------------------------
% bandwidth Bandwidth
% ---------------------------------------------------------------------
bandwidth         = cfg_entry;
bandwidth.tag     = 'bandwidth';
bandwidth.name    = 'Bandwidth';
bandwidth.strtype = 'r';
bandwidth.num     = [1  1];
% ---------------------------------------------------------------------
% flip Flip sign of signal
% ---------------------------------------------------------------------
flip         = cfg_menu;
flip.tag     = 'flip';
flip.name    = 'Flip sign of signal';
flip.labels = {
               'No'
               'Yes'
               }';
flip.values = {
               false
               true
               }';
% ---------------------------------------------------------------------
% resp Respiratory
% ---------------------------------------------------------------------
resp1         = cfg_branch;
resp1.tag     = 'resp';
resp1.name    = 'Respiratory';
resp1.val     = {datafile bandwidth flip };
% ---------------------------------------------------------------------
% corr Correction type
% ---------------------------------------------------------------------
corr         = cfg_menu;
corr.tag     = 'corr';
corr.name    = 'Correction type';
corr.labels = {
               'Global (Resp histogram)'
               'Both global'
               'Global (Resp cyclic)'
               'Both cyclic'
               }';
corr.values = {
               -1
               0
               1
               2
               }';
% ---------------------------------------------------------------------
% pulseresp Pulse+Respiratory
% ---------------------------------------------------------------------
pulseresp         = cfg_branch;
pulseresp.tag     = 'pulseresp';
pulseresp.name    = 'Pulse+Respiratory';
pulseresp.val     = {pulse1 resp1 corr };
% ---------------------------------------------------------------------
% which Data for correction
% ---------------------------------------------------------------------
which         = cfg_choice;
which.tag     = 'which';
which.name    = 'Data for correction';
which.values  = {cardiac resp pulse respcard cardresp resppulse pulseresp };
% ---------------------------------------------------------------------
% corr_phases_and_cycles Estimate Phases and Cycles
% ---------------------------------------------------------------------
corr_phases_and_cycles         = cfg_exbranch;
corr_phases_and_cycles.tag     = 'corr_phases_and_cycles';
corr_phases_and_cycles.name    = 'Estimate Phases and Cycles';
corr_phases_and_cycles.val     = {nscans nslices TR ndummy which };
corr_phases_and_cycles.prog = @(job)run_phases_and_cycles('run',job);
corr_phases_and_cycles.vout = @(job)run_phases_and_cycles('vout',job);
% ---------------------------------------------------------------------
% images Image Time Series
% ---------------------------------------------------------------------
images         = cfg_files;
images.tag     = 'images';
images.name    = 'Image Time Series';
images.help    = {'Enter the image time series.'};
images.filter = 'image';
images.ufilter = '.*';
images.num     = [1 Inf];
% ---------------------------------------------------------------------
% TR TR
% ---------------------------------------------------------------------
TR         = cfg_entry;
TR.tag     = 'TR';
TR.name    = 'TR';
TR.help    = {'The TR of your experiment. Note that this function assumes that the scans are acquired without any "silent" periods between scans.'};
TR.strtype = 'r';
TR.num     = [1  1];
% ---------------------------------------------------------------------
% ndummy #Dummy scans
% ---------------------------------------------------------------------
ndummy         = cfg_entry;
ndummy.tag     = 'ndummy';
ndummy.name    = '#Dummy scans';
ndummy.help    = {'Enter the number of dummy scans that were acquired before the start of the image time series.'};
ndummy.strtype = 'w';
ndummy.num     = [1  1];
% ---------------------------------------------------------------------
% sorder Slice order
% ---------------------------------------------------------------------
sorder         = cfg_entry;
sorder.tag     = 'sorder';
sorder.name    = 'Slice order';
sorder.help    = {'Enter the slice order of your acquisition.'};
sorder.strtype = 'n';
sorder.num     = [1  Inf];
% ---------------------------------------------------------------------
% PhasesOfSlices Phases of Slices
% ---------------------------------------------------------------------
PhasesOfSlices         = cfg_entry;
PhasesOfSlices.tag     = 'PhasesOfSlices';
PhasesOfSlices.name    = 'Phases of Slices';
PhasesOfSlices.strtype = 'r';
PhasesOfSlices.num     = [];
% ---------------------------------------------------------------------
% CyclesOfSlices Cycles of Slices
% ---------------------------------------------------------------------
CyclesOfSlices         = cfg_entry;
CyclesOfSlices.tag     = 'CyclesOfSlices';
CyclesOfSlices.name    = 'Cycles of Slices';
CyclesOfSlices.strtype = 'r';
CyclesOfSlices.num     = [];
% ---------------------------------------------------------------------
% corr Correction type
% ---------------------------------------------------------------------
corr         = cfg_menu;
corr.tag     = 'corr';
corr.name    = 'Correction type';
corr.labels = {
               'Global'
               'Cyclic'
               }';
corr.values = {
               0
               1
               }';
% ---------------------------------------------------------------------
% cardiac Cardiac
% ---------------------------------------------------------------------
cardiac         = cfg_branch;
cardiac.tag     = 'cardiac';
cardiac.name    = 'Cardiac';
cardiac.val     = {corr };
% ---------------------------------------------------------------------
% corr Correction type
% ---------------------------------------------------------------------
corr         = cfg_menu;
corr.tag     = 'corr';
corr.name    = 'Correction type';
corr.labels = {
               'Global (histogram)'
               'Global'
               'Cyclic'
               }';
corr.values = {
               -1
               0
               1
               }';
% ---------------------------------------------------------------------
% resp Respiratory
% ---------------------------------------------------------------------
resp         = cfg_branch;
resp.tag     = 'resp';
resp.name    = 'Respiratory';
resp.val     = {corr };
% ---------------------------------------------------------------------
% corr Correction type
% ---------------------------------------------------------------------
corr         = cfg_menu;
corr.tag     = 'corr';
corr.name    = 'Correction type';
corr.labels = {
               'Global'
               'Cyclic'
               }';
corr.values = {
               0
               1
               }';
% ---------------------------------------------------------------------
% pulse Pulse
% ---------------------------------------------------------------------
pulse         = cfg_branch;
pulse.tag     = 'pulse';
pulse.name    = 'Pulse';
pulse.val     = {corr };
% ---------------------------------------------------------------------
% corr Correction type
% ---------------------------------------------------------------------
corr         = cfg_menu;
corr.tag     = 'corr';
corr.name    = 'Correction type';
corr.labels = {
               'Global (Resp histogram)'
               'Both global'
               'Global (Resp cyclic)'
               'Both cyclic'
               }';
corr.values = {
               -1
               0
               1
               2
               }';
% ---------------------------------------------------------------------
% respcard Respiratory+Cardiac
% ---------------------------------------------------------------------
respcard         = cfg_branch;
respcard.tag     = 'respcard';
respcard.name    = 'Respiratory+Cardiac';
respcard.val     = {corr };
% ---------------------------------------------------------------------
% corr Correction type
% ---------------------------------------------------------------------
corr         = cfg_menu;
corr.tag     = 'corr';
corr.name    = 'Correction type';
corr.labels = {
               'Global (Resp histogram)'
               'Both global'
               'Global (Resp cyclic)'
               'Both cyclic'
               }';
corr.values = {
               -1
               0
               1
               2
               }';
% ---------------------------------------------------------------------
% cardresp Cardiac+Respiratory
% ---------------------------------------------------------------------
cardresp         = cfg_branch;
cardresp.tag     = 'cardresp';
cardresp.name    = 'Cardiac+Respiratory';
cardresp.val     = {corr };
% ---------------------------------------------------------------------
% corr Correction type
% ---------------------------------------------------------------------
corr         = cfg_menu;
corr.tag     = 'corr';
corr.name    = 'Correction type';
corr.labels = {
               'Global (Resp histogram)'
               'Both global'
               'Global (Resp cyclic)'
               'Both cyclic'
               }';
corr.values = {
               -1
               0
               1
               2
               }';
% ---------------------------------------------------------------------
% resp Respiratory+Pulse
% ---------------------------------------------------------------------
resp1         = cfg_branch;
resp1.tag     = 'resp';
resp1.name    = 'Respiratory+Pulse';
resp1.val     = {corr };
% ---------------------------------------------------------------------
% corr Correction type
% ---------------------------------------------------------------------
corr         = cfg_menu;
corr.tag     = 'corr';
corr.name    = 'Correction type';
corr.labels = {
               'Global (Resp histogram)'
               'Both global'
               'Global (Resp cyclic)'
               'Both cyclic'
               }';
corr.values = {
               -1
               0
               1
               2
               }';
% ---------------------------------------------------------------------
% resp Pulse+Respiratory
% ---------------------------------------------------------------------
resp2         = cfg_branch;
resp2.tag     = 'resp';
resp2.name    = 'Pulse+Respiratory';
resp2.val     = {corr };
% ---------------------------------------------------------------------
% which Data Source and Correction Method
% ---------------------------------------------------------------------
which         = cfg_choice;
which.tag     = 'which';
which.name    = 'Data Source and Correction Method';
which.values  = {cardiac resp pulse respcard cardresp resp1 resp2 };
% ---------------------------------------------------------------------
% var Specify Data
% ---------------------------------------------------------------------
var         = cfg_branch;
var.tag     = 'var';
var.name    = 'Specify Data';
var.val     = {PhasesOfSlices CyclesOfSlices which };
% ---------------------------------------------------------------------
% matfile Specify .mat File
% ---------------------------------------------------------------------
matfile         = cfg_files;
matfile.tag     = 'matfile';
matfile.name    = 'Specify .mat File';
matfile.filter = 'mat';
matfile.ufilter = '.*';
matfile.num     = [1 1];
% ---------------------------------------------------------------------
% corrdata Correction Data
% ---------------------------------------------------------------------
corrdata         = cfg_choice;
corrdata.tag     = 'corrdata';
corrdata.name    = 'Correction Data';
corrdata.values  = {var matfile };
% ---------------------------------------------------------------------
% fitmethod Fit Method
% ---------------------------------------------------------------------
fitmethod         = cfg_menu;
fitmethod.tag     = 'fitmethod';
fitmethod.name    = 'Fit Method';
fitmethod.labels = {
                    'Fourier Series'
                    'Polynomial'
                    }';
fitmethod.values = {
                    0
                    1
                    }';
% ---------------------------------------------------------------------
% fitorder Fit Order
% ---------------------------------------------------------------------
fitorder         = cfg_menu;
fitorder.tag     = 'fitorder';
fitorder.name    = 'Fit Order';
fitorder.labels = {
                   '2'
                   '4'
                   }';
fitorder.values = {
                   2
                   4
                   }';
% ---------------------------------------------------------------------
% prefix Prefix
% ---------------------------------------------------------------------
prefix         = cfg_entry;
prefix.tag     = 'prefix';
prefix.name    = 'Prefix';
prefix.help    = {'The prefix will be prepended  to the image filenames.'};
prefix.strtype = 's';
prefix.num     = [1  Inf];
% ---------------------------------------------------------------------
% corr_correction Apply Correction
% ---------------------------------------------------------------------
corr_correction         = cfg_exbranch;
corr_correction.tag     = 'corr_correction';
corr_correction.name    = 'Apply Correction';
corr_correction.val     = {images TR ndummy sorder corrdata fitmethod fitorder prefix };
corr_correction.prog = @(job)run_correction('run',job);
corr_correction.vout = @(job)run_correction('vout',job);
% ---------------------------------------------------------------------
% images Image Time Series
% ---------------------------------------------------------------------
images         = cfg_files;
images.tag     = 'images';
images.name    = 'Image Time Series';
images.help    = {'Enter the image time series.'};
images.filter = 'image';
images.ufilter = '.*';
images.num     = [1 Inf];
% ---------------------------------------------------------------------
% TR TR
% ---------------------------------------------------------------------
TR         = cfg_entry;
TR.tag     = 'TR';
TR.name    = 'TR';
TR.help    = {'The TR of your experiment. Note that this function assumes that the scans are acquired without any "silent" periods between scans.'};
TR.strtype = 'r';
TR.num     = [1  1];
% ---------------------------------------------------------------------
% ndummy #Dummy scans
% ---------------------------------------------------------------------
ndummy         = cfg_entry;
ndummy.tag     = 'ndummy';
ndummy.name    = '#Dummy scans';
ndummy.help    = {'Enter the number of dummy scans that were acquired before the start of the image time series.'};
ndummy.strtype = 'w';
ndummy.num     = [1  1];
% ---------------------------------------------------------------------
% sorder Slice order
% ---------------------------------------------------------------------
sorder         = cfg_entry;
sorder.tag     = 'sorder';
sorder.name    = 'Slice order';
sorder.help    = {'Enter the slice order of your acquisition.'};
sorder.strtype = 'n';
sorder.num     = [1  Inf];
% ---------------------------------------------------------------------
% datafile Data file
% ---------------------------------------------------------------------
datafile         = cfg_files;
datafile.tag     = 'datafile';
datafile.name    = 'Data file';
datafile.filter = 'any';
datafile.ufilter = '.*';
datafile.num     = [1 1];
% ---------------------------------------------------------------------
% bandwidth Bandwidth
% ---------------------------------------------------------------------
bandwidth         = cfg_entry;
bandwidth.tag     = 'bandwidth';
bandwidth.name    = 'Bandwidth';
bandwidth.strtype = 'r';
bandwidth.num     = [1  1];
% ---------------------------------------------------------------------
% flip Flip sign of signal
% ---------------------------------------------------------------------
flip         = cfg_menu;
flip.tag     = 'flip';
flip.name    = 'Flip sign of signal';
flip.labels = {
               'No'
               'Yes'
               }';
flip.values = {
               false
               true
               }';
% ---------------------------------------------------------------------
% channel Channel
% ---------------------------------------------------------------------
channel         = cfg_entry;
channel.tag     = 'channel';
channel.name    = 'Channel';
channel.strtype = 'n';
channel.num     = [1  1];
% ---------------------------------------------------------------------
% cardiac Cardiac
% ---------------------------------------------------------------------
cardiac1         = cfg_branch;
cardiac1.tag     = 'cardiac';
cardiac1.name    = 'Cardiac';
cardiac1.val     = {datafile bandwidth flip channel };
% ---------------------------------------------------------------------
% corr Correction type
% ---------------------------------------------------------------------
corr         = cfg_menu;
corr.tag     = 'corr';
corr.name    = 'Correction type';
corr.labels = {
               'Global'
               'Cyclic'
               }';
corr.values = {
               0
               1
               }';
% ---------------------------------------------------------------------
% cardiac Cardiac
% ---------------------------------------------------------------------
cardiac         = cfg_branch;
cardiac.tag     = 'cardiac';
cardiac.name    = 'Cardiac';
cardiac.val     = {cardiac1 corr };
% ---------------------------------------------------------------------
% datafile Data file
% ---------------------------------------------------------------------
datafile         = cfg_files;
datafile.tag     = 'datafile';
datafile.name    = 'Data file';
datafile.filter = 'any';
datafile.ufilter = '.*';
datafile.num     = [1 1];
% ---------------------------------------------------------------------
% bandwidth Bandwidth
% ---------------------------------------------------------------------
bandwidth         = cfg_entry;
bandwidth.tag     = 'bandwidth';
bandwidth.name    = 'Bandwidth';
bandwidth.strtype = 'r';
bandwidth.num     = [1  1];
% ---------------------------------------------------------------------
% flip Flip sign of signal
% ---------------------------------------------------------------------
flip         = cfg_menu;
flip.tag     = 'flip';
flip.name    = 'Flip sign of signal';
flip.labels = {
               'No'
               'Yes'
               }';
flip.values = {
               false
               true
               }';
% ---------------------------------------------------------------------
% resp Respiratory
% ---------------------------------------------------------------------
resp1         = cfg_branch;
resp1.tag     = 'resp';
resp1.name    = 'Respiratory';
resp1.val     = {datafile bandwidth flip };
% ---------------------------------------------------------------------
% corr Correction type
% ---------------------------------------------------------------------
corr         = cfg_menu;
corr.tag     = 'corr';
corr.name    = 'Correction type';
corr.labels = {
               'Global (histogram)'
               'Global'
               'Cyclic'
               }';
corr.values = {
               -1
               0
               1
               }';
% ---------------------------------------------------------------------
% resp Respiratory
% ---------------------------------------------------------------------
resp         = cfg_branch;
resp.tag     = 'resp';
resp.name    = 'Respiratory';
resp.val     = {resp1 corr };
% ---------------------------------------------------------------------
% datafile Data file
% ---------------------------------------------------------------------
datafile         = cfg_files;
datafile.tag     = 'datafile';
datafile.name    = 'Data file';
datafile.filter = 'any';
datafile.ufilter = '.*';
datafile.num     = [1 1];
% ---------------------------------------------------------------------
% bandwidth Bandwidth
% ---------------------------------------------------------------------
bandwidth         = cfg_entry;
bandwidth.tag     = 'bandwidth';
bandwidth.name    = 'Bandwidth';
bandwidth.strtype = 'r';
bandwidth.num     = [1  1];
% ---------------------------------------------------------------------
% flip Flip sign of signal
% ---------------------------------------------------------------------
flip         = cfg_menu;
flip.tag     = 'flip';
flip.name    = 'Flip sign of signal';
flip.labels = {
               'No'
               'Yes'
               }';
flip.values = {
               false
               true
               }';
% ---------------------------------------------------------------------
% pulse Pulse
% ---------------------------------------------------------------------
pulse1         = cfg_branch;
pulse1.tag     = 'pulse';
pulse1.name    = 'Pulse';
pulse1.val     = {datafile bandwidth flip };
% ---------------------------------------------------------------------
% corr Correction type
% ---------------------------------------------------------------------
corr         = cfg_menu;
corr.tag     = 'corr';
corr.name    = 'Correction type';
corr.labels = {
               'Global'
               'Cyclic'
               }';
corr.values = {
               0
               1
               }';
% ---------------------------------------------------------------------
% pulse Pulse
% ---------------------------------------------------------------------
pulse         = cfg_branch;
pulse.tag     = 'pulse';
pulse.name    = 'Pulse';
pulse.val     = {pulse1 corr };
% ---------------------------------------------------------------------
% datafile Data file
% ---------------------------------------------------------------------
datafile         = cfg_files;
datafile.tag     = 'datafile';
datafile.name    = 'Data file';
datafile.filter = 'any';
datafile.ufilter = '.*';
datafile.num     = [1 1];
% ---------------------------------------------------------------------
% bandwidth Bandwidth
% ---------------------------------------------------------------------
bandwidth         = cfg_entry;
bandwidth.tag     = 'bandwidth';
bandwidth.name    = 'Bandwidth';
bandwidth.strtype = 'r';
bandwidth.num     = [1  1];
% ---------------------------------------------------------------------
% flip Flip sign of signal
% ---------------------------------------------------------------------
flip         = cfg_menu;
flip.tag     = 'flip';
flip.name    = 'Flip sign of signal';
flip.labels = {
               'No'
               'Yes'
               }';
flip.values = {
               false
               true
               }';
% ---------------------------------------------------------------------
% resp Respiratory
% ---------------------------------------------------------------------
resp1         = cfg_branch;
resp1.tag     = 'resp';
resp1.name    = 'Respiratory';
resp1.val     = {datafile bandwidth flip };
% ---------------------------------------------------------------------
% datafile Data file
% ---------------------------------------------------------------------
datafile         = cfg_files;
datafile.tag     = 'datafile';
datafile.name    = 'Data file';
datafile.filter = 'any';
datafile.ufilter = '.*';
datafile.num     = [1 1];
% ---------------------------------------------------------------------
% bandwidth Bandwidth
% ---------------------------------------------------------------------
bandwidth         = cfg_entry;
bandwidth.tag     = 'bandwidth';
bandwidth.name    = 'Bandwidth';
bandwidth.strtype = 'r';
bandwidth.num     = [1  1];
% ---------------------------------------------------------------------
% flip Flip sign of signal
% ---------------------------------------------------------------------
flip         = cfg_menu;
flip.tag     = 'flip';
flip.name    = 'Flip sign of signal';
flip.labels = {
               'No'
               'Yes'
               }';
flip.values = {
               false
               true
               }';
% ---------------------------------------------------------------------
% channel Channel
% ---------------------------------------------------------------------
channel         = cfg_entry;
channel.tag     = 'channel';
channel.name    = 'Channel';
channel.strtype = 'n';
channel.num     = [1  1];
% ---------------------------------------------------------------------
% cardiac Cardiac
% ---------------------------------------------------------------------
cardiac1         = cfg_branch;
cardiac1.tag     = 'cardiac';
cardiac1.name    = 'Cardiac';
cardiac1.val     = {datafile bandwidth flip channel };
% ---------------------------------------------------------------------
% corr Correction type
% ---------------------------------------------------------------------
corr         = cfg_menu;
corr.tag     = 'corr';
corr.name    = 'Correction type';
corr.labels = {
               'Global (Resp histogram)'
               'Both global'
               'Global (Resp cyclic)'
               'Both cyclic'
               }';
corr.values = {
               -1
               0
               1
               2
               }';
% ---------------------------------------------------------------------
% respcard Respiratory+Cardiac
% ---------------------------------------------------------------------
respcard         = cfg_branch;
respcard.tag     = 'respcard';
respcard.name    = 'Respiratory+Cardiac';
respcard.val     = {resp1 cardiac1 corr };
% ---------------------------------------------------------------------
% datafile Data file
% ---------------------------------------------------------------------
datafile         = cfg_files;
datafile.tag     = 'datafile';
datafile.name    = 'Data file';
datafile.filter = 'any';
datafile.ufilter = '.*';
datafile.num     = [1 1];
% ---------------------------------------------------------------------
% bandwidth Bandwidth
% ---------------------------------------------------------------------
bandwidth         = cfg_entry;
bandwidth.tag     = 'bandwidth';
bandwidth.name    = 'Bandwidth';
bandwidth.strtype = 'r';
bandwidth.num     = [1  1];
% ---------------------------------------------------------------------
% flip Flip sign of signal
% ---------------------------------------------------------------------
flip         = cfg_menu;
flip.tag     = 'flip';
flip.name    = 'Flip sign of signal';
flip.labels = {
               'No'
               'Yes'
               }';
flip.values = {
               false
               true
               }';
% ---------------------------------------------------------------------
% channel Channel
% ---------------------------------------------------------------------
channel         = cfg_entry;
channel.tag     = 'channel';
channel.name    = 'Channel';
channel.strtype = 'n';
channel.num     = [1  1];
% ---------------------------------------------------------------------
% cardiac Cardiac
% ---------------------------------------------------------------------
cardiac1         = cfg_branch;
cardiac1.tag     = 'cardiac';
cardiac1.name    = 'Cardiac';
cardiac1.val     = {datafile bandwidth flip channel };
% ---------------------------------------------------------------------
% datafile Data file
% ---------------------------------------------------------------------
datafile         = cfg_files;
datafile.tag     = 'datafile';
datafile.name    = 'Data file';
datafile.filter = 'any';
datafile.ufilter = '.*';
datafile.num     = [1 1];
% ---------------------------------------------------------------------
% bandwidth Bandwidth
% ---------------------------------------------------------------------
bandwidth         = cfg_entry;
bandwidth.tag     = 'bandwidth';
bandwidth.name    = 'Bandwidth';
bandwidth.strtype = 'r';
bandwidth.num     = [1  1];
% ---------------------------------------------------------------------
% flip Flip sign of signal
% ---------------------------------------------------------------------
flip         = cfg_menu;
flip.tag     = 'flip';
flip.name    = 'Flip sign of signal';
flip.labels = {
               'No'
               'Yes'
               }';
flip.values = {
               false
               true
               }';
% ---------------------------------------------------------------------
% resp Respiratory
% ---------------------------------------------------------------------
resp1         = cfg_branch;
resp1.tag     = 'resp';
resp1.name    = 'Respiratory';
resp1.val     = {datafile bandwidth flip };
% ---------------------------------------------------------------------
% corr Correction type
% ---------------------------------------------------------------------
corr         = cfg_menu;
corr.tag     = 'corr';
corr.name    = 'Correction type';
corr.labels = {
               'Global (Resp histogram)'
               'Both global'
               'Global (Resp cyclic)'
               'Both cyclic'
               }';
corr.values = {
               -1
               0
               1
               2
               }';
% ---------------------------------------------------------------------
% cardresp Cardiac+Respiratory
% ---------------------------------------------------------------------
cardresp         = cfg_branch;
cardresp.tag     = 'cardresp';
cardresp.name    = 'Cardiac+Respiratory';
cardresp.val     = {cardiac1 resp1 corr };
% ---------------------------------------------------------------------
% datafile Data file
% ---------------------------------------------------------------------
datafile         = cfg_files;
datafile.tag     = 'datafile';
datafile.name    = 'Data file';
datafile.filter = 'any';
datafile.ufilter = '.*';
datafile.num     = [1 1];
% ---------------------------------------------------------------------
% bandwidth Bandwidth
% ---------------------------------------------------------------------
bandwidth         = cfg_entry;
bandwidth.tag     = 'bandwidth';
bandwidth.name    = 'Bandwidth';
bandwidth.strtype = 'r';
bandwidth.num     = [1  1];
% ---------------------------------------------------------------------
% flip Flip sign of signal
% ---------------------------------------------------------------------
flip         = cfg_menu;
flip.tag     = 'flip';
flip.name    = 'Flip sign of signal';
flip.labels = {
               'No'
               'Yes'
               }';
flip.values = {
               false
               true
               }';
% ---------------------------------------------------------------------
% resp Respiratory
% ---------------------------------------------------------------------
resp1         = cfg_branch;
resp1.tag     = 'resp';
resp1.name    = 'Respiratory';
resp1.val     = {datafile bandwidth flip };
% ---------------------------------------------------------------------
% datafile Data file
% ---------------------------------------------------------------------
datafile         = cfg_files;
datafile.tag     = 'datafile';
datafile.name    = 'Data file';
datafile.filter = 'any';
datafile.ufilter = '.*';
datafile.num     = [1 1];
% ---------------------------------------------------------------------
% bandwidth Bandwidth
% ---------------------------------------------------------------------
bandwidth         = cfg_entry;
bandwidth.tag     = 'bandwidth';
bandwidth.name    = 'Bandwidth';
bandwidth.strtype = 'r';
bandwidth.num     = [1  1];
% ---------------------------------------------------------------------
% flip Flip sign of signal
% ---------------------------------------------------------------------
flip         = cfg_menu;
flip.tag     = 'flip';
flip.name    = 'Flip sign of signal';
flip.labels = {
               'No'
               'Yes'
               }';
flip.values = {
               false
               true
               }';
% ---------------------------------------------------------------------
% pulse Pulse
% ---------------------------------------------------------------------
pulse1         = cfg_branch;
pulse1.tag     = 'pulse';
pulse1.name    = 'Pulse';
pulse1.val     = {datafile bandwidth flip };
% ---------------------------------------------------------------------
% corr Correction type
% ---------------------------------------------------------------------
corr         = cfg_menu;
corr.tag     = 'corr';
corr.name    = 'Correction type';
corr.labels = {
               'Global (Resp histogram)'
               'Both global'
               'Global (Resp cyclic)'
               'Both cyclic'
               }';
corr.values = {
               -1
               0
               1
               2
               }';
% ---------------------------------------------------------------------
% resppulse Respiratory+Pulse
% ---------------------------------------------------------------------
resppulse         = cfg_branch;
resppulse.tag     = 'resppulse';
resppulse.name    = 'Respiratory+Pulse';
resppulse.val     = {resp1 pulse1 corr };
% ---------------------------------------------------------------------
% datafile Data file
% ---------------------------------------------------------------------
datafile         = cfg_files;
datafile.tag     = 'datafile';
datafile.name    = 'Data file';
datafile.filter = 'any';
datafile.ufilter = '.*';
datafile.num     = [1 1];
% ---------------------------------------------------------------------
% bandwidth Bandwidth
% ---------------------------------------------------------------------
bandwidth         = cfg_entry;
bandwidth.tag     = 'bandwidth';
bandwidth.name    = 'Bandwidth';
bandwidth.strtype = 'r';
bandwidth.num     = [1  1];
% ---------------------------------------------------------------------
% flip Flip sign of signal
% ---------------------------------------------------------------------
flip         = cfg_menu;
flip.tag     = 'flip';
flip.name    = 'Flip sign of signal';
flip.labels = {
               'No'
               'Yes'
               }';
flip.values = {
               false
               true
               }';
% ---------------------------------------------------------------------
% pulse Pulse
% ---------------------------------------------------------------------
pulse1         = cfg_branch;
pulse1.tag     = 'pulse';
pulse1.name    = 'Pulse';
pulse1.val     = {datafile bandwidth flip };
% ---------------------------------------------------------------------
% datafile Data file
% ---------------------------------------------------------------------
datafile         = cfg_files;
datafile.tag     = 'datafile';
datafile.name    = 'Data file';
datafile.filter = 'any';
datafile.ufilter = '.*';
datafile.num     = [1 1];
% ---------------------------------------------------------------------
% bandwidth Bandwidth
% ---------------------------------------------------------------------
bandwidth         = cfg_entry;
bandwidth.tag     = 'bandwidth';
bandwidth.name    = 'Bandwidth';
bandwidth.strtype = 'r';
bandwidth.num     = [1  1];
% ---------------------------------------------------------------------
% flip Flip sign of signal
% ---------------------------------------------------------------------
flip         = cfg_menu;
flip.tag     = 'flip';
flip.name    = 'Flip sign of signal';
flip.labels = {
               'No'
               'Yes'
               }';
flip.values = {
               false
               true
               }';
% ---------------------------------------------------------------------
% resp Respiratory
% ---------------------------------------------------------------------
resp1         = cfg_branch;
resp1.tag     = 'resp';
resp1.name    = 'Respiratory';
resp1.val     = {datafile bandwidth flip };
% ---------------------------------------------------------------------
% corr Correction type
% ---------------------------------------------------------------------
corr         = cfg_menu;
corr.tag     = 'corr';
corr.name    = 'Correction type';
corr.labels = {
               'Global (Resp histogram)'
               'Both global'
               'Global (Resp cyclic)'
               'Both cyclic'
               }';
corr.values = {
               -1
               0
               1
               2
               }';
% ---------------------------------------------------------------------
% pulseresp Pulse+Respiratory
% ---------------------------------------------------------------------
pulseresp         = cfg_branch;
pulseresp.tag     = 'pulseresp';
pulseresp.name    = 'Pulse+Respiratory';
pulseresp.val     = {pulse1 resp1 corr };
% ---------------------------------------------------------------------
% which Data for correction
% ---------------------------------------------------------------------
which         = cfg_choice;
which.tag     = 'which';
which.name    = 'Data for correction';
which.values  = {cardiac resp pulse respcard cardresp resppulse pulseresp };
% ---------------------------------------------------------------------
% fitmethod Fit Method
% ---------------------------------------------------------------------
fitmethod         = cfg_menu;
fitmethod.tag     = 'fitmethod';
fitmethod.name    = 'Fit Method';
fitmethod.labels = {
                    'Fourier Series'
                    'Polynomial'
                    }';
fitmethod.values = {
                    0
                    1
                    }';
% ---------------------------------------------------------------------
% fitorder Fit Order
% ---------------------------------------------------------------------
fitorder         = cfg_menu;
fitorder.tag     = 'fitorder';
fitorder.name    = 'Fit Order';
fitorder.labels = {
                   '2'
                   '4'
                   }';
fitorder.values = {
                   2
                   4
                   }';
% ---------------------------------------------------------------------
% prefix Prefix
% ---------------------------------------------------------------------
prefix         = cfg_entry;
prefix.tag     = 'prefix';
prefix.name    = 'Prefix';
prefix.help    = {'The prefix will be prepended  to the image filenames.'};
prefix.strtype = 's';
prefix.num     = [1  Inf];
% ---------------------------------------------------------------------
% corr_est_apply Estimate+Apply Correction
% ---------------------------------------------------------------------
corr_est_apply         = cfg_exbranch;
corr_est_apply.tag     = 'corr_est_apply';
corr_est_apply.name    = 'Estimate+Apply Correction';
corr_est_apply.val     = {images TR ndummy sorder which fitmethod fitorder prefix };
corr_est_apply.prog = @(job)run_est_apply('run',job);
corr_est_apply.vout = @(job)run_est_apply('vout',job);
% ---------------------------------------------------------------------
% physiotool PhysioTool
% ---------------------------------------------------------------------
physiotool         = cfg_choice;
physiotool.tag     = 'physiotool';
physiotool.name    = 'PhysioTool';
physiotool.values  = {corr_phases_and_cycles corr_correction corr_est_apply };
% ---------------------------------------------------------------------
% add path to this mfile
% ---------------------------------------------------------------------
addpath(fileparts(mfilename('fullpath')));
