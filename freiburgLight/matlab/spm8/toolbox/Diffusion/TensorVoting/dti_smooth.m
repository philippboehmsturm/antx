function ISDTI=dti_smooth(varargin)
%
% This function is part of the diffusion toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.

%_______________________________________________________________________
%
% @(#) $Id: dti_smooth.m 435 2006-03-02 16:35:11Z glauche $

rev = '$Revision: 435 $';

Finter=spm_figure('GetWin','Interactive');
spm_input('!DeleteInputObj');
Finter=spm('FigName','Diffusion - Tensor smoothing',Finter);

if nargin<1
  nsub = spm_input('# subjects','!+1','e',1);
  for sub = 1:nsub
    IDTIall{sub}=spm_vol(spm_get(6,'*D??_*IMAGE',['DTI images - subj ' int2str(sub)]));
  end;
else
    IDTIall=varargin{1};
    nsub = numel(IDTIall);
end;

% subsampling flag
if nargin<2
  ssf =  spm_input('Subsampling [vx]','!+1','e',3);
else
  ssf = varargin{2};
end;
if nargin<3
  fwhma = spm_input('fwhma','!+1','e',.5);
else
  fwhma = varargin{3};
end;
if nargin<4
  fwhmd = spm_input('fwhmd','!+1','e',.3);
else
  fwhmd = varargin{4};
end;
if nargin<5
  kstep = spm_input('Voting kernel step size','!+1','e','1/3');
else
  kstep = varargin{5};
end;
if nargin<6
  klen = spm_input('Voting kernel length','!+1','e','3');
else
  klen = varargin{6};
end;

clear dti_vote_field; % force reload of persistent variables in dti_vote_field
tens = dti_vote_field([1 1 1 0 0 0],fwhma,fwhmd,kstep,klen);
sk = size(tens); % FIXME get kernel size
sk = sk(2:end);

for sub = 1:nsub
  Finter=spm('FigName',sprintf('Diffusion - Tensor Smoothing (Subj %d of %d)',sub,nsub),Finter);
  IDTI = IDTIall{sub}; % images for subject sub
  if isstruct(IDTI) % reading image
    [p n e v]=fileparts(IDTI(1).fname);
    addon = ['tv' num2str(ssf) '-' num2str(fwhma) '-' ...
	  num2str(fwhmd)];
    [sts msg]=mkdir(p, addon);
    %  if ~isempty(msg)
    %    chk=questdlg(sprintf('An error occured while creating %s: %s', fullfile(p,addon), msg),...
    %	'Warning','Continue','Abort','Continue');
    %    if (chk ~= 'Continue')
    %      error;
    %    end;
    %  end;
    p = fullfile(p,addon);
    DTIdim=IDTI(1).dim(1:3);
    SDTIdim=(DTIdim-1)*ssf+sk;
    for j=1:6
      [tmp n e v]=fileparts(IDTI(j).fname);
      
      ISDTI{sub}(j)=IDTI(j);
      ISDTI{sub}(j).dim(1:3)=SDTIdim;
      ISDTI{sub}(j).dt=[spm_type('float32') spm_platform('bigend')];
      ISDTI{sub}(j).pinfo=[1;0;0];
      prms=spm_imatrix(ISDTI{sub}(j).mat);
      ISDTI{sub}(j).mat=spm_matrix([prms(1:6) prms(7:9)/ssf prms(10:12)]);
      ISDTI{sub}(j).fname   = fullfile(p,[n '_' addon e v]);
      ISDTI{sub}(j)=spm_create_vol(ISDTI{sub}(j));
    end;
    % prepare output array
    %-----------------------------------------------------------------------
    SD = zeros([6,SDTIdim(1:2) sk(3)]);
    sstrength = zeros([SDTIdim(1:2) sk(3)]);
  else
    DTIdim=[size(IDTI,2) size(IDTI,3) size(IDTI,4)];
    SDTIdim=(DTIdim-1)*ssf+sk;
    % prepare output array
    %-----------------------------------------------------------------------
    SD = zeros([6,SDTIdim]);
    sstrength = zeros(SDTIdim);
  end;

  %-Start progress plot
  %-----------------------------------------------------------------------
  spm_progress_bar('Init',DTIdim(3),'','planes completed');

  %-Loop over planes computing result Y
  %-----------------------------------------------------------------------
  
  for p = 1:DTIdim(3),
    if isstruct(IDTI)
      B = inv(spm_matrix([0 0 -p 0 0 0 1 1 1]));
    
      D=zeros([6,IDTI(1).dim(1:2)]); 
      D(1,:,:) = spm_slice_vol(IDTI(1),B,IDTI(1).dim(1:2),0); % hold 0
      D(2,:,:) = spm_slice_vol(IDTI(2),B,IDTI(1).dim(1:2),0); % hold 0
      D(3,:,:) = spm_slice_vol(IDTI(3),B,IDTI(1).dim(1:2),0); % hold 0
      D(4,:,:) = spm_slice_vol(IDTI(4),B,IDTI(1).dim(1:2),0); % hold 0
      D(5,:,:) = spm_slice_vol(IDTI(5),B,IDTI(1).dim(1:2),0); % hold 0
      D(6,:,:) = spm_slice_vol(IDTI(6),B,IDTI(1).dim(1:2),0); % hold 0
    end;
    for k=1:DTIdim(1)
      for l=1:DTIdim(2)
	if isstruct(IDTI)
	  Dvx=D(:,k,l);
	else
	  Dvx=IDTI(:,k,l,p);
	end;
	if all(isfinite(Dvx))&any(Dvx~=0)
	  [tens ss] = dti_vote_field(Dvx,fwhma,fwhmd,kstep,klen);
	  ix = ssf*(k-1)+[1:sk(1)];
	  iy = ssf*(l-1)+[1:sk(2)];
	  if isstruct(IDTI)
	    iz = 1:sk(3);
	  else
	    iz = ssf*(p-1)+[1:sk(3)];
	  end;
	  SD(:,ix,iy,iz) = SD(:,ix,iy,iz) + tens;
	  sstrength(ix,iy,iz) = sstrength(ix,iy,iz) + (ss~=0);
	end;
      end;
    end;
    if isstruct(IDTI)
      SD1=SD(:,:,:,1:ssf);
      sstrength1=sstrength(:,:,1:ssf);
      finsel = squeeze(any(~isfinite(SD1)));
      SD1(1,finsel)=eps;
      SD1(2,finsel)=eps;
      SD1(3,finsel)=eps;
      SD1(4,finsel)=0;
      SD1(5,finsel)=0;
      SD1(6,finsel)=0;
      for k=1:6
	for l=1:ssf
	  ISDTI{sub}(k)=spm_write_plane(ISDTI{sub}(k), ...
	      squeeze(SD1(k,:,:,l))./sstrength1(:,:,l),l+(p-1)*ssf);
	end;
      end;
      clear SD1 sstrength1 finsel;
      SD2=SD(:,:,:,(ssf+1):end);
      sstrength2=sstrength(:,:,(ssf+1):end);
      % re-prepare output array
      %-----------------------------------------------------------------------
      SD = zeros([6,SDTIdim(1:2) sk(3)]);
      SD(:,:,:,1:(sk(3)-ssf)) = SD2;
      sstrength = zeros([SDTIdim(1:2) sk(3)]);
      sstrength(:,:,1:(sk(3)-ssf))=sstrength2;
      clear SD2 sstrength2;
    end;      
    spm_progress_bar('Set',p);
  end;    
  
  %-Write output image 
  %-----------------------------------------------------------------------

  clear D;
  finsel = squeeze(any(~isfinite(SD)));
  SD(1,finsel)=eps;
  SD(2,finsel)=eps;
  SD(3,finsel)=eps;
  SD(4,finsel)=0;
  SD(5,finsel)=0;
  SD(6,finsel)=0;
  for k=1:6
    if isstruct(IDTI)
      for l=1:(sk(3)-ssf) %flush remaining SD
	ISDTI{sub}(k)=spm_write_plane(ISDTI{sub}(k), ...
	    squeeze(SD(k,:,:,l))./sstrength(:,:,l),l+p*ssf);
      end;
    else
      ISDTI{sub}(k,:,:,:)=squeeze(SD(k,:,:,:))./sstrength;
    end;
  end;
  if isstruct(ISDTI{sub})
    spm_close_vol(ISDTI{sub});
  end;
  %-End for sub = 1:nsub
  %-----------------------------------------------------------------------
  spm_progress_bar('Clear')
end;
clear dti_vote_field; % force reload of persistent variables in dti_vote_field

