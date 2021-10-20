import numpy as np
import matplotlib.pyplot as plt
# include if using a Jupyter notebook
# %matplotlib inline

# Data
# derived from plot_cor_bar.ncl
# f1 = open("./bar_cor_mme_1_1861.txt","r")
# f2 = open("./bar_cor_err_1_1861.txt","r")
# f3 = open("./bar_cor_mme_2_1861.txt","r")
# f4 = open("./bar_cor_err_2_1861.txt","r")
# print(f1.read())
# eof1_mme =  f1.read()
# eof1_rmse=  f2.read()
# eof2_mme =  f3.read()
# eof2_rmse=  f4.read()
# print(eof1_rmse)

# # [] seems equal to np.array([])
# # eof1_mme = np.array([-0.010763,-0.018341,-0.002718,-0.052688,-0.052091, 0.080558])
eof1_mme = [  0.058357, 0.033965, 0.098350,-0.044699]#,-0.072066, 0.083840]
eof1_rmse= [ 61.849434,38.928204,86.037750,49.719101]#,72.038841,79.176117] # greater than 95 is significant
eof2_mme = [  0.076009, 0.158892, 0.123965, 0.019260]#, 0.249898, 0.166840]
eof2_rmse= [ 74.592728,98.342361,93.776276,22.712648]#,99.985809,98.818062]
# eof1_mme = [  0.033446, 0.033965,0.063250,-0.042038, -0.069851, 0.097476]
# eof1_rmse= [ 38.381565,38.928204,65.720215,47.139843,70.530769,85.681000] # greater than 95 is significant
# eof2_mme = [  0.059271, 0.158892,0.095749, 0.014781,  0.245525, 0.064155]
# eof2_rmse= [ 62.592453,98.342361,84.955147,17.527134,99.981316,66.407585]
# # eof1_1950_mme = [-0.046720,-0.082875,-0.048298,-0.139640,-0.268270, 0.043208]
# # eof1_1950_rmse= [ 0.061269, 0.080237, 0.079141, 0.086337, 0.206127, 0.243446]
# # eof2_1950_mme = [ 0.073241, 0.108714, 0.064740, 0.146061, 0.263556, 0.018744]
# # eof2_1950_rmse= [ 0.044379, 0.057560, 0.071518, 0.050495, 0.189411, 0.246761]
# print(eof2_rmse)
eof1_mme


# Define labels, positions, bar heights and error bar heights
labels = ['CMIP5 MME', 'CMIP6 MME','CMIP5 PLUS', 'CMIP5 MINUS']#,'CESM2','CESM2-CMIP5']
x_pos = np.arange(len(labels))
width = 0.35  # the width of the bars
CTEs = [0.073241, 0.108714, 0.064740, 0.146061, 0.263556, 0.018744]
error = [0.044379, 0.057560, 0.071518, 0.050495, 0.189411, 0.246761]

# Build the plot
fig, ax = plt.subplots()

ax.bar(x_pos - width/2, eof1_mme, width, label='PC1',linewidth=0,alpha=0.5)#,labelsize=20,
                # yerr=eof1_rmse,
                # align='center',
                # ecolor='black',
                # capsize=5)

ax.bar(x_pos + width/2, eof2_mme, width, label='PC2',linewidth=0,alpha=0.5)#,labelsize=20,
                # yerr=eof2_rmse,
                # align='center',
                # alpha=0.5,
                # ecolor='black',
                # capsize=5)

# rects3 = ax.bar(x_pos - width/2, eof1_1950_mme, width, label='PC1(1950)',
#                 yerr=eof1_rmse,
#                 align='center',
#                 alpha=0.5,
#                 ecolor='black',
#                 capsize=5)
#
# rects4 = ax.bar(x_pos + width/1, eof2_1950_mme, width, label='PC2(1950)',
#                 yerr=eof2_rmse,
#                 align='center',
#                 alpha=0.5,
#                 ecolor='black',
#                 capsize=5)

ax.set_ylabel('Regression Coefficient',size='large')
ax.tick_params(axis='both', labelsize='large')
ax.set_xticks(x_pos)
ax.set_xticklabels(labels,size='large')
ax.set_title('Relation between PDV and external forcing modes',size='large')
ax.legend(fontsize='large')
# ax.yaxis.grid(True)
eof1_rmse= [ 38.381565,38.928204,65.720215,47.139843,70.530769,85.681000] # greater than 95 is significant
eof2_rmse= [ 62.592453,98.342361,84.955147,17.527134,99.981316,66.407585]
eof1_s = eof1_mme
eof2_s = eof2_mme
for i in range(len(eof1_mme)):
    if eof1_rmse[i] >= 95:
        eof1_s[i] = eof1_mme[i]
    else:
        eof1_s[i] = np.nan

for i in range(len(eof2_mme)):
    if eof2_rmse[i] >= 95:
        eof2_s[i] = eof2_mme[i]
    else:
        eof2_s[i] = np.nan

print(eof1_s)
print(eof2_s)
# ax.bar_label(rects1, labels=['','','','','',''], padding=3)
ax.bar(x_pos - width/2, eof1_s, width, linewidth=1.5, edgecolor='black', color='none')
# ax.bar_label(rects2, labels=['','*','','','*',''], padding=3)
ax.bar(x_pos + width/2, eof2_s, width, linewidth=1.5, edgecolor='black', color='none')

# changing it's width and height
fig.set_size_inches(8.5, 5)

# Save the figure and show
plt.tight_layout()
plt.savefig('bar_plot_with_error_bars.png')
plt.show()
