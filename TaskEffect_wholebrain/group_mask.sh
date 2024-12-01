#!/bin/bash


#################################################################################################
#  70% group gray matter mask
#################################################################################################
#author: Jessica S. Flannery
subjects='005 030 078 116 162 198 006 037 085 118 172 199 008 045 087 119 173 200 009 047 088 123 175 201 011 055 093 125 176 203 012 056 095 133 182 205 017 058 098 136 186 208 018 060 099 187 211 019 061 103 147 188 212 023 063 104 154 189 220 027 068 106 155 190 222 028 075 111 157 191 999 029 077 115 158 194'


for sub in ${subjects}; do
	# copy GM prob mask to working folder
	cp /path/sub-${sub}sess005/anat/sub-${sub}sess005_space-MNI152NLin2009cAsym_label-GM_probseg.nii.gz ./brain_masks/
	gunzip ./brain_masks/sub-${sub}sess005_space-MNI152NLin2009cAsym_label-GM_probseg.nii.gz

	# put segmentation file in fucntional space
	3dresample -master /path/sub-${sub}sess005/func/sub-${sub}sess005_task-Planets1_space-MNI152NLin2009cAsym_desc-postproc_bold_blur8+tlrc -prefix ./brain_masks/sub-${sub}sess005_temp_GM -input ./brain_masks/sub-${sub}sess005_space-MNI152NLin2009cAsym_label-GM_probseg.nii

	rm ./brain_masks/sub-${sub}sess005_GM_mask_temp*
	#make GM probability segmentation file and mask
	3dcalc -a ./brain_masks/sub-${sub}sess005_temp_GM+tlrc -expr 'step(a)' -prefix ./brain_masks/sub-${sub}sess005_GM_mask_temp


	# copy CSF prob mask to working folder
	cp /path/sub-${sub}sess005/anat/sub-${sub}sess005_space-MNI152NLin2009cAsym_label-CSF_probseg.nii.gz ./brain_masks/
	gunzip ./brain_masks/sub-${sub}sess005_space-MNI152NLin2009cAsym_label-CSF_probseg.nii.gz

	# put segmentation file in fucntional space
	3dresample -master /path/sub-${sub}sess005/func/sub-${sub}sess005_task-Planets1_space-MNI152NLin2009cAsym_desc-postproc_bold_blur8+tlrc -prefix ./brain_masks/sub-${sub}sess005_temp_CSF -input ./brain_masks/sub-${sub}sess005_space-MNI152NLin2009cAsym_label-CSF_probseg.nii

	rm ./brain_masks/sub-${sub}sess005_CSF_mask_temp*
	#make CSF probability segmentation file and mask
	3dcalc -a ./brain_masks/sub-${sub}sess005_temp_CSF+tlrc -expr 'astep(a,0.5)' -prefix ./brain_masks/sub-${sub}sess005_CSF_mask_temp


	# copy CSF prob mask to working folder
	cp /path/sub-${sub}sess005/anat/sub-${sub}sess005_space-MNI152NLin2009cAsym_label-WM_probseg.nii.gz ./brain_masks/
	gunzip ./brain_masks/sub-${sub}sess005_space-MNI152NLin2009cAsym_label-WM_probseg.nii.gz

	# put segmentation file in fucntional space
	3dresample -master /path/sub-${sub}sess005/func/sub-${sub}sess005_task-Planets1_space-MNI152NLin2009cAsym_desc-postproc_bold_blur8+tlrc -prefix ./brain_masks/sub-${sub}sess005_temp_WM -input ./brain_masks/sub-${sub}sess005_space-MNI152NLin2009cAsym_label-WM_probseg.nii

	rm ./brain_masks/sub-${sub}sess005_WM_mask_temp
	#make WM probability segmentation file and mask
	3dcalc -a ./brain_masks/sub-${sub}sess005_temp_WM+tlrc -expr 'astep(a,0.5)' -prefix ./brain_masks/sub-${sub}sess005_WM_mask_temp

	rm ./brain_masks/temp_mask+tlrc*
	rm ./brain_masks/sub-${sub}sess005_GM_mask+tlrc*
	3dcalc -a ./brain_masks/sub-${sub}sess005_GM_mask_temp+tlrc -b ./brain_masks/sub-${sub}sess005_WM_mask_temp+tlrc -expr 'a-b' -prefix ./brain_masks/temp_mask
	3dclac -a ./brain_masks/temp_mask+tlrc -b ./brain_masks/sub-${sub}sess005_CSF_mask_temp+tlrc -expr 'a-b' -prefix ./brain_masks/sub-${sub}sess005_GM_mask

done

rm ./group_GM*70*
rm ./group_CSF_80*
rm ./group_WM_80*

#3dmask_tool -input ./brain_masks/sub-${sub}sess005_GM_mask+tlrc -frac 0.7 -dilate_result 2 -1 -prefix ./group_GM_70
3dmask_tool -input ./brain_masks/*sess005_WM_mask+tlrc* -frac 0.8 -prefix ./group_WM_80
3dmask_tool -input ./brain_masks/*sess005_CSF_mask+tlrc* -frac 0.8 -prefix ./group_CSF_80

3dmask_tool -input ./brain_masks/*sess005_GM_mask_temp+tlrc* -fill_holes -dilate_result 3 -4 -frac 0.7 -prefix ./group_GM_70



#3dcalc -a ./brain_masks/group_GM_temp_70+tlrc -b ./brain_masks/group_CSF_70+tlrc -expr 'a-b' -prefix ./group_GM_70
