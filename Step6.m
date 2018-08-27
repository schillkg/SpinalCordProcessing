%% Step 6, move all to mFFE space
% in FINAL2FFE
% b0
% md
% fa
% AD
% RD
% NODDI__odi
% NODDI__kappa
% NODDI__fiso
% NODDI__ficvf
% output_intra
% output_extratrans
% output_extramd
% output_diff
% output_b0
% also move mFFE to folder
% also move WM, GM, seg to folder

addpath(genpath('/Volumes/schillkg/MATLAB/NIFTI_20130306/'))

%% 
load('b02mFFE.mat');
% load tform

saveDir = 'DIFF2FFE'
mkdir(saveDir)

copyfile PROCESSED/mFFE_IMG.nii DIFF2FFE/mFFE_IMG.nii
copyfile PROCESSED/mFFE_MASK.nii DIFF2FFE/mFFE_MASK.nii
copyfile PROCESSED/mFFE_GM.nii DIFF2FFE/mFFE_GM.nii
copyfile PROCESSED/mFFE_WM.nii DIFF2FFE/mFFE_WM.nii

nii = load_untouch_nii('DIFF2FFE/mFFE_IMG.nii');
anat = nii.img;

% DTI

input = 'b0';
output = 'b02mFFE'
nii2 = load_untouch_nii(['PROCESSED' filesep input '.nii']);
img = nii2.img;
A = imresize(img,size(anat));
B = imwarp(A,tform,'OutputView',imref2d(size(anat)));
nii.img = B;
save_untouch_nii(nii,[saveDir filesep output '.nii']);

input = 'md';
output = 'md2mFFE'
nii2 = load_untouch_nii(['PROCESSED' filesep input '.nii']);
img = nii2.img;
A = imresize(img,size(anat));
B = imwarp(A,tform,'OutputView',imref2d(size(anat)));
nii.img = B;
save_untouch_nii(nii,[saveDir filesep output '.nii']);

input = 'fa';
output = 'fa2mFFE'
nii2 = load_untouch_nii(['PROCESSED' filesep input '.nii']);
img = nii2.img;
A = imresize(img,size(anat));
B = imwarp(A,tform,'OutputView',imref2d(size(anat)));
nii.img = B;
save_untouch_nii(nii,[saveDir filesep output '.nii']);

input = 'AD';
output = 'AD2mFFE'
nii2 = load_untouch_nii(['PROCESSED' filesep input '.nii']);
img = nii2.img;
A = imresize(img,size(anat));
B = imwarp(A,tform,'OutputView',imref2d(size(anat)));
nii.img = B;
save_untouch_nii(nii,[saveDir filesep output '.nii']);

input = 'RD';
output = 'RD2mFFE'
nii2 = load_untouch_nii(['PROCESSED' filesep input '.nii']);
img = nii2.img;
A = imresize(img,size(anat));
B = imwarp(A,tform,'OutputView',imref2d(size(anat)));
nii.img = B;
save_untouch_nii(nii,[saveDir filesep output '.nii']);

% NODDI
% NODDI__odi
% NODDI__kappa
% NODDI__fiso
% NODDI__ficvf

input = 'NODDI__odi';
output = 'NODDI__odi2mFFE'
nii2 = load_untouch_nii(['PROCESSED' filesep input '.nii']);
img = nii2.img;
A = imresize(img,size(anat));
B = imwarp(A,tform,'OutputView',imref2d(size(anat)));
nii.img = B;
save_untouch_nii(nii,[saveDir filesep output '.nii']);

input = 'NODDI__kappa';
output = 'NODDI__kappa2mFFE'
nii2 = load_untouch_nii(['PROCESSED' filesep input '.nii']);
img = nii2.img;
A = imresize(img,size(anat));
B = imwarp(A,tform,'OutputView',imref2d(size(anat)));
nii.img = B;
save_untouch_nii(nii,[saveDir filesep output '.nii']);

input = 'NODDI__fiso';
output = 'NODDI__fiso2mFFE'
nii2 = load_untouch_nii(['PROCESSED' filesep input '.nii']);
img = nii2.img;
A = imresize(img,size(anat));
B = imwarp(A,tform,'OutputView',imref2d(size(anat)));
nii.img = B;
save_untouch_nii(nii,[saveDir filesep output '.nii']);

input = 'NODDI__ficvf';
output = 'NODDI__ficvf2mFFE'
nii2 = load_untouch_nii(['PROCESSED' filesep input '.nii']);
img = nii2.img;
A = imresize(img,size(anat));
B = imwarp(A,tform,'OutputView',imref2d(size(anat)));
nii.img = B;
save_untouch_nii(nii,[saveDir filesep output '.nii']);

% SMT
% output_intra
% output_extratrans
% output_extramd
% output_diff
% output_b0

input = 'output_intra';
output = 'output_intra2mFFE'
nii2 = load_untouch_nii(['PROCESSED' filesep input '.nii']);
img = nii2.img;
A = imresize(img,size(anat));
B = imwarp(A,tform,'OutputView',imref2d(size(anat)));
nii.img = B;
save_untouch_nii(nii,[saveDir filesep output '.nii']);

input = 'output_extratrans';
output = 'output_extratrans2mFFE'
nii2 = load_untouch_nii(['PROCESSED' filesep input '.nii']);
img = nii2.img;
A = imresize(img,size(anat));
B = imwarp(A,tform,'OutputView',imref2d(size(anat)));
nii.img = B;
save_untouch_nii(nii,[saveDir filesep output '.nii']);

input = 'output_extramd';
output = 'output_extramd2mFFE'
nii2 = load_untouch_nii(['PROCESSED' filesep input '.nii']);
img = nii2.img;
A = imresize(img,size(anat));
B = imwarp(A,tform,'OutputView',imref2d(size(anat)));
nii.img = B;
save_untouch_nii(nii,[saveDir filesep output '.nii']);

input = 'output_diff';
output = 'output_diff2mFFE'
nii2 = load_untouch_nii(['PROCESSED' filesep input '.nii']);
img = nii2.img;
A = imresize(img,size(anat));
B = imwarp(A,tform,'OutputView',imref2d(size(anat)));
nii.img = B;
save_untouch_nii(nii,[saveDir filesep output '.nii']);

input = 'output_b0';
output = 'output_b02mFFE'
nii2 = load_untouch_nii(['PROCESSED' filesep input '.nii']);
img = nii2.img;
A = imresize(img,size(anat));
B = imwarp(A,tform,'OutputView',imref2d(size(anat)));
nii.img = B;
save_untouch_nii(nii,[saveDir filesep output '.nii']);











