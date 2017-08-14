function [faD, faMD, divMD, Dsim, rots] = dti_simu_rot(varargin)

% function rots = dti_simu_rot(evals,mxrot,pflag)
%
% evals: mx3 matrix eigenvalues of original tensor (default [1 1 1])
% mxrot: nx1 vector of maximum rotation in degrees
% pflag: plot results? (default no)
%
% This function is part of the diffusion toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.

%_______________________________________________________________________
%
% @(#) $Id$

rev='$Revision$';

evals = [1 1 1];
mxrot = 10;
pflag  = 0;
if nargin >= 1
  switch size(varargin{1},2) 
    case 3
      evals = varargin{1};
    case 6
      clear evals;
      Dstart = varargin{1};
    otherwise
      error('Need 3-vector of eigenvalues or 6 tensor elements as input');
  end;
  ntens = size(varargin{1},1);
end;
if nargin >= 2
  mxrot = varargin{2};
end;
if nargin >= 3
  pflag = varargin{3};
end;


for j=1:ntens
  
  for l = 1:length(mxrot)
    if exist('evals','var')
      D = diag(evals(j,:));
    else
      D = [Dstart(j,1) Dstart(j,4) Dstart(j,5);...
	          Dstart(j,4) Dstart(j,2) Dstart(j,6);...
		  Dstart(j,5) Dstart(j,6) Dstart(j,3)];
    end;

    [Dsim{l,j} rots{l,j}]=gen_time_series(D,'rot_sym',mxrot(l)/180*pi,140,1);

    MD = mean(Dsim{l,j},3);
    [v,d] = eig(MD);
    d=diag(d);
    [tmp ind]=sort(-d);
    [vo,do] = eig(D);
    do=diag(do);
    [tmp,indo]=sort(-do);
    
    divMD(j,l) = sum(vo(:,indo(1))'*v(:,ind(1)));
    faMD(j,l) = sqrt(3/2*sum(sum( (MD-trace(MD)/3*eye(3)).^2 ))...
	/sum(sum(MD.^2)));
    if pflag
      plot_time_series(Dsim{l,j},rots{l,j},mxrot(l));
    end;
  end;
  faD(j)  = sqrt(3/2*sum(sum( (D(:,:,1)-trace(D(:,:,1))/3*eye(3)).^2 ))...
      /sum(sum(D(:,:,1).^2)));
end;

[tmp,ind] = sort(faD);
faD=faD(ind);
faMD=faMD(ind,:);
divMD=divMD(ind,:);
figure;subplot(2,1,1);plot(mxrot,faMD./repmat(faD',1,length(mxrot)));
subplot(2,1,2);plot(mxrot,acos(abs(divMD))*180/pi); 
legend(num2str(faD'));


function [Dsim, rots] = gen_time_series(Dstart, rotfun, mxrot, nruns, itflag)

rots = zeros(nruns,3);
Dsim(:,:,1) = Dstart;
for k=2:nruns
  rots(k,:) = feval(rotfun,mxrot);
  if itflag % movement relative to previous time point
    rots(k,:) = rots(k-1,:)+rots(k,:);
  end;
  M = spm_matrix([0 0 0 rots(k,:)]);
  Dsim(:,:,k) = M(1:3,1:3)'*Dsim(:,:,1)*M(1:3,1:3);
end;

function rot = rot_sym(mxrot)
rot = mxrot*rand(1,3)-mxrot/2;

function rot = rot_asym(mxrot)
rot = mxrot*rand(1,3)-3/7*mxrot;

function plot_time_series(D,rots,mxrot)

f=figure;
subplot(1,2,1);
view(3);
p0 = [0 0 0];
[v,d] = eig(D(:,:,1));
d=diag(d);
dl=line([p0;v(:,1)'*d(1)],[p0;v(:,2)'*d(2)],[p0;v(:,3)'*d(3)],...
    'Color','r','LineWidth',.2);
hold on;
for k=2:size(D,3)-1
  MD = mean(D(:,:,1:k),3);
  [v,d] = eig(MD);
  d=diag(d);
  dl1=line([p0;v(:,1)'*d(1)],[p0;v(:,2)'*d(2)],[p0;v(:,3)'*d(3)],...
      'Color','b','LineWidth',.5);
end;
MD = mean(D,3);
[v,d] = eig(MD);
d=diag(d);
dl1=line([p0;v(:,1)'*d(1)],[p0;v(:,2)'*d(2)],[p0;v(:,3)'*d(3)],...
	  'Color','m','LineWidth',2);

mx=max(abs(axis));
axis([-mx mx -mx mx -mx mx]); axis square;
subplot(1,2,2);
plot(rots*180/pi);
xlabel(sprintf('Maximum rotation %f degrees',mxrot));
