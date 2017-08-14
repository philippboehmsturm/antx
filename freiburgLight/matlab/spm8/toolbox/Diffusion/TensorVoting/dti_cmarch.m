function Lines=dti_cmarch(Vt,S,hiS,loS,minlen)
% Vt: 3-by-1 cell array of volume handles or XDIM-by-YDIM-by-ZDIM arrays of
%     vector components for surface normals (represented in VOXEL space)
% S: XDIM-by-YDIM-by-ZDIM array of saliencies (eg. eval1-eval2)
%
% This function is part of the diffusion toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.

%_______________________________________________________________________
%
% @(#) $Id$

rev = '$Revision$';

szS = size(S);

h  = pqheap('init',S);

nL = 1;

while ((S(h.p(1)) > hiS) & (h.N > 0))
  maxL = 100; cuL = 0; cuL1 = 0;
  L    = repmat(NaN,[maxL 3]);
  L1   = [];
  rev  = 0;
  cuS  = double(h.p(1));
  [cuSx cuSy cuSz] = ind2sub(szS,cuS);
  stS  = cuS; % save start coordinate
  stSx = cuSx;
  stSy = cuSy;
  stSz = cuSz;
  while cuS~=0
    if ~any([cuSx cuSy cuSz] > szS-2) &...
	  ~any([cuSx cuSy cuSz] == 1) % range check
      dS1(1,1,1,:) = [S(cuSx  ,cuSy  ,cuSz  )-S(cuSx-1,cuSy  ,cuSz  );
	              S(cuSx  ,cuSy  ,cuSz  )-S(cuSx  ,cuSy-1,cuSz  );
		      S(cuSx  ,cuSy  ,cuSz  )-S(cuSx  ,cuSy  ,cuSz-1)];
      dS1(1,1,2,:) = [S(cuSx  ,cuSy  ,cuSz  )-S(cuSx-1,cuSy  ,cuSz  );
	              S(cuSx  ,cuSy  ,cuSz  )-S(cuSx  ,cuSy-1,cuSz  );
		      S(cuSx  ,cuSy  ,cuSz+2)-S(cuSx  ,cuSy  ,cuSz+1)];
      dS1(1,2,1,:) = [S(cuSx  ,cuSy  ,cuSz  )-S(cuSx-1,cuSy  ,cuSz  );
	              S(cuSx  ,cuSy+2,cuSz  )-S(cuSx  ,cuSy+1,cuSz  );
		      S(cuSx  ,cuSy  ,cuSz  )-S(cuSx  ,cuSy  ,cuSz-1)];
      dS1(1,2,2,:) = [S(cuSx  ,cuSy  ,cuSz  )-S(cuSx-1,cuSy  ,cuSz  );
	              S(cuSx  ,cuSy+2,cuSz  )-S(cuSx  ,cuSy+1,cuSz  );
		      S(cuSx  ,cuSy  ,cuSz+2)-S(cuSx  ,cuSy  ,cuSz+1)];
      dS1(2,1,1,:) = [S(cuSx+2,cuSy  ,cuSz  )-S(cuSx+1,cuSy  ,cuSz  );
	              S(cuSx  ,cuSy  ,cuSz  )-S(cuSx  ,cuSy-1,cuSz  );
		      S(cuSx  ,cuSy  ,cuSz  )-S(cuSx  ,cuSy  ,cuSz-1)];
      dS1(2,1,2,:) = [S(cuSx+2,cuSy  ,cuSz  )-S(cuSx+1,cuSy  ,cuSz  );
	              S(cuSx  ,cuSy  ,cuSz  )-S(cuSx  ,cuSy-1,cuSz  );
		      S(cuSx  ,cuSy  ,cuSz+2)-S(cuSx  ,cuSy  ,cuSz+1)];
      dS1(2,2,1,:) = [S(cuSx+2,cuSy  ,cuSz  )-S(cuSx+1,cuSy  ,cuSz  );
	              S(cuSx  ,cuSy+2,cuSz  )-S(cuSx  ,cuSy+1,cuSz  );
		      S(cuSx  ,cuSy  ,cuSz  )-S(cuSx  ,cuSy  ,cuSz-1)];
      dS1(2,2,2,:) = [S(cuSx+2,cuSy  ,cuSz  )-S(cuSx+1,cuSy  ,cuSz  );
	              S(cuSx  ,cuSy+2,cuSz  )-S(cuSx  ,cuSy+1,cuSz  );
		      S(cuSx  ,cuSy  ,cuSz+2)-S(cuSx  ,cuSy  ,cuSz+1)];
      dS(:,:,:,1) = S([cuSx cuSx+1]+1, [cuSy cuSy+1]  , [cuSz cuSz+1]  ) - ...
	            S([cuSx cuSx+1]  , [cuSy cuSy+1]  , [cuSz cuSz+1]  );
      dS(:,:,:,2) = S([cuSx cuSx+1]  , [cuSy cuSy+1]+1, [cuSz cuSz+1]  ) - ...
	            S([cuSx cuSx+1]  , [cuSy cuSy+1]  , [cuSz cuSz+1]  );
      dS(:,:,:,3) = S([cuSx cuSx+1]  , [cuSy cuSy+1]  , [cuSz cuSz+1]+1) - ...
	            S([cuSx cuSx+1]  , [cuSy cuSy+1]  , [cuSz cuSz+1]  );
      
      [cxi cyi czi] = ndgrid(cuSx:cuSx+1, cuSy:cuSy+1, cuSz:cuSz+1);
      t1(:,:,1)=spm_sample_vol(Vt{1},cxi,cyi,czi,0);
      t1(:,:,2)=spm_sample_vol(Vt{2},cxi,cyi,czi,0);
      t1(:,:,3)=spm_sample_vol(Vt{3},cxi,cyi,czi,0);
      t=reshape(t1,[2 2 2 3]);
      Ltmp = SingleSubVoxelCMarch(t,...
				  dS);%(cuSx:cuSx+1, cuSy:cuSy+1,...
%	                                          cuSz:cuSz+1,:));
%						 dS1);
    else 
      Ltmp = [];
    end;
    tmp = pqheap('delete',S,h,cuS);
    if ~isempty(Ltmp) % add point to line segment
      if cuL == maxL
	tmp  = L(1:cuL,:);
	maxL = maxL + 100;
	L    = repmat(NaN, [maxL 3]);
	L(1:cuL,:) = tmp;	  
      end;
      cuL = cuL+1;
      fprintf('\rLine %d segment %2.0d',nL,cuL+cuL1);
      L(cuL,:) = Ltmp+[cuSx cuSy cuSz];
      if cuL > 1
	d = squeeze(L(cuL,:) - L(cuL-1,:));
      else
	d = squeeze(t(1,1,1,:));
      end;
      dst=NaN*ones(3,1);
      for k=1:3
	if d(k)>0
	  dst(k) = (1-Ltmp(k))/abs(d(k));
	elseif d(k)<0
	  dst(k) = Ltmp(k)/abs(d(k));
	end;
      end;
      [tmp ind] = min(dst);
      switch ind
	case 1, cuSx = cuSx+sign(d(1));
	case 2, cuSy = cuSy+sign(d(2));
	case 3, cuSz = cuSz+sign(d(3));
      end;
      if (all([cuSx cuSy cuSz] < szS) & all([cuSx cuSy cuSz] >= 1)) 
	cuS = sub2ind(szS, cuSx, cuSy, cuSz); 
      else
	Ltmp = []; % FIXME force reversal at volume boundary
      end;
    end;
      
    if ((S(cuS) < loS) | isempty(Ltmp) | (h.q(cuS) == 0)) 
      if (rev == 0) & (cuL>0) % try other direction
	d(1) = spm_sample_vol(Vt{1},stSx,stSy,stSz,0);
	d(2) = spm_sample_vol(Vt{2},stSx,stSy,stSz,0);
	d(3) = spm_sample_vol(Vt{3},stSx,stSy,stSz,0);
	dst=NaN*ones(3,1);
	Ltmp = L(1,:) - [stSx stSy stSz];
	for k=1:3
	  if d(k)>0
	    dst(k) = (1-Ltmp(k))/abs(d(k));
	  elseif d(k)<0
	    dst(k) = Ltmp(k)/abs(d(k));
	  end;
	end;
	[tmp ind] = min(dst);
	switch ind
	  case 1, cuSx = stSx+sign(d(1));
	  case 2, cuSy = stSy+sign(d(2));
	  case 3, cuSz = stSz+sign(d(3));
	end;
	
	if all([cuSx cuSy cuSz] <= szS) & all([cuSx cuSy cuSz] >= 1) 
	  cuS  = sub2ind(szS, cuSx, cuSy, cuSz);
	  if (h.q(cuS) == 0)
	    break;
	  end;
	  rev  = 1;
	  cuL1 = cuL-1;
	  L1   = L(1:cuL,:);
	  maxL = 100; cuL = 1;
	  L    = repmat(NaN, [maxL 3]);
	  if ~isempty(L1)
	    L(1,:) = L1(1,:);
	  end;
	else % reversal failed
	  cuS = 0;
	  break;
	end;
      else % already reversed or no start point found
	cuS = 0;
	break;
      end;
    end;
  end;
  if (cuL+cuL1 > 1)
    if isempty(L1)
      Lines{nL} = L(1:cuL,:);
    else
      Lines{nL} = [L1(end:-1:1,:); L(2:cuL,:)] ;
    end;
    if size(Lines{nL},1) > minlen
      nL = nL+1;
      fprintf('\n');
    end;
  end;
  if h.N == 0
    break;
  end;
