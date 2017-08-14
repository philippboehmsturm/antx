function tbxmp_convert_rp(bch)
% Import realignment parameters documented by the Freiburg spm_dicom_convert
% FORMAT tbxmp_convert_rp(bch)
% ======
% Two input files are necessary: one listing the filenames, the other
% listing the image comments
%
% This function is part of the volumes toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Volumes
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: tbxmp_convert_rp.m 30 2010-06-29 13:41:42Z volkmar $

rev = '$Revision: 30 $';
funcname = 'Extract realign params';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

fid = fopen(bch.srcimg{1},'r');
txt = textscan(fid,'%s%s%f,%f,%f,%f,%f,%f%s','delimiter',':+');
fclose(fid);
% sort and uniquify entries by filename
[fsort ind] = unique(txt{1});
if numel(fsort) < numel(txt{1})
    warning('tbxmp_convert_rp:multi',['Multiple entries per image file detected. Realignment ' ...
             'params may be incorrect.']);
end;
rp = cat(2,txt{3:8});
rp = rp(ind,:); %#ok<NASGU> - used in save below
[p fn] = fileparts(fsort{1});
p = fileparts(bch.srcimg{1});
save(fullfile(p,['rp_' fn '.txt']),'rp','-ascii');

    