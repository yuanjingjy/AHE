# -*- coding: utf-8 -*-
"""
Created on Wed Sep  6 08:25:30 2017

@author: YuanJing
"""


import numpy as np
from sklearn import preprocessing  

"""
加载txt格式的数据文件
"""
def loadDataSet(filename):
    numFeat=len(open(filename).readline().split('\t'))
    dataMat=[];labelMat=[]
    fr=open(filename)
    for line in fr.readlines():
        lineArr=[]
        curLine=line.strip().split('\t')
        for i in range(numFeat-1):
            lineArr.append(float(curLine[i]))
        dataMat.append(lineArr)
        labelMat.append(float(curLine[-1]))
    return dataMat,labelMat
'''
将特征值规范化到[0,1]之间
'''
def preprocess(dataset):#将特征值规范化到[0,1]之间
    min_max_scaler=preprocessing.MinMaxScaler()
    X_train01=min_max_scaler.fit_transform(dataset)
    return X_train01

'''
normalize the data between -1 and 1
'''
def preprocess1(dataset):#normalize the data between -1 and 1
    for i in range(np.shape(dataset)[1]):#column number
        dataset[:,i]=2*dataset[:,i]-1
    return dataset

'''
normalize the data between -1 and 1 according to row
按行归一化，默认的按列
'''
def rowscale(dataset):#normalize the data between -1 and 1 according to row
    mindata=np.min(dataset)
    maxdata=np.max(dataset)
    dataset=(dataset-mindata)/(maxdata-mindata)
    return dataset

"""
Description:
    神经网络分类器
Input:
    trainin:训练集输入数据
    trainout:训练集标签
    testin:测试集输入数据
output:
     train_predict:对训练集数据的预测结果，0，1标签
     test_predict:对测试集数据的预测结果，0，1标签
     proba_train:对训练集数据的预测结果，概率值
     proba_test:对测试集数据的预测结果，概率值
"""
def ANNClassifier(neuo,trainin,trainout,testin):
    from sklearn.neural_network import MLPClassifier#import the classifier
    clf=MLPClassifier(hidden_layer_sizes=(neuo,), activation='tanh',
                      shuffle=True,solver='sgd',alpha=1e-6,batch_size=2,
                      learning_rate='adaptive')
#==============================================================================
#     clf=MLPClassifier(solver='lbfgs',alpha=1e-5,hidden_layer_sizes=(90,1),
#                       random_state=1)#another classifier with the solver='lbfgs'
#==============================================================================
    clf.fit(trainin,trainout)#train the classifier
    #test=clf.coefs_
    train_predict=clf.predict(trainin)#test the model with trainset
    test_predict=clf.predict(testin)#test the model with testset
    proba_train=clf.predict_proba(trainin)
    proba_test=clf.predict_proba(testin)
    return train_predict, test_predict,proba_train,proba_test

"""
Description:
    支持向量机分类器
Input:
    trainin:训练集输入数据
    trainout:训练集标签
    testin:测试集输入数据
output:
     train_predict:对训练集数据的预测结果，0，1标签
     test_predict:对测试集数据的预测结果，0，1标签
     proba_train:对训练集数据的预测结果，概率值
     proba_test:对测试集数据的预测结果，概率值
     weights：各个特征值对应的权重
"""
def SVMClassifier(trainin,trainout,testin):
    from sklearn import svm
    clf=svm.SVC(C=50,kernel='rbf',gamma='auto',shrinking=True,probability=True,
             tol=0.001,cache_size=1000,verbose=False,
             max_iter=-1,decision_function_shape='ovr',random_state=None)
#    clf=svm.LinearSVC()
    clf.fit(trainin,trainout)#train the classifier
    # weights=clf.coef_
    train_predict=clf.predict(trainin)#test the model with trainset
    test_predict=clf.predict(testin)#test the model with testset
    proba_train=clf.predict_proba(trainin)
    proba_test=clf.predict_proba(testin)
    return train_predict, test_predict,proba_train,proba_test

"""
Description:
    分类模型评价指标
Input:
    y_true:实际标签
    y_predict:预测结果
    proba:预测概率值
Output:
     [[TPR,SPC,PPV,NPV,ACC,AUC,BER]]:各评价指标
     [[tn,fp,fn,tp]]:混淆矩阵
"""
def evaluatemodel(y_true,y_predict,proba):
    from sklearn.metrics import confusion_matrix  
#    from sklearn.metrics import accuracy_score
    from sklearn.metrics import roc_auc_score
#    from sklearn.metrics import precision_score
#    from sklearn.metrics import recall_score
    tn, fp, fn, tp =confusion_matrix(y_true,y_predict).ravel();
    TPR=tp/(tp+fn);
    SPC=tn/(fp+tn);
    PPV=tp/(tp+fp);
    NPV=tn/(tn+fn);
    ACC=(tp+tn)/(tn+fp+fn+tp);
    
#    Accuracy=accuracy_score(y_true,y_predict)
    AUC=roc_auc_score(y_true,proba)
#    Precision=precision_score(y_true,y_predict)
#    Recall=recall_score(y_true,y_predict)
    BER=0.5*((1-TPR)+(1-SPC))
    return [[TPR,SPC,PPV,NPV,ACC,AUC,BER]],[[tn,fp,fn,tp]]


    
