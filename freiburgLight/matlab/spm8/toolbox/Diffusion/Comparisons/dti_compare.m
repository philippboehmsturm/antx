function dti_compare(job)
% Compare tensors
% 
% Determine affine transformation (without shearing) that would map 
% tensors voxel-by-voxel to a volume of reference tensors.
%
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id$

rev = '$Revision$';
funcname = 'Compare tensors';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here


IDTI1=spm_vol(job.refdtimg);

IDTI2=spm_vol(job.dtimg);

IMsk=spm_vol(job.maskimg);

[p2 n2 e]=spm_fileparts(IDTI2(1).fname);

for k=1:6
        IComp(k)=IDTI2(1);
        IComp(k).fname=fullfile(p1,[job.prefix sprintf('%02d_',k+3) n2 e]);
        IComp(k) = spm_create_vol(IComp(k));
end;
%-Start progress plot
%-----------------------------------------------------------------------
spm_progress_bar('Init',IDTI1(1).dim(3),'','planes completed');
  
  
%-Loop over planes computing result Y
%-----------------------------------------------------------------------

for p = 1:IDTI1(1).dim(3),
        comp=zeros(6,DTIdim(1),DTIdim(2));
        B = inv(spm_matrix([0 0 -p 0 0 0 1 1 1]));
        X1=zeros(3,3,DTIdim(1),DTIdim(2)); 
        msk = spm_slice_vol(IMsk,B,DTIdim,0);
        if any(msk(:))
                X1(1,1,:,:) = spm_slice_vol(IDTI1(1),B,DTIdim,0); % hold 0
                X1(1,2,:,:) = spm_slice_vol(IDTI1(2),B,DTIdim,0); % hold 0
                X1(1,3,:,:) = spm_slice_vol(IDTI1(3),B,DTIdim,0); % hold 0
                X1(2,1,:,:) = X1(1,2,:,:);
                X1(2,2,:,:) = spm_slice_vol(IDTI1(4),B,DTIdim,0); % hold 0
                X1(2,3,:,:) = spm_slice_vol(IDTI1(5),B,DTIdim,0); % hold 0
                X1(3,1,:,:) = X1(1,3,:,:);
                X1(3,2,:,:) = X1(2,3,:,:);
                X1(3,3,:,:) = spm_slice_vol(IDTI1(6),B,DTIdim,0); % hold 0
                X2=zeros(3,3,DTIdim(1),DTIdim(2)); 
                X2(1,1,:,:) = spm_slice_vol(IDTI2(1),B,DTIdim,0); % hold 0
                X2(1,2,:,:) = spm_slice_vol(IDTI2(2),B,DTIdim,0); % hold 0
                X2(1,3,:,:) = spm_slice_vol(IDTI2(3),B,DTIdim,0); % hold 0
                X2(2,1,:,:) = X2(1,2,:,:);
                X2(2,2,:,:) = spm_slice_vol(IDTI2(4),B,DTIdim,0); % hold 0
                X2(2,3,:,:) = spm_slice_vol(IDTI2(5),B,DTIdim,0); % hold 0
                X2(3,1,:,:) = X2(1,3,:,:);
                X2(3,2,:,:) = X2(2,3,:,:);
                X2(3,3,:,:) = spm_slice_vol(IDTI2(6),B,DTIdim,0); % hold 0
                if any(X1(:)) || any(X2(:))
                        for k=1:DTIdim(1)
                                for l=1:DTIdim(2)
                                        if(msk(k,l))
                                                tmp=X1(:,:,k,l)/X2(:,:,k,l);
                                                if ~isnan(tmp) && any(tmp)
                                                        try
                                                                comp(:,k,l) = vg_imatrix(tmp);
                                                        catch
                                                                fprintf('Warning\n');
                                                        end;
                                                end;
                                        end;
                                end;
                        end;
                end;
        end;
        for k=1:6
                spm_write_plane(IComp(k),squeeze(comp(k,:,:)),p);
        end;
        spm_progress_bar('Set',p);
end;    
spm_progress_bar('Clear')


function P = vg_imatrix(M)
% returns the parameters for creating an affine transformation
% FORMAT P = spm_imatrix(M)
% M      - Affine transformation matrix
% P      - Parameters (see spm_matrix for definitions)
%___________________________________________________________________________
% @(#)spm_imatrix.m	2.1 John Ashburner & Stefan Kiebel 98/12/18

% Translations and zooms
%-----------------------------------------------------------------------
R         = M(1:3,1:3);
C         = chol(R'*R);
P         = [0 0 0  diag(C)'];
if det(R)<0, P(4)=-P(4);end % Fix for -ve determinants

% Shears
%-----------------------------------------------------------------------
%C         = diag(diag(C))\C;
%P(10:12)  = C([4 7 8]);
%R0        = spm_matrix([0 0 0  0 0 0 P(7:12)]);
%R0        = R0(1:3,1:3);
%R1        = R/R0;

% vg: we assume to have no shears

R1=R;

% This just leaves rotations in matrix R1
%-----------------------------------------------------------------------
%[          c5*c6,           c5*s6, s5]
%[-s4*s5*c6-c4*s6, -s4*s5*s6+c4*c6, s4*c5]
%[-c4*s5*c6+s4*s6, -c4*s5*s6-s4*c6, c4*c5]

P(2) = asin(rang(R1(1,3)));
if (abs(P(2))-pi/2).^2 < 1e-9,
  P(1) = 0;
  P(3) = atan2(-rang(R1(2,1)), rang(-R1(3,1)/R1(1,3)));
else
  c    = cos(P(2));
  P(1) = atan2(rang(R1(2,3)/c), rang(R1(3,3)/c));
  P(3) = atan2(rang(R1(1,2)/c), rang(R1(1,1)/c));
end;
return;

% There may be slight rounding errors making b>1 or b<-1.
function a = rang(b)
a = min(max(b, -1), 1);
return;
