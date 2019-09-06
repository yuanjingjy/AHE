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
import xgboost as xgb
from xgboost.sklearn import XGBClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import roc_auc_score,accuracy_score
from time import time
from sklearn.neural_network import MLPClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.gaussian_process import GaussianProcessClassifier
from sklearn.gaussian_process.kernels import RBF
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.discriminant_analysis import QuadraticDiscriminantAnalysis
from sklearn.ensemble import AdaBoostClassifier
from sklearn.pipeline import make_pipeline
from sklearn.base import BaseEstimator,TransformerMixin
import os,random,shutil
from sklearn.model_selection import cross_val_score
import matplotlib.pyplot as plt
from hyperopt import fmin, tpe, hp, STATUS_OK, Trials, partial, space_eval
from sklearn.base import BaseEstimator,TransformerMixin
import warnings
warnings.filterwarnings("ignore")
from sklearn.externals import joblib



#定义预处理类
class preprocess(object):
    def transform(self,X,y=None):
        data = X.copy()
        # 处理年龄
        data.loc[data['age'] > 89, 'age'] = 91.4

        # 添加BMI的标签，插值得到的标签为1，否则为0
        data['bmi_label'] = 0
        index_bmi = data[data['height'].isnull() | data['weight_first'].isnull()].index
        data.loc[index_bmi, 'bmi_label'] = 1

        #计算BMI
        height = data['height']
        weight = data['weight_first']
        bmi = weight / ((height / 100) * (height / 100))
        data.drop(['height', 'weight_first'], axis=1, inplace=True)
        data['BMI'] = bmi

        data_processed = data

        return data_processed

    def fit(self,X,y=None):
        return self

class outdata(object):
    """
    Description:
        利用改进zscore方法及Turkey方法识别异常值，两种方法都识别为异常值的认为是异常值
        改进zscore法：根据中位数及距离中位数的偏差来识别异常值
        Turkeys方法：定义IQR=上四分位数-下四分位数
                            上四分位数+3*IQR与下四分位数-3*IQR 范围外的定义为异常值
    Input:
        datain:待判断数据
    Output:
        dataout:将异常值位置置空后输出的矩阵
    """

    def transform(self,datain):
        # 利用改进zscore方法识别异常数据
        diff = datain - np.median(datain, axis=0)  # 原始数据减去中位数
        MAD = np.median(abs(diff), axis=0)  # 上述差值的中位数
        zscore = (0.6745 * diff) / (MAD + 0.0001)  # 计算zscore分数
        zscore = abs(zscore)  # zscore分数的绝对值
        dataout = datain.copy()
        mask_zscore = zscore > 3.5  # zscore分数大于3.5的认为是异常值，mask_score对应位置为1，其余位置为0

        # 利用Turkey方法识别异常值
        Q1, mid, Q3 = np.percentile(datain, (25, 50, 75), axis=0)  # 求上四分位数Q1、中位数mid、下四分位数
        IQR = Q3 - Q1
        out_up = Q3 + 3 * IQR
        out_down = Q1 - 3 * IQR
        mask_precup = np.maximum(datain, out_up) == datain  # 超过上限的异常值
        mask_precdown = np.maximum(datain, out_down) == out_down  # 超过下限的异常值
        mask_prec = np.logical_or(mask_precdown, mask_precup)  # 逻辑或，合并超过上限和下限的异常值

        maskinfo = np.logical_and(mask_prec, mask_zscore)  # 两种方法都识别为异常值的认为是异常值

        dataout[maskinfo] = np.nan  # 异常值位置置空
        return dataout

    def fit(self,X,y=None):
        return self

