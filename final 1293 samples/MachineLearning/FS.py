#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2018/5/8 8:36
# @Author  : YuanJing
# @File    : FS.py
"""
Description：
    1.首先计算Relief、Fisher-score、Gini_index三个得分值，归一化后叠加到一起得到最终分值
    2.根据叠加后的分值对特征值进行排序
    3.根据排序结果逐个增加特征值，得到BER平均值及std的变化曲线并进行保存
        注意：1.对于AdaBoost算法，只能区分1，-1标签
                  2. 对于逻辑回归，第一项是常数项，在每折中添加
    4.大段注释掉的是自己按照文献公式复原的相关性系数和Fisher-score得分
    5.最终进行特则选择使用的是scikit-feature包
OutputMessage:
    sorteigen：记录的是各个方法得到的特征值评分以及根据整合后评分进行排序后的结果，
                        对应FSsort.csv
    sortFeatures:是根据sorteigen的结果对全部特征值进行排序，用于最终模型的训练，对应
                        sortedFeature.csv文件
    writemean：逐步增加特征值个数时，当前算法对应的BER平均值
    writestd：逐步增加特征值个数时，当前算法对应的BER标准差
"""
import global_new  as gl
import numpy as np
import  pandas as pd
import sklearn.feature_selection as sfs
import  ann
from sklearn.neural_network import MLPClassifier  # import the classifier
from sklearn.model_selection import StratifiedKFold
import matplotlib.pyplot as plt
from sklearn.metrics import confusion_matrix
import adaboost
import logRegres as LR
from sklearn import svm



featurenames=gl.colnames[0:80]
datamat=gl.dataMat#归一化到[-1,1]的
dataFrame=pd.DataFrame(datamat,columns=featurenames)
labelmat=gl.labelMat
[n_sample,n_feature]=np.shape(datamat)
"""
#_-------------------------只针对AdaBoost算法，区分-1，1-------#
for i in range(len(labelmat)):
     if labelmat[i]==0:
         labelmat[i]=-1;#adaboost只能区分-1和1的标签
"""

"""
#------------------calculate the Correlation criterion——YJ---------------------#
mean_feature=np.mean(datamat,axis=0)#average of each feature
[n_sample,n_feature]=np.shape(datamat)
mean_label=np.mean(labelmat)#average of label


corup=[]
cordown=[]
label_series=labelmat-mean_label
for j in range(n_feature):
   tmp_up=sum((datamat[:,j]-mean_feature[j])*label_series)
   corup.append(tmp_up)

    #计算相关系数公式的分母
   down_feature=np.square(datamat[:,j]-mean_feature[j])
   down_label=np.square(label_series)
   tmp_down=np.sqrt(sum(down_feature)*sum(down_label))
   cordown.append(tmp_down)

corvalue=np.array(corup)/np.array(cordown)
corvalue=np.abs(corvalue)


#------------calculate the Fisher criterion——YJ--------------#
df=np.column_stack((datamat,labelmat))#特征和标签合并

positive_set=df[df[:,80]==1]
negtive_set=df[df[:,80]==0]
positive_feaure=positive_set[:,0:80]#正类的特征
negtive_feature=negtive_set[:,0:80]#负类的特征
[sample_pos,feature_pos]=np.shape(positive_feaure)
[sample_neg,feature_neg]=np.shape(negtive_feature)

mean_pos=np.mean(positive_feaure,axis=0)#正类中，各特征的平均值
mean_neg=np.mean(negtive_feature,axis=0)#负类中，各样本的平均值
std_pos=np.std(positive_feaure,ddof=1,axis=0)#正类中各特征值的标准差
std_neg=np.std(negtive_feature,ddof=1,axis=0)#负类中各特征值的标准差
F_up=np.square(mean_pos-mean_feature)+np.square(mean_neg-mean_feature)
F_down=np.square(std_pos)+np.square(std_neg)
F_score=F_up/F_down
"""
#------------calculate the FS score with scikit-feature package--------------#
from skfeature.function.similarity_based import fisher_score
from skfeature.function.similarity_based import reliefF
from skfeature.function.statistical_based import gini_index

Relief = reliefF.reliefF(datamat, labelmat)
Fisher= fisher_score.fisher_score(datamat, labelmat)
gini= gini_index.gini_index(datamat,labelmat)
gini=-gini
FSscore=np.column_stack((Relief,Fisher,gini))#合并三个分数

FSscore=ann.preprocess(FSscore)
FinalScore=np.sum(FSscore,axis=1)
FS=np.column_stack((FSscore,FinalScore))
FS_nor=ann.preprocess(FS)#将最后一列联合得分归一化
FS=pd.DataFrame(FS_nor,columns=["Relief", "Fisher","gini","FinalScore"],index=featurenames)
# FS.to_csv("F:\Githubcode\AdaBoost\myown\FSscore.csv")


