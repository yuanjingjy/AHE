# -*- coding: utf-8 -*-
"""
Created on Wed Sep  6 08:42:39 2017

@author: YuanJing
本程序为神经网络算法的运行程序
输入参数：
    sortedFeatures.csv:按照重要性排序后的特征值

重要的中间变量：
    train_predict：训练后的模型对训练集的预测标签
    test_predict：训练后的模型对测试集的预测标签
    proba_train：模型对训练集的预测概率值（相加为1的两列）
    proba_test：模型对测试集的预测概率值（相加为1的两列）

输出结果：
    evaluate_train：各折训练集的各个评价指标，最后两行分别为平均值及标准差
    evaluate_test：各折测试集的各个评价指标，最后两行分别为平均值及标准差
    prenum_train：各折训练集混淆矩阵的结果
    prenum_test：各折测试集混淆矩阵的结果
"""


import ann
import  pandas as pd
import numpy as np
from imblearn.over_sampling import RandomOverSampler
from sklearn.model_selection import StratifiedKFold
import matplotlib.pyplot as plt

data=pd.read_csv('sortedFeature.csv')#排序后的特征值
labelMat=data['classlabel']
# dataMat=data.ix[:,0:80]#全部特征值
# dataMat=data.ix[:,0:67]#BER最小对应的特征值子集
dataMat=data.ix[:,0:8]#特征值个数最少的特征值子集
dataMat=ann.preprocess(dataMat)#归一化到[0,1]
dataMat=ann.preprocess1(dataMat)#归一化到[-1,1]
neuo=np.shape(dataMat)[1]#隐含层中神经元的数目和特征值个数一致

evaluate_train=[]
evaluate_test=[]
prenum_train=[]
prenum_test=[]

skf = StratifiedKFold(n_splits=10)#十折交叉验证
kfold=1
for train, test in skf.split(dataMat, labelMat):
    print("第%s 次交叉验证：" %kfold )
    train_in = dataMat[train]
    test_in=dataMat[test]
    train_out=labelMat[train]
    test_out=labelMat[test]
    train_in, train_out = RandomOverSampler().fit_sample(train_in, train_out)#平衡测试集样本
    train_predict,test_predict,proba_train,proba_test=ann.ANNClassifier(neuo,train_in,train_out,test_in)
    proba_train=proba_train[:,1]
    proba_test=proba_test[:,1]
    test1,test2=ann.evaluatemodel(train_out,train_predict,proba_train)#求训练集测试集的评价指标
    evaluate_train.extend(test1)#训练集的各评价指标，百分比
    prenum_train.extend(test2)#测试结果中，混淆矩阵对应的四个数

    test3,test4=ann.evaluatemodel(test_out,test_predict,proba_test)#test model with testset
    evaluate_test.extend(test3)
    prenum_test.extend(test4)

    kfold=kfold+1#十折交叉验证的次数

#对于测试集，保存模型预测的结果的评价指标，并绘制箱线图
Result_test=pd.DataFrame(evaluate_test,columns=['TPR','SPC','PPV','NPV','ACC','AUC','BER'])
Result_test.to_csv('BER/BER_ANN_ks.csv')
Result_test.boxplot()
plt.show()

#对于测试集的评价指标，计算十折后，各个评价指标的平均值及标准差
mean_train=np.mean(evaluate_train,axis=0)
std_train=np.std(evaluate_train,axis=0)
evaluate_train.append(mean_train)
evaluate_train.append(std_train)

#对于测试集，计算十折后，各评价指标的平均值及标准差
mean_test=np.mean(evaluate_test,axis=0)
std_test=np.std(evaluate_test,axis=0)
evaluate_test.append(mean_test)
evaluate_test.append(std_test)

#格式转换，用于显示
evaluate_train=np.array(evaluate_train)
evaluate_test=np.array(evaluate_test)
prenum_train=np.array(prenum_train)
prenum_test=np.array(prenum_test)


print("view the variable")