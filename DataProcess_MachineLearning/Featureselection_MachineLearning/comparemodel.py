#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2018/5/29 16:39
# @Author  : YuanJing
# @File    : comparemodel.py
''''
Description:
    1. 本程序主要比较同一评价指标对于不同分类算法的结果
    2. 最后绘制箱线图进行表示，横轴表示四种机器学习算法及MEWS评分，
        纵轴表示某一评价指标
'''

import  numpy as np
import  pandas as pd
import  matplotlib.pyplot as plt

#加载评价指标结果数据集，_ks、_min、 _all分别和MEWS进行比较
adaboost=pd.read_csv('BER/BER_AdaBoost_ks.csv')
ann=pd.read_csv('BER/BER_ANN_ks.csv')
logistic=pd.read_csv('BER/BER_LR_ks.csv')
svm=pd.read_csv('BER/BER_SVM_ks.csv')
mews=pd.read_csv('BER/BER_MEWS.csv')

#提取出出各方法的TPR列并合并
TPR=pd.DataFrame()
TPR['ANN']=ann['TPR']
TPR['LR']=logistic['TPR']
TPR['SVM']=svm['TPR']
TPR['AdaBoost']=adaboost['TPR']
TPR['MEWS']=mews['TPR']
TPR=TPR*100#最终结果单位用（%）

SPC=pd.DataFrame()
SPC['ANN']=ann['SPC']
SPC['LR']=logistic['SPC']
SPC['SVM']=svm['SPC']
SPC['AdaBoost']=adaboost['SPC']
SPC['MEWS']=mews['SPC']
SPC=SPC*100

PPV=pd.DataFrame()
PPV['ANN']=ann['PPV']
PPV['LR']=logistic['PPV']
PPV['SVM']=svm['PPV']
PPV['AdaBoost']=adaboost['PPV']
PPV['MEWS']=mews['PPV']
PPV=PPV*100

NPV=pd.DataFrame()
NPV['ANN']=ann['NPV']
NPV['LR']=logistic['NPV']
NPV['SVM']=svm['NPV']
NPV['AdaBoost']=adaboost['NPV']
NPV['MEWS']=mews['NPV']
NPV=NPV*100

ACC=pd.DataFrame()
ACC['ANN']=ann['ACC']
ACC['LR']=logistic['ACC']
ACC['SVM']=svm['ACC']
ACC['AdaBoost']=adaboost['ACC']
ACC['MEWS']=mews['ACC']
ACC=ACC*100

AUC=pd.DataFrame()
AUC['ANN']=ann['AUC']
AUC['LR']=logistic['AUC']
AUC['SVM']=svm['AUC']
AUC['AdaBoost']=adaboost['AUC']
AUC['MEWS']=mews['AUC']
AUC=AUC*100

BER=pd.DataFrame()
BER['ANN']=ann['BER']
BER['LR']=logistic['BER']
BER['SVM']=svm['BER']
BER['AdaBoost']=adaboost['BER']
BER['MEWS']=mews['BER']
BER=BER*100

#画箱线图
plt.figure(1)
AUC.boxplot()#直接用DataFrame的boxplot()功能绘制箱线图，这样自动加载横轴
plt.ylim(0,100)
# plt.xlabel("Models")
plt.ylabel("AUC(%)")
plt.show()

print('test')