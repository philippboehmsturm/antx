function C=dti_classify(job)
% Classify DTI data based on anisotropy and direction of first eigenvector
%
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id$

rev='$Revision$';

EvecHandle=spm_vol(job.e1img);
DTIData=spm_read_vols(EvecHandle);

FAHandle=spm_vol(job.faimg);
FAData=spm_read_vols(FAHandle);

MaskHandle=spm_vol(job.maskimg);
U=logical(spm_read_vols(MaskHandle));
dim=size(U);
FAsel =  (FAData>job.fathresh);

Uan = U.*FAsel;
Uis = U.*(~FAsel);

% assume DTIdata to be stored as x*y*z*datadim array

cno = 1;

Can=classify(Uan, DTIData, @collinear, @neighbour6, 1);
fprintf('\nIsotrop\n');
Cis=classify(Uis, DTIData, @isotrop, @neighbour6, max(Can(:))+1);
C=Uan.*Can + Uis.*Cis;
CHandle=EvecHandle(1);
[p n e] = spm_fileparts(CHandle.fname);
CHandle.fname = fullfile(p,[job.prefix n e]);
spm_write_vol(CHandle,C);

function C = classify(U, DTIData, classfunc, nbfunc, cno)
dim = size(DTIData);
C = zeros(dim(1:3));
while (sum(U(:)))
  N=zeros(dim(1:3));
  Nlist=cell(dim(1:3));

  [px py pz] = ind2sub(size(U),find(U));
  px=px(1); py=py(1); pz=pz(1);
  C(px,py,pz)=cno;
  U(px,py,pz)=0;
  [N Nlist] = feval(nbfunc,U,N,Nlist,[px,py,pz]);

  fprintf('\r%d - ( %2d, %2d, %2d)',cno, px, py, pz);

  while (sum(N(:)))
    [qx qy qz] = ind2sub(size(N),find(N));
    q=[qx(1) qy(1) qz(1)];
    N(q(1),q(2),q(3))=0;
    while (~isempty(Nlist{q(1),q(2),q(3)}))
      p1 = Nlist{q(1),q(2),q(3)}(1,:);
      if feval(classfunc, DTIData, p1, q)
	C(q(1),q(2),q(3)) = cno;
	U(q(1),q(2),q(3)) = 0;
	Nlist{q(1),q(2),q(3)} = [];
	[N Nlist] = feval(nbfunc, U,N,Nlist,q);
	fprintf(' %.0d',fix(sum(N(:))));
	figure(2);subplot(10,13,q(3));image(C(:,:,q(3)));
	axis off;
      else
	s = size(Nlist{q(1),q(2),q(3)});
	Nlist{q(1),q(2),q(3)} = Nlist{q(1),q(2),q(3)}(2:s(1),:);
	if isempty(Nlist{q(1),q(2),q(3)})
	  N(q(1),q(2),q(3))=0;
	end;
      end;      
    end;
  end;
  if sum(C(:)==cno) > 2
    cno = cno+1;
    fprintf('\n');
  else
    C(C==cno) = 0;
  end;
end;

function flag=collinear(DTIData, p1, p2)
dim=size(DTIData);
% dp=p2-p1; % p1+dp = p2
% p = p1 -dp;
% if (0<p) & (p < dim(1:3))
%  c(1) = sum(DTIData(p(1), p(2), p(3),:) .* DTIData(p2(1), p2(2), p2(3),:)); % "2"-Nachbar von p2
%  w(1) = 0;
%else
%  c(1)=NaN;
%  w(1)=0;
%end;
%p = p2 + dp;
%if (0<p) & (p < dim(1:3))
%  c(2) = sum(DTIData(p(1), p(2), p(3),:) .* DTIData(p1(1), p1(2), p1(3),:)); % "2"-Nachbar von p1
%  w(2) = 0;
%else
%  c(2)=NaN;
%  w(2)=0;
%end;
c(3) = sum(DTIData(p2(1), p2(2), p2(3),:) .* DTIData(p1(1), p1(2), p1(3),:));
w(3) = 3;
flag = (abs(c(3) > .99));% | (((abs(acos(c(3))-acos(c(1))) < .05) ... 
  %  | (abs(acos(c(3))-acos(c(2))) <.05)) & (abs(c(3)) >.6)) ; 
%if flag
%  [squeeze(DTIData(p2(1), p2(2), p2(3),:) .* DTIData(p1(1), p1(2), p1(3),:))]'
%  [squeeze(DTIData(p2(1), p2(2), p2(3),:))]'
%  [squeeze(DTIData(p1(1), p1(2), p1(3),:))]'
%end;

function flag=isotrop(DTIData, p1, p2)
flag = 1;

function [N, Nlist]=neighbour27(U,N,Nlist,p)
for dx = -1:1
  for dy = -1:1
    for dz = -1:1
      p1=p + [dx dy dz];
      if (p1>0) && (p1 <= size(N))
	N(p1(1),p1(2),p1(3))=U(p1(1),p1(2),p1(3));
	if U(p1(1),p1(2),p1(3))
	  Nlist{p1(1),p1(2),p1(3)} = [Nlist{p1(1),p1(2),p1(3)}; p];
	end;
      end;
    end;
  end;
end;

function [N, Nlist]=neighbour6(U,N,Nlist,p)
for k=1:3
  d=zeros(1,3);
  d(k)=1;
  p1=p + d;
  if (p1>0) && (p1 <= size(N))
    N(p1(1),p1(2),p1(3))=U(p1(1),p1(2),p1(3));
    if U(p1(1),p1(2),p1(3))
      Nlist{p1(1),p1(2),p1(3)} = [Nlist{p1(1),p1(2),p1(3)}; p];
    end;
  end;
  p1=p - d;
  if (p1>0) && (p1 <= size(N))
    N(p1(1),p1(2),p1(3))=U(p1(1),p1(2),p1(3));
    if U(p1(1),p1(2),p1(3))
      Nlist{p1(1),p1(2),p1(3)} = [Nlist{p1(1),p1(2),p1(3)}; p];
    end;
  end;
end;
