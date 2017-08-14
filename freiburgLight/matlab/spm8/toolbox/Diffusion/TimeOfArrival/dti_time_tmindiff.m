function dti_time_tmindiff(varargin)
% Find local minima in time
% FORMAT dti_time_tmindiff
% ======
%
% This function is part of the diffusion toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.

%_______________________________________________________________________
%
% @(#) $Id$

rev = '$Revision$';
funcname = 'Find time holes';

% menu setup
if nargin==2
  if ischar(varargin{1}) & ishandle(varargin{2})
    if strcmp(lower(varargin{1}),'menu')
      Menu = uimenu(varargin{2},'Label',funcname,...
	  'Callback',mfilename);
      return;
    end;
    if strcmp(lower(varargin{1}),'hmenu')
      Menu = uimenu(varargin{2},'Label',['Help on ' funcname],...
	  'Callback',['spm_help(''' mfilename ''')']);
      return;
    end;
  end;
end;

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
spm_input('!DeleteInputObj');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here
VTA=spm_vol(spm_get(Inf,'ta_*IMAGE','ToA images'));

for j=1:length(VTA)
    %-Start progress plot
    %-----------------------------------------------------------------------
    spm_progress_bar('Init',VTA(j).dim(3),'','planes completed');
    
    VTD = VTA(j);
    [p n e v] = fileparts(VTD.fname);
    VTD.fname = fullfile(p,['d' n e v]);
    %-Loop over planes computing result Y
    %-----------------------------------------------------------------------
    TD = zeros(VTD.dim(1:3));

    T = repmat(Inf,[VTD.dim(1:2)+2 3]);
    
    for k = 1:VTD.dim(3),
        B1 = inv(spm_matrix([0 0 -(k-1) 0 0 0 1 1 1]));
        B2 = inv(spm_matrix([0 0 -k 0 0 0 1 1 1]));
        B3 = inv(spm_matrix([0 0 -(k+1) 0 0 0 1 1 1]));

        if k>1
            T(2:end-1,2:end-1,1) = spm_slice_vol(VTA(j),B1,VTD.dim(1:2),0);
        end;
        T(2:end-1,2:end-1,2) = spm_slice_vol(VTA(j),B2,VTD.dim(1:2),0);
        if k<VTD.dim(3)
            T(2:end-1,2:end-1,3) = spm_slice_vol(VTA(j),B3,VTD.dim(1:2),0);
        end;
        
        for l=1:VTD.dim(1)
            for m=1:VTD.dim(2)
                Tn = T(l:l+2,m:m+2,1:3);
                Tn(2,2,2)=Inf;
                TD(l,m,k)=T(l+1,m+1,2)-min(Tn(:));
                if TD(l,m,k)<0&isfinite(T(l+1,m+1,2))
                    fprintf('Local minimum in time at (%d, %d, %d): ta = %d, min(nb) = %d\n',...
                        l,m,k,T(l+1,m+1,2),min(Tn(:)));
                end;
            end;
        end;
        spm_progress_bar('Set',k);
    end;    
    
    %-Write output image (uses spm_write_vol - which calls spm_write_plane)
    %-----------------------------------------------------------------------
    
    TD(isnan(TD)) = 0;
    fprintf('#vox > cutoff (5000): %d\n',sum(TD(~isinf(TD))>5000));
    TD(isinf(TD)) = 5000;
    TD(TD>5000) = 5000;
    
    VTD = spm_write_vol(VTD,TD);
    
    %-End
    %-----------------------------------------------------------------------
    spm_progress_bar('Clear')
end;
