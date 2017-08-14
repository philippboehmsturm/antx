function spm_movie(Action,Orient,F,p,nloops,mode,scal)
% Runs a movie of a plane from a series of images
% FORMAT spm_movie
%
% This is a simple command-line utility which you can use if you
% wish.
%
% The movie can be displayed as transverse, coronal or sagittal
% in movie mode or slider mode which allows slide selection of
% the frame
%
% @(#)spm_movie.m  		John Ashburner, Chloe Hutton

if (nargin==0)
        spm_progress_bar('Clear');
	spm_figure('Clear','Interactive');
        Orient= spm_input('Select slice orientation',...
		1,'m','transverse|sagittal|coronal');
	F      = spm_select(Inf,'image','select images');
	p      = spm_input('plane #',1);
	scal = spm_input('Intensity scaling','+1','m',{'1st image', ...
		    'per image (linear)','per image (equalised)'}, [0 1 2], 0);
        smode=spm_input('Use slider to view movie ?','+1','b',{'yes','no'});
        if strcmp(lower(smode(1)),'y')
           nloops=1;
           mode=1;
        else
           nloops = spm_input('# loops',2);
           mode=0;
        end
	set(spm_figure('FindWin','Interactive'),...
		'Name','Movie','Pointer','watch');   
	spm_movie('Load',Orient,F,p,nloops,mode,scal);
	spm_figure('Clear','Interactive');
	return;
end

switch lower(Action), case('load')
%==========================================================
% Open graphics window to display images as loaded

global PRINTSTR
if isempty(PRINTSTR)
   PRINTSTR='print -dpsc2 -append spm.ps';
end;

n = size(F,1);
figwin=spm_figure('FindWin','Graphics');
if isempty(figwin)
   figwin=spm_figure('Create','Graphics','Graphics');
end
spm_figure('Clear','Graphics');

fig = axes('position',[0.25 0.25 0.5 0.5],'Parent',figwin);
axis image;axis off;
disp('Don''t move the Graphics Window off the edge of the');
disp('screen while spm_movie is preparing the sequence.');
disp('This results in a Segmentation Fault.');

% Read first volume to get dimensions
%---------------------------------------------------------
f = deblank(F(1,:));
V = spm_vol(f);

if Orient==2 | Orient==3
% Sagittal or Coronal slice
%==========================================================
% Display progress bar
spm_progress_bar('Init',n,'Preparing','Images Complete');

   if Orient==2
      % Sagittal slice
      %------------------------------------
      C=[0 0 1 0;0 1 0 0;1 0 0 0;0 0 0 1];
      DIM=V.dim([3 2]);
   elseif Orient==3
      % Coronal slice
      %------------------------------------
      C=[0 0 1 0;1 0 0 0;0 -1 0 0;0 0 0 1];
      DIM=V.dim([3 1]);
      p=-p;
   end;

for j=1:n
	set(0,'CurrentFigure',figwin);
	f = deblank(F(j,:));
	V = spm_vol(f);
        C(3,4)=-p;
	img = spm_slice_vol(V,inv(C),DIM,0);
        if scal==2
                img = histeq(img,255);
        end;
	bar = zeros(size(img,1),2);
	if (j==1)
		s = 64/max(max(img));
 		im=image([bar img*s],'Parent',fig,'Tag','ToDelete');
                set(figwin,'CurrentAxes',fig);
		axis image; axis xy; %axis off
                set(gca,'xgrid','on','ygrid','on','xcolor',[1 1 1],...
                        'ycolor',[1 1 1]);
		M = moviein(n,fig);
                idata=get(im,'CData');
                idim=size(idata);
                MI=zeros(idim(1)*idim(2),n);
	else
		l = round(size(img,1)*(j-1)/(n-1));
		if l>0, bar(1:l,2)=64; end;
		if scal s = 64/max(max(img)); end;
                set(gca,'xgrid','on','ygrid','on','xcolor',[1 1 1],...
                        'ycolor',[1 1 1]);
		im=image([bar img*s],'Parent',fig,'Tag','ToDelete');
                set(figwin,'CurrentAxes',fig);
		axis image; axis xy;%axis off
                set(gca,'xgrid','on','ygrid','on','xcolor',[1 1 1],...
                        'ycolor',[1 1 1]);
	end
	drawnow;
	M(:,j) = getframe(fig);
	idata=get(im,'CData');
        idim=size(idata);
        MI(:,j)=reshape(idata,idim(1)*idim(2),1);
	spm_progress_bar('Set',j);
end

elseif Orient==1
% Transverse slice
%==========================================================
C=[1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1];
DIM=V.dim(1:2);
% Display progress bar
spm_progress_bar('Init',n,'Preparing','Images Complete');

for j=1:n
        set(0,'CurrentFigure',figwin);
	f = deblank(F(j,:));
	V = spm_vol(f);
        C(3,4)=-p;
	img = spm_slice_vol(V,inv(C),DIM,0);
        if scal==2
                img = histeq(img,255);
        end;
	bar = zeros(size(img,2),2);
	if (j==1)
		s = 64/max(max(img));
 		im=image([flipud(bar) rot90(img*s)],...
		         'Parent',fig,'Tag','ToDelete');
                set(figwin,'CurrentAxes',fig);
		axis image;% axis off
                set(gca,'xgrid','on','ygrid','on','xcolor',[1 1 1],...
                        'ycolor',[1 1 1]);
		M = moviein(n,fig);
                idata=get(im,'CData');
                idim=size(idata);
                MI=zeros(idim(1)*idim(2),n);
	else
                l = round(size(img,2)*(j-1)/(n-1));
		if l>0, bar(1:l,2)=64; end;
		if scal s = 64/max(max(img)); end;
		im=image([flipud(bar) rot90(img*s)],...
		'Parent',fig,'Tag','ToDelete');
                set(figwin,'CurrentAxes',fig);
		axis image;%axis off
                set(gca,'xgrid','on','ygrid','on','xcolor',[1 1 1],...
                        'ycolor',[1 1 1]);
	end
	drawnow;
	M(:,j) = getframe(fig);
        idata=get(im,'CData');
        idim=size(idata);
        MI(:,j)=reshape(idata,idim(1)*idim(2),1);
       	spm_progress_bar('Set',j);
end

end

spm_figure('Clear','Interactive');

% Display movie or slider as required
%----------------------------------------------------------
if mode==0 
   h=findobj('Tag','ToDelete');
   if ~isempty(h)
      delete(h);
   end;
   movie(fig,M,nloops)
elseif mode==1
   if n==1 
      min_step=0.5;
      max_step=1;
      min_slide=0;
      max_slide=0.5;
   elseif n==2
      min_step=0.5;
      max_step=1;
      min_slide=0;
      max_slide=n-1;
   elseif n<=10
      min_step=1/(n-1);
      max_step=1;
      min_slide=0;
      max_slide=n-1;
   else
      min_step=1/(n-1);
      max_step=10/(n-1);
      min_slide=0;
      max_slide=n-1;
   end
   h=findobj('Tag','ToDelete');
   if ~isempty(h)
      delete(h);
   end;

   m_struct=struct('movie',MI,'filename',F,'dim',idim,'orient',Orient);
   s=uicontrol('Style','slider','Parent',figwin,...
		    'Position',[200 150 200 30],...
		    'Min',min_slide,'Max',max_slide,...
		    'SliderStep',[min_step max_step],...
                    'Callback','spm_movie(''Scroll'');',...
		    'Userdata',m_struct,'String','Frame number');
   set(0,'CurrentFigure',figwin);
   fig = axes('position',[0.25 0.25 0.5 0.5],'Parent',figwin);
   I=reshape(MI(:,1),idim(1),idim(2));
   image(I,'Parent',fig,'Tag','ToDelete');
   axis image; 
   if Orient==2 | Orient==3
      axis xy;
   end;
   set(gca,'xgrid','on','ygrid','on','xcolor',[1 1 1],...
           'ycolor',[1 1 1]);
   frame=sprintf('%s',deblank(F(1,:)));
   t=title(frame,'FontSize',14,'HandleVisibility','on','Tag','ToDelete');
end

case('scroll')
%==========================================================
global PRINTSTR
if isempty(PRINTSTR)
   PRINTSTR='print -dpsc2 -append spm.ps';
end;

g=get(gcbo,'Value');
m_struct=get(gcbo,'Userdata');
M=m_struct.movie;
Or=m_struct.orient;
idim=m_struct.dim;
F=m_struct.filename;
figwin=spm_figure('FindWin','Graphics');
if isempty(figwin)
   figwin=spm_figure('Create','Graphics','Graphics');
end
h=findobj('Tag','ToDelete');
if ~isempty(h)
   delete(h);
end;
fig = axes('position',[0.25 0.25 0.5 0.5],'Parent',figwin);
I=reshape(M(:,floor(g+1)),idim(1),idim(2));
image(I,'Parent',fig,'Tag','ToDelete');
axis image; 
if Or==2 | Or==3
   axis xy; 
end;
set(gca,'xgrid','on','ygrid','on','xcolor',[1 1 1],...
        'ycolor',[1 1 1]);
frame=sprintf('%s',deblank(F(floor(g+1),:)));
t=title(frame,'FontSize',14,'HandleVisibility','on','Tag','ToDelete');

%======================================================================== 
otherwise
%========================================================================
warning('Unknown action string')

%=======================================================================
end;

   
