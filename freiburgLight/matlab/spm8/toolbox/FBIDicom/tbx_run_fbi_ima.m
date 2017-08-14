function out = tbx_run_fbi_ima(cmd, job)
%
% (c) Sebastian Thees 17.2.2001, email: s_thees@yahoo.com
%
% Dept. of Neurologie, Charite, Berlin, Germany
%

switch lower(cmd)
    case 'run'
        params.file            = detImaParams(job.imaFileList{1});
        
        order = genSliceOrder( params.file.nSlices, job.interleaved);
        [p n e v] = spm_fileparts(job.imgFilename);
        if ~any(strcmp(e,{'.img','.nii'}))
            e = '.nii';
        end
        if params.file.isMosaic == 0
            imgFilename = [n e];
            
            img = zeros(params.file.matrix(1), params.file.matrix(2), numel(job.imaFileList), ...
                'uint16');
            for i = 1 : numel(job.imaFileList)
                imaFid = fopen(job.imaFileList{order(i)}, 'r', 'ieee-be');
                fseek( imaFid, 6144, 'bof');
                [img(:,:,i), n]= fread( imaFid, params.file.matrix(1:2), 'uint16');
                if n ~= params.file.imaSize
                    fclose('all');
                    error('Unable to read image %s completely. %2.4f %% read => terminating !',...
                        job.imaFileList{order(i)}, n/params.file.imaSize);
                end
                fclose( imaFid);
            end
            V = imaToImg_geometrie(imgFilename, job.odir{1}, params);
            spm_write_vol(V, double(img));
            out.outimgs{1} = V.fname;
        else
            xSize = params.file.matrix(1); ySize = params.file.matrix(2);
            nX    = params.file.nX;        nY    = params.file.nY; % mosaic-dimensions (1x1,2x2,4x4,8x8, ...)
            
            oimg = zeros( xSize, ySize, nX*nY, 'uint16');
            for i = 1 : numel(job.imaFileList)
                imgFilename = sprintf('%s-%0*d%s', n, ceil(log10(numel(job.imaFileList)+1)), ...
                    i, e);
                imaFid = fopen(job.imaFileList{i}, 'r', 'ieee-be');
                fseek( imaFid, 6144, 'bof');
                img = uint16( fread( imaFid, [nX*xSize nY*ySize], 'uint16'));
                if size( img, 1)*size(img,2) ~= nX*xSize*nY*ySize  % check for possible error
                    fclose('all');
                    error('Unable to read image completly. %2.4f %% read => terminating !\n\n', ...
                        size( img, 1)*size(img,2)/nX*xSize*nY*ySize);
                end
                %
                % begin: image extraction
                for j = 0 : nY - 1
                    for k = 0 : nX - 1
                        oimg(:,:, 1+k+j*nX) = img( 1 + k*xSize : (k+1)*xSize, 1 + j*xSize : (j+1)*xSize);
                    end
                end
                % end: image extraction
                fclose( imaFid);
                V = imaToImg_geometrie(imgFilename, job.odir{1}, params);
                spm_write_vol(V, double(oimg));
                out.outimgs{i} = V.fname;
            end
        end
    case 'vout'
        out = cfg_dep;
        out.sname = 'Converted IMA images';
        out.src_output = substruct('.','outimgs');
        out.tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
end
function V = imaToImg_geometrie( imgFilename, path, params)

%
% Sebastian Thees 17.2.2001, email: s_thees@yahoo.com
%
% Dept. of Neurologie, Charite, Berlin, Germany
%
% calculate the rotations / translations and fix them in a .mat file
%
% intro / remember:
% coord in scanner: x => horizontal, to left is +
%                   y => vertical, up is +, therefor: z => to the feets is +
%
% coord in spm (neurological world ...): rot about 180� versus y.
%

M           = eye( 4);

Tspm        = eye( 3);  % transformation from MRT Koord to SPM world. 
Tspm(1,1)   = -1;   
Tspm(3,3)   = -1;   

Zoom  = zeros( 3);      % scaling in row, col and norm direction (Units == [mm]).
Zoom( 1, 1) = params.file.FoV(1) / params.file.matrix(1);   
Zoom( 2, 2) = params.file.FoV(2) / params.file.matrix(2);  
Zoom( 3, 3) = params.file.sliceThickness*(1+params.file.distFactor);

Tmrt     = zeros( 3);   % tranformation from native to scanned plot-orientation in MRT-KoordSys
Tmrt(1:3,1) = params.file.rowVect;  
Tmrt(1:3,2) = params.file.colVect;  
Tmrt(1:3,3) = params.file.normVect; 

M(1:3,1:3) = Tspm * Tmrt * Zoom; % total transformation 

% vector in MRT coord-sys to the voxel 1 1 1.
MRT_BBorigin = params.file.centerPoint - Zoom( 3, 3)/2*params.file.normVect - ...
   (params.file.matrix(1)+1)/2*Zoom( 1, 1) * params.file.rowVect - ...
   (params.file.matrix(2)+1)/2*Zoom( 2, 2) * params.file.colVect;

% this vector tells SPM where to locate the Voxel 1 1 1 (Units == [mm]).
M(1:3,4)    = Tspm * MRT_BBorigin;

