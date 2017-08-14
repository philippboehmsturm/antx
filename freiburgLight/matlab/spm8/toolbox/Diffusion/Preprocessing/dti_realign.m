function varargout = dti_realign(bch)
% Determine realignment parameters for diffusion weighted images
%
% Motion correction of diffusion weighted images can not be done by 
% simply using SPMs realignment procedure, because images with different 
% diffusion weighting show different contrast and signal/noise 
% ratio. This would violate the assumptions on which the realignment code 
% is based.
% In a repeated measurement scenario, the solution could be separate 
% realignment of images with different diffusion weighting. However, this 
% does not work well for high b values, and it does not work at all without 
% repeated measurements. Without repeated measurements, it is recommended 
% to insert additional b0 scans into your acquisition every 6-10 
% diffusion weighting directions.
% Motion correction can then be performed on the b0 images and the 
% parameters applied to the corresponding diffusion weighted images. 
% Three different options for motion correction based on b0 images are 
% available:
%/*\begin{description}*/
%/*\item[*/ Stepwise correction/*]*/
%         Movement parameters for a b0 image will be applied unchanged to 
%         all following diffusion weighted images up to the next b0 image.
%/*\item[*/ Linear correction/*]*/
%         For all but the diffusion weighting images following the last 
%         b0 image, motion parameters will be determined by linear 
%         interpolation between the two sets of motion parameters of b0 
%         images. There are two possibilities for images in the last series:
%/*\begin{description}*/
%/*\item[*/         last stepwise/*]*/ Do a stepwise correction for the last images
%/*\item[*/         last linear/*]*/ Extrapolate motion parameters from difference 
%         between last b0 images. This option might be useful if there 
%         is a linear scanner drift that is larger than voluntary head 
%         movement.
%/*\end{description}*//*\end{description}*/
% In addition (or alternatively, if no time series of b0 images exists), 
% motion correction can be performed on diffusion weighted images:
%/*\begin{description}*/
%/*\item[*/ Realign xy/*]*/
%         The b1 images are realigned within xy plane.
%/*\item[*/ Coregister to mean/*]*/
%         From the realigned diffusion images a mean image is 
%         created. The b1 images are then coregistered to this mean 
%         image.
%/*\end{description}*/
% The images itself are not resliced during this step, only position 
% information in NIFTI headers is updated. If necessary, images can be 
% resliced to the space of the 1st image by choosing "Realign->Reslice 
% only" from standard SPM and selecting all images of all series together 
% in the correct order. This step can be skipped, if images will be 
% normalised before tensor estimation. Gradient directions need to be 
% adjusted prior to running tensor estimation using dti_reorient_gradients.
%
% Batch processing:
% FORMAT dti_realign(bch)
% ======   
% Input argument:
%   bch struct with fields
%/*\begin{description}*/
%/*\item[*/       .srcimgs/*]*/  cell array of image filenames. Images are classified as b0 
%               or b1 by inspection of the diffusion information in 
%               userdata using dti_extract_dirs. 
%/*\item[*/       .b0corr/*]*/ Motion correction on b0 images
%/*\item[*/       .b1corr/*]*/ Motion correction on b1 images
%/*\end{description}*/
% This function is part of the diffusion toolbox for SPM5. For general  
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id$

rev = '$Revision$';
funcname = 'Realign';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
spm_input('!DeleteInputObj');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

spm('pointer','watch');
[nwd n e] = spm_fileparts(bch.srcimgs{1});
owd = pwd;
cd(nwd); % goto image directory (for writing spmXX.ps file)
ds.srcimgs = bch.srcimgs;
ds.ref.refscanner = 1;
ds.saveinf = 0;
ds.ltol = 10;
ds.dtol = .95;
ds.sep  = 1;
res = dti_extract_dirs(ds);

b0ind = find(res.allb==0);
if (numel(b0ind) < 2) && bch.b0corr
        bch.b0corr = 0;
        warning('Not enough b0 images to apply motion correction.');
        b0ind = [];
end;

if bch.b1corr == 2
        % for separate realignment, don't do b0 correction
        bch.b0corr = 0;
end;

