function varargout=dti_dt_time3(bch)
% Compute time of arrival map for diffusion data
%
% A level set algorithm is used to compute time of arrival maps. Starting 
% with a start region, diffusion is simulated by evaluating the 
% diffusivity profile at each voxel of a propagating front. The profile 
% is computed efficiently from arbitrary order tensors.
%
% References:
% [Set96]      Sethian, James A. A Fast Marching Level Set Method for 
%              Monotonically Advancing Fronts. Proceedings of the 
%              National Academy of Sciences, USA, 93(4):1591 -- 1595, 1996.
% [?M03]       ?rszalan, Evren and Thomas H Mareci. Generalized Diffusion 
%              Tensor Imaging and Analytical Relationships Between 
%              Diffusion Tensor Imaging and High Angular Resolution 
%              Diffusion Imaging. Magnetic Resonance in Medicine, 
%              50:955--965, 2003.
%
% Batch processing:
% FORMAT dti_dt_time3(bch)
% ======
% Input argument:
%   bch - struct with batch descriptions, containing the following 
%         fields:
%         .order  - tensor order
%         .files - cell array of tensor image filenames
%         .mask  - image mask
%         .sroi  - starting ROI
%         .eroi  - end ROI (optional)
%         .frac  - maximum fraction of voxels that should be visited 
%                  (range 0-1)
%         .resfile - results filename stub
%         .nb    - neighbourhood (one of 6, 18, 26)
%         .exp   - Exponential for tensor elements (should be an odd integer)
%
% This function is part of the diffusion toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: dti_dt_time3.m 543 2008-03-12 19:40:40Z glauche $

rev = '$Revision: 543 $';
funcname = 'Time of arrival (DT)';
  
% function preliminaries
Finter=spm_figure('GetWin','Interactive');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

% DEBUG
debug = true;
if debug
    dTV = spm_vol(spm_select(1,'image','Tloc image'));
    dTind = find(spm_read_vols(dTV));
end;
% ~DEBUG

