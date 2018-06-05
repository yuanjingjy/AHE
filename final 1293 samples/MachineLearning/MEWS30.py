#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2018/5/22 8:06
# @Author  : YuanJing
# @File    : MEWS30.py

import pandas as pd
import numpy as np
import sklearn.metrics  as skm
from imblearn.over_sampling import RandomOverSampler
from sklearn.model_selection import StratifiedKFold
import ann
import matplotlib.pyplot as plt
from sklearn.model_selection import StratifiedShuffleSplit



data=pd.read_csv('MEWS.csv')
data_complete=data.fillna(data.mean())

hr=data_complete[['hr_max','hr_mean']]
rr=data_complete[['RR_max','RR_mean']]
bp=data_complete[['bp_max','bp_mean']]

mews_hr=[]
mews_rr=[]
mews_bp=[]
mews_gcs=[]
mews_tem=[]

def mews_hr(x):
    mews_hr=[]
    num_sample=np.shape(x)[0]
    for i in range(num_sample):
        if x[i]<40:
            tmp_hr=2
        if (x[i]>=40) & (x[i]<50):
            tmp_hr=1
        if (x[i]>=50) & (x[i]<100):
            tmp_hr=0
        if (x[i]>=100) & (x[i]<110):
            tmp_hr=1
        if (x[i] >=110) & (x[i] <130):
            tmp_hr=2
        if x[i]>=130:
            tmp_hr=3
        mews_hr.append(tmp_hr)
    return mews_hr

def mews_bp(x):
    mews_bp=[]
    num_samples=np.shape(x)[0]
    for i in range(num_samples):
        if x[i]<70:
            tmp_bp=3
        if (x[i]>=70)&(x[i]<80):
            tmp_bp=2
        if(x[i]>=80)&(x[i]<100):
            tmp_bp=1
        if(x[i]>=100)&(x[i]<199):
            tmp_bp=0
        if x[i]>=199:
            tmp_bp=2
        mews_bp.append(tmp_bp)
    return mews_bp

def mews_rr(x):
    mews_rr=[]
    num_samples=np.shape(x)[0]
    for i in range(num_samples):
        if x[i]<9:
            tmp_rr=2
        if (x[i]>=9)&(x[i]<14):
            tmp_rr=0
        if (x[i]>=14)&(x[i]<20):
            tmp_rr=1
        if(x[i]>=20)&(x[i]<29):
            tmp_rr=2
        if(x[i]>=29):
            tmp_rr=3
        mews_rr.append(tmp_rr)
    return mews_rr

def mews_tem(x):
    mews_tem=[]
    n_samples=np.shape(x)[0]
    for i in range(n_samples):
        if (x[i]<35):
            tmp_tem=2
        if (x[i]>=35)&(x[i]<38.4):
            tmp_tem=0
        if x[i]>=38.5:
            tmp_tem=2
        mews_tem.append(tmp_tem)
    return mews_tem

def mews_gcs(x):
    mews_gcs=[]
    n_samples=np.shape(x)[0]
    for i in range(n_samples):
        if (x[i]>=3) &(x[i]<6):
            tmp_gcs=3
        if(x[i]>=6)&(x[i]<9):
            tmp_gcs=2
        if (x[i]>=9)&(x[i]<12):
            tmp_gcs=1
        if(x[i]>=12)&(x[i]<=15):
            tmp_gcs=0
        mews_gcs.append(tmp_gcs)
    return mews_gcs

def maxscore(data1,data2):#传入两列维度一致的数据
    num_samples=np.shape(data1)[0]
    score=[]
    for i in range(num_samples):
        if data1[i]>data2[i]:
            score_tmp=data1[i]
        else:
            score_tmp=data2[i]
        score.append(score_tmp)
    score=np.array(score)
    return score


#-----------计算心率得分-----------#
data_hrmean=data_complete['hr_mean']
mews_hrmean=mews_hr(data_hrmean)

data_hrmax=data_complete['hr_max']
mews_hrmax=mews_hr(data_hrmax)

mews_HR=maxscore(mews_hrmax, mews_hrmean)

