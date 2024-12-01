#!/bin/sh

#SBATCH --job-name=tat2
#SBATCH -p general
#SBATCH -N 1
#SBATCH --time=40:00:00
#SBATCH --mem=5g
#SBATCH -n 1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=flannerj@ad.unc.edu
#SBATCH --error=/path/slurm_%x_%j.err
#SBATCH --output=/path/slurm_%x_%j.out

# Tat2 script
# Adapted by Tehya Drummond and Arianna Cascone for BrainMAP
## March 2023

# Adapted by Jessica Flannery for NT data
## Jan. 2024

## Add module
module add afni/20.3.00

#Run tat2 attempt

export PATH="$PATH:/path/lncdtools"


subjects='007 013 015 037 043 058 059 064 067 071 072 077 079 081 090 092 097 102 110 133 137 139 140 153 157 161 170 184 185 192 193 196 197 204 207 209 210 213 214 215 218 221 226 228'
#'005 030 078 116 162 198 006 037 085 118 172 199 008 045 087 119 173 200 009 047 088 123 175 201 011 055 093 125 176 203 012 056 095 133 182 205 017 058 098 136 186 208 018 060 099 140 187 211 019 061 103 147 188 212 023 063 104 154 189 220 027 068 106 155 190 222 028 075 111 157 191 999 029 077 115 158 194 001 003 004 007 010 013 015 022 024 025 026 032 038 040 043 044 046 048 054 057 059 062 064 065 067 070 071 072 074 079 080 081 083 084 086 089 090 092 096 097 102 107 108 110 112 114 117 122 124 126 128 130 131 132 133 134 135 137 138 139 141 142 143 144 145 148 149 150 151 153 156 160 161 163 166 167 169 170 174 178 179 184 185 192 193 196 197 204 206 207 209 210 213 214 215 216 217 218 219 221 226 228'

#'005 030 078 116 162 198 006 037 085 118 172 199 008 045 087 119 173 200 009 047 088 123 175 201 011 055 093 125 176 203 012 056 095 133 182 205 017 058 098 136 186 208 018 060 099 140 187 211 019 061 103 147 188 212 023 063 104 154 189 220 027 068 106 155 190 222 028 075 111 157 191 999 029 077 115 158 194 001 003 004 007 010 013 015 022 024 025 026 032 038 040 043 044 046 048 054 057 059 062 064 065 067 070 071 072 074 079 080 081 083 084 086 089 090 092 096 097 102 107 108 110 112 114 117 122 124 126 128 130 131 132 133 134 135 137 138 139 141 142 143 144 145 148 149 150 151 153 156 160 161 163 166 167 169 170 174 178 179 184 185 192 193 196 197 204 206 207 209 210 213 214 215 216 217 218 219 221 226 228'

waves='1 2 3 5'

#runs='Shapes1 Shapes2 CupsSelf'

# inputs preprocessed in a minimal fashion via fmriprep:
# slice-timing and head motion correction, skull stripping, coregistration to the structural image, and nonlinear warping to MNI space.


for sub in ${subjects}; do
	for w in ${waves}; do
		cd /path/data/wave${w}

		tat2 \
		-output "/path/TI_files/wave${w}/sub-${sub}sess00${w}_TI.nii" \
                -mask_rel 's/preproc_bold.nii/brain_mask.nii/' \
                -censor_rel 's/preproc_bold.nii/censor_03.1D/'  \
                -median_time \
                -median_vol \
                -no_voxscale \
                -verbose \
		/path/data/wave${w}/sub-${sub}sess00${w}_task-*_space-MNI152NLin2009cAsym_desc-preproc_bold.nii




        done

done
