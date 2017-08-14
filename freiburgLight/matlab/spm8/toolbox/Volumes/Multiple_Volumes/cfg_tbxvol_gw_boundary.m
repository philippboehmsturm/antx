function gw_boundary = cfg_tbxvol_gw_boundary
% 'Compute Grey/White Boundary' - MATLABBATCH configuration
% This MATLABBATCH configuration file has been generated automatically
% by MATLABBATCH using ConfGUI. It describes menu structure, validity
% constraints and links to run time code.
% Changes to this file will be overwritten if the ConfGUI batch is executed again.
% Created at 2009-06-29 18:23:39.
% ---------------------------------------------------------------------
% segments Grey+White segments
% ---------------------------------------------------------------------
segments         = cfg_files;
segments.tag     = 'segments';
segments.name    = 'Grey+White segments';
segments.filter = 'image';
segments.ufilter = '^c[12]';
segments.num     = [2 2];
% ---------------------------------------------------------------------
% maskexpr Mask expression
% ---------------------------------------------------------------------
maskexpr         = cfg_entry;
maskexpr.tag     = 'maskexpr';
maskexpr.name    = 'Mask expression';
maskexpr.strtype = 's';
maskexpr.num     = [1  Inf];
% ---------------------------------------------------------------------
% gradthr Threshold for min(grad) map
% ---------------------------------------------------------------------
gradthr         = cfg_entry;
gradthr.tag     = 'gradthr';
gradthr.name    = 'Threshold for min(grad) map';
gradthr.strtype = 'r';
gradthr.num     = [1  1];
% ---------------------------------------------------------------------
% gw_boundary Compute Grey/White Boundary
% ---------------------------------------------------------------------
gw_boundary         = cfg_exbranch;
gw_boundary.tag     = 'gw_boundary';
gw_boundary.name    = 'Compute Grey/White Boundary';
gw_boundary.val     = {segments maskexpr gradthr };
gw_boundary.prog = @(x)tbxvol_gw_boundary('run',x);
gw_boundary.vout = @(x)tbxvol_gw_boundary('vout',x);