end;
fprintf('\n');

function L = SingleSubVoxelCMarch(t, dS)

L = [];

if any(~isfinite(t(:)))
  return;
end;

% vertex coordinates
P = [0 0 0; 0 0 1; 0 1 0; 0 1 1; 1 0 0; 1 0 1; 1 1 0; 1 1 1]' -.5; 

% edges of cuboid (index into P)
E = [ 1 2; 1 3; 1 5; 2 4; 2 6; 3 4; 3 7; 4 8; 5 6; 5 7; 6 8; 7 8];

% normalise direction of tangents in cuboid with respect to t(1,1,1,:)
% ns = ones(2,2,2);
% for k=1:2
%  for l=1:2
%    for m=1:2
%      ns(k,l,m) = sign(sum(t(1,1,1,:).*t(k,l,m,:)));
%      if ns(k,l,m) == 0
%	ns(k,l,m) = 1;
%      end;
%    end;
%  end;
% end;
% VG 2002-28-12
ns = sign(sum(repmat(t(1,1,1,:), [2 2 2]).*t, 4));
ns(find(ns==0)) = 1;

tn = [0;0;0];
for k = 1:3
  tn(k) = sum(sum(sum(ns.*t(:,:,:,k))))/8;
end;

if all(tn==0)
  fprintf('tn==0\n');
  return;