V.fname = fullfile(path, imgFilename);
V.dim   = [params.file.matrix params.file.nSlices];
V.dt    = [spm_type('uint16') spm_platform('bigend')];
V.mat   = M;
V.pinfo = [Inf;Inf;0];

function order = genSliceOrder( n, type)
%
% Matthias Moosmann -Moosoft-
%
order = zeros(1,n);
switch type
case 1, %verschachtelt
   %n gerade  
   if n/2==round(n/2),     
      for i=1:n,              
         if i/2==round(i/2),
            order(i)=(n-i+2)/2 ;            
         else 
            order(i)= (2*n-i+1)/2;
         end                 
      end
   %n ungerade      
   else
      for i=1:n,
         if i/2==round(i/2), 
            order(i)=(2*n-i+2)/2;            
         else 
            order(i)=(n-i+2)/2;           
         end
      end      
   end
   order = fliplr( order);
      
case 0, % ascending( MRT: first slice top)
   order = 1 : n;
end

function params = detImaParams( filename)
%
% Sebastian Thees 17.2.2001, email: s_thees@yahoo.com
%
% Dept. of Neurologie, Charite, Berlin, Germany
%
% params = struct(
%                 name: string
%                 date: string
%                 time: string
%              seqType: string
%      acquisitionTime: double
%             normVect: [3x1 double]
%              colVect: [3x1 double]
%              rowVect: [3x1 double]
%          centerPoint: [3x1 double]
%    distFromIsoCenter: double
%                  FoV: [2x1 double]
%       sliceThickness: double
%           distFactor: double
%              repTime: double
%            scanIndex: double
%            angletype: [7x1 char]
%                angle: [4x1 char]
%               matrix: [2x1 douuble]
%              nSlices: double
%             isMosaic: int
%              imaSize: int
% )
fid = fopen( filename, 'r', 's');

% who and when
fseek( fid, 768, 'bof');
params.name = sscanf( fread( fid, 25, 'uchar=>char'), '%s');
fseek( fid, 12, 'bof');
date = fread( fid, 3, 'uint32');
params.date = sprintf( '%d.%d.%d', date(3),date(2),date(1));
fseek( fid, 52, 'bof');
time = fread( fid, 3, 'uint32');
params.time = sprintf( '%d:%d:%d', time(1),time(2),time(3));

%scan stuff
fseek( fid, 3083, 'bof'); %sequenzeType
params.seqType = sscanf( fread( fid, 8, 'uchar=>char'), '%s');

fseek( fid, 2048, 'bof'); % acquisition Time
params.acquisitionTime = fread( fid, 1, 'double');


%geometrical stuff
fseek( fid, 3792, 'bof');
params.normVect = fread( fid, 3, 'double');
fseek( fid, 3856, 'bof');
params.colVect = fread( fid, 3, 'double');
fseek( fid, 3832, 'bof');
params.rowVect = fread( fid, 3, 'double');
fseek( fid, 3768, 'bof');
params.centerPoint = fread( fid, 3, 'double');

fseek( fid, 3816, 'bof');
params.distFromIsoCenter = fread( fid, 1, 'double');

% sliceParams ...
fseek( fid, 3744, 'bof');
params.FoV = fread( fid, 2, 'double');

%fseek( fid, 5000, 'bof');
%params.pixelSize = fread( fid, 2, 'double');

fseek( fid, 1544, 'bof');
params.sliceThickness = fread( fid, 1, 'double');

fseek( fid, 1560, 'bof');
params.repTime = fread( fid, 1, 'double');

fseek( fid, 5726, 'bof');
params.scanIndex = str2double( sscanf( fread( fid, 3, 'uchar=>char'), '%s'));

fseek( fid, 5814, 'bof');
params.angletype = fread( fid, 7, 'uchar=>char');
fseek( fid, 5821, 'bof');
params.angle = fread( fid, 4, 'uchar=>char');
%
% fourier transform MRI leeds to a squared image matrix:
fseek(fid, 2864, 'bof'); 
params.matrix(1) = fread( fid, 1, 'uint32');
params.matrix(2) = params.matrix(1);
%
fseek(fid, 1948, 'bof');
params.imaSize=fread( fid, 1, 'int32')/2;

% total imageSize
fseek(fid, 4994, 'bof'); params.imaDim = fread( fid, 2, 'short');

fseek(fid, 3984, 'bof'); p=fread(fid, 1, 'uint32');
if p~=0 % number of partitions not zero (-> 3D dataset)
   params.nSlices=p;
   params.distFactor = 0;
else
   fseek( fid, 4004, 'bof'); params.nSlices = fread( fid, 1, 'uint32');
   fseek( fid, 4136, 'bof'); params.distFactor = fread( fid, 1, 'double');
end

% estimate if file is mosaic or not
params.isMosaic=0; params.nX=1; params.nY=1;
% calculation of mosaic format assumes a "squared" format !!!
n = sqrt( params.imaSize/(params.matrix(1)*params.matrix(2)));
if (n>1) && (int32(n)==n)
   params.isMosaic=1;
   params.nX = params.imaDim(1)/params.matrix(1);
   params.nY = params.imaDim(2)/params.matrix(2);
end
fclose( fid);