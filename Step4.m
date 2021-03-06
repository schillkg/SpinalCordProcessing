% Step 4: Calculate dti in diffusion space, calculate NODDI in diffusion
% space
% FA, MD, AD, RD
% NODDI values too

addpath(genpath('/Volumes/schillkg/MATLAB/NIFTI_20130306/'))


%% DTI
dir1 = 'PROCESSED'; 
bvec = [dir1 filesep 'bvecs.txt']
bval = [dir1 filesep 'bvals.txt']
img = [dir1 filesep 'DWIs.nii']
mask = [dir1 filesep 'bgmask.nii']

% for each, just run camino!
system('PATH=${PATH}:~/camino/bin')
system( 'export CAMINO_HEAP_SIZE=24000')
system(['~/camino/bin/fsl2scheme -bvecfile ' bvec ' -bvalfile ' bval ' -outputfile ' dir1 '/b.scheme'])
system(['~/camino/bin/image2voxel -4dimage ' img ' -outputfile ' dir1 '/dwi.Bfloat'])
system(['~/camino/bin/modelfit -inversion 2 -schemefile ' dir1 '/b.scheme -inputfile ' dir1 '/dwi.Bfloat -bgmask ' mask ' -outputfile ' dir1 '/dt.Bdouble'])
system(['~/camino/bin/dt2nii -inputfile ' dir1 '/dt.Bdouble -inputdatatype double  -header ' img ' -outputroot ' dir1 filesep 'camino_'])
system(['cat ' dir1 '/dt.Bdouble | ~/camino/bin/fa | ~/camino/bin/voxel2image -outputroot ' dir1 '/fa -header ' img])
system(['cat ' dir1 '/dt.Bdouble | ~/camino/bin/md | ~/camino/bin/voxel2image -outputroot ' dir1 '/md -header ' img])
system(['cat ' dir1 '/dt.Bdouble | ~/camino/bin/dteig > ' dir1 '/dteig.Bdouble']) 
system(['~/camino/bin/shredder 8 24 72 < ' dir1 '/dteig.Bdouble > ' dir1 '/PEV.Bdouble'])
system(['~/camino/bin/shredder 0 8 88 < ' dir1 '/dteig.Bdouble > ' dir1 '/L1.Bdouble'])
system(['~/camino/bin/shredder 32 8 88 < ' dir1 '/dteig.Bdouble > ' dir1 '/L2.Bdouble'])
system(['~/camino/bin/shredder 64 8 88 < ' dir1 '/dteig.Bdouble > ' dir1 '/L3.Bdouble'])

% View correct orientation
% system(['~/camino/bin/pdview -inputfile ' dir1 '/dteig.Bdouble -scalarfile ' dir1 '/fa.nii'])
nii = load_untouch_nii([dir1 filesep 'fa.nii'])
sz = size(nii.img);
% PEV
fid = fopen([dir1 filesep 'PEV.Bdouble'], 'r', 'b');
pd = fread(fid, 'double'); fclose(fid);
pd = permute(reshape(pd, [3, sz]), [2 3 4 1]); pd(:,:,:,1) = -pd(:,:,:,1);
nii.img = pd;
nii.hdr.dime.dim(1) = 4;
nii.hdr.dime.dim(5) = 3;
save_untouch_nii(nii,[dir1 filesep 'PEV_fslview.nii'])

fid = fopen([dir1 filesep 'L1.Bdouble'], 'r', 'b');
L1 = fread(fid, 'double'); fclose(fid);
L1 = permute(reshape(L1, [sz]), [1 2 3]); 
nii.img = L1;
nii.hdr.dime.dim(1) = 3;
nii.hdr.dime.dim(5) = 1;
save_untouch_nii(nii,[dir1 filesep 'L1.nii'])

fid = fopen([dir1 filesep 'L2.Bdouble'], 'r', 'b');
L2 = fread(fid, 'double'); fclose(fid);
L2 = permute(reshape(L2, [sz]), [1 2 3]); 
nii.img = L2;
nii.hdr.dime.dim(1) = 3;
nii.hdr.dime.dim(5) = 1;
save_untouch_nii(nii,[dir1 filesep 'L2.nii'])

fid = fopen([dir1 filesep 'L3.Bdouble'], 'r', 'b');
L3 = fread(fid, 'double'); fclose(fid);
L3 = permute(reshape(L3, [sz]), [1 2 3]); 
nii.img = L3;
nii.hdr.dime.dim(1) = 3;
nii.hdr.dime.dim(5) = 1;
save_untouch_nii(nii,[dir1 filesep 'L3.nii'])

AD = L1;
RD = (L2+L3)/2;

nii.img = AD;
save_untouch_nii(nii,[dir1 filesep 'AD.nii'])
nii.img = RD;
save_untouch_nii(nii,[dir1 filesep 'RD.nii'])

%% NODDI

cd PROCESSED/

if exist('FittedParams.mat', 'file') == 2
    system('rm FittedParams.mat')
end
    
% Include niftimatlib and NODDI toolbox in the matlab search path
addpath(genpath('/Volumes/schillkg/MATLAB/NODDI_toolbox_v1.01/'))
addpath(genpath('/Volumes/schillkg/MATLAB/niftimatlib-1.2/'))

% Convert the raw DWI volume into the required format with the function
% CreateROI (no gzip files for some reason)
%CreateROI('data.nii', 'nodif_brain_mask.nii', 'NODDI_roi.mat');
CreateROI('DWIs.nii', 'bgmask.nii', 'NODDI_roi.mat');

% Convert the FSL bval/bvec files into the required format with the function FSL2Protocol
%bvec = load('bvecs.txt'); bvec = bvec'; dlmwrite('bvecs_.txt',bvec,'precision','%.6f');
%bval = load('bvals.txt'); bval = bval'; dlmwrite('bvals_.txt',bval);
b0threshold = 100;
%protocol = FSL2Protocol('bvals_.txt', 'bvecs_.txt', b0threshold);
protocol = FSL2Protocol('bvals.txt', 'bvecs.txt', b0threshold);

% Create the NODDI model structure with the function MakeModel
noddi = MakeModel('WatsonSHStickTortIsoV_B0')

% Run the NODDI fitting with the function batch_fitting, if you have the 
% parallel computing toolbox, or batch_fitting_single, if you do not

batch_fitting('NODDI_roi.mat', protocol, noddi, 'FittedParams.mat', 6)
% The first three arguments to the function are explained in the 
% previous steps. The fourth argument specifies the mat file name to 
% store the estimated NODDI parameters. The final argument sets the 
% number of computing cores to use for running the fitting in parallel. 
% This argument is optional. If not specified, the function will let 
% Matlab choose the default setting. On a 8-core machine, the fitting 
% should finish in around 15 minutes.

% Convert the estimated NODDI parameters into volumetric parameter maps
SaveParamsAsNIfTI('FittedParams.mat', 'NODDI_roi.mat', 'bgmask.nii', 'NODDI_')
% This function converts the fitted parameters (1st argument) into NIfTI 
% formatted volumes with the same spatial dimension as the original image, 
% specified by the brain mask (3rd argument). The function also requires 
% as input the roi file (2nd argument). In addition, you also need to 
% specify a prefix to the output volumes with the final argument. 
% (Prior to Version 0.9, you also need to input the model, which is now 
% stored alongside the fitted parameter file.)