if bch.b0corr
        VrB0 = spm_realign(char(bch.srcimgs{b0ind}));
        % apply parameters to b0 images
        for l=1:numel(VrB0)
                spm_get_space(VrB0(l).fname, VrB0(l).mat);
        end;
        b0ind = [b0ind; numel(bch.srcimgs)+1];
        switch bch.b0corr
        case {2,3}, % interpolated
                for m = 1:(numel(b0ind)-1)
                        if (m == numel(b0ind)-1) 
                                if bch.b0corr == 2 % stepwise adjustment for last image
                                        for l = (b0ind(m)+1):(b0ind(m+1)-1)
                                                spm_get_space(bch.srcimgs{l}, VrB0(m).mat);
                                        end;
                                else % extrapolate from previous movement            
                                        prm1 = spm_imatrix(VrB0(m-1).mat);
                                        prm2 = spm_imatrix(VrB0(m).mat);
                                        prms = interp1([0 b0ind(m+1)-b0ind(m)],...
                                                       [prm2; prm2+(prm2-prm1)],...
                                                       1:(b0ind(m+1)-b0ind(m)-1));
                                        for l = (b0ind(m)+1):(b0ind(m+1)-1)
                                                spm_get_space(bch.srcimgs{l},...
                                                              spm_matrix(prms(l-b0ind(m),:)));
                                        end;
                                end;
                        else
                                prm1 = spm_imatrix(VrB0(m).mat);
                                prm2 = spm_imatrix(VrB0(m+1).mat);
                                prms = interp1([0 b0ind(m+1)-b0ind(m)], [prm1; prm2],...
                                               1:(b0ind(m+1)-b0ind(m)-1));
                                for l = (b0ind(m)+1):(b0ind(m+1)-1)
                                        spm_get_space(bch.srcimgs{l},...
                                                      spm_matrix(prms(l-b0ind(m),:)));
                                end;
                        end;
                end;
        case 1, % stepwise
                for m = 1:(numel(b0ind)-1)
                        for l = (b0ind(m)+1):(b0ind(m+1)-1)
                                spm_get_space(bch.srcimgs{l}, VrB0(m).mat);
                        end;
                end;
        end;
end;

%b1ind = find(res.allb~=0);
VB1 = spm_vol(char(bch.srcimgs));
% Realignment
switch bch.b1corr
    case 2,
        [ubg ubgi ubgj] = unique([res.ubj res.ugj],'rows');
        for k = 1:max(ubgj)
            bgsel = ubgj==k;
            if sum(bgsel) > 1
                spm_realign(char(bch.srcimgs{bgsel}), struct('rtm',1));
            end;
        end;
    case {6,7}
        wmjob.srcimgs = bch.srcimgs;
        wmjob.infix   = '';
        out = dti_dw_wmean_variance('run',wmjob);
        if bch.b1corr == 7
            ropts.lkp = 1:12;
        else
            ropts.lkp = 1:6;
        end;
        ropts.graphics = 0;
        for m=1:numel(bch.srcimgs)
            spm_realign(char([out.wmean(m) bch.srcimgs(m)]),ropts);
        end
    case {1,3,4,5}
        switch bch.b1corr        
            case {1,3},
                % save un-realigned b1 image positions
                VpB1 = VB1;
                % make translations in plane by re-setting .mat
                M = zeros(4,4,numel(VB1));
                for m=1:numel(VB1)
                    prm = spm_imatrix(VB1(m).mat);
                    M(:,:,m) = spm_matrix([0 0 0 prm(4:6) 1 1 1]);
                    VpB1(m).mat = M(:,:,m)\VB1(m).mat;
                end;
                VrpB1 = spm_realign(VpB1,struct('lkp',[1 2 6],'rtm',1));
                % re-apply rotations
                for m=1:numel(VrpB1)
                    VrpB1(m).mat = M(:,:,m)*VrpB1(m).mat;
                end
            case {4,5},
                VrpB1 = spm_realign(VB1,struct('rtm',1));
        end;
        switch bch.b1corr
            case {3,4,5}
                spm_reslice(VrpB1,struct('mean',1,'which',0));
                % coregister to mean
                [p n e]=spm_fileparts(VrpB1(1).fname);
                if bch.b1corr == 5
                    coregprms = [zeros(1,6) ones(1,3) zeros(1,3)];
                else
                    coregprms = zeros(1,6);
                end;
                prms = spm_coreg(fullfile(p,['mean' n e]),VrpB1,...
                                 struct('params',coregprms,'graphics',0));
                for m=1:numel(VrpB1)
                    VrpB1(m).mat = spm_matrix(prms(m,:))\VrpB1(m).mat;
                end;
        end;
        for m=1:numel(VrpB1)
            spm_get_space(VrpB1(m).fname, VrpB1(m).mat);
        end;
end
cd(owd);
spm('pointer','arrow');
res.files = bch.srcimgs;
if nargout > 0
    varargout{1} = res;
end;
