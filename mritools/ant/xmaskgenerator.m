%% MASK-GENRATOR (create masks based on anatomical regions)

function xmaskgenerator(showgui,x,pa)
% function snip_makelabelmask

%———————————————————————————————————————————————
%%   get database
%———————————————————————————————————————————————

xx = load('gematlabt_labels.mat');
[table idxLUT] = buildtable(xx.matlab_results{1}.msg{1});

global an
templatepath  =  fullfile(fileparts(an.datpath),'templates');
%studyTemplatePath given as input
avg0=fullfile(templatepath,'AVGT.nii');
ano0=fullfile(templatepath,'ANO.nii');
fib0=fullfile(templatepath,'FIBT.nii');
disp(' ......use MOUSE''s local templates');


avg = nifti(avg0);
avg = double(avg.dat);

anostruct = nifti(ano0);
ano       = double(anostruct.dat);

fib = nifti(fib0);
fib       = double(fib.dat);


AVGT=avg;
ANO=ano;
ANOstruct=anostruct;
FIBT =fib;


hano=spm_vol(ano0);

COL = buildColLabeling(ANO,idxLUT);
COL2 = buildColLabeling(FIBT,idxLUT);

[idvol idlabel] = makeIDvolume(ANO,idxLUT);


ANO2 = ANO; z.hemisphere = 'Both';
FIBT2 = FIBT;
ANO2(isnan(ANO))=0;
FIBT2(isnan(ANO))=0;

% compute region sizes for annotations
idxLUT = BrAt_ComputeAreaSize(idxLUT,ANO2,FIBT2);
luts.info = idxLUT; % create lookup table

actmap=ANO2;
actmap(actmap<=0 ) = nan;
% p1=getvalues(luts,ANO2,hano,actmap,z); %EXTRACT VALUES -ANO

%———————————————————————————————————————————————
%%
%———————————————————————————————————————————————

db=idxLUT;
% c=squeeze(struct2cell(db))';
% c(:,[1 2 5])

% p1=getmask(luts,ANO2,hano,actmap,z); %EXTRACT VALUES -ANO



[v]=prep4mask(luts,ANO,FIBT);
msk=getmask(luts,v,389);

% nam={db(1:size(db,2)).name}';
% col={db(1:size(db,2)).color_hex_triplet}';
% ah={'label'}
% selector2(nam,ah,'iswait',0,'color','000000','bgcolor',col,'selcolor','0000ff')
% li=[c(:,5)]
% selector2(li,{'TargetImage'})
% selector2({'<html><font color="red">bla</hmtl>'},{'TargetImage'})
% selector2({'<html><font color="#ff00FF">bla</hmtl>'},{'TargetImage'})


%% voxsize
vx={idxLUT(:).voxsz}';
vx( cellfun(@isempty, vx) ) = {0};
vx=cellfun(@(a){sprintf('%7d',a)} ,vx);

nam={};
stag=repmat('&clubs;',[1 5]);
for i=1:size(db,2)
    col=db(i).color_hex_triplet;
    nam{i,1}=['<font color="#' col  '">'  stag '<font color="000000">' ];
    %nam{i,1}=['<html><font bgcolor="#' col '", color="#' col  '">'  stag '<font color="000000"></hmtl>' ];
    % nam{i,1}=['<html><li style="color:#C00;"><span style="color:#39C;">Some text</span></li></hmtl>'];
end
nam2={db(1:size(db,2)).name}';
tb=[vx nam  nam2];
tbh={'Nvox' 'Color'  'Label'};
% db=db(1:985,:);

 clear global mxm
global mxm
clear xmx
mxm.luts=luts;
mxm.v   =v;
mxm.ano =ANO2;
mxm.avgt=AVGT;
mxm.col =COL;
mxm.col2 =COL2;
mxm.idbef=zeros(size(mxm.luts.info,2),1);

mxm.idvol  =idvol; 
mxm.idlabel=idlabel;

