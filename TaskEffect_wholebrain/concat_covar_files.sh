#!/bin/bash

# concat two runs covariate files and concat all subjects mean FD into one file

subjects='005 006 008 009 011 012 017 018 019 023 027 028 029 030 037 045 047 055 056 058 060 061 063 068 075 077 078 085 087 088 093 095 098 099 103 104 106 111 115 116 118 119 123 125 136 140 147 154 155 157 158 162 172 173 175 176 182 186 187 188 189 190 191 194 198 199 200 201 203 205 208 211 212 220 222 999'

waves='5'


# concat all subjects and sessions mean FD into one file
rm /path/Mean_FD.txt
cat /path/*.txt > Mean_FD.txt

for sub in ${subjects}; do
	for wave in ${waves}; do
		# remove filed attempt at concat
		rm /path/sub-${sub}sess00${wave}/sub-${sub}sess${wave}-concat-censor_03.1D
		rm /path/sub-${sub}sess00${wave}/sub-${sub}sess00${wave}_confounds.txt

		#concat two runs censor files

		rm /path/sub-${sub}sess00${wave}/sub-${sub}sess${wave}-Planets-concat-censor_03.1D

		mv /path/sub-${sub}sess00${wave}/sub-${sub}sess${wave}-Planets1-censor_03.1D /path/sub-${sub}sess00${wave}/sub-${sub}sess00${wave}-Planets1-censor_03.1D

		mv /path/sub-${sub}sess00${wave}/sub-${sub}sess${wave}-Planets2-censor_03.1D /path/sub-${sub}sess00${wave}/sub-${sub}sess00${wave}-Planets2-censor_03.1D


		cat /path/sub-${sub}sess00${wave}/sub-${sub}sess00${wave}-Planets*-censor_03.1D > /path/sub-${sub}sess00${wave}/sub-${sub}sess00${wave}-Planets-concat-censor_03.1D
		# concat two runs orvec confound files
		rm /path/sub-${sub}sess00${wave}/sub-${sub}sess00${wave}-Planets-concat-confounds.txt
		cat /path/sub-${sub}sess00${wave}/sub-${sub}sess00${wave}_Planets*_confounds.txt > /path/sub-${sub}sess00${wave}/sub-${sub}sess00${wave}-Planets-concat-confounds.txt

	done
done
