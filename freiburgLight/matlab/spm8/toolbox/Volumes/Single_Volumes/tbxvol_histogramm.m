function tbxvol_histogramm(bch)
% Window image volumes by histogram
% FORMAT tbxvol_histogramm(bch)
% ======
% This tool creates a histogram of voxel intensities over a volume and 
% allows to interactively exclude intensity values at both ends of the 
% intensity range. The windowed image volume can then be saved to disk.
%
% This function is part of the volumes toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Volumes
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: tbxvol_histogramm.m 712 2010-06-30 14:20:19Z glauche $

rev = '$Revision: 712 $';
funcname = 'Intensity histogram';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

V = spm_vol(bch.srcimg{1});
ok = 0;
X = spm_read_vols(V);
int = [min(X(:)) max(X(:))];
f = figure;
hist(X(X>int(1) & X<int(2)),100);
while ~ok
        int = spm_input('Interval','!-1','e',int,2)';
        figure(f);
        hist(X(X>int(1) & X<int(2)),100);
        xlabel(sprintf('#vox < %d: %d #vox > %d: %d', ...
                       int(1),sum(X(:)<int(1)),int(2),sum(X(:)>int(2))));
        ok = spm_input('Accept?','!+1','b',{'yes','no','cancel'},[1 0 ...
	  -1],1);
end;
if ok == 1
        X(X<int(1))=int(1);
        X(X>int(2))=int(2);
        if ~bch.overwrite
                [p n e] = spm_fileparts(V.fname);
                V.fname = fullfile(p,...
                                    [bch.prefix sprintf('%1.2e:%1.2e',int) ...
                                    n e]);
                V = spm_create_vol(V);
        end;
        V = spm_write_vol(V,X);
end;
close(f);
spm_input('!DeleteInputObj');
  
