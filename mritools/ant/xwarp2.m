

function [success]=xwarp2(z,an)

% process=upper(mfilename);
% try;  statusbar2(0,  process  ,'-SETUP', 'sss');  end
% return
if 0%===== TESTS====================================================
    %      xwarp(struct('task',[2:4],'voxres',[.07 .07 .07],'t2',pwd,'autoreg',1))
    %      xwarp(struct('task',[1:4],'voxres',[.07 .07 .07],'t2',pwd,'autoreg',1))
    %      xwarp(struct('task',[1],'voxres',[.07 .07 .07],'t2',pwd,'autoreg',1))
    %     xwarp(struct('task',[1:4],'voxres',[.07 .07 .07],'t2',pwd,'autoreg',0))
    
    global an
    xwarp2(  struct('task',1,'t2', pwd, 'autoreg',1)   , an )
    
end

%% =========================================================
%% [0] PRELUDE (in all steps always "initialized")
% INPUT:
%% =========================================================

process=upper(mfilename);
% struct to variables
if ~isfield(z,'task') || isempty(z.task); z.task=1:4 ;end  %  if  pstruct.task is empty or not declared
fn=fieldnames(z);
for j=1:length(fn); eval([fn{j} '=z.' fn{j} ';' ]) ;end


%=========================================================

[pant r]=   antpath;
success=    0;

infocw=['process: '  strrep(z.t2,filesep,[filesep filesep])  '\t'  datestr(now) '\n'] ;
try;cprintf([0 0 1],([ repmat('–',[1 length(infocw)]) '\n']  ));end
try;cprintf([0 0 1],(infocw) );end
try;cprintf([0 0 1],([ repmat('–',[1 length(infocw)]) '\n']  ));end

% define t2-file (from path)
[pa fi ext]=fileparts(t2);
if isempty(ext) %% only path was given-->link t2
    t2=     fullfile(t2,'t2.nii');
    pa=     fileparts(t2);
    if exist(t2,'file')~=2;             return                      ;    end
end
% get ID
[~, ID]=fileparts(pa);



try;  statusbar2(0,  process  ,'-SETUP', ID);  end

%% =================================================================================
%% [1] INITIALIZATION:
%% >> if 'defs.mat' does not exist in t2-folder  than  copy TPMS/volumes to the t2-folder
%% >>otherwise, set reorientMAT of TPMS to its original values (..from 'defs.mat', this is faster than recopy stuff)
% INPUT:
%% =================================================================================
if find(task==1)
    try;  statusbar2(1,  process ,'-INITIALIZATION', ID);  end
    
    %% copy templates to studyTemplatepath
    %      if isdir(fullfile(fileparts(fileparts(pa)),'templates'))==0
    %            fa=xcopyfiles(r, pa,  voxres);
    %      else %folder exist but check files
    %          if length(dir(fullfile(fileparts(fileparts(pa)),'templates','*.nii')))<8
    %              fa=xcopyfiles(r, pa,  voxres);
    %          end
    %      end
    fa=xcreatetemplatefiles(an,0);
    
    
    
    
    
    
    if exist(fullfile(pa,'defs.mat'))==0  %% COPY TPMS if not exists
        
        %% COPY TEMPLATES FROM studyTemplatepath to current MOUSEPATH
        templatepath=fullfile(fileparts(fileparts(pa)),'templates');
        %(1)TPMS
        tpm00  ={...
            fullfile(templatepath, '_b1grey.nii')
            fullfile(templatepath, '_b2white.nii')
            fullfile(templatepath, '_b3csf.nii') };
        tpm=replacefilepath(tpm00,pa);
        for i=1:length(tpm00)
            copyfile(tpm00{i},tpm{i},'f');
        end
        %(2) copy [_sample.nii]
        %         copyfile(  fullfile(templatepath, '_sample.nii')  ,           fullfile(pa, '_sample.nii')            ,'f' );
        %         %(3) copy [AVGT.nii] , [ANO.nii]
                copyfile(  fullfile(templatepath, 'AVGT.nii')  ,           fullfile(pa, 'AVGT.nii')            ,'f' );
                copyfile(  fullfile(templatepath, 'ANO.nii')  ,           fullfile(pa, 'ANO.nii')            ,'f' );
        
        %(4)make copies of TPM [_refIMG.nii] & [_tpmgrey.nii],[_tpmwhite.nii],[_tpmcsf.nii]; used as ORIG TPMS
        copyfile(tpm{1},  fullfile(pa, '_refIMG.nii' )         ,'f' );
        copyfile(tpm{1},  fullfile(pa, '_tpmgrey.nii' )       ,'f' );
        copyfile(tpm{2},  fullfile(pa, '_tpmwhite.nii' )     ,'f' );
        copyfile(tpm{3},  fullfile(pa, '_tpmcsf.nii' )          ,'f' );
        refIMG=fullfile(pa,'_refIMG.nii');
        
        %
        %% SKULLSTRIP T2.nii
        disp('...do skullstripping (be patient)');
        skullstrip_pcnn3d(t2, fullfile(pa, '_msk.nii' ),  'skullstrip'   );
        
        %% save orientation of TPMs, due to transformation...in next step we won't copy them from source
        for j=1:length(tpm)
            htemp=spm_vol(tpm{j});
            tpms(j,:)=    {  htemp.fname htemp.mat htemp.dim };
        end
        defs.tpms     =tpms;
        save(fullfile(pa, 'defs.mat' ),'defs'  );
    else
        refIMG      =fullfile(pa,'_refIMG.nii');
        load(fullfile(pa,'defs.mat'));
        tpm         =replacefilepath(defs.tpms(:,1),pa);   %tpm=defs.tpms(:,1);
        for j=1:length(tpm)
            spm_get_space(tpm{j}, defs.tpms{j,2}  );
        end
    end
