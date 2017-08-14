
%% doelastix  (INPUTS SEE BELOW)
%% [1] Calculation (forward and backward calculation is done in one process)-->run only once!!
% doelastix(task,     path, images ,parafiles )
% task : 'calculate'
% path:    local mousepath
% parafiles:  cell of elastix-parameterfiles (txt-files)
% images: cell with 2 inputs: fixed Image  & moving IMage, i.e.    { "fullpathOf AVGT.nii"   "fullpathOf t2.nii"}
%% [2] Transformation Forward (>>to ALLENspace)
%doelastix(task,       path  ,files, interp, M  )
% task:  'transform'   or  1  (just 1 !)
% path:    local mousepath          or   empty  []
% files:     cell of all files to be transformed (fullpathlist),  files can be from different directories, but then set M='local'
% interp: interpolationMethod:   -1  used for 0-1-range images such as TPMs (GM,WM,CSF)  , (due to elastix-bug ??)
%                                                      0 used for binary images or images not to interpolate such as anatom-label-volumes
%                                                      1,2,3 spline interpolation   (use 3 or 4) for "fullrange"
%                         -if there are more tranformation files, the same interpolation method is applied
%                           alternatively you could specifiy an interpolation vector of length of files (example: 2 files   --> interp=[3 -1] --> 1st. file spline interpolated, 2nd file int the 0-1range)
% M         : transformationMatrix        -[] do not use/apply transformation matrix (reorient.mat)
%                                                           -4x4 orientationMatrix, -->this will be used/applied for all inputfiles>>thus inputfiles should derive from the same directory
%                                                           -'local' (string)  : for each file use the locally stored reorientationMatrix (it is assumed that the "reorient.mat" file
%                                                              is located in the file(i)'s directory   )
%% [3] Transformation Backward (>>to MOUSESspace)
% same as Forward transformation but the task is 'transforminv' instead 'transform'
% task:  'transforminv'   or  -1  (just -1 !)
%% EXAMPLES
%% EXAMPLE FILES;
%     f1=fullfile(pwd,'sAVGT.nii')
%     f2=fullfile(pwd,'_b1grey.nii')
%     f3=fullfile(pwd,'t2.nii')
%     f4=fullfile(pwd,'c1t2.nii')
%     f5=fullfile(pwd,'c1c2mask.nii')
%     path=pwd
%% CALCULATION
%     fixim=fullfile(pwd, 'templateGMWM.nii'); %FIEX IMAGE
%     movim=fullfile(pwd, 'mouseGMWM.nii'); %MOVINF IMAGE
%     parafiles={'V:\mritools\elastix\paramfiles\Par0025affine.txt'
%         'V:\mritools\elastix\paramfiles\Par0033bspline_EM2.txt'}  %ELASTIX PARAMETERFILES
%     doelastix('calculate'  ,path, {fixim movim} ,parafiles)   ;
%% BACKWARD TRAFO
%     doelastix('transforminv'  , path,    {f1 f2} ,[3 -1]  )   ;%TPM with interp=-1' !!! (elastix:0-1 range not defined)
%     doelastix('transforminv'  , path,    {f1 f2}   )    ;%if not specified interp=3
%     doelastix('transforminv'  , path,    {f1 f2} ,[3]  )
%% FORWARD TRAFO
%     doelastix('transform'  , path,    {f3 f4} ,[3 -1]  )   ;%TPM with interp=-1' !!! (elastix:0-1 range not defined)
%     doelastix('transform'  , path,    { f4} ,[ -1]  )   ;%TPM with interp=-1'
%     doelastix('transform'  , path,    { f5} ,[ 0]  )   ; %BINARYMASK with interp=0'
%% use TRANSFORMATION matrix(4x4) (Variable | stored as reorient.mat)
%     (1)  use reorient matrix M(4x4) from workspace
%     doelastix('transforminv'  , path,    {fullfile(path,'sAVGT.nii')} ,[] ,M )
%    (2)  forward, useLocalPath,  files2trafo from different Mousefolders , interp, use Locally stored ReorientMat
%      doelastix(1    , [],      files                          ,3 ,      'local' );








%  doelastix('calculate',     path, fixmovIMG,  )
%doelastix('transform'       path  ,files,interp  )
%doelastix('transforminv'  path,  files,interp   )
% doelastix('transforminv'  , pa,    {fullfile(pa,'_sample.nii')},3,M   ) %where M is the reorientMAT(4x4)
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

function doelastix( task, arg1,arg2,arg3,  arg4)

warning off;

%% direction also assigned using 1/-1
if   isnumeric(task);
    if task==1          ;   task='transform';
    elseif  task==-1  ;  task='transforminv';
    end
end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if 0
    f1=fullfile(pwd,'sAVGT.nii')
    f2=fullfile(pwd,'_b1grey.nii')
    f3=fullfile(pwd,'t2.nii')
    f4=fullfile(pwd,'c1t2.nii')
    f5=fullfile(pwd,'c1c2mask.nii')
    path=pwd
    
    %calculate
    fixim=fullfile(pwd, 'templateGMWM.nii')
    movim=fullfile(pwd, 'mouseGMWM.nii')
    parafiles={'V:\mritools\elastix\paramfiles\Par0025affine.txt'
        'V:\mritools\elastix\paramfiles\Par0033bspline_EM2.txt'}
    doelastix('calculate'  ,path, {fixim movim} ,parafiles)   ;
    
    
    % BACKWARD
    doelastix('transforminv'  , path,    {f1 f2} ,[3 -1]  )   ;%TPM with interp=-1' !!! (elastix:0-1 range not defined)
    doelastix('transforminv'  , path,    {f1 f2}   )    ;%if not specified interp=3
    doelastix('transforminv'  , path,    {f1 f2} ,[3]  )
    
    %FORWARD
    doelastix('transform'  , path,    {f3 f4} ,[3 -1]  )   ;%TPM with interp=-1' !!! (elastix:0-1 range not defined)
    doelastix('transform'  , path,    { f4} ,[ -1]  )   ;%TPM with interp=-1'
    doelastix('transform'  , path,    { f5} ,[ 0]  )   ; %BINARYMASK with interp=0'
    
    doelastix('transforminv'  , path,    {fullfile(path,'sAVGT.nii')} ,[] ,M ) %use reorientMAT from workspace
    
    %%  forward, useLocalPath,  files2trafo from different Mousefolders , interp, use Locally stored ReorientMat
    doelastix(1    , [],      files                          ,3 ,      'local' );
end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%
% task='calcertask'
%  timex(task)
%  pause(5)
%  delete(timerfind('tag','timex99'))
%
%  return

prefix={'x_' 'ix_'};
folder={'elastixForward' 'elastixBackward'};

switch task
    %% %••••••••••••••••••••••••••••••••••••••       CALCULATION   ••••••••••••••••••••••••••••••••••••••••••••••••••
    case 'calculate'
        z.prefix=prefix;
        z.folder=folder;
        z.path=arg1;
        z.fiximg=arg2{1};
        z.movimg=arg2{2};
        z.parafiles=arg3;
        
        if exist('arg4')
            if iscell(arg4)
                try;                z.fiximgMSK=arg4{1} ; catch; z.fiximgMSK=[]; end
                try;                z.movimgMSK=arg4{1} ; catch; z.movimgMSK=[]; end
            end
        end
        
        
        %         try;               timex('CALCULATE TRANSFORMATION: dt=');  end
        calculate(z);        %% now calculate
        %         try;              delete(timerfind('tag','timex99'));  statusbar(0)   ;end
    otherwise
        %% %••••••••••••••••••••••••••••••••••••••       FORWARD/BACKWARD TRANSFORM FILE     ••••••••••••••••••••••••
        switch task
            case 'transform'
                z.direction= 1;             %warpdirection [1,-1].forward,backward
                z.prefix=prefix{1};       %file prefix used
                z.folder=folder{1};     %folder were transformParas.txt etc will be written
                if exist('arg4'); z.M=arg4; else; z.M=[]; end  %reorientMAT  applied if given
            case 'transforminv'
                z.direction=-1;
                z.prefix=prefix{2};
                z.folder=folder{2};
                if exist('arg4'); z.M=arg4; else; z.M=[]; end  %reorientMAT
        end
        z.path=arg1;
        z.files  =arg2;
        try ; z.interp=arg3  ; catch  ; z.interp=[];end  %% INTERPOLATION (default 3)
        
        
        %         try;               timex('TRANSFORM IMAGES: dt=');  end
        trafo(z) ;
        %         try;              delete(timerfind('tag','timex99')); statusbar(0)   ; end
end
return


%% ################################################################################

%%  [2]    transform forward, backward

%% ################################################################################

function trafo(z)
%% check files (cell) and add interpolationMethod
if ischar(z.files);                                          z.files  =  cellstr(z.files)   ;end                                             % cell only
if isempty(z.interp);                                   z.interp=ones(1, length((z.files) ))*3  ; end                        % default interp if empty
if length(z.files)~=length(z.interp);          z.interp =  repmat(z.interp(1),[1 length(z.files)  ]); end   %replicate interp, if one interpvalue given for all files

%% get TRAFOFILE
if ~isempty(z.path)
    getPathInEachLoop=0;
    trafopath=        fullfile(z.path,z.folder) ;
    trafofile=          dir(fullfile(trafopath,'TransformParameters*.txt'));
    trafofile=          fullfile(trafopath,trafofile(end).name);                                          %the last TRAFOFILE contains all infos
else
    getPathInEachLoop=1;
end

%% check wether local REORIENT.MAT SHOULD BE JUSED (z.m='local')
%% use local Reorient.mat
if isstr(z.M) && ~isempty(z.M)
    if            strcmp(z.M,'local')
        getReorientmatInEachLoop=1; %load in each ImageLoop
    end
else
    getReorientmatInEachLoop=0;
end

%% apply for each file
for i=1:length(z.files)
    filename=z.files{i};
    
    %% use local path
    if getPathInEachLoop==1;
        z.path=fileparts(filename);
        trafopath=        fullfile(z.path,z.folder) ;
        trafofile=          dir(fullfile(trafopath,'TransformParameters*.txt'));
        trafofile=          fullfile(trafopath,trafofile(end).name);                                          %the last TRAFOFILE contains all infos
    end
    
    %% load the local Reorient.mat
    if getReorientmatInEachLoop==1
        Mpath=fullfile(z.path,'reorient.mat');
        if exist(Mpath)==2
            load(Mpath);
            z.M=M;
        else
            keyboard
        end
    end
    
    %% set internal imagePRECISION
    %               // *********** used for all other images ***************
    %             (FixedInternalImagePixelType "float")
    %             (MovingInternalImagePixelType "float")
    %             (ResultImagePixelType "float")
    %
    %             // *********** used for 64bit images ***************
    %             //(FixedInternalImagePixelType "short")
    %             //(MovingInternalImagePixelType "short")
    %             //(ResultImagePixelType "float")
    %                 v=  spm_vol(filename);
    % rm_ix(trafofile,'FixedInternalImagePixelType');
    % rm_ix(trafofile,'MovingInternalImagePixelType');
    % rm_ix(trafofile,'ResultImagePixelType');
    
    v=  spm_vol(filename);
    if v.dt(1)<=100%32
        set_ix(trafofile,'FixedInternalImagePixelType','float');
        set_ix(trafofile,'MovingInternalImagePixelType','float');
        set_ix(trafofile,'ResultImagePixelType','float');
    else
        set_ix(trafofile,'FixedInternalImagePixelType','short');
        set_ix(trafofile,'MovingInternalImagePixelType','short');
        set_ix(trafofile,'ResultImagePixelType','float');
    end
    
    %% work on templatefile, which is renamed after trafo
    tempfile0=fullfile(z.path, '__tobewarped.nii' );% WE WORK ON THIS
    copyfile(filename,tempfile0,'f'); %
    
    if z.direction==1 & ~isempty(z.M)  %apply TRAFO in FORWARD-DIR
        v=  spm_vol(tempfile0);
        spm_get_space(tempfile0,      inv(z.M) * v.mat);
    end
    
    
    %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    %%    set size of IMAGE
    %     if z.direction==   -1
    % %         hh=spm_vol(fullfile(z.path,'t2.nii'));
    % %         disp(['  check dim inverse: ' num2str(hh.dim)]);
    % %         set_ix(trafofile,'Size',    hh.dim);
    %     elseif z.direction==1
    %         hh=spm_vol(fullfile(z.path,'_refIMG.nii')); %(Size 172 215 115)
    %         disp(['  check dim forward: ' num2str(hh.dim)]);
    %         set_ix(trafofile,'Size',    hh.dim);
    %     end
    %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    %     edit(trafofile)
    
    
    if z.interp(i)==-1 %TPMs -->between 0 and 1   ...ALTERNATIVE FOR 0-1-RANGE-DATA
        [ha  a]=rgetnii( tempfile0);
        range1=[min(a(:))  max(a(:))];
        dt=ha.dt;
        pinfo=ha.pinfo;
        ha.dt=[16 0];
        a=a.*10000;
        tempfile=fullfile( z.path,['_elxTemp.nii']);
        rsavenii(tempfile,  ha,a );
        
        
        set_ix(trafofile,'FinalBSplineInterpolationOrder',    3);
        % [im4,tr4] =        run_transformix(  tempfile ,[],trafofile,   z.path ,'');
        [~,im4,tr4]=evalc('run_transformix(  tempfile ,[],trafofile,   z.path ,'''')');
        
        %% set original range
        [hb  b]=rgetnii( im4);
        b2=b./10000;
        [pas fis ext]=fileparts(filename);
        fileout=fullfile(z.path, [ z.prefix  fis ext ]);
        %newfile=stradd(z.files{i},  z.prefix ,1 );
        rsavenii(fileout,  hb,b2 );
        try; delete(tempfile);end
        try; delete(im4);       end
        
        %         if 0
        %             hb.dt=dt;
        %             hb.pinfo=pinfo
        %             %           b2=b./10000;
        %             b2=b;
        %             b2=b2-min(b2(:));
        %             b2=b2./max(b2(:));
        %             b2=(b2.*(range1(2)-range1(1)))+range1(1);
        %             range2=[min(b2(:))  max(b2(:))] ;%check range
        %             newfile=stradd(z.im2warpinv{i},'ix' ,1 );
        %             rsavenii(newfile,  hb,b2 )
        %         end
        
    else  %% USE ELASTIX INTERPOLATION
        
        %% ANO-check inverse-->problem with precission, since values are to large
        [~, fi,ext]=fileparts(filename);
        if strcmp([fi ext],'ANO.nii') && z.interp(i)==0
            [dx dc]=rgetnii(tempfile0);
            uni=unique(dc);
            il=find(uni>1e6);
            maxval=uni(min(il)-1);
            valtrans=[uni(il)  [20000+[1:length(il)]]'   ];
            
            for j=1:size(valtrans,1)
                dc(dc==valtrans(j,1))=valtrans(j,2);
            end
            rsavenii(tempfile0,dx,dc);
        end
        
        
        
        %set_ix(trafofile,'ResultImagePixelType',    'float'); %'float' is default -->for ALLEN
        set_ix(trafofile,'FinalBSplineInterpolationOrder',    z.interp(i));
        
        %% BUG: calculation and tranformation on DIFFERENT machines !!!!!!
        if 1
         initrafoParamFN=   get_ix(trafofile,'InitialTransformParametersFileName');
         [pas fis exs]=fileparts(initrafoParamFN);
         initrafoParamFN_neu=fullfile(trafopath, [fis exs]);
         set_ix(trafofile,'InitialTransformParametersFileName',initrafoParamFN_neu);
        end
        
        % [im4,tr4] =       run_transformix(  tempfile0 ,[],trafofile, z.path ,'');
        [~,im4,tr4]=evalc('run_transformix(  tempfile0 ,[],trafofile, z.path ,'''')');
        
        if strcmp([fi ext],'ANO.nii') && z.interp(i)==0
            [dx dc]=rgetnii(im4);
            for j=1:size(valtrans,1)
                dc(dc==valtrans(j,2))=valtrans(j,1);
            end
            rsavenii(im4,dx,dc,[64 0]);
        end
        
        
        
        [pas fis ext]=fileparts(filename); %RENAME FILE
        fileout=fullfile(z.path, [z.prefix fis ext]) ;
        movefile(im4,fileout   );
    end
    
    if z.direction==-1 && ~isempty(z.M)  %apply TRAFO in BACKWARD-DIR
        v=  spm_vol(fileout);
        spm_get_space(fileout,      (z.M) * v.mat);
         rreslice2target(fileout,fullfile(fileparts(fileout),'t2.nii') , fileout  , 0);
    end
    
    try
        disp([pnum(i,4) '] imported file <a href="matlab: explorerpreselect(''' fileout ''')">' fileout '</a>'  ]);
    end
    
end



%clean up
try; delete(tempfile0);end
try; delete(fullfile(z.path,'transformix.log'));end

%% ################################################################################

%%  [1] calculate forward & backward

%% ################################################################################

function calculate(z)

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% 1st copy parameterFiles
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
parafiles2=replacefilepath(stradd(z.parafiles,'x',1),z.path);
for i=1:length(parafiles2)
    copyfile(z.parafiles{i},parafiles2{i},'f');
end
parafiles=parafiles2;


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% run Elastix : forwardDirection
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
z.outforw=fullfile(z.path,z.folder{1}); mkdir(z.outforw);

if 0
    disp('use approach-1');
    [im,trfile] = run_elastix(z.fiximg,z.movimg,    z.outforw  ,parafiles,   [],[]       ,[],[],[]);
end

if 1%WITH MASK
    %disp('use approach-3-with MASK');
    if isfield(z,'fiximgMSK')==0; z.fiximgMSK=[]; end
    if isfield(z,'movimgMSK')==0; z.movimgMSK=[]; end
    %        set_ix(parafiles{2},'ErodeMask','false'); %
    %       set_ix(parafiles{2},'MaximumNumberOfIterations',3000); %
    %  [im,trfile] =      run_elastix(z.fiximg,z.movimg,    z.outforw  ,parafiles,   z.fiximgMSK,z.movimgMSK     ,[],[],[]);
    [~,im,trfile]=evalc('run_elastix(z.fiximg,z.movimg,    z.outforw  ,parafiles,   z.fiximgMSK,z.movimgMSK     ,[],[],[])');
end

if 0
    disp('use approach-2 (warp with masklesion)');
    %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    %% approach 2 using lesionMask
    %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    path=z.path;%% make masks
    tpm           ={ 'c1t2.nii' 'c2t2.nii' };
    tpm           =fullpath(path,tpm);
    brainmask=fullpath(path,'brainmask.nii');
    lesionmask=fullpath(path,'masklesion.nii');
    
    makebrainmask3(tpm, .1,brainmask);
    [ h a]=rgetnii(brainmask);
    [ hm b]=rgetnii(lesionmask);
    a2=a;
    a2(b==1)=0;
    brainNoLesionMask=fullpath(path,'brainNoLesionMask.nii'); %% MASK USED
    rsavenii(brainNoLesionMask,h,a2 );
    
    tpmref           ={ '_tpmgrey.nii' '_tpmwhite.nii' };% REF
    tpmref           =fullpath(path,tpmref);
    brainmaskref =fullpath(path,'brainmaskref.nii');
    makebrainmask3(tpmref, .1,brainmaskref);
    
    
    
    %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    [ ha a]=rgetnii(brainmaskref);
    [ hb b]=rgetnii(fullfile(path, 'AVGT.nii'));
    b2=double(b).*double(a);
    rsavenii(brainmaskref,hb,b2 );
    
    [ ha a]=rgetnii(brainmask);
    [ hb b]=rgetnii(fullfile(path, 't2.nii'));
    b2=double(b).*double(a);
    rsavenii(brainmask,hb,b2 );
    
    %--------------------------
    ff=@(a,b)fullfile(a,b);
    z.fiximg       =brainmaskref   ;%ff(path, 'AVGT.nii');
    z.movimg  =brainmask    ;   %fullfile(path,'t2.nii') ;  %%ff(pa, 'T2.nii')
    %  z.fix_mask     =brainmaskref ;%% ff(pa, 'c1c2mask.2.nii')
    %  z.mov_mask = brainNoLesionMask ;%ff(pa, 'brainNoLesionMask.nii')  %mov_mask =ff(pa, 'brainNoLesionMask3.nii')
    
    %   z.fiximg     ='O:\harms1\harms2\dat\_s20150908_FK_C1M01_1_3_1\AVGT.nii'
    %   z.movimg  ='O:\harms1\harms2\dat\_s20150908_FK_C1M01_1_3_1\t2.nii'
    %   %    z.outforw  =
    %   z.fix_mask  ='O:\harms1\harms2\dat\_s20150908_FK_C1M01_1_3_1\brainmaskref.nii'
    %   z.mov_mask='O:\harms1\harms2\dat\_s20150908_FK_C1M01_1_3_1\brainNoLesionMask.nii'
    %
    % [im,trfile] = run_elastix(z.fiximg,z.movimg,    z.outforw  ,parafiles,   z.fix_mask,z.mov_mask     ,[],[],[]);
    [im,trfile] = run_elastix(z.fiximg,z.movimg,    z.outforw  ,parafiles,   [],[]       ,[],[],[]);
end


% %% example TEST-forward
% trafofile=dir(fullfile(z.outforw,'TransformParameters*.txt'))
% trafofile=fullfile(z.outforw,trafofile(end).name);
% z.im2warp=fullfile(pa,'t2.nii')
%  [im2,tr2] = run_transformix(z.im2warp,[],trafofile,[],'');

% try ; doelastix('transform'  , z.path,    {fullfile(z.path,'t2.nii')}   )   ; end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% run Elastix : backWardDirection
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% copy PARAMfiles
parafilesinv=stradd(parafiles,'inv',1);
for i=1:length(parafilesinv)
    copyfile(parafiles{i},parafilesinv{i},'f');
    pause(.01)
    rm_ix(parafilesinv{i},'Metric'); pause(.1) ;
    set_ix(parafilesinv{i},'Metric','DisplacementMagnitudePenalty'); %SET DisplacementMagnitudePenalty
end

trafofile=dir(fullfile(z.outforw,'TransformParameters*.txt')); %get Forward TRAFOfile
trafofile=fullfile(z.outforw,trafofile(end).name);

z.outbackw=fullfile(z.path, z.folder{2} ); mkdir(z.outbackw);
% [im3,trfile3] =      run_elastix(z.movimg,z.movimg,    z.outbackw  ,parafilesinv,[], []       ,   trafofile   ,[],[]);
[~,im3,trfile3]=evalc('run_elastix(z.movimg,z.movimg,    z.outbackw  ,parafilesinv,[], []       ,   trafofile   ,[],[])');



%% [im3,trfile3] = run_elastix(z.movimg,z.movimg,    z.outbackw  , (parafilesinv), [],[]   ,   trafofile   ,[],[]);
trfile3=cellstr(trfile3);
%set "NoInitialTransform" in TransformParameters.0.txt.
set_ix(trfile3{1},'InitialTransformParametersFileName','NoInitialTransform');%% orig
%set_ix(trfile3{2},'InitialTransformParametersFileName','NoInitialTransform');


% apply backwardTRAFO
% try ; doelastix('transforminv'  , z.path,    {fullfile(z.path,'sAVGT.nii')}   )   ; end

% doelastix('transforminv'  , [],    {fullfile(z.path,'_refIMG.nii')},-1,'local'  )
% doelastix('transform'  , [],    {fullfile(z.path,'t2.nii')},3,'local'  )

%    if 0
% %        addpath(genpath('O:\TOOLS\matlab_elastix-master'))
% %
% %        inpa='O:\harms1\harms2\dat\_s20150505SM01_1_x_x\elastixForward'
% %        outpa='O:\harms1\harms2\dat\_s20150505SM01_1_x_x\elastixBackward'
% %        inverted = invertElastixTransform('O:\harms1\harms2\dat\_s20150505SM01_1_x_x\tmp');
%
% parafiles2={    'O:\harms1\harms2\dat\_s20150505SM01_1_x_x\xPar0025affinecopy.txt'
%     'O:\harms1\harms2\dat\_s20150505SM01_1_x_x\xPar0033bspline_EM2copy.txt'}
% inv_txt = invert_transformation(parafiles2,z.movimg,trafofile)
%    end



%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% clean up
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
k=dir(fullfile(z.outforw,'*.nii'));
for i=1:length(k)
    try; delete(           fullfile(z.outforw,k(i).name)              )  ;end
end
k=dir(fullfile(z.outbackw,'*.nii'));
for i=1:length(k)
    try; delete(           fullfile(z.outbackw,k(i).name)              )  ;end
end

return



function timex(task)
delete(timerfindall);
% task='calculate'
us.task=task;
us.t=tic;
t = timer('period',6.0,'userdata',us);
set(t,'ExecutionMode','fixedrate','StartDelay',0,'tag','timex99');
set(t,'timerfcn',['t=timerfind(''tag'',''timex99'')   ; us=get(t,''userdata'');' ...
    'dt=toc(us.t);'  ,  'statusbar(0, sprintf([ ''  '' us.task   ''%2.2fmin'' ],dt/60));'   ]);
%           'dt=toc(us.t);   statusbar(0,num2str(dt))  '      ]);
%       'dt=toc(us.t);'  ,  'statusbar(0, sprintf([''%2.2f min'' ],dt/60));'   ]);
start(t);
return
