function dti_export_evec
% Export eigenvectors for use in tensor voting binary program.
%
% This function is part of the diffusion toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.

%_______________________________________________________________________
%
% @(#) $Id: dti_export_evec.m 435 2006-03-02 16:35:11Z glauche $

rev = '$Revision: 435 $';
ssf=10;
VEv=spm_vol(spm_get(3,'evec1*IMAGE','Eigenvector images'));
VSa=spm_vol(spm_get([0 1],'*IMAGE','Saliency image'));
X=spm_read_vols(VEv);
if ~isempty(VSa)
  XSa=spm_read_vols(VSa);
else
  XSa=ones(size(X(:,:,:,1)));
end;
[p n e v] = fileparts(VEv(1).fname);
datname = fullfile(p,[n '-mx-' num2str(ssf) '.dat' v]);
f = fopen(datname,'w');
for x=1:VEv(1).dim(1)
  for y=1:VEv(1).dim(2)
    for z=1:VEv(1).dim(3)
      if ~any(isnan(X(x,y,z,:)))&~isnan(XSa(x,y,z))&any(X(x,y,z,:)~=0)&(XSa(x,y,z)~=0)
	fprintf(f,'%f %f %f 0\n',ssf*x,ssf*y,ssf*z);
	fprintf(f,'%f %f %f 1\n',ssf*x-XSa(x,y,z)*X(x,y,z,1), ssf*y+XSa(x,y,z)*X(x,y,z,2), ssf*z+XSa(x,y,z)*X(x,y,z,3));
      end;
    end;
  end;
end;
fclose(f);
