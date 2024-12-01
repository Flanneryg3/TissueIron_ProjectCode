#!/usr/bin/env python
# coding: utf-8

# In[ ]:


# AFNI noise orvec Files and censor files for planets glm

#Author: Jessica S. Flannery, 10-11-2024


##############################################
# AFNI deconvolution nusance regressor file info (3dTproject)
##############################################
#pip install xlrd
#pip install openpyxl

#############################################################################################
# Standard imports (i.e., Python builtins) go at the top
import os
import os.path as op
from glob import glob
import numpy as np

# Now third-party imports
import pandas as pd
import xlrd
import openpyxl
import csv
##############################################################################################


waves=['5']

runs=['Planets1', 'Planets2']

subjects=['005', '006', '008', '009', '011', '012', '017', '018', '019', '023', '027', '028', '029', '030', '037', '045', '047', '055', '056', '058', '060', '061', '063', '068', '075', '077', '078', '085', '087', '088', '093', '095', '098', '099', '103', '104', '106', '111', '115', '116', '118', '119', '123', '125', '136', '140', '147', '154', '155', '157', '158', '162', '172', '173', '175', '176', '182', '186', '187', '188', '189', '190', '191', '194', '198', '199', '200', '201', '203', '205', '208', '211', '212', '220', '222', '999']

# saving stim text files to each subject's func folder
func_local = '/path/'
out_dir = '/path/'

for subject in subjects:
	for wave in waves:
		subsess_fd_mean_list=[]
		censor_values=[]
		print('Processing subject: {0} wave {1}'.format(subject, wave))
		func_folder = op.join(func_local, 'sub-{0}sess00{1}'.format(subject, wave), 'func')
		#create output folder for sub (if one doesn't exist)
		sub_output = os.path.join(out_dir, 'sub-{0}sess00{1}'.format(subject, wave))
		if not os.path.exists(sub_output):
			os.makedirs(sub_output)

		for run in runs:
			try:

				print(func_folder)
				# get confound file
				tsv = op.join(func_folder, 'sub-{0}sess00{1}_task-{2}_desc-confounds_timeseries.tsv'.format(subject, wave, run))

    				#check if fmriprep tsv exists
				if os.path.exists(tsv):
					df = pd.read_csv(tsv, delimiter='\t')


					#confounds file: extract cols and write to text file
					confound_cols = ['csf', 'csf_derivative1', 'white_matter', 'white_matter_derivative1',
					'trans_x', 'trans_x_derivative1', 'trans_y', 'trans_y_derivative1',
					'trans_z', 'trans_z_derivative1', 'rot_x', 'rot_x_derivative1',
					'rot_y', 'rot_y_derivative1', 'rot_z', 'rot_z_derivative1']
					confound_df = df[confound_cols]
					confound_output = os.path.join(sub_output, 'sub-{0}sess00{1}_{2}_confounds.txt'.format(subject, wave, run))
        				confound_df.to_csv(confound_output, sep='\t', index=False, header=None)


					#get each subjects mean FD for that run
					FDmean = [df['framewise_displacement'].mean()]
					print(FDmean)
					#append each value to  list
					subsess_fd_mean_list.append(FDmean)

					#make 1s and 0s for censoring for each run
					fd = df['framewise_displacement']
					fd = fd[1:,]
					fd_cens = np.ones(len(fd.index)+1)
					fd_list = []
					for i, tmp_fd in enumerate(fd):
						if float(tmp_fd) > 0.30:
							fd_list.append(i+1)
						else:
							fd_cens[fd_list] = 0
					censor_values.append(fd_cens)
					with open(op.join(sub_output,'sub-{0}sess00{1}-{2}-censor_03.1D'.format(subject, wave, run)), 'a') as fo:
						for tmp in fd_cens:
							fo.write('{0}\n'.format(tmp))
			except:
				print('missing sub-{0}sess{1}run{2}'.format(subject, wave, run))
		# concat run censors and write to one file


		# write list of mean FDs for each session to one file
		FDmean_file = op.join(out_dir, 'sub-{0}sess00{1}-FD_means.txt'.format(subject, wave))
		with open(FDmean_file, "a") as file:
			file.write('{0}'.format(subject) + '\t' + '{0}'.format(wave) + '\t' + str(subsess_fd_mean_list) + '\n')







		# notes


		#concat_censor = op.join(out_dir, 'sub-{0}sess{1}-concat_censor.txt'.format(subject, wave))
		#with open(concat_censor, "a") as file:
			#file.write('{0}'.format(subject) + '\t' + '{0}'.format(wave) + '\t' + str(subsess_fd_mean_list) + '\n')






		#run1_censor_vals = np.genfromtxt(op.join(sub_output,'sub-{0}sess{1}-Planets1-censor_03.1D'.format(subject, wave))
		#run2_censor_vals = np.genfromtxt(op.join(sub_output,'sub-{0}sess{1}-Planets2-censor_03.1D'.format(subject, wave))
		#concat_censor = np.concatenate((run1_censor_vals,run1_censor_vals),axis=1)
		#print(concat_censor)


		#run1_confound_output = os.path.join(sub_output, 'sub-{0}sess00{1}_{2}_confounds.txt'.format(subject, wave, run))
		#run1_confound_output = os.path.join(sub_output, 'sub-{0}sess00{1}_{2}_confounds.txt'.format(subject, wave, run))

		#df = pd.concat([df1, df2])
