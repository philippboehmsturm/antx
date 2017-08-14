function varargout=dti_warp_tensors(bch)
% Apply image reorientation information to diffusion gradients
% 
% Batch processing:
% FORMAT dti_warp_tensors(bch)
% ======
% Input argument
%   bch struct with fields:
%/*\begin{description}*/
%/*\item[*/      .srcimgs/*]*/  cell array of file names (tensor images
%                 computed from normalised images)
%/*\item[*/       .snparams/*]*/ optional normalisation parameters file used to 
%                 write the images normalised.
%/*\end{description}*/
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: dti_warp_tensors.m 712 2010-06-30 14:20:19Z glauche $

rev = '$Revision: 712 $';
funcname = 'Warp tensors';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
spm_input('!DeleteInputObj');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

V = spm_vol(char(dti_fileorder(bch.dtimg)));
dti_write_sn(V,bch.snparams{1});

function VO = dti_write_sn(V,prm,flags,extras)
% Write Out Warped Images.
% FORMAT VO = dti_write_sn(V,prm,flags,msk)
% V         - Images to transform (filenames or volume structure).
% matname   - Transformation information (filename or structure).
% flags     - flags structure, with fields...
%           interp   - interpolation method (0-7)
%           wrap     - wrap edges (e.g., [1 1 0] for 2D MRI sequences)
%           vox      - voxel sizes (3 element vector - in mm)
%                      Non-finite values mean use template vox.
%           bb       - bounding box (2x3 matrix - in mm)
%                      Non-finite values mean use template bb.
%           preserve - either 0 or 1.  A value of 1 will "modulate"
%                      the spatially normalised images so that total
%                      units are preserved, rather than just
%                      concentrations. This field is present for
%                      compatibility with spm_write_sn, but will be
%                      ignored.
% msk       - An optional cell array for masking the spatially
%             normalised images (see below).
%
% Warped images are written prefixed by "w".
%
% Non-finite vox or bounding box suggests that values should be derived
% from the template image.
%
% Don't use interpolation methods greater than one for data containing
% NaNs.
% _______________________________________________________________________
%
% FORMAT msk = dti_write_sn(V,prm,flags,'mask')
% V         - Images to transform (filenames or volume structure).
% matname   - Transformation information (filename or structure).
% flags     - flags structure, with fields...
%           wrap     - wrap edges (e.g., [1 1 0] for 2D MRI sequences)
%           vox      - voxel sizes (3 element vector - in mm)
%                      Non-finite values mean use template vox.
%           bb       - bounding box (2x3 matrix - in mm)
%                      Non-finite values mean use template bb.
% msk       - a cell array for masking a series of spatially normalised
%             images.
%_______________________________________________________________________
% Copyright (C) 2005 Wellcome Department of Imaging Neuroscience

% John Ashburner
% $Id: dti_warp_tensors.m 712 2010-06-30 14:20:19Z glauche $


if isempty(V), return; end;

if ischar(prm), prm = load(prm);  end;
if ischar(V),   V   = spm_vol(V); end;

def_flags = struct('interp',1,'vox',NaN,'bb',NaN,'wrap',[0 0 0],'preserve',0);
[def_flags.bb, def_flags.vox] = bbvox_from_V(prm.VG(1));

if nargin < 3,
	flags = def_flags;
else
	fnms = fieldnames(def_flags);
	for i=1:length(fnms),
		if ~isfield(flags,fnms{i}),
			flags.(fnms{i}) = def_flags.(fnms{i});
		end;
	end;
end;

% Voxel size and bounding box from images
flags.vox = sqrt(sum(V(1).mat(1:3,1:3).^2));
bbtmp     = V(1).mat*[1 1 1 1; V(1).dim(1:3) 1]';
flags.bb  = bbtmp(1:3,:)';

[x,y,z,mat] = get_xyzmat(prm,flags.bb,flags.vox);

msk = []; % unused

if nargout==0,
	if isempty(prm.Tr),
		affine_transform(V,prm,x,y,z,mat,flags,msk);
	else
		nonlin_transform(V,prm,x,y,z,mat,flags,msk);
	end;
else
	if isempty(prm.Tr),
		VO = affine_transform(V,prm,x,y,z,mat,flags,msk);
	else
		VO = nonlin_transform(V,prm,x,y,z,mat,flags,msk);
	end;
