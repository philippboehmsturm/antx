


function xprepelastix(s,approach)
% 
% function xprepelastix(s,approach)
% s       :  extended s.wa-structure
% approach:  aproach-number  (defined in s.elxMaskApproach  )


% if 0
%     
%     approach=s.elxMaskApproach
%     xprepelastix(s,approach)
% end


%%     INPUT parameter
parafiles=s.elxParamfile;
load(fullfile(s.pa,'reorient.mat'));


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% APPROACH-0
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if approach==0
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    %%  [1]  make MOUSE-MASK
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    [ha  a]=rgetnii(fullfile(s.pa, 'c1t2.nii'));
    [hb b]=rgetnii(fullfile(s.pa, 'c2t2.nii'));
    [hd d]=rgetnii(fullfile(s.pa, 'c3t2.nii'));
    c=a.*10000+b*20000+d*40000;
    % c=a.*10000+b*20000;
    mouseMASK=fullfile(s.pa,'MSKmouse.nii');
    rsavenii(mouseMASK,ha,c,[16 0]);
    
    v=  spm_vol(mouseMASK); %reorient IMAGW
    spm_get_space(mouseMASK,      inv(M) * v.mat);
    
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    %%  [2]  make TEMPLATE-MASK
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    [ha  a]=rgetnii(fullfile(s.pa, '_tpmgrey.nii'));
    [hb b]=rgetnii(fullfile(s.pa, '_tpmwhite.nii'));
    [hd d]=rgetnii(fullfile(s.pa, '_tpmcsf.nii'));
    % c=a.*10000+b*20000;
    c=a.*10000+b*20000+d*40000;
    tpmMASK=fullfile(s.pa,'MSKtemplate.nii');
    rsavenii(tpmMASK,ha,c,[16 0]);
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    %%  [3]    calculate ELASTIX-PARAMETER;
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    fixim  =     tpmMASK;
    movim  =     mouseMASK;
    doelastix('calculate'  ,s.pa, {fixim movim} ,parafiles)   ;
    %doelastix('calculate'  ,s.pa, {fixim movim} ,parafiles,{fixim movim})   ;
    
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    %%  [4]    tests-transformation;
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    if 0
        doelastix('transforminv'  , s.pa,    {fullfile(s.pa,'AVGT.nii')}  ,3,M )
        doelastix('transform'     , s.pa,    {fullfile(s.pa,'t2.nii')}    ,3,M )
    end
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    %%  [5]    clean-up
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––  
    if s.cleanup==1
        try; delete(tpmMASK);end
        try; delete(mouseMASK);end
    end
