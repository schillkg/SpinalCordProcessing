% step 3 -  v2 (keep as 3d)
% extract center slice from:
%
% b0_moco_mean.nii
% dwi_moco_mean_seg.nii
% dwi_crop_moco.nii
%
% these last ones get 35mm of cropping and center slice
% mFFE.nii
% mFFE_seg.nii
% mFFE_wmseg.nii
% mFFE_gmseg.nii
% 
% potentially split dwis into new folder too idk

addpath(genpath('/Volumes/schillkg/MATLAB/NIFTI_20130306/'))


mkdir('PROCESSED');

nii = load_untouch_nii('b0_moco_mean.nii');
img = nii.img;
img = img(:,:,ceil(size(img,3)/2));
img = double(img);
%nii.img = double(img);
nii.hdr.dime.dim(4) = 1;
nii.hdr.dime.scl_slope = 0; nii.hdr.dime.scl_inter = 0; nii.hdr.dime.bitpix = 64; nii.hdr.dime.datatype = 64;
img_norm = (img - min(img(:))) / (max(img(:)) - min(img(:)));
nii.img = 1000*img_norm;
save_untouch_nii(nii,'PROCESSED/b0.nii');
b0_slice = img_norm;

nii = load_untouch_nii('dwi_moco_mean_seg.nii');
img = nii.img;
img = double(img);
img = img(:,:,ceil(size(img,3)/2));
nii.img = img;
nii.hdr.dime.dim(4) = 1;
nii.hdr.dime.scl_slope = 0; nii.hdr.dime.scl_inter = 0; nii.hdr.dime.bitpix = 64; nii.hdr.dime.datatype = 64;
img_norm = (img - min(img(:))) / (max(img(:)) - min(img(:)));
nii.img = 1000*img_norm;
save_untouch_nii(nii,'PROCESSED/bgmask.nii');
b0_mask = img_norm;

nii = load_untouch_nii('dmri_crop_moco.nii');
img = nii.img;
img = double(img);
img = img(:,:,ceil(size(img,3)/2),:);
nii.img = img;
nii.hdr.dime.dim(4) = 1;
img_norm = (img - min(img(:))) / (max(img(:)) - min(img(:)));
nii.img = 1000*img_norm;
nii.hdr.dime.scl_slope = 0; nii.hdr.dime.scl_inter = 0; nii.hdr.dime.bitpix = 64; nii.hdr.dime.datatype = 64;
dwi = img_norm;

save_untouch_nii(nii,'PROCESSED/DWIs.nii');

copyfile bvals.txt PROCESSED/bvals.txt
copyfile bvecs.txt PROCESSED/bvecs.txt

%%

% these last ones get 35mm of cropping and center slice
% mFFE.nii
% mFFE_seg.nii
% mFFE_wmseg.nii
% mFFE_gmseg.nii



nii = load_untouch_nii('mFFE_seg.nii');
img = nii.img;
img = double(img);
img = img(:,:,ceil(size(img,3)/2),:);
[y, x] = ndgrid(1:size(img, 1), 1:size(img, 2));
centroid = mean([x(logical(img)), y(logical(img))]);
pix = 35/nii.hdr.dime.pixdim(2);
voxels = round((pix-2)/2)*2+2;
img_new = img(round(centroid(2)-voxels/2)+1:round(centroid(2)+voxels/2),round(centroid(1)-voxels/2)+1:round(centroid(1)+voxels/2));
%nii.img = img_new;
img_norm = (img_new - min(img_new(:))) / (max(img_new(:)) - min(img_new(:)));
nii.img = 1000*img_norm;
nii.hdr.dime.scl_slope = 0; nii.hdr.dime.scl_inter = 0; nii.hdr.dime.bitpix = 64; nii.hdr.dime.datatype = 64;
nii.hdr.dime.dim(1) = 3;
nii.hdr.dime.dim(2:3) = size(img_norm);
nii.hdr.dime.dim(4) = 1;
save_untouch_nii(nii,'PROCESSED/mFFE_MASK.nii');
anat_mask = img_norm;