% id=selector2(tb,{'Nvox' 'Color'  'Label'},'selfun',{@showx},'iswait',1,'position',[0.0778  0.0772  0.3510  0.8644]);
% fun= {@selector2,tb,{'Nvox' 'Color'  'Label'},'selfun',{@showx},'iswait',1,'position',[0.0778  0.0772  0.3510  0.8644]}'
fun={@showlist,tb,tbh};

%———————————————————————————————————————————————
%%   GUI
%———————————————————————————————————————————————

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

if exist('showgui')~=1;    showgui=1; end
if exist('x')      ~=1;    x=[];      end
if isempty(x);             showgui=1; end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

p={...
    'inf1'      '*** MASK-GENERATOR                '         '' ''
    'inf2'      ['[' mfilename ']']                         '' ''
    'inf3'     '==================================='        '' ''
    'labelID'     ''      'SELECT ANATOMICAL LABELS HERE'     fun
    'hemisphere'   '(3) both united'    'HEMISPHERE: define mask & relation to hemisphere' {'(1) left','(2) right','(3) both united' '(4) both separated '}
    'merge'        1                    'MERGE VALUES: in case of several anatom. labels: (1) all labels get the same code (..BINARYMask/DualMask), (0) keep label-specific codes (MultiColorMask)'                       'b'
    'saveas'     'dummy.nii'            'DEFINE FILENAME to save the mask (default: file is stored in the "templates folder", but the name mus tbe specified)'                       'f'
    };
p=paramadd(p,x);%add/replace parameter
%% show GUI
if showgui==1
    [m z]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.5 .5 .4 .2 ],'title','MASK-GENERATOR');
else
    z=param2struct(p);
end

%———————————————————————————————————————————————
%%  run showx again
%———————————————————————————————————————————————
if isempty(z.labelID);
   error('NO ANATOMICAL LABELS SELECTED...PROCESS TERMINATED') ;
end
showx(z.labelID);




%———————————————————————————————————————————————
%%   get parameters
%———————————————————————————————————————————————
z.hemi=str2num(z.hemisphere(regexpi(z.hemisphere,'\d')));
[pax fix ext]=fileparts(z.saveas);
if isempty(pax); pax=fullfile(fileparts(an.datpath),'templates') ; end





msk = mxm.mask;
lab = mxm.masklabels;



