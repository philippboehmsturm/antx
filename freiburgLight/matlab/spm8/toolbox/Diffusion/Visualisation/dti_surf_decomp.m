function dti_surf_decomp(D,x,l)
% display a full tensor and its decomposition

SD=zeros(size(D));

nrows = ceil(sqrt(length(l)+2));
ncols = ceil(sqrt(length(l)+2));

while (nrows-1)*ncols >= length(l)+2
  nrows = nrows - 1;
end;

order = ndims(D);
[Hind mult iHperm]=dti_dt_order(order);

f     = figure;
for k=1:length(l)
  tx=l(k)*tensor_gop(x{k});
  D=D-tx;
  SD=SD+tx;
  dwbch(k).data=dti_dt_reshape(tx,ndims(D),iHperm);
  dwbch(k).f = f;
  figure(f);
  dwbch(k).ax = subplot(nrows,ncols,k);
  view(3);
end;
dwbch(length(l)+1).data=dti_dt_reshape(D,ndims(D),iHperm);
dwbch(length(l)+1).ax = subplot(nrows,ncols,length(l)+1);
view(3);
dwbch(length(l)+2).data=dti_dt_reshape(SD,ndims(D),iHperm);
dwbch(length(l)+2).ax = subplot(nrows,ncols,length(l)+2);
view(3);
[dwbch.order]    = deal(ndims(D));
[dwbch.scaling]  = deal(0);
[dwbch.register] = deal(0);
[dwbch.res]      = deal(.1);
[dwbch.f]        = deal(f);

[dwres dwbch]=dti_surface(dwbch);

[dwbch.scaling]=deal(subsref(max(cat(1,dwres.scaling)),struct('type','()','subs',{{2}})));
[dwres dwbch]=dti_surface(dwbch);
axma = [-inf -inf -inf];
axmi = [inf inf inf];
for k=1:length(l)
  title(dwbch(k).ax,sprintf('Component %d', k));
  axc = axis(dwbch(k).ax);
  axma = max(axma,axc([2 4 6]));
  axmi = min(axmi,axc([1 3 5]));
end;
title(dwbch(length(l)+1).ax,'Residual tensor');
axc = axis(dwbch(length(l)+1).ax);
axma = max(axma,axc([2 4 6]));
axmi = min(axmi,axc([1 3 5]));
title(dwbch(length(l)+2).ax,'Fitted tensor');
axc = axis(dwbch(length(l)+2).ax);
axma = max(axma,axc([2 4 6]));
axmi = min(axmi,axc([1 3 5]));
for k=1:(numel(dwbch))
  axis(dwbch(k).ax,[axmi(1) axma(1) axmi(2) axma(2) axmi(3) axma(3)]);
  if k<=numel(x)
    plotxdirs(x(k),axmi,axma,dwbch(k).ax);
  end;
end;
plotxdirs(x,axmi,axma,dwbch(length(l)+2).ax);
function plotxdirs(x,axmi,axma,ax)
return; % do nothing
hold on;
for k=1:length(x)
  s(1:3)=(axma-1)'./x{k}(:,1);
  s(4:6)=(axmi-1)'./x{k}(:,1);
  sp=min(s(s>0));
  sn=max(s(s<0));
  l(k)=line([sn*x{k}(1,1) sp*x{k}(1,1)]+1,...
            [sn*x{k}(2,1) sp*x{k}(2,1)]+1,...
            [sn*x{k}(3,1) sp*x{k}(3,1)]+1,'Parent',ax); % dw surface has center
                                            % at voxel (1,1,1)
end;
