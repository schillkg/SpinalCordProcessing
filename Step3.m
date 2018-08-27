% step 3
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

mkdir('PROCESSED');

nii = load_untouch_nii('b0_moco_mean.nii');
img = nii.img;
img = img(:,:,ceil(size(img,3)/2));
nii.img = img;
nii.hdr.dime.dim(4) = 1;
save_untouch_nii(nii,'PROCESSED/b0.nii');

nii = load_untouch_nii('dwi_moco_mean_seg.nii');
img = nii.img;
img = img(:,:,ceil(size(img,3)/2));
nii.img = img;
nii.hdr.dime.dim(4) = 1;
save_untouch_nii(nii,'PROCESSED/bgmask.nii');

nii = load_untouch_nii('dmri_crop_moco.nii');
img = nii.img;
img = img(:,:,ceil(size(img,3)/2),:);
nii.img = img;
nii.hdr.dime.dim(4) = 1;
save_untouch_nii(nii,'PROCESSED/DWIs.nii');

%%

% these last ones get 35mm of cropping and center slice
% mFFE.nii
% mFFE_seg.nii
% mFFE_wmseg.nii
% mFFE_gmseg.nii

nii = load_untouch_nii('mFFE_seg.nii');
img = nii.img;
img = img(:,:,ceil(size(img,3)/2),:);
[y, x] = ndgrid(1:size(img, 1), 1:size(img, 2));
centroid = mean([x(logical(img)), y(logical(img))]);
pix = 35/nii.hdr.dime.pixdim(2);
voxels = round((pix-2)/2)*2+2;
img_new = img(round(centroid(2)-voxels/2)+1:round(centroid(2)+voxels/2),round(centroid(1)-voxels/2)+1:round(centroid(1)+voxels/2));
nii.img = img_new;
nii.hdr.dime.dim(1) = 3;
nii.hdr.dime.dim(2:3) = size(img_new);
nii.hdr.dime.dim(4) = 1;
save_untouch_nii(nii,'PROCESSED/mFFE_MASK.nii');

nii = load_untouch_nii('mFFE.nii');
img = nii.img;
img = img(:,:,ceil(size(img,3)/2),:);
img_new = img(round(centroid(2)-voxels/2)+1:round(centroid(2)+voxels/2),round(centroid(1)-voxels/2)+1:round(centroid(1)+voxels/2));
nii.img = img_new;
nii.hdr.dime.dim(1) = 3;
nii.hdr.dime.dim(2:3) = size(img_new);
nii.hdr.dime.dim(4) = 1;
save_untouch_nii(nii,'PROCESSED/mFFE_IMG.nii');

nii = load_untouch_nii('mFFE_wmseg.nii');
img = nii.img;
img = img(:,:,ceil(size(img,3)/2),:);
img_new = img(round(centroid(2)-voxels/2)+1:round(centroid(2)+voxels/2),round(centroid(1)-voxels/2)+1:round(centroid(1)+voxels/2));
nii.img = img_new;
nii.hdr.dime.dim(1) = 3;
nii.hdr.dime.dim(2:3) = size(img_new);
nii.hdr.dime.dim(4) = 1;
save_untouch_nii(nii,'PROCESSED/mFFE_WM.nii');

nii = load_untouch_nii('mFFE_gmseg.nii');
img = nii.img;
img = img(:,:,ceil(size(img,3)/2),:);
img_new = img(round(centroid(2)-voxels/2)+1:round(centroid(2)+voxels/2),round(centroid(1)-voxels/2)+1:round(centroid(1)+voxels/2));
nii.img = img_new;
nii.hdr.dime.dim(1) = 3;
nii.hdr.dime.dim(2:3) = size(img_new);
nii.hdr.dime.dim(4) = 1;
save_untouch_nii(nii,'PROCESSED/mFFE_GM.nii');



