

function  t=xcreatetemplatefiles2(s,forcetooverwrite)

%% create templateFolder
patpl=s.templatepath;
if exist(patpl)~=7; mkdir(patpl); end



f1=s.avg;
f2       =fullfile(patpl,'AVGT.nii');
t.avg=f2;
if any([~exist(f2,'file')  forcetooverwrite])==1
    disp(['generate: ' f2]);
    [BB, vox]   = world_bb(f1);
    resize_img5(f1,f2, s.voxsize , BB, [], 1,[64 0]);
end
refimage=f2;

%% AVGTmask
makeMaskT3m(f2, fullfile(fileparts(f2),'AVGTmask.nii') , '>30');



f1=s.ano;
f2       =fullfile(patpl,'ANO.nii');
t.ano=f2;
if any([~exist(f2,'file')  forcetooverwrite])==1
    disp(['generate: ' f2]);
    rreslice2target(f1, refimage, f2, 0,[64 0]);
end

f1=s.fib;
f2       =fullfile(patpl,'FIBT.nii');
t.fib=f2;
if any([~exist(f2,'file')  forcetooverwrite])==1
    disp(['generate: ' f2]);
    rreslice2target(f1, refimage, f2, 0,[64 0]);
end

%% TPMS

f1=s.refTPM{1};
f2       =fullfile(patpl,'_b1grey.nii');
t.refTPM{1,1}=f2;
if any([~exist(f2,'file')  forcetooverwrite])==1
    disp(['generate: ' f2]);
    rreslice2target(f1, refimage, f2, 0,[2 0]);
end

f1=s.refTPM{2};
f2       =fullfile(patpl,'_b2white.nii');
t.refTPM{2,1}=f2;
if any([~exist(f2,'file')  forcetooverwrite])==1
    disp(['generate: ' f2]);
    rreslice2target(f1, refimage, f2, 0,[2 0]);
end

f1=s.refTPM{3};
f2       =fullfile(patpl,'_b3csf.nii');
t.refTPM{3,1}=f2;
if any([~exist(f2,'file')  forcetooverwrite])==1
    disp(['generate: ' f2]);
    rreslice2target(f1, refimage, f2, 0,[2 0]);
end

%% others
if s.create_gwc==1
    ano=fullfile(patpl,'ANO.nii');
    fib=fullfile(patpl,'FIBT.nii');
    f2=fullfile(patpl,'GWC.nii');
    t.gwc=f2;
    if any([~exist(f2,'file')  forcetooverwrite])==1
        disp(['generate: ' f2]);
        xcreateGWC( ano,fib,  f2 );
    end
end

if s.create_anopcol==1
    ano=fullfile(patpl,'ANO.nii');
    f2=fullfile(patpl,'ANOpcol.nii');
    t.anopcol=f2;
    if any([~exist(f2,'file')  forcetooverwrite])==1
        disp(['generate: ' f2]);
        [ha a]=rgetnii(ano);
        % pseudocolor conversion
        reg1=single(a);
        uni=unique(reg1(:));
        uni(find(uni==0))=[];
        reg2=reg1.*0;
        for l=1:length(uni)
            reg2=reg2+(reg1==uni(l)).*l;
        end
        rsavenii(f2,ha,reg2,[4 0]);
    end
end


