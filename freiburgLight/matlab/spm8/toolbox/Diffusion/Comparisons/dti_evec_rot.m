function IEvec1= dti_evec_rot(job)
% Rotate tensors
% Determine rotations to match the tensors main axes.
%
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id$

rev = '$Revision$';
funcname = 'Rotate tensors';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

IEvec = spm_vol(job.refe1img);
IRot = spm_vol(job.e1img);
IMsk=spm_vol(job.maskimg);

IEvec1 = IEvec;
for k=1:3
    [p n e] = spm_fileparts(IEvec1(k).fname);
    IEvec1(k).fname = fullfile(p,[job.prefix n e]);
end;
    %-Start progress plot
    %-----------------------------------------------------------------------
    spm_progress_bar('Init',IEvec(1).dim(3),'','planes completed');
    
 
    %-Loop over planes computing result Y
    %-----------------------------------------------------------------------

    Evec1=zeros([IEvec(1).dim(1:3) 3]);

    for p = 1:IEvec1(1).dim(3),
        B = inv(spm_matrix([0 0 -p 0 0 0 1 1 1]));
 
        msk = spm_slice_vol(IMsk,B,IEvec(1).dim(1:2),0);
        if any(msk(:))
            Evec(:,:,1) = msk.*spm_slice_vol(IEvec(1),B,IEvec(1).dim(1:2),0); % hold 0
            Evec(:,:,2) = msk.*spm_slice_vol(IEvec(2),B,IEvec(1).dim(1:2),0); % hold 0
            Evec(:,:,3) = msk.*spm_slice_vol(IEvec(3),B,IEvec(1).dim(1:2),0); % hold 0
            Rot(:,:,1) = msk.*spm_slice_vol(IRot(1),B,IEvec(1).dim(1:2),0); % hold 0
            Rot(:,:,2) = msk.*spm_slice_vol(IRot(2),B,IEvec(1).dim(1:2),0); % hold 0
            Rot(:,:,3) = msk.*spm_slice_vol(IRot(3),B,IEvec(1).dim(1:2),0); % hold 0
            
            for k=1:IEvec(1).dim(1)
                for l=1:IEvec(1).dim(2)
                    tmp=spm_matrix([0 0 0 squeeze(Rot(k,l,:))'])*[squeeze(Evec(k,l,:)); 1];
                    Evec1(k,l,p,:)=tmp(1:3);
                end;
            end;
        end;
        spm_progress_bar('Set',p);
    end;    

    %-Write output image (uses spm_write_vol - which calls spm_write_plane)
    %-----------------------------------------------------------------------
    
    for k=1:3
        spm_write_vol(IEvec1(k),squeeze(Evec1(:,:,:,k)));
    end;

    %-End
    %-----------------------------------------------------------------------
    spm_progress_bar('Clear')

