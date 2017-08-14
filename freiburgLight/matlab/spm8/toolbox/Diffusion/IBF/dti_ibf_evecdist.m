function dti_ibf_evecdist
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: dti_ibf_evecdist.m 435 2006-03-02 16:35:11Z glauche $

rev = '$Revision: 435 $';
nsub = spm_input('# subjects','!+1');
for sub = 1:nsub
  Vevec{sub}=spm_vol(spm_get(3,'mevec1*IMAGE',['Subject ' num2str(sub) ': eigenvector images']));
  Vsal{sub} = spm_vol(spm_get([0 1],'sc*IMAGE',['Subject ' num2str(sub) ' saliency image']));
end;

for sub = 1:nsub
  evec=spm_read_vols(Vevec{sub});
  if ~isempty(Vsal{sub})
    sal = spm_read_vols(Vsal{sub});
    pref = 'svdsal';
  else
    pref = 'svd';
    sal  = [];
  end;

  szevec=size(evec);
  evec1=reshape(evec,prod(szevec(1:3)),3);
  
  clear evec;
  
  sel=all(isfinite(evec1),2)&any(evec1~=0,2);
  disp(sum(sel(:))),
  evec1=evec1(sel,:);
  
  if isempty(sal)
    c=abs(evec1*evec1');
  else
    c=abs(evec1.*repmat(sal(sel),[1 3])*evec1');
  end;
  clear evec1 sal;
  
  [u s v]=svd(c);
  ds = diag(s);
  clear u s;
  pwr = cumsum(ds)/sum(ds);
  mpwr= find(pwr>.96);
  sz = szevec(1:3);
  sX=repmat(NaN,sz);

  sX(sel) = v(:,1:mpwr(1))*ds(1:mpwr(1));

  V=Vevec{sub}(1);
  [pt na ex ve]=fileparts(V.fname);

  V.pinfo=[1 0 0]';
  V.dim(4)=spm_type('float');

  V.fname=fullfile(pt,[pref 'sum' na ex ve]);
  V.descrip=['Sum of ' num2str(mpwr(1)) ' components'];
  spm_create_vol(V);
  spm_write_vol(V,sX);
  V.fname=fullfile(pt,[pref 'scov' na ex ve]);
  V.descrip='';
  sc = repmat(NaN,szevec(1:3));
  sc(sel) = sum(c);
  spm_write_vol(V,sc./sum(sel));
  save(fullfile(pt, [pref na '.mat']),'ds','v','sel','c','sz');
  clear ds v X sX sc c sel;
end;
