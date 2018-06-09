# Content
***
* [Abstract](#Abstract)  
* [select-11-hours-data-with matlab](#select-11-hours-data-with-matlab)  
    * [loaddata.m](#loaddata)  
    * [age.m](#age)
    * [selectAHE.m](#selectAHE)
        * [findAHE.m](#findAHE)
        * [AHEEpisode.m](#AHEEpisode) 
    *  [select_nonAHE](#select_nonAHE) 
        * [mvdir.m](#mvdir)
        * [selectnon.m](#selectnon)
        * [findnonAHE.m](#findnonAHE)
* [generate-feature-eigen-with-matlab](#generate-feature-eigen-with-matlab)
    * [combinedata.m](#combinedata)
    * [create_eigen.m](#create_eigen)
    * [extractagesex.m](#extractagesex)
    * [latest.m](#latest)
    * [mmMissingValues.m](#mmMissingValues)
    * [pro_nan.m](#pro_nan)
    * [reSample.m](#reSample)
    * [tezhengzhi.m](#tezhegnzhi)
    * [xigma.m](#xigma)
* [extract-timepoint-with-matlab](#extract-mimic-data-with-matlab)
    * [extracttime.m](#extracttime)
    * [locate_AHE.m](#locate_AHE)
    * [savetimepoint_ahe.m](#savetimepoint_ahe)
    * [savetimepoint_non.m](#savetimepoint_non)
* [generate_final_eigen_with_SQL](#generate_final_eigen_with_SQL)
    * [extract_clinical_data.sql](#extract_clinical_data)
    * [sheet_export_from_database](#sheet_export_from_database)
        * export_finaleigen_duplicate.csv
        * export_finaleigen_single.csv
___

## Abstract
    该文件夹内程序的主要功能为：  
        1. 可用11小时数据段筛选
        2. 趋势数据特征值提取
        3. 提取数据记录的起始时间以及11小时数据段的起始时刻
        4. 根据病人编号和时间点，提取临床参数，生产最终的特征值矩阵

## select-11-hours-data-with matlab
    该文件夹内程序的主要功能为：  
        1. 对原始波形文件去除基线和增益，按照特定顺序排列各参数
        2. 从每个数据记录对应的头文件中提取年龄和性别
        3. 根据AHE定义，从全部数据记录中筛选发生AHE的11小时数据段
        4. 挑选完AHE患者后，从剩余患者中筛选出未发生AHE的11小时数据段
### loaddata
    % Description：
    %   本程序对convert_wavedata之后的原始波形文件进行格式转换，按照基线、增益处理后，
    %   将生理参数按照特定的顺序进行排列：HR、SBP、DBP、MBP、PULSE、RESP、SPO2
    %Input data：
    %   path='D:\Available_yj\already\，convert_wavedata之后的数据
    %Output data：
    %   以"_selected.mat"结尾的文件，存放到path里


### age
    % Description:
    %   从.hea文件中提取患者的年龄和性别，对于缺失情况用-100代替，然后从临床数据库
    %   中提取或插值补全
    % Input:
    %   path='D:\Available_yj\already\*nm.hea'
    %Output:
    %   path='D:\Available_yj\already\*_age.mat'


### selectAHE
    %Description：
    %   从path='D:\Available_yj\already\*_selected.mat'文件中筛选发生急性低血压的样本，
    %   将发生的存储到path=‘D:\1yj_AHE\'中
    %Input:
    %   path='D:\Available_yj\already\*_select.mat'
    %Output:
    %   path='D:\1yj_AHE\*_AHE.mat'
    
#### findAHE
        function [AHEdata] = findAHE( inputdata,ForecastWin,Win,VAL,TOL)
        %------------------------程序功能说明-------------------%
        %本程序的功能为按照急性低血压的定义：预测窗口内（1个小时）对于给定的每分钟
        %采样一次的动脉平均压值，在任意30分钟或更长的时间段内，有超过90%的血压值
        %低于60mmHg时，认为该患者出现了急性低血压。
        %
        %首先判断数据长度：
        %       当数据长度不足十一小时时，记录当前编号，输出提示：数据长度不足；
        %       当数据长度超过十一小时时，从第十个小时之后的点开始判断是否会发生AHE       
        %       重叠长度为10min，整个11个小时长度的数据段，重叠长度为10min进行移动
        %
        % 输出参数：
        %       AHEdata：最后1个小时发生了急性低血压的共11(或3)小时的数据
        %
        %输入参数：
        %       inputdata：待判断数据段
        %       ForcastWin：预测窗口的长度，1个小时，（输入60）
        %       Win:最小的移动窗口的长度，半个小时（输入21）
        %       VAL：发生低血压时血压值的最低限值，60mmHg（输入60）
        %       TOL：Win内血压值地与VAL的个数占整个窗口的比例（输入0.9）
        
#### AHEEpisode
        function [ ahe_find] = AHEEpisode( input,WIN,VAL,TOL )
        %Description:
        %   该函数的功能为判断1个小时的数据窗口内是否发生了急性低血压
        %输出参数：
        %   ahe_find:标识该1小时的预测窗口内是否发生了急性低血压，
        %            值为1表示发生，值为0表示未发生       
        %
        %输入参数：
        %	input：待判断的1小时的数据段
        %   WIN：判断窗的长度，30min或更长
        %   VAL：发生低血压的ABPMean下限值，为60mmHg
        %   TOL：发生AHE时，低于下限值VAL的点所占的比例，为0.9

### select_nonAHE
    文件夹，里面的两个文件用来筛选对照组：未发生急性低血压的样本

#### mvdir
    %Description:
    %   1.提取出所有发生低血压的病例的文件名称
    %   2.将发生低血压的病例的数据文件夹移动到指定位置，剩下的即为未发生低血压的数据
    % Input：
    %   pathahe='D:\1yj_AHE'
    %Output:
    %   path='D:\Available_yj\AHEdir'

#### selectnon
    function [ startpoint,output_data ] = selectnon( input_data )
    %selectnon 函数筛选未发生低血压的病例
    %筛选规则：
    %   1.数据长度大于11小时
    %   2.最后1小时数据中，大于60mmHg的有27个以上
    %   3.最后1小时数据中，小于等于0的值在10%以下
    %   4.前10个小时的数据，所有数据缺失比例在30%以内
    %
    %   Input：
    %       input_data:输入的待判断数据段；
    %   Output：
    %       output_data:筛选结果，遇到1个符合规则的即保存，后续数据不再进行判断
    %       startpoint:11小时数据段的起始位置

#### findnonAHE
    %Description:
    %   调用selectnon.m文件，筛选未发生急性低血压的样本
    %Input:
    %   path_nonAHE='D:\Available_yj\already\*select.mat'：该路径下的发生AHE的原始数据已转移
    %Output：
    %   path='D:\1yj_nonAHE\*_non.mat'
    
## generate-feature-eigen-with-matlab
    该文件夹中程序的主要功能为：
        1. 对筛选出的病例组和对照组11小时数据，对每个生理参数提取10个统计特征值
        2. 对筛选出的病例组和对照组11小时数据，提取对应的年龄性别，并和第一步的特征值矩阵
                手动合并
        3.对于血压数据，通过对有创血压每隔30min求一次平均值，来模拟无创血压 
### combinedata
    %Description:
    %   该程序的功能为对挑战项目中训练集和测试集的数据进行合并整理，合并前是按照参数进行
    %   存储，即训练集中所有60个样本的心率存在一个.mat文件中，拆分后为按照样本进行存储，
    %   每个样本按照心率、动脉收缩压、动脉舒张压、动脉平均压、脉搏、呼吸、血氧的顺序进行存储
    %   对于训练集，即保存60个660*7的.mat文件
    
### create_eigen
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
    
### extractagesex
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

### latest
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
### mmMissingValues
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
    
### pro_nan
    %Description:
    %   pro_nan函数处理特征参数矩阵中含有NAN的项
    %   当某一生理参数某一个样本缺失时，求得的统计变量为非法值或者0值
    %   对于此类情况，将0值或非法值，用该列其他数据的平均值替代
    %
    %Input：
    %    data:特征参数矩阵，10列
    %Output：
    %    output：补全之后的特征参数矩阵
    
### reSample
    %Description:
    %   对输入数据每隔30个数求一次平均值，主要目的是用有创血压模拟无创血压，30min测一次
    %Input：
    %   inputdata:每分钟记录一次的血压数据
    %Output:
    %   output：30min求一个平均值之后的数据
    
### tezhegnzhi
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
    
### xigma
    %Description:
    %   根据拉依达准则，去除可能存在问题的异常数据，直接置零
    %Input:
    %   data：输入待判断数据
    % Output: 
    %   data：异常值置零后的数据
    
## extract-timepoint-with-matlab
    本文件夹下程序的主要功能为：
        1. 定位筛选出的11小时数据段在原始数据记录中的位置
        2. 保存发生AHE样本原始数据记录的起始时刻以及11小时数据段对应的位置，
            手动和之前的特征值矩阵进行拼接，用于后期从数据库中提取临床参数
        3. 保存未发生AHE样本原始数据记录的起始时刻以及11小时数据段对应的位置，
            手动和之前的特征值矩阵进行拼接，用于后期从数据库中提取临床参数
             
### extracttime
    %Description:
    %   将提取出的日期拆分了，直接用datestr总出错
    %Input:
    %   timestr:时间字符串
    %Output:
    %   starttimestr:PostgresSQL支持的时间字符串
    
### locate_AHE
    %Description：
    %   找到筛选出的数据段在原始数据段中的位置
    %Input：
    %   ahe_episode:筛选出的AHE数据段
    %   ahe_source:AHE原始数据
    %Output：
    %   startpoint:AHE数据段在原始数据段中的位置
    
### savetimepoint_ahe
    %Description:
    %   提取所有发生AHE样本数据记录的起始时间以及11小时数据段的起始位置
    %Input:
    %   ahepath='D:\1yj_AHE\时间有问题的\'：所有筛选出来的11小时AHE数据段
    %Output:
    %   time_point(i-2,1)=startpoint：11小时数据段的起始位置，对应单位为分钟
    %   time_point(i-2,2)=ahe_id：subject_id
    %   starttime_point(i-2,:)=starttime:整个数据记录的起始时间
    
### savetimepoint_non
    %Description:
    %   提取所有未发生AHE样本数据记录的起始时间以及11小时数据段的起始位置
    %Input:
    %   ahepath='D:\1yj_nonAHE\时间有问题的\'：所有筛选出来的11小时nonAHE数据段
    %Output:
    %   time_point(i-2,1)=startpoint：11小时数据段的起始位置，对应单位为分钟
    %   time_point(i-2,2)=ahe_id：subject_id
    %   starttime_point(i-2,:)=starttime:整个数据记录的起始时间
    
## generate_final_eigen_with_sql
    本文件夹内程序的主要功能为根据筛选出的AHE、非AHE样本对应的subject_id,  
    starttime,startpoint,从数据库中提取GCS、温度、身高、体重数据
    
### extract_clinical_data
    --从matlab中得到包含年龄、性别、整个数据段其实记录时间、AHE开始时间点、70个特征值的表
    --根据subject_id,找到GCS、身高、体重、体温数据
    
### sheet_export_from_database  
    本文件夹下存放的是从数据库导出的最终特征值矩阵结果:
        1.export_finaleigen_duplicate.csv
            _duplicate.csv结尾的文件有1648个样本，一个病人可能有多条记录
        2. export_finaleigen_single.csv
         _single.csv结尾的文件有1293个样本，对于有多条记录的病人，只取第一次发生AHE的
