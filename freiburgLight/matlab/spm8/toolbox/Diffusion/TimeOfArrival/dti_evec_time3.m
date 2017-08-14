function dti_evec_time3(varargin)
% Compute time of arrival map for diffusion data
%
% References:
% [Set96]      Sethian, James A. A Fast Marching Level Set Method for
%              Monotonically Advancing Fronts. Proceedings of the National
%              Academy of Sciences, USA, 93(4):1591 -- 1595, 1996.
%
% FORMAT bchdefaults = dti_evec_time3('defaults')
% ======
% returns the default batch structure as described below. This structure
% can be used as a skeleton to fill in necessary values for batch processing.
%
% FORMAT [res bchdone]=dti_evec_time3(bch)
% ======
% This function incorporates the GUI frontend and former dti_time3allway.
%
% This function is part of the diffusion toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.

%_______________________________________________________________________
%
% @(#) $Id: dti_evec_time3.m 452 2006-06-08 09:27:02Z glauche $

  rev = '$Revision: 452 $';
  funcname = 'Time of arrival';
  
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
  
  % defaults
  mydefaults = struct('ecfiles',{{}}, 'evfiles',{{}}, 'salfiles',{{}},...
                      'mask',{{}},'sroi',{{}}, 'eroi',{{}}, 'frac',[], ...
                      'resfile',{{}});
  if nargin==1 & ischar(varargin{1}) & strcmp(lower(varargin{1}),'defaults')
    varargout{1} = mydefaults;
    return;
  end;
  
  % function preliminaries
  Finter=spm_figure('GetWin','Interactive');
  spm_input('!DeleteInputObj');
  Finter=spm('FigName',funcname,Finter);
  SPMid = spm('FnBanner',mfilename,rev);
  % function code starts here
  
% Check input arguments
if (nargin==1) & isstruct(varargin{1})
  % Check for spmr_pp-batch
  if isfield(varargin{1},'step')
    bch = fillstruct(mydefaults, varargin{1}.step);
  else
    bch = fillstruct(mydefaults, varargin{1});
  end;
  nsub = numel(bch);
else
  nsub   = spm_input('# subjects','!+1','e','');
  bch=repmat(mydefaults,[nsub 1]);
end;

for sub = 1:nsub
  spm_input(sprintf('subject %d', sub),1,'d',funcname);
    ssub = sprintf('Subj %d - ', sub);
    if isempty(bch(sub).ecfiles)
      bch(sub).ecfiles=spm_get(9, 'evec*IMAGE',...
                               {[ssub 'Eigenvector images']});
    end;
    if isempty(bch(sub).evfiles)
      bch(sub).evfiles=spm_get(3,'eval*IMAGE',...
                               {[ssub 'Eigenvalue images']});
    end;
    if isempty(bch(sub).salfiles)
      bch(sub).salfiles=spm_get([0 3],'s*IMAGE',...
                                {[ssub 'Saliency images (optional)']});
      if isempty(bch(sub).salfiles)
        bch(sub).salfiles={''};
      end;
    end;
    if isempty(bch(sub).mask)
      bch(sub).mask=spm_get(1,'*IMAGE',{[ssub 'DTI data mask']});
    end;
    if isempty(bch(sub).sroi)
      bch(sub).sroi=spm_get(1,'*roi*IMAGE',{[ssub 'Starting ROI']});
    end;
    if isempty(bch(sub).eroi)
      bch(sub).eroi=spm_get([0 1], '*roi*IMAGE',...
                            {[ssub 'Destination ROI (optional)']});
      if isempty(bch(sub).eroi)
        bch(sub).eroi={''};
      end;
    end;
    if isempty(bch(sub).frac)
      bch(sub).frac=spm_input([ssub 'fraction of voxels'],'!+1','e',1);
    end;
    if isempty(bch(sub).resfile)
      [p n e v] = fileparts(bch(sub).ecfiles{1});
      bch(sub).resfile={spm_input([ssub 'results filename base'],'!+1', ...
                                  's',p)};
    end;
  end;
  
  for sub = 1:nsub
    fprintf('%s - subject %d of %d\n', funcname, sub, nsub);
    
    EcH = spm_vol(strvcat(bch(sub).ecfiles));
    EcDt=zeros([3, 3, EcH(1).dim(1:3)]); % 3 for all 3 evecs
    EcDt(1,:,:,:,:)=shiftdim(spm_read_vols(EcH(1:3)),3);
    EcDt(2,:,:,:,:)=shiftdim(spm_read_vols(EcH(4:6)),3);
    EcDt(3,:,:,:,:)=shiftdim(spm_read_vols(EcH(7:9)),3);
    
    EvH = spm_vol(strvcat(bch(sub).evfiles));
    EvDt=abs(shiftdim(spm_read_vols(EvH),3));
    
    if isempty(bch(sub).salfiles{1})
      bchsal=dti_saliencies('defaults');
      res = dti_saliencies(setfield(bchsal,'files',bch(sub).evfiles));
      bch(sub).salfiles = {res.sc{1},res.sp{1},res.ss{1}};
    end;
    SalH = spm_vol(strvcat(bch(sub).salfiles));
    SalDt=shiftdim(spm_read_vols(SalH),3);
    MaskH=spm_vol(bch(sub).mask{1});
    MaskDt=spm_read_vols(MaskH);
    MaskDt(~isfinite(MaskDt))=0;
    StartDt=spm_read_vols(spm_vol(bch(sub).sroi{1}))&MaskDt;
    
    if isempty(bch(sub).eroi{1})
      EndDt = [];
    else
      EndDt=spm_read_vols(spm_vol(bch(sub).eroi{1}))&MaskDt;
      if ~any(EndDt(:))
        EndDt = [];
      end;
    end;
    
    % we need voxel size later on
    P = spm_imatrix(MaskH.mat);
    VOX = abs(P(7:9));
    
    % Voxel selection
    xmin = 1;
    xmax = MaskH.dim(1);%118;
    ymin = 1;
    ymax = MaskH.dim(2);%118;
    sx = xmax - xmin + 1;
    sy = ymax - ymin + 1;
    sz = MaskH.dim(3);
    
    % set Eigenvalues and saliencies (and thereby velocity) to 0 for out of
    % brain voxels  
    EvDt(:,~logical(MaskDt(xmin:xmax,ymin:ymax,1:MaskH.dim(3))))=0;
    SalDt(:,~logical(MaskDt(xmin:xmax,ymin:ymax,1:MaskH.dim(3))))=0;
    
    %fvel = inline('100*EvDt(1)*abs(sum(squeeze(EcDt1(1,:)).*squeeze(EcDt2(1,:))))+EvDt(2)*abs(sum(squeeze(EcDt1(2,:)).*squeeze(EcDt2(2,:))))+EvDt(3)*abs(sum(squeeze(EcDt1(3,:)).*squeeze(EcDt2(3,:))));','EvDt','EcDt1','EcDt2');
    %fvel = inline(['100*sum(EvDt.*squeeze(abs(sum(squeeze(EcDt1)'...
    %                        '.*repmat(ds,3,1),2))))'... 
    %                 '.*sum(EvDt.*squeeze(abs(sum(squeeze(EcDt1)'...
    %		        '.*squeeze(EcDt2),2))));'], ...
    %    'EvDt', 'EcDt1', 'EcDt2', 'ds');

    fvel = inline(['SalDtc(1,:).*abs(sum(squeeze(EcDtc(1,:,:)).*ds)).*'...
                   '(SalDtn(1,:).*'...
                   'abs(sum(squeeze(EcDtc(1,:,:)).*squeeze(EcDtn(1,:,:))))'...
                   '+SalDtn(2,:).*'...
                   '(1-abs(sum(squeeze(EcDtc(1,:,:)).*squeeze(EcDtn(3,:,:)))))'...
                   '+SalDtn(3,:))'...
                   '+SalDtc(2,:).*(1-abs(sum(squeeze(EcDtc(1,:,:)).*ds))).*'...
                   '(SalDtn(1,:).*'...
                   '(1-abs(sum(squeeze(EcDtc(3,:,:)).*squeeze(EcDtn(1,:,:)))))'...
                   '+SalDtn(2,:).*'...
                   'abs(sum(squeeze(EcDtc(3,:,:)).*squeeze(EcDtn(3,:,:))))'...
                   '+SalDtn(3,:))'...
                  ],...%               '+SalDtc(3,:)'], ...
                  'EcDtc','EcDtn','SalDtc','SalDtn','ds');
    
    sumu=floor(bch(sub).frac*sum(EvDt(1,:)>0));
    
    alive=logical(StartDt(xmin:xmax,ymin:ymax,1:MaskH.dim(3)));
    
    bandx(2:sx,:,:)=alive(1:sx-1,:,:);
    bandx(1:sx-1,:,:)=bandx(1:sx-1,:,:)|alive(2:sx,:,:);
    bandx=bandx&~alive&MaskDt;
    bandy(:,2:sy,:)=alive(:,1:sy-1,:);
    bandy(:,1:sy-1,:)=bandy(:,1:sy-1,:)|alive(:,2:sy,:);
    bandy=bandy&~alive&MaskDt;
    bandz(:,:,2:sz)=alive(:,:,1:sz-1);
    bandz(:,:,1:sz-1)=bandz(:,:,1:sz-1)|alive(:,:,2:sz);
    bandz=bandz&~alive&MaskDt;
    
    T=Inf*ones(sx,sy,sz);
    D=Inf*ones(sx,sy,sz);
    P=Inf*ones(sx,sy,sz);
    Tloc=zeros(sx,sy,sz);
    T(alive)=0;
    D(alive)=0;
    P(alive)=0;
    
    % Initialize T(band)
    
    T(bandx) = VOX(1)./fvel(EcDt(:,:,bandx), EcDt(:,:,bandx), ...
                            SalDt(:,bandx), SalDt(:,bandx), ...
                            repmat([1 0 0]',[1 sum(bandx(:))])); 
    T(bandy) = VOX(2)./fvel(EcDt(:,:,bandy), EcDt(:,:,bandy),...
                            SalDt(:,bandy), SalDt(:,bandy),...
                            repmat([0 1 0]',[1 sum(bandy(:))]));
    T(bandz) = VOX(3)./fvel(EcDt(:,:,bandz), EcDt(:,:,bandz),...
                            SalDt(:,bandz), SalDt(:,bandz),...
                            repmat([0 0 1]',[1 sum(bandz(:))]));
    band=bandx+bandy+bandz>0;
    D(band)=1;
    
    clear bandx bandy bandz StartDt;
    
    global nbhood6;
    res = dti_sphere_nb(struct('nb',6));
    nbhood6 = res.nbhood;
    
    global nbhood26;
    res = dti_sphere_nb(struct('nb',26));
    nbhood26 = res.nbhood;
    
    global nbhood;
    nbhood=nbhood26;
    
    global nbdist;
    nbdist=sqrt(sum((nbhood.*repmat(VOX,[size(nbhood,1) 1])).^2,2))';
    
    global opts;
    opts=optimset('fzero');
    
    %spm_progress_bar('Init',sumu,'','voxels');
    
    mT = zeros(1,sumu);
    f=spm_figure('GetWin', 'Interactive');
    spm_figure('Clear', f);
    xlabel('Iterations');
    ylabel('Min time');
    for numb=1:sumu
      Bandind=find(band);
      if isempty(Bandind)
        break;
      end;
      [mT(numb) ind1]=min(T(band));
      ind = Bandind(ind1(1));
      if mT(numb) == Inf
        break;
      end;
      
      figure(f);plot(mT(1:numb));
      
      [xc yc zc] = ind2sub([sx sy sz], ind);
      alive(xc,yc,zc)=1;
      band(xc,yc,zc)=0;
      if ~isempty(EndDt) & all(alive(EndDt(:)))
        break;
      end;
      
      EvDtc=EvDt(:,xc,yc,zc);
      SalDtc=SalDt(:,xc,yc,zc);
      EcDtc=EcDt(:,:,xc,yc,zc);
      
      xnb = xc+nbhood(:,1);
      ynb = yc+nbhood(:,2);
      znb = zc+nbhood(:,3);
      sel = (xnb>=1) & (ynb>=1) & (znb>=1) &...
            (xnb<=sx) & (ynb<=sy) & (znb<=sz);
      nbcur = nbhood(sel,:);
      xnb = xnb(sel);
      ynb = ynb(sel);
      znb = znb(sel);
      
      % neighbour select
      for nbk = 1:size(nbcur,1)
        if ~alive(xnb(nbk),ynb(nbk),znb(nbk))
          band(xnb(nbk),ynb(nbk),znb(nbk)) = 1;
          SalDtn=SalDt(:,xnb(nbk),ynb(nbk),znb(nbk));
          EcDtn=EcDt(:,:,xnb(nbk),ynb(nbk),znb(nbk));
          dsc = nbcur(nbk,:);
          vel = SalDtc(1).*abs(sum(EcDtc(1,:).*dsc))...
                .*(SalDtn(1).*abs(sum(EcDtc(1,:).*EcDtn(1,:)))...
                   +SalDtn(2).*(1-abs(sum(EcDtc(1,:).*EcDtn(3,:))))...
                   +SalDtn(3))...
                +SalDtc(2).*(1-abs(sum(EcDtc(3,:).*dsc)))...
                .*(SalDtn(1).*(1-abs(sum(EcDtc(3,:).*EcDtn(1,:))))...
                   +SalDtn(2).*abs(sum(EcDtc(3,:).*EcDtn(3,:)))...
                   +SalDtn(3));%...
                               %	  +SalDtc(3);
          
          if vel > 0
            nbrec = [nbhood(:,1)+xnb(nbk),...
                     nbhood(:,2)+ynb(nbk) nbhood(:,3)+znb(nbk)];
            
            sel = nbrec(:,1)>=1 & nbrec(:,2)>=1 & nbrec(:,3)>=1 &...
                  nbrec(:,1)<=sx & nbrec(:,2)<=sy & nbrec(:,3)<=sz;
            nbind = sub2ind([sx sy sz], nbrec(sel,1), nbrec(sel,2), nbrec(sel,3));
            trec(sel) = T(nbind);
            trec(~sel) = Inf;
            if any(isfinite(trec))    
              try
                tmp = fzero(@diffT1, mT(numb), opts,  trec, nbdist, vel); 
              catch
                disp(lasterr),
              end
            else
              tmp = inf;
            end;
          else
            tmp = inf;
          end;
          
          if (tmp<T(xnb(nbk),ynb(nbk),znb(nbk)))
            D(xnb(nbk),ynb(nbk),znb(nbk)) = D(xc,yc,zc) + 1;
            P(xnb(nbk),ynb(nbk),znb(nbk)) = ind;
            T(xnb(nbk),ynb(nbk),znb(nbk))=tmp; 
            if tmp < mT(numb)
              Tloc(xnb(nbk),ynb(nbk),znb(nbk))=tmp;
            end,
          end;
        end;
      end;
      %    spm_progress_bar('Set',numb);
    end;
    
    Ta=full(T);
    Tb=full(T);
    Ta(~(isfinite(Ta)&alive)) = NaN;
    Tb(~(isfinite(Tb)&band)) = NaN;
    
    P(~alive)=NaN;
    D(~alive)=NaN;
    
    THa = EcH(1);
    THb = EcH(1);
    THl = EcH(1);
    DH = EcH(1);
    PH = EcH(1);
    VH = EcH(1);
    
    [p n e v] = fileparts(THa.fname);
    n = bch(sub).resfile{1};
    THa.fname = fullfile(p,['ta_' n e v]);
    res(sub).ta = {THa.fname};
    THb.fname = fullfile(p,['tb_' n e v]);
    res(sub).tb = {THb.fname};
    THl.fname = fullfile(p,['tl_' n e v]);
    res(sub).tl = {THl.fname};
    DH.fname = fullfile(p,['dst_' n e v]);
    res(sub).dst = {DH.fname};
    PH.fname = fullfile(p,['trc_' n e v]);
    res(sub).trc = PH.fname;
    VH.fname = fullfile(p,['vel_' n e v]);
    res(sub).vel = VH.fname;
    
    spm_write_vol(THa,reshape(Ta,THa.dim(1:3)));
    spm_write_vol(THb,reshape(Tb,THb.dim(1:3)));
    spm_write_vol(THl,reshape(Tloc,THb.dim(1:3)));
    spm_write_vol(DH,reshape(D,DH.dim(1:3)));
    spm_write_vol(PH,reshape(P,PH.dim(1:3)));
    spm_write_vol(VH,D./reshape(Ta,PH.dim(1:3)));
    spm_input('!DeleteInputObj');
    %spm_progress_bar('Clear');
    return;
  end;
  
function err = diffT(t,t1,dx,vel)
% t1 directions are x, y, z, -x, -y, -z
err = max( max((t1(4)-t)/(-dx(1)),0), -min((t1(1)-t)/dx(1),0) ).^2 + ...
    max( max((t1(5)-t)/(-dx(2)),0), -min((t1(2)-t)/dx(2),0) ).^2 + ...
    max( max((t1(6)-t)/(-dx(3)),0), -min((t1(3)-t)/dx(3),0) ).^2 - 1/vel.^2;
disc=[max((t1(4)-t)/(-dx(1)),0).^2 min((t1(1)-t)/dx(1),0).^2 ...
      max((t1(5)-t)/(-dx(2)),0).^2 min((t1(2)-t)/dx(2),0).^2 ...
      max((t1(6)-t)/(-dx(3)),0).^2 min((t1(3)-t)/dx(3),0).^2];

return;

function err = diffT1(t,t1,dx,vel)
% t1 directions are x, y, z, -x, -y, -z
% max(-x -y -z replaced by min(x y z
%err = min((t1(4)-t)/dx(1),0).^2 + min((t1(1)-t)/dx(1),0).^2 + ...
%    min((t1(5)-t)/dx(2),0).^2 + min((t1(2)-t)/dx(2),0).^2 + ...
%    min((t1(6)-t)/dx(3),0).^2 + min((t1(3)-t)/dx(3),0).^2 - 1/vel.^2;
err = sum(min((t1-t)./dx,0).^2) - 1/vel.^2;

return;