DH = spm_vol(char(bch.dtimg));
% get vox and mm coordinates of DH voxels
[x y z]=ndgrid(1:DH(1).dim(1),1:DH(1).dim(2),1:DH(1).dim(3));
Dxyzvx = [x(:)';y(:)';z(:)'; ones(1,numel(x))];
xyzmm=DH(1).mat*Dxyzvx;

% resample Mask and ROI(s) in DH space
MaskH=spm_vol(bch.maskimg{1});
Mxyzvx=inv(MaskH.mat)*xyzmm;
MaskDt=reshape(spm_sample_vol(MaskH,Mxyzvx(1,:),Mxyzvx(2,:),Mxyzvx(3,:),0),...
               DH(1).dim(1:3));
MaskDt(~isfinite(MaskDt))=0;
MaskDt = logical(MaskDt);

SRoiH=spm_vol(bch.sroi{1});
Sxyzvx=inv(SRoiH.mat)*xyzmm;
alive=MaskDt&logical(reshape(spm_sample_vol(SRoiH, Sxyzvx(1,:), Sxyzvx(2,:),...
                                    Sxyzvx(3,:),0),...
                     DH(1).dim(1:3)));
    
if isempty(bch.eroi{1})
    EndDt = [];
else
    EndH=spm_vol(bch.eroi{1});
    Exyzvx=inv(EndH.mat)*xyzmm;
    EndDt=MaskDt&logical(reshape(spm_sample_vol(EndH, Exyzvx(1,:), Exyzvx(2,:),...
                                        Exyzvx(3,:),0),...
                         DH(1).dim(1:3)));
    if ~any(EndDt(:))
        EndDt = [];
    end;
end;
clear Mxyzvx Sxyzvx Exyzvx

% we need voxel size later on
VOX = sqrt(sum(DH(1).mat(1:3,1:3).^2));

sumu=floor(bch.frac*sum(MaskDt(:)==true));

bandx=false(DH(1).dim(1:3));
bandy=false(DH(1).dim(1:3));
bandz=false(DH(1).dim(1:3));

bandx(2:end,:,:)=alive(1:end-1,:,:);
bandx(1:end-1,:,:)=bandx(1:end-1,:,:)|alive(2:end,:,:);
bandx=bandx&~alive&MaskDt;
bandy(:,2:end,:)=alive(:,1:end-1,:);
bandy(:,1:end-1,:)=bandy(:,1:end-1,:)|alive(:,2:end,:);
bandy=bandy&~alive&MaskDt;
bandz(:,:,2:end)=alive(:,:,1:end-1);
bandz(:,:,1:end-1)=bandz(:,:,1:end-1)|alive(:,:,2:end);
bandz=bandz&~alive&MaskDt;
band=bandx|bandy|bandz;
clear bandx bandy bandz;

T=inf(DH(1).dim(1:3));
D=inf(DH(1).dim(1:3));
P=inf(DH(1).dim(1:3));
Tloc=zeros(DH(1).dim(1:3));
Tnumb=zeros(DH(1).dim(1:3));
T(alive)=0;
D(alive)=1;
P(alive)=0;
D(band)=1;

[Hind mult] = dti_dt_order(bch.dtorder);
global nbhood;
nbhood=dti_sphere_nb(struct('nb',bch.nb));
nbhood.nbdist=sqrt(sum(abs(nbhood.nbhood).*...
                       repmat(VOX.^2,bch.nb,1),2))';
% pre-compute HM
for cnb=1:bch.nb
    nbhood.HM{cnb} = zeros(size(nbhood.Vd{cnb},1),size(Hind,2));
    for k = 1:size(Hind,2)
        nbhood.HM{cnb}(:,k) = prod(nbhood.Vd{cnb}(:,Hind(:,k)),2)*mult(k);
    end;
end;

% Initialize T(band)
% for each band voxel, take the minimum time needed from any of the
% neighbouring alive voxels
bind = find(band);
bD=zeros(numel(DH),numel(bind));
for k=1:numel(DH)
    bD(k,:) = (10.^7)*...
              spm_sample_vol(DH(k), Dxyzvx(1,bind), Dxyzvx(2,bind), Dxyzvx(3,bind),0)';
end;
for cb = 1:numel(bind)
    cnsub = nbhood.nbhood+nbhood.ones*(Dxyzvx(1:3,bind(cb))');
    % Two step indexing
    % 1st: Neighbour voxels within volume 
    cnvol = find(all(cnsub>0 & cnsub<=nbhood.ones*DH(1).dim(1:3),2));
%    cnsub = cnsub(sel,:);
%    cnnum = nbhood.num(sel);
%    cninum= nbhood.inum(sel);
    % subscript indexing does not work vector-wise, therefore linear index
    % necessary
    cnind = sub2ind(DH(1).dim(1:3),cnsub(cnvol,1), cnsub(cnvol,2),...
        cnsub(cnvol,3));
    % 2nd: Alive neighbours - index into cnvol
    cnavol = cnvol(alive(cnind));
    aD=zeros(numel(DH),numel(cnavol));
    for k=1:numel(DH)
        aD(k,:) = (10.^7)*...
                  spm_sample_vol(DH(k),cnsub(cnavol,1),cnsub(cnavol,2),cnsub(cnavol,3),0)';
    end;
    tmpT=zeros(size(cnavol));
    for ca = 1:numel(cnavol)
        tmpT(ca) = nbhood.nbdist(nbhood.num(cnavol(ca)))./...
            fvel(aD(:,ca), bD(:,cb),...
                 nbhood.Vd{nbhood.num(cnavol(ca))}, nbhood.Vd{nbhood.inum(cnavol(ca))},...
                 nbhood.HM{nbhood.num(cnavol(ca))}, nbhood.HM{nbhood.inum(cnavol(ca))},...
                 -nbhood.nbhood(cnavol(ca),1:3),bch.exp);
    end;
    T(bind(cb)) = min(tmpT);
end;

% DEBUG
if debug
    dband = false(sumu+1, numel(dTind));
    dalive = false(sumu+1, numel(dTind));
    dT = inf(sumu+1, numel(dTind));
    dband(1,:) = band(dTind);
    dalive(1,:) = alive(dTind);
    dT(1,:) = T(dTind);
end;
% ~DEBUG
mT = zeros(1,sumu);
f=spm_figure('GetWin', 'Interactive');
spm_figure('Clear', f);
for numb=1:sumu
    bind=find(band);
    if isempty(bind)
        break;
    end;
    [mT(numb) ind1]=min(T(band));
    if mT(numb) == Inf
        break;
    end;
    if rem(numb,100)==0
        figure(f);plot(mT(1:numb));
        xlabel('Iterations');
        ylabel('Min time');
    end;
    [cx cy cz] = ind2sub(DH(1).dim(1:3), bind(ind1(1)));
    alive(cx,cy,cz)=true;
    band(cx,cy,cz)=false;
    if ~isempty(EndDt) && all(alive(EndDt(:)))
        break;
    end;
    
    nbx = cx+nbhood.nbhood(:,1);
    nby = cy+nbhood.nbhood(:,2);
    nbz = cz+nbhood.nbhood(:,3);
    sel = (nbx>=1) & (nby>=1) & (nbz>=1) &...
          (nbx<=DH(1).dim(1)) & (nby<=DH(1).dim(2)) & (nbz<=DH(1).dim(3));
    nbnum = nbhood.num(sel);
    nbinum= nbhood.inum(sel);
    nbx = nbx(sel);
    nby = nby(sel);
    nbz = nbz(sel);
    cD=zeros(numel(DH),size(nbx,1)+1);
    for k=1:numel(DH)
        cD(k,:) = (10.^7)*...
                  spm_sample_vol(DH(k), [cx; nbx], [cy; nby], [cz; nbz],0)';
    end;
    
    trec = inf(1,size(nbhood.nbhood, 1));
    % neighbour select
    for nbk = 1:numel(nbx)
        if ~alive(nbx(nbk),nby(nbk),nbz(nbk)) && MaskDt(nbx(nbk),nby(nbk), ...
                                                       nbz(nbk))
            band(nbx(nbk),nby(nbk),nbz(nbk)) = true;
            vel = fvel(cD(:,1), cD(:,nbk+1), ...
                       nbhood.Vd{nbnum(nbk)}, nbhood.Vd{nbinum(nbk)},...
                       nbhood.HM{nbnum(nbk)}, nbhood.HM{nbinum(nbk)},...
                       [cx-nbx(nbk), cy-nby(nbk), cz-nbz(nbk)],bch.exp);         
            if vel > 0
                % [nbhood.nbhood ones(18,1)]*[[eye(3) [nbx(nbk); nby(nbk); nbz(nbk)]]; 0 0 0 1]'
                nbrec = [nbhood.nbhood(:,1)+nbx(nbk),...
                         nbhood.nbhood(:,2)+nby(nbk) nbhood.nbhood(:,3)+nbz(nbk)];
                
                sel = nbrec(:,1)>=1 & nbrec(:,2)>=1 & nbrec(:,3)>=1 &...
                      nbrec(:,1)<=DH(1).dim(1) & nbrec(:,2)<=DH(1).dim(2) &...
                      nbrec(:,3)<=DH(1).dim(3);
                nbind = sub2ind(DH(1).dim(1:3),...
                                nbrec(sel,1), nbrec(sel,2), nbrec(sel,3));
                trec(sel) = T(nbind);
                trec(~sel) = Inf;
                if any(isfinite(trec))    
                    try %FIXME nbdist
                        % this fzero call has a huge overhead, but
                        % dti_dt_fzero is out of date
                        % tmp = dti_dt_fzero(mT(numb), opts, trec, nbhood.nbdist, vel);
                        % tmp = fzero(@(t) diffT1(t, trec, nbhood.nbdist, vel), mT(numb));
                        tmp = fzero(@(t) sum(min((trec-t)./nbhood.nbdist,0).^2) - 1/vel.^2, mT(numb));                        
                        if (tmp<T(nbx(nbk),nby(nbk),nbz(nbk)))
                            if tmp < mT(numb)
                                Tloc(nbx(nbk),nby(nbk),nbz(nbk))=tmp;
                                Tnumb(nbx(nbk),nby(nbk),nbz(nbk))=numb;
                            end,
                            D(nbx(nbk),nby(nbk),nbz(nbk)) = D(cx,cy,cz) + 1;
                            P(nbx(nbk),nby(nbk),nbz(nbk)) = bind(ind1(1));
                            T(nbx(nbk),nby(nbk),nbz(nbk))=tmp;
                        end;
                    catch
                        disp(lasterr),
                    end
                else
                    warning('Time not updated.');
                end;
            end;            
        end;
    end;
    % DEBUG
    if debug
        dband(numb+1,:) = band(dTind);
        dalive(numb+1,:) = alive(dTind);
        dT(numb+1,:) = T(dTind);
    end;
    % ~DEBUG
    %    spm_progress_bar('Set',numb);
end;
    
Ta=full(T);
Tb=full(T);
Ta(~(isfinite(Ta)&alive)) = NaN;
Tb(~(isfinite(Tb)&band)) = NaN;

P(~alive)=NaN;
D(~alive)=NaN;
Htmp = DH(1);
Htmp.dt = [spm_type('float32') spm_platform('bigend')];
THa = Htmp;
THb = Htmp;
THl = Htmp;
DstH = Htmp;
PH = Htmp;
VH = Htmp;

[p n e v] = spm_fileparts(Htmp.fname);

switch bch.resfile
case 's',
    [p1 n e1 v1] = spm_fileparts(bch.sroi{1});
case 't',
    [p1 n e1 v1] = spm_fileparts(bch.dtimg{1});
case 'e',
    if ~isempty(bch.eroi{1})
        [p1 n e1 v1] = spm_fileparts(bch.eroi{1});
    else
        warning('No end ROI defined, using start ROI.');
        [p1 n e1 v1] = spm_fileparts(bch.sroi{1});
    end;
end;

THa.fname = fullfile(bch.swd{1}, ['ta_' n e]);
res.ta = {THa.fname};
THb.fname = fullfile(bch.swd{1}, ['tb_' n e]);
res.tb = {THb.fname};
THl.fname = fullfile(bch.swd{1}, ['tl_' n e]);
res.tl = {THl.fname};
DstH.fname = fullfile(bch.swd{1}, ['dst_' n e]);
res.dst = {DstH.fname};
PH.fname = fullfile(bch.swd{1}, ['trc_' n e]);
res.trc = PH.fname;
VH.fname = fullfile(bch.swd{1}, ['vel_' n e]);
res.vel = VH.fname;

spm_write_vol(THa,reshape(Ta,THa.dim(1:3)));
spm_write_vol(THb,reshape(Tb,THb.dim(1:3)));
spm_write_vol(THl,reshape(Tloc,THb.dim(1:3)));
spm_write_vol(DstH,reshape(D,DstH.dim(1:3)));
spm_write_vol(PH,reshape(P,PH.dim(1:3)));
spm_write_vol(VH,D./reshape(Ta,PH.dim(1:3)));

if nargout>0
    varargout{1} = res;
end;
if nargout>1
    varargout{2} = bch;
end;
spm('pointer','arrow');
return;

function err = diffT(t,t1,dx,vel)
% t1 directions are x, y, z, -x, -y, -z
err = max( max((t1(4)-t)/(-dx(1)),0), -min((t1(1)-t)/dx(1),0) ).^2 + ...
    max( max((t1(5)-t)/(-dx(2)),0), -min((t1(2)-t)/dx(2),0) ).^2 + ...
    max( max((t1(6)-t)/(-dx(3)),0), -min((t1(3)-t)/dx(3),0) ).^2 - 1/vel.^2;
disc=[max((t1(4)-t)/(-dx(1)),0).^2 min((t1(1)-t)/dx(1),0).^2 ...
      max((t1(5)-t)/(-dx(2)),0).^2 min((t1(2)-t)/dx(2),0).^2 ...
      max((t1(6)-t)/(-dx(3)),0).^2 min((t1(3)-t)/dx(3),0).^2];

return;

function err = diffT1(t,t1,dx,vel)
% t1 directions are x, y, z, -x, -y, -z
% max(-x -y -z replaced by min(x y z
%err = min((t1(4)-t)/dx(1),0).^2 + min((t1(1)-t)/dx(1),0).^2 + ...
%    min((t1(5)-t)/dx(2),0).^2 + min((t1(2)-t)/dx(2),0).^2 + ...
%    min((t1(6)-t)/dx(3),0).^2 + min((t1(3)-t)/dx(3),0).^2 - 1/vel.^2;
err = sum(min((t1-t)./dx,0).^2) - 1/vel.^2;

return;

function vel = fvel(D1,D2,G1,G2,HM1,HM2,dxyz,dexp)
% Compute ADCs (or correcty B:D, which is a scaled ADC if B = b*gg' for a
% gradient vector g) from tensors for all directions on unit sphere that
% have current neighbourhood direction as nearest neighbour. ADCs will be
% weighted by the euclidean distance between current neighbourhood
% direction and ADC direction. This distance function can be sharpened by
% specifying a direction exponential. Note that this sharpening is
% independent of diffusion direction, it only imposes a weighting dependent
% on the distance between front direction and ADC direction.
Dtmp1=HM1*D1;
Dtmp2=HM2*D2;
Dsel1 = Dtmp1>0;
Dsel2 = Dtmp2>0;
ndxyz = dxyz/sqrt(sum(dxyz.^2));

vel = sqrt(Dtmp1(Dsel1)'*(G1(Dsel1,:)*ndxyz')/sum(Dsel1)*Dtmp2(Dsel2)'*(G2(Dsel2,:)*(-ndxyz'))/sum(Dsel2));