class preimp(object):
    def transform(self,data):
        # 提取所有的数值型特征的名称
        labelmat = data[['classlabel']]
        datamat = data.drop(['classlabel'],axis=1)

        keys = list(datamat.keys())
        # for key in ['gender', 'bmi_label']:
        #     keys.remove(key)

        # 定义对数值型变量和分类型变量的处理方法
        numeric_features = keys
        numeric_transformer = Pipeline(steps=[
            ('imputer0', SimpleImputer(strategy='median'))
           # ,('outdata', outdata())
           #  ('imputer', SimpleImputer(strategy='mean'))
           ,('scaler', QuantileTransformer(random_state=0, output_distribution='uniform'))
           #  ,('scaler',MinMaxScaler(copy=True, feature_range=(0, 1)))
        ])

        #定义分类型变量的预处理方法
        categorical_features = ['gender', 'bmi_label']
        categorical_transformer = Pipeline(steps=[
            ('imputer', SimpleImputer(strategy='constant', fill_value=1)),
            ('onehot', OneHotEncoder(handle_unknown='ignore'))
        ])

        # 预处理模块，ColumnTransformer函数分别处理数值型特征和分类型特征
        preprocessor_imp = ColumnTransformer(
            transformers=[
                ('num', numeric_transformer, numeric_features),
                # ('cat', categorical_transformer, categorical_features)
            ]
        )

        preprocessor_imp.fit(datamat)
        data_processed = preprocessor_imp.transform(datamat)
        data_processed = pd.DataFrame(data_processed)
        data_processed['classlabel'] = labelmat
        return data_processed

    def fit(self, X, y=None):
        return self


class FeatureRank(BaseEstimator,TransformerMixin):
    """
    利用Gini_index,Fisher score,ReliefF三种方法对各个特征值的重要性进行排序
    输出结果：
        1.排序的得分按照30_60_FS.csv的命名规则进行存储
        2.最终return的结果为按照特征值重要性排序后的样本集
    """
    def __init__(self,comb_idx = [0,]):
        self.comb_idx = comb_idx

    def transform(self,data):

        datamat_d = pd.DataFrame(data)
        rankedfeatures = datamat_d.loc[:,self.comb_idx]
        labelmat = datamat_d[['classlabel']]
        rankedfeatures['classlabel'] = labelmat
        return rankedfeatures

    def fit(self, X, y=None):
        self.comb_idx = rankindex(X)
        return self

param_XGB = {
        'max_depth': 3,
        'n_estimators': 250,
        'learning_rate': 0.3,
        'min_child_weight': 5,
        # 'alpha': 0.3,
        # 'lambda': 0.3,
        'gamma': 5,
        'seed': 100,
        'scale_pos_weight': 1,
        'subsample': 1,
        'probability': True,
        'objective': 'binary:logistic',
        'colsample_bytree': 1,
        'early_stopping_rounds': 6

    }

param_SVM = {
        'C': 0.5,
        'kernel':  'linear',
        'degree': 5,
        # 'coef0': 5,
        'probability': True
    }
# clf_final = XGBClassifier(**param_XGB)

class selectfeatureset(object):
    """
    根据FeatureRank中，各特征排序的结果，逐个将特征值代入到具体的机器学习算法中进行特征选择。
    """

    def __init__(self,selectnum = [0,]):
        self.selectnum = selectnum

    def transform(self, datamat):
        labelmat = datamat[['classlabel']]
        datamat = datamat.drop(['classlabel'],axis=1)
        datamat = np.array(datamat)
        dataset = datamat[:,0:self.selectnum]
        tmp = self.selectnum
        dataset = pd.DataFrame(dataset)
        dataset['classlabel'] = labelmat
        return dataset

    def fit(self, X, y=None):
        self.selectnum = selectednumber(X)
        return self


def selectednumber(datamat):
    data = datamat.sample(frac=1, random_state=10)
    labelmat = data[['classlabel']]
    datamat = data.drop(['classlabel'], axis=1)
    datamat = np.array(datamat)
    datamat = np.around(datamat, decimals=4)