end


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% APPROACH-1  -using Masklesion-filler
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if approach==1
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    %%  [1]  make MOUSE-MASK
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    brainmaskref =fullpath(s.pa,'brainmaskref.nii');
    makebrainmask3({fullfile(s.pa, 'c1t2.nii'); fullfile(s.pa, 'c2t2.nii')}, .1,brainmaskref);
    [ho  o]=rgetnii(brainmaskref);
    
    [ha  a]=rgetnii(fullfile(s.pa, 'c1t2.nii'));
    [hb b]=rgetnii(fullfile(s.pa, 'c2t2.nii'));
    [hd d]=rgetnii(fullfile(s.pa, 'c3t2.nii'));
    % c=a.*10000+b*20000;
    c=a.*10000+b*20000+d*40000;
    %   c=(10000*a.*double(a>.1))+(20000*b.*double(b>.1));
    %         c=(10000*a.*double(a>.1));
    %   c=(10000*b.*double(b>.1));
    
    % c=a.*10000+b*20000;
    % c=a.*10000;
    % c=b.*10000;
    c=c.*double(o>0);
    mouseMASK=fullfile(s.pa,'MSKmouse.nii');
    
    if exist(fullfile(s.pa,'masklesion.nii'))==2
        [he e ]=rreslice2target(fullfile(s.pa,'masklesion.nii'), fullfile(s.pa, 'c1t2.nii'), []);
        e(e<.5)=0; e(e>.5)=1;
        
        v1=c.*(e==1); v1(v1==0)=nan;
        v2=c.*(e==0); v2(v2==0)=nan;
        v22=v2(:);v22(isnan(v22))=[];
        v22=sort(v22);
        
        %     val=v22( round(length(v22)*0.001) );
        %     val=v22(1);
        val=2000;
        c(e==1)=c(e==1)./3;
    end
    
    rsavenii(mouseMASK,ha,c,[16 0]);
    v=  spm_vol(mouseMASK);
    spm_get_space(mouseMASK,      inv(M) * v.mat);
    
    
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    %%  [2]  make TEMPLATE-MASK
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    [ha  a]=rgetnii(fullfile(s.pa, '_tpmgrey.nii'));
    [hb b]=rgetnii(fullfile(s.pa, '_tpmwhite.nii'));
    [hd d]=rgetnii(fullfile(s.pa, '_tpmcsf.nii'));
    % c=a.*10000+b*20000;
    c=a.*10000+b*20000+d*40000;
    %     c=(10000*a.*double(a>.1))+(20000*b.*double(b>.1));
    %   c=(10000*a.*double(a>.1));
    %   c=(10000*b.*double(b>.1));
    % c=a.*10000+b*20000;
    % c=a.*10000;
    % c=b.*10000;
    tpmMASK=fullfile(s.pa,'MSKtemplate.nii');
    rsavenii(tpmMASK,ha,c,[16 0]);
    
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    %%  [3]    calculate ELASTIX-PARAMETER;
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    fixim  =     tpmMASK;
    movim  =     mouseMASK;
    doelastix('calculate'  ,s.pa, {fixim movim} ,parafiles)   ;
    
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    %%  [4]    tests-transformation;
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    if 0
        doelastix('transforminv'  , s.pa,    {fullfile(s.pa,'AVGT.nii')}  ,3,M )
        doelastix('transform'     , s.pa,    {fullfile(s.pa,'t2.nii')}    ,3,M )
    end
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    %%  [5]    clean-up
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    if s.cleanup==1
        try; delete(tpmMASK);end
        try; delete(mouseMASK);end
        try; delete(brainmaskref);end
    end
end

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% APPROACH-2  using graymatter-mask -->           suboptimal approach !!!
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if approach==2
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    %%  [1]  make MOUSE-MASK
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    brainmaskref =fullpath(s.pa,'brainmaskref.nii');
    makebrainmask3({fullfile(s.pa, 'c1t2.nii'); fullfile(s.pa, 'c2t2.nii')}, .1,brainmaskref);
    [ho  o]=rgetnii(brainmaskref);
    
    [ha  a]=rgetnii(fullfile(s.pa, 'c1t2.nii'));
    [hb b]=rgetnii(fullfile(s.pa, 'c2t2.nii'));
    [hd d]=rgetnii(fullfile(s.pa, 'c3t2.nii'));
    % c=a.*10000+b*20000;
    thresh=.6;
    a(a<thresh)=0;
    b(b<thresh)=0;
    d(d<thresh)=0;
    
%     c=a.*10000+b*20000+d*40000;
    %   c=(10000*a.*double(a>.1))+(20000*b.*double(b>.1));
    %         c=(10000*a.*double(a>.1));
    %   c=(10000*b.*double(b>.1));
    
    % c=a.*10000+b*20000;
    % c=a.*10000;
    % c=b.*10000;