sorteigen=FS.sort_values(by='FinalScore',ascending=False,axis=0)
sorteigen.to_csv('FSsort.csv')
#------------crossalidation with ann--------------#
meanfit=[]#用来存储逐渐增加特征值过程中，不同数目特征值对应的BER平均值
stdfit=[]#用来存储逐渐增加特征值过程中，不同数目特征值对应的BER标准差

names=sorteigen.index#排序之后的特征值

#sortfeatures用于具体的算法当中，提取前面的n个特征值，此处没有用到
sortfeatures=dataFrame[names]#对特征值进行排序
sortfeatures['classlabel']=labelmat
sortfeatures.to_csv('sortedFeature.csv')#对全部特征值进行排序的结果

for i in range(80):
    print("第%s个参数："%(i+1))
    index=names[0:i+1]
    dataMat=dataFrame.loc[:,index]
    dataMat=np.array(dataMat)
    labelMat=labelmat

    skf = StratifiedKFold(n_splits=10)
    scores=[]#用来存十折中每一折的BER得分
    mean_score=[]#第i个特征值交叉验证后BER的平均值
    std_score=[]#第i个特征值交叉验证后BER的标准差
    k=0;

    for train, test in skf.split(dataMat, labelMat):
        k=k+1
        # print("%s %s" % (train, test))
        print("----第%s次交叉验证：" %k)
        train_in = dataMat[train]
        test_in = dataMat[test]
        train_out = labelMat[train]
        test_out = labelMat[test]

        n_train=np.shape(train_in)[0]
        n_test=np.shape(test_in)[0]
        """
        #---------对于LR的特殊处理
        addones_train = np.ones(( n_train,1))
        train_in = np.c_[addones_train, train_in]#给训练集数据加1列1

        addones_test=np.ones((n_test,1))
        test_in=np.c_[addones_test,test_in]#给测试集加一列1
        """

        from imblearn.over_sampling import RandomOverSampler
        train_in, train_out = RandomOverSampler().fit_sample(train_in, train_out)

        """
        clf=svm.SVC(C=50,kernel='rbf',gamma='auto',shrinking=True,probability=True,
             tol=0.001,cache_size=1000,verbose=False,
             max_iter=-1,decision_function_shape='ovr',random_state=None)
        clf.fit(train_in,train_out)#train the classifier
        test_predict=clf.predict(test_in)#test the model with trainset
         """

#====================逻辑回归=============================================        
#        trainWeights = LR.stocGradAscent1(train_in, train_out, 500)
#        len_test = np.shape(test_in)[0]
#        test_predict = []
#        for i in range(len_test):
#            test_predict_tmp = LR.classifyVector(test_in[i, :], trainWeights)
#            test_predict.append(test_predict_tmp)
#        test_predict=np.array(test_predict)
 #=========================================================================

         # --------------------ANN----------------------------------#
        clf = MLPClassifier(hidden_layer_sizes=(i + 1,), activation='tanh',
                            shuffle=True, solver='sgd', alpha=1e-6, batch_size=3,
                            learning_rate='adaptive')
        clf.fit(train_in, train_out)
        test_predict = clf.predict(test_in)
        """        

     #----------------------AdaBoost----------------------------------#
        classifierArray, aggClassEst = adaboost.adaBoostTrainDS(train_in, train_out, 200);
        test_predict, prob_test = adaboost.adaClassify(test_in, classifierArray);  # 测试测试集 
         """
        tn, fp, fn, tp = confusion_matrix(test_out, test_predict).ravel()
        BER=0.5*((fn/(tp+fn))+(fp/(tn+fp)))
        scores.append(BER)
    mean_score = np.mean(scores)
    std_score=np.std(scores)

    meanfit.append(mean_score)
    stdfit.append(std_score)
#============================================================================== 

meanfit = np.array(meanfit)
writemean=pd.DataFrame(meanfit)
writemean.to_csv('F:/Githubcode/AdaBoost/myown/annmean.csv', encoding='utf-8', index=True)


stdfit=np.array(stdfit)
writestd=pd.DataFrame(stdfit)
writestd.to_csv('F:/Githubcode/AdaBoost/myown/annfit.csv', encoding='utf-8', index=True)

fig, ax1 = plt.subplots()
line1 = ax1.plot(meanfit, "b-", label="BER")
ax1.set_xlabel("Number of features")
ax1.set_ylabel("BER", color="b")
plt.show()


print("test")
