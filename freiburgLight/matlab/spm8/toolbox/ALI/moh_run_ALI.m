function moh_run_ALI(job)
% routine: Automatic Lesion Identification (ALI)
% routine with several steps
% can alos be used to generate lesion overlap maps (LOM)
% -------------------------------------------------
% STEP 1:
%   segment in 4 classes all structural T1 images
%   all controls and patients
%   in two runs:
%   1- a rough estimate of the lesion localisation
%   2- use the result form run 1 as a prior (iterative segmentation)
% -------------------------------------------------
% STEP 2:
%   Spatial smoothing of GM and WM images
%   (controls and patients)
% -------------------------------------------------
% STEP 3:
%   Outlier detection within GM and WM classes
%   Using Fuzzy clustering with fixed prototype (FCP)
%   in 2 parts:
%   1- outliers (positive and negative) in GM
%   2- outliers (positive and negative) in WM
% -------------------------------------------------
% STEP 4:
%   Grouping of outliers within GM and WM (negative values)
%   Generate three different images:
%   1- fuzzy definition of the lesion (continuous abnormality)
%   2- binary (1/0) image of the lesion (at a given threshold)
%   3- contours of the lesion
% ---------------------------------------------------
% Generate Lesion overlap maps LOM across patients
% and then explore LOM image + list of patients with lesions
%
% ---------------------------------------------------
% Mohamed Seghier, 30.05.2009
% ======================================


clc ;

vs = '2.5' ;

disp(spm('time')) ;

% spm('ver', 'spm_spm.m') ;
% if ~ismember({spm('ver')}, {'SPM5','SPM8b', 'SPM8'}), ...
% error('The script needs SPM5 (or greater) to run correctly....!!!'); end
% if spm_matlab_version_chk('7') < 0, ...
%         error('The script needs MATLAB 7 or greater....!!!'); end
pushbutton_color = [0.3 0.3 0.3] ;

spm_defaults ;
global defaults