%     c=c.*double(o>0);
     c=a;
    mouseMASK=fullfile(s.pa,'MSKmouse.nii');
    
    if exist(fullfile(s.pa,'masklesion.nii'))==2
        [he e ]=rreslice2target(fullfile(s.pa,'masklesion.nii'), fullfile(s.pa, 'c1t2.nii'), []);
        e(e<.5)=0; e(e>.5)=1;
        
        v1=c.*(e==1); v1(v1==0)=nan;
        v2=c.*(e==0); v2(v2==0)=nan;
        v22=v2(:);v22(isnan(v22))=[];
        v22=sort(v22);
        
        %     val=v22( round(length(v22)*0.001) );
        %     val=v22(1);
        val=2000;
        c(e==1)=c(e==1)./3;
    end
    
    rsavenii(mouseMASK,ha,c,[16 0]);
    v=  spm_vol(mouseMASK);
    spm_get_space(mouseMASK,      inv(M) * v.mat);
    
    
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    %%  [2]  make TEMPLATE-MASK
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    [ha  a]=rgetnii(fullfile(s.pa, '_tpmgrey.nii'));
    [hb b]=rgetnii(fullfile(s.pa, '_tpmwhite.nii'));
    [hd d]=rgetnii(fullfile(s.pa, '_tpmcsf.nii'));
    
     a(a<thresh)=0;
    % c=a.*10000+b*20000;
    c=a.*10000+b*20000+d*40000;
    %     c=(10000*a.*double(a>.1))+(20000*b.*double(b>.1));
    %   c=(10000*a.*double(a>.1));
    %   c=(10000*b.*double(b>.1));
    % c=a.*10000+b*20000;
    % c=a.*10000;
    % c=b.*10000;
    c=a;
    tpmMASK=fullfile(s.pa,'MSKtemplate.nii');
    rsavenii(tpmMASK,ha,c,[16 0]);
    
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    %%  [3]    calculate ELASTIX-PARAMETER;
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    fixim  =     tpmMASK;
    movim  =     mouseMASK;
    doelastix('calculate'  ,s.pa, {fixim movim} ,parafiles)   ;
    
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    %%  [4]    tests-transformation;
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    if 0
        doelastix('transforminv'  , s.pa,    {fullfile(s.pa,'AVGT.nii')}  ,3,M )
        doelastix('transform'     , s.pa,    {fullfile(s.pa,'t2.nii')}    ,3,M )
    end
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    %%  [5]    clean-up
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    if s.cleanup==1
        try; delete(tpmMASK);end
        try; delete(mouseMASK);end
        try; delete(brainmaskref);end
    end
end













if 0 %% TEST WITH MASK
    
    %% FIXIMG
    fix0=fullfile(pa,'AVGT.nii')
    fixim=fullfile(pa,'allen.nii')
    copyfile(fix0,fixim,'f')
    % REF
    tpmref         ={ '_tpmgrey.nii' '_tpmwhite.nii' };% REF
    tpmref           =fullpath(pa,tpmref);
    brainmaskref =fullpath(pa,'brainmaskref.nii');
    makebrainmask3(tpmref, .1,brainmaskref);
    [ha a]=rgetnii(brainmaskref);
    [hb b]=rgetnii(fixim);
    c=b.*(a>0);
    rsavenii(fixim, hb,c);
    %% MOVIMG
    
    mov0=fullfile(pa,'t2.nii');
    movim=fullfile(pa,'mouse.nii');
    copyfile(mov0,movim,'f');
    
    [ha a]=rgetnii(fullfile(pa,'_test1.nii'));
    [hb b]=rgetnii(movim);
    c=b;%.*(a>0);
    [hd d ]=rreslice2target(fullfile(pa,'masklesion.nii'), movim, []);
    
    val=c(d>0);
    valx=median(val).*.7;
    e=c;
    e(d>0)=valx;
    rsavenii(movim, hb,e);
    
    v=  spm_vol(movim);
    spm_get_space(movim,    inv(M) * v.mat);
    
    doelastix('calculate'  ,pa, {fixim movim} ,parafiles,{[] []})   ;
end