end;

%tn=tn./sqrt(sum(tn.^2));

u  = repmat(NaN,[12 1]); % u values
Eu = repmat(NaN,[12 1]); % corresponding edges
Q  = repmat(NaN,[3 12]);
nQ = 0;

% compute intersection points of tangential plane
for k = 1:12
  d = P(:,E(k,2)) - P(:,E(k,1));
  td = sum(tn.*d);
  if td ~= 0
    u(nQ+1) = -sum(tn.*P(:,E(k,1)))/td;
    if (u(nQ+1) >= 0) & (u(nQ+1) <= 1)
      Q(:,nQ+1) = P(:,E(k,1)) + d*u(nQ+1);
      Eu(nQ+1)  = k;
      nQ = nQ + 1;
    end;
  end;
end;

if nQ < 4
  fprintf('only %f intersection points found\n', nQ);
  return;
end;

% coordinate transformation into tangential plane
x = Q(:,1)/sqrt(sum(Q(:,1).^2));
z = tn/sqrt(sum(tn.^2));
y = [x(2)*z(3)-x(3)*z(2); ...
     x(3)*z(1)-x(1)*z(3); ...
     x(1)*z(2)-x(2)*z(1)];
y = y./sqrt(sum(y.^2));
   
R = [x'; y'; z']; % 07-04-03

RQ1 = R*Q(:,1:nQ); 

% sort points (gives convex hull) - see Sedgewick, p 404f
ang = zeros([nQ 1]);

for k=2:nQ
  dQ=RQ1(:,k)-RQ1(:,1);
  adQ=sum(abs(dQ));
  if adQ==0 
    ang(k)=0; 
  else 
    ang(k)=dQ(2)/adQ; 
  end;
  if (dQ(1) < 0) 
    ang(k)=2-ang(k); 
  elseif (dQ(2) < 0) 
    ang(k)=4+ang(k); 
  end;
end;

[tmp ind] = sort(ang); 
RQ = RQ1(:,ind);
sEu= Eu(ind);
su = u(ind);

% compute qu, qv in tangential plane
qu = repmat(NaN,[nQ 1]);
qv = repmat(NaN,[nQ 1]);

for k = 1:nQ
  g = squeeze(dS(P(1,E(sEu(k),1))+1.5,P(2,E(sEu(k),1))+1.5,P(3,E(sEu(k),1))+1.5,:) +...
      (dS(P(1,E(sEu(k),2))+1.5,P(2,E(sEu(k),2))+1.5,P(3,E(sEu(k),2))+1.5,:)-...
       dS(P(1,E(sEu(k),1))+1.5,P(2,E(sEu(k),1))+1.5,P(3,E(sEu(k),1))+1.5,:)))*su(k);

  q = R*[tn(2)*g(3) - tn(3)*g(2);...
         tn(3)*g(1) - tn(1)*g(3);...
	 tn(1)*g(2) - tn(2)*g(1)];
  qu(k) = q(1);
  qv(k) = q(2);
end;

% find zero crossings
qu1 = qu([2:end 1]);
zcu = find((sign(qu) + (qu==0)) == -(sign(qu1) + (qu1==0)));

qv1 = qv([2:end 1]);
zcv = find((sign(qv) + (qv==0)) == -(sign(qv1) + (qv1==0)));

qu(qu==0)=eps;
qv(qv==0)=eps;

if length(zcu)~=2|length(zcv)~=2
%  fprintf('not 2 zero crossings found\n');
  return;
end;

for k = 1:2
  if zcu(k) == nQ
    zcu1 = 1;
  else
    zcu1 = zcu(k)+1;
  end;
%  RQu(:,k) = RQ(1:2,zcu(k)) + ...
%             abs(qu(zcu(k)))/(abs(qu(zcu(k)))+abs(qu1(zcu(k)))) * ...
%             (RQ(1:2,zcu1) - RQ(1:2,zcu(k)));

  RQu(:,k) = RQ(1:2,zcu(k)) + ...
      qu(zcu(k))/(qu(zcu(k))-qu(zcu1)) * ...
      (RQ(1:2,zcu1) - RQ(1:2,zcu(k)));
	 
  if zcv(k) == nQ
    zcv1 = 1;
  else
    zcv1 = zcv(k)+1;
  end;
%  RQv(:,k) = RQ(1:2,zcv(k)) + ...
%             abs(qv(zcv(k)))/(abs(qv(zcv(k)))+abs(qv1(zcv(k)))) * ...
%             (RQ(1:2,zcv1) - RQ(1:2,zcv(k)));
  RQv(:,k) = RQ(1:2,zcv(k)) + ...
             qv(zcv(k))/(qv(zcv(k))+qv(zcv1)) * ...
             (RQ(1:2,zcv1) - RQ(1:2,zcv(k)));
end;	

% intersection - see Bronstein, p 219f
du  = RQu(:,2) - RQu(:,1);
dv  = RQv(:,2) - RQv(:,1);

cu  = RQu(1,1)*du(2) - RQu(2,1)*du(1);
cv  = RQv(1,1)*dv(2) - RQv(2,1)*dv(1);

nom = det([-du(2) du(1); -dv(2) dv(1)]);

xuv = det([du(1) cu; dv(1) cv])/nom;
yuv = det([cu -du(2); cv -dv(2)])/nom;

L = (inv(R)*[xuv; yuv; 0])' +.5;
if any(L>1.0)|any(L<0.0) %1.05 and -.05
%  fprintf('%1.2f %1.2f %1.2f intersect outside cuboid\n', L);
  L=[];
end;
if any(~isfinite(L))
  L=[];
end;

function x = misc(x1)
% constant coordinates for edge - not needed
C = [ 1 1 0; 1 0 1; 0 1 1;
      1 0 1; 0 1 1;
      1 1 0; 0 1 1;
      0 1 1;
      1 1 0; 1 0 1;
      1 0 1;
      1 1 0];
    
