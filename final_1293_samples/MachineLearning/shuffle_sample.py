# -*- coding: utf-8 -*-
"""
Created on Tue Nov 14 16:32:49 2017

@author: Administrator
"""

import ann
import numpy as np

dataMat,labelMat=ann.loadDataSet('final_data.txt')
 
dataset=np.c_[dataMat,labelMat]
np.array(dataset)

# dataset1=dataset[:,0:11]
# dataset2=dataset[:,44:84]


# dataset=np.c_[dataset1,dataset2]

dataSet=np.random.permutation(dataset)