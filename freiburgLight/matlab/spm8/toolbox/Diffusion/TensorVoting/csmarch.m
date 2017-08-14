function ret=march
Vt = spm_vol(spm_get(3,'evec1*s*IMAGE','Curve tangents'));
Vt = {Vt(1), Vt(2), Vt(3)};
n = spm_read_vols(spm_vol(spm_get(3,'evec3*s*IMAGE','Surface normals')));

Ev = spm_read_vols(spm_vol(spm_get(3,'eval*s*IMAGE','Eigenvalues')));

St = (Ev(:,:,:,1) - Ev(:,:,:,2));%./Ev(:,:,:,1);
Sn = (Ev(:,:,:,2) - Ev(:,:,:,3));%./Ev(:,:,:,1);
Ss = Ev(:,:,:,3);%./Ev(:,:,:,1);

clear Ev
b=[0 0 0]; % border
xsel=b(1)+1:(size(St,1)-b(1));%30:63;
ysel=b(2)+1:(size(St,2)-b(2));%35:83;
zsel=b(3)+1:(size(St,3)-b(3));
t=t(xsel,ysel,zsel,:);
St=St(xsel,ysel,zsel);
St(~isfinite(St)|~any(isfinite(t),4)|St<0)=0;

n=n(xsel,ysel,zsel,:);
Sn=Sn(xsel,ysel,zsel);
Sn(~isfinite(Sn)|~any(isfinite(n),4)|Sn<0)=0;


hiSt = 1.2*mean(St(St(:)>0));
loSt = .05*mean(St(St(:)>0));
f=figure(2);
for k=1:size(St,3) 
  subplot(ceil(size(St,3)/5),5,k); ...
  imagesc((St(:,:,k)>hiSt)+(St(:,:,k)>loSt),[0 2]); 
  axis off;
  daspect([1 1 1]);
end
colormap gray
figure(f);
title(sprintf('Curve saliency - # seeds: %d; # voxels: %d',sum(St(:)>hiSt),sum(St(:)>loSt)));

hiSn = 6*mean(Sn(Sn(:)>0));
loSn = 4.5*mean(Sn(Sn(:)>0));
f=figure(3);
for k=1:size(Sn,3) 
  subplot(ceil(size(Sn,3)/5),5,k); ...
  imagesc((Sn(:,:,k)>hiSn)+(Sn(:,:,k)>loSn),[0 2]); 
  axis off;
  daspect([1 1 1]);
end
colormap gray
figure(f);
title(sprintf('Surface saliency - # seeds: %d; # voxels: %d',sum(Sn(:)>hiSn),sum(Sn(:)>loSn)));

L = dti_cmarch(t,St,hiSt,loSt);

FV= dti_smarch(n,Sn,hiSn,loSn);

M = Vt{1}.mat;

figure(4);
for k=1:length(L)
  d = abs(L{k}(1,:)-L{k}(end,:));
  [tmp ind] = max(d);
  switch ind(1)
    case 1
      lc = 'red';
    case 2
      lc = 'green';
    case 3
      lc = 'blue';
  end;
  switch length(L{k})
    case {15,16,17,18,19,20}
      lw = 1;
    case {21,22,23,24,25,26,27,28,29,30}
      lw = 2;
    otherwise
      disp(length(L{k}));
      lw = 3;
  end;
  % transform into SPM world coordinates
  L{k}(:,1) = L{k}(:,1)+xsel(1)-1;
  L{k}(:,2) = L{k}(:,2)+ysel(1)-1;
  L{k}(:,3) = L{k}(:,3)+zsel(1)-1;
  xyz = M*[L{k} ones(size(L{k},1),1)]';
  L{k} = xyz(1:3,:)';
  li(k)=line(L{k}(:,1),L{k}(:,2),L{k}(:,3),'color',lc,'linewidth',lw); 
end
view(3);
daspect([1 1 1]);
xlabel('x');
hold on;

if isempty(FV)
  return,
end;

figure(5);
for k=1:length(FV)
%  FVC = zeros(size(FV(k).V));
  for l=1:3
    mx = max(FV(k).V(:,l));
    mn = min(FV(k).V(:,l));
    d(l) = mx-mn;
%    if mx ~= mn
%      FVC(:,l) = (FV(k).V(:,l) - mn)/(mx-mn);
%    end;
  end;  
%  p(k)=patch('Faces',FV(k).F, 'Vertices',FV(k).V, 'FaceVertexCData',FVC, ...
%      'Edgecolor','none','Facecolor','interp');  
  [tmp ind] = max(d);
  switch(ind)
    case 1
      cp = 'red';
    case 2
      cp = 'green';
    case 3
      cp = 'blue';
  end;
  FV(k).V(:,1) = FV(k).V(:,1)+xsel(1)-1;
  FV(k).V(:,2) = FV(k).V(:,2)+ysel(1)-1;
  FV(k).V(:,3) = FV(k).V(:,3)+zsel(1)-1;
  xyz = M*[FV(k).V ones(size(FV(k).V,1),1)]';
  FV(k).V = xyz(1:3,:)';
  
  p(k)=patch('Faces',FV(k).F, 'Vertices',FV(k).V, 'FaceColor',cp, ...
      'Edgecolor','none');

end
view(3);
daspect([1 1 1]);
xlabel('x');
ret.L=L;
ret.FV=FV;

function ret = misc1(x)
figure;
ps=patch(isosurface(Ss,.8));
set(ps, 'FaceColor', 'red', 'EdgeColor', 'none');%,'FaceAlpha',.5);
daspect([1 1 1])
view(3)
camlight; lighting phong

ret.li=li;
ret.p=p;
ret.ps=ps;

function ret=misc(x)
%S=zeros(12,12,12);
%t=zeros(12,12,12,3);
%for k=2:11
%  S([k-1 k+1],k,k)=.2;
%  S(k,[k-1 k+1],k)=.2;
%  S(k,k,[k-1 k+1])=.2;

%  S(k,k,k)=1;
%  t([k-1 k+1],k,k,1:3)=.2;
%  t(k,[k-1 k+1],k,1:3)=.2;
%  t(k,k,[k-1 k+1],1:3)=.2;
%  t(k,k,k,:)=[1 1 1];
%end;

%for k=2:11
%  S(k,4:6,4:6)=S(k,4:6,4:6)+.3;
%  S(k,5,5) = 1.5;
%  t(k,4:6,4:6,1)=t(k,4:6,4:6,1)+repmat(.5,[1 3 3]);
%  t(k,5,5,:)=[1.7 0 0];
%end;


%S=S+.01*rand(12,12,12);
%t=t+.01*rand(12,12,12,3);

