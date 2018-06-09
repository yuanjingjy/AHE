#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2018/4/26 8:56
# @Author  : YuanJing
# @File    : global_new.py
'''
因为此部分每种算法的处理流程都是一样的：提取数据、哑变量处理、归一化，所以
此处将数据当作全局变量进行处理，各个算法直接调用
提取特征值，对哑变量性别进行处理，然后进行归一化
0——79列是特征值，最后一列是标签
'''


import pandas as pd
import  numpy as np
import  ann
global dataMat
global labelMat

#建立全局变量，提取全部特征值

###read the data###
data = pd.read_csv('final_eigen.csv')
dummy_sex=data['sex']#哑变量
dummies=pd.get_dummies(dummy_sex,prefix='sex')#哑变量变换
data=data.drop(['sex'],axis=1)#去掉原来的列
datawithdummy = dummies.join(data)#矩阵进行拼接
colnames=datawithdummy.keys()
dataSet=np.array(datawithdummy)
dataSet[:,0:80]=ann.preprocess(dataSet[:,0:80])
dataSet[:,0:80]=ann.preprocess1(dataSet[:,0:80])


#print("test")
