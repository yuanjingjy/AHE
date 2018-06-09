# -*- coding: utf-8 -*-
"""
Created on Fri Aug 25 16:09:36 2017

@author: YuanJing
本程序为AdaBoost算法的运行程序
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
import adaboost
import numpy as np
from sklearn.model_selection import StratifiedKFold
import  pandas as pd
import  matplotlib.pyplot as plt
from imblearn.over_sampling import RandomOverSampler


train_in=[];
test_in=[];
train_out=[];
test_out=[];
errnum=[];
evaluate_train=[];
evaluate_test=[];
AUCaaa=[];
fp_train=[];
fp_test=[];
AUCtest=[]

data=pd.read_csv('sortedFeature.csv')
labelArr=data['classlabel']
# dataArr=data.ix[:,0:80]#全部特征值
# dataArr=data.ix[:,0:50]#BER最小时对应的特征值子集
dataArr=data.ix[:,0:9]#最少特征值对应的特征值子集

#数据类型转换
labelArr=np.array(labelArr)
dataArr=np.array(dataArr)

#AdaBoost算法只能识别-1，1标签
for i in range(len(labelArr)):
    if labelArr[i]==0:
        labelArr[i]=-1;#adaboost只能区分-1和1的标签

# dataArr=dataMat
label=labelArr
skf=StratifiedKFold(n_splits=10)
for train,test in skf.split(dataArr,labelArr):
    print("%s %s" % (train, test))
    train.tolist();
    train_in=dataArr[train];
    test_in=dataArr[test];
    train_out=label[train];
    test_out=label[test];
    train_in, train_out = RandomOverSampler().fit_sample(train_in, train_out)#训练集过采样，平衡样本
    classifierArray,aggClassEst=adaboost.adaBoostTrainDS(train_in,train_out,200);

    prediction_train,prob_train=adaboost.adaClassify(train_in,classifierArray);#测试训练集
    prediction_test,prob_test=adaboost.adaClassify(test_in,classifierArray);#测试测试集

    tmp_train,fp_train_tmp=adaboost.evaluatemodel(train_out,prediction_train,prob_train);
    #evaluate_train=np.array(evaluate_train);
    evaluate_train.extend(tmp_train);#训练集结果评估
    fp_train.extend(fp_train_tmp);
    
    tmp_test,fp_test_tmp=adaboost.evaluatemodel(test_out,prediction_test,prob_test);
    evaluate_test.extend(tmp_test);
    fp_test.extend(fp_test_tmp);

"""
#存储十次交叉验证测试集评价指标的运行结果，避免每次运行覆盖结果，此处加了注释
Result_test = pd.DataFrame(evaluate_test, columns=['TPR', 'SPC', 'PPV', 'NPV', 'ACC', 'AUC', 'BER'])
Result_test.to_csv('BER/BER_AdaBoost_ks.csv')
Result_test.boxplot()
plt.show()
"""
mean_train=np.mean(evaluate_train,axis=0)
std_train=np.std(evaluate_train,axis=0)
evaluate_train.append(mean_train)
evaluate_train.append(std_train)

mean_test=np.mean(evaluate_test,axis=0)
std_test=np.std(evaluate_test,axis=0)
evaluate_test.append(mean_test)
evaluate_test.append(std_test)
    
evaluate_train=np.array(evaluate_train);
evaluate_test=np.array(evaluate_test);
fp_train=np.array(fp_train);
fp_test=np.array(fp_test);

print("test")
