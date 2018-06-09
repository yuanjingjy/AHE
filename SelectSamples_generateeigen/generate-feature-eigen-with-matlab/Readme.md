# Content
* [Abstract](#Abstract)
    * [combinedata.m](#combinedata.m)
    * [create_eigen.m](#create_eigen.m)
    * [extractagesex.m](#extractagesex.m)
    * [latest.m](#latest.m)
    * [mmMissingValues.m](#mmMissingValues.m)
    * [pro_nan.m](#pro_nan.m)
    * [reSample.m](#reSample.m)
    * [tezhengzhi.m](#tezhegnzhi.m)
    * [xigma.m](#xigma.m)

## Abstract
    该文件夹中程序的主要功能为：
        1. 对筛选出的病例组和对照组11小时数据，对每个生理参数提取10个统计特征值
        2. 对筛选出的病例组和对照组11小时数据，提取对应的年龄性别，并和第一步的特征值矩阵
                手动合并
        3.对于血压数据，通过对有创血压每隔30min求一次平均值，来模拟无创血压 
### combinedata.m
    %Description:
    %   该程序的功能为对挑战项目中训练集和测试集的数据进行合并整理，合并前是按照参数进行
    %   存储，即训练集中所有60个样本的心率存在一个.mat文件中，拆分后为按照样本进行存储，
    %   每个样本按照心率、动脉收缩压、动脉舒张压、动脉平均压、脉搏、呼吸、血氧的顺序进行存储
    %   对于训练集，即保存60个660*7的.mat文件
    
### create_eigen.m
    %Description：
    %   本程序为每个生理参数提取出10个统计参数，构成特征值矩阵
    %Calls：
    %   function [ output] = pro_nan( data)
    %   function [ data_value] = tezhengzhi( data)
    %   function [ outputdata ] = reSample( inputdata)
    %   function [data]=xigma(data)
    %   function yout=mmMissingValues( data,maxmium)
    %Input：
    %   AHE:发生AHE的11小时数据段的文件夹
    %   nonAHE：未发生AHE的11小时数据段的文件夹
    %Output：
    %   final_eigen：特征值矩阵
    
### extractagesex.m
    %Description:
    %   本函数提取筛选出的AHE及nonAHE样本的年龄和性别，select-11-hours-data-with-matlab
    %   文件夹中的age.m函数从头文件中提取出的年龄性别是单独存放的，此处整理成特征值矩阵
    %Input:
    %   AHE：所有发生AHE的11小时数据段的数据文件夹
    %   nonAHE：所有未发生AHE的11小时数据段的数据文件夹
    %Output：
    %   final_eigen：1648*3的特征值矩阵，第一列年龄，第二列性别，第三列标签
    %Notice：
    %   1.此处的1648个样本是去除重复样本之前的数目
    %   2.发生AHE的有一个时间格式不对的，需留意
    %   3. 提取完年龄性别，直接复制粘贴到特征值矩阵中

### latest.m
    %Description:
    %   该文件为从11小时数数据记录中提取每个参数的统计量生成特征值矩阵的原始程序，
    %   还包括挑战项目中训练集、测试集的110个样本，但由于后期无法提取临床参数，所以
    %   没后没有用，该程序的进一步改进程序为create_eigen.m
    %Calls：
    %   function [ output] = pro_nan( data)
    %   function [ data_value] = tezhengzhi( data)
    %   function [ outputdata ] = reSample( inputdata)
    %   function [data]=xigma(data)
    %   function yout=mmMissingValues( data,maxmium)
    %Input:
    %   训练集：挑战赛训练集11小时数据段文件夹
    %   测试集A：挑战赛测试集A11小时数据段文件夹
    %   测试集B：挑战赛测试集B11小时数据段文件夹
    %   AHE：发生急性低血压的11小时数据段文件夹
    %   nonAHE：未发生AHE的11小时数据段文件夹
    %Output:
    %   final_eigen：特征值矩阵
### mmMissingValues.m
    %Description:
     %   该函数寻找缺失值及异常大、异常小值的位置
     %   各生理参数上限值：  
 |HR | ABPMean | ABPSys | ABPDias | Pulse | Resp|Spo2 | 
 |:----:|:-----:|:----:|:-----:|:-----:|:----:|:-----:| 
 | 250 | 200 | 200 | 200 | 200 | 100 | 100 |
    %Input：
    %   data:1列11小时的数据
    %   maximum：输入的数据的上限值
    %Output:
    %   yout：将异常值置零后的数据
    
### pro_nan.m
    %Description:
    %   pro_nan函数处理特征参数矩阵中含有NAN的项
    %   当某一生理参数某一个样本缺失时，求得的统计变量为非法值或者0值
    %   对于此类情况，将0值或非法值，用该列其他数据的平均值替代
    %
    %Input：
    %    data:特征参数矩阵，10列
    %Output：
    %    output：补全之后的特征参数矩阵
    
### reSample.m
    %Description:
    %   对输入数据每隔30个数求一次平均值，主要目的是用有创血压模拟无创血压，30min测一次
    %Input：
    %   inputdata:每分钟记录一次的血压数据
    %Output:
    %   output：30min求一个平均值之后的数据
    
### tezhegnzhi.m
    %Description:
    %   tezhengzhi 求各个特征值
    %
    %Input：
    %data:  需要计算统计量的输入数据
    %
    %Output：
    %   data_value(1):  data_mean,  均值
    %   data_value(2):  data_median, 中位数
    %   data_value(3):  data_std,   标准差
    %   data_value(4):  data_skewness,:  偏度
    %   data_value(5):  data_prctile,   百分位数（75%）
    %   data_value(6):  data_kurtosis,  峰度（峭度）
    %   data_value(7):  data_iqr,  四分位数
    %   data_value(8):  data_mad,   平均绝对偏差
    %   data_value(9): data_range, 极差
    %   data_value(10): data_var,   方差
    
### xigma.m
    %Description:
    %   根据拉依达准则，去除可能存在问题的异常数据，直接置零
    %Input:
    %   data：输入待判断数据
    % Output: 
    %   data：异常值置零后的数据