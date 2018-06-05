# -*- coding: utf-8 -*-
"""
Created on Wed Sep  6 08:42:39 2017

@author: YJ
"""

##该脚本是对特征选择方法的实验过程，其中应用的方法包括：
#1.稳定性方法，基于L1正则化
#2.基于平均精确度的方法，将每个特征值的数值随机打乱，看对预测结果的影响
#3.基于卡方、互信息等方法的selectKBest方法，及其重要性排序、写入csv文件
#4.RFE方法，递归特征减小法，并实验了选择不同数目的变量对预测结果的影响
import ann
import numpy as np
from sklearn.model_selection import StratifiedShuffleSplit
from sklearn.model_selection import StratifiedKFold
from sklearn.neural_network import MLPClassifier#import the classifier
from sklearn.feature_selection import  RFE#
from sklearn import svm
import  pandas as  pd#python data analysis
import  sklearn.feature_selection as sfs
import matplotlib.pyplot as plt
from sklearn import preprocessing

pandas_data=pd.read_csv('sql_eigen.csv')
sql_eigen=pandas_data.fillna(np.mean(pandas_data))

data =sql_eigen.iloc[:,0:85]
# data.iloc[:,84][data.iloc[:,84]>200]=91
data['age'][data['age']>200]=91
data2=data.drop(['hr_cov', 'bpsys_cov', 'bpdia_cov', 'bpmean_cov', 'pulse_cov', 'resp_cov', 'spo2_cov'],axis=1)

label=sql_eigen['class_label']

dataMat1=np.array(data2)
labelMat=np.array(label)##the final label

data01 = ann.preprocess(dataMat1)
# dataMat = ann.preprocess1(data01)
dataMat=np.array(data01)## The final dataset

#dataandlabel=pd.DataFrame(labelMat,columns=['label'])
#dataandlabel.to_csv('F:/label.csv', encoding='utf-8', index=True)
for i in range(len(labelMat)):
    if labelMat[i] == -1:
        labelMat[i] = 0;  # adaboost只能区分-1和1的标签

evaluate_train = []
evaluate_test = []
prenum_train = []
prenum_test  = []
weight=[]
######################################################
#########较稳定的特征选择方法，嵌入式，正则化#######
from sklearn.linear_model import RandomizedLasso
from sklearn.linear_model import RandomizedLogisticRegression

X = dataMat
Y = labelMat
names = data2.keys()

rlasso = RandomizedLogisticRegression()
rlasso.fit(X, Y)

print ("Features sorted by their score:")

scores1=rlasso.scores_
compareeigen=pd.DataFrame([scores1],index=['score'],columns=data2.keys())

sorteigen=compareeigen.sort_values(by='score',ascending=False,axis=1)
select_fea=sorteigen[: 1:29]
names1=select_fea.keys()
sorteigen.to_csv('D:/stable.csv', encoding='utf-8', index=True)

print('test')
######################################################
#########利用神经网络，依次将各个特征值随机化，看对预测结果的影响#####################
from sklearn.metrics import accuracy_score
from collections import defaultdict
clf = MLPClassifier(hidden_layer_sizes=(10,), activation='tanh',
                         shuffle=True, solver='sgd', alpha=1e-6, batch_size=1,
                         learning_rate='adaptive')
scores=[]

skf = StratifiedKFold(n_splits=10)
for train, test in skf.split(dataMat, labelMat):
    # ==============================================================================
    # skf=StratifiedShuffleSplit(n_splits=10)
    # for train,test in skf.split(dataMat,labelMat):
    # ==============================================================================
    print("%s %s" % (train, test))
    train_in = dataMat[train]
    test_in = dataMat[test]
    train_out = labelMat[train]
    test_out = labelMat[test]
    clf.fit(train_in, train_out)
    acc=clf.score(test_in,test_out)
    score = []
    for i in range(dataMat.shape[1]):
        x_t=test_in;
        np.random.shuffle(x_t[:,i])#将某一特征的值打乱
        shuff_acc=clf.score(x_t,test_out)
        score.append((acc-shuff_acc)/acc)
    scores.append(score)
scores=np.array(scores)
scores=np.mean(scores,axis=0)
compareeigen=pd.DataFrame([scores],index=['score'],columns=data2.keys())

sorteigen=compareeigen.sort_values(by='score',ascending=False,axis=1)

sorteigen.to_csv('D:/each.csv', encoding='utf-8', index=True)

svmscore = pd.DataFrame(scores)
svmscore = svmscore.sort_values(by='score', ascending=False, axis=1)
svmscore.to_csv('D:/anntest.csv', encoding='utf-8', index=True)
print("test")





