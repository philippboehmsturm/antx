function varargout=dti_stream3
%
% This function is part of the diffusion toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id$

rev = '$Revision$';

EvecHandle=spm_vol(spm_get(3,'evec*IMAGE','Eigenvector images'));% 9 for all 3 evecs
EvecData=zeros([1, 3, EvecHandle(1).dim(1:3)]); % 3 for all 3 evecs
EvecData(1,:,:,:,:)=shiftdim(spm_read_vols(EvecHandle(1:3)),3);
%EvecData(2,:,:,:,:)=shiftdim(spm_read_vols(EvecHandle(4:6)),3);
%EvecData(3,:,:,:,:)=shiftdim(spm_read_vols(EvecHandle(7:9)),3);

%EvalsHandle=spm_vol(spm_get(3,'eval*IMAGE','Eigenvalue images'));
%EvalsData=shiftdim(spm_read_vols(EvalsHandle),3);

FAHandle=spm_vol(spm_get(1,'fa*IMAGE','Fractional anisotropy image'));
FAData=spm_read_vols(FAHandle);

MaskHandle=spm_vol(spm_get(1,'mask*IMAGE','DTI data mask'));
MaskData=spm_read_vols(MaskHandle);

%RoiName=spm_get(1,'*IMAGE','Streamline ROI');
%RoiHandle=spm_vol(RoiName);
RoiData=zeros(FAHandle.dim(1:3));%spm_read_vols(RoiHandle);
RoiData(75:80,40:45,63:66)=1;
% Voxel selection
xmin=1;%11;
xmax=MaskHandle.dim(1);%118;
ymin=1;%11;
ymax=MaskHandle.dim(2);%118;

[x1 y1 z1]=meshgrid(ymin:ymax,xmin:xmax,1:MaskHandle.dim(3));

tmp=MaskHandle.mat*[x1(:)'; y1(:)'; z1(:)'; ones(size(x1(:)'))];
x = reshape(tmp(1,:),size(x1));
y = reshape(tmp(2,:),size(x1));
z = reshape(tmp(3,:),size(x1));

% Assume identical mask and data space
% sc=max(abs(EvalsData(1,:)));
u=squeeze(EvecData(1,1,xmin:xmax,ymin:ymax,1:MaskHandle.dim(3)));
   %.* squeeze(EvalsData(1,xmin:xmax,ymin:ymax,1:MaskHandle.dim(3)))/sc; 
v=squeeze(EvecData(1,2,xmin:xmax,ymin:ymax,1:MaskHandle.dim(3)));% .* ...
    % squeeze(EvalsData(1,xmin:xmax,ymin:ymax,1:MaskHandle.dim(3)))/sc; 
w=squeeze(EvecData(1,3,xmin:xmax,ymin:ymax,1:MaskHandle.dim(3))); %.* ...
    % squeeze(EvalsData(1,xmin:xmax,ymin:ymax,1:MaskHandle.dim(3)))/sc;

% rotate vector data, no translation, scaling or affine transformation
%P=spm_imatrix(MaskHandle.mat);
%tmp=spm_matrix([0 0 0 P(4:6)])*[u1(:)'; v1(:)'; w1(:)'; ones(size(u1(:)'))];
%u = reshape(tmp(1,:),size(u1));
%v = reshape(tmp(2,:),size(u1));
%w = reshape(tmp(3,:),size(u1));

mFAData=.08;%mean(abs(FAData(:).*MaskData(:))); % mean FA of relevant Voxels

select=logical( ...
    abs(FAData(xmin:xmax,ymin:ymax,1:MaskHandle.dim(3))) >mFAData); 
fprintf('FA threshold: %d\n',mFAData);
roiselect=logical(select.*RoiData);
%roiselect=zeros(size(x));
%rxmin=1;
%rxmax=64;
%rymin=1;
%rymax=64;
%rzmin=4;
%rzmax=17;
%roiselect(rxmin:rxmax,rymin:rymax,rzmin:rzmax) = ...
%    ones(rxmax-rxmin+1,rymax-rymin+1,rzmax-rzmin+1);

%roiselect=logical(roiselect.*select.*RoiData(xmin:xmax,ymin:ymax,1:MaskHandle.dim(3)));


%clear tmp x1 y1 z1 u1 v1 w1

% in brain voxels below fa threshold set to zero
u(~select)=0;
v(~select)=0;
w(~select)=0;

u(~logical(MaskData(xmin:xmax,ymin:ymax,1:MaskHandle.dim(3))))=NaN;
v(~logical(MaskData(xmin:xmax,ymin:ymax,1:MaskHandle.dim(3))))=NaN;
w(~logical(MaskData(xmin:xmax,ymin:ymax,1:MaskHandle.dim(3))))=NaN;

lines=stream3(x, y, z,...
              u, v, w,...
              x(roiselect),...
              y(roiselect),...
              z(roiselect),...
              [.5 512]);

fprintf('Removing NaN''s\n');
sel=zeros(size(lines,2),1);
for k=1:size(lines,2)
  if(~isempty(lines{k}))
    lines{k}=lines{k}(~isnan(lines{k}(:,1)),:);
    if (size(lines{k},1) > 4)
      lines{k}=lines{k}*[0 1 0;1 0 0; 0 0 1];
      sel(k)=1;
    end;
  end;
end;
lines1=lines(logical(sel));
clear lines;

figure; view(3);

h=streamline(lines1);
for k=1:size(h,1) 
  xd=get(h(k),'XData');
  yd=get(h(k),'YData'); 
  zd=get(h(k),'ZData'); 

% quick hack to get "old" coloring
  txyz=MaskHandle.mat\[xd;yd;zd;ones(size(xd))];
 
  xd2=(max(txyz(1,:))-min(txyz(1,:)))^2;
  yd2=(max(txyz(2,:))-min(txyz(2,:)))^2;
  zd2=(max(txyz(3,:))-min(txyz(3,:)))^2;

  set(h(k),'Color',[(xd2>=yd2+zd2)*.5 + (xd2>=3*(yd2+zd2))*.5,...
		    (yd2>=xd2+zd2)*.5 + (yd2>=3*(xd2+zd2))*.5,...
		    (zd2>=xd2+yd2)*.5 + (zd2>=3*(xd2+yd2))*.5]); 
end
xlabel('x');
switch nargout
  case 1
    varargout(1)=lines1;
  case 2
    varargout{1}=lines1;
    varargout{2}=h;
end;
