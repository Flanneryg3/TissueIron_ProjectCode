#!/bin/bash

#####################################################
# define variables

# extract mean non-zero beta weights for each ROI for each subject and for each contrast
#####################################################
# Jessica S. Flannery


roi_path='/path'
data_path='/path/data/TI_files'
out_dir='/path'


#################################################################################################
#  WAVE 5
#################################################################################################

subjects='001 007 010 013 015 037 043 054 058 059 063 064 067 071 072 077 079 081 089 090 092 097 102 107 110 115 124 126 133 137 138 139 140 144 149 150 151 153 156 157 161 167 169 170 174 178 179 184 185 192 193 196 197 204 206 207 209 210 213 214 215 216 217 218 219 221 226 228'

waves='1 2 3 5'

rm ${out_dir}/*

cd ${out_dir}/

for sub in ${subjects}; do
	for wave in ${waves}; do

		#rm ${out_dir}/TI_00${wave}_BG_${sub}.txt
		#rm ${out_dir}/TI_00${wave}_taskmap_${sub}.txt

		#3dresample -master ${data_path}/wave${wave}/sub-${sub}sess00${wave}_TI.nii -input ${roi_path}/HarvardOxford-sub-maxprob-thr0-1mm.nii -prefix ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-HO-atlas

		#3dresample -master ${data_path}/wave${wave}/sub-${sub}sess00${wave}_median+tlrc.BRIK -input ${roi_path}/planets_sample_ave_glm/B_N_mask+tlrc.BRIK -prefix ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-B_N_mask

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-NA_L_HO+tlrc.BRIK -nzmean ${data_path}/wave${wave}/sub-${sub}sess00${wave}_TI.nii > ${out_dir}/TI_00${wave}_NA_L_${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-NA_R_HO+tlrc.BRIK -nzmean ${data_path}/wave${wave}/sub-${sub}sess00${wave}_TI.nii > ${out_dir}/TI_00${wave}_NA_R_${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-Caud_L_HO+tlrc.BRIK -nzmean ${data_path}/wave${wave}/sub-${sub}sess00${wave}_TI.nii > ${out_dir}/TI_00${wave}_Caud_L_${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-Caud_R_HO+tlrc.BRIK -nzmean ${data_path}/wave${wave}/sub-${sub}sess00${wave}_TI.nii > ${out_dir}/TI_00${wave}_Caud_R_${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-Put_L_HO+tlrc.BRIK -nzmean ${data_path}/wave${wave}/sub-${sub}sess00${wave}_TI.nii > ${out_dir}/TI_00${wave}_Put_L_${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-Put_R_HO+tlrc.BRIK -nzmean ${data_path}/wave${wave}/sub-${sub}sess00${wave}_TI.nii > ${out_dir}/TI_00${wave}_Put_R_${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-GP_L_HO+tlrc.BRIK -nzmean ${data_path}/wave${wave}/sub-${sub}sess00${wave}_TI.nii > ${out_dir}/TI_00${wave}_GP_L_${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-GP_R_HO+tlrc.BRIK -nzmean ${data_path}/wave${wave}/sub-${sub}sess00${wave}_TI.nii > ${out_dir}/TI_00${wave}_GP_R_${sub}.txt

	done
done

###########################################
#put all subjects in one file
###########################################


cd ${out_dir}/

for wave in ${waves}; do

	rm CAT_w${wave}_*_TI_betas.txt


	cat ./TI_00${wave}_NA_L_*.txt > ${out_dir}/CAT_w${wave}_NA_L_TI_betas.txt
	cat ./TI_00${wave}_NA_R_*.txt > ${out_dir}/CAT_w${wave}_NA_R_TI_betas.txt
	cat ./TI_00${wave}_Caud_L_*.txt > ${out_dir}/CAT_w${wave}_Caud_L_TI_betas.txt
	cat ./TI_00${wave}_Caud_R_*.txt > ${out_dir}/CAT_w${wave}_Caud_R_TI_betas.txt
	cat ./TI_00${wave}_Put_L_*.txt > ${out_dir}/CAT_w${wave}_Put_L_TI_betas.txt
	cat ./TI_00${wave}_Put_R_*.txt > ${out_dir}/CAT_w${wave}_Put_R_TI_betas.txt
	cat ./TI_00${wave}_GP_L_*.txt > ${out_dir}/CAT_w${wave}_GP_L_TI_betas.txt
	cat ./TI_00${wave}_GP_R_*.txt > ${out_dir}/CAT_w${wave}_GP_R_TI_betas.txt


done
######################################################
#move final output to easily accessable place
#####################################################
