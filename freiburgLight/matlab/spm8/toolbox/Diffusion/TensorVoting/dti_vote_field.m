function [f, ss] = dti_vote_field(t, varargin);
% changed tensor order to alphabetical convention
%
% This function is part of the diffusion toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.

%_______________________________________________________________________
%
% @(#) $Id$

rev = '$Revision$';

if nargin > 1 fwhma = varargin{1}; else fwhma = .5; end;
if nargin > 2 fwhmd = varargin{2}; else fwhmd = .3; end;
if nargin > 3 kstep = varargin{3}; else kstep = 1/3; end;
if nargin > 4 klen = varargin{4};  else klen = 3; end;
if nargin > 5 stcut = varargin{5}; else stcut = .005; end; % 5 percent strength cutoff

warning off;
persistent dti_vf_x dti_vf_y dti_vf_z dti_vf_szf dti_vf_cent;
if isempty(dti_vf_x)
  [dti_vf_x,dti_vf_y,dti_vf_z]=ndgrid(-klen:kstep:klen);
  dti_vf_szf=size(dti_vf_x);
  dti_vf_cent = sub2ind(dti_vf_szf,(dti_vf_szf(1)-1)/2+1,(dti_vf_szf(2)-1)/2+1,(dti_vf_szf(3)-1)/2+1);
end;

[v d] = eig([t(1) t(2) t(3); ...
             t(2) t(4) t(5); ...
	     t(3) t(5) t(6)]);
d=abs(diag(d)); % we should only have positive eigenvalues anyway
[tmp ind] = sort(-d); % need to sort in descending order
v=v(:,ind);
d=d(ind);

f = zeros([6 prod(dti_vf_szf)]);
ss = zeros(1,prod(dti_vf_szf));

% rotation in template system
kxyz=inv(v)*[dti_vf_x(:) dti_vf_y(:) dti_vf_z(:)]';
kxyz12 =kxyz(1,:).^2+kxyz(2,:).^2;
kxyz23 =kxyz(2,:).^2+kxyz(3,:).^2;
kxyz123=kxyz12+kxyz(3,:).^2;

% stick field
% height = distance from x==0 in y-z-plane
h=sqrt(kxyz23);

% r^2 = (r-h)^2 + x^2
r=kxyz123./(2*h);

% rotation about y axis
calpha=(r-h)./r;
calpha(r==Inf)=1;
salpha=sqrt(1-calpha.^2);
aalpha=abs(acos(calpha));
% don't connect arc to points with rotation angles greater than pi 
sel=(aalpha>pi/2);

% length scaling according to angle
l = r.*aalpha;
l(aalpha==0)=abs(kxyz(1,aalpha==0));

c=r.^(-2);
c(r==Inf)=0;
%lm=min(klen./abs([dti_vf_x(:) dti_vf_y(:) dti_vf_z(:)]'));
lm=min(1./abs(v(:,1)));
%strength = exp(-fwhma*c).*exp(-fwhmd*l.^2);
strength = exp(-fwhma*c).*exp(-fwhmd*(l./lm).^2);
strength(~isfinite(strength)) = 0;
strength(strength<stcut) = 0;
strength(sel) = 0;

% rotation about x axis (for rotational symmetry)
cbeta=(kxyz(1,:)./sqrt(kxyz123));
sbeta=sqrt(1-cbeta.^2);
xs1=kxyz(1,:).*calpha;
ys1=h.*salpha.*cbeta;
zs1=h.*salpha.*sbeta;
lenscale=strength./sqrt(xs1.^2+ys1.^2+zs1.^2);
xs=lenscale.*abs(xs1).*sign(kxyz(1,:));
ys=lenscale.*abs(ys1).*sign(kxyz(2,:));
zs=lenscale.*abs(zs1).*sign(kxyz(3,:));

% rotate back, align to 1st eigenvector
xstmp=v*[xs(:) ys(:) zs(:)]';
xs=xstmp(1,:);
ys=xstmp(2,:);
zs=xstmp(3,:);

xs(dti_vf_cent)=v(1,1);
ys(dti_vf_cent)=v(2,1);
zs(dti_vf_cent)=v(3,1);
strength(dti_vf_cent)=1;

xs(~isfinite(xs))=0;
ys(~isfinite(ys))=0;
zs(~isfinite(zs))=0;
  
f(1,:) = f(1,:) + (d(1)-d(2))*xs.*xs;
f(2,:) = f(2,:) + (d(1)-d(2))*xs.*ys;
f(3,:) = f(3,:) + (d(1)-d(2))*xs.*zs;
f(4,:) = f(4,:) + (d(1)-d(2))*ys.*ys;
f(5,:) = f(5,:) + (d(1)-d(2))*ys.*zs;
f(6,:) = f(6,:) + (d(1)-d(2))*zs.*zs;
ss = ss+strength;

% plate field

% height is just abs(z)
% r^2 = (r-h)^2 + (x^2 + y^2)
r=(kxyz123)./(2*abs(kxyz(3,:)));

% rotation out of (x,y)-plane
calpha=(r-abs(kxyz(3,:)))./r;
calpha(r==Inf)=1;
salpha=sqrt(1-calpha.^2);
aalpha=abs(acos(calpha));
aalpha(kxyz(3,:)==0)=0;
% don't connect arc to points with rotation angles greater than pi 
sel=(aalpha>pi/2);

% length scaling according to angle
l = r.*aalpha;
l(aalpha==0)=sqrt(kxyz(1,aalpha==0).^2+kxyz(2,aalpha==0).^2);

c=r.^(-2);
c(r==Inf)=0;

lm=min(1./abs(v(:,3)));
%strength = exp(-fwhma*c).*exp(-fwhmd*l.^2);
strength = exp(-fwhma*c).*exp(-fwhmd*(l./lm).^2);
strength(~isfinite(strength)) = 0;
strength(strength<stcut) = 0;
strength(sel) = 0;
% 1st eigenvector
xy=sqrt(kxyz12);
xr1=kxyz(1,:)./xy.*calpha;
yr1=kxyz(2,:)./xy.*calpha;
zr1=salpha;

lenscale=strength./sqrt(xr1.^2+yr1.^2+zr1.^2);
xr=lenscale.*abs(xr1).*sign(kxyz(1,:));
yr=lenscale.*abs(yr1).*sign(kxyz(2,:));
zr=lenscale.*abs(zr1).*sign(kxyz(3,:));

% 2nd eigenvector: (-y,x,0)
lenscale=strength./sqrt(kxyz12);
xt=lenscale.*(-kxyz(2,:));
yt=lenscale.*kxyz(1,:);
zt=zeros(size(kxyz(3,:)));

% rotate back, align to 3rd eigenvector
xrtmp=v*[xr(:) yr(:) zr(:)]';
xr=xrtmp(1,:);
yr=xrtmp(2,:);
zr=xrtmp(3,:);
xr(dti_vf_cent)=v(1,1);
yr(dti_vf_cent)=v(2,1);
zr(dti_vf_cent)=v(3,1);
xr(~isfinite(xr))=0;
yr(~isfinite(yr))=0;
zr(~isfinite(zr))=0;

% rotate back, align to 3rd eigenvector
xttmp=v*[xt(:) yt(:) zt(:)]';
xt=xttmp(1,:);
yt=xttmp(2,:);
zt=xttmp(3,:);
xt(dti_vf_cent)=v(1,2);
yt(dti_vf_cent)=v(2,2);
zt(dti_vf_cent)=v(3,2);
xt(~isfinite(xt))=0;
yt(~isfinite(yt))=0;
zt(~isfinite(zt))=0;

% add to voting field
f(1,:) = f(1,:) + (d(2)-d(3))*(xr.*xr+xt.*xt);
f(2,:) = f(2,:) + (d(2)-d(3))*(xr.*yr+xt.*yt);
f(3,:) = f(3,:) + (d(2)-d(3))*(xr.*zr+xt.*zt);
f(4,:) = f(4,:) + (d(2)-d(3))*(yr.*yr+yt.*yt);
f(5,:) = f(5,:) + (d(2)-d(3))*(yr.*zr+yt.*zt);
f(6,:) = f(6,:) + (d(2)-d(3))*(zr.*zr+zt.*zt);

ss = ss+strength;

% ball field
lm=1;
%strength=exp(-fwhmd*kxyz123);
strength=exp(-fwhmd*kxyz123./lm.^2);
strength(strength<stcut) = 0;

zrs=zeros(size(strength(:)));
x1tmp=v*[strength(:) zrs(:) zrs(:)]';
x1=x1tmp(1,:);
y1=x1tmp(2,:);
z1=x1tmp(3,:);
x2tmp=v*[zrs(:) strength(:) zrs(:)]';
x2=x2tmp(1,:);
y2=x2tmp(2,:);
z2=x2tmp(3,:);
x3tmp=v*[zrs(:) zrs(:) strength(:)]';
x3=x3tmp(1,:);
y3=x3tmp(2,:);
z3=x3tmp(3,:);

% add to voting field
f(1,:) = f(1,:) + d(3)*(x1.*x1+x2.*x2+x3.*x3);
f(2,:) = f(2,:) + d(3)*(x1.*y1+x2.*y2+x3.*y3);
f(3,:) = f(3,:) + d(3)*(x1.*z1+x2.*z2+x3.*z3);
f(4,:) = f(4,:) + d(3)*(y1.*y1+y2.*y2+y3.*y3);
f(5,:) = f(5,:) + d(3)*(y1.*z1+y2.*z2+y3.*z3);
f(6,:) = f(6,:) + d(3)*(z1.*z1+z2.*z2+z3.*z3);

ss = ss+strength;
ss = reshape(ss/3,dti_vf_szf);
f = reshape(f,[6 dti_vf_szf]);

function f=dti_vote_field_old(t)

fwhmk = .7; % kernel fwhm
fwhma = .2; % aperture fwhm
[xk,yk,zk]=meshgrid(-1:.2:1);

% symmetric distance kernel
dkrnl  = xk.^2+yk.^2+zk.^2;

% symmetric kernel with gaussian shape
sqdkrnl = sqrt(dkrnl); sqdkrnl(sqdkrnl==0) = eps;
nkrnl(:,:,:,1)=xk./sqdkrnl;
nkrnl(:,:,:,2)=yk./sqdkrnl;
nkrnl(:,:,:,3)=zk./sqdkrnl;
krnl = nkrnl.*repmat(exp(-(dkrnl)./fwhmk),[1 1 1 3]);
sk=size(krnl);

% get eigenvectors, eigenvalues
f=zeros([sk(1:3) 3 3]);
if isfinite(t)
  [v,d]=eig(t);

  for k=1:3
    % angle between eigenvector and kernel, exponential decay
    krnl(6,6,6,:)=v(:,k);
    nkrnl(6,6,6,:)=v(:,k);
    akrnl = exp(-(1-abs(sum(nkrnl.*repmat(shiftdim(v(:,k)',-2),...
	[sk(1:3) 1]),4)))./fwhma);
    
    tmp=repmat(krnl.*repmat(akrnl,[1 1 1 3]),[1 1 1 1 3]);  % 3x3 columns of vectors
    f = f + d(k).*tmp.*permute(tmp,[1 2 3 5 4]); % 3x3c.*3x3r => 3x3 tensor
  end;
end;