########################Validation_curve#########################################
    from sklearn.model_selection import validation_curve

    param_range = np.logspace(-6, -1, 5)
    train_scores, test_scores = validation_curve(
        SVC(**param_SVM), datamat, labelmat, param_name="coef0", param_range=param_range,
        cv=5, scoring="roc_auc", n_jobs=1)
    train_scores_mean = np.mean(train_scores, axis=1)
    train_scores_std = np.std(train_scores, axis=1)
    test_scores_mean = np.mean(test_scores, axis=1)
    test_scores_std = np.std(test_scores, axis=1)

    plt.title("Validation Curve with SVM")
    plt.xlabel(r"$\gamma$")
    plt.ylabel("Score")
    plt.ylim(0.0, 1.1)
    lw = 2
    plt.semilogx(param_range, train_scores_mean, label="Training score",
                 color="darkorange", lw=lw)
    plt.fill_between(param_range, train_scores_mean - train_scores_std,
                     train_scores_mean + train_scores_std, alpha=0.2,
                     color="darkorange", lw=lw)
    plt.semilogx(param_range, test_scores_mean, label="Cross-validation score",
                 color="navy", lw=lw)
    plt.fill_between(param_range, test_scores_mean - test_scores_std,
                     test_scores_mean + test_scores_std, alpha=0.2,
                     color="navy", lw=lw)
    plt.legend(loc="best")
    plt.show()
    global clf_final
    clf_final = hyperparameter(data)
    meanfit = []
    stdfit = []

    n_features = datamat.shape[1]
    for i in range(n_features):
        print("第%s个参数： " % (i + 1))
        datamat_tmp = datamat[:, 0:i + 1]
        datamat_tmp = np.array(datamat_tmp)

        scores = cross_val_score(clf_final, datamat_tmp, labelmat, scoring='roc_auc', cv=5)
        mean_score = np.mean(scores)
        std_score = np.std(scores)

        meanfit.append(mean_score)
        stdfit.append(std_score)

    meanfit = np.array(meanfit)
    writemean = pd.DataFrame(meanfit)
    # writemean.to_csv('D:/01袁晶/AHEdata/processed_2019/d_featuresubset/svmfmean.csv', encoding='utf-8', index=True)

    stdfit = np.array(stdfit)
    writestd = pd.DataFrame(stdfit)
    # writestd.to_csv('D:/01袁晶/AHEdata/processed_2019/d_featuresubset/svmfit.csv', encoding='utf-8', index=True)

    # fig, ax1 = plt.subplots()
    # line1 = ax1.plot(meanfit, "b-", label="BER")
    # ax1.set_xlabel("Number of features")
    # ax1.set_ylabel("BER", color="b")
    # plt.show()

    std_up = meanfit + stdfit  # 平均值加标准差
    std_down = meanfit - stdfit  # 平均值减标准差

    minindex = np.argmax(meanfit)  # BER最小值对应的索引值

    # up = std_up[minindex]
    # down = std_down[minindex]
    # meanfit = pd.Series(meanfit)
    # test = (meanfit[(meanfit < up) & (meanfit > down)].index)
    # leastindex = (meanfit[(meanfit < up) & (meanfit > down)].index)[0]

    return minindex