disp([sprintf('\n\n'),...
    'Welcome to the Automatic Lesion Identification (ALI) toolbox',...
    sprintf('\n\n')]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% -------------------------------------------------------------------------
% STEP 1: iterative unified segmentation-normalisation
% -------------------------------------------------------------------------


if isfield(job, 'step1prior')

    % segment in 4 classes all structural T1 images
    % (controls and patients)
    %=============================================================
    % in two steps:
    % 1- a rough estimate of the lesion localisation
    % 2- use the result form step 1 as a prior (iterative process)


    p_anat = char(job.step1data) ;
    p0_C4prior = char(job.step1prior) ;

    % default values
    % --------------
    n_iter = job.step1niti ; % number of iterations in the new segment
    clean_prob = job.step1thr_prob ; % lower prob value in the extra class
    clean_size = job.step1thr_size ; % size threshold in the extra class
    do_coregister = job.step1coregister ; % if coregistration is necessary


    for n=1:size(p_anat, 1)

        % 1st guess
        % ======

        [pth,nam,ext,toto] = spm_fileparts(deblank(p_anat(n,:))) ;     

        % to improve the segmentation (unified framework)
        % coregister the T1 image to the T1 template
        if do_coregister
            moh_coregister_job(deblank(p_anat(n,:))) ;
        end
        
        V_anat = spm_vol(deblank(p_anat(n,:))) ;

        % first segmentation in 4 classes (EXTRA1)
        disp(['/////////////////////// SUBJECT ' num2str(n), ...
            ' /// iteration 1 ////////////////////////////////']) ;
        moh_unified_segmentation(V_anat, p0_C4prior) ;


        for iti=1:(n_iter-1)

            % prepare the rough estimate of the lesion
            % prepare the prior (clean up)
            pC4 = fullfile(pth , ['wc4' nam ext]) ;
            vC4 = spm_vol(pC4) ;

            im_prior = moh_cleanup_prior(vC4, clean_prob, clean_size, iti);


            % itirative segmentation
            % ======================
            disp(['////////////////////// SUBJECT ' num2str(n),...
                ' /// iteration ',num2str(iti+1),' /////////////'])

            moh_unified_segmentation(V_anat, im_prior) ;


        end


        % after segmentation, write a normalised anatomical volume
        % =========================================================
        moh_writenormalise_job(V_anat.fname)
        disp('################# write a normalised structural volume ..OK')


    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% -------------------------------------------------------------------------
% STEP 2: spatial smoothing of segmented GM/WM classes
% -------------------------------------------------------------------------


if isfield(job, 'step2fwhm')

    P = job.step2data ;

    fwhm = job.step2fwhm ;

    % Spatial smoothing of GM and WM images
    % (controls and patients)
    %=============================================================
    disp(sprintf('##### smoothing of the segmented tissue images...... '))
    moh_smooth_job(P,fwhm) ;
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% -------------------------------------------------------------------------
% STEP 3: outliers detection (detection of abnormality in GM and WM)
% -------------------------------------------------------------------------


if isfield(job, 'step3Lambda')        % Outlier detection within GM and WM
    % (Fuzzy clustering)
    %=============================================================
    folder_results = char(job.step3directory) ;

    pm = char(job.step3mask) ;
    % data for classification of voxels
    pPG = char(job.step3patientGM) ;
    pPW = char(job.step3patientWM) ;
    pCG = char(job.step3controlGM) ;
    pCW = char(job.step3controlWM) ;

    % default parameters
    mask_threshold = job.step3mask_thr  ; % or use threshold 2 for F masks
    Lambda = job.step3Lambda ; % equivalent to "m" in FCM (m=1-2/lambda)
    Alpha = job.step3Alpha ; % factor of sensitivity (tunning factor)


    % load of the mask (mask.img) (meaningful voxels)
    vm = spm_vol(pm) ;
    mask = spm_read_vols(vm) > mask_threshold ;
    Vol = find(mask) ;
    [voxx voxy voxz] = ind2sub(size(mask), Vol) ;

    % c = size(pCG,1) + 1 ; % number of classes = N controls + 1 patient


    % Structure FCP creation
    FCP.version.SPM = spm('ver') ;
    FCP.version.toolbox = vs ;
    FCP.files.patients.GM = pPG ;
    FCP.files.patients.WM = pPW ;
    FCP.files.controls.GM = pCG ;
    FCP.files.controls.WM = pCW ;
    FCP.mask.file = pm ;
    FCP.mask.threshold = mask_threshold ;
    FCP.lambda = Lambda ;
    FCP.alpha = Alpha ;
    FCP.size.nvoxels = nnz(mask) ;
    FCP.size.nclasses = size(pCG,1) + 1 ;



    % Outliers detection for GM images
    % ============================================================
    disp('############## Outlier detection .............. GM images.....')

    % prepare control data (GM)
    vCG = spm_vol(pCG) ;
    XC = [] ;
    XC = spm_get_data(vCG,[voxx voxy voxz]')' ;


    for n=1:size(pPG,1)

        clear U* G*

        vPG = spm_vol(deblank(pPG(n,:))) ;

        [pth nam ext toto] = spm_fileparts(vPG.fname) ;
        disp(['=========== patient number ',...
            num2str(n), ' , name: ', nam]) ;

        % detection of outlier voxels
        [Up, Un, Gp, Gn] = moh_FCP_outliers(vPG, XC, Vol, Alpha, Lambda);

        % prepare outlput for positive effects
        vU = vPG(1) ;
        vU.descrip = 'Fuzzy CP classification' ;
        vU.fname = fullfile(folder_results,...
            ['FCP_positive_',nam, ext]) ;
        spm_write_vol(vU,Up) ;
        FCP.GM.U.positive{n} = vU.fname ;
        FCP.GM.G.positive(n,:) = Gp ;

        % prepare outlput for negative effects
        vU.fname = fullfile(folder_results,...
            ['FCP_negative_',nam, ext]) ;
        spm_write_vol(vU,Un) ;
        FCP.GM.U.negative{n} = vU.fname ;
        FCP.GM.G.negative(n,:) = -Gn ;

    end



    % Outliers detection for WM images
    % ============================================================
    disp('############## Outlier detection .............. WM images.....')

    % prepare control data (WM)
    vCW = spm_vol(pCW) ;
    XC = [] ;
    XC = spm_get_data(vCW,[voxx voxy voxz]')' ;


    for n=1:size(pPW,1)

        clear U* G*

        vPW = spm_vol(deblank(pPW(n,:))) ;

        [pth nam ext toto] = spm_fileparts(vPW.fname) ;
        disp(['=========== patient number ',...
            num2str(n), ' , name: ', nam]) ;

        % detection of outlier voxels
        [Up, Un, Gp, Gn] = moh_FCP_outliers(vPW, XC, Vol, Alpha, Lambda);

        % prepare output for positive effects
        vU = vPG(1) ;
        vU.descrip = 'Fuzzy CP classification' ;
        vU.fname = fullfile(folder_results,...
            ['FCP_positive_',nam, ext]) ;
        spm_write_vol(vU,Up) ;
        FCP.WM.U.positive{n} = vU.fname ;
        FCP.WM.G.positive(n,:) = Gp ;

        % prepare output for negative effects
        vU.fname = fullfile(folder_results,...
            ['FCP_negative_',nam, ext]) ;
        spm_write_vol(vU,Un) ;
        FCP.WM.U.negative{n} = vU.fname ;
        FCP.WM.G.negative(n,:) = -Gn ;


    end


    save(fullfile(folder_results, ['FCP_' lower(date) '.mat']), 'FCP') ;

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% -------------------------------------------------------------------------
% STEP 4: lesion definition by grouping outliers (fuzzy, binary, contour)
% -------------------------------------------------------------------------


if isfield(job, 'step4fcpGM')     % Grouping of outliers within GM and WM
    % Contour detection
    %=============================================================
    folder_results = char(job.step4directory) ;

    % select the GM U images
    pG = char(job.step4fcpGM) ;

    % select the WM U images
    pW = char(job.step4fcpWM) ;

    % default parameters
    % ------------------
    thr_size = job.step4binary_size ; % lesion more than 1cm3 in volume
    thr_U = job.step4binary_thr ; % threshold on U values


    % Critical: check that the selected files have the same order
    % ===========================================================
    for i=1:size(pG,1)
        [pth namG ext toto] =  spm_fileparts(deblank(pG(i,:))) ;
        [pth namW ext toto] =  spm_fileparts(deblank(pW(i,:))) ;
        and_names = ~(namG == namW) ;
        if nnz(and_names)>1
            disp(['==== proble starting at subject number ' num2str(i)]) ;
            error('### Please check the names/order of your files....!!!');
        end
    end

    % structure for volumetric information (e.g. lesions + size + location)
    Volume.version.SPM = spm('ver') ;
    Volume.version.toolbox = vs ;
    Volume.subjects = pG ;
    Volume.threshold_U = thr_U ;
    Volume.threshold_extent = thr_size ;


    vG = spm_vol(pG) ;
    vW = spm_vol(pW) ;



    % read all images
    for i=1:size(pG,1)

        disp(['######## Lesion mask for patient number:  ', num2str(i)]) ;

        % Group lesion, binary + contour, calculate size and location
        [FuzzyLesion,BinaryLesion,ContourLesion,sizeFuzzy,SizeBinary] = ...
            moh_group_lesion(vG(i), vW(i), thr_U, thr_size) ;

        vo = vG(i) ; % V structure for the output file

        [pth nam ext toto] =  spm_fileparts(deblank(pG(i,:))) ;
        ind = find(ismember(nam, '_')) ;
        vo.fname = fullfile(folder_results,...
            ['Lesion_binary_' nam(ind(2)+1:end), ext]) ;
        spm_write_vol(vo, BinaryLesion) ;

        vo.fname = fullfile(folder_results,...
            ['Lesion_fuzzy_' nam(ind(2)+1:end), ext]) ;
        spm_write_vol(vo, FuzzyLesion) ;

        vo.fname = fullfile(folder_results,...
            ['Lesion_contour_' nam(ind(2)+1:end), ext]) ;
        spm_write_vol(vo, ContourLesion) ;

        Volume.Fcardinality(i) = sizeFuzzy ;
        Volume.binary(i) = SizeBinary ;


    end


    save(fullfile(folder_results,['Volume_' lower(date) '.mat']),'Volume');

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% -------------------------------------------------------------------------
% generate lesion overlap maps (LOM): useful for group analysis
% -------------------------------------------------------------------------


if isfield(job, 'step5LOM')     % Generate Lesion overlap across patients
    %=============================================================
    
    clear LOM ;
    
    folder_results = char(job.step5directory) ;
    threshold_mask = 1 ;

    % select the binary masks
    pG = char(job.step5LOM) ;

    vG = spm_vol(pG) ;
    [pth,nam,ext,toto] = spm_fileparts(vG(1).fname) ;

    % anatomical (canonical) image
    pp = fullfile(spm('Dir'),...
        'canonical', 'single_subj_T1.nii') ;
    vv = spm_vol_nifti(pp);
    [anat, XYZ] = spm_read_vols(vv) ;

    im_overlap = uint16(zeros(vG(1).dim)) ; % init of the overlap image
    vo = vG(1) ; % Vol structure for the output file
    vo.pinfo(1) = 1 ;
    vo.dt = [spm_type('uint16') 0] ;

    % index of patients of interest
    index_lesion = repmat(uint8(zeros(vG(1).dim)), [1 1 1 size(pG,1)]) ;

    % read all images
    for i=1:size(pG,1)

        % LOM assessment
        lesion_bin = uint16(spm_read_vols(vG(i))) ;
        im_overlap = im_overlap + lesion_bin ;
        [x y z] = ind2sub(vG(1).dim, find(lesion_bin > 0)) ;
        ind_xyz = sub2ind(size(index_lesion), x,y,z,i*ones(length(x),1)) ;
        index_lesion(ind_xyz) = 1 ;

    end

    % write LOM image
    vo.fname = fullfile(folder_results,...
        ['LOM_nb', num2str(size(pG,1), '%.3d'), 'patients' ext]) ;
    spm_write_vol(vo, im_overlap) ;


    % display LOM maps
    % ==================
%     % with montage multi-slice display   
%     figure(2) ;
%     colormapp = colormap([gray(256) ; jet(size(pG,1))]) ;
%     mask =  im_overlap >= threshold_mask ;
%     map = 256 * anat / max(anat(:));
%     map(mask) = double(im_overlap(mask)) + 256  ;
%     mont(:,:,1,:) = imrotate(map(:,:,4:end-9),90) ;
%     mont = flipdim(mont, 2); % flip L/R
%     montage (mont, colormapp);

    % within SPM (3-views)
    Fgraph = spm_figure('GetWin','Graphics');
    figure(Fgraph) ;
    moh_display_blobs(vo, threshold_mask, vv) ;


    % wrtite the structure of the group analysis
    ss = reshape(index_lesion, [prod(vG(1).dim) size(pG,1)]);
    voxels_of_interest = find(sum(ss,2) > 0);
    occurrence = squeeze(ss(voxels_of_interest, :)) ;
    LOM.image = ['LOM_nb', num2str(size(pG,1), '%.3d'), 'patients' ext] ;
    LOM.subjects = pG ;
    LOM.index.voxels = voxels_of_interest ;
    LOM.index.occurence = occurrence ;
    LOM.version.SPM = spm('ver') ;
    LOM.version.toolbox = vs ;

    save(fullfile(folder_results,...
        ['LOM_nb',num2str(size(pG,1), '%.3d'),'patients_info.mat']),'LOM');

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% -------------------------------------------------------------------------
% explore the LOM maps: useful for group analysis
% -------------------------------------------------------------------------



if isfield(job, 'step6thr_nb')



    % Explore and examen Lesion overlap maps
    % list patients having lesions at a gievn location
    %====================================================================

    % select the LOM structure
    pL = char(job.step6LOM_file) ;

    min_display = job.step6thr_nb ; % default: all lesioned voxs are shown


    % load of the structure and the map
    LOM = load(pL) ; LOM = LOM.LOM ;
    assignin('base', 'LOM', LOM);
    [pth nm ext toto]= spm_fileparts(pL) ;
    v = spm_vol(fullfile(pth, LOM.image)) ;
    assignin('base', 'v', v);

    if min_display == 1
        moh_display_blobs(v, 1) ;
    else
        % anatomical (canonical) image
        pp = fullfile(spm('Dir'),...
            'canonical', 'single_subj_T1.nii') ;
        im_overlap = spm_read_vols(v) ;

        % Display the image within SPM (3-views)
        spm_check_registration(pp) ;
        [X,Y,Z] = ind2sub(v.dim, LOM.index.voxels) ;
        Zblob = double(im_overlap(LOM.index.voxels)); % blob voxel intens.
        Zblob(Zblob < min_display) = NaN ;

        spm_orthviews('AddBlobs',1,[X';Y';Z'],Zblob,v.mat) ;

    end


    Fgraph = spm_figure('GetWin','Graphics');
    figure(Fgraph) ;
    spm_figure('Colormap','gray-jet') ;

    fsz=get(Fgraph, 'Position') ;


    bout2 = uicontrol('BackgroundColor', pushbutton_color, ...
        'Style','pushbutton', ...
        'string', ' List of lesions at the voxel', ...
        'Units', 'Pixels', ...
        'Position', [0.1*fsz(3) 0.05*fsz(4) 300 30], ...
        'FontAngle','italic',...
        'FontWeight','bold',...
        'FontUnits','points',...
        'FontSize', 12, ...
        'ForegroundColor','w',...
        'HorizontalAlignment', 'center',...
        'Visible', 'On', ...
        'Selected','off',...
        'SelectionHighlight','on', ...
        'Callback',...
        'moh_LOM_explore(LOM, v, ''list_only'')');

    bout3 = uicontrol('BackgroundColor', pushbutton_color, ...
        'Style','pushbutton', ...
        'string', ' List of lesions within a VOI', ...
        'Units', 'Pixels', ...
        'Position', [0.1*fsz(3) (0.05*fsz(4))-35 300 30], ...
        'FontAngle','italic',...
        'FontWeight','bold',...
        'FontUnits','points',...
        'FontSize', 12, ...
        'ForegroundColor','w',...
        'HorizontalAlignment', 'center',...
        'Visible', 'On', ...
        'Selected','off',...
        'SelectionHighlight','on', ...
        'Callback',...
        'moh_LOM_explore(LOM, v, ''list_only_voi'')');

    bout4 = uicontrol('BackgroundColor', pushbutton_color, ...
        'Style','pushbutton', ...
        'string', ' Lesion: size and centre', ...
        'Units', 'Pixels', ...
        'Position', [(0.1*fsz(3))+340 0.05*fsz(4) 250 30], ...
        'FontAngle','italic',...
        'FontWeight','bold',...
        'FontUnits','points',...
        'FontSize', 12, ...
        'ForegroundColor','w',...
        'HorizontalAlignment', 'center',...
        'Visible', 'On', ...
        'Selected','off',...
        'SelectionHighlight','on', ...
        'Callback',...
        'moh_LOM_explore(LOM, v, ''list_size'')');

end


return ;
