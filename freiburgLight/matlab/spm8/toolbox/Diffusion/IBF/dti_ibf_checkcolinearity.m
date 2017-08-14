
Xref=reshape(spm_read_vols(Vref),[prod(Vref(1).dim(1:3)) 10]);
sel=all(isfinite(Xref),2);
Xref=Xref(sel,:);
oXref=orth(Xref);

Xcmp=reshape(spm_read_vols(Vcmp),[prod(Vcmp(1).dim(1:3)) 10]);
sel=all(isfinite(Xcmp),2);
Xcmp=Xcmp(sel,:);
oXcmp=orth(Xcmp);

for k=1:10
for j=k:10
c(k,j)=sum(Xref(:,k).*Xcmp(:,j));
c(j,k)=c(k,j);
oc(k,j)=sum(oXref(:,k).*oXcmp(:,j));
oc(j,k)=oc(k,j);
end;
end,
figure;imagesc(abs(oc),[0 1]);axis square;colormap gray,
figure;imagesc(abs(c),[0 1]);axis square;colormap gray
