function idxLUT = BrAt_ComputeAreaSize(idxLUT,ANO,FIBT)

iio = find(ANO>0);
F = sparse(ANO(iio),ones(length(iio),1),ones(length(iio),1));
idx = find(F>0);
sz = full(F(idx));
for k = 1:length(idx),
    %iii = find(idx(k) == [idxLUT.id]);
    %idxLUT(iii).voxsz = sz(k);
    idxLUT(idx(k) == [idxLUT.id]).voxsz = sz(k);
end

iio = find(FIBT>0);
F = sparse(FIBT(iio),ones(length(iio),1),ones(length(iio),1));
idx = find(F>0);
sz = full(F(idx));
for k = 1:length(idx),
    %iii = find(idx(k) == [idxLUT.id]);
    %idxLUT(iii).voxsz = sz(k);
    idxLUT(idx(k) == [idxLUT.id]).voxsz = sz(k);
end

voxsz = zeros(1,length(idxLUT));
for k = 1:length(idxLUT)
    if isempty(idxLUT(k).voxsz)
        [common, ia, ib] = intersect([idxLUT.id],idxLUT(k).children);
        if not(isempty(ia))
            voxsz = sum([idxLUT(ia).voxsz]);
            idxLUT(k).voxsz = voxsz;
        end
    end
end
end