end %task


%% =================================================================================
%% [2] COREGISTRATION
% INPUTS:   tpm, t2(file), refIMG,parafile,   (roregfigcatpure)
%  reorient image                       ( FBtool [-pi/2 pi 0]   |    BERLIN [ PI/2 PI PI])
%% =================================================================================


if find(task==2)
    try;  statusbar2(1, process  ,'-COREGISTRATION', ID);  end
    
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    %%     INPUT parameter
    load(fullfile(pa,'defs.mat'));
    tpm                         =replacefilepath(defs.tpms(:,1),pa);
    refIMG                      =fullfile(pa,'_refIMG.nii');
    parafile                    =which('trafoeuler.txt');
    coregFigname         =fullfile(pa,'coreg.jpg');
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    %set TPM to orig orientation
    tpm         =replacefilepath(defs.tpms(:,1),pa);   %tpm=defs.tpms(:,1);
    for j=1:length(tpm)
        spm_get_space(tpm{j}, defs.tpms{j,2}  );
    end
    
    
    %% STEP-1  : FIND ROTATION
    if autoreg==1
        spm fmri;
        [rot id trafo]=findrotation(refIMG ,t2 ,parafile, 1,1);
        preorient=trafo;
        Bvec=[ [preorient]  1 1 1 0 0 0];
        fsetorigin(tpm,   spm_imatrix(inv(spm_matrix(Bvec)))    );
        
        %% check and make screenshut
        pause(.5);drawnow;
        try
            displaykey3inv( tpm{1} ,t2,0,struct('parafile',parafile,'screencapture',coregFigname  ) );
            
            hgfeval(  get( findobj(findobj(gcf,'tag','Graphics'),'string','END'),'callback')  );     %make screenshut usong callback
        end
        
        
        % parafile=fullfile(pant,'paraaffine4rots.txt');
        %     [rot id trafo]=findrotation(r.refsample ,t2 ,parafile, 1,1);
        % preorient=[0 0 0 -pi/2 pi 0];%Freiburg
        % preorient=[0 0 0 pi/2 pi pi];%BErlin to ALLEN
        %     fsetorigin(tpm, Bvec);  %ANA
        
    elseif autoreg==0
        %     if isempty(findobj(0,'tag','Graphics'));
        %         spm fmri; %drawnow;drawnow;
        %     end
        %     displaykey2(r.refsample,t2,1);
        % spm fmri; drawnow;drawnow;
        %    figure(findobj(0,'tag','Graphics')); drawnow; pause(.5); drawnow
        % displaykey3inv(  refIMG ,t2,1); %shoenso [grayMAtter(=.._refIMG.nii), t2.nii]
        %displaykey3inv(  refIMG ,t2,0,  parafile ); %with option to autorotate
        
        displaykey3inv( refIMG ,t2,1,struct('parafile',parafile,'screencapture',coregFigname  ) );
        %    return
        
        %% TESTER
        if 0
            refIMG=fullfile(pwd,'_refIMG.nii')
            t2=fullfile(pwd,'t2.nii')
            displaykey3inv(  refIMG ,t2,0,  struct('parafile', which('trafoeuler.txt') ) ); %with option to autorotate
        end
    end
    
    %  return
    
    
    %     0.0672   -6.5761    1.4926    1.5260    3.1178    3.1340---6---1.5708    3.1416    3.1416
    
    
    % %% STEP-2+3  :  autocoregister+COREG
    % predef=[ [[0 0 0   0 0 0 ]]  1 1 1 0 0 0];
    % reorient=autoregister(tpm{1} , t2 , predef);
    % %% reorient TPMS
    % for i=1:length(tpm)
    %     mfvol=spm_vol(tpm{i});
    %     spm_get_space(tpm{i}, reorient * mfvol.mat);
    % end
    
    
    %
    %
    %
    % %% STEP-2+3  :  autocoregister
    % predef=[ [[0 0 0   0 0 0 ]]  1 1 1 0 0 0];
    % [shift vec]=restimateOrigin4(tpm{1} , t2 ,[-7 7], [2 .5 .1 .05],predef);
    % st=fullfile(pa,'_test333SHIFT.nii');
    % copyfile(t2,st);
    %  trafo=[ [shift] [-pi/2 pi 0] 1 1 1 0 0 0]
    % fsetorigin({st}, vec);  %ANA
    
    
    
    %••••••••••••••  original •••••••••••••••••••••••••••••••••••••
    %     if 0
    %         %% retrieve & save orient MAT
    %         v1 =  spm_vol(refIMG);
    %         % v2 =  spm_vol('_test333FIN.nii');;
    %         v2=   spm_vol(tpm{1});%
    %         M =  v2.mat/v1.mat;
    %         % M=diag([1 1 1 1]);
    %         save(fullfile(pa,'reorient.mat'),'M');
    %     end
    %••••••••••••• test elastix only •••••••••••••••••••••••••••
    %% retrieve & save orient MAT
    % v1 =  spm_vol(fullfile(pa,'_test333SHIFT.nii'));
    v1 =  spm_vol(fullfile(pa,'_refIMG.nii'));; %ORIG GM_in_ALLENSPACE !!
    v2=   spm_vol(tpm{1});%transformed GM in mouseSPace with ALLENorientMAT
    M =  v2.mat/v1.mat;
    save(fullfile(pa,'reorient.mat'),'M');
    
    %save older reorientMats
    load(fullfile(pa,'defs.mat'));
    if ~isfield(defs,'reorientmats'); defs.reorientmats={}; end
    defs.reorientmats=[defs.reorientmats;  {M  datestr(now)}];
    save(fullfile(pa, 'defs.mat' ),'defs'  );
    
    %% CHECKS
    if 0
        % t2 from mouseSPACE to ALLENSPACE
        t2new=fullfile(pa,'_test_t2_inALLENSPACE.nii')
        copyfile(t2,t2new,'f');
        v=  spm_vol(t2new);
        spm_get_space(t2new,    inv(M) * v.mat);
        %GM from ALLENSAPCE to mouseSPACE
        w1=fullfile(pa,'_test_refIMG_inMOUSEPACE.nii')
        copyfile(fullfile(pa, '_refIMG.nii' ),w1,'f');
        v=  spm_vol(w1);
        spm_get_space(w1,     (M) * v.mat);
    end
    
