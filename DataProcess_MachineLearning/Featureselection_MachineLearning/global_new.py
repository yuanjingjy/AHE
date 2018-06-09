#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2018/4/26 8:56
# @Author  : YuanJing
# @File    : global_new.py
"""
Description：
    提取特征值，对哑变量性别进行处理，然后进行归一化
    0——79列是特征值，最后一列是标签

输入信息：
    final_eigen.csv:特征值矩阵
输出结果：
    framefile: 处理完哑变量后的，归一化到[0,1]之间的各个特征值及标签
"""


import pandas as pd
import  numpy as np
import  ann
global dataMat
global labelMat
global colnames
global framefile
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
# dataSet[:,0:80]=ann.preprocess1(dataSet[:,0:80])

dataMat=dataSet[:,0:80]
labelMat=np.array(datawithdummy['Label'])


framefile=pd.DataFrame(dataSet,columns=colnames)
#writefile.to_csv("F:/testformean.csv")#归一化之后的结果
print("test")