return
if 0
    
    %% make masks
    path=pa;
    tpm           ={ 'c1t2.nii' 'c2t2.nii' };
    tpm           =fullpath(path,tpm);
    brainmask=fullpath(path,'brainmask.nii');
    lesionmask=fullpath(path,'masklesion.nii');
    
    makebrainmask3(tpm, .1,brainmask);
    % makebrainmask3({ 'c1T2.nii' 'c2T2.nii' }, .1, 'brainmask.nii')
    [ h a]=rgetnii(brainmask);
    % [ hm b]=rgetnii(lesionmask);
    [hm b ]=rreslice2target(lesionmask, brainmask, []);
    a2=a;
    a2(b==1)=0;
    brainNoLesionMask=fullpath(path,'brainNoLesionMask.nii'); %% MASK USED
    rsavenii(brainNoLesionMask,h,a2 );
    v=  spm_vol(brainNoLesionMask);
    spm_get_space(brainNoLesionMask,    inv(M) * v.mat);
    
    
    % REF
    tpmref         ={ '_tpmgrey.nii' '_tpmwhite.nii' };% REF
    tpmref           =fullpath(path,tpmref);
    brainmaskref =fullpath(path,'brainmaskref.nii');
    makebrainmask3(tpmref, .1,brainmaskref);
    
    ff=@(a,b)fullfile(a,b);
    pa            =path;
    fixim     =ff(pa, 'AVGT.nii');
    
    
    movim =ff(pa, 'mouseMask.nii');
    copyfile(ff(pa, 't2.nii'),  movim,'f');
    v=  spm_vol(movim);
    spm_get_space(movim,    inv(M) * v.mat);
    
    fix_mask      =brainmaskref ;%% ff(pa, 'c1c2mask.2.nii')
    mov_mask = brainNoLesionMask ;%ff(pa, 'brainNoLesionMask.nii')  %mov_mask =ff(pa, 'brainNoLesionMask3.nii')
    
    disp(fixim);
    disp(movim);
    disp(fix_mask);
    disp(mov_mask);
    %         doelastix('calculate'  ,pa, {fixim movim} ,parafiles,{[],[]})   ;
    doelastix('calculate'  ,pa, {fixim movim} ,parafiles,{fix_mask,mov_mask})   ;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %    disp('use approach-2 (warp with masklesion)');
    % %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    % %% approach 2 using lesionMask
    % %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    % path=pa;%% make masks
    % tpm           ={ 'c1t2.nii' 'c2t2.nii' };
    % tpm           =fullpath(path,tpm);
    % brainmask=fullpath(path,'brainmask.nii');
    % lesionmask=fullpath(path,'masklesion.nii');
    %
    % makebrainmask3(tpm, .1,brainmask);
    % [ h a]=rgetnii(brainmask);
    % [ hm b]=rgetnii(lesionmask);
    % a2=a;
    % a2(b==1)=0;
    % brainNoLesionMask=fullpath(path,'brainNoLesionMask.nii'); %% MASK USED
    % rsavenii(brainNoLesionMask,h,a2 );
    %
    % tpmref           ={ '_tpmgrey.nii' '_tpmwhite.nii' };% REF
    % tpmref           =fullpath(path,tpmref);
    % brainmaskref =fullpath(path,'brainmaskref.nii');
    % makebrainmask3(tpmref, .1,brainmaskref);
    %
    % %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    % [ ha a]=rgetnii(brainmaskref);
    % [ hb b]=rgetnii(fullfile(path, 'AVGT.nii'));
    % b2=double(b).*double(a);
    % rsavenii(brainmaskref,hb,b2 );
    %
    % [ ha a]=rgetnii(brainmask);
    % [ hb b]=rgetnii(fullfile(path, 't2.nii'));
    % b2=double(b).*double(a);
    % rsavenii(brainmask,hb,b2 );
    %
    % %--------------------------
    % ff=@(a,b)fullfile(a,b);
    %  z.fiximg       =brainmaskref   ;%ff(path, 'AVGT.nii');
    %  z.movimg  =brainmask    ;   %fullfile(path,'t2.nii') ;  %%ff(pa, 'T2.nii')
    % %  z.fix_mask     =brainmaskref ;%% ff(pa, 'c1c2mask.2.nii')
    % %  z.mov_mask = brainNoLesionMask ;%ff(pa, 'brainNoLesionMask.nii')  %mov_mask =ff(pa, 'brainNoLesionMask3.nii')
    %
    % %   z.fiximg     ='O:\harms1\harms2\dat\_s20150908_FK_C1M01_1_3_1\AVGT.nii'
    % %   z.movimg  ='O:\harms1\harms2\dat\_s20150908_FK_C1M01_1_3_1\t2.nii'
    % %   %    z.outforw  =
    % %   z.fix_mask  ='O:\harms1\harms2\dat\_s20150908_FK_C1M01_1_3_1\brainmaskref.nii'
    % %   z.mov_mask='O:\harms1\harms2\dat\_s20150908_FK_C1M01_1_3_1\brainNoLesionMask.nii'
    % %
    % fiximg=brainmaskref
    % movimg=brainmask
    % fixmsk=[];
    % movmsk=[];
    %  doelastix('calculate'  ,pa, {fiximg movimg} ,parafiles,{fixmsk movmsk})   ;
    % %    [im,trfile] = run_elastix(z.fiximg,z.movimg,    z.outforw  ,parafiles,   z.fix_mask,z.mov_mask     ,[],[],[]);
    %    %     [im,trfile] = run_elastix(z.fiximg,z.movimg,    z.outforw  ,parafiles,   [],[]       ,[],[],[]);
