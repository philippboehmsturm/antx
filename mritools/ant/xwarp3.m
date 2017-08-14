
%% WARP IMAGES
function [success]=xwarp3(s)

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if 0%===== TESTS====================================================
    
    global an
    s=an.wa
    s.voxsize=an.voxsize
    s.task=[4]
    s.t2='O:\TOMsampleData\study4\dat\s20160623_RosaHDNestin_eml_29_1_x_x'
    s.autoreg=1
    
    [success]=xwarp3(s)
       
end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••



%% =========================================================
%% [0] PRELUDE (in all steps always "initialized")
% INPUT:
%% =========================================================
warning off;
process=upper(mfilename);
% struct to variables
if ~isfield(s,'task') || isempty(s.task); s.task=1:4 ;end  %  if  s.task is empty or not declared
% fn=fieldnames(pstruct);
% for j=1:length(fn); eval([fn{j} '=pstruct.' fn{j} ';' ]) ;end


%=========================================================

% [pant r]=   antpath;
success=    0;




% get fullpath-filename  "t2.nii"-file (from path)
[pa fi ext]=fileparts(s.t2);
if isempty(ext) %% only path was given-->link t2
    s.t2=     fullfile(s.t2,'t2.nii');
    s.pa=     fileparts(s.t2);
    if exist(s.t2,'file')~=2;             return                      ;    end
end
clear pa fi ext
% get ID
[~, ID]=fileparts(s.pa);

%% showinfo
infoc.a1=['process: '  ID  char(9)  datestr(now)];
infoc.a2=[ repmat('–',[1 length(infoc.a1)]) ];
showinfo(infoc.a2   ,1);
showinfo(infoc.a1   ,1);
showinfo(infoc.a2   ,1);
disp(['open folder <a href="matlab: explorer('' ' s.pa '  '')">' s.pa '</a>']);% show h<perlink

%templetpath
s.templatepath=fullfile(fileparts(fileparts(s.pa)),'templates');





try;  statusbar2(0,  process  ,'-SETUP', ID);  end



%% =================================================================================
%% [1] INITIALIZATION:
%% >> if 'defs.mat' does not exist in t2-folder  than  copy TPMS/volumes to the t2-folder
%% >>otherwise, set reorientMAT of TPMS to its original values (..from 'defs.mat', this is faster than recopy stuff)
% INPUT:
%% =================================================================================
if find(s.task==1)
    try;  statusbar2(1,  process ,'-INITIALIZATION', ID);  end
    showinfo(' ..  INITIALIZATION...wait (seconds-minutes)'  ,1 );
    
    %% copy templates to studyTemplatepath
    t=xcreatetemplatefiles2(s,0);
    
    
    
    
    if exist(fullfile(s.pa,'defs.mat'))==0  %% COPY TPMS if not exists
        
        %% COPY TEMPLATES FROM studyTemplatepath to current MOUSEPATH
        %(1)TPMS
        tpm00  =t.refTPM;
        tpm=replacefilepath(tpm00,s.pa);
        for i=1:length(tpm00)
            copyfile(tpm00{i},tpm{i},'f');
        end
        %(2) copy [_sample.nii]
        %% copyfile(  fullfile(templatepath, '_sample.nii')  ,           fullfile(pa, '_sample.nii')            ,'f' );
        %(3) copy [AVGT.nii] , [ANO.nii]
        copyfile( t.avg  ,           fullfile(s.pa, 'AVGT.nii')      ,'f' );
        copyfile( t.ano  ,           fullfile(s.pa, 'ANO.nii')      ,'f' );
        
        %(4)make copies of TPM [_refIMG.nii] & [_tpmgrey.nii],[_tpmwhite.nii],[_tpmcsf.nii]; used as ORIG TPMS
        copyfile(tpm{1},  fullfile(s.pa, '_refIMG.nii' )         ,'f' );
        copyfile(tpm{1},  fullfile(s.pa, '_tpmgrey.nii' )       ,'f' );
        copyfile(tpm{2},  fullfile(s.pa, '_tpmwhite.nii' )     ,'f' );
        copyfile(tpm{3},  fullfile(s.pa, '_tpmcsf.nii' )          ,'f' );
        refIMG=fullfile(s.pa,'_refIMG.nii');
        
        %
        %% SKULLSTRIP T2.nii
        if s.usePriorskullstrip==1
            disp('...do skullstripping (be patient)');
            skullstrip_pcnn3d(s.t2, fullfile(s.pa, '_msk.nii' ),  'skullstrip'   );
        end
        
        %% save orientation of TPMs, due to transformation...in next step we won't copy them from source
        for j=1:length(tpm)
            htemp=spm_vol(tpm{j});
            tpms(j,:)=    {  htemp.fname htemp.mat htemp.dim };
        end
        defs.tpms     =tpms;
        save(fullfile(s.pa, 'defs.mat' ),'defs'  );
    else
        refIMG      =fullfile(s.pa,'_refIMG.nii');
        load(fullfile(s.pa,'defs.mat'));
        tpm         =replacefilepath(defs.tpms(:,1),s.pa);   %tpm=defs.tpms(:,1);
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