%% mak labelinfo
lax=[ num2cell(1:length(z.labelID))'  lab num2cell(z.labelID(:))  ];
% 
% for i=1:size(lab,1)
%     
%     labx{i,1}=[ sprintf('%4d\t',i)   lab{i}  sprintf('\t%4d\t',z.labelID(i))  ]
% end


  
 img=   permute(rot90(msk,3),[1 3 2 ]);
 if z.merge==1
     img(img>0)=1;
     lax(:,1)={1};
     mergestr='m1';
 else
     mergestr='m0';
 end
if z.hemi==1;  
    img(round(size(img,1)/2)+1:size(img,1) , :,:)=  0;      
     hemistr='hL';
elseif z.hemi==2;  
    img(   1:  round(size(img,1)/2)  ,:           ,:)=  0;  
    hemistr='hR';
elseif z.hemi==3
    hemistr='hB';
elseif z.hemi==4;  %both-separated
    dum1  = img(   1:  round(size(img,1)/2)         ,: ,:);
    dum2  = img(round(size(img,1)/2)+1:size(img,1)  , :,:);
    mx=max(dum1(:));
    dum2(dum2==0)=nan;
    dum2=dum2+mx;
    dum2(isnan(dum2))=0;
    img=([dum1;dum2]);
    
    lax2=lax;
    lax2(:,1)=num2cell(cell2mat(lax2(:,1))+mx);
    lax=[lax;lax2];
    hemistr='hBS';
end

%% write this file
templatepath  =  fullfile(fileparts(an.datpath),'templates');
%studyTemplatePath given as input
hd=spm_vol(fullfile(templatepath,'AVGT.nii'));
fiout=fullfile(pax,[fix ['_' mergestr '_' hemistr ] '.nii']);
rsavenii(fiout,hd,img,[2 0]);

% eval(['!start ' fiout ' &'])
disp(['generated mask <a href="matlab: explorer('' ' fileparts(fiout) '  '')">' fiout '</a>'  ]);

%% write info;
fioutinfo=fullfile(pax,[fix  ['_' mergestr '_' hemistr ] '.txt']);
for i=1:size(lax,1)
    labx{i,1}=[ sprintf('%4d\t',lax{i,1})   lax{i,2}  sprintf('\t%4d\t',lax{i,3})  ];
end
pwrite2file2(fioutinfo,labx,[]);


makebatch(z);



%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%•••••••••••••••••••••••••••••••	subs        •••••••••••••••••••••••••••••••••••••••••••••••••••••
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

function makebatch(z)
try
    hlp=help(mfilename);
    hlp=hlp(1:min(strfind(hlp,char(10)))-1);
catch
    hlp='';
end
hh={};
hh{end+1,1}=('% ••••••••••••••••••••••••••••••••••••••••••••••••••••••');
hh{end+1,1}=[ '% BATCH:        [' [mfilename '.m' ] ']' ];
hh{end+1,1}=[ '% descr:' hlp];
hh{end+1,1}=('% ••••••••••••••••••••••••••••••••••••••••••••••••••••••');
hh=[hh; struct2list(z)];
hh(end+1,1)={[mfilename '(' '1',  ',z' ')' ]};
% uhelp(hh,1);
try
    v = evalin('base', 'anth');
catch
    v={};
    assignin('base','anth',v);
    v = evalin('base', 'anth');
end
v=[v; hh; {'                '}];
assignin('base','anth',v);
disp(['batch <a href="matlab:' 'uhelp(anth)' '">' 'show batch code' '</a>'  ]);



function id=showlist(tb, tbh)

id=selector2(tb,tbh,'selfun',{@showx},'iswait',1,'position',[0.0778  0.0772  0.3510  0.8644]);
% id=selector2(tb,{'Nvox' 'Color'  'Label'},'selfun',{@showx},'iswait',1,'position',[0.0778  0.0772  0.3510  0.8644]);
id=id(:)';
try; close(11); end


%———————————————————————————————————————————————
%%   show volume
%———————————————————————————————————————————————

function showx(id)
global mxm

if exist('id')~=1
    
    us=get(gcf,'userdata');
    id0=find(us.sel);
    id=str2num(char(us.raw(id0,1)));
    lab=us.raw(id0,4);
else
    lab=mxm.idlabel(id+1); %% THIS MUST BE INDEX+1 !!!
end

% return



% 
% if ~isfield(mxm,'idbef')
%     mxm.idbef=zeros(size(mxm.luts.info,2),1)
% end
% 
% ix=[mxm.idbef us.sel ];
% idf=ix(:,2)-ix(:,1)   ;
% is =find(idf~=0)   ; %only the currently changed ID
% 
% val=idf(is)        ; %what do do (delete/plot)
% 
% mxm.idbef(is)=mxm.idbef(is)+idf(is);
% mxm.idbef(find(mxm.idbef~=0));

newplot=1;
if newplot==1
    is=id;
    val=ones(length(is),1);
end

%% get MASK

% tic
% mk2=[];
% for i=1:length(is)
%     if sign(val(i))>0
%         
%         m0=getmask(mxm.luts,mxm.v,is(i));
%         m0(m0>0)=1;
%         msk=i.*m0;
%         
%         if i==1
%             mk2=msk.*sign(val(i)); %depending whether to remove or not
%         else
%             mk2=mk2+msk*sign(val(i));
%         end
%     end
% end
% % mk2=sign(mk2);
% toc
% 
% mkdel=[];
% for i=1:length(is)
%     if sign(val(i))<0
%         msk=getmask(mxm.luts,mxm.v,is(i));
%         if i==1
%             mkdel=msk.*sign(val(i)); %depending whether to remove or not
%         else
%             mkdel=mkdel+msk*sign(val(i));
%         end
%     end
% end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% get MASK
tic
v     =mxm.v;
mm    =v.msk; %fill
md    =v.msk; %delete
uni =[v.uni;v.uni2];
iv  =[v.iv ;v.iv2];
% uni =[v.uni];
% iv  =[v.iv ];
n = 1;
nm=-1;
for i=1:length(is)
    idx=is(i);
    %ivox=find(ismember(v.uni,          [v.lab{idx,1} ;v.lab{idx,2} ]));%allen ONLY
    ivox=find(ismember(uni, [v.lab{idx,1} ;v.lab{idx,2} ]));
    
%      [com a1 a2]=intersect(uni, [v.lab{idx,1} ;v.lab{idx,2} ]); %
%  vx=v.iv2(a1);
%     vz=cell2mat(vx); %get indices for label ( Nx2 array)
%     v.msk(vz)=1;    
    
    if sign(val(i))>0
        if ~isempty(ivox)
            vx=iv(ivox);
            k=cell2mat(vx);
            %k=iv{ ivox } ;
            mm(k ,1 )  =n;
            n=n+1;
        end
    else
        if ~isempty(ivox)
            vx=iv(ivox);
            k=cell2mat(vx);
            %k=iv{ ivox } ;
            md(k ,1 )  =nm;
            nm=nm-1;
        end
    end
end
% mk2=sign(mk2);
mk2   =reshape(mm,[v.si]);
mkdel =reshape(md,[v.si]);

toc
% fg,montage_p(mk2); colorbar
% fg,montage_p(mkdel); colorbar







%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% mkdel=sign(mkdel);
if isempty(mk2) ;      mk2=zeros(size(mxm.avgt));      end
if isempty(mkdel) ;    mkdel=zeros(size(mxm.avgt));      end


% si=size(H)
% h2=reshape(H,[prod(si(1:3)) 3]);
% c2=reshape(mxm.col,[prod(si(1:3)) 3]);
% m2=reshape(mk2,[prod(si(1:3)) 1]);

if ~isfield(mxm,'bg'); %backgroundvector
    G=mxm.avgt;
    C = colormap(gray);  % Get the figure's colormap.
    L = size(C,1);
    Gs = round(interp1(linspace(min(G(:)),max(G(:)),L),1:L,G));
    H = reshape(C(Gs,:),[size(Gs) 3]); % Make RGB image from scaled.
    
    
    
    si=size(mxm.avgt);
    
    h2=reshape(H,[prod(si(1:3)) 3]);
    c2=reshape(mxm.col,[prod(si(1:3)) 3]);
    
    
    mxm.h2=h2;  %hinterground gray-RGB
    mxm.c2=c2; %%colorlabel forground-RGB  orig gray-RGB vals -ALLlabels
    mxm.f2=h2; %%colorlabel forground-RGB  orig gray-RGB vals - zusammengestellte labels
    %     mxm.bg=m2; %%orig gray
    
    %% movingpoint
    si=size(mxm.avgt);
%     pp   =reshape(mxm.idvol,    [prod(si(1:3)) 1]);
%     
%     f3=reshape(pp,[si 3 ]);
    pp=rot90(permute(mxm.idvol,[1 3 2 4]));
    pp=pp(22:end-22+1 , 10:end-10 , 10:end-10,:); %cut vol
    pp = montageout(permute(pp,[1 2 4 3]));
    mxm.idvol2=single(pp);

end
si=size(mxm.avgt);
m2   =reshape(mk2,    [prod(si(1:3)) 1]);
m2del=reshape(mkdel,    [prod(si(1:3)) 1]);


%% get current fusion-vector
f2      = mxm.f2; 
if newplot==1
    f2      = mxm.h2;
end
%% remove labels
iv      =find(m2del<0);
f2(iv,:)=mxm.h2(iv,:);
%% add labels
iv      =find(m2>0);
f2(iv,:)=mxm.c2(iv,:);

%% make mask

mxm.mask      =rot90(permute(mk2,[1 3 2 4]));
mxm.masklabels=lab;
% figure(11)
% image(squeeze(h4(:,:,100,:)));

%% update mxm.f2
mxm.f2=f2;
f3=reshape(f2,[si 3 ]);
f4=rot90(permute(f3,[1 3 2 4]));
f4=f4(22:end-22+1 , 10:end-10 , 10:end-10,:);%cut this
f5=[];
f5(:,:,1) = montageout(permute(f4(:,:,:,1),[1 2 4 3]));
f5(:,:,2) = montageout(permute(f4(:,:,:,2),[1 2 4 3]));
f5(:,:,3) = montageout(permute(f4(:,:,:,3),[1 2 4 3]));
% fg,image(f5)

if isempty(findobj(0,'tag','maskimg'))
    figure(11);set(gcf,'tag','maskimg','color','k','units','norm','position',[ 0.4309    0.3994    0.3889    0.4667]);
    im=image(f5);
    set(im,'tag','mask');
    axis image
    set(gcf,'WindowButtonMotionFcn',@figmotion);
    set(gcf,'units','normalized'); set(gca,'position',[0 0 1 1]);
    set(gcf,'menubar','none');
    set(gcf,'toolbar','figure');
    axis off;

    %% courcour
cr=[...


  NaN    1       1   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   
   1     2       2     1   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   
   1     2       2     1   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   
   NaN   1       1   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN];

set(gcf,'Pointer','custom');
set(gcf,'PointerShapeCData',cr);

    
else
    im=findobj(0,'tag','mask');
    set(im,'cdata',single(f5));
end

% drawnow;
% length(find(mxm.mask(:)>0));
msg2=sprintf('# InMask-Voxel=%i ',(length(find(mxm.mask(:)>0))));
plotfig=findobj(0,'tag','maskimg');
set(plotfig,'name',[ '[' msg2   '] move mouse to label underlying region' ]);
set(plotfig,'name',[ '[' msg2   '] move mouse to label underlying region' ]);
% drawnow;


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

function figmotion(h,e)

try
    pos=get(gca,'CurrentPoint');
    pos=round(pos(1,1:2));
    pos=fliplr(pos);
    
    
    d= (get(findobj(gcf, 'type','image'),'cdata'));;
    % disp(pos);
    % disp(size(d));
    if (pos(1)>0 && pos(1)<=size(d,1)) &&  (pos(2)>0 && pos(2)<=size(d,2))
        global mxm
        %v=d(pos(1),pos(2)) ;
        %v=squeeze(d(pos(1),pos(2),:))'
        %msg=sprintf('  %10.5f',v);
        msg=['   '  mxm.idlabel{mxm.idvol2(pos(1),pos(2))}];
        msg2=sprintf('#VoxMsk=%i ',(length(find(mxm.mask(:)>0))));
        %     disp(sprintf('  %10.5f',v));
        
        mn=[pos(2) pos(1)];
        %     disp(mn)
        te=findobj(gcf,'tag','posmagn');
        if isempty(te)
            te=text(mn(1), mn(2),msg ,'tag','posmagn' ,'color','w');
            set(te,'fontsize',6,'color','w','fontname','courier','fontweight','bold',...
                'verticalalignment','center','horizontalalignment','left');
        else
            set(te,'position',[mn(1), mn(2) .1 ]);
        end
        set(te,'string',msg);
        set(gcf,'name',[ '[' msg2   ']' msg(3:end)]); drawnow
    end
end



function msk=getmask(luts,v, idx)
%% INTERSECTION UNIQUE LABEL IN ANO AND LUTS+ITS CHILDREN
[com a1 a2]=intersect(v.uni, [v.lab{idx,1} ;v.lab{idx,2} ]); %
vx=v.iv(a1);
vz=cell2mat(vx); %get indices for label ( Nx2 array)
v.msk(vz)=1;
msk=reshape(v.msk,[v.si]);
if 1 %use also FIB
    [com a1 a2]=intersect(v.uni2, [v.lab{idx,1} ;v.lab{idx,2} ]); %
    vx=v.iv2(a1);
    vz=cell2mat(vx); %get indices for label ( Nx2 array)
    v.msk(vz)=1;
    msk2=reshape(v.msk,[v.si]);
    msk=msk+msk2;
end


% v.msk(v.iv{find(ismember(v.uni, [v.lab{idx,1} ;v.lab{idx,2} ]))} )  =1
% msk=reshape(v.msk,[v.si]);




function [v]=prep4mask(luts,ANO,FIBT)
an=(ANO(:));
msk=zeros(size(an));
uni=unique(an);
uni(1)=[];
si=size(ANO);
iv={};
for i=1:length(uni)
    ix= find(an==uni(i));
    iv{i,1}=ix;
end

fi=(FIBT(:));
uni2=unique(fi);
uni2(1)=[];
iv2={};
for i=1:length(uni2)
    ix= find(fi==uni2(i));
    iv2{i,1}=ix;
end

% toc
%% get label and ots children from LUTS
lab=[{luts.info.id }' {luts.info.children}'];
v.lab = lab ;  %ALL-LABEL-IDX
v.msk = msk ; %used for later filling [zeroMtrx]
v.si  = si  ; %SIZE
% -ANO------------
v.uni = uni ;  %numeric labels
v.iv  = iv  ;  %indices in vol
%-FIBT------
v.uni2 =uni2  ;
v.iv2  =iv2  ;




% 
% function p=getvalues(luts,ANO,hano,actmap,z)
% 
% an=(ANO(:));
% ac=actmap(:);
% uni=unique(an);
% uni(1)=[];
% si=size(ANO);
% 
% %% get all vox-idx for all labels within ANO.nii
% iv={};
% for i=1:length(uni)
%     ix= find(an==uni(i));
%     iv{i,1}=ix;
% end
% % toc
% %% get label and ots children from LUTS
% lab=[{luts.info.id }' {luts.info.children}'];
% 
% 
% params={};
% for i=1:size(lab,1)
%     %% INTERSECTION UNIQUE LABEL IN ANO AND LUTS+ITS CHILDREN
%     [com a1 a2]=intersect(uni, [lab{i,1} ;lab{i,2} ]); %
%     vx=iv(a1);
%     vz=cell2mat(vx); %get indices for label ( Nx2 array)
%     vals=ac(vz); %get values of inputfile
%     
%     %% EXTRACT PARAMETERS (DEFINED IN Z-STRUCT)
%     s=stats(vals,z,hano);
%     params(:,i)=s(:,2);
% end
% p.paramname=s(:,1);
% p.params   =cell2mat(params);
% p.label    ={luts.info.name }';



function COL = buildColLabeling(ANO,idxLUT)
ANO(isnan(ANO)) = 0;
I = sparse([idxLUT.id]+1,ones(length(idxLUT),1),1:length(idxLUT));
for k = 1:length(idxLUT),
    col = sscanf(idxLUT(k).color_hex_triplet,'%x');
    cmap(k,1) = floor(col/256^2);
    cmap(k,2) = mod(floor(col/256),256);
    cmap(k,3) = mod(floor(col),256);
end;
cmap = [0 0 0 ; cmap]/255;
w = full(I(ANO+1));
COL = reshape(cmap(w+1,:),[size(ANO) 3]);


function [idvol idname] = makeIDvolume(ANO,idxLUT)
ANO(isnan(ANO)) = 0;
I = sparse([idxLUT.id]+1,ones(length(idxLUT),1),1:length(idxLUT));
for k = 1:length(idxLUT)
    col = sscanf(idxLUT(k).color_hex_triplet,'%x');
    cmap(k,1) = floor(col/256^2);
    cmap(k,2) = mod(floor(col/256),256);
    cmap(k,3) = mod(floor(col),256);
end;
cmap = [0 0 0 ; cmap]/255;
nmap=[1:size(idxLUT,2)]';
w = full(I(ANO+1));
% COL = reshape(cmap(w+1,:),[size(ANO) 3]);
idvol  = single(reshape(nmap(w+1,:),[size(ANO) 1]));
idname =[{'outside'}; {idxLUT.name}'];










