#!/bin/bash


subjects='005sess005 006sess005 009sess005 011sess005 012sess005 017sess005 018sess005 019sess005 023sess005 027sess005 028sess005 029sess005 030sess005 037sess005 045sess005 047sess005 055sess005 056sess005 058sess005 060sess005 061sess005 063sess005 068sess005 075sess005 077sess005 078sess005 085sess005 087sess005 088sess005 093sess005 095sess005 098sess005 099sess005 103sess005 104sess005 106sess005 111sess005 115sess005 116sess005 118sess005 119sess005 123sess005 125sess005 136sess005 140sess005 147sess005 154sess005 155sess005 157sess005 158sess005 162sess005 172sess005 173sess005 175sess005 176sess005 182sess005 186sess005 187sess005 188sess005 189sess005 190sess005 191sess005 194sess005 198sess005 199sess005 200sess005 201sess005 203sess005 205sess005 208sess005 211sess005 212sess005 220sess005 222sess005 999sess005'

#008sess005


runs='1 2'

for sub in ${subjects}; do
	for run in ${runs}; do
		cd /path/sub-${sub}/func
		3dBlurToFWHM -FWHM 8 -input sub-${sub}_task-Planets${run}_space-MNI152NLin2009cAsym_desc-postproc_bold.nii.gz -prefix sub-${sub}_task-Planets${run}_space-MNI152NLin2009cAsym_desc-postproc_bold_blur8 -mask /path/sub-${sub}/func/sub-${sub}_task-Planets${run}_space-MNI152NLin2009cAsym_desc-brain_mask.nii.gz
	done
done