end;

return;
%_______________________________________________________________________

%_______________________________________________________________________
function VO = affine_transform(V,prm,x,y,z,mat,flags,msk)
VO = [];
warning('Please use copy/reorient diffusion information for this task.');
return;
%_______________________________________________________________________

%_______________________________________________________________________
function VO = nonlin_transform(V,prm,x,y,z,mat,flags,msk)

Tr = prm.Tr;
BX = spm_dctmtx(prm.VG(1).dim(1),size(Tr,1),x-1);
BY = spm_dctmtx(prm.VG(1).dim(2),size(Tr,2),y-1);
BZ = spm_dctmtx(prm.VG(1).dim(3),size(Tr,3),z-1);
% need jacobian matrix for local transformations
DX = spm_dctmtx(prm.VG(1).dim(1),size(Tr,1),x-1,'diff');
DY = spm_dctmtx(prm.VG(1).dim(2),size(Tr,2),y-1,'diff');
DZ = spm_dctmtx(prm.VG(1).dim(3),size(Tr,3),z-1,'diff');

spm_progress_bar('Init',V(1).dim(3),'Resampling','planes completed');
for i=1:numel(V),
	VO(i)     = make_hdr_struct(V(i),x,y,z,mat);

	if nargout>0,
		%Dat= zeros(VO.dim(1:3));
		Dat{i} = single(0);
		Dat{i}(VO.dim(1),VO.dim(2),VO.dim(3)) = 0;
	else
		VO(i)  = spm_create_vol(VO(i));
	end;
end

% matrices used in loop
%----------------------------------------------------------------------------
J = zeros([V(1).dim(1:2),3,3]);
isj = zeros([V(1).dim(1:2),6]);
D   = zeros([V(1).dim(1:2),6]);
R11 = zeros(V(1).dim(1:2));
R12 = zeros(V(1).dim(1:2));
R13 = zeros(V(1).dim(1:2));
R21 = zeros(V(1).dim(1:2));
R22 = zeros(V(1).dim(1:2));
R23 = zeros(V(1).dim(1:2));
DR  = zeros(V(1).dim(1:2));

for j=1:length(z),
    % Cycle over planes
    % Nonlinear deformations
    %----------------------------------------------------------------------------
    tx = get_2Dtrans(Tr(:,:,:,1),BZ,j);
    ty = get_2Dtrans(Tr(:,:,:,2),BZ,j);
    tz = get_2Dtrans(Tr(:,:,:,3),BZ,j);