if find(s.task==2)
    try;  statusbar2(1, process  ,'-COREGISTRATION', ID);  end
    showinfo(' ..  COREGISTRATION...wait (seconds)'  ,1 );

    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    %%     INPUT parameter
    load(fullfile(s.pa,'defs.mat'));
    tpm                         =replacefilepath(defs.tpms(:,1),s.pa);
    refIMG                      =fullfile(s.pa,'_refIMG.nii');
    parafile                    =which('trafoeuler.txt');
    coregFigname         =fullfile(s.pa,'coreg.jpg');
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    %set TPM to orig orientation
    tpm         =replacefilepath(defs.tpms(:,1),s.pa);   %tpm=defs.tpms(:,1);
    for j=1:length(tpm)
        spm_get_space(tpm{j}, defs.tpms{j,2}  );
    end
    
    
    %% STEP-1  : FIND ROTATION
    if s.autoreg==1
        spm fmri;
        [rot id trafo]=findrotation(refIMG ,s.t2 ,parafile, 1,1);
        preorient=trafo;
        Bvec=[ [preorient]  1 1 1 0 0 0];
        fsetorigin(tpm,   spm_imatrix(inv(spm_matrix(Bvec)))    );
        
        %% check and make screenshut
        pause(.5);drawnow;
        try
            displaykey3inv( tpm{1} ,s.t2,0,struct('parafile',parafile,'screencapture',coregFigname  ) );
            
            hgfeval(  get( findobj(findobj(gcf,'tag','Graphics'),'string','END'),'callback')  );     %make screenshut usong callback
        end
        
        
        % parafile=fullfile(pant,'paraaffine4rots.txt');
        %     [rot id trafo]=findrotation(r.refsample ,t2 ,parafile, 1,1);
        % preorient=[0 0 0 -pi/2 pi 0];%Freiburg
        % preorient=[0 0 0 pi/2 pi pi];%BErlin to ALLEN
        %     fsetorigin(tpm, Bvec);  %ANA
        
    elseif s.autoreg==0
        %     if isempty(findobj(0,'tag','Graphics'));
        %         spm fmri; %drawnow;drawnow;
        %     end
        %     displaykey2(r.refsample,t2,1);
        % spm fmri; drawnow;drawnow;
        %    figure(findobj(0,'tag','Graphics')); drawnow; pause(.5); drawnow
        % displaykey3inv(  refIMG ,t2,1); %shoenso [grayMAtter(=.._refIMG.nii), t2.nii]
        %displaykey3inv(  refIMG ,t2,0,  parafile ); %with option to autorotate
        
        displaykey3inv( refIMG ,s.t2,1,struct('parafile',parafile,'screencapture',coregFigname  ) );
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
    v1 =  spm_vol(fullfile(s.pa,'_refIMG.nii'));; %ORIG GM_in_ALLENSPACE !!
    v2=   spm_vol(tpm{1});%transformed GM in mouseSPace with ALLENorientMAT
    M =  v2.mat/v1.mat;
    save(fullfile(s.pa,'reorient.mat'),'M');
    
    %save older reorientMats
    load(fullfile(s.pa,'defs.mat'));
    if ~isfield(defs,'reorientmats'); defs.reorientmats={}; end
    defs.reorientmats=[defs.reorientmats;  {M  datestr(now)}];
    save(fullfile(s.pa, 'defs.mat' ),'defs'  );
    
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
if find(s.task==3)
    try;  statusbar2(1,  process ,'-SEGMENTATION', ID);  end
    showinfo(' ..  SPM-SEGMENTATION...wait (minutes)'  ,1 );
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    %%     INPUT parameter
    defstemp                =load(fullfile(s.pa,'defs.mat'));
    tpm                         =replacefilepath(defstemp.defs.tpms(:,1),s.pa);
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    template                = [tpm; fullfile(s.pa, 'reorient.mat')];
    if isempty(findobj(0,'tag','Graphics'));
        spm fmri;drawnow;
    end
    loadspmmouse;drawnow;
    %xsegment(t2,template,'segment'); %
    xsegment(s.t2,template); %
end %TASK: segment



%% =================================================================================
%%  [4]  NORMALIZATION using ELASTIX
% Input:  (pa), parafiles, M (reorientMAt)
%% =================================================================================

