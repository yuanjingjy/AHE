
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2017/12/22 16:40
# @Author  : YuanJing
# @File    : Gridsearch.py

import ann
import  pandas as pd
import numpy as np
from sklearn.neural_network import MLPClassifier  # import the classifier
from sklearn.model_selection import  GridSearchCV
from sklearn.model_selection import StratifiedShuffleSplit
from imblearn.under_sampling import RandomUnderSampler
from sklearn.model_selection import StratifiedKFold

dataset=pd.read_csv("sortedFeatures..csv")
dataset=np.array(dataset)
dataMat=dataset[:, 0:9]
dataMat=ann.preprocess(dataMat)
dataMat=ann.preprocess1(dataMat)
labelMat=dataset[:,9]

layernum=np.arange(1,10,1)
batchsize=np.arange(1,6,1)

parameters={'hidden_layer_sizes':layernum, 'activation':('tanh','logistic','identity','relu'),
            'batch_size':batchsize,'solver':('lbfgs','sgd','adam')}


# clf = MLPClassifier(hidden_layer_sizes=(10,), activation='tanh',
#                     shuffle=True, solver='sgd', alpha=1e-6, batch_size=1,
#                     learning_rate='adaptive')

ann = MLPClassifier()
clf=GridSearchCV(ann,parameters)
clf.fit(dataMat,labelMat)
print("test")
