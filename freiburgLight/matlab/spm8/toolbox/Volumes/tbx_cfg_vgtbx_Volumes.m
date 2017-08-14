function vgtbx_Volumes = tbx_cfg_vgtbx_Volumes
% Volumes toolbox
%_______________________________________________________________________
%
% This toolbox contains various helper functions to make image 
% manipulation within SPM5 more convenient. Help on each individual item 
% can be obtained by selecting the corresponding entry in the help menu.
%
% This toolbox is free but copyright software, distributed under the 
% terms of the GNU General Public Licence as published by the Free 
% Software Foundation (either version 2, as given in file 
% spm_LICENCE.man, or at your option, any later version). Further details 
% on "copyleft" can be found at http://www.gnu.org/copyleft/.
% The toolbox consists of the files listed in its Contents.m file.
%
% The source code of this toolbox is available at
%
% http://sourceforge.net/projects/spmtools
% 
% Please use the SourceForge forum and tracker system for comments, 
% suggestions, bug reports etc. regarding this toolbox.
%_______________________________________________________________________
%
% @(#) $Id: vgtbx_config_Volumes.m 539 2007-12-06 17:31:12Z glauche $



rev='$Revision: 539 $';

addpath(fullfile(spm('dir'),'toolbox','Volumes'));

% MATLABBATCH Configuration file for toolbox 'Volume handling utilities'
% This code has been automatically generated.
% ---------------------------------------------------------------------
% Toolbox paths - added manually
% ---------------------------------------------------------------------
tbxdir = fileparts(mfilename('fullpath'));
addpath(tbxdir);
addpath(fullfile(tbxdir, 'Single_Volumes'));
addpath(fullfile(tbxdir, 'Multiple_Volumes'));
addpath(fullfile(tbxdir, 'Stats_Tools'));
% ---------------------------------------------------------------------
% srcspm Source SPM.mat
% ---------------------------------------------------------------------
srcspm         = cfg_files;
srcspm.tag     = 'srcspm';
srcspm.name    = 'Source SPM.mat';
srcspm.help    = {''};
srcspm.filter = 'mat';
srcspm.ufilter = '.*SPM.*\.mat';
srcspm.num     = [1 1];
% ---------------------------------------------------------------------
% srcimgs Source Images
% ---------------------------------------------------------------------
srcimgs         = cfg_files;
srcimgs.tag     = 'srcimgs';
srcimgs.name    = 'Source Images';
srcimgs.help    = {''};
srcimgs.filter = 'image';
srcimgs.ufilter = '.*';
srcimgs.num     = [1 Inf];
% ---------------------------------------------------------------------
% src Data Source
% ---------------------------------------------------------------------
src         = cfg_choice;
src.tag     = 'src';
src.name    = 'Data Source';
src.help    = {'Data can be sampled from raw images, or from an SPM analysis. In case of an SPM analysis, both fitted and raw data will be sampled.'};
src.values  = {srcspm srcimgs };
% ---------------------------------------------------------------------
% srcimg Source Image
% ---------------------------------------------------------------------
srcimg         = cfg_files;
srcimg.tag     = 'srcimg';
srcimg.name    = 'Source Image';
srcimg.help    = {''};
srcimg.filter = 'image';
srcimg.ufilter = '.*';
srcimg.num     = [1 1];
% ---------------------------------------------------------------------
% roistart Start Point (in mm)
% ---------------------------------------------------------------------
roistart         = cfg_entry;
roistart.tag     = 'roistart';
roistart.name    = 'Start Point (in mm)';
roistart.help    = {''};
roistart.strtype = 'e';
roistart.num     = [3 1];
% ---------------------------------------------------------------------
% roiend End Point (in mm)
% ---------------------------------------------------------------------
roiend         = cfg_entry;
roiend.tag     = 'roiend';
roiend.name    = 'End Point (in mm)';
roiend.help    = {''};
roiend.strtype = 'e';
roiend.num     = [3 1];
% ---------------------------------------------------------------------
% roistep Sampling Distance along Line (in mm)
% ---------------------------------------------------------------------
roistep         = cfg_entry;
roistep.tag     = 'roistep';
roistep.name    = 'Sampling Distance along Line (in mm)';
roistep.help    = {''};
roistep.strtype = 'e';
roistep.num     = [1 1];
% ---------------------------------------------------------------------
% roiline Line (Start and End Point)
% ---------------------------------------------------------------------
roiline         = cfg_branch;
roiline.tag     = 'roiline';
roiline.name    = 'Line (Start and End Point)';
roiline.val     = {roistart roiend roistep };
roiline.help    = {
                   'Specify a line in 3D space from a start point to an end point. The image is sampled along this line according to the specified sampling distance.'
                   'Note that the sampling positions are computed in mm space and then transformed into the voxel space of the image. This may result in a sparse sampling of the image, if the voxel size is smaller than the sampling distance.'
}';
% ---------------------------------------------------------------------
% roilinep1 First Point (in mm)
% ---------------------------------------------------------------------
roilinep1         = cfg_entry;
roilinep1.tag     = 'roilinep1';
roilinep1.name    = 'First Point (in mm)';
roilinep1.help    = {''};
roilinep1.strtype = 'e';
roilinep1.num     = [3 1];
% ---------------------------------------------------------------------
% roilinep2 Second Point (in mm)
% ---------------------------------------------------------------------
roilinep2         = cfg_entry;
roilinep2.tag     = 'roilinep2';
roilinep2.name    = 'Second Point (in mm)';
roilinep2.help    = {''};
roilinep2.strtype = 'e';
roilinep2.num     = [3 1];
% ---------------------------------------------------------------------
% roilinecoords Point List of Line Coordinates
% ---------------------------------------------------------------------
roilinecoords         = cfg_entry;
roilinecoords.tag     = 'roilinecoords';
roilinecoords.name    = 'Point List of Line Coordinates';
roilinecoords.help    = {''};
roilinecoords.strtype = 'e';
roilinecoords.num     = [1 Inf];
% ---------------------------------------------------------------------
% roilineparam Line (2 Points on Line and Parameters in Line Coords)
% ---------------------------------------------------------------------
roilineparam         = cfg_branch;
roilineparam.tag     = 'roilineparam';
roilineparam.name    = 'Line (2 Points on Line and Parameters in Line Coords)';
roilineparam.val     = {roilinep1 roilinep2 roilinecoords };
roilineparam.help    = {
                        'Specify a line in 3D space  going through 2 points. The image is sampled along this line according to the specified line coordinates, starting with zero at the first point. Spacing between line coordinates can be variable.'
                        'The convention for line coordinates is that negative values run from P1 towards P2, while positive values run from P1 away from P2.'
                        'Note that the sampling positions are computed in mm space and then transformed into the voxel space of the image. This may result in a sparse sampling of the image, if the voxel size is smaller than the sampling distance.'
}';
% ---------------------------------------------------------------------
% roicent Centre Point (in mm)
% ---------------------------------------------------------------------
roicent         = cfg_entry;
roicent.tag     = 'roicent';
roicent.name    = 'Centre Point (in mm)';
roicent.help    = {''};
roicent.strtype = 'e';
roicent.num     = [3 1];
% ---------------------------------------------------------------------
% roirad Radius (in mm)
% ---------------------------------------------------------------------
roirad         = cfg_entry;
roirad.tag     = 'roirad';
roirad.name    = 'Radius (in mm)';
roirad.help    = {''};
roirad.strtype = 'e';
roirad.num     = [1 1];
% ---------------------------------------------------------------------
% roisphere Sphere
% ---------------------------------------------------------------------
roisphere         = cfg_branch;
roisphere.tag     = 'roisphere';
roisphere.name    = 'Sphere';
roisphere.val     = {roicent roirad };
roisphere.help    = {'Specify a sphere with centre and radius in mm coordinates.The actual sampling positions are computed in voxel space, and therefore a contiguous sampling of the specified sphere is guaranteed.'};
% ---------------------------------------------------------------------
% roilist Point List (in mm)
% ---------------------------------------------------------------------
roilist         = cfg_entry;
roilist.tag     = 'roilist';
roilist.name    = 'Point List (in mm)';
roilist.help    = {'Specify a list of mm positions to be sampled. Note, that this may sample a volume in a non-contiguous way, if the positions do not correspond 1-to-1 to voxel positions.'};
roilist.strtype = 'e';
roilist.num     = [3 Inf];
% ---------------------------------------------------------------------
% roispec ROI Specification
% ---------------------------------------------------------------------
roispec         = cfg_repeat;
roispec.tag     = 'roispec';
roispec.name    = 'ROI Specification';
roispec.help    = {'A region of interest can be specified by an image file or a list of (mm)-positions. If an image file is given, data is extracted for all non-zero voxels in the region of interest.'};
roispec.values  = {srcimg roiline roilineparam roisphere roilist };
roispec.num     = [1 Inf];
% ---------------------------------------------------------------------
% avg Average
% ---------------------------------------------------------------------
avg         = cfg_menu;
avg.tag     = 'avg';
avg.name    = 'Average';
avg.help    = {'If set to ''yes'', only averages over the voxel values of each image are returned.'};
avg.labels = {
              'No averaging'
              'Average over voxels'
}';
avg.values = {
              'none'
              'vox'
}';
% ---------------------------------------------------------------------
% interp Interpolation
% ---------------------------------------------------------------------
interp         = cfg_menu;
interp.tag     = 'interp';
interp.name    = 'Interpolation';
interp.help    = {''};
interp.labels = {
                 'Nearest neighbour'
                 'Trilinear'
                 '2nd Degree b-Spline'
                 '3rd Degree b-Spline'
                 '4th Degree b-Spline'
                 '5th Degree b-Spline'
                 '6th Degree b-Spline'
                 '7th Degree b-Spline'
                 '2nd Degree Sinc'
                 '3rd Degree Sinc'
                 '4th Degree Sinc'
                 '5th Degree Sinc'
                 '6th Degree Sinc'
                 '7th Degree Sinc'
}';
interp.values = {0 1 2 3 4 5 6 7 -2 -3 -4 -5 -6 -7};
% ---------------------------------------------------------------------
% tbxvol_extract Extract Data from ROI
% ---------------------------------------------------------------------
cfg_tbxvol_extract         = cfg_exbranch;
cfg_tbxvol_extract.tag     = 'tbxvol_extract';
cfg_tbxvol_extract.name    = 'Extract Data from ROI';
cfg_tbxvol_extract.val     = {src roispec avg interp };
cfg_tbxvol_extract.help    = vgtbx_help2cell('tbxvol_extract');
cfg_tbxvol_extract.prog = @tbxvol_extract;
cfg_tbxvol_extract.vout    = @vout_tbxvol_extract;
% ---------------------------------------------------------------------
% srcimgs Source Images
% ---------------------------------------------------------------------
srcimgs         = cfg_files;
srcimgs.tag     = 'srcimgs';
srcimgs.name    = 'Source Images';
srcimgs.help    = {''};
srcimgs.filter = 'image';
srcimgs.ufilter = '.*';
srcimgs.num     = [1 Inf];
% ---------------------------------------------------------------------
% flipdir Flip Direction (Voxel Space)
% ---------------------------------------------------------------------
flipdir         = cfg_menu;
flipdir.tag     = 'flipdir';
flipdir.name    = 'Flip Direction (Voxel Space)';
flipdir.help    = {''};
flipdir.labels = {
                  'X'
                  'Y'
                  'Z'
}';
flipdir.values = {1 2 3};
% ---------------------------------------------------------------------
% prefix Output Filename Prefix
% ---------------------------------------------------------------------
prefix         = cfg_entry;
prefix.tag     = 'prefix';
prefix.name    = 'Output Filename Prefix';
prefix.val = {'F'};
prefix.help    = {'The output filename is constructed by prefixing the original filename with this prefix.'};
prefix.strtype = 's';
prefix.num     = [1 Inf];
% ---------------------------------------------------------------------
% overwrite Overwrite existing Input/Output Files
% ---------------------------------------------------------------------
overwrite         = cfg_menu;
overwrite.tag     = 'overwrite';
overwrite.name    = 'Overwrite existing Input/Output Files';
overwrite.help    = {''};
overwrite.labels = {
                    'Yes'
                    'No'
}';
overwrite.values = {true false};
% ---------------------------------------------------------------------
% tbxvol_flip Flip Volumes
% ---------------------------------------------------------------------
cfg_tbxvol_flip         = cfg_exbranch;
cfg_tbxvol_flip.tag     = 'tbxvol_flip';
cfg_tbxvol_flip.name    = 'Flip Volumes';
cfg_tbxvol_flip.val     = {srcimgs flipdir prefix overwrite };
cfg_tbxvol_flip.help    = {'No help available for topic ''tbxvol_flip''.'};
cfg_tbxvol_flip.prog = @tbxvol_flip;
cfg_tbxvol_flip.vfiles = @vfiles_tbxvol_flip;
% ---------------------------------------------------------------------
% srcimgs Source Images
% ---------------------------------------------------------------------
srcimgs         = cfg_files;
srcimgs.tag     = 'srcimgs';
srcimgs.name    = 'Source Images';
srcimgs.help    = {''};
srcimgs.filter = 'image';
srcimgs.ufilter = '.*';
srcimgs.num     = [1 Inf];
% ---------------------------------------------------------------------
% tbxvol_get_integrals Image integrals
% ---------------------------------------------------------------------
cfg_tbxvol_get_integrals         = cfg_exbranch;
cfg_tbxvol_get_integrals.tag     = 'tbxvol_get_integrals';
cfg_tbxvol_get_integrals.name    = 'Image integrals';
cfg_tbxvol_get_integrals.val     = {srcimgs };
cfg_tbxvol_get_integrals.help    = {'No help available for topic ''tbxvol_get_integrals''.'};
cfg_tbxvol_get_integrals.prog = @(job)tbxvol_get_integrals('run',job);
cfg_tbxvol_get_integrals.vout = @(job)tbxvol_get_integrals('vout',job);
% ---------------------------------------------------------------------
% srcimg Source Image
% ---------------------------------------------------------------------
srcimg         = cfg_files;
srcimg.tag     = 'srcimg';
srcimg.name    = 'Source Image';
srcimg.help    = {''};
srcimg.filter = 'image';
srcimg.ufilter = '.*';
srcimg.num     = [1 1];
% ---------------------------------------------------------------------
% prefix Output Filename Prefix
% ---------------------------------------------------------------------
prefix         = cfg_entry;
prefix.tag     = 'prefix';
prefix.name    = 'Output Filename Prefix';
prefix.val = {'H'};
prefix.help    = {'The output filename is constructed by prefixing the original filename with this prefix.'};
prefix.strtype = 's';
prefix.num     = [1 Inf];
% ---------------------------------------------------------------------
% overwrite Overwrite existing Input/Output Files
% ---------------------------------------------------------------------
overwrite         = cfg_menu;
overwrite.tag     = 'overwrite';
overwrite.name    = 'Overwrite existing Input/Output Files';
overwrite.help    = {''};
overwrite.labels = {
                    'Yes'
                    'No'
}';
overwrite.values = {true false};
% ---------------------------------------------------------------------
% tbxvol_histogramm Histogramm Thresholding
% ---------------------------------------------------------------------
cfg_tbxvol_histogramm         = cfg_exbranch;
cfg_tbxvol_histogramm.tag     = 'tbxvol_histogramm';
cfg_tbxvol_histogramm.name    = 'Histogramm Thresholding';
cfg_tbxvol_histogramm.val     = {srcimg prefix overwrite };
cfg_tbxvol_histogramm.help    = {'No help available for topic ''tbxvol_histogramm''.'};
cfg_tbxvol_histogramm.prog = @tbxvol_histogramm;
% ---------------------------------------------------------------------
% srcimgs Source Images
% ---------------------------------------------------------------------
srcimgs         = cfg_files;
srcimgs.tag     = 'srcimgs';
srcimgs.name    = 'Source Images';
srcimgs.help    = {''};
srcimgs.filter = 'image';
srcimgs.ufilter = '.*';
srcimgs.num     = [1 Inf];
% ---------------------------------------------------------------------
% interleaved Interleaved
% ---------------------------------------------------------------------
interleaved         = cfg_const;
interleaved.tag     = 'interleaved';
interleaved.name    = 'Interleaved';
interleaved.val{1} = double(0);
interleaved.help    = {''};
% ---------------------------------------------------------------------
% userdef User Defined
% ---------------------------------------------------------------------
userdef         = cfg_entry;
userdef.tag     = 'userdef';
userdef.name    = 'User Defined';
userdef.help    = {''};
userdef.strtype = 'i';
userdef.num     = [1 Inf];
% ---------------------------------------------------------------------
% sliceorder Slice Order
% ---------------------------------------------------------------------
sliceorder         = cfg_choice;
sliceorder.tag     = 'sliceorder';
sliceorder.name    = 'Slice Order';
sliceorder.help    = {''};
sliceorder.values  = {interleaved userdef };
% ---------------------------------------------------------------------
% prefix Output Filename Prefix
% ---------------------------------------------------------------------
prefix         = cfg_entry;
prefix.tag     = 'prefix';
prefix.name    = 'Output Filename Prefix';
prefix.val = {'I'};
prefix.help    = {'The output filename is constructed by prefixing the original filename with this prefix.'};
prefix.strtype = 's';
prefix.num     = [1 Inf];
% ---------------------------------------------------------------------
% overwrite Overwrite existing Input/Output Files
% ---------------------------------------------------------------------
overwrite         = cfg_menu;
overwrite.tag     = 'overwrite';
overwrite.name    = 'Overwrite existing Input/Output Files';
overwrite.help    = {''};
overwrite.labels = {
                    'Yes'
                    'No'
}';
overwrite.values = {true false};
% ---------------------------------------------------------------------
% tbxvol_interleave (De)Interleave Volumes
% ---------------------------------------------------------------------
cfg_tbxvol_interleave         = cfg_exbranch;
cfg_tbxvol_interleave.tag     = 'tbxvol_interleave';
cfg_tbxvol_interleave.name    = '(De)Interleave Volumes';
cfg_tbxvol_interleave.val     = {srcimgs sliceorder prefix overwrite };
cfg_tbxvol_interleave.help    = {'No help available for topic ''tbxvol_interleave''.'};
cfg_tbxvol_interleave.prog = @tbxvol_interleave;
% ---------------------------------------------------------------------
% srcimg Source Image
% ---------------------------------------------------------------------
srcimg         = cfg_files;
srcimg.tag     = 'srcimg';
srcimg.name    = 'Source Image';
srcimg.help    = {''};
srcimg.filter = 'image';
srcimg.ufilter = '.*';
srcimg.num     = [1 1];
% ---------------------------------------------------------------------
% repslice Slice to Replace
% ---------------------------------------------------------------------
repslice         = cfg_entry;
repslice.tag     = 'repslice';
repslice.name    = 'Slice to Replace';
repslice.help    = {''};
repslice.strtype = 'i';
repslice.num     = [1 1];
% ---------------------------------------------------------------------
% prefix Output Filename Prefix
% ---------------------------------------------------------------------
prefix         = cfg_entry;
prefix.tag     = 'prefix';
prefix.name    = 'Output Filename Prefix';
prefix.val = {'R'};
prefix.help    = {'The output filename is constructed by prefixing the original filename with this prefix.'};
prefix.strtype = 's';
prefix.num     = [1 Inf];
% ---------------------------------------------------------------------
% overwrite Overwrite existing Input/Output Files
% ---------------------------------------------------------------------
overwrite         = cfg_menu;
overwrite.tag     = 'overwrite';
overwrite.name    = 'Overwrite existing Input/Output Files';
overwrite.help    = {''};
overwrite.labels = {
                    'Yes'
                    'No'
}';
overwrite.values = {true false};
% ---------------------------------------------------------------------
% tbxvol_replace_slice Replace Slice
% ---------------------------------------------------------------------
cfg_tbxvol_replace_slice         = cfg_exbranch;
cfg_tbxvol_replace_slice.tag     = 'tbxvol_replace_slice';
cfg_tbxvol_replace_slice.name    = 'Replace Slice';
cfg_tbxvol_replace_slice.val     = {srcimg repslice prefix overwrite };
cfg_tbxvol_replace_slice.help    = {'No help available for topic ''tbxvol_replace_slice''.'};
cfg_tbxvol_replace_slice.prog = @tbxvol_replace_slice;
% ---------------------------------------------------------------------
% srcimgs Source Images
% ---------------------------------------------------------------------
srcimgs         = cfg_files;
srcimgs.tag     = 'srcimgs';
srcimgs.name    = 'Source Images';
srcimgs.help    = {''};
srcimgs.filter = 'image';
srcimgs.ufilter = '.*';
srcimgs.num     = [1 Inf];
% ---------------------------------------------------------------------
% scale New Scaling Factor
% ---------------------------------------------------------------------
scale         = cfg_entry;
scale.tag     = 'scale';
scale.name    = 'New Scaling Factor';
scale.help    = {'Set the new scaling factor. To determine this value from your image series, set this field to NaN.'};
scale.strtype = 'e';
scale.num     = [1 1];
% ---------------------------------------------------------------------
% offset New Intensity Offset
% ---------------------------------------------------------------------
offset         = cfg_entry;
offset.tag     = 'offset';
offset.name    = 'New Intensity Offset';
offset.help    = {''};
offset.strtype = 'e';
offset.num     = [1 1];
% ---------------------------------------------------------------------
% dtype Data Type
% ---------------------------------------------------------------------
dtype         = cfg_menu;
dtype.tag     = 'dtype';
dtype.name    = 'Data Type';
dtype.val{1} = double(0);
dtype.help    = {'Data-type of output images.  SAME indicates the same datatype as the original images.'};
dtype.labels = cellstr(char('SAME',spm_type(spm_type)));
dtype.values = num2cell([0 spm_type]);
% ---------------------------------------------------------------------
% prefix Output Filename Prefix
% ---------------------------------------------------------------------
prefix         = cfg_entry;
prefix.tag     = 'prefix';
prefix.name    = 'Output Filename Prefix';
prefix.val = {'S'};
prefix.help    = {'The output filename is constructed by prefixing the original filename with this prefix.'};
prefix.strtype = 's';
prefix.num     = [1 Inf];
% ---------------------------------------------------------------------
% overwrite Overwrite existing Input/Output Files
% ---------------------------------------------------------------------
overwrite         = cfg_menu;
overwrite.tag     = 'overwrite';
overwrite.name    = 'Overwrite existing Input/Output Files';
overwrite.help    = {''};
overwrite.labels = {
                    'Yes'
                    'No'
}';
overwrite.values = {true false};
% ---------------------------------------------------------------------
% tbxvol_rescale Rescale Images
% ---------------------------------------------------------------------
cfg_tbxvol_rescale         = cfg_exbranch;
cfg_tbxvol_rescale.tag     = 'tbxvol_rescale';
cfg_tbxvol_rescale.name    = 'Rescale Images';
cfg_tbxvol_rescale.val     = {srcimgs scale offset dtype prefix overwrite };
cfg_tbxvol_rescale.help    = {'No help available for topic ''tbxvol_rescale''.'};
cfg_tbxvol_rescale.prog = @tbxvol_rescale;
cfg_tbxvol_rescale.vout = @vout_tbxvol_rescale;
% ---------------------------------------------------------------------
% srcimgs Source Images
% ---------------------------------------------------------------------
srcimgs         = cfg_files;
srcimgs.tag     = 'srcimgs';
srcimgs.name    = 'Source Images';
srcimgs.help    = {''};
srcimgs.filter = 'image';
srcimgs.ufilter = '.*';
srcimgs.num     = [1 Inf];
% ---------------------------------------------------------------------
% oldscale Old intensity range
% ---------------------------------------------------------------------
oldscale         = cfg_entry;
oldscale.tag     = 'oldscale';
oldscale.name    = 'Old intensity range';
oldscale.help    = {'Original data intensity scaling. To derive min/max from the data, set the first or second entry to Inf.'};
oldscale.strtype = 'e';
oldscale.num     = [1 2];
% ---------------------------------------------------------------------
% newscale New intensity range
% ---------------------------------------------------------------------
newscale         = cfg_entry;
newscale.tag     = 'newscale';
newscale.name    = 'New intensity range';
newscale.help    = {'Set min/max value for new intensity range.'};
newscale.strtype = 'e';
newscale.num     = [1 2];
% ---------------------------------------------------------------------
% prefix Output Filename Prefix
% ---------------------------------------------------------------------
prefix         = cfg_entry;
prefix.tag     = 'prefix';
prefix.name    = 'Output Filename Prefix';
prefix.val = {'S'};
prefix.help    = {'The output filename is constructed by prefixing the original filename with this prefix.'};
prefix.strtype = 's';
prefix.num     = [1 Inf];
% ---------------------------------------------------------------------
% tbxvol_rescale_min_max Rescale Images to [min max]
% ---------------------------------------------------------------------
cfg_tbxvol_rescale_min_max         = cfg_exbranch;
cfg_tbxvol_rescale_min_max.tag     = 'tbxvol_rescale_min_max';
cfg_tbxvol_rescale_min_max.name    = 'Rescale Images to [min max]';
cfg_tbxvol_rescale_min_max.val     = {srcimgs oldscale newscale prefix };
cfg_tbxvol_rescale_min_max.help    = {'No help available for topic ''tbxvol_rescale_min_max''.'};
cfg_tbxvol_rescale_min_max.prog = @tbxvol_rescale_min_max;
cfg_tbxvol_rescale_min_max.vout = @vout_tbxvol_rescale_min_max;
% ---------------------------------------------------------------------
% srcimgs Source Images
% ---------------------------------------------------------------------
srcimgs         = cfg_files;
srcimgs.tag     = 'srcimgs';
srcimgs.name    = 'Source Images';
srcimgs.help    = {''};
srcimgs.filter = 'image';
srcimgs.ufilter = '.*';
srcimgs.num     = [1 Inf];
% ---------------------------------------------------------------------
% cor_orig Correct Origin of Wrapped Images
% ---------------------------------------------------------------------
cor_orig         = cfg_menu;
cor_orig.tag     = 'cor_orig';
cor_orig.name    = 'Correct Origin of Wrapped Images';
cor_orig.help    = {''};
cor_orig.labels = {
                   'Yes'
                   'No'
}';
cor_orig.values = {true false};
% ---------------------------------------------------------------------
% npix #pixels to Unwrap
% ---------------------------------------------------------------------
npix         = cfg_entry;
npix.tag     = 'npix';
npix.name    = '#pixels to Unwrap';
npix.help    = {''};
npix.strtype = 'i';
npix.num     = [1 1];
% ---------------------------------------------------------------------
% wrapdir Wrap Direction (Voxel Space)
% ---------------------------------------------------------------------
wrapdir         = cfg_menu;
wrapdir.tag     = 'wrapdir';
wrapdir.name    = 'Wrap Direction (Voxel Space)';
wrapdir.help    = {''};
wrapdir.labels = {
                  'X'
                  'Y'
                  'Z'
}';
wrapdir.values = {1 2 3};
% ---------------------------------------------------------------------
% prefix Output Filename Prefix
% ---------------------------------------------------------------------
prefix         = cfg_entry;
prefix.tag     = 'prefix';
prefix.name    = 'Output Filename Prefix';
prefix.val = {'U'};
prefix.help    = {'The output filename is constructed by prefixing the original filename with this prefix.'};
prefix.strtype = 's';
prefix.num     = [1 Inf];
% ---------------------------------------------------------------------
% overwrite Overwrite existing Input/Output Files
% ---------------------------------------------------------------------
overwrite         = cfg_menu;
overwrite.tag     = 'overwrite';
overwrite.name    = 'Overwrite existing Input/Output Files';
overwrite.help    = {''};
overwrite.labels = {
                    'Yes'
                    'No'
}';
overwrite.values = {true false};
% ---------------------------------------------------------------------
% tbxvol_unwrap Unwrap Volumes
% ---------------------------------------------------------------------
cfg_tbxvol_unwrap         = cfg_exbranch;
cfg_tbxvol_unwrap.tag     = 'tbxvol_unwrap';
cfg_tbxvol_unwrap.name    = 'Unwrap Volumes';
cfg_tbxvol_unwrap.val     = {srcimgs cor_orig npix wrapdir prefix overwrite };
cfg_tbxvol_unwrap.help    = {'No help available for topic ''tbxvol_unwrap''.'};
cfg_tbxvol_unwrap.prog = @tbxvol_unwrap;
% ---------------------------------------------------------------------
% tbxvol_list_max List Local Maxima
% ---------------------------------------------------------------------
cfg_tbxvol_list_max         = cfg_exbranch;
cfg_tbxvol_list_max.tag     = 'tbxvol_list_max';
cfg_tbxvol_list_max.name    = 'List Local Maxima';
cfg_tbxvol_list_max.val     = {srcimgs };
cfg_tbxvol_list_max.help    = {'No help available for topic ''tbxvol_list_max''.'};
cfg_tbxvol_list_max.prog = @tbxvol_list_max;
% ---------------------------------------------------------------------
% interp Interpolation
% ---------------------------------------------------------------------
interp         = cfg_menu;
interp.tag     = 'interp';
interp.name    = 'Interpolation';
interp.help    = {''};
interp.labels = {
                 'Integrate (Downsampling only)'
                 'Nearest neighbour'
                 'Trilinear'
                 '2nd Degree b-Spline'
                 '3rd Degree b-Spline'
                 '4th Degree b-Spline'
                 '5th Degree b-Spline'
                 '6th Degree b-Spline'
                 '7th Degree b-Spline'
                 '2nd Degree Sinc'
                 '3rd Degree Sinc'
                 '4th Degree Sinc'
                 '5th Degree Sinc'
                 '6th Degree Sinc'
                 '7th Degree Sinc'
}';
interp.values = {NaN 0 1 2 3 4 5 6 7 -2 -3 -4 -5 -6 -7};
% ---------------------------------------------------------------------
% ndim New Image Dimensions
% ---------------------------------------------------------------------
ndim         = cfg_entry;
ndim.tag     = 'ndim';
ndim.name    = 'New Image Dimensions (voxels)';
ndim.help    = {'The new image will have the specified matrix size and number of slices.'};
ndim.strtype = 'i';
ndim.num     = [1 3];
% ---------------------------------------------------------------------
% vxsz New Voxel Size
% ---------------------------------------------------------------------
vxsz         = cfg_entry;
vxsz.tag     = 'vxsz';
vxsz.name    = 'New Voxel Size (mm)';
vxsz.help    = {'The new image will have the specified voxel size.'};
vxsz.strtype = 'r';
vxsz.num     = [1 3];
% ---------------------------------------------------------------------
% vxsc Voxel Size Scaling
% ---------------------------------------------------------------------
vxsc         = cfg_entry;
vxsc.tag     = 'vxsc';
vxsc.name    = 'Voxel Size Scaling';
vxsc.help    = {'The voxel size in the new image will be the original size multiplied by these scaling factors.'};
vxsc.strtype = 'r';
vxsc.num     = [1 3];
% ---------------------------------------------------------------------
% sctype Resampling Specification
% ---------------------------------------------------------------------
sctype        = cfg_choice;
sctype.tag    = 'sctype';
sctype.name   = 'Resampling Specification';
sctype.help   = {''};
sctype.values = {ndim vxsz vxsc};
% ---------------------------------------------------------------------
% prefix Output Filename Prefix
% ---------------------------------------------------------------------
prefix         = cfg_entry;
prefix.tag     = 'prefix';
prefix.name    = 'Output Filename Prefix';
prefix.val = {'r'};
prefix.help    = {'The output filename is constructed by prefixing the original filename with this prefix.'};
prefix.strtype = 's';
prefix.num     = [1 Inf];
% ---------------------------------------------------------------------
% tbxvol_regrid Regrid Volumes
% ---------------------------------------------------------------------
cfg_tbxvol_regrid         = cfg_exbranch;
cfg_tbxvol_regrid.tag     = 'tbxvol_regrid';
cfg_tbxvol_regrid.name    = 'Regrid Volumes';
cfg_tbxvol_regrid.val     = {srcimgs interp sctype dtype prefix};
cfg_tbxvol_regrid.help    = {'No help available for topic ''tbxvol_regrid''.'};
cfg_tbxvol_regrid.prog = @tbxvol_regrid;
cfg_tbxvol_regrid.vout = @vout_tbxvol_regrid;
% ---------------------------------------------------------------------
% Single_Volumes Single Volumes
% ---------------------------------------------------------------------
Single_Volumes         = cfg_choice;
Single_Volumes.tag     = 'Single_Volumes';
Single_Volumes.name    = 'Single Volumes';
Single_Volumes.help    = {''};
Single_Volumes.values  = {cfg_tbxvol_extract cfg_tbxvol_flip cfg_tbxvol_get_integrals cfg_tbxvol_histogramm cfg_tbxvol_interleave cfg_tbxvol_replace_slice cfg_tbxvol_rescale cfg_tbxvol_rescale_min_max cfg_tbxvol_unwrap cfg_tbxvol_list_max cfg_tbxvol_regrid};
% ---------------------------------------------------------------------
% srcspm Source SPM.mat
% ---------------------------------------------------------------------
srcspm         = cfg_files;
srcspm.tag     = 'srcspm';
srcspm.name    = 'Source SPM.mat';
srcspm.help    = {''};
srcspm.filter = 'mat';
srcspm.ufilter = '.*SPM.*\.mat';
srcspm.num     = [1 1];
% ---------------------------------------------------------------------
% nfactor # of Factor with unequal Variance
% ---------------------------------------------------------------------
nfactor         = cfg_menu;
nfactor.tag     = 'nfactor';
nfactor.name    = '# of Factor with unequal Variance';
nfactor.help    = {''};
nfactor.labels = {
                  'Factor 1'
                  'Factor 2'
                  'Factor 3'
}';
nfactor.values = {2 3 4};
% ---------------------------------------------------------------------
% tbxvol_correct_ec_SPM Correct Error Covariance components
% ---------------------------------------------------------------------
cfg_tbxvol_correct_ec_SPM         = cfg_exbranch;
cfg_tbxvol_correct_ec_SPM.tag     = 'tbxvol_correct_ec_SPM';
cfg_tbxvol_correct_ec_SPM.name    = 'Correct Error Covariance components';
cfg_tbxvol_correct_ec_SPM.val     = {srcspm nfactor };
cfg_tbxvol_correct_ec_SPM.help    = {'No help available for topic ''tbxvol_correct_ec_SPM''.'};
cfg_tbxvol_correct_ec_SPM.prog = @tbxvol_correct_ec_SPM;
% ---------------------------------------------------------------------
% srcimgs Source Images
% ---------------------------------------------------------------------
srcimgs         = cfg_files;
srcimgs.tag     = 'srcimgs';
srcimgs.name    = 'Source Images';
srcimgs.help    = {''};
srcimgs.filter = 'image';
srcimgs.ufilter = '.*';
srcimgs.num     = [1 Inf];
% ---------------------------------------------------------------------
% voxsz Output Image Voxel Size
% ---------------------------------------------------------------------
voxsz         = cfg_entry;
voxsz.tag     = 'voxsz';
voxsz.name    = 'Output Image Voxel Size';
voxsz.help    = {''};
voxsz.strtype = 'e';
voxsz.num     = [1 3];
% ---------------------------------------------------------------------
% interp Interpolation
% ---------------------------------------------------------------------
interp         = cfg_menu;
interp.tag     = 'interp';
interp.name    = 'Interpolation';
interp.help    = {''};
interp.labels = {
                 'Nearest neighbour'
                 'Trilinear'
                 '2nd Degree b-Spline'
                 '3rd Degree b-Spline'
                 '4th Degree b-Spline'
                 '5th Degree b-Spline'
                 '6th Degree b-Spline'
                 '7th Degree b-Spline'
                 '2nd Degree Sinc'
                 '3rd Degree Sinc'
                 '4th Degree Sinc'
                 '5th Degree Sinc'
                 '6th Degree Sinc'
                 '7th Degree Sinc'
}';
interp.values = {0 1 2 3 4 5 6 7 -2 -3 -4 -5 -6 -7};
% ---------------------------------------------------------------------
% dtype Data Type
% ---------------------------------------------------------------------
dtype         = cfg_menu;
dtype.tag     = 'dtype';
dtype.name    = 'Data Type';
dtype.val{1} = double(0);
dtype.help    = {'Data-type of output images.  SAME indicates the same datatype as the original images.'};
dtype.labels = cellstr(char('SAME',spm_type(spm_type)));
dtype.values = num2cell([0 spm_type]);
% ---------------------------------------------------------------------
% prefix Output Filename Prefix
% ---------------------------------------------------------------------
prefix         = cfg_entry;
prefix.tag     = 'prefix';
prefix.name    = 'Output Filename Prefix';
prefix.val = {'C'};
prefix.help    = {'The output filename is constructed by prefixing the original filename with this prefix.'};
prefix.strtype = 's';
prefix.num     = [1 Inf];
% ---------------------------------------------------------------------
% tbxvol_combine Combine Volumes
% ---------------------------------------------------------------------
cfg_tbxvol_combine         = cfg_exbranch;
cfg_tbxvol_combine.tag     = 'tbxvol_combine';
cfg_tbxvol_combine.name    = 'Combine Volumes';
cfg_tbxvol_combine.val     = {srcimgs voxsz interp dtype prefix };
cfg_tbxvol_combine.help    = {'No help available for topic ''tbxvol_combine''.'};
cfg_tbxvol_combine.prog = @tbxvol_combine;
% ---------------------------------------------------------------------
% srcimg Mask Image
% ---------------------------------------------------------------------
srcimg         = cfg_files;
srcimg.tag     = 'srcimg';
srcimg.name    = 'Mask Image';
srcimg.help    = {''};
srcimg.filter = 'image';
srcimg.ufilter = '.*';
srcimg.num     = [1 1];
% ---------------------------------------------------------------------
% srcimgs Source Images for New Mask
% ---------------------------------------------------------------------
srcimgs         = cfg_files;
srcimgs.tag     = 'srcimgs';
srcimgs.name    = 'Source Images for New Mask';
srcimgs.help    = {''};
srcimgs.filter = 'image';
srcimgs.ufilter = '.*';
srcimgs.num     = [1 Inf];
% ---------------------------------------------------------------------
% maskpredef AND
% ---------------------------------------------------------------------
maskpredef         = cfg_const;
maskpredef.tag     = 'maskpredef';
maskpredef.name    = 'AND';
maskpredef.val = {'and'};
maskpredef.help    = {'Mask expression ''(i1~=0) & ... & (iN ~= 0)'''};
% ---------------------------------------------------------------------
% maskpredef OR
% ---------------------------------------------------------------------
maskpredef1         = cfg_const;
maskpredef1.tag     = 'maskpredef';
maskpredef1.name    = 'OR';
maskpredef1.val = {'or'};
maskpredef1.help    = {'Mask expression ''(i1~=0) | ... | (iN ~= 0)'''};
% ---------------------------------------------------------------------
% maskpredef NAND
% ---------------------------------------------------------------------
maskpredef2         = cfg_const;
maskpredef2.tag     = 'maskpredef';
maskpredef2.name    = 'NAND';
maskpredef2.val = {'nand'};
maskpredef2.help    = {'Mask expression ''~((i1~=0) & ... & (iN ~= 0))'''};
% ---------------------------------------------------------------------
% maskpredef NOR
% ---------------------------------------------------------------------
maskpredef3         = cfg_const;
maskpredef3.tag     = 'maskpredef';
maskpredef3.name    = 'NOR';
maskpredef3.val = {'nor'};
maskpredef3.help    = {'Mask expression ''~((i1~=0) | ... | (iN ~= 0))'''};
% ---------------------------------------------------------------------
% maskcustom Custom Mask Expression
% ---------------------------------------------------------------------
maskcustom         = cfg_entry;
maskcustom.tag     = 'maskcustom';
maskcustom.name    = 'Custom Mask Expression';
maskcustom.help    = {'Enter a valid expression for spm_imcalc.'};
maskcustom.strtype = 's';
maskcustom.num     = [1 Inf];
% ---------------------------------------------------------------------
% mtype Mask Type
% ---------------------------------------------------------------------
mtype         = cfg_choice;
mtype.tag     = 'mtype';
mtype.name    = 'Mask Type';
mtype.help    = {''};
mtype.values  = {maskpredef maskpredef1 maskpredef2 maskpredef3 maskcustom };
% ---------------------------------------------------------------------
% swd Output directory
% ---------------------------------------------------------------------
swd         = cfg_files;
swd.tag     = 'swd';
swd.name    = 'Output directory';
swd.help    = {'Files produced by this function will be written into this output directory'};
swd.filter = 'dir';
swd.ufilter = '.*';
swd.num     = [1 1];
% ---------------------------------------------------------------------
% fname Output Filename
% ---------------------------------------------------------------------
fname         = cfg_entry;
fname.tag     = 'fname';
fname.name    = 'Output Filename';
fname.val = {'output.img'};
fname.help    = {'The output image is written to the selected working directory.'};
fname.strtype = 's';
fname.num     = [1 Inf];
% ---------------------------------------------------------------------
% outimg Mask Image Name & Directory
% ---------------------------------------------------------------------
outimg         = cfg_branch;
outimg.tag     = 'outimg';
outimg.name    = 'Mask Image Name & Directory';
outimg.val     = {swd fname };
outimg.help    = {'Specify a output filename and target directory.'};
% ---------------------------------------------------------------------
% maskdef Create New Mask
% ---------------------------------------------------------------------
maskdef         = cfg_branch;
maskdef.tag     = 'maskdef';
maskdef.name    = 'Create New Mask';
maskdef.val     = {srcimgs mtype outimg };
maskdef.help    = {''};
% ---------------------------------------------------------------------
% centers Sphere Centers
% ---------------------------------------------------------------------
centers         = cfg_entry;
centers.tag     = 'centers';
centers.name    = 'Sphere Centers';
centers.help    = {['Enter the coordinates of the ROI centers in voxel ' ...
                    'space of the reference image.']};
centers.strtype = 'e';
centers.num     = [Inf 3];
% ---------------------------------------------------------------------
% radii Radii
% ---------------------------------------------------------------------
radii         = cfg_entry;
radii.tag     = 'radii';
radii.name    = 'Radii';
radii.help    = {['Enter the radii (in mm). ' ...
                  'Enter either one radius for all spheres or one per ROI.']};
radii.strtype = 'e';
radii.num     = [Inf 1];
% ---------------------------------------------------------------------
% refimg Mask Image
% ---------------------------------------------------------------------
refimg         = cfg_files;
refimg.tag     = 'refimg';
refimg.name    = 'Reference Image';
refimg.help    = {['The masks will be created with orientation and voxel ' ...
                   'size of this image.']};
refimg.filter = 'image';
refimg.ufilter = '.*';
refimg.num     = [1 1];
% ---------------------------------------------------------------------
% spheres Create Masks from Coordinates
% ---------------------------------------------------------------------
spheres         = cfg_branch;
spheres.tag     = 'spheres';
spheres.name    = 'Create Masks from Coordinates';
spheres.val     = {centers radii refimg outimg};
spheres.check   = @(job)tbxvol_create_mask('check',job,'spheres');
% ---------------------------------------------------------------------
% maskspec Mask Specification
% ---------------------------------------------------------------------
maskspec         = cfg_choice;
maskspec.tag     = 'maskspec';
maskspec.name    = 'Mask Specification';
maskspec.help    = {
                    'Specify an existing mask image or a set of images '
                    'that will be used to create a mask image.'
}';
maskspec.values  = {srcimg maskdef spheres };
% ---------------------------------------------------------------------
% srcimgs Source Images
% ---------------------------------------------------------------------
srcimgs         = cfg_files;
srcimgs.tag     = 'srcimgs';
srcimgs.name    = 'Source Images';
srcimgs.help    = {''};
srcimgs.filter = 'image';
srcimgs.ufilter = '.*';
srcimgs.num     = [1 Inf];
% ---------------------------------------------------------------------
% scope Scope of Mask
% ---------------------------------------------------------------------
scope         = cfg_menu;
scope.tag     = 'scope';
scope.name    = 'Scope of Mask';
scope.help    = {'Specify which parts of the images should be kept: parts where the mask image is different from zero (inclusive) or parts where the mask image is zero (exclusive).'};
scope.labels = {
                'Inclusive'
                'Exclusive'
}';
scope.values = {
                'i'
                'e'
}';
% ---------------------------------------------------------------------
% space Space of Masked Images
% ---------------------------------------------------------------------
space         = cfg_menu;
space.tag     = 'space';
space.name    = 'Space of Masked Images';
space.help    = {'Specify whether the masked images should be written with orientation and voxel size of the original images or of the mask image.'};
space.labels = {
                'Object'
                'Mask'
}';
space.values = {
                'object'
                'mask'
}';
% ---------------------------------------------------------------------
% prefix Output Filename Prefix
% ---------------------------------------------------------------------
prefix         = cfg_entry;
prefix.tag     = 'prefix';
prefix.name    = 'Output Filename Prefix';
prefix.val = {'M'};
prefix.help    = {'The output filename is constructed by prefixing the original filename with this prefix.'};
prefix.strtype = 's';
prefix.num     = [1 Inf];
% ---------------------------------------------------------------------
% interp Interpolation
% ---------------------------------------------------------------------
interp         = cfg_menu;
interp.tag     = 'interp';
interp.name    = 'Interpolation';
interp.help    = {''};
interp.labels = {
                 'Nearest neighbour'
                 'Trilinear'
                 '2nd Degree b-Spline'
                 '3rd Degree b-Spline'
                 '4th Degree b-Spline'
                 '5th Degree b-Spline'
                 '6th Degree b-Spline'
                 '7th Degree b-Spline'
                 '2nd Degree Sinc'
                 '3rd Degree Sinc'
                 '4th Degree Sinc'
                 '5th Degree Sinc'
                 '6th Degree Sinc'
                 '7th Degree Sinc'
}';
interp.values = {0 1 2 3 4 5 6 7 -2 -3 -4 -5 -6 -7};
% ---------------------------------------------------------------------
% nanmask Zero/NaN Masking
% ---------------------------------------------------------------------
nanmask         = cfg_menu;
nanmask.tag     = 'nanmask';
nanmask.name    = 'Zero/NaN Masking';
nanmask.help    = {'For data types without a representation of NaN, implicit zero masking assummes that all zero voxels are to be treated as missing, and treats them as NaN. NaN''s are written as zero (by spm_write_plane), for data types without a representation of NaN.'};
nanmask.labels = {
                  'No implicit zero mask'
                  'Implicit zero mask'
                  'NaNs should be zeroed'
}';
nanmask.values = {0 1 -1};
% ---------------------------------------------------------------------
% maskthresh Threshold for masking
% ---------------------------------------------------------------------
maskthresh         = cfg_entry;
maskthresh.tag     = 'maskthresh';
maskthresh.name    = 'Threshold for masking';
maskthresh.help    = {'Sometimes zeroes are represented as non-zero values due to rounding errors (especially in binary masks). Specify a small non-zero value for zero masking in this case.'};
maskthresh.strtype = 'e';
maskthresh.num     = [1 1];
% ---------------------------------------------------------------------
% overwrite Overwrite existing Input/Output Files
% ---------------------------------------------------------------------
overwrite         = cfg_menu;
overwrite.tag     = 'overwrite';
overwrite.name    = 'Overwrite existing Input/Output Files';
overwrite.help    = {''};
overwrite.labels = {
                    'Yes'
                    'No'
}';
overwrite.values = {true false};
% ---------------------------------------------------------------------
% srcspec Apply Created Mask
% ---------------------------------------------------------------------
srcspec         = cfg_branch;
srcspec.tag     = 'srcspec';
srcspec.name    = 'Apply Created Mask';
srcspec.val     = {srcimgs scope space prefix interp nanmask maskthresh overwrite };
srcspec.help    = {'Specify images which are to be masked.'};
% ---------------------------------------------------------------------
% unused Apply Masks
% ---------------------------------------------------------------------
unused         = cfg_repeat;
unused.tag     = 'unused';
unused.name    = 'Apply Masks';
unused.help    = {''};
unused.values  = {srcspec };
unused.num     = [0 Inf];
% ---------------------------------------------------------------------
% tbxvol_create_mask Create and Apply Masks
% ---------------------------------------------------------------------
cfg_tbxvol_create_mask         = cfg_exbranch;
cfg_tbxvol_create_mask.tag     = 'tbxvol_create_mask';
cfg_tbxvol_create_mask.name    = 'Create and Apply Masks';
cfg_tbxvol_create_mask.val     = {maskspec unused };
cfg_tbxvol_create_mask.help    = {'No help available for topic ''tbxvol_create_mask''.'};
cfg_tbxvol_create_mask.prog = @(job)tbxvol_create_mask('run',job);
cfg_tbxvol_create_mask.vout = @(job)tbxvol_create_mask('vout',job);
% ---------------------------------------------------------------------
% srcimgs Source Images
% ---------------------------------------------------------------------
srcimgs         = cfg_files;
srcimgs.tag     = 'srcimgs';
srcimgs.name    = 'Source Images';
srcimgs.help    = {''};
srcimgs.filter = 'image';
srcimgs.ufilter = '.*';
srcimgs.num     = [1 Inf];
% ---------------------------------------------------------------------
% bbox Bounding Box for Extracted Image
% ---------------------------------------------------------------------
bbox         = cfg_entry;
bbox.tag     = 'bbox';
bbox.name    = 'Bounding Box for Extracted Image';
bbox.help    = {
                'Specify the bounding box in voxel coordinates of '
                'the original image: X1 X2 Y1 Y2 Z1 Z2.'
}';
bbox.strtype = 'i';
bbox.num     = [1 6];
% ---------------------------------------------------------------------
% prefix Output Filename Prefix
% ---------------------------------------------------------------------
prefix         = cfg_entry;
prefix.tag     = 'prefix';
prefix.name    = 'Output Filename Prefix';
prefix.val = {'E'};
prefix.help    = {'The output filename is constructed by prefixing the original filename with this prefix.'};
prefix.strtype = 's';
prefix.num     = [1 Inf];
% ---------------------------------------------------------------------
% tbxvol_extract_subvol Extract Subvolume
% ---------------------------------------------------------------------
cfg_tbxvol_extract_subvol         = cfg_exbranch;
cfg_tbxvol_extract_subvol.tag     = 'tbxvol_extract_subvol';
cfg_tbxvol_extract_subvol.name    = 'Extract Subvolume';
cfg_tbxvol_extract_subvol.val     = {srcimgs bbox prefix };
cfg_tbxvol_extract_subvol.help    = {'No help available for topic ''tbxvol_extract_subvol''.'};
cfg_tbxvol_extract_subvol.prog = @tbxvol_extract_subvol;
% ---------------------------------------------------------------------
% source Source Images
% ---------------------------------------------------------------------
source         = cfg_files;
source.tag     = 'source';
source.name    = 'Source Images';
source.help    = {'The images that are warped to match the template(s).  The result is a set of warps, which can be applied to this image, or any other image that is in register with it.'};
source.filter = 'image';
source.ufilter = '.*';
source.num     = [1 Inf];
% ---------------------------------------------------------------------
% wtsrc Source Weighting Image
% ---------------------------------------------------------------------
wtsrc         = cfg_files;
wtsrc.tag     = 'wtsrc';
wtsrc.name    = 'Source Weighting Image';
wtsrc.val{1} = {};
wtsrc.help    = {'Optional weighting images (consisting of pixel values between the range of zero to one) to be used for registering abnormal or lesioned brains.  These images should match the dimensions of the image from which the parameters are estimated, and should contain zeros corresponding to regions of abnormal tissue.'};
wtsrc.filter = 'image';
wtsrc.ufilter = '.*';
wtsrc.num     = [0 1];
% ---------------------------------------------------------------------
% subj Subjects
% ---------------------------------------------------------------------
subj         = cfg_branch;
subj.tag     = 'subj';
subj.name    = 'Subjects';
subj.val     = {source wtsrc };
subj.help    = {'Data for all subjects.  The same parameters are used within subject.'};
% ---------------------------------------------------------------------
% template Template Image
% ---------------------------------------------------------------------
template         = cfg_files;
template.tag     = 'template';
template.name    = 'Template Image';
template.help    = {
                    'Specify a template image to match the source image with. The contrast in the template must be similar to that of the source image in order to achieve a good registration.  It is also possible to select more than one template, in which case the registration algorithm will try to find the best linear combination of these images in order to best model the intensities in the source image.'
                    ''
                    'The template(s) will be used for the first iteration of within-group normalisation. Further iterations will use an average version of the normalised images as template.'
}';
template.filter = 'image';
template.ufilter = '.*';
template.num     = [1 Inf];
% ---------------------------------------------------------------------
% weight Template Weighting Image
% ---------------------------------------------------------------------
weight         = cfg_files;
weight.tag     = 'weight';
weight.name    = 'Template Weighting Image';
weight.help    = {
                  'Applies a weighting mask to the template(s) during the parameter estimation.  With the default brain mask, weights in and around the brain have values of one whereas those clearly outside the brain are zero.  This is an attempt to base the normalization purely upon the shape of the brain, rather than the shape of the head (since low frequency basis functions can not really cope with variations in skull thickness).'
                  ''
                  'The option is now available for a user specified weighting image. This should have the same dimensions and mat file as the template images, with values in the range of zero to one.'
}';
weight.filter = 'image';
weight.ufilter = '.*';
weight.num     = [0 1];
% ---------------------------------------------------------------------
% stempl Initial normalisation template
% ---------------------------------------------------------------------
stempl         = cfg_branch;
stempl.tag     = 'stempl';
stempl.name    = 'Initial normalisation template';
stempl.val     = {template weight };
stempl.help    = {''};
% ---------------------------------------------------------------------
% sparams Initial normalisation params
% ---------------------------------------------------------------------
sparams         = cfg_files;
sparams.tag     = 'sparams';
sparams.name    = 'Initial normalisation params';
sparams.help    = {''};
sparams.filter = 'mat';
sparams.ufilter = '.*sn.mat$';
sparams.num     = [0 Inf];
% ---------------------------------------------------------------------
% starting Initial Normalisation
% ---------------------------------------------------------------------
starting         = cfg_choice;
starting.tag     = 'starting';
starting.name    = 'Initial Normalisation';
starting.help    = {''};
starting.values  = {stempl sparams };
% ---------------------------------------------------------------------
% smosrc Source Image Smoothing
% ---------------------------------------------------------------------
smosrc         = cfg_entry;
smosrc.tag     = 'smosrc';
smosrc.name    = 'Source Image Smoothing';
smosrc.help    = {'Smoothing to apply to a copy of the source image. The template and source images should have approximately the same smoothness. Remember that the templates supplied with SPM have been smoothed by 8mm, and that smoothnesses combine by Pythagoras'' rule.'};
smosrc.strtype = 'e';
smosrc.num     = [1 1];
% ---------------------------------------------------------------------
% smoref Template Image Smoothing
% ---------------------------------------------------------------------
smoref         = cfg_entry;
smoref.tag     = 'smoref';
smoref.name    = 'Template Image Smoothing';
smoref.help    = {'Smoothing to apply to a copy of the template image. The template and source images should have approximately the same smoothness. Remember that the templates supplied with SPM have been smoothed by 8mm, and that smoothnesses combine by Pythagoras'' rule.'};
smoref.strtype = 'e';
smoref.num     = [1 1];
% ---------------------------------------------------------------------
% regtype Affine Regularisation
% ---------------------------------------------------------------------
regtype         = cfg_menu;
regtype.tag     = 'regtype';
regtype.name    = 'Affine Regularisation';
regtype.help    = {'Affine registration into a standard space can be made more robust by regularisation (penalising excessive stretching or shrinking).  The best solutions can be obtained by knowing the approximate amount of stretching that is needed (e.g. ICBM templates are slightly bigger than typical brains, so greater zooms are likely to be needed). If registering to an image in ICBM/MNI space, then choose the first option.  If registering to a template that is close in size, then select the second option.  If you do not want to regularise, then choose the third.'};
regtype.labels = {
                  'ICBM space template'
                  'Average sized template'
                  'No regularisation'
}';
regtype.values = {
                  'mni'
                  'subj'
                  'none'
}';
% ---------------------------------------------------------------------
% cutoff Nonlinear Frequency Cutoff
% ---------------------------------------------------------------------
cutoff         = cfg_entry;
cutoff.tag     = 'cutoff';
cutoff.name    = 'Nonlinear Frequency Cutoff';
cutoff.help    = {'Cutoff of DCT bases.  Only DCT bases of periods longer than the cutoff are used to describe the warps. The number used will depend on the cutoff and the field of view of the template image(s).'};
cutoff.strtype = 'e';
cutoff.num     = [1 1];
% ---------------------------------------------------------------------
% nits Nonlinear Iterations
% ---------------------------------------------------------------------
nits         = cfg_entry;
nits.tag     = 'nits';
nits.name    = 'Nonlinear Iterations';
nits.help    = {'Number of iterations of nonlinear warping performed.'};
nits.strtype = 'w';
nits.num     = [1 1];
% ---------------------------------------------------------------------
% reg Nonlinear Regularisation
% ---------------------------------------------------------------------
reg         = cfg_entry;
reg.tag     = 'reg';
reg.name    = 'Nonlinear Regularisation';
reg.help    = {'The amount of regularisation for the nonlinear part of the spatial normalisation. Pick a value around one.  However, if your normalized images appear distorted, then it may be an idea to increase the amount of regularization (by an order of magnitude) - or even just use an affine normalization. The regularization influences the smoothness of the deformation fields.'};
reg.strtype = 'e';
reg.num     = [1 1];
% ---------------------------------------------------------------------
% iteration Iteration Options
% ---------------------------------------------------------------------
iteration         = cfg_branch;
iteration.tag     = 'iteration';
iteration.name    = 'Iteration Options';
iteration.val     = {smosrc smoref regtype cutoff nits reg };
iteration.help    = {'Various settings for estimating warps.'};
% ---------------------------------------------------------------------
% iterations Estimation Iterations
% ---------------------------------------------------------------------
iterations         = cfg_repeat;
iterations.tag     = 'iterations';
iterations.name    = 'Estimation Iterations';
iterations.help    = {''};
iterations.values  = {iteration };
iterations.num     = [1 Inf];
% ---------------------------------------------------------------------
% eoptions Estimation Options
% ---------------------------------------------------------------------
eoptions         = cfg_branch;
eoptions.tag     = 'eoptions';
eoptions.name    = 'Estimation Options';
eoptions.val     = {starting iterations };
eoptions.help    = {''};
% ---------------------------------------------------------------------
% tbxvol_normalise Group Normalise
% ---------------------------------------------------------------------
cfg_tbxvol_normalise         = cfg_exbranch;
cfg_tbxvol_normalise.tag     = 'tbxvol_normalise';
cfg_tbxvol_normalise.name    = 'Group Normalise';
cfg_tbxvol_normalise.val     = {subj eoptions };
cfg_tbxvol_normalise.help    = {''};
cfg_tbxvol_normalise.prog = @tbxvol_normalise;
cfg_tbxvol_normalise.vfiles = @vfiles_tbxvol_normalise;
cfg_tbxvol_normalise.modality = {
                             'FMRI'
                             'PET'
                             'VBM'
}';
% ---------------------------------------------------------------------
% srcimgs Source Images
% ---------------------------------------------------------------------
srcimgs         = cfg_files;
srcimgs.tag     = 'srcimgs';
srcimgs.name    = 'Source Images';
srcimgs.help    = {''};
srcimgs.filter = 'image';
srcimgs.ufilter = '.*';
srcimgs.num     = [1 Inf];
% ---------------------------------------------------------------------
% sliceorder Slice/Volume Order
% ---------------------------------------------------------------------
sliceorder         = cfg_menu;
sliceorder.tag     = 'sliceorder';
sliceorder.name    = 'Slice/Volume Order';
sliceorder.help    = {''};
sliceorder.labels = {
                     'Vol1 Slice1..N,...VolM Slice1..N'
                     'VolM Slice1..N,...Vol1 Slice1..N'
                     'Slice1 Vol1..M,...SliceN Vol1..M'
                     'Slice1 VolM..1,...SliceN VolM..1'
}';
sliceorder.values = {
                     'volume'
                     'volume_vrev'
                     'slice'
                     'slice_vrev'
}';
% ---------------------------------------------------------------------
% noutput #Output Images
% ---------------------------------------------------------------------
noutput         = cfg_entry;
noutput.tag     = 'noutput';
noutput.name    = '#Output Images';
noutput.help    = {''};
noutput.strtype = 'i';
noutput.num     = [1 1];
% ---------------------------------------------------------------------
% thickcorr Correct Slice Thickness
% ---------------------------------------------------------------------
thickcorr         = cfg_menu;
thickcorr.tag     = 'thickcorr';
thickcorr.name    = 'Correct Slice Thickness';
thickcorr.help    = {'If set to ''yes'', the slice thickness is multiplied by the #output images.'};
thickcorr.labels = {
                    'Yes'
                    'No'
}';
thickcorr.values = {true false};
% ---------------------------------------------------------------------
% tbxvol_split Split Volumes
% ---------------------------------------------------------------------
cfg_tbxvol_split         = cfg_exbranch;
cfg_tbxvol_split.tag     = 'tbxvol_split';
cfg_tbxvol_split.name    = 'Split Volumes';
cfg_tbxvol_split.val     = {srcimgs sliceorder noutput thickcorr };
cfg_tbxvol_split.help    = {'No help available for topic ''tbxvol_split''.'};
cfg_tbxvol_split.prog = @tbxvol_split;
cfg_tbxvol_split.vfiles = @vfiles_tbxvol_split;
% ---------------------------------------------------------------------
% srcimgs Source Images
% ---------------------------------------------------------------------
srcimgs         = cfg_files;
srcimgs.tag     = 'srcimgs';
srcimgs.name    = 'Source Images';
srcimgs.help    = {''};
srcimgs.filter = 'image';
srcimgs.ufilter = '.*';
srcimgs.num     = [1 Inf];
% ---------------------------------------------------------------------
% spikethr Threshold (in standard deviations)
% ---------------------------------------------------------------------
spikethr         = cfg_entry;
spikethr.tag     = 'spikethr';
spikethr.name    = 'Threshold (in standard deviations)';
spikethr.help    = {''};
spikethr.strtype = 'e';
spikethr.num     = [1 1];
% ---------------------------------------------------------------------
% tbxvol_spike Detect abnormal slices
% ---------------------------------------------------------------------
cfg_tbxvol_spike         = cfg_exbranch;
cfg_tbxvol_spike.tag     = 'tbxvol_spike';
cfg_tbxvol_spike.name    = 'Detect abnormal slices';
cfg_tbxvol_spike.val     = {srcimgs spikethr };
cfg_tbxvol_spike.help    = {'No help available for topic ''tbxvol_spike''.'};
cfg_tbxvol_spike.prog = @tbxvol_spike;
% ---------------------------------------------------------------------                                                                                                                 
% srcimgs - Source Images                                                                                                                                                                 
% ---------------------------------------------------------------------                                                                                                                 
srcimgs         = cfg_files;                                                                                                                                                            
srcimgs.tag     = 'srcimgs';                                                                                                                                                            
srcimgs.name    = 'Source Images';                                                                                                                                                      
srcimgs.help    = {'A list of images to be analysed. The computed selection indices will refer to this list of images.'};                                                               
srcimgs.filter = 'image';                                                                                                                                                               
srcimgs.ufilter = '.*';                                                                                                                                                                 
srcimgs.num     = [1 Inf];                                                                                                                                                              
% ---------------------------------------------------------------------                                                                                                                 
% maskimg -  Mask Image                                                                                                                                                 
% ---------------------------------------------------------------------                                                                                                                 
maskimg         = cfg_files;                                                                                                                                                            
maskimg.tag     = 'maskimg';                                                                                                                                                            
maskimg.name    = 'Mask Image';                                                                                                                                                      
maskimg.help    = {'Each source image will be weighted by this mask image before thresholding.'
    'The mask image should have values between 0 (voxel does not belong to ROI) and 1 (voxel does belong to ROI). Fractional values are allowed.'};                                                               
maskimg.filter = 'image';                                                                                                                                                               
maskimg.ufilter = '.*';                                                                                                                                                                 
maskimg.num     = [1 1];                                                                                                                                                              
% ---------------------------------------------------------------------
% invert - Invert Mask
% ---------------------------------------------------------------------
invert        = cfg_menu;
invert.tag    = 'invert';
invert.name   = 'Invert Mask';
invert.help   = {'Yes: source images will be masked with (1-mask value).'
    'No: source images will be masked with (mask value).'};
invert.labels = {'Yes'; 'No'};
invert.values = {true; false};
% ---------------------------------------------------------------------
% masking - Mask Specification
% ---------------------------------------------------------------------
masking      = cfg_branch;
masking.tag  = 'masking';
masking.name = 'Mask Specification';
masking.val  = {maskimg invert};
% ---------------------------------------------------------------------
% thresh - Threshold
% ---------------------------------------------------------------------
thresh         = cfg_entry;
thresh.tag     = 'thresh';
thresh.name    = 'Intensity Threshold';
thresh.help    = {'Voxels with a value higher than this threshold will be counted as ''bad''.'};
thresh.strtype = 'r';
thresh.num     = [1 1];
% ---------------------------------------------------------------------
% ratio - Bad Voxels per Slice Ratio
% ---------------------------------------------------------------------
ratio         = cfg_entry;
ratio.tag     = 'ratio';
ratio.name    = 'Bad Voxels per Slice Ratio';
ratio.help    = {'If the ratio of ''bad'' voxels to inmask volume exceeds this ratio a slice will be marked ''bad'' and the volume will be discarded.'};
ratio.strtype = 'r';
ratio.num     = [1 1];
% ---------------------------------------------------------------------
% crit - Exclusion Criteria
% ---------------------------------------------------------------------
crit      = cfg_branch;
crit.tag  = 'crit';
crit.name = 'Exclusion Criteria';
crit.val  = {thresh ratio};
% ---------------------------------------------------------------------
% cfg_tbxvol_spike_mask - Detect Spikes in Mask
% ---------------------------------------------------------------------
cfg_tbxvol_spike_mask       = cfg_exbranch;
cfg_tbxvol_spike_mask.tag   = 'tbxvol_spike_mask';
cfg_tbxvol_spike_mask.name  = 'Detect Spikes in Mask';
cfg_tbxvol_spike_mask.val   = {srcimgs masking crit};
cfg_tbxvol_spike_mask.help  = {'A very crude method to detect spikes.' 
    ['Images will be weighted by the mask image or its inverse (1-mask). ', ... 
    'Afterwards, for each slice the number of voxels exceeding the ', ...
    'specified threshold will be counted. Images will be marked ''bad'' ', ...
    'if more than a specified percentage of voxels per slice exceed the threshold.']
    'This method is useful to detect rare spikes on a set of e.g. '
    'standard deviation images of a time series.'};
cfg_tbxvol_spike_mask.prog  = @(job)tbxvol_spike_mask('run', job);
cfg_tbxvol_spike_mask.vout  = @(job)tbxvol_spike_mask('vout', job);
% ---------------------------------------------------------------------
% srcimgs Images
% ---------------------------------------------------------------------
srcimgs         = cfg_files;
srcimgs.tag     = 'srcimgs';
srcimgs.name    = 'Images';
srcimgs.help    = {'These images will be read and their histogramms displayed.'};
srcimgs.filter = 'image';
srcimgs.ufilter = '.*';
srcimgs.num     = [1 Inf];
% ---------------------------------------------------------------------
% int Intensity Range
% ---------------------------------------------------------------------
int         = cfg_entry;
int.tag     = 'int';
int.name    = 'Intensity Range';
int.help    = {'The histogramm will only be created from voxels with intensities in this range.'};
int.strtype = 'r';
int.num     = [1  2];
% ---------------------------------------------------------------------
% hstart Image #s
% ---------------------------------------------------------------------
hstart         = cfg_entry;
hstart.tag     = 'hstart';
hstart.name    = 'Image #s';
hstart.help    = {'Image numbers (in the input image list) for which histogramms should be created.'};
hstart.strtype = 'n';
hstart.num     = [1  Inf];
% ---------------------------------------------------------------------
% hnum #Averages
% ---------------------------------------------------------------------
hnum         = cfg_entry;
hnum.tag     = 'hnum';
hnum.name    = '#Averages';
hnum.help    = {'The number of consecutive image to average in one histogramm.'};
hnum.strtype = 'n';
hnum.num     = [1  1];
% ---------------------------------------------------------------------
% nbins Histogramm timebins
% ---------------------------------------------------------------------
nbins         = cfg_entry;
nbins.tag     = 'nbins';
nbins.name    = 'Histogramm timebins';
nbins.strtype = 'n';
nbins.num     = [1  1];
% ---------------------------------------------------------------------
% holdhist Reference Histogramms
% ---------------------------------------------------------------------
holdhist         = cfg_menu;
holdhist.tag     = 'holdhist';
holdhist.name    = 'Reference Histogramms';
holdhist.labels = {
                   'First'
                   'Last'
                   'Both'
                   'None'
                   }';
holdhist.values = {
                   'first'
                   'last'
                   'both'
                   'none'
                   }';
% ---------------------------------------------------------------------
% cfg_tbxvol_histogramm_movie Histogramm movie
% ---------------------------------------------------------------------
cfg_tbxvol_histogramm_movie         = cfg_exbranch;
cfg_tbxvol_histogramm_movie.tag     = 'cfg_tbxvol_histogramm_movie';
cfg_tbxvol_histogramm_movie.name    = 'Histogramm movie';
cfg_tbxvol_histogramm_movie.val     = {srcimgs int hstart hnum nbins holdhist };
cfg_tbxvol_histogramm_movie.check   = @(job)tbxvol_histogramm_movie('check',job);
cfg_tbxvol_histogramm_movie.prog = @(job)tbxvol_histogramm_movie('run',job);
cfg_tbxvol_histogramm_movie.vout = @(job)tbxvol_histogramm_movie('vout',job);
% ---------------------------------------------------------------------
% Multiple_Volumes Multiple Volumes
% ---------------------------------------------------------------------
Multiple_Volumes         = cfg_choice;
Multiple_Volumes.tag     = 'Multiple_Volumes';
Multiple_Volumes.name    = 'Multiple Volumes';
Multiple_Volumes.help    = {''};
Multiple_Volumes.values  = {cfg_tbxvol_correct_ec_SPM cfg_tbxvol_combine cfg_tbxvol_create_mask cfg_tbxvol_extract_subvol cfg_tbxvol_normalise cfg_tbxvol_split cfg_tbxvol_spike cfg_tbxvol_spike_mask cfg_tbxvol_histogramm_movie cfg_tbxvol_gw_boundary};
% ---------------------------------------------------------------------
% srcspm Source SPM.mat
% ---------------------------------------------------------------------
srcspm         = cfg_files;
srcspm.tag     = 'srcspm';
srcspm.name    = 'Source SPM.mat';
srcspm.help    = {''};
srcspm.filter = 'mat';
srcspm.ufilter = '.*SPM.*\.mat';
srcspm.num     = [1 1];
% ---------------------------------------------------------------------
% newpath Path Component to be inserted
% ---------------------------------------------------------------------
newpath         = cfg_menu;
newpath.tag     = 'newpath';
newpath.name    = 'Path Component to be inserted';
newpath.help    = {
                   'The tool tries to quess which parts of the path names need to be replaced by comparing the path stored in SPM.swd with the current path to the SPM.mat file. '
                   'This does not always work as expected, confirmation before replacement is strongly advised.'
}';
newpath.labels = {
                  'Determine and insert'
                  'Ask before inserting'
}';
newpath.values = {
                  'auto'
                  'ask'
}';
% ---------------------------------------------------------------------
% oldpath Path Component to be replaced
% ---------------------------------------------------------------------
oldpath         = cfg_menu;
oldpath.tag     = 'oldpath';
oldpath.name    = 'Path Component to be replaced';
oldpath.help    = {
                   'The tool tries to guess which parts of the path names need to be replaced by comparing the path stored in SPM.swd with the current path to the SPM.mat file. '
                   'This does not always work as expected, confirmation before replacement is strongly advised.'
}';
oldpath.labels = {
                  'Determine and replace'
                  'Ask before replacing'
}';
oldpath.values = {
                  'auto'
                  'ask'
}';
% ---------------------------------------------------------------------
% dpaths Data Files
% ---------------------------------------------------------------------
dpaths         = cfg_branch;
dpaths.tag     = 'dpaths';
dpaths.name    = 'Data Files';
dpaths.val     = {newpath oldpath };
dpaths.help    = {''};
% ---------------------------------------------------------------------
% newpath Path Component to be inserted
% ---------------------------------------------------------------------
newpath         = cfg_menu;
newpath.tag     = 'newpath';
newpath.name    = 'Path Component to be inserted';
newpath.help    = {
                   'The tool tries to quess which parts of the path names need to be replaced by comparing the path stored in SPM.swd with the current path to the SPM.mat file. '
                   'This does not always work as expected, confirmation before replacement is strongly advised.'
}';
newpath.labels = {
                  'Determine and insert'
                  'Ask before inserting'
}';
newpath.values = {
                  'auto'
                  'ask'
}';
% ---------------------------------------------------------------------
% oldpath Path Component to be replaced
% ---------------------------------------------------------------------
oldpath         = cfg_menu;
oldpath.tag     = 'oldpath';
oldpath.name    = 'Path Component to be replaced';
oldpath.help    = {
                   'The tool tries to guess which parts of the path names need to be replaced by comparing the path stored in SPM.swd with the current path to the SPM.mat file. '
                   'This does not always work as expected, confirmation before replacement is strongly advised.'
}';
oldpath.labels = {
                  'Determine and replace'
                  'Ask before replacing'
}';
oldpath.values = {
                  'auto'
                  'ask'
}';
% ---------------------------------------------------------------------
% apaths Analysis Files
% ---------------------------------------------------------------------
apaths         = cfg_branch;
apaths.tag     = 'apaths';
apaths.name    = 'Analysis Files';
apaths.val     = {newpath oldpath };
apaths.help    = {''};
% ---------------------------------------------------------------------
% newpath Path Component to be inserted
% ---------------------------------------------------------------------
newpath         = cfg_menu;
newpath.tag     = 'newpath';
newpath.name    = 'Path Component to be inserted';
newpath.help    = {
                   'The tool tries to quess which parts of the path names need to be replaced by comparing the path stored in SPM.swd with the current path to the SPM.mat file. '
                   'This does not always work as expected, confirmation before replacement is strongly advised.'
}';
newpath.labels = {
                  'Determine and insert'
                  'Ask before inserting'
}';
newpath.values = {
                  'auto'
                  'ask'
}';
% ---------------------------------------------------------------------
% oldpath Path Component to be replaced
% ---------------------------------------------------------------------
oldpath         = cfg_menu;
oldpath.tag     = 'oldpath';
oldpath.name    = 'Path Component to be replaced';
oldpath.help    = {
                   'The tool tries to guess which parts of the path names need to be replaced by comparing the path stored in SPM.swd with the current path to the SPM.mat file. '
                   'This does not always work as expected, confirmation before replacement is strongly advised.'
}';
oldpath.labels = {
                  'Determine and replace'
                  'Ask before replacing'
}';
oldpath.values = {
                  'auto'
                  'ask'
}';
% ---------------------------------------------------------------------
% bpaths Data&Analysis Files
% ---------------------------------------------------------------------
bpaths         = cfg_branch;
bpaths.tag     = 'bpaths';
bpaths.name    = 'Data&Analysis Files';
bpaths.val     = {newpath oldpath };
bpaths.help    = {''};
% ---------------------------------------------------------------------
% npaths None
% ---------------------------------------------------------------------
npaths         = cfg_const;
npaths.tag     = 'npaths';
npaths.name    = 'None';
npaths.val{1} = double(0);
npaths.help    = {''};
% ---------------------------------------------------------------------
% chpaths Paths to change
% ---------------------------------------------------------------------
chpaths         = cfg_choice;
chpaths.tag     = 'chpaths';
chpaths.name    = 'Paths to change';
chpaths.help    = {''};
chpaths.values  = {dpaths apaths bpaths npaths };
% ---------------------------------------------------------------------
% swap Change Byte Order Information for Mapped Images?
% ---------------------------------------------------------------------
swap         = cfg_menu;
swap.tag     = 'swap';
swap.name    = 'Change Byte Order Information for Mapped Images?';
swap.help    = {'This option may be obsolete for SPM5. With SPM2-style analyses, byte order of an image was stored at the time statistics were run. If one later moved the SPM.mat and analysis files to a machine with different byte order, this was not realised by SPM.'};
swap.labels = {
               'Yes'
               'No'
}';
swap.values = {true false};
% ---------------------------------------------------------------------
% tbxvol_changeSPM Change SPM.mat Image Information
% ---------------------------------------------------------------------
cfg_tbxvol_changeSPM         = cfg_exbranch;
cfg_tbxvol_changeSPM.tag     = 'tbxvol_changeSPM';
cfg_tbxvol_changeSPM.name    = 'Change SPM.mat Image Information';
cfg_tbxvol_changeSPM.val     = {srcspm chpaths swap };
cfg_tbxvol_changeSPM.help    = {'No help available for topic ''tbxvol_changeSPM''.'};
cfg_tbxvol_changeSPM.prog = @tbxvol_changeSPM;
% ---------------------------------------------------------------------
% srcspm Source SPM.mat
% ---------------------------------------------------------------------
srcspm         = cfg_files;
srcspm.tag     = 'srcspm';
srcspm.name    = 'Source SPM.mat';
srcspm.help    = {''};
srcspm.filter = 'mat';
srcspm.ufilter = '.*SPM.*\.mat';
srcspm.num     = [1 1];
% ---------------------------------------------------------------------
% nfactor # of Factor with unequal Variance
% ---------------------------------------------------------------------
nfactor         = cfg_menu;
nfactor.tag     = 'nfactor';
nfactor.name    = '# of Factor with unequal Variance';
nfactor.help    = {''};
nfactor.labels = {
                  'Factor 1'
                  'Factor 2'
                  'Factor 3'
}';
nfactor.values = {2 3 4};
% ---------------------------------------------------------------------
% tbxvol_correct_ec_SPM Correct Error Covariance components
% ---------------------------------------------------------------------
cfg_tbxvol_correct_ec_SPM         = cfg_exbranch;
cfg_tbxvol_correct_ec_SPM.tag     = 'tbxvol_correct_ec_SPM';
cfg_tbxvol_correct_ec_SPM.name    = 'Correct Error Covariance components';
cfg_tbxvol_correct_ec_SPM.val     = {srcspm nfactor };
cfg_tbxvol_correct_ec_SPM.help    = {'No help available for topic ''tbxvol_correct_ec_SPM''.'};
cfg_tbxvol_correct_ec_SPM.prog = @tbxvol_correct_ec_SPM;
% ---------------------------------------------------------------------
% srcimgs Source Images
% ---------------------------------------------------------------------
srcimgs         = cfg_files;
srcimgs.tag     = 'srcimgs';
srcimgs.name    = 'Source Images';
srcimgs.help    = {''};
srcimgs.filter = 'image';
srcimgs.ufilter = '.*';
srcimgs.num     = [1 Inf];
% ---------------------------------------------------------------------
% option Select output map
% ---------------------------------------------------------------------
option         = cfg_menu;
option.tag     = 'option';
option.name    = 'Select output map';
option.help    = {''};
option.labels = {
                 'p'
                 '-log(1-p)'
                 'correlation coefficient cc'
                 'effect size d'
}';
option.values = {1 2 3 4};
% ---------------------------------------------------------------------
% tbxvol_transform_t2x Transform t maps
% ---------------------------------------------------------------------
cfg_tbxvol_transform_t2x         = cfg_exbranch;
cfg_tbxvol_transform_t2x.tag     = 'tbxvol_transform_t2x';
cfg_tbxvol_transform_t2x.name    = 'Transform t maps';
cfg_tbxvol_transform_t2x.val     = {srcimgs option };
cfg_tbxvol_transform_t2x.help    = {'No help available for topic ''tbxvol_transform_t2x''.'};
cfg_tbxvol_transform_t2x.prog = @tbxvol_transform_t2x;
cfg_tbxvol_transform_t2x.vfiles = @vfiles_tbxvol_transform_t2x;
% ---------------------------------------------------------------------
% srcimgs Source Images
% ---------------------------------------------------------------------
srcimgs         = cfg_files;
srcimgs.tag     = 'srcimgs';
srcimgs.name    = 'Source Images';
srcimgs.help    = {''};
srcimgs.filter = 'image';
srcimgs.ufilter = '.*';
srcimgs.num     = [1 Inf];
% ---------------------------------------------------------------------
% interp Interpolation
% ---------------------------------------------------------------------
interp         = cfg_menu;
interp.tag     = 'interp';
interp.name    = 'Interpolation';
interp.help    = {''};
interp.labels = {
                 'Nearest neighbour'
                 'Trilinear'
                 '2nd Degree b-Spline'
                 '3rd Degree b-Spline'
                 '4th Degree b-Spline'
                 '5th Degree b-Spline'
                 '6th Degree b-Spline'
                 '7th Degree b-Spline'
                 '2nd Degree Sinc'
                 '3rd Degree Sinc'
                 '4th Degree Sinc'
                 '5th Degree Sinc'
                 '6th Degree Sinc'
                 '7th Degree Sinc'
}';
interp.values = {0 1 2 3 4 5 6 7 -2 -3 -4 -5 -6 -7};
% ---------------------------------------------------------------------
% dtype Data Type
% ---------------------------------------------------------------------
dtype         = cfg_menu;
dtype.tag     = 'dtype';
dtype.name    = 'Data Type';
dtype.val{1} = double(0);
dtype.help    = {'Data-type of output images.  SAME indicates the same datatype as the original images.'};
dtype.labels = cellstr(char('SAME',spm_type(spm_type)));
dtype.values = num2cell([0 spm_type]);
% ---------------------------------------------------------------------
% prefix Output Filename Prefix
% ---------------------------------------------------------------------
prefix         = cfg_entry;
prefix.tag     = 'prefix';
prefix.name    = 'Output Filename Prefix';
prefix.val = {'li_'};
prefix.help    = {'The output filename is constructed by prefixing the original filename with this prefix.'};
prefix.strtype = 's';
prefix.num     = [1 Inf];
% ---------------------------------------------------------------------
% tbxvol_laterality Compute Laterality index
% ---------------------------------------------------------------------
cfg_tbxvol_laterality         = cfg_exbranch;
cfg_tbxvol_laterality.tag     = 'tbxvol_laterality';
cfg_tbxvol_laterality.name    = 'Compute Laterality index';
cfg_tbxvol_laterality.val     = {srcimgs interp dtype prefix };
cfg_tbxvol_laterality.help    = {'No help available for topic ''tbxvol_laterality''.'};
cfg_tbxvol_laterality.prog = @tbxvol_laterality;
cfg_tbxvol_laterality.vfiles = @vfiles_tbxvol_laterality;
% ---------------------------------------------------------------------
% srcspm Source SPM.mat
% ---------------------------------------------------------------------
srcspm         = cfg_files;
srcspm.tag     = 'srcspm';
srcspm.name    = 'Source SPM.mat';
srcspm.help    = {''};
srcspm.filter = 'mat';
srcspm.ufilter = '.*SPM.*\.mat';
srcspm.num     = [1 1];
% ---------------------------------------------------------------------
% maskimg Brain mask image (optional)
% ---------------------------------------------------------------------
maskimg         = cfg_files;
maskimg.tag     = 'maskimg';
maskimg.name    = 'Brain mask image (optional)';
maskimg.val = {''};
maskimg.help    = {''};
maskimg.filter = 'image';
maskimg.ufilter = '.*';
maskimg.num     = [0 1];
% ---------------------------------------------------------------------
% dist Distance from mean
% ---------------------------------------------------------------------
dist         = cfg_entry;
dist.tag     = 'dist';
dist.name    = 'Distance from mean';
dist.help    = {''};
dist.strtype = 'e';
dist.num     = [1 1];
% ---------------------------------------------------------------------
% graphics Graphics output
% ---------------------------------------------------------------------
graphics         = cfg_menu;
graphics.tag     = 'graphics';
graphics.name    = 'Graphics output';
graphics.help    = {''};
graphics.labels = {
                   'Yes'
                   'No'
}';
graphics.values = {true false};
% ---------------------------------------------------------------------
% tbxvol_analyse_resms Analyse goodness of fit
% ---------------------------------------------------------------------
cfg_tbxvol_analyse_resms         = cfg_exbranch;
cfg_tbxvol_analyse_resms.tag     = 'tbxvol_analyse_resms';
cfg_tbxvol_analyse_resms.name    = 'Analyse goodness of fit';
cfg_tbxvol_analyse_resms.val     = {srcspm maskimg dist graphics };
cfg_tbxvol_analyse_resms.help    = {'No help available for topic ''tbxvol_analyse_resms''.'};
cfg_tbxvol_analyse_resms.prog = @tbxvol_analyse_resms;
%cfg_tbxvol_analyse_resms.vfiles = @vfiles_tbxvol_analyse_resms;
% ---------------------------------------------------------------------
% srcimgs Source Images
% ---------------------------------------------------------------------
srcimgs         = cfg_files;
srcimgs.tag     = 'srcimgs';
srcimgs.name    = 'Source Images';
srcimgs.help    = {''};
srcimgs.filter = 'image';
srcimgs.ufilter = '.*';
srcimgs.num     = [1 Inf];
% ---------------------------------------------------------------------
% maskimgs Mask image(s)
% ---------------------------------------------------------------------
maskimgs         = cfg_files;
maskimgs.tag     = 'maskimgs';
maskimgs.name    = 'Mask image(s)';
maskimgs.help    = {''};
maskimgs.filter = 'image';
maskimgs.ufilter = '.*';
maskimgs.num     = [1 Inf];
% ---------------------------------------------------------------------
% subjects Subject
% ---------------------------------------------------------------------
subjects1         = cfg_branch;
subjects1.tag     = 'subjects';
subjects1.name    = 'Subject';
subjects1.val     = {srcimgs maskimgs };
subjects1.help    = {''};
% ---------------------------------------------------------------------
% subjects Subjects
% ---------------------------------------------------------------------
subjects         = cfg_repeat;
subjects.tag     = 'subjects';
subjects.name    = 'Subjects';
subjects.help    = {''};
subjects.values  = {subjects1 };
subjects.num     = [1 Inf];
% ---------------------------------------------------------------------
% bins Edges of histogramm bins
% ---------------------------------------------------------------------
bins         = cfg_entry;
bins.tag     = 'bins';
bins.name    = 'Edges of histogramm bins';
bins.help    = {'Enter the edges of histogramm bins. See ''help histc'' for details.'};
bins.strtype = 'e';
bins.num     = [1 Inf];
% ---------------------------------------------------------------------
% tbxvol_hist_summary Histogramm summary
% ---------------------------------------------------------------------
cfg_tbxvol_hist_summary         = cfg_exbranch;
cfg_tbxvol_hist_summary.tag     = 'tbxvol_hist_summary';
cfg_tbxvol_hist_summary.name    = 'Histogramm summary';
cfg_tbxvol_hist_summary.val     = {subjects bins };
cfg_tbxvol_hist_summary.help    = {'No help available for topic ''tbxvol_hist_summary''.'};
cfg_tbxvol_hist_summary.prog = @(job)tbxvol_hist_summary('run',job);
cfg_tbxvol_hist_summary.vout = @(job)tbxvol_hist_summary('vout',job);
% ---------------------------------------------------------------------
% num Session #
% ---------------------------------------------------------------------
num         = cfg_entry;
num.tag     = 'num';
num.name    = 'Session #';
num.strtype = 'n';
num.num     = [1 1];
num.help    = {['Orthogonalisation will be performed per Session. Enter ' ...
    'the number of the session to be orthogonalised.']};
% ---------------------------------------------------------------------
% c Conditions
% ---------------------------------------------------------------------
c         = cfg_entry;
c.tag     = 'c';
c.name    = 'Conditions';
c.strtype = 'n';
c.num     = [1 Inf];
c.help    = {['Enter the condition numbers to orthogonalise. The order of ' ...
    'conditions is important, orthogonalisation will be performed from ' ...
    'to right.']};
% ---------------------------------------------------------------------
% Sess
% ---------------------------------------------------------------------
Sess      = cfg_branch;
Sess.tag  = 'Sess';
Sess.name = 'Session';
Sess.val  = {num c};
% ---------------------------------------------------------------------
% Sessrep Sessions
% ---------------------------------------------------------------------
Sessrep        = cfg_repeat;
Sessrep.tag    = 'Sessrep';
Sessrep.name   = 'Sessions';
Sessrep.num    = [1 Inf];
Sessrep.values = {Sess};
% ---------------------------------------------------------------------
% cfg_tbxvol_orth_conditions Orthogonalise conditions
% ---------------------------------------------------------------------
cfg_tbxvol_orth_conditions      = cfg_exbranch;
cfg_tbxvol_orth_conditions.tag  = 'tbxvol_orth_conditions';
cfg_tbxvol_orth_conditions.name = 'Orthogonalise conditions';
cfg_tbxvol_orth_conditions.val  = {srcspm Sessrep};
cfg_tbxvol_orth_conditions.prog = @(job)tbxvol_orth_conditions('run',job);
cfg_tbxvol_orth_conditions.vout = @(job)tbxvol_orth_conditions('vout',job);
cfg_tbxvol_orth_conditions.help = vgtbx_help2cell('tbxvol_orth_conditions');
% ---------------------------------------------------------------------
% Latency computation - modified copy of spm_cfg_imcalc
% ---------------------------------------------------------------------
cfg_tbxvol_latency      = spm_cfg_imcalc;
cfg_tbxvol_latency.tag  = 'tbxvol_latency';
cfg_tbxvol_latency.name = 'Latency (Image Calculator)';
cfg_tbxvol_latency.val{1}.name = 'HRF+Derivative con images';
cfg_tbxvol_latency.val{1}.num  = [2 2];
cfg_tbxvol_latency.val{4}.val  = {'2*1.78/(1+exp(3.10*i2/i1))-1.78)'};
% ---------------------------------------------------------------------
% Stats_Tools Stats Tools
% ---------------------------------------------------------------------
Stats_Tools         = cfg_choice;
Stats_Tools.tag     = 'Stats_Tools';
Stats_Tools.name    = 'Stats Tools';
Stats_Tools.help    = {''};
Stats_Tools.values  = {cfg_tbxvol_changeSPM cfg_tbxvol_correct_ec_SPM cfg_tbxvol_transform_t2x cfg_tbxvol_laterality cfg_tbxvol_analyse_resms cfg_tbxvol_hist_summary cfg_tbxvol_orth_conditions cfg_tbxvol_latency};
% ---------------------------------------------------------------------
% vgtbx_Volumes Volume handling utilities
% ---------------------------------------------------------------------
vgtbx_Volumes         = cfg_choice;
vgtbx_Volumes.tag     = 'vgtbx_Volumes';
vgtbx_Volumes.name    = 'Volume handling utilities';
vgtbx_Volumes.help    = {
                         'Volumes toolbox'
                         '_______________________________________________________________________'
                         ''
                         'This toolbox contains various helper functions to make image manipulation within SPM5 more convenient. Help on each individual item can be obtained by selecting the corresponding entry in the help menu.'
                         ''
                         'This toolbox is free but copyright software, distributed under the terms of the GNU General Public Licence as published by the Free Software Foundation (either version 2, as given in file spm_LICENCE.man, or at your option, any later version). Further details on "copyleft" can be found at http://www.gnu.org/copyleft/.'
                         'The toolbox consists of the files listed in its Contents.m file.'
                         ''
                         'The source code of this toolbox is available at'
                         ''
                         'http://sourceforge.net/projects/spmtools'
                         ''
                         'Please use the SourceForge forum and tracker system for comments, suggestions, bug reports etc. regarding this toolbox.'
                         '_______________________________________________________________________'
                         ''
                         '@(#) $Id: vgtbx_config_Volumes.m 539 2007-12-06 17:31:12Z glauche $'
}';
vgtbx_Volumes.values  = {Single_Volumes Multiple_Volumes Stats_Tools };
% ---------------------------------------------------------------------
% Virtual outputs/files
% ---------------------------------------------------------------------
function dep = vout_tbxvol_extract(job)
dep            = cfg_dep;
dep.sname      = 'Extract Data (All)';
dep.src_output = substruct('()',{':',1:numel(job.roispec)});
dep.tgt_spec   = cfg_findspec({{'strtype','e'}});

if numel(job.roispec) > 1
    for l = 1:numel(job.roispec)
        dep(l+1)            = cfg_dep;
        dep(l+1).sname      = sprintf('Extract Data (ROI %d)', l);
        dep(l+1).src_output = substruct('()', {':',l});
        dep(l+1).tgt_spec   = cfg_findspec({{'strtype','e'}});
    end;
end;

function dep = vout_tbxvol_rescale(job)
dep = cfg_dep;
dep.sname      = 'Rescaled Images';
dep.src_output = substruct('.','rimgs');
dep.tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});

