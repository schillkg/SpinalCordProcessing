#!/bin/bash
# just in case average over time
sct_maths -i mFFE.nii -mean t -o mFFE.nii

# Spinal cord segmentation on T2
sct_deepseg_sc -i mFFE.nii -c t2s
# makes mFFE_seg.nii
#fslview mFFE.nii -l Greyscale /Volumes/GRAID/SpinalCord/SingleSlice/Smith_228819_20160727/mFFE_seg.nii -l Red -t 0.7 &

# Segment gray matter
sct_deepseg_gm -i mFFE.nii

#fslview mFFE.nii -l Greyscale -t 1 mFFE_gmseg.nii -l Red -t 0.7 &

# makes mFFE_gmseg.nii

# Subtract GM segmentation from cord segmentation to obtain WM segmentation
sct_maths -i mFFE_seg.nii -sub mFFE_gmseg.nii -o mFFE_wmseg.nii

# Compute mean dMRI from dMRI data
sct_maths -i dmri.nii -mean t -o dmri_mean.nii
# Segment SC on mean dMRI data
# Note: This segmentation does not need to be accurate-- it is only used to create a mask around the cord
# sct_propseg -i dmri_mean.nii -c dwi
# Create mask (for subsequent cropping)
# sct_create_mask -i dmri_mean.nii -p dmri_mean_seg.nii -size 35mm
# Crop data for faster processing
# sct_crop_image -i dmri.nii.gz -m mask_dmri_mean.nii.gz -o dmri_crop.nii.gz

 # Motion correction (moco)
sct_dmri_moco -i dmri_crop.nii -bvec bvecs.txt

# Segment SC on motion-corrected mean dwi data
sct_propseg -i dwi_moco_mean.nii.gz -c dwi
# Check results
#fslview dwi_moco_mean.nii -l Greyscale ./dwi_moco_mean_seg.nii -l Red -t 0.7 &