nii = load_untouch_nii('mFFE.nii');
img = nii.img;
img = double(img);
img = img(:,:,ceil(size(img,3)/2),:);
img_new = img(round(centroid(2)-voxels/2)+1:round(centroid(2)+voxels/2),round(centroid(1)-voxels/2)+1:round(centroid(1)+voxels/2));
%nii.img = img_new;
img_norm = (img_new - min(img_new(:))) / (max(img_new(:)) - min(img_new(:)));
nii.img = 1000*img_norm;
nii.hdr.dime.scl_slope = 0; nii.hdr.dime.scl_inter = 0; nii.hdr.dime.bitpix = 64; nii.hdr.dime.datatype = 64;
nii.hdr.dime.dim(1) = 3;
nii.hdr.dime.dim(2:3) = size(img_norm);
nii.hdr.dime.dim(4) = 1;
save_untouch_nii(nii,'PROCESSED/mFFE_IMG.nii');
anat = img_norm;

nii = load_untouch_nii('mFFE_wmseg.nii');
img = nii.img;
img = double(img);
img = img(:,:,ceil(size(img,3)/2),:);
img_new = img(round(centroid(2)-voxels/2)+1:round(centroid(2)+voxels/2),round(centroid(1)-voxels/2)+1:round(centroid(1)+voxels/2));
%nii.img = img_new;
nii.hdr.dime.scl_slope = 0; nii.hdr.dime.scl_inter = 0; nii.hdr.dime.bitpix = 64; nii.hdr.dime.datatype = 64;
img_norm = (img_new - min(img_new(:))) / (max(img_new(:)) - min(img_new(:)));
nii.img = 1000*img_norm;
nii.hdr.dime.dim(1) = 3;
nii.hdr.dime.dim(2:3) = size(img_norm);
nii.hdr.dime.dim(4) = 1;
save_untouch_nii(nii,'PROCESSED/mFFE_WM.nii');

nii = load_untouch_nii('mFFE_gmseg.nii');
img = nii.img;
img = double(img);
img = img(:,:,ceil(size(img,3)/2),:);
img_new = img(round(centroid(2)-voxels/2)+1:round(centroid(2)+voxels/2),round(centroid(1)-voxels/2)+1:round(centroid(1)+voxels/2));
%nii.img = img_new;
img_norm = (img_new - min(img_new(:))) / (max(img_new(:)) - min(img_new(:)));
nii.img = 1000*img_norm;
nii.hdr.dime.scl_slope = 0; nii.hdr.dime.scl_inter = 0; nii.hdr.dime.bitpix = 64; nii.hdr.dime.datatype = 64;
nii.hdr.dime.dim(1) = 3;
nii.hdr.dime.dim(2:3) = size(img_norm);
nii.hdr.dime.dim(4) = 1;
save_untouch_nii(nii,'PROCESSED/mFFE_GM.nii');

%% register

% have to make same size
% register to anatomical slice, save transform (start with same sized
% images)
anat_slice = double(anat);
b0_slice_masked = b0_slice.*b0_mask;
b0_slice_resized_masked = imresize(double(b0_slice_masked),size(anat_slice));
anat_slice_masked = anat_slice.*anat_mask;

transform = 'translation'
[optimizer, metric] = imregconfig('multimodal')
metric.NumberOfHistogramBins = 32;

[moving_reg, R_reg] = imregister(b0_slice_resized_masked, anat_slice_masked, transform,optimizer,metric);
tform = imregtform(b0_slice_resized_masked,anat_slice_masked,transform,optimizer,metric)
    
save('b02mFFE.mat','tform')

figure; imshowpair(anat_slice, moving_reg,'Scaling','joint')
pause(2);

figure; 
subplot(1,3,1); imagesc(anat_slice_masked); axis equal; axis tight; axis off; colormap gray;
subplot(1,3,2); imshowpair(anat_slice_masked, moving_reg,'Scaling','joint'); axis equal; axis tight; axis off;
subplot(1,3,3); imagesc(moving_reg); axis equal; axis tight; axis off; colormap gray;
pause(2);


% sz_diff = size(dwi);
% % apply tform to DWIs
% for jj = 1:sz_diff(4)
%     A = dwi(:,:,1,jj); % 2d image of given slice, loop through volumes
%     A = imresize(A,size(anat_slice));
%     B = imwarp(A,tform,'OutputView',imref2d(size(anat_slice_filt_masked)));
%     warped_vols(:,:,i,jj) = B;
% end








