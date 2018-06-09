#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2017/12/20 8:54
# @Author  : YuanJing
# @File    : MIV.py

'''
Description:
    本程序针对于神经网络算法，用平均影响值的方式对特征值进行筛选：
        1.平均影响值计算过程：首先用全部特征值训练出神经网络模型，然后将当个特征值
            的数值增加10%和减小10%，分别用训练出的神经网络模型进行预测，两个预测结果之间的
            差值对应的就是该特征值的影响值，对全部样本上的影响值求平均即得到该样本的平均影响值
        2.得到各个特征值对应的平均影响值后特征值进行排序，平均影响值即代表该特征的重要程度
        3. 按照特征重要性排序结果，逐个增加特征值的方式比较不同特征子集对应的模型预测结果
Input：
    sql_eigen.csv:全部样本的特征值矩阵
'''

import pandas as pd
import  numpy as np
import  ann
from sklearn.neural_network import MLPClassifier  # import the classifier
from imblearn.under_sampling import RandomUnderSampler
from sklearn.model_selection import StratifiedKFold
import matplotlib.pyplot as plt

pandas_data = pd.read_csv('sql_eigen.csv')
data = pandas_data.fillna(np.mean(pandas_data))#缺失数据插补

data['age'][data['age'] > 200] = 91.4#年龄大于200岁的用中位数91.4代替
data2 = data.drop(['hr_cov', 'bpsys_cov', 'bpdia_cov', 'bpmean_cov', 'pulse_cov', 'resp_cov', 'spo2_cov','height'], axis=1)#去掉没用的列
dataSet=np.array(data2)
dataSet[:,0:78]=ann.preprocess(dataSet[:,0:78])#归一化到[0,1]
dataSet[:,0:78]=ann.preprocess1(dataSet[:,0:78])#归一化到[-1,1]

dataMat=dataSet[:,0:78]
labelMat=dataSet[:,78]
# dataMat=np.array(dataMat)
# labelMat=np.array(labelMat)

'''
计算各个特征值的平均影响值
'''
clf = MLPClassifier(hidden_layer_sizes=(78,), activation='tanh',
                    shuffle=True, solver='sgd', alpha=1e-6, batch_size=5,
                    learning_rate='adaptive')
clf.fit(dataMat,labelMat)
IV=[]
for i in range(78):
    tmpdata=dataMat.copy()
    tmpdata[:, i]=tmpdata[:,i]*0.8
    train_dec=tmpdata
    pre_dec = clf.predict_proba(train_dec)
    tmpdata[:,i]=tmpdata[:,i]*11/8
    pre_inc = clf.predict_proba(tmpdata)

    IVi=pre_dec[:,0]-pre_inc[:,0]
    meanIV=np.mean(IVi)
    IV.append(meanIV)
IV=np.array(IV)
IV=np.abs(IV)
print("test")

'''
根据平均影响值的计算结果，对各个特征值进行排序，排序的结果为sorteigen.csv
'''
datacolname= data2.drop(['class_label'], axis=1)#带名称的特征向量
eigencounts = pd.DataFrame([IV],index=['score'],columns=datacolname.keys())
sorteigen = eigencounts.sort_values(by='score',ascending=False, axis=1)
# sorteigen.to_csv("F:/sorteigenMIV")
# sorteigen.to_csv('F:/MIVsort.csv', encoding='utf-8', index=True)

eigenwithname = pd.DataFrame(dataMat,columns=datacolname.keys())#用来从中按名称提取特征值

"""
计算逐个增加特征值时，模型预测准确率的变化过程，因为计算速度太慢，这里只用了5折交叉验证
"""
fitscore=[]
for i in range(78):
    col=sorteigen.keys()#按照IV进行排序后特征值的
    index=col[0:i+1]
    dataMat=eigenwithname.loc[:,index]
    dataMat=np.array(dataMat)

    skf = StratifiedKFold(n_splits=5)
    scores=[]
    for train, test in skf.split(dataMat, labelMat):
        print("%s %s" % (train, test))
        train_in = dataMat[train]
        test_in = dataMat[test]
        train_out = labelMat[train]
        test_out = labelMat[test]
        clf = MLPClassifier(hidden_layer_sizes=(i+1,), activation='tanh',
                            shuffle=True, solver='sgd', alpha=1e-6, batch_size=1,
                            learning_rate='adaptive')
        clf.fit(train_in, train_out)
        score = clf.score(test_in,test_out)
        scores.append(score)
    scores = np.array(scores)
    mean_score = np.mean(scores)
    fitscore.append(mean_score)
fitscore = np.array(fitscore)#逐步增加特征值后ACC的计算结果

'''
画图表示逐步增加特征值时预测准确率的变化过程
'''
fig, ax1 = plt.subplots()
line1 = ax1.plot(fitscore, "b-", label="score")
ax1.set_xlabel("Number of features")
ax1.set_ylabel("Scores", color="b")
plt.show()
