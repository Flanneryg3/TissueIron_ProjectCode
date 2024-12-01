#!/bin/bash

#####################################################
# define variables

# extract mean non-zero beta weights for each ROI for each subject and for each contrast
#####################################################
# Jessica S. Flannery


roi_path='/path'
data_path='/path'
out_dir='/path'


#################################################################################################
#  WAVE 5
#################################################################################################



subjects='005 006 008 009 011 012 017 018 019 023 027 028 029 030 037 045 047 055 056 058 060 061 063 068 075 077 078 085 087 088 093 095 098 099 103 104 106 111 115 116 118 119 123 125 136 140 147 154 155 157 158 162 172 173 175 176 182 186 187 188 189 190 191 194 198 199 200 201 203 205 208 211 212 220 222 999'

waves='5'

rm ${out_dir}/*

cd ${out_dir}/

for sub in ${subjects}; do
	for wave in ${waves}; do

	#rm ${out_dir}/BB_NB-*-${sub}.txt
	#rm ${out_dir}/SB_NB-*-${sub}.txt
	#rm ${out_dir}/SB_NB-*-${sub}.txt


	# make ROIS

	rm /path/native_space_atlas/sub-${sub}sess005-HO-atlas*
	3dresample -master ${data_path}/sub-${sub}sess00${wave}/func/sub-${sub}sess005_task-Planets1_space-MNI152NLin2009cAsym_desc-postproc_bold_blur8+tlrc.BRIK -input /path/HarvardOxford-sub-maxprob-thr0-1mm.nii -prefix /path/native_space_atlas/sub-${sub}sess005-HO-atlas

	rm ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-NA_L_HO_glm+tlrc.*
	3dcalc -a /path/native_space_atlas/sub-${sub}sess005-HO-atlas+tlrc.BRIK -expr 'equals(a,11)' -prefix /path/native_space_atlas/sub-${sub}sess005-NA_L_HO_glm

	rm ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-NA_R_HO_glm+tlrc.*
	3dcalc -a /path/native_space_atlas/sub-${sub}sess005-HO-atlas+tlrc.BRIK -expr 'equals(a,21)' -prefix /path/native_space_atlas/sub-${sub}sess005-NA_R_HO_glm

	rm ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-Caud_L_HO_glm+tlrc.*
	3dcalc -a /path/native_space_atlas/sub-${sub}sess005-HO-atlas+tlrc.BRIK -expr 'equals(a,5)' -prefix /path/native_space_atlas/sub-${sub}sess005-Caud_L_HO_glm

	rm ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-Caud_R_HO_glm+tlrc.*
	3dcalc -a /path/native_space_atlas/sub-${sub}sess005-HO-atlas+tlrc.BRIK -expr 'equals(a,16)' -prefix /path/native_space_atlas/sub-${sub}sess005-Caud_R_HO_glm

	rm ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-Put_L_HO_glm+tlrc.*
	3dcalc -a /path/native_space_atlas/sub-${sub}sess005-HO-atlas+tlrc.BRIK -expr 'equals(a,6)' -prefix /path/native_space_atlas/sub-${sub}sess005-Put_L_HO_glm

	rm ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-Put_R_HO_glm+tlrc.*
	3dcalc -a /path/native_space_atlas/sub-${sub}sess005-HO-atlas+tlrc.BRIK -expr 'equals(a,17)' -prefix /path/native_space_atlas/sub-${sub}sess005-Put_R_HO_glm

	rm ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-GP_L_HO_glm+tlrc.*
	3dcalc -a /path/native_space_atlas/sub-${sub}sess005-HO-atlas+tlrc.BRIK -expr 'equals(a,7)' -prefix /path/native_space_atlas/sub-${sub}sess005-GP_L_HO_glm

	rm ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-GP_R_HO_glm+tlrc.*
	3dcalc -a /path/native_space_atlas/sub-${sub}sess005-HO-atlas+tlrc.BRIK -expr 'equals(a,18)' -prefix /path/native_space_atlas/sub-${sub}sess005-GP_R_HO_glm


########################################################################################################################################################################################################
########################################################################################################################################################################################################


		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-NA_L_HO_glm+tlrc.BRIK -nzmean ${data_path}/sub-${sub}sess00${wave}/func/sub-${sub}-Planets-REML+tlrc.BRIK'[7]' > ${out_dir}/BB-NA_L-${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-NA_R_HO_glm+tlrc.BRIK -nzmean ${data_path}/sub-${sub}sess00${wave}/func/sub-${sub}-Planets-REML+tlrc.BRIK'[7]'> ${out_dir}/BB-NA_R-${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-Caud_L_HO_glm+tlrc.BRIK -nzmean ${data_path}/sub-${sub}sess00${wave}/func/sub-${sub}-Planets-REML+tlrc.BRIK'[7]' > ${out_dir}/BB-Caud_L-${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-Caud_R_HO_glm+tlrc.BRIK -nzmean ${data_path}/sub-${sub}sess00${wave}/func/sub-${sub}-Planets-REML+tlrc.BRIK'[7]' > ${out_dir}/BB-Caud_R-${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-Put_L_HO_glm+tlrc.BRIK -nzmean ${data_path}/sub-${sub}sess00${wave}/func/sub-${sub}-Planets-REML+tlrc.BRIK'[7]' > ${out_dir}/BB-Put_L-${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-Put_R_HO_glm+tlrc.BRIK -nzmean ${data_path}/sub-${sub}sess00${wave}/func/sub-${sub}-Planets-REML+tlrc.BRIK'[7]' > ${out_dir}/BB-Put_R-${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-GP_L_HO_glm+tlrc.BRIK -nzmean ${data_path}/sub-${sub}sess00${wave}/func/sub-${sub}-Planets-REML+tlrc.BRIK'[7]' > ${out_dir}/BB-GP_L-${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-GP_R_HO_glm+tlrc.BRIK -nzmean ${data_path}/sub-${sub}sess00${wave}/func/sub-${sub}-Planets-REML+tlrc.BRIK'[7]' > ${out_dir}/BB-GP_R-${sub}.txt


########################################################################################################################################################################################################
########################################################################################################################################################################################################


		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-NA_L_HO_glm+tlrc.BRIK -nzmean ${data_path}/sub-${sub}sess00${wave}/func/sub-${sub}-Planets-REML+tlrc.BRIK'[9]' > ${out_dir}/SB-NA_L-${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-NA_R_HO_glm+tlrc.BRIK -nzmean ${data_path}/sub-${sub}sess00${wave}/func/sub-${sub}-Planets-REML+tlrc.BRIK'[9]' > ${out_dir}/SB-NA_R-${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-Caud_L_HO_glm+tlrc.BRIK -nzmean ${data_path}/sub-${sub}sess00${wave}/func/sub-${sub}-Planets-REML+tlrc.BRIK'[9]' > ${out_dir}/SB-Caud_L-${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-Caud_R_HO_glm+tlrc.BRIK -nzmean ${data_path}/sub-${sub}sess00${wave}/func/sub-${sub}-Planets-REML+tlrc.BRIK'[9]' > ${out_dir}/SB-Caud_R-${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-Put_L_HO_glm+tlrc.BRIK -nzmean ${data_path}/sub-${sub}sess00${wave}/func/sub-${sub}-Planets-REML+tlrc.BRIK'[9]' > ${out_dir}/SB-Put_L-${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-Put_R_HO_glm+tlrc.BRIK -nzmean ${data_path}/sub-${sub}sess00${wave}/func/sub-${sub}-Planets-REML+tlrc.BRIK'[9]' > ${out_dir}/SB-Put_R-${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-GP_L_HO_glm+tlrc.BRIK -nzmean ${data_path}/sub-${sub}sess00${wave}/func/sub-${sub}-Planets-REML+tlrc.BRIK'[9]' > ${out_dir}/SB-GP_L-${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-GP_R_HO_glm+tlrc.BRIK -nzmean ${data_path}/sub-${sub}sess00${wave}/func/sub-${sub}-Planets-REML+tlrc.BRIK'[9]' > ${out_dir}/SB-GP_R-${sub}.txt


########################################################################################################################################################################################################
########################################################################################################################################################################################################

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-NA_L_HO_glm+tlrc.BRIK -nzmean ${data_path}/sub-${sub}sess00${wave}/func/sub-${sub}-Planets-REML+tlrc.BRIK'[11]' > ${out_dir}/AnyBoost-NA_L-${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-NA_R_HO_glm+tlrc.BRIK -nzmean ${data_path}/sub-${sub}sess00${wave}/func/sub-${sub}-Planets-REML+tlrc.BRIK'[11]' > ${out_dir}/AnyBoost-NA_R-${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-Caud_L_HO_glm+tlrc.BRIK -nzmean ${data_path}/sub-${sub}sess00${wave}/func/sub-${sub}-Planets-REML+tlrc.BRIK'[11]' > ${out_dir}/AnyBoost-Caud_L-${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-Caud_R_HO_glm+tlrc.BRIK -nzmean ${data_path}/sub-${sub}sess00${wave}/func/sub-${sub}-Planets-REML+tlrc.BRIK'[11]' > ${out_dir}/AnyBoost-Caud_R-${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-Put_L_HO_glm+tlrc.BRIK -nzmean ${data_path}/sub-${sub}sess00${wave}/func/sub-${sub}-Planets-REML+tlrc.BRIK'[11]' > ${out_dir}/AnyBoost-Put_L-${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-Put_R_HO_glm+tlrc.BRIK -nzmean ${data_path}/sub-${sub}sess00${wave}/func/sub-${sub}-Planets-REML+tlrc.BRIK'[11]' > ${out_dir}/AnyBoost-Put_R-${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-GP_L_HO_glm+tlrc.BRIK -nzmean ${data_path}/sub-${sub}sess00${wave}/func/sub-${sub}-Planets-REML+tlrc.BRIK'[11]' > ${out_dir}/AnyBoost-GP_L-${sub}.txt

		3dROIstats -mask ${roi_path}/native_space_atlas/sub-${sub}sess00${wave}-GP_R_HO_glm+tlrc.BRIK -nzmean ${data_path}/sub-${sub}sess00${wave}/func/sub-${sub}-Planets-REML+tlrc.BRIK'[11]' > ${out_dir}/AnyBoost-GP_R-${sub}.txt





	done
done

###########################################
#put all subjects in one file
###########################################


cd ${out_dir}/

for wave in ${waves}; do

	cd ${out_dir}/

	rm CAT_BB-*_betas.txt


	cat ./BB-NA_L-*.txt > ${out_dir}/CAT_BB-NA_L_betas.txt
	cat ./BB-NA_R-*.txt > ${out_dir}/CAT_BB-NA_R_betas.txt
	cat ./BB-Caud_L-*.txt > ${out_dir}/CAT_BB-Caud_L_betas.txt
	cat ./BB-Caud_R-*.txt > ${out_dir}/CAT_BB-Caud_R_betas.txt
	cat ./BB-Put_L-*.txt > ${out_dir}/CAT_BB-Put_L_betas.txt
	cat ./BB-Put_R-*.txt > ${out_dir}/CAT_BB-Put_R_betas.txt
	cat ./BB-GP_L-*.txt > ${out_dir}/CAT_BB-GP_L_betas.txt
	cat ./BB-GP_R-*.txt > ${out_dir}/CAT_BB-GP_R_betas.txt


	rm CAT_SB-*_betas.txt

	cat ./SB-NA_L-*.txt > ${out_dir}/CAT_SB-NA_L_betas.txt
	cat ./SB-NA_R-*.txt > ${out_dir}/CAT_SB-NA_R_betas.txt
	cat ./SB-Caud_L-*.txt > ${out_dir}/CAT_SB-Caud_L_betas.txt
	cat ./SB-Caud_R-*.txt > ${out_dir}/CAT_SB-Caud_R_betas.txt
	cat ./SB-Put_L-*.txt > ${out_dir}/CAT_SB-Put_L_betas.txt
	cat ./SB-Put_R-*.txt > ${out_dir}/CAT_SB-Put_R_betas.txt
	cat ./SB-GP_L-*.txt > ${out_dir}/CAT_SB-GP_L_betas.txt
	cat ./SB-GP_R-*.txt > ${out_dir}/CAT_SB-GP_R_betas.txt

	rm CAT_AnyBoost-*_betas.txt

	cat ./AnyBoost-NA_L-*.txt > ${out_dir}/CAT_AnyBoost-NA_L_betas.txt
	cat ./AnyBoost-NA_R-*.txt > ${out_dir}/CAT_AnyBoost-NA_R_betas.txt
	cat ./AnyBoost-Caud_L-*.txt > ${out_dir}/CAT_AnyBoost-Caud_L_betas.txt
	cat ./AnyBoost-Caud_R-*.txt > ${out_dir}/CAT_AnyBoost-Caud_R_betas.txt
	cat ./AnyBoost-Put_L-*.txt > ${out_dir}/CAT_AnyBoost-Put_L_betas.txt
	cat ./AnyBoost-Put_R-*.txt > ${out_dir}/CAT_AnyBoost-Put_R_betas.txt
	cat ./AnyBoost-GP_L-*.txt > ${out_dir}/CAT_AnyBoost-GP_L_betas.txt
	cat ./AnyBoost-GP_R-*.txt > ${out_dir}/CAT_AnyBoost-GP_R_betas.txt



done
######################################################
#move final output to easily accessable place
#####################################################
