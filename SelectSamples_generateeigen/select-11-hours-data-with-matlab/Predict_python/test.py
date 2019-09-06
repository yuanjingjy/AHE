#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Author  : yuanjing
# @File    : preprocess.py
# @Time    : 2018/12/14 11:06
import pandas as pd
import numpy as np
from sklearn.pipeline import Pipeline, FeatureUnion
from sklearn.linear_model import SGDClassifier
from sklearn.model_selection import RandomizedSearchCV
from sklearn.model_selection import GridSearchCV
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import OneHotEncoder,QuantileTransformer,FunctionTransformer,MinMaxScaler
from sklearn.impute import SimpleImputer
from sklearn.compose import ColumnTransformer
from sklearn.svm import SVC
from sklearn.metrics import roc_auc_score,accuracy_score
from time import time
from sklearn.neural_network import MLPClassifier
from sklearn.ensemble import AdaBoostClassifier
from sklearn.pipeline import make_pipeline
from sklearn.base import BaseEstimator,TransformerMixin
import os,random,shutil
from sklearn.model_selection import cross_val_score
import matplotlib.pyplot as plt
from hyperopt import fmin, tpe, hp, STATUS_OK, Trials, partial, space_eval
from sklearn.base import BaseEstimator,TransformerMixin

train_path = 'D:/01袁晶/AHEdata/processed_2019/c_final_eigen/trainset/'
test_path = 'D:/01袁晶/AHEdata/processed_2019/c_final_eigen/testset/'

def convert_data(path):
    pathdir = os.listdir(path)  #文件原始路径
    filenumber = len(pathdir)

    for name in pathdir:
        data = pd.read_csv(path+name,names=None,index_col=None,header=None)
        subject_name = data.iloc[:,-1]#提取出名称列单独处理
        drop_col = data.columns[len(data.columns) - 1]
        datamat = data.drop([drop_col],axis=1)#删掉最后一列，剩下的都是数值特征
        subjectid_tmp = []
        for values in subject_name:
            tmp = int(values[1:6])
            subjectid_tmp.append(tmp)
        datamat['subject_id'] = subjectid_tmp
        datamat.to_csv(path+name,index=None)
        print('test')


# convert_data(train_path)
convert_data(test_path)





    # eigen_number_train = pd.read_csv('D:/01袁晶/AHEdata/processed_2019/c_final_eigen/trainset/30_180.csv')#
    # eigen_number_test = pd.read_csv('D:/01袁晶/AHEdata/processed_2019/c_final_eigen/testset/30_180.csv')#
    # eigen_clinic = pd.read_csv('D:/01袁晶/Githubcode/AHE/SelectSamples_generateeigen/select-11-hours-data-with-matlab/Predict_python/clinicaleigen.csv')
    # eigen_clinic = eigen_clinic[['subject_id','classlabel','age','gender','height','weight_first','gcs_first','30_180']]#
    # data_train = pd.merge(eigen_clinic,eigen_number_train, on='subject_id')#训练集全部数据
    # data_test = pd.merge(eigen_clinic,eigen_number_test, on='subject_id')#测试集全部数据
    #
    # data_train = data_train.drop(['subject_id'],axis=1)  # 训练集全部数据
    # data_test = data_test.drop(['subject_id'],axis=1)#测试集全部数据





print('test')