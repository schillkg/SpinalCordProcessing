% take high, low for images, bvals, bvecs
% combine
% save as dmri.nii.gz
% save as bvals.txt (with b-vals set to 0)
% save as bvecs.txt (with 3*N, 0's)

% revisions - can accewpt both low and high, as well as already combined
% revisions - can accept with >1 in 3rd dimension, will grab just middle
addpath(genpath('/Volumes/schillkg/MATLAB/NIFTI_20130306/'))

%% 

if exist('NODDI_low.nii', 'file') == 2
    disp('COMBINING LOW AND HIGH B-VALUES')
    
    nii = load_untouch_nii('NODDI_low.nii')
    nii2 = load_untouch_nii('NODDI_high.nii')
    
    dwi1 = nii.img;
    dwi2 = nii2.img;
    
    dwi = cat(4,dwi1,dwi2);
    
    nii.img = dwi;
    nii.hdr.dime.dim(5) = size(dwi,4);
    save_untouch_nii(nii,'dmri.nii');
    
    bval1 = load('NODDI_low.bval');
    bval2 = load('NODDI_high.bval');
    bval = cat(2,bval1,bval2);
    bval(bval<100) = 0;
    dlmwrite('bvals.txt',bval,'precision','%.6f','delimiter',' ');
    
    bvec1 = load('NODDI_low.bvec');
    bvec2 = load('NODDI_high.bvec');
    bvec = cat(2,bvec1,bvec2);
    dlmwrite('bvecs.txt',bvec,'precision','%.6f','delimiter',' ');
    
    % make dmri_mean_seg
    
    dwi(1:round(size(dwi,1)/4),:,:,:) = 0;
    dwi(3*round(size(dwi,1)/4)+1:end,:,:,:) = 0;
    dwi(:,1:round(size(dwi,1)/4),:,:) = 0;
    dwi(:,3*round(size(dwi,1)/4)+1:end,:,:) = 0;
    
    %Mask DWI
    disp('MASKING DWI...');
    mask_tuning = 0.5; % fine-tuning range to calculate the mask: [0.5 1.5]
    cluster_s = 10; % omit pixel clusters smaller than 'cluster_s' during masking
    index = find(bval<100);
    mask = mask_DWI2(dwi(:,:,:,index), mask_tuning, cluster_s );
    
    % create mask
    
    nii.img = uint16(mask);
    nii.hdr.dime.dim(5) = 1;
    nii.hdr.dime.dim(1) = 3;
    save_untouch_nii(nii,'dmri_mean_seg.nii');
    
    mask = mask(:,:,ceil(size(mask,3)/2));
    
    % crop at 35mm (nearest even nubmer voxels)
    % get center of mask
    [y, x] = ndgrid(1:size(mask, 1), 1:size(mask, 2));
    centroid = mean([x(logical(mask)), y(logical(mask))]);
    % centroid is in col, row
    % by what 35mm is in voxel size
    pix = 35/nii.hdr.dime.pixdim(2);
    voxels = round((pix-2)/2)*2+2 ;
    img_new = dwi(round(centroid(2)-voxels/2)+1:round(centroid(2)+voxels/2),round(centroid(1)-voxels/2)+1:round(centroid(1)+voxels/2),:,:);
    
    % nii.img = img_new;
    % nii.hdr.dime.dim(1) = 4;
    % nii.hdr.dime.dim(2:5) = size(img_new);
    % save_untouch_nii(nii,'dmri_crop.nii');
    
    if size(img_new,3) == 1
        % copy 7 times for dimension 3
        disp('dimension 3 is only 1....')
        img_new_cat = cat(3,img_new,img_new,img_new,img_new,img_new,img_new,img_new);
        
    else
        disp('dimension 3 means something ...')
        img_new_cat = img_new;
    end
    
    nii.img = img_new_cat;
    nii.hdr.dime.dim(1) = 4;
    nii.hdr.dime.dim(2:5) = size(img_new_cat);
    save_untouch_nii(nii,'dmri_crop.nii');
    
    %%%%%%%%%%%%%%%%% done with sepereated scans %%%%%%%%%%%%%%%%%%%%%%%%%%
    
else % NODDI is the same scan
    disp('LOW AND HIGH ALREADY COMBINED INTO ONE')
    
    nii = load_untouch_nii('NODDI.nii');
    dwi = nii.img;
    nii.img = dwi;
    save_untouch_nii(nii,'dmri.nii');
    
    bval = load('NODDI.bval');
    bval(bval<100) = 0;
    dlmwrite('bvals.txt',bval,'precision','%.6f','delimiter',' ');
    
    bvec = load('NODDI.bvec');
    dlmwrite('bvecs.txt',bvec,'precision','%.6f','delimiter',' ');
    
     % make dmri_mean_seg
    dwi(1:round(size(dwi,1)/4),:,:,:) = 0;
    dwi(3*round(size(dwi,1)/4)+1:end,:,:,:) = 0;
    dwi(:,1:round(size(dwi,1)/4),:,:) = 0;
    dwi(:,3*round(size(dwi,1)/4)+1:end,:,:) = 0;
    
    %Mask DWI
    disp('MASKING DWI...');
    mask_tuning = 0.5; % fine-tuning range to calculate the mask: [0.5 1.5]
    cluster_s = 10; % omit pixel clusters smaller than 'cluster_s' during masking
    index = find(bval<100);
    mask = mask_DWI2(dwi(:,:,:,index), mask_tuning, cluster_s );
    
    nii.img = uint16(mask);
    nii.hdr.dime.dim(5) = 1;
    nii.hdr.dime.dim(1) = 3;
    save_untouch_nii(nii,'dmri_mean_seg.nii');
    
    mask = mask(:,:,ceil(size(mask,3)/2));
    
     % crop at 35mm (nearest even nubmer voxels)
    % get center of mask
    [y, x] = ndgrid(1:size(mask, 1), 1:size(mask, 2));
    centroid = mean([x(logical(mask)), y(logical(mask))]);
    % centroid is in col, row
    % by what 35mm is in voxel size
    pix = 35/nii.hdr.dime.pixdim(2);
    voxels = round((pix-2)/2)*2+2 ;
    img_new = dwi(round(centroid(2)-voxels/2)+1:round(centroid(2)+voxels/2),round(centroid(1)-voxels/2)+1:round(centroid(1)+voxels/2),:,:);
    
       % nii.img = img_new;
    % nii.hdr.dime.dim(1) = 4;
    % nii.hdr.dime.dim(2:5) = size(img_new);
    % save_untouch_nii(nii,'dmri_crop.nii');
    
    if size(img_new,3) == 1
        % copy 7 times for dimension 3
        disp('dimension 3 is only 1....')
        img_new_cat = cat(3,img_new,img_new,img_new,img_new,img_new,img_new,img_new);
        
    else
        disp('dimension 3 means something ...')
        img_new_cat = img_new;
    end
    
    nii.img = img_new_cat;
    nii.hdr.dime.dim(1) = 4;
    nii.hdr.dime.dim(2:5) = size(img_new_cat);
    save_untouch_nii(nii,'dmri_crop.nii');
    
    
end

    
    
    
    