#-----------计算bp得分-----------#
data_bpmean=data_complete['bp_mean']
mews_bpmean=mews_bp(data_bpmean)

data_bpmax=data_complete['bp_max']
mews_bpmax=mews_bp(data_bpmax)

mews_BP=maxscore(mews_bpmean,mews_bpmax)

#-----------计算rr得分-----------#
data_rrmean=data_complete['RR_mean']
mews_rrmean=mews_rr(data_rrmean)

data_rrmax=data_complete['RR_max']
mews_rrmax=mews_rr(data_rrmax)

mews_RR=maxscore(mews_rrmean,mews_rrmax)

#-----------计算tem得分-----------#
data_tem=data_complete['mean_tem']

mews_TEM=mews_tem(data_tem)

#-----------计算gcs得分-----------#
data_gcs=data_complete['min_gcs']

mews_GCS=mews_gcs(data_gcs)

MEWS=sum([mews_HR,mews_BP,mews_RR,mews_TEM,mews_GCS])

classlabel=data['classlabel']
# fpr,tpr,thresholds=skm.roc_curve(classlabel,MEWS,pos_label=1)

def binaryclassify(datamat, thresh):#根据阈值进行二分类
    label=[]
    num_sample=np.shape(datamat)[0]
    for i in range(num_sample):
        if (datamat[i] < thresh):
            tmp = 0
        else:
            tmp = 1
        label.append(tmp)
    return label

def findthresh(datamat, label):#根据ROC曲线确定分类阈值
    fpr, tpr, thresholds = skm.roc_curve(label, datamat, pos_label=1)
    n=np.shape(fpr)[0]
    x=np.linspace(0, n-1, n)
    # plt.plot(x,fpr,'b-',x,(1-tpr),'r-')
    # plt.show()
    arg=abs(fpr+tpr-1)
    minindex = np.argmin(arg)
    thresh=thresholds[minindex]
    return thresh


def evaluatemodel(y_true, y_predict,Mews):
    from sklearn.metrics import confusion_matrix
    from sklearn.metrics import roc_auc_score
    tn, fp, fn, tp = confusion_matrix(y_true, y_predict).ravel();
    TPR = tp / (tp + fn);
    SPC = tn / (fp + tn);
    PPV = tp / (tp + fp);
    NPV = tn / (tn + fn);
    ACC = (tp + tn) / (tn + fp + fn + tp);

    AUC = roc_auc_score(y_true, Mews)
    BER = 0.5 * ((1 - TPR) + (1 - SPC))

    return [[TPR, SPC, PPV, NPV, ACC, AUC, BER]], [[tn, fp, fn, tp]]

dataMat=MEWS
labelMat=classlabel
thre=[]
evaluate_test=[]
evaluate_train=[]

# skf=StratifiedShuffleSplit(n_splits=5)
skf = StratifiedKFold(n_splits=10)
for train, test in skf.split(dataMat, labelMat):
    print("%s %s" % (train, test))
    train_in = dataMat[train]
    test_in = dataMat[test]
    train_out = labelMat[train]
    test_out = labelMat[test]
    train_in=train_in.reshape(-1,1)#只有一个特征值，过采样前特殊处理
    train_in, train_out = RandomOverSampler().fit_sample(train_in, train_out)

    thre_tmp=findthresh(train_in,train_out)
    thre.append(thre_tmp)

    train_predict = binaryclassify(train_in,thre_tmp)
    test_predict=binaryclassify(test_in,thre_tmp)

    test1, test2 = ann.evaluatemodel(train_out, train_predict, train_in)  # test model with trainset
    evaluate_train.extend(test1)

    test3, test4 = ann.evaluatemodel(test_out, test_predict, test_in)  # test model with testset
    evaluate_test.extend(test3)

Result_test = pd.DataFrame(evaluate_test, columns=['TPR', 'SPC', 'PPV', 'NPV', 'ACC', 'AUC', 'BER'])
Result_test.to_csv('BER/BER_MEWS.csv')
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


evaluate_train_mean = np.mean(evaluate_test, axis=0)


print('test')