#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2018/5/25 16:34
# @Author  : YuanJing
# @File    : testSVM.py

import ann
import pandas as pd
import numpy as np
from imblearn.over_sampling import RandomOverSampler
from sklearn.model_selection import StratifiedKFold
import matplotlib.pyplot as plt


data = pd.read_csv('sortedFeature.csv')
labelMat = data['classlabel']
# dataMat=data.ix[:,0:80]
dataMat = data.ix[:, 0:11]
dataMat = ann.preprocess(dataMat)
# dataMat = ann.preprocess1(dataMat)

evaluate_train = []
evaluate_test = []
prenum_train = []
prenum_test = []

skf = StratifiedKFold(n_splits=10)
for train, test in skf.split(dataMat, labelMat):
    print("%s %s" % (train, test))
    train_in = dataMat[train]
    test_in = dataMat[test]
    train_out = labelMat[train]
    test_out = labelMat[test]
    train_in, train_out = RandomOverSampler().fit_sample(train_in, train_out)
    train_predict, test_predict, proba_train, proba_test = ann.SVMClassifier(train_in, train_out, test_in)
    proba_train = proba_train[:, 1]
    proba_test = proba_test[:, 1]
    test1, test2 = ann.evaluatemodel(train_out, train_predict, proba_train)  # test model with trainset
    evaluate_train.extend(test1)
    prenum_train.extend(test2)

    test3, test4 = ann.evaluatemodel(test_out, test_predict, proba_test)  # test model with testset
    evaluate_test.extend(test3)
    prenum_test.extend(test4)

Result_test = pd.DataFrame(evaluate_test, columns=['TPR', 'SPC', 'PPV', 'NPV', 'ACC', 'AUC', 'BER'])
Result_test.to_csv('BER/BER_SVM_ks.csv')
Result_test.boxplot()
plt.show()

mean_train = np.mean(evaluate_train, axis=0)
std_train = np.std(evaluate_train, axis=0)
evaluate_train.append(mean_train)
evaluate_train.append(std_train)

mean_test = np.mean(evaluate_test, axis=0)
std_test = np.std(evaluate_test, axis=0)
evaluate_test.append(mean_test)
evaluate_test.append(std_test)

evaluate_train = np.array(evaluate_train)
evaluate_test = np.array(evaluate_test)
prenum_train = np.array(prenum_train)
prenum_test = np.array(prenum_test)

evaluate_train_mean = np.mean(evaluate_test, axis=0)
# np.array(test_important)
print("view the variable")