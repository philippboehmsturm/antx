function tbxrend_nifti_to_df3(bch)

% export NIfTI image to POVray df3 format
% produces the df3 file itself and a coordinate transform from unit cube
% to NIfTI world space
% bch.srcimg
% bch.outimg.fname
% bch.outimg.swd
% bch.outres - 'uint8','uint16','uint32' 
% data will be scaled to fit range, non-finite values set to minimum of data. A mask
% df3 will be written which contains 1 for valid data, 0 for non-finite data

V = spm_vol(bch.srcimg{1});
[ps ns e v] = spm_fileparts(bch.srcimg{1});
if isempty(bch.outimg.swd{1})
    po = ps;
else
    po = bch.outimg.swd{1};
end;
if isempty(bch.outimg.fname)
    no = ns;
else
    no = bch.outimg.fname;
end;
out.dfile{1}    = fullfile(po,[ns '.df3']);
out.mfile{1}    = fullfile(po,[ns '_msk.df3']);
out.dinclude{1} = fullfile(po,[ns '.inc']);
out.minclude{1} = fullfile(po,[ns '_msk.inc']);

X = spm_read_vols(V);
msk = uint8(isfinite(X));
mn = min(X(logical(msk(:))));
mx = max(X(logical(msk(:))));
X(~logical(msk)) = mn;

switch bch.outres
    case 'uint8'
	mxval = 2^8-1;
    case 'uint16'
	mxval = 2^16-1;
    case 'uint32'
	mxval = 2^32-1;
end;
dat = eval(sprintf('%s(round((X-mn)/(mx-mn)*mxval))',bch.outres));
fid = fopen(out.dfile{1},'w','ieee-be');
fwrite(fid,uint16(V.dim(1:3)),'uint16');
fwrite(fid,dat,bch.outres);
fclose(fid);

fid = fopen(out.mfile{1},'w','ieee-be');
fwrite(fid,uint16(V.dim(1:3)),'uint16');
fwrite(fid,msk,'uint8');
fclose(fid);

% transformation from unit cube to mm via voxels
M = V.mat*[diag(V.dim(1:3)-1) ones(3,1); 0 0 0 1];

write_include(out.dinclude{1}, out.dfile{1}, M);
write_include(out.minclude{1}, out.mfile{1}, M);


function write_include(iname, dname, M)
fid = fopen(iname,'w');
fprintf(fid,'{\n   density_file df3 "%s"\n', dname);
fprintf(fid,'   matrix < %.02f, %.02f, %.02f,\n      %.02f, %.02f, %.02f,\n      %.02f, %.02f, %.02f,\n      %.02f, %.02f, %.02f >\n', M(1:3,:));
fprintf(fid,'}\n');
fclose(fid);
