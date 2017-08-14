function varargout = dti_svd(varargin)
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: dti_svd.m 435 2006-03-02 16:35:11Z glauche $

rev = '$Revision: 435 $';
funcname = 'DTI SVD';

% menu setup
if nargin==2
  if ischar(varargin{1}) & ishandle(varargin{2})
    if strcmp(lower(varargin{1}),'menu')
      Menu = uimenu(varargin{2},'Label',funcname,...
	  'Callback',mfilename);
      return;
    end;
    if strcmp(lower(varargin{1}),'hmenu')
      Menu = uimenu(varargin{2},'Label',['Help on ' funcname],...
	  'Callback',['spm_help(''' mfilename ''')']);
      return;
    end;
  end;
end;

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
spm_input('!DeleteInputObj');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

V=spm_vol(spm_get);
Y=spm_read_vols(V);
szY=size(Y);
Y=reshape(Y,prod(szY(1:3)),szY(4));
sel=all(Y>0,2);
Y=Y(sel,:);
[u,s,v]=svds(Y,16);
for k=1:size(u,2)
  im=zeros(prod(szY(1:3),1));
  im(sel) = u(:,k);
  iu{k}=reshape(im,szY(1:3));
end;

Vo=V(1);
[p n e v]=fileparts(Vo.fname);
for k=1:numel(iu)
  Vo.fname = fullfile(p,['u' num2str(k) e v]);
  spm_write_vol(Vo,iu{k});
  Vo.fname = fullfile(p,['su' num2str(k) e v]);
  spm_write_vol(Vo,s(k,k)*iu{k});  
end;

y = Y(:,1);

X = u(:,1:3);

b = pinv(X)*y;

r = y-X*b;

Vo.fname = fullfile(p,['r' e v]);
im=zeros(prod(szY(1:3),1));
im(sel)=r;
im=reshape(im,szY(1:3));
spm_write_vol(Vo,im);
