#!/bin/bash

#################################################################################################
#  FIRST LEVEL PLANETS REGRESSIONS
#################################################################################################
# authors: Jessica S. Flannery

#
subjects='008'
#'005 006 009 011 012 017 018 019 023 027 028 029 030 037 045 047 055 056 058 060 061 063 068 075 077 078 085 087 088 093 095 098 099 103 104 106 111 115 116 118 119 123 125 136 140 147 154 155 157 158 162 172 173 175 176 182 186 187 188 189 190 191 194 198 199 200 201 203 205 208 211 212 220 222 999'

#################################################################################################
#################################################################################################

for sub in ${subjects}; do

	cd /path/sub-${sub}sess005/func/

	rm *${sub}-Planets-x1D*
	rm *${sub}-Planets-REML*
	rm *xjpeg*

	3dDeconvolve \
	-jobs 6 \
	-mask /path/sub-${sub}sess005/func/sub-${sub}sess005_task-Planets1_space-MNI152NLin2009cAsym_desc-brain_mask.nii.gz \
	-polort A \
	-x1D_stop \
	-input sub-${sub}sess005_task-Planets1_space-MNI152NLin2009cAsym_desc-postproc_bold_blur8+tlrc sub-${sub}sess005_task-Planets2_space-MNI152NLin2009cAsym_desc-postproc_bold_blur8+tlrc \
	-censor /path/sub-${sub}sess005/sub-${sub}sess005-Planets-concat-censor_03.1D \
	-ortvec /path/sub-${sub}sess005/sub-${sub}sess005-Planets-concat-confounds.txt mopars \
	-local_times \
	-allzero_OK \
	-num_stimts 3 \
	-stim_times_AM1 1 /path/planets_onsets/sub-5${sub}/5${sub}_BB.txt 'dmBLOCK(1)' -stim_label 1 BigBoost \
	-stim_times_AM1 2 /path/planets_onsets/sub-5${sub}/5${sub}_SB.txt 'dmBLOCK(1)' -stim_label 2 SmallBoost \
	-stim_times_AM1 3 /path/planets_onsets/sub-5${sub}/5${sub}_NB.txt 'dmBLOCK(1)' -stim_label 3 NoBoost \
	-stim_times_subtract 1 \
	-num_glt 3 \
	-gltsym 'SYM: +BigBoost[0] -NoBoost[0]' \
	-glt_label 1 BB_v_NB \
	-gltsym 'SYM: +SmallBoost[0] -NoBoost[0]' \
	-glt_label 2 SB_v_NB \
	-gltsym 'SYM: +BigBoost[0] +SmallBoost[0] -NoBoost[0]' \
	-glt_label 3 AnyBoost_v_NoBoost \
	-tout -xsave -xjpeg sub-${sub}-Planets-xjpeg -x1D sub-${sub}-Planets-x1D

	3dREMLfit -matrix sub-${sub}-Planets-x1D \
	-GOFORIT \
	-input "sub-${sub}sess005_task-Planets1_space-MNI152NLin2009cAsym_desc-postproc_bold_blur8+tlrc sub-${sub}sess005_task-Planets2_space-MNI152NLin2009cAsym_desc-postproc_bold_blur8+tlrc" \
	-mask /path/sub-${sub}sess005/func/sub-${sub}sess005_task-Planets1_space-MNI152NLin2009cAsym_desc-brain_mask.nii.gz \
	-tout -Rbuck sub-${sub}-Planets-REML -Rvar sub-${sub}-Planets-REMLvar -verb $*
done
