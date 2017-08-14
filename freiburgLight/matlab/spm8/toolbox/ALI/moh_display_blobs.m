function [] = moh_display_blobs(vb, thr, va)
% display an image on the canonical T1 image
% e.g. overlap functional on anatomical image
% input:
%   vb: functional/overlap volume (color coded)
%   thr: threshold (>=) of the signal in the funct/blob image
%   va: optional, anatomical volume (gray coded)
%
% ===============================================
% Mohamed Seghier, 13.11.2005
%

if nargin==2
    pa = fullfile(spm('Dir'),...
        'canonical', 'single_subj_T1.nii') ;
    va = spm_vol_nifti(pa);
end

if ~isstruct(vb), vb = spm_vol(vb) ; end

spm_check_registration(va) ;
imb = spm_read_vols(vb) ;
ind = find(imb >= thr) ;
[X,Y,Z] = ind2sub(vb.dim, ind) ;
spm_orthviews('AddBlobs',1,[X';Y';Z'],double(imb(ind)),vb.mat) ;
% spm_figure('Colormap','gray-jet') ;


return ;
