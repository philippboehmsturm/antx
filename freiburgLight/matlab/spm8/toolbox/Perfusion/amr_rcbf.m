function varargout = amr_rcbf(varargin);

%-calculates rCBF from time course data
%-written by OS 17.11.99
%
%        [rcbv_out,at_out,mtt_out,alpha_out,beta_out,rcbf_out,base_out,tail_out,noise_out] = amr_rcbf(in,slc_first,slc_last,method);
%
%        in:         must be a mrStruct of type series3D or series2D
%        slc_first:  first slice to process
%        slc_last:   last slice to process
%        method:     string containing 'ge' or 'se' [optional], default is 'ge'
%


amr_global
NPAR = 4;

if  (nargin < 1)
    error('Too less input!')
elseif  (nargin >= 1)
    in = varargin{1};
end
n_slices = 1;
if mrstruct_istype(in,'series3D')
	[size_x,size_y,size_z,size_t] = size(in.dataAy);
    n_slices = size_z;
elseif mrstruct_istype(in,'series2D')
    [size_x,size_y,size_t] = size(in.dataAy);
else
    error('Input must be series2D or series3D')
end

if (nargin >= 2)
    slc_st = varargin{2};
else
    slc_st = 1;    
end
if (nargin >= 3)
    slc_end = varargin{3};
else
    slc_end = n_slices;
end
if (nargin >= 4)
    method = varargin{4};
    if strcmp(method,'ge')
        amr_init_ge;
    elseif strcmp(method,'se')
        amr_init_se;
    end
else
    amr_init_ge;
end


% select and load data and info
%-----------------------------------------------------------------------
%if (nargin == 1)
%  S = get(0,'ScreenSize');
 %  [in_fn,in_path] = uigetfile('/export/home/streck/Daten/*',...
 %	 'select source data for rCBF calculation',S(3)/2-200,S(4)/2-300);
 %else
 %  in_path = varargin{2};
 %end

alpha = DEFAULT_PERF_ALPHA;
beta  = DEFAULT_PERF_BETA;
at    = DEFAULT_PERF_BOLUS_AT;
skip  = DEFAULT_POWELL(1);

% calculate rbf using amr_rbf_powell
% (only for voxel with more than DEFAULT_THRESH times max intensity)
%-----------------------------------------------------------------------
im_size     	= size_x*size_y;
out			    = zeros(im_size,n_slices,NPAR);
rcbv_out		= zeros(size_x,size_y);
rcbf_out		= zeros(size_x,size_y);
mtt_out			= zeros(size_x,size_y);
at_out			= zeros(size_x,size_y);
alpha_out		= zeros(size_x,size_y);
beta_out		= zeros(size_x,size_y);
A_min_max	    = [DEFAULT_PERF_ALPHA(2:3),DEFAULT_PERF_BETA(2:3),DEFAULT_PERF_BOLUS_AT(2:3)];
default_powell  = [DEFAULT_POWELL in.te/1000];

for slice = slc_st:slc_end,
   
    fprintf('\nCalculating maps for slice no. %d/%d\n',slice,n_slices);
    data = squeeze(reshape(in.dataAy(:,:,slice,:),im_size,size_t));
    max_int = max(max(data));
    mask = zeros(im_size,1);

    for k=1:im_size,
        if  (length(find(data(k,:) > max_int*(DEFAULT_THRESH))) > 10)   % <==  THE FILTER
            mask(k,1)=k;
        end
    end
    mask = find(mask > 0);
    mask_size = length(mask);
    A = zeros(5,mask_size);
  
    for k = 1:mask_size,
        ma = max(data(mask(k),skip:end));
        mi = min(data(mask(k),skip:end));
        A(3,k) = (ma-mi)/ma*100;
    end
  
    A(1,:) = alpha(1);
    A(2,:) = beta(1);
    A(4,:) = at(1);
    A(5,:) = skip;  
    data = data(mask,:);
    data = transpose(data);
    out(mask,slice,:) = transpose(amr_rbf_powell(data,A,A_min_max,default_powell));
  
end