end %TASK: coreg




%% =================================================================================
%% [3] SEGMENTATION
% Input:  (pa), tpm   (template)
%% =================================================================================
if find(task==3)
    try;  statusbar2(1,  process ,'-SEGMENTATION', ID);  end
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    %%     INPUT parameter
    defstemp                =load(fullfile(pa,'defs.mat'));
    tpm                         =replacefilepath(defstemp.defs.tpms(:,1),pa);
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    template                = [tpm; fullfile(pa, 'reorient.mat')];
    if isempty(findobj(0,'tag','Graphics'));
        spm fmri;drawnow;
    end
    loadspmmouse;drawnow;
    %xsegment(t2,template,'segment'); %
    xsegment(t2,template); %
end %TASK: segment



%% =================================================================================
%%  [4]  NORMALIZATION using ELASTIX
% Input:  (pa), parafiles, M (reorientMAt)
%% =================================================================================

if find(task==4)
    try;  statusbar2(1,  process  ,'-NORMALIZATION (ELASTIX)', ID);  end
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    %%     INPUT parameter
    parafiles                  = {...
        'V:\mritools\elastix\paramfiles\Par0025affine.txt'
        'V:\mritools\elastix\paramfiles\Par0033bspline_EM2.txt'};
    load(fullfile(pa,'reorient.mat'));
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    %%  [4.1]  make brainMASKS
    %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    
    %% make mousemask
    [ha  a]=rgetnii(fullfile(pa, 'c1t2.nii'));
    [hb b]=rgetnii(fullfile(pa, 'c2t2.nii'));
    [hd d]=rgetnii(fullfile(pa, 'c3t2.nii'));
    c=a.*10000+b*20000+d*40000;
    % c=a.*10000+b*20000;
    mouseMASK=fullfile(pa,'MSKmouse.nii');
    rsavenii(mouseMASK,ha,c,[16 0]);
    
    v=  spm_vol(mouseMASK);
    spm_get_space(mouseMASK,      inv(M) * v.mat);
    
    %% make templateMAKS
    [ha  a]=rgetnii(fullfile(pa, '_tpmgrey.nii'));
    [hb b]=rgetnii(fullfile(pa, '_tpmwhite.nii'));
    [hd d]=rgetnii(fullfile(pa, '_tpmcsf.nii'));
    % c=a.*10000+b*20000;
    c=a.*10000+b*20000+d*40000;
    tpmMASK=fullfile(pa,'MSKtemplate.nii');
    rsavenii(tpmMASK,ha,c,[16 0]);
    %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    %%  [4.2]    calculate ELASTIX-PARAMETER;
    %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    
    fixim      =     tpmMASK;            %fullfile(pa, 'tpmMASK.nii');
    movim  =     mouseMASK;        %fullfile(pa, 'mouseMASK.nii');
    if 0 %orig
        doelastix('calculate'  ,pa, {fixim movim} ,parafiles)   ;
    end
    
    if 0 %% TEST WITH MASK
        doelastix('calculate'  ,pa, {fixim movim} ,parafiles,{fixim movim})   ;
    end
    
    if 0
        fixim      =     fullfile(pa, 'avgtc3.nii');            %fullfile(pa, 'tpmMASK.nii');
        movim  =     fullfile(pa, 't2brainonly.nii');    ;
    end
    
    %% XWAR.M-VERSION
    if 1 %
        %% make mousemask
        brainmaskref =fullpath(pa,'brainmaskref.nii');
        makebrainmask3({fullfile(pa, 'c1t2.nii'); fullfile(pa, 'c2t2.nii')}, .1,brainmaskref);
        [ho  o]=rgetnii(brainmaskref);
        
        [ha  a]=rgetnii(fullfile(pa, 'c1t2.nii'));
        [hb b]=rgetnii(fullfile(pa, 'c2t2.nii'));
        [hd d]=rgetnii(fullfile(pa, 'c3t2.nii'));
        % c=a.*10000+b*20000;
        c=a.*10000+b*20000+d*40000;
        %   c=(10000*a.*double(a>.1))+(20000*b.*double(b>.1));
        %         c=(10000*a.*double(a>.1));
        %   c=(10000*b.*double(b>.1));
        
        % c=a.*10000+b*20000;
        % c=a.*10000;
        % c=b.*10000;
        c=c.*double(o>0);
        mouseMASK=fullfile(pa,'MSKmouse.nii');
        
        if exist(fullfile(pa,'masklesion.nii'))==2
            [he e ]=rreslice2target(fullfile(pa,'masklesion.nii'), fullfile(pa, 'c1t2.nii'), []);
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
        
        
        
        %% make templateMAKS
        [ha  a]=rgetnii(fullfile(pa, '_tpmgrey.nii'));
        [hb b]=rgetnii(fullfile(pa, '_tpmwhite.nii'));
        [hd d]=rgetnii(fullfile(pa, '_tpmcsf.nii'));
        % c=a.*10000+b*20000;
        c=a.*10000+b*20000+d*40000;
        %     c=(10000*a.*double(a>.1))+(20000*b.*double(b>.1));
        %   c=(10000*a.*double(a>.1));
        %   c=(10000*b.*double(b>.1));
        % c=a.*10000+b*20000;
        % c=a.*10000;
        % c=b.*10000;
        tpmMASK=fullfile(pa,'MSKtemplate.nii');
        rsavenii(tpmMASK,ha,c,[16 0]);
        
        
        fixim      =     tpmMASK;            %fullfile(pa, 'tpmMASK.nii');
        movim  =     mouseMASK;        %fullfile(pa, 'mouseMASK.nii');
        doelastix('calculate'  ,pa, {fixim movim} ,parafiles)   ;
        
        
        
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
    
    if 1  %TESTS ELASTIX
        %% TESTBACKWARD
        try;  doelastix('transforminv'  , pa,    {fullfile(pa,'AVGT.nii')}  ,3,M )  ;end
        %         doelastix('transforminv'  , pa,    {fullfile(pa,'_tpmgrey.nii')}  ,-1,M )
        try;    doelastix('transforminv'  , pa,    {fullfile(pa,'_sample.nii')},3,M   );end
        %doelastix('transforminv'  , pa,    {fullfile(pa,'ANO.nii')}  ,0,M )
        %% TEST FORWARD
        try;  doelastix('transform'  , pa,    {fullfile(pa,'t2.nii')}  ,3,M ); end
        % doelastix('transform'  , pa,    {fullfile(pa,'20150701_wr1_Anat_#i0.nii')}  ,0,M )
        %doelastix('transform'  , pa,    {fullfile(pa,'c1t2.nii')}  ,3,M )
    end
    if 1
        try;   xdeform2(fullfile(pa,'AVGT.nii'),-1, [nan nan nan],4 ); end
        try;   xdeform2(fullfile(pa,'t2.nii'),        1, [nan nan nan],4 );end
    end
    
    %% cleanUP
    if 0
        
        try; delete(fullfile(pa,'mt2.nii'));end
        try; delete(fullfile(pa,'_t2_findrotation2.nii'));end
        
        try; delete(fullfile(pa,'MSKmouse.nii'));end
        try; delete(fullfile(pa,'MSKtemplate.nii'));end
        % try; delete(fullfile(pa,'t2_seg_*.mat'));end
        
    end
    
end %TASK: normalize(Elastix)


try;  statusbar2(-1);  end



%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% old
% %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

if 0
    %
    %     addpath('C:\Users\skoch\Downloads\PCNN3D matlab\PCNN3D')
    %     t2='O:\harms1\koeln\dat\s20150701_BB1';
    %     voxres=[  0.0700    0.0700    0.0700];
    %     manualorient=1;
    %     [success]=xnormalizeElastix(t2, voxres, manualorient)
    %
    %     %% EXAMPLE-2
    %     cd('O:\harms1\koeln\dat\_leer')  ;%check if everything is put to t2-folder
    %     t2='O:\harms1\koeln\dat\s20150701_BB2';
    %     voxres=[  0.0700    0.0700    0.0700];
    %     manualorient=0;
    %     [success]=xnormalizeElastix(t2, voxres, manualorient)
    %
    %
    %        %% EXAMPLE-3
    %     cd('O:\harms1\koeln\dat\_leer')  ;%check if everything is put to t2-folder
    %     t2='O:\harms1\koeln\dat\s20202020_otherc3m15';
    %     voxres=[  0.0700    0.0700    0.0700];
    %     manualorient=1;
    %     [success]=xnormalizeElastix(t2, voxres, manualorient)
end