%     j11 = DX*tx*BY' + 1; j12 = BX*tx*DY';     j13 = BX*get_2Dtrans(Tr(:,:,:,1),DZ,j)*BY';
%     j21 = DX*ty*BY';     j22 = BX*ty*DY' + 1; j23 = BX*get_2Dtrans(Tr(:,:,:,2),DZ,j)*BY';
%     j31 = DX*tz*BY';     j32 = BX*tz*DY';     j33 = BX*get_2Dtrans(Tr(:,:,:,3),DZ,j)*BY' + 1;
    % as opposed to the original code, we need the inverse rotation to
    % compensate normalisation. This is equal to rotation with M'
    % (M'*D*M) instead of M (M*D*M') and needs indexing of j. Therefore
    % we use an indexed m-by-n-by-3,3 array instead of 9 individual variables
    J(:,:,1,1) = DX*tx*BY' + 1; J(:,:,1,2) = BX*tx*DY';     J(:,:,1,3) = BX*get_2Dtrans(Tr(:,:,:,1),DZ,j)*BY';
    J(:,:,2,1) = DX*ty*BY';     J(:,:,2,2) = BX*ty*DY' + 1; J(:,:,2,3) = BX*get_2Dtrans(Tr(:,:,:,2),DZ,j)*BY';
    J(:,:,3,1) = DX*tz*BY';     J(:,:,3,2) = BX*tz*DY';     J(:,:,3,3) = BX*get_2Dtrans(Tr(:,:,:,3),DZ,j)*BY' + 1;

    % brute force method to compute finite strain rotation matrix and
    % rotated tensors
    %----------------------------------------------------------------------------

    % M = inv(sqrtm(J*J'))*J;
    % J*J';
    jjt11=J(:,:,1,1).^2  +J(:,:,1,2).^2  +J(:,:,1,3).^2;
    jjt21=J(:,:,2,1).*J(:,:,1,1)+J(:,:,2,2).*J(:,:,1,2)+J(:,:,2,3).*J(:,:,1,3); jjt22=J(:,:,2,1).^2  +J(:,:,2,2).^2  +J(:,:,2,3).^2;
    jjt31=J(:,:,3,1).*J(:,:,1,1)+J(:,:,3,2).*J(:,:,1,2)+J(:,:,3,3).*J(:,:,1,3); jjt32=J(:,:,3,1).*J(:,:,2,1)+J(:,:,3,2).*J(:,:,2,2)+J(:,:,3,3).*J(:,:,2,3); jjt33=J(:,:,3,1).^2+J(:,:,3,2).^2+J(:,:,3,3).^2;

    % inv(sqrtm)
    for k=1:V(1).dim(1)
        for l=1:V(1).dim(2)
            tmp = inv(sqrtm([jjt11(k,l) jjt21(k,l) jjt31(k,l); ...
                             jjt21(k,l) jjt22(k,l) jjt32(k,l); ...
                             jjt31(k,l) jjt32(k,l) jjt33(k,l)]));
            isj(k,l,1)=tmp(1,1);
            isj(k,l,2)=tmp(2,1); isj(k,l,4)=tmp(2,2);
            isj(k,l,3)=tmp(3,1); isj(k,l,5)=tmp(3,2); isj(k,l,6)=tmp(3,3);
        end;
    end;

    % read tensors into matrix
    %----------------------------------------------------------------------------
    B = inv(spm_matrix([0 0 -j 0 0 0 1 1 1]));
    for k=1:6
        D(:,:,k)=spm_slice_vol(V(k),B,V(1).dim(1:2),0);
    end;
    
    % rotate tensors
    %----------------------------------------------------------------------------

    % if there is an parameterisation for M that allows to estimate
    % rotations without inversion and sqrtm, then an vectorised scheme
    % for rotation could be used:
    % DR_{ij} = vec(M_{i.} x M'_{j.}) * [D_xx; Dxy; D_xz; ... D_zz]
    %
    % where the vec(M) lines can be stacked to yield DR_xx...DR_zz and
    % the entire process can be reordered into sparse matrix form for rotation of an
    % entire plane like this
    % [DR_{xx1}; ... DR_{xxN}; DR_{xy1}; DR_{xyN};...] =
    %                     [spdiags(M_{xx}.^2) spdiags(M_{xx}.*M_{yy}+M_{xy}.*M_{yx}...)]
    %                     *[D_{xx1};...D_{xxN}; D_{xy1}...D_{xyN}] 
%     % This is for rotation in the J direction
%     % R = [isj(:,1).*j11+isj(:,2).*j21+isj(:,3).*j31   isj(:,1).*j12+isj(:,2).*j22+isj(:,3).*j32   isj(:,1).*j13+isj(:,2).*j23+isj(:,3).*j33 
%     %      isj(:,2).*j11+isj(:,4).*j21+isj(:,5).*j31   isj(:,2).*j12+isj(:,4).*j22+isj(:,5).*j32   isj(:,2).*j13+isj(:,4).*j23+isj(:,5).*j33
%     %      isj(:,3).*j11+isj(:,5).*j21+isj(:,6).*j31   isj(:,3).*j12+isj(:,5).*j22+isj(:,6).*j32   isj(:,3).*j13+isj(:,5).*j23+isj(:,6).*j33]
%
%     % M.. = [R.1*R.1   R.1*R.2+R.2*R.1   R.1*R.3+R.3*R.1   R.2*R.2   R.2*R.3+R.3*R.2   R.3*R.3]
%     % wobei M21 = M12, M31=M13, M32=M23 wegen Tensorsymmetrie
%     ri = [1 2 3 1 2 3; ... % xx
%           1 2 3 2 4 5; ... % xy
%           1 2 3 3 5 6; ... % xz
%           2 4 5 2 4 5; ... % yy
%           2 4 5 3 5 6; ... % yz
%           3 5 6 3 5 6];    % zz
    % inverse rotation means rotation with R'     
    % R = [isj(:,1).*j11+isj(:,2).*j21+isj(:,3).*j31   isj(:,2).*j11+isj(:,4).*j21+isj(:,5).*j31   isj(:,3).*j11+isj(:,5).*j12+isj(:,6).*j13 
    %      isj(:,1).*j12+isj(:,2).*j22+isj(:,3).*j32   isj(:,2).*j12+isj(:,4).*j22+isj(:,5).*j32   isj(:,3).*j12+isj(:,5).*j22+isj(:,6).*j33
    %      isj(:,1).*j13+isj(:,2).*j23+isj(:,3).*j33   isj(:,2).*j13+isj(:,4).*j23+isj(:,5).*j33   isj(:,3).*j13+isj(:,5).*j23+isj(:,6).*j33]

    rj = [1 1;...
          1 2;...
          1 3;...
          2 2;...
          2 3;...
          3 3];
           
    for k=1:6
%         % rotation about R      
%         R11 = isj(:,:,ri(k,1)).*j11+isj(:,:,ri(k,2)).*j21+isj(:,:,ri(k,3)).*j31;
%         R12 = isj(:,:,ri(k,1)).*j12+isj(:,:,ri(k,2)).*j22+isj(:,:,ri(k,3)).*j32;
%         R13 = isj(:,:,ri(k,1)).*j13+isj(:,:,ri(k,2)).*j23+isj(:,:,ri(k,3)).*j33;
%         R21 = isj(:,:,ri(k,4)).*j11+isj(:,:,ri(k,5)).*j21+isj(:,:,ri(k,6)).*j31;
%         R22 = isj(:,:,ri(k,4)).*j12+isj(:,:,ri(k,5)).*j22+isj(:,:,ri(k,6)).*j32;
%         R23 = isj(:,:,ri(k,4)).*j13+isj(:,:,ri(k,5)).*j23+isj(:,:,ri(k,6)).*j33;
         % rotation about R'
         R11 = isj(:,:,1).*J(:,:,1,rj(k,1))+isj(:,:,2).*J(:,:,2,rj(k,1))+isj(:,:,3).*J(:,:,3,rj(k,1));
         R12 = isj(:,:,2).*J(:,:,1,rj(k,1))+isj(:,:,4).*J(:,:,2,rj(k,1))+isj(:,:,5).*J(:,:,3,rj(k,1));
         R13 = isj(:,:,3).*J(:,:,1,rj(k,1))+isj(:,:,5).*J(:,:,2,rj(k,1))+isj(:,:,6).*J(:,:,3,rj(k,1));
         R21 = isj(:,:,1).*J(:,:,1,rj(k,2))+isj(:,:,2).*J(:,:,2,rj(k,2))+isj(:,:,3).*J(:,:,3,rj(k,2));
         R22 = isj(:,:,2).*J(:,:,1,rj(k,2))+isj(:,:,4).*J(:,:,2,rj(k,2))+isj(:,:,5).*J(:,:,3,rj(k,2));
         R23 = isj(:,:,3).*J(:,:,1,rj(k,2))+isj(:,:,5).*J(:,:,2,rj(k,2))+isj(:,:,6).*J(:,:,3,rj(k,2));
        DR =  R11 .* R21               .* D(:,:,1) + ...
             (R11 .* R22 + R12 .* R21) .* D(:,:,2) + ...
             (R11 .* R23 + R13 .* R21) .* D(:,:,3) + ...
              R12 .* R22               .* D(:,:,4) + ...
             (R12 .* R23 + R13 .* R22) .* D(:,:,5) + ...
              R13 .* R23               .* D(:,:,6);
        VO(k) = spm_write_plane(VO(k), DR, j);
    end;
    spm_progress_bar('Set',j);
end;
spm_progress_bar('Clear');
return;
%_______________________________________________________________________

%_______________________________________________________________________
function VO   = make_hdr_struct(V,x,y,z,mat)
VO            = V;
VO.fname      = prepend(V.fname,'W2');
VO.mat        = mat;
VO.dim(1:3)   = [length(x) length(y) length(z)];
VO.pinfo(3,1) = 0;
VO.descrip    = 'spm - 3D normalized';
return;
%_______________________________________________________________________

%_______________________________________________________________________
function T2 = get_2Dtrans(T3,B,j)
d   = [size(T3) 1 1 1];
tmp = reshape(T3,d(1)*d(2),d(3));
T2  = reshape(tmp*B(j,:)',d(1),d(2));
return;
%_______________________________________________________________________

%_______________________________________________________________________
function PO = prepend(PI,pre)
[pth,nm,xt,vr] = spm_fileparts(deblank(PI));
PO             = fullfile(pth,[nm(1:3) pre nm(4:end) xt vr]);
return;
%_______________________________________________________________________

%_______________________________________________________________________
function [X2,Y2,Z2] = mmult(X1,Y1,Z1,Mult)
if length(Z1) == 1,
	X2= Mult(1,1)*X1 + Mult(1,2)*Y1 + (Mult(1,3)*Z1 + Mult(1,4));
	Y2= Mult(2,1)*X1 + Mult(2,2)*Y1 + (Mult(2,3)*Z1 + Mult(2,4));
	Z2= Mult(3,1)*X1 + Mult(3,2)*Y1 + (Mult(3,3)*Z1 + Mult(3,4));
else
	X2= Mult(1,1)*X1 + Mult(1,2)*Y1 + Mult(1,3)*Z1 + Mult(1,4);
	Y2= Mult(2,1)*X1 + Mult(2,2)*Y1 + Mult(2,3)*Z1 + Mult(2,4);
	Z2= Mult(3,1)*X1 + Mult(3,2)*Y1 + Mult(3,3)*Z1 + Mult(3,4);
end;
return;
%_______________________________________________________________________

%_______________________________________________________________________
function [bb,vx] = bbvox_from_V(V)
vx = sqrt(sum(V.mat(1:3,1:3).^2));
if det(V.mat(1:3,1:3))<0, vx(1) = -vx(1); end;

o  = V.mat\[0 0 0 1]';
o  = o(1:3)';
bb = [-vx.*(o-1) ; vx.*(V.dim(1:3)-o)]; 
return;
%_______________________________________________________________________

%_______________________________________________________________________
function [x,y,z,mat] = get_xyzmat(prm,bb,vox)
% The old voxel size and origin notation is used here.
% This requires that the position and orientation
% of the template is transverse.  It would not be
% straitforward to account for templates that are
% in different orientations because the basis functions
% would no longer be seperable.  The seperable basis
% functions mean that computing the deformation field
% from the parameters is much faster.

% bb  = sort(bb);
% vox = abs(vox);

msk       = find(vox<0);
bb        = sort(bb);
bb(:,msk) = flipud(bb(:,msk));

% Adjust bounding box slightly - so it rounds to closest voxel.
% Comment out if not needed.  I chose not to change it because
% it would lead to being bombarded by questions about spatially
% normalised images not having the same dimensions.
bb(:,1) = round(bb(:,1)/vox(1))*vox(1);
bb(:,2) = round(bb(:,2)/vox(2))*vox(2);
bb(:,3) = round(bb(:,3)/vox(3))*vox(3);

M   = prm.VG(1).mat;
vxg = sqrt(sum(M(1:3,1:3).^2));
if det(M(1:3,1:3))<0, vxg(1) = -vxg(1); end;
ogn = M\[0 0 0 1]';
ogn = ogn(1:3)';

% Convert range into range of voxels within template image
x   = (bb(1,1):vox(1):bb(2,1))/vxg(1) + ogn(1);
y   = (bb(1,2):vox(2):bb(2,2))/vxg(2) + ogn(2);
z   = (bb(1,3):vox(3):bb(2,3))/vxg(3) + ogn(3);

og  = -vxg.*ogn;

% Again, chose whether to round to closest voxel.
of  = -vox.*(round(-bb(1,:)./vox)+1);
%of = bb(1,:)-vox;

M1  = [vxg(1) 0 0 og(1) ; 0 vxg(2) 0 og(2) ; 0 0 vxg(3) og(3) ; 0 0 0 1];
M2  = [vox(1) 0 0 of(1) ; 0 vox(2) 0 of(2) ; 0 0 vox(3) of(3) ; 0 0 0 1];
mat = prm.VG(1).mat/M1*M2;

LEFTHANDED = true;
if (LEFTHANDED && det(mat(1:3,1:3))>0) || (~LEFTHANDED && det(mat(1:3,1:3))<0),
	Flp = [-1 0 0 (length(x)+1); 0 1 0 0; 0 0 1 0; 0 0 0 1];
	mat = mat*Flp;
	x   = flipud(x(:))';
end;
return;