function vfiles = vfiles_tbxvol_split(job)
vfiles = {};
for l = 1:numel(job.srcimgs)
        [p n e] = spm_fileparts(job.srcimgs{l});
        fs = sprintf('_%%0%dd',ceil(log10(job.noutput)));
        for k = 1:job.noutput
                vfiles{end+1} = fullfile(p,[n sprintf(fs,k) e]);
        end;
end;

function vfiles = vfiles_tbxvol_transform_t2x(job)
for k = 1:numel(job.srcimgs)
    [pth nm xt] = spm_fileparts(job.srcimgs{k});
    switch job.option
    case 1
        nm2 = 'P';
    case 2
        nm2 = 'logP';
    case 3
        nm2 = 'R';
    case 4
        nm2 = 'D';
    end
    
    % name should follow convention spm?_0*.img
    if strcmp(nm(1:3),'spm') && strcmp(nm(4:6),'T_0')	
        vfiles{k} = fullfile(pth,[nm(1:3) nm2 nm(5:end) xt ',1']);
    else
        vfiles{k} = fullfile(pth,['spm' nm2 '_' nm xt ',1']);
    end
end;

function vfiles = vfiles_tbxvol_laterality(job)
for k = 1:numel(job.srcimgs)
    [pth nm xt] = spm_fileparts(job.srcimgs{k});
    vfiles{k} = fullfile(pth, [job.prefix nm xt ',1']);
end;

function vout = vout_tbxvol_rescale_min_max(job)
vout = cfg_dep;
vout.sname = 'Rescaled Images';
vout.src_output = substruct('.','scimgs');
vout.tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});

function vout = vout_tbxvol_regrid(job)
vout = cfg_dep;
vout.sname = 'Regridded Images';
vout.src_output = substruct('.','outimgs');
vout.tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});

function vfiles = vfiles_tbxvol_flip(job)
vfiles = job.srcimgs;
if ~job.overwrite
    dirs = 'XYZ';
    for k=1:numel(job.srcimgs)
        [p n e v] = spm_fileparts(job.srcimgs{k});
        vfiles{k} = fullfile(p,[job.prefix dirs(job.flipdir) n e v]);
    end;
end;

function vf = vfiles_tbxvol_normalise(varargin)
job = varargin{1};
vf  = cell(numel(job.subj.source));
for i=1:numel(job.subj.source),
    [pth,nam,ext,num] = spm_fileparts(deblank(job.subj.source{i}));
    vf{i} = fullfile(pth,[nam,'_gr_sn.mat']);
end;
