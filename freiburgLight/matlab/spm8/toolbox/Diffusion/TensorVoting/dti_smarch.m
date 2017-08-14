function FV=dti_smarch(n,S,hiS,loS)
%
% This function is part of the diffusion toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.

%_______________________________________________________________________
%
% @(#) $Id$

rev = '$Revision$';

FV=struct('F',[],'V',[]);
% n: XDIM-by-YDIM-by-ZDIM-by-3 array of surface normals
%    (represented in VOXEL space)
% s: XDIM-by-YDIM-by-ZDIM array of saliencies (eval2-eval3)

szS = size(S);

%dS(:,:,:,1) = cat(1,S(2:end,:,:),S(end,:,:))-S;
%dS(:,:,:,2) = cat(2,S(:,2:end,:),S(:,end,:))-S;
%dS(:,:,:,3) = cat(3,S(:,:,2:end),S(:,:,end))-S;

dS(:,:,:,1) = (cat(1,S(2:end,:,:),S(end,:,:))-cat(1,S(1,:,:), S(1:end-1,:,:)))/2;
dS(:,:,:,2) = (cat(2,S(:,2:end,:),S(:,end,:))-cat(2,S(:,1,:), S(:,1:end-1,:)))/2;
dS(:,:,:,3) = (cat(3,S(:,:,2:end),S(:,:,end))-cat(3,S(:,:,1), S(:,:,1:end-1)))/2;

h  = pqheap('init',S);

nFV = 1;

while ((S(h.p(1)) > hiS) & (h.N > 0))
  maxF = 100; maxV = 1000;
  cuF = 0; cuV = 0;
  F = repmat(NaN,[maxF 13]);
  V = repmat(NaN,[maxV 3]);

  cuS = double(h.p(1));
  [cuSx cuSy cuSz] = ind2sub(szS,cuS);

  nb = cuS+[-1; 1;...
            -szS(1); szS(1);...
	    -szS(1)*szS(2);szS(1)*szS(2)]; % initialise neighbourhoud
  nb = nb([cuSx > 1; cuSx < szS(1); ...
           cuSy > 1; cuSy < szS(2); ...
	   cuSz > 1; cuSz < szS(3)]);
  nb  = nb((S(nb) > loS) & (h.q(nb) > 0)); % non-visited voxels above loS

  while cuS~=0
    if all([cuSx cuSy cuSz] < szS) % range check
      [FVtmp C] = SingleSubVoxelMarch(n(cuSx:cuSx+1, cuSy:cuSy+1, ...
	                                         cuSz:cuSz+1,:),...
				  dS(cuSx:cuSx+1, cuSy:cuSy+1,...
	                                          cuSz:cuSz+1,:));
      if ~isempty(FVtmp.F)
	addF      = size(FVtmp.F,1);
	addV      = size(FVtmp.V,1);
	FVtmp.V   = FVtmp.V + repmat([cuSx cuSy cuSz],  [addV 1]);
	FVtmp.F   = FVtmp.F + cuV;

	if cuF + addF > maxF
	  tmp = F(1:cuF,:);
	  maxF= maxF + 100;
	  F = repmat(NaN,[maxF 13]);
	  F(1:cuF,:) = tmp;	  
	end;
	F(cuF+1:cuF+addF,:) = FVtmp.F;
	cuF = cuF + addF;

	if cuV + addV > maxV
	  tmp = V(1:cuV,:);
	  maxV= maxV + 1000;
	  V = repmat(NaN,[maxV 3]);
	  V(1:cuV,:) = tmp;
	end;
	V(cuV+1:cuV+addV,:) = FVtmp.V;
	cuV = cuV + addV;
	
	nbrem = cuS+[-1, 1;...
	             -szS(1), szS(1);...
		     -szS(1)*szS(2),szS(1)*szS(2)]; 
        nbrem = nbrem([cuSx > 1, cuSx < szS(1); ...
                       cuSy > 1, cuSy < szS(2); ...
		       cuSz > 1, cuSz < szS(3)] & C==0);
      else
	nbrem = cuS+[-1, 1;...
	             -szS(1), szS(1);...
		     -szS(1)*szS(2),szS(1)*szS(2)]; 
        nbrem = nbrem([cuSx > 1, cuSx < szS(1); ...
                       cuSy > 1, cuSy < szS(2); ...
		       cuSz > 1, cuSz < szS(3)]);
      end;
      nb = setdiff(nb, nbrem(:)); % remove unconnected neighbours	   
    end;
    tmp = pqheap('delete',S,h,cuS);
    if ~isempty(nb)
      cuS = nb(1);
      [cuSx cuSy cuSz] = ind2sub(szS,cuS);
      nbtmp = cuS+[-1; 1;...
	           -szS(1); szS(1);...
		   -szS(1)*szS(2);szS(1)*szS(2)]; 
      nbtmp = nbtmp([cuSx > 1; cuSx < szS(1); ...
                     cuSy > 1; cuSy < szS(2); ...
		     cuSz > 1; cuSz < szS(3)]);
      nbtmp  = nbtmp((S(nbtmp) > loS) & (h.q(nbtmp) > 0)); 
      nb = union(nb(2:end),nbtmp); % add to neighbourhoud
    else
      cuS = 0;
    end;
  end;
  if cuF > 0
    FV(nFV) = struct('F',F(1:cuF,:),'V',V(1:cuV,:)); 
    nFV = nFV +1;
  end;
end;

function [FV,C] = SingleSubVoxelMarch(n,dS)

FV = struct('V',[],'F',[]);
C  = [];
% normalise direction of normals in cuboid with respect to n(1,1,1,:)
ns = ones(2,2,2);
for k=1:2
  for l=1:2
    for m=1:2
      ns(k,l,m) = sign(sum(n(1,1,1,:).*n(k,l,m,:)));
    end;
  end;
end;
%ns = sign(sum(repmat(n(1,1,1,:),[2,2,2,1]).*n,4));
for k = 1:3
  nn(:,:,:,k) = ns.*n(:,:,:,k);
end;

q  = sum(dS.*nn, 4);

c1 = [0 1 0 1]';
c2 = [0 0 1 1]';

zc = cat(1, reshape(q(1,:,:)./(q(1,:,:)-q(2,:,:)),[4 1]),...
              reshape(q(:,1,:)./(q(:,1,:)-q(:,2,:)),[4 1]),...
              reshape(q(:,:,1)./(q(:,:,1)-q(:,:,2)),[4 1]));
if any(~isfinite(zc(:)))
  return;
end;

FV.V = cat(1, cat(2, zc(1:4), c1, c2),...
              cat(2, c1, zc(5:8), c2),...
	      cat(2, c1, c2, zc(9:12)));

edges = repmat(NaN,[12 2]);
eind  = 1;

C = ones(3,2);  % connectivity to neighbours
zcsel = cat(3,[5 11 7 9; 6 12 8 10]',... % x = const
              [1 10 3 9; 2 12 4 11]',... % y = const
	      [1  6 2 5; 3  8 4  7]');   % z = const
for k = 1:3   % coordinate
  for l = 1:2 % value of coordinate
    zc1 = zc(zcsel(:,l,k));
    zc1sel = (zc1 > 0) & (zc1 < 1); % zero crossings in voxel?

    switch sum(zc1sel)
      case 2
	edges(eind,:) = zcsel(zc1sel,l,k)';
	eind = eind+1;
      case 4
	switch k 
	  case 1 % x = const
	    q1 = squeeze(q(l,:,:));
	  case 2 % y = const
	    q1 = squeeze(q(:,l,:));
	  case 3 % z = const
	    q1 = squeeze(q(:,:,l));
	end;

	x = mean(zc1([1 3]));
	y = mean(zc1([2 4]));
	if ((1-y)*((1-x)*q1(1,1) + x*q1(2,1)) + ... 
	      y*((1-x)*q1(1,2) + x*q1(2,2))) >= 0
	  edges(eind,:) = zcsel(1:2,l,k)';
	  edges(eind+1,:) = zcsel(3:4,l,k)';
	else
	  edges(eind,:) = zcsel(2:3,l,k)';
	  edges(eind+1,:) = zcsel([1 4],l,k)';
	end;
	eind = eind+2;
      otherwise
	C(k,l)=0;
    end,
  end;
end;

Find = 1;
edges = edges(1:eind-1,:);
while ~isempty(edges)
  F = [NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN];
  Fcind = 3;
  F(1:2) = edges(1,:);
  edges = edges(2:end,:);
  [i j] = find(edges==F(2));
  while ~isempty(i)
    if length(i)>1
      warning('spm_tbx_Diffusion:dti_smarch_EdgeVertex',...
              'More than one edge per Vertex left');
    end;
    if j == 1
      F(Fcind) = edges(i,2);
    else
      F(Fcind) = edges(i,1);
    end;
    edges = [edges(1:i-1,:); edges(i+1:end,:)];
    [i j] = find(edges==F(Fcind));
    Fcind = Fcind+1;
  end;
  if sum(isfinite(F)) > 2
    FV.F(Find,:) = F;
    Find = Find+1;
  end;
end;

function ret = misc(x)

qV = [1 1 1; 2 1 1; 1 2 1; 2 2 1; 1 1 2; 2 1 2; 1 2 2; 2 2 2];
qF = [1 2 4 3; 1 2 6 5; 1 5 7 3; 5 6 8 7; 2 4 8 6; 3 4 8 7];
zcF= cat(3, [1 1 1; 2 1 3; 1 2 1; 1 1 3],...
            [1 1 1; 2 1 2; 2 1 1; 1 1 2],...
	    [1 1 2; 1 2 3; 1 2 2; 1 1 3],...
	    [1 2 1; 2 2 2; 2 2 1; 1 2 2],...
	    [2 1 3; 2 2 2; 2 2 3; 2 1 2],...
	    [2 2 3; 2 2 1; 1 2 3; 2 1 1]);
	