def hyperparameter(data):
    """
    hyperopt进行参数优化

    """
    # 1.定义优化函数
    labelmat = data[['classlabel']]
    datamat = data.drop(['classlabel'],axis=1)
    datamat = np.around(datamat, decimals=4)

    def percept_evaluate(args):
        # param = arggist_transform(args)
        clf = SVC(**args)
        # clf = XGBClassifier(**param)
        # clf = LogisticRegression(**param)
        acc = cross_val_score(clf, datamat, labelmat, scoring='roc_auc', cv=5).mean()
        return {'loss': -acc, 'status': STATUS_OK}

    def arggist_transform(args):

        ##XGBOOST
        # args['max_depth'] = args['max_depth'] + 1
        # args['n_estimators'] = args['n_estimators'] + 50
        # args['min_child_weight'] = args['min_child_weight'] + 1
        # args['early_stopping_rounds'] = args['early_stopping_rounds'] + 3

        ##LR
        args["intercept_scaling"] = args["intercept_scaling"] + 1
        return args


    space_SVM = {
        'C': hp.uniform('C', 0, 0.6),
        'kernel': 'linear',
        'degree': hp.uniform('degree', 1, 10),
        'coef0': hp.uniform('coef0', 0, 10),
        'probability': True
    }

    space_XGB = {
        'max_depth': hp.randint('max_depth',3),
        'n_estimators': hp.randint('n_estimators',200),
        'learning_rate': hp.uniform('learning_rate', 0.1,0.3),
        'min_child_weight': hp.randint('min_child_weight', 7),
        # 'alpha': hp.uniform('alpha', 0, 3),
        # 'lambda': hp.uniform('lambda', 0, 3),
        'gamma':hp.uniform('gamma',3,5),
        'seed': 100,
        'scale_pos_weight': 1,
        'subsample': 1,
        'probability': True,
        'objective': 'binary:logistic',
        'colsample_bytree': 1,
        'early_stopping_rounds': hp.randint('early_stopping_rounds',7),

    }

    space_LR = {
        'penalty': hp.choice('penalty', ['l1', 'l2']),
        'C': hp.uniform('C', 0.1, 20),
        'intercept_scaling': hp.randint('intercept_scaling', 20),
        'solver': hp.choice('solver', ['liblinear', 'saga']),
        'warm_start': True,
        'class_weight':'balanced',
        # 'max_iter':1000
    }

    algo = partial(tpe.suggest)
    trials = Trials()
    best = fmin(percept_evaluate, space_SVM, algo=algo, max_evals=50, trials=trials)
    # print(best)
    # print(space_eval(space_SVM, best))
    # print(percept_evaluate(space_eval(space_SVM, best)))
    best_args0 = space_eval(space_SVM, best)
    # best_args = arggist_transform(best_args0)
    clf_final = SVC(**best_args0)
    # clf_final.set_params(probability=True)#逻辑回归不用加这一句
    return clf_final


def rankindex(data):
    from skfeature.function.similarity_based import fisher_score
    from skfeature.function.similarity_based import reliefF
    from skfeature.function.statistical_based import gini_index

    labelmat = data['classlabel']
    datamat_d = data.drop(['classlabel'], axis=1)
    labelmat = np.array(labelmat)
    datamat = np.array(datamat_d)

    labelmat = np.array(labelmat)
    datamat = np.array(datamat)

    Relief = reliefF.reliefF(datamat, labelmat)
    Fisher = fisher_score.fisher_score(datamat, labelmat)
    gini = gini_index.gini_index(datamat, labelmat)
    gini = -gini
    FSscore = np.column_stack((Relief, Fisher, gini))  # 合并三个分数

    min_max_scaler = MinMaxScaler()
    FSscore = min_max_scaler.fit_transform(FSscore)
    FinalScore = np.sum(FSscore, axis=1)
    FS = np.column_stack((FSscore, FinalScore))
    FS_nor = min_max_scaler.fit_transform(FS)  # 将最后一列联合得分归一化
    FS = pd.DataFrame(FS_nor, columns=["Relief", "Fisher", "gini", "FinalScore"])

    sorteigen = FS.sort_values(by='FinalScore', ascending=False, axis=0)
    ranked_index = sorteigen.index
    return ranked_index

def evaluatemodel(y_true, y_predict, proba):
    from sklearn.metrics import confusion_matrix
    #    from sklearn.metrics import accuracy_score
    from sklearn.metrics import roc_auc_score
    #    from sklearn.metrics import precision_score
    #    from sklearn.metrics import recall_score
    tn, fp, fn, tp = confusion_matrix(y_true, y_predict).ravel();
    TPR = tp / (tp + fn);
    SPC = tn / (fp + tn);
    PPV = tp / (tp + fp);
    NPV = tn / (tn + fn);
    ACC = (tp + tn) / (tn + fp + fn + tp);

    #    Accuracy=accuracy_score(y_true,y_predict)
    AUC = roc_auc_score(y_true, proba)
    #    Precision=precision_score(y_true,y_predict)
    #    Recall=recall_score(y_true,y_predict)
    BER = 0.5 * ((1 - TPR) + (1 - SPC))
    return [[TPR, SPC, PPV, NPV, ACC, AUC, BER]], [[tn, fp, fn, tp]]