end





% 99.5098 ;
if 0
    
    %         %% make mousemask
    %         [ha  a]=rgetnii(fullfile(pa, 'c1t2.nii'));
    %         [hb b]=rgetnii(fullfile(pa, 'c2t2.nii'));
    %         [hd d]=rgetnii(fullfile(pa, 'c3t2.nii'));
    %         % c=a.*10000+b*20000+d*40000;
    % %         c=a.*10000+b*20000;
    %         c=(10000*a.*double(a>.1))+(20000*b.*double(b>.1));
    %         mouseMASK=fullfile(pa,'MSKmouse.nii');
    %         rsavenii(mouseMASK,ha,c,[16 0]);
    %
    %         v=  spm_vol(mouseMASK);
    %         spm_get_space(mouseMASK,      inv(M) * v.mat);
    %
    %         %% make templateMAKS
    %         [ha  a]=rgetnii(fullfile(pa, '_tpmgrey.nii'));
    %         [hb b]=rgetnii(fullfile(pa, '_tpmwhite.nii'));
    %         [hd d]=rgetnii(fullfile(pa, '_tpmcsf.nii'));
    %         %c=a.*10000+b*20000+d*40000;
    % %         c=a.*10000+b*20000;
    %          %c=10000*b.*double(b>.1);
    %           c=(10000*a.*double(a>.1))+(20000*b.*double(b>.1));
    %         tpmMASK=fullfile(pa,'MSKtemplate.nii');
    %         rsavenii(tpmMASK,ha,c,[16 0]);
    
    
    %         [ha  a]=rgetnii(mouseMASK);
    %         [hx  x]=rgetnii(tpmMASK);
    %
    %         [hb  b]=rgetnii(fullfile(pa,'_test1.nii'));
    %         bm=double(b~=0);
    %         c=a.*bm;
    %         rsavenii(mouseMASK,ha,c);
    %         doelastix('calculate'  ,pa, {tpmMASK mouseMASK} ,parafiles)   ;
    %         mouseMASK=fullfile(pa,'MSKmouse.nii');
    %
    %
    [hd  d]=rgetnii(fullfile(pa,'t2.nii'));
    [hb  b]=rgetnii(fullfile(pa,'_test1.nii'));
    c=d;
    c=c-min(c(:));
    c=(c./max(c(:))).*10000;
    c=c.*double(b~=0);
    %         c=round(c);
    rsavenii(mouseMASK,hd,c,[16 0]);
    
    v=  spm_vol(mouseMASK);
    spm_get_space(mouseMASK,      inv(M) * v.mat);
    
    %______________________________________
    %           [hb  b]=rgetnii(fullfile(pa,'_test1.nii'));
    %           movM=fullfile(pa, 'mask2Mouse.nii')
    %           c2=double(b~=0);
    %           rsavenii(movM,hd,c2,[2 0]);
    %
    %
    %           v=  spm_vol(movM);
    %           spm_get_space(movM,      inv(M) * v.mat);
    %          %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    %
    %
    %         [hd  ]=rgetnii(fullfile(pa, '_tpmgrey.nii'));
    [ha a]=rgetnii(fullfile(pa, 'AVGT.nii'));
    [hb  b]=rgetnii(fullfile(pa,'_testref1.nii'));
    %        [hb b]=rgetnii(fullfile(pa, 'MSKtemplate.nii'));
    %        c=a.*(b>.10000);
    c=a.*(a>40);
    c=c-min(c(:));
    c=(c./max(c(:))).*10000;
    c=c.*double(b~=0);
    %         c=round(c);
    %c=abs(c-max(c(:))); c(c==max(c(:)))=0; %invert
    
    rsavenii(tpmMASK,ha,c,[16 0]);
    
    %______________________________________
    %        fixim2=fullfile(pa,'_testref1.nii')
    %        makebrainmask3({fullfile(pa,'_tpmgrey.nii') ;fullfile(pa,'_tpmwhite.nii')  }, .1,fixim2);
    %          [ha a]=rgetnii(fixim2);
    %          rsavenii(fixim2,ha,a,[2 0]);
    %
    %           fixM=fullfile(pa, 'mask2ref.nii')
    %         c2=double(c~=0);
    %          rsavenii(fixM,ha,c2,[16 0]);
    
    %         [hb a]=rgetnii(fullfile(pa, '_test1.nii'));
    %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    disp('files •••••••••••••••••••••••••••••');
    fixim=fullfile(pa,'MSKtemplate.nii')
    movim=fullfile(pa,'MSKmouse.nii')
    %        fixM=fixim2
    %        movM=movM
    doelastix('calculate'  ,pa, {fixim movim} ,parafiles)   ;
    %         doelastix('calculate'  ,pa, {fixim movim} ,parafiles,{fixM movM})   ;
    
    