clear A tmp A_min_max mi ma mask mask_size max_int im_size slice i;
clear alpha beta at skip ;

mtt_data = reshape(out(:,:,2).*(out(:,:,1)+1),size_x,size_y,n_slices,1);
out = reshape(out,size_x,size_y,n_slices,NPAR);




% generate output
%-----------------------------------------------------------------------
typeVec=([n_slices] > [1]);
if  typeVec == [0],
    typeStr = 'image';
elseif typeVec == [1],
    typeStr = 'volume';
end
rcbv = mrstruct_init(typeStr);
rcbv.memoryType = in.memoryType;
rcbv.vox = in.vox;
rcbv.edges = in.edges;
rcbv.orient = in.orient;
rcbv.method = in.method;
rcbv.te = in.te;
rcbv.tr = in.tr;
rcbv.ti = in.ti;
rcbv.patient = in.patient;
rcbv.user = in.user;
if (nargout >= 1)
   [rcbv, err] = mrstruct_checkin(rcbv,squeeze(out(:,:,:,3)));
   varargout(1) = {rcbv};
end
if (nargout >= 2)
   [at, err] = mrstruct_checkin(rcbv,squeeze(out(:,:,:,4)));
   varargout(2) = {at};
   clear at;
end
if (nargout >= 3)
   [mtt, err] = mrstruct_checkin(rcbv,squeeze(mtt_data));
   varargout(3) = {mtt};

end
if (nargout >= 4)
   [alpha, err] = mrstruct_checkin(rcbv,squeeze(out(:,:,:,1)));
   varargout(4) = {alpha};
   clear alpha;
end
if (nargout >= 5)
   [beta, err] = mrstruct_checkin(rcbv,squeeze(out(:,:,:,2)));
   varargout(5) = {beta};
   clear beta;
end
if (nargout >= 6)
	rcbf_out = zeros(size_x,size_y,n_slices);
	rcbf_out = squeeze(rcbf_out);
	[x, y]	 = find(mtt.dataAy ~= 0);
	for l=1:size(x);
        rcbf_out(x(l),y(l)) 	= rcbv.dataAy(x(l),y(l))./mtt.dataAy(x(l),y(l));
	end; 
    [rcbf, err] = mrstruct_checkin(rcbv,rcbf_out);
    varargout(6) = {rcbf};
    clear rcbf_out;    
    clear mtt;
end;
if (nargout >= 7)
	base_out = zeros(size_x,size_y,n_slices);
	base_out = squeeze(base_out);
    interval = (default_powell(1):default_powell(2));
    if mrstruct_istype(in,'series3D')
        base_out = mean(in.dataAy(:,:,:,interval), 4);
    elseif mrstruct_istype(in,'series2D')
        base_out = mean(in.dataAy(:,:,interval), 3);
    end;
    [base, err] = mrstruct_checkin(rcbv,base_out);
    varargout(7) = {base};
    clear  base_out interval;
end;
if (nargout >= 8)
	tail_out = zeros(size_x,size_y,n_slices);
	tail_out = squeeze(tail_out);
    interval = ((size_t - default_powell(3)+ 1):size_t);
    if mrstruct_istype(in,'series3D')
        tail_out = mean(in.dataAy(:,:,:,interval), 4);
    elseif mrstruct_istype(in,'series2D')
        tail_out = mean(in.dataAy(:,:,interval), 3);
    end;
    [tail, err] = mrstruct_checkin(rcbv,tail_out);
    varargout(8) = {tail};
    clear  tail_out;
end;
if (nargout >= 9)
	noise_out = zeros(size_x,size_y,n_slices);
	noise_out = squeeze(noise_out);
    interval = (default_powell(1):default_powell(2));
    if mrstruct_istype(in,'series3D')
        noise_out = std(in.dataAy(:,:,:,interval),0, 4);
    elseif mrstruct_istype(in,'series2D')
        noise_out = std(in.dataAy(:,:,interval),0, 3);
    end;
    [noise, err] = mrstruct_checkin(rcbv,noise_out);
    varargout(9) = {noise};
    clear  noise_out interval;
end;

clear in;
