function [fitfunc]   = amr_test_fit(base, tail, rcbv,at,alpha,beta,method);
%
% function [fitfunc] = amr_test_fit(base, tail, rcbv,at,alpha,beta,method);
%
% method: 'ge' or 'se'; default is 'ge'
%
% Examples:
%  for ge:
%  [fitfunc_ge] = amr_test_fit(base_ge, tail_ge, rcbv_ge,at_ge,alpha_ge,beta_ge,'ge');
%  for se:
%  [fitfunc_se] = amr_test_fit(base_se, tail_se, rcbv_se,at_se,alpha_se,beta_se,'se');
%
if  mrstruct_istype(base,'volume')
	[size_x,size_y,size_z] = size(base.dataAy);
    n_slices = size_z;
    fitfunc        = mrstruct_init('series3D');
elseif mrstruct_istype(base,'image')
    [size_x,size_y] = size(base.dataAy);
    size_z=1;
    fitfunc         = mrstruct_init('series2D');
end

amr_global
if (nargin >= 7)
    if strcmp(method,'ge')
        amr_init_ge;
    elseif strcmp(method,'se')
        amr_init_se;
    end
else
    amr_init_ge;
end


TE             = base.te/1000;
skip           = DEFAULT_POWELL(1); 
kon            = 1;
default_powell = [DEFAULT_POWELL TE];
size_t         = rcbv.user;
t              = 1:size_t;
S0_start       = DEFAULT_POWELL(1);
S0_stop        = DEFAULT_POWELL(2);
SE_int         = DEFAULT_POWELL(3);
dil_rate       = 10;
im_size	       = size_x*size_y;

  % slice = 7;
   
for slice=1:size_z;   
    %data   = squeeze(reshape(in.dataAy(:,:,slice,:),im_size,size_t));
	if  mrstruct_query(alpha,'size_z')==1
	    slice=1
	end
    alpha1 = alpha.dataAy(:,:,slice); 
    beta1  = beta.dataAy(:,:,slice);  
    rcbv1  = rcbv.dataAy(:,:,slice);   
    at1    = at.dataAy(:,:,slice);
    base1  = base.dataAy(:,:,slice);
    tail1  = tail.dataAy(:,:,slice);
    alpha1 = alpha1(:);
    beta1  = beta1(:);
    rcbv1  = rcbv1(:);
    at1    = at1(:);
    base1  = base1(:);
    tail1  = tail1(:);
    if  length(at1)~=im_size
        error('Image size of data and parameter maps do not fit!');
    end;
    
    mask    = zeros(im_size,1);
    at1     = at1+ 1; % t0 in matlab= 1, in real. aber t0= 0;
  
  
    mask      = find(beta1 ~=0);
    mask_size = length(mask);
    out	      = zeros(im_size,size_t);
    alpha1    = alpha1(mask);
    beta1     = beta1(mask);
    rcbv1     = rcbv1(mask);
    at1       = at1(mask);
    base1     = base1(mask);
    tail1     = tail1(mask);

    %for k=1:mask_size
        tat = ones([1 mask_size])'*t;
        tat = tat- (at1*ones([1 size_t]));
        ind = find(tat<0);
        tat(ind)= 0;
        
        rcbv1 = rcbv1 * ones([1 size_t]);
        Ct = rcbv1.*gammafunc(tat,alpha1,beta1,size_t);
        
        rbf_S0 = base1;
        rbf_SE = tail1;
        rbf_SS = rbf_S0 - rbf_SE;
        rbf_S0 = rbf_S0 * ones([1 size_t]);
        y      = rbf_S0.* exp(-kon.*TE.*Ct); 
        rbf_SS = rbf_SS * ones([1 size_t]);
        dil    = (1- exp(-tat./dil_rate)).* rbf_SS;
%         y      = y-dil;
        out(mask,:)=y;
        %end;
    
    out = reshape(out,size_x,size_y,size_t);
    fitfunc.dataAy(:,:,slice,:) = out; 
  
end;

fitfunc.vox     = base.vox;
fitfunc.patient = base.patient;
fitfunc.te      = base.te;
fitfunc.tr      = base.tr;
fitfunc.method  = base.method;
  
clear A tmp A_min_max mi ma mask mask_size  im_size slice i;
clear alpha1 beta1 rcbv1 base1 rcbf1;


function f = gammafunc(x,alpha,beta,size_t);


alpha = alpha * ones([1 size_t]);
beta  = beta  * ones([1 size_t]);

f = x.^alpha.*exp(-x./beta)./gamma(alpha+1)./beta.^(alpha+1);