end


if 0
    mouseMASK=fullfile(pa,'MSKmouse.nii');
    [ha  a]=rgetnii(mouseMASK);
    [hb  b]=rgetnii(fullfile(pa,'_test1.nii'));
    %          c=a.*(b~=0);
    c=b.*(b>0);
    
    c=c-min(c(:));
    c=(c./max(c(:))).*10000;
    c=abs(c-max(c(:))); c(c==max(c(:)))=0; %invert
    rsavenii(mouseMASK,ha,c,[16 0]);
    
    
    
    
    [hd  ]=rgetnii(fullfile(pa, '_tpmgrey.nii'));
    [ha a]=rgetnii(fullfile(pa, 'AVGT.nii'));
    %        [hb b]=rgetnii(fullfile(pa, 'MSKtemplate.nii'));
    %        c=a.*(b>.10000);
    c=a.*(a>70);
    c=c-min(c(:));
    c=(c./max(c(:))).*10000;
    c=abs(c-max(c(:))); c(c==max(c(:)))=0; %invert
    
    rsavenii(tpmMASK,hd,c,[16 0]);
    %
    %         [hb a]=rgetnii(fullfile(pa, '_test1.nii'));
    
    fixim=fullfile(pa,'MSKtemplate.nii')
    movim=fullfile(pa,'MSKmouse.nii')
    doelastix('calculate'  ,pa, {fixim movim} ,parafiles)   ;
    
end