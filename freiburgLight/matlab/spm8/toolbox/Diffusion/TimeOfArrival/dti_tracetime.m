function dti_tracetime

% @(#) $Id$

rev='$Revision$';

VR = spm_vol(spm_get(1,'*IMAGE','Starting ROI'));
VT = spm_vol(spm_get(1,'*IMAGE','ToA image'));
roi = spm_read_vols(VR);
tr = spm_read_vols(VT);

path = zeros(size(roi));
ind = find(roi(:));

for j = 1:3
    for k = 1:3
        for l = 1:3
            nbhood26(sub2ind([3 3 3],j,k,l),1:3)=[j-2 k-2 l-2];
        end,
    end;
end;
nbhood26 = nbhood26(sum(abs(nbhood26),2)~=0,:);

ok=1;
while ok
    path(ind) = 1;
    ind1=zeros(size(ind));
    for j=1:size(ind)
        [x1 y1 z1] = ind2sub(VR.dim(1:3),ind(j));
        nb = nbhood26+repmat([x1 y1 z1],size(nbhood26,1),1);
        sel = all(nb>0,2) & all(nb<repmat(VR.dim(1:3),size(nb,1),1),2);
        nbind = sub2ind(VR.dim(1:3), nb(sel,1), nb(sel,2), nb(sel,3));
        [tmp tmind] = min(tr(nbind));
        ind1(j) = nbind(tmind);
    end,
    ok=~(ind==ind1);
    fprintf('%d ',ind(sort(ind)~=sort(ind1)));
    fprintf('\n');
    ind=unique(ind1);
end;

VP = VR;
[p n e v] = fileparts(VP.fname);
VP.fname = fullfile(p,['path' e v]);
spm_write_vol(VP,path);