######################################################
#########select features with selectKBest######################
# selectmodel=sfs.SelectKBest(sfs.mutual_info_classif)
# selectmodel.fit(dataMat,labelMat)
# selectedeigen=selectmodel.get_support()
# selectedscore=selectmodel.scores_
# selectedpvalue=selectmodel.pvalues_
# score=ann.rowscale(selectedscore)
# # pvalue=ann.rowscale(selectedpvalue)
# compareeigen=pd.DataFrame([score,selectedeigen],index=['score','YN'],columns=data.keys())
# sorteigen=compareeigen.sort_values(by='score',ascending=False,axis=1)
# sorteigen.to_csv('F:/ftest.csv', encoding='utf-8', index=True)
# datatoplot=sorteigen.iloc[0]
# plt.figure()
# datatoplot.plot(title='Score of chi2 for eigens',legend=True,stacked=True,alpha=0.7)
# plt.show()
# dataMat_new=sfs.SelectKBest(sfs.chi2,k=50).fit_transform(dataMat,labelMat)
# # indices=sfs.SelectKBest(sfs.chi2,k=50).get_support()
# dataMat=dataMat_new
######################################################


######################################################
##########RFE &RFECV###########
clf1=MLPClassifier(hidden_layer_sizes=(90,), activation='tanh',
                      shuffle=True,solver='sgd',alpha=1e-6,batch_size=5,
                      learning_rate='adaptive')

clf=svm.SVC(C=2,kernel='linear',gamma='auto',shrinking=True,probability=True,
             tol=0.001,cache_size=200,class_weight='balanced',verbose=False,
             max_iter=-1,decision_function_shape='ovr',random_state=None)
score =[]
###the loop markdown the the estimator score when select different num of features
# for i in range(78):
#     rfe = RFE(estimator=clf, n_features_to_select=i+1, step=1)
#     rfe.fit(dataMat, labelMat)
#     selectedeigen = rfe.support_
#     selectedscore = rfe.score(dataMat, labelMat)
#     score.append(selectedscore)
#
# score=np.array(score)
# dataandlabel=pd.DataFrame(score,columns=['label'])
# dataandlabel.to_csv('F:/score.csv', encoding='utf-8', index=True)
#
# # selectedpvalue=selectmodel.pvalues_
# # compareeigen=pd.DataFrame([selectedscore,selectedpvalue,selectedeigen],index=['score','pvalue','YN'],columns=data.keys())
# # sorteigen=compareeigen.sort_values(by='score',ascending=False,axis=1)
# num_features = rfe.n_features_
# select_feature = rfe.support_
# rank_fea = rfe.ranking_
# model = rfe.estimator_
#
# compareeigen=pd.DataFrame([rank_fea,selectedeigen],index=['rank','YN'],columns=data.keys())
# sorteigen=compareeigen.sort_values(by='rank',ascending=False,axis=1)
# #
# data_mat=dataMat(select_feature)
#######################################################


skf = StratifiedKFold(n_splits=10)
for train, test in skf.split(dataMat, labelMat):
    # ==============================================================================
    # skf=StratifiedShuffleSplit(n_splits=10)
    # for train,test in skf.split(dataMat,labelMat):
    # ==============================================================================
    print("%s %s" % (train, test))
    train_in = dataMat[train]
    test_in = dataMat[test]
    train_out = labelMat[train]
    test_out = labelMat[test]
    train_predict, test_predict, proba_train, proba_test,weights = ann.SVMClassifier(train_in, train_out, test_in)#SVM
    weight.append(weights)
    # train_predict, test_predict, proba_train, proba_test = ann.ANNClassifier(train_in, train_out, test_in)#ANN

    proba_train = proba_train[:, 1]
    proba_test = proba_test[:, 1]
    test1, test2 = ann.evaluatemodel(train_out, train_predict, proba_train)  # test model with trainset
    evaluate_train.extend(test1)
    prenum_train.extend(test2)

    test3, test4 = ann.evaluatemodel(test_out, test_predict, proba_test)  # test model with testset
    evaluate_test.extend(test3)
    prenum_test.extend(test4)

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
prenum_train = np.array(prenum_train)
prenum_test = np.array(prenum_test)

evaluate_train_mean = np.mean(evaluate_test, axis=0)
# np.array(test_important)
weight=np.array(weight)
svmscore = pd.DataFrame(weights, index=['score'],columns=data2.keys())
svmscore=svmscore.sort_values(by='score',ascending=False,axis=1)
svmscore.to_csv('D:/svmtest.csv', encoding='utf-8', index=True)
weight=np.array(weight)
print("view the variable")