if find(s.task==4)
    try;  statusbar2(1,  process  ,'-NORMALIZATION (ELASTIX)', ID);  end
    showinfo(' ..  ELASTIX-ESTIMATE TRANSFORMATION...wait (minutes)'  ,1 );
    
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    %%  [4.1]  using MASKAPPRIOACH AND CALC PARAMERS
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    approach= s.elxMaskApproach;
    xprepelastix(s,approach);
    
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    %%  [4.2]  TRANSFORM specified VOLUMES
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    load(fullfile(s.pa,'reorient.mat'));
    
    %% BACKWARD
    if isfield(s,'tf_ano') && s.tf_ano==1
        file={fullfile(s.templatepath,'ANO.nii')} ; showinfo(['   ..transform: ' file{1}]);
        doelastix('transforminv'  , s.pa,    file ,0,M )
    end
    
    if  isfield(s,'tf_anopcol') && s.tf_anopcol==1
        file={fullfile(s.templatepath,'ANOpcol.nii')} ;showinfo(['   ..transform: ' file{1}]);
        doelastix('transforminv'  , s.pa,    file ,0,M )
    end
    
    if  isfield(s,'tf_avg') && s.tf_avg==1
         file={fullfile(s.templatepath,'AVGT.nii')} ; showinfo(['   ..transform: ' file{1}]);
        doelastix('transforminv'  , s.pa,    file ,3,M )
    end
    
    if  isfield(s,'tf_refc1') && s.tf_refc1==1
         file={fullfile(s.pa,'_refIMG.nii')} ; showinfo(['   ..transform: ' file{1}]);
        doelastix('transforminv'  , s.pa,    file,-1,M  )
    end
    
    
    %% FORWARD
    if isfield(s,'tf_t2') && s.tf_t2==1
         file={fullfile(s.pa,'t2.nii')} ; showinfo(['   ..transform: ' file{1}]);
        doelastix('transform'  , s.pa,   file  ,3,M )
    end
    if isfield(s,'tf_c1') && s.tf_c1==1
         file={fullfile(s.pa,'c1t2.nii')} ; showinfo(['   ..transform: ' file{1}]);
        doelastix('transform'  , s.pa,    file  ,3,M )
    end
    if isfield(s,'tf_c2') && s.tf_c2==1
         file={fullfile(s.pa,'c2t2.nii')} ; showinfo(['   ..transform: ' file{1}]);
        doelastix('transform'  , s.pa,   file  ,3,M )
    end
    if isfield(s,'tf_c3') && s.tf_c3==1
         file={fullfile(s.pa,'c3t2.nii')} ; showinfo(['   ..transform: ' file{1}]);
        doelastix('transform'  , s.pa,   file ,3,M )
    end
    if isfield(s,'tf_c1c2mask') && s.tf_c1c2mask==1
         file={fullfile(s.pa,'c1c2mask.nii')} ; showinfo(['   ..transform: ' file{1}]);
        doelastix('transform'  , s.pa,   file  ,3,M )
    end
    
    
    if 1
        xdeform2(fullfile(s.pa,'AVGT.nii'),-1, [nan nan nan],4 )
        xdeform2(fullfile(s.pa,'t2.nii'),        1, [nan nan nan],4 )
    end
    
    %———————————————————————————————————————————————
    %% jacobian
    %———————————————————————————————————————————————
    disp('  ..generate JACOBIAN');
    trafofile=fullfile(s.pa,'elastixForward\TransformParameters.1.txt');
    %         [im4,tr4] = run_transformix(  [] ,[],trafofile, s.pa ,'jac');
    [logs,im4,tr4]=evalc(['run_transformix(  [] ,[],trafofile, s.pa ,''jac'')']);
    movefile(tr4,fullfile(s.pa,'JD.nii'),'f');
    
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    %%  [4.2]  clean up
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    if s.cleanup==1
        
%         try; delete(fullfile(s.pa,'mt2.nii'));end
        try; delete(fullfile(s.pa,'_t2_findrotation2.nii'));end
        
        try; delete(fullfile(s.pa,'MSKmouse.nii'));end
        try; delete(fullfile(s.pa,'MSKtemplate.nii'));end
        try; delete(fullfile(s.pa,'_bestROT.nii'));end
        try; delete(fullfile(s.pa,'_bestROT.txt'));end
        try; delete(fullfile(s.pa,'brainmaskref.nii'));end
        % try; delete(fullfile(pa,'t2_seg_*.mat'));end
        
    end
    
end %TASK: normalize(Elastix)


try;  statusbar2(-1);  end



function showinfo(infox, bold )
%% SHOW INFO
if exist('bold')~=1
    bold=0;
end

if bold==1
    try
        cprintf('*blue',  [strrep(infox,filesep,[filesep filesep]) '\n']);
    catch
        try
            cprintf([0 0 1],  [strrep(infox,filesep,[filesep filesep]) '\n']);
        catch
            disp(infox);
        end
    end
else
    try
        cprintf([0 0 1],  [strrep(infox,filesep,[filesep filesep]) '\n']);
    catch
        disp(infox);
    end
end
    
    
    
    


