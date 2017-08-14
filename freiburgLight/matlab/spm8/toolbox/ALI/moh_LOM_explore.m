function [] = moh_LOM_explore(LOM ,v ,todo)
% explore the lesion overlap map (LOM)
% list the subjects with lesion at a given location (+ size and centre)
% input:
%   LOM: mat structure that contains all detais about the lesion overlap
%   v: structure of the volume (spm_vol) of the LOM image
%   todo: what to do (list subjects with or without lesion size)
%
% =====================================================
% Mohamed Seghier, 23.11.2008
%


switch todo
    case 'list_only'
        vox = round(spm_orthviews('Pos',1));
        vox_mm = round(spm_orthviews('Pos'));
        disp(['#### List of subjects with lesion at [mm]: ',...
            num2str(vox_mm')]) ;
        ii = sub2ind(v.dim, vox(1), vox(2), vox(3)) ;
        iii = find(LOM.index.voxels == ii) ;
        list_index = find(LOM.index.occurence(iii, :)) ;
        disp(LOM.subjects(list_index, :)) ;
        disp('  ')
        

    case 'list_only_voi'

        tp = spm_input('VOI (sphere)...',3,'b',{'2D','3D'}) ;
        rad_mm = spm_input('VOI radius (mm)','!+1','r',0,1,[0,Inf]) ;
        rad_vox = ceil(rad_mm / abs(v.mat(1,1))) ;

        vox = round(spm_orthviews('Pos',1));
        vox_mm = round(spm_orthviews('Pos'));

        switch tp
            case '2D'
                mesh_vox = -rad_vox:1:rad_vox ;
                [xx,yy] = meshgrid(mesh_vox, mesh_vox) ;
                voi_mask = (xx.^2 + yy.^2) <= rad_vox^2 ;
                xx = (xx.* voi_mask) + vox(1) ;
                yy = (yy.* voi_mask) + vox(2) ;
                zz = zeros(size(xx)) + vox(3) ;
            case '3D'
                mesh_vox = -rad_vox:1:rad_vox ;
                [xx,yy,zz] = meshgrid(mesh_vox, mesh_vox, mesh_vox) ;
                voi_mask = (xx.^2 + yy.^2 + zz.^2) <= rad_vox^2 ;
                xx = (xx.* voi_mask) + vox(1) ;
                yy = (yy.* voi_mask) + vox(2) ;
                zz = (zz.* voi_mask) + vox(3) ;
        end
        
        % check that dimensions are within the volume box
        xx = max(min(xx, ones(size(xx))*v.dim(1)), ones(size(xx))) ;
        yy = max(min(yy, ones(size(yy))*v.dim(2)), ones(size(yy))) ;
        zz = max(min(zz, ones(size(zz))*v.dim(3)), ones(size(zz))) ;

        %         im_centre = zeros(v.dim) ;
        %         im_centre(vox(1), vox(2), vox(3)) = 1 ;
        %         im_centre = spm_dilate(im_centre , 1*str_morpho) ;
        %         voi_ii = find(im_centre > 0) ;

        voi_ii = sub2ind(v.dim, xx(:), yy(:), zz(:)) ;
        [tmp1, voi_iii, tmp2] = intersect(LOM.index.voxels, voi_ii) ;
        list_index_all = LOM.index.occurence(voi_iii, :) ;
        list_index = find(sum(list_index_all , 1)) ;
        disp(['#### List of subjects with lesion within a '...
            num2str(rad_mm) 'mm-radius sphere'...
            ' centred at [mm]: ' num2str(vox_mm')]) ;
        disp(LOM.subjects(list_index, :)) ;
                disp('  ')




    case 'list_size'
        vox = round(spm_orthviews('Pos',1));
        ii = sub2ind(v.dim, vox(1), vox(2), vox(3)) ;
        iii = find(LOM.index.voxels == ii) ;
        list_index = find(LOM.index.occurence(iii, :)) ;

        for n=1:length(list_index)
            vn = spm_vol(LOM.subjects(list_index(n), :)) ;
            imn = spm_read_vols(vn) ;
            [mask_labeled, sublesions] = spm_bwlabel(1*imn,18) ;
            lesion_of_interest = mask_labeled(ii) ;
            size_voxels = [] ;
            size_cm3 = [] ;
            centre_mm = [] ;
            for j=1:sublesions,
                size_voxels(j) = nnz(mask_labeled == j) ;
                size_cm3(j) = nnz(mask_labeled == j) * ...
                    prod(abs(diag(vn.mat(1:3,1:3)))) / 1000 ;
                [xx yy zz] = ind2sub(vn.dim, find(mask_labeled == j)) ;
                centre_mm(j,:) = (mean([xx yy zz]) .* ...
                    diag(vn.mat(1:3,1:3))') + vn.mat(1:3,4)';
            end
            toto = size_voxels(1) ;
            size_voxels(1) = size_voxels(lesion_of_interest);
            size_voxels(lesion_of_interest) = toto ;
            toto = size_cm3(1) ;
            size_cm3(1) = size_cm3(lesion_of_interest);
            size_cm3(lesion_of_interest) = toto ;
            toto = centre_mm(1,:) ;
            centre_mm(1,:) = centre_mm(lesion_of_interest,:);
            centre_mm(lesion_of_interest,:) = toto ;
            disp(['========== subject ' num2str(n) ' :        ' vn.fname]);
            disp(['lesion index            ' ...
                sprintf(repmat('%10g  \t' ,[1 4]) , 1:sublesions)]) ;
            disp(['size in nb voxels       ' ...
                sprintf(repmat('%10g  \t' ,[1 4]) , size_voxels)]) ;
            disp(['size in cm3             ' ...
                sprintf(repmat('%10g  \t' ,[1 4]) , size_cm3)]) ;
            tmp = num2str(round(centre_mm)) ;
            tmp = [tmp repmat('      ',[sublesions 1])] ;
            tmp_bis = reshape(tmp',[1 prod(size(tmp))]) ;
            disp(['centre of lesion (mm)    ' tmp_bis]) ;
            disp(' --------------------------------------------------- ') ;
        end;

    otherwise
        disp('=== ERROR: option not supported........!!!!') ;
end


return ;