def main():
    # loaddata
    # 注意有3个地方需要修改30_60.csv
    import numpy as np
    final_result = []
    final_result_train = []
    gap = np.linspace(30, 180, 6)
    win = np.linspace(60, 420, 7)
    for i in gap:
        for j in win:
            datafile = str(int(i)) + '_' + str(int(j))
            print(datafile)
            eigen_number_train = pd.read_csv(
                'D:/01袁晶/AHEdata/processed_2019/c_final_eigen/trainset/' + datafile + '.csv')  #
            eigen_number_test = pd.read_csv(
                'D:/01袁晶/AHEdata/processed_2019/c_final_eigen/testset/' + datafile + '.csv')  #
            eigen_clinic = pd.read_csv(
                'D:/01袁晶/Githubcode/AHE/SelectSamples_generateeigen/select-11-hours-data-with-matlab/Predict_python/clinicaleigen.csv')
            # eigen_clinic = eigen_clinic[['subject_id', 'classlabel', 'age', 'gender', 'height', 'weight_first']]  #
            eigen_clinic = eigen_clinic[['subject_id', 'classlabel']]  #
            data_train = pd.merge(eigen_clinic, eigen_number_train, on='subject_id')  # 训练集全部数据
            data_test = pd.merge(eigen_clinic, eigen_number_test, on='subject_id')  # 测试集全部数据

            data_train = data_train.drop(['subject_id'], axis=1)  # 训练集全部数据
            data_test = data_test.drop(['subject_id'], axis=1)  # 测试集全部数据

            # 最终的pipeline
            pipeline = Pipeline([
                                # ('preprocess', preprocess()),
                                 ('imputation', preimp())
                                 # ('FeatureRanked', FeatureRank()),
                                 # ('selectfeatureset', selectfeatureset())
                                 ])
            # pipeline.fit(data_train)
            preprocess_pipeline = pipeline.fit(data_train)
            joblib.dump(preprocess_pipeline, 'D:/01袁晶/AHEdata/processed_2019/e_final_model/' + datafile + '_pipeline.sav')
            # loaded_pipeline = joblib.load('/usr/local/src/Ineed/processed_2019/e_final_model/' + datafile + '_pipeline.sav')
            trainset_transform = preprocess_pipeline.transform(data_train)
            testset_transform = preprocess_pipeline.transform(data_test)
            labelmat_train = trainset_transform[['classlabel']]
            datamat_train = trainset_transform.drop(['classlabel'], axis=1)
            labelmat_test = testset_transform[['classlabel']]
            datamat_test = testset_transform.drop(['classlabel'], axis=1)

            # clf_final = hyperparameter(trainset_transform)
            clf_final =  QuadraticDiscriminantAnalysis()
            clf_final.fit(datamat_train, labelmat_train)

            joblib.dump(clf_final, 'D:/01袁晶/AHEdata/processed_2019/e_final_model/' + datafile + '_clf.sav')

            # loaded_model = joblib.load('/usr/local/src/Ineed/processed_2019/e_final_model/' + datafile + '_clf.sav')
            #训练集结果
            predict_train = clf_final.predict(datamat_train)
            predict_prob_train = (clf_final.predict_proba(datamat_train))[:, 1]
            Score_train, confusion_train = evaluatemodel(labelmat_train, predict_train, predict_prob_train)
            final_result_train.extend(Score_train)
            #测试集结果
            predict_test = clf_final.predict(datamat_test)
            predict_prob = (clf_final.predict_proba(datamat_test))[:, 1]
            Score, confusion = evaluatemodel(labelmat_test, predict_test, predict_prob)
            print(Score)
            final_result.extend(Score)
            # print('test')
    Result_train = pd.DataFrame(final_result_train, columns=['TPR', 'SPC', 'PPV', 'NPV', 'ACC', 'AUC', 'BER'])
    Result_train.to_csv('D:/01袁晶/AHEdata/processed_2019/final_result/' + 'final_score_train.csv')
    Result_test = pd.DataFrame(final_result, columns=['TPR', 'SPC', 'PPV', 'NPV', 'ACC', 'AUC', 'BER'])
    Result_test.to_csv('D:/01袁晶/AHEdata/processed_2019/final_result/' + 'final_score.csv')

    return Score,confusion

if __name__ == '__main__':
    Score,confusion = main()
    print(Score)
    # print('test')