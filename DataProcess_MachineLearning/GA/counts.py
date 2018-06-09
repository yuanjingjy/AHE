#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2017/12/20 14:45
# @Author  : YuanJing
# @File    : counts.py

'''
按照遗传算法的排序结果，将特征值逐步增加带入到神经网络中看预测结果
'''

import pandas as pd
import  numpy as np
import  ann
from sklearn.neural_network import MLPClassifier  # import the classifier
from imblearn.under_sampling import RandomUnderSampler
from sklearn.model_selection import StratifiedKFold
import matplotlib.pyplot as plt
import  global_new as gl

dataSet=gl.dataSet
colnames=gl.colnames
result = pd.read_csv('garesult2018.csv',header=None)
garesult=np.array(result)
counts=np.sum(result,axis=0)
counts=np.array(counts)
eigencounts=pd.DataFrame([counts],index=['num'],columns=colnames[0:80])
sorteigen=eigencounts.sort_values(by='num',ascending=False,axis=1)

#根据遗传算法的运行结果对特征值的重要性进行排序的结果，只有特征值名称和GA过程中被选中的次数
sorteigen.to_csv('F:/2018new/GAsort.csv', encoding='utf-8', index=True)

dataMat=dataSet[:,0:80]
labelMat=dataSet[:,80]

eigenwithname = pd.DataFrame(dataMat,columns=colnames[0:80])#带名称的特征值矩阵

#############此段程序用于提取遗传算法得到的34个特征值
# col=sorteigen.keys()
# index=col[0:34+1]
# dataMat=eigenwithname.loc[:,index]
# dataMat['label']=labelMat
# dataMat.to_csv('F:/eigen_GA.csv', encoding='utf-8', index=True)
#############################################
fitscore=[]
col=sorteigen.keys()
for i in range(80):
    print("第%s个参数：",i+1)
    index=col[0:i+1]
    dataMat=eigenwithname.loc[:,index]
    dataMat=np.array(dataMat)

    skf = StratifiedKFold(n_splits=5)
    scores=[]
    for train, test in skf.split(dataMat, labelMat):
        # print("%s %s" % (train, test))
        print("----第%s次交叉验证：")
        train_in = dataMat[train]
        test_in = dataMat[test]
        train_out = labelMat[train]
        test_out = labelMat[test]

        from imblearn.over_sampling import RandomOverSampler
        train_in, train_out = RandomOverSampler().fit_sample(train_in, train_out)

        clf = MLPClassifier(hidden_layer_sizes=(i+1,), activation='tanh',
                            shuffle=True, solver='sgd', alpha=1e-6, batch_size=1,
                            learning_rate='adaptive')
        clf.fit(train_in, train_out)
        score = clf.score(test_in,test_out)
        scores.append(score)
    scores = np.array(scores)
    mean_score = np.mean(scores)
    fitscore.append(mean_score)
fitscore = np.array(fitscore)
writescore=pd.DataFrame(fitscore)
writescore.to_csv('F:/2018new/GAScore.csv', encoding='utf-8', index=True)

fig, ax1 = plt.subplots()
line1 = ax1.plot(fitscore, "b-", label="score")
ax1.set_xlabel("Number of features")
ax1.set_ylabel("Scores", color="b")
plt.show()


