
# Acute Hypotension Episode 
#目录
* [数据下载](##波形数据下载)  
* [波形数据格式转换](##波形数据格式转换)  
* [数据文件](##Data)
* [特征值矩阵生产](##SelectSamples_generateeigen)
    * [可用11小时数据段筛选](###select-11-hours-data-with-matlab)  
    * [趋势数据特征值提取](###generate-feature-eigen-with-matlab) 
    * [时间点提取](###extract-timepoint-with-matlab)
    * [生成特征值矩阵](###generate_final_eigen_with_SQL)
* [机器学习](##DataProcess_MachineLearning)
    * [缺失数据插补](###Missingdata)
    * [特征工程](###FeatureSelection)
        * [Filter方法](####Filter)  
        * [遗传算法](####GA)   
        * [平均影响值](####MIV)
    * [机器学习算法](###MachineLearning)  
        * [神经网络](####ANN)
        * [逻辑回归](####LR)
        * [AdaBoost](####AdaBoost)
        * [支持向量机](####SVM)    
* [对比算法—早期预警评分](##MEWS)

## 波形数据下载

WFDB软件安装方法：[https://www.physionet.org/physiotools/wfdb-windows-quick-start.shtml](https://www.physionet.org/physiotools/wfdb-windows-quick-start.shtml) <br>
匹配数据库下载方法：[https://www.physionet.org/physiobank/database/mimic2wdb/matched/](https://www.physionet.org/physiobank/database/mimic2wdb/matched/) <br>
原始波形数据格式转换[https://physionet.org/faq.shtml#tar-gz](https://physionet.org/faq.shtml#tar-gz)<br>
MIMICII临床数据库下载网址[https://physionet.org/works/MIMICIIClinicalDatabase/files/](https://physionet.org/works/MIMICIIClinicalDatabase/files/)<br>
MIMICII临床数据库安装[https://physionet.org/works/MIMICIIClinicalDatabase/files/](https://physionet.org/works/MIMICIIClinicalDatabase/files/)<br>
[https://github.com/AndreaBravi/MIMIC2](https://github.com/AndreaBravi/MIMIC2)

## 波形数据格式转换
    convert_wavedata.sh


##Data
    1.里面有两个文件夹，AHE和nonAHE，分别是筛选出来的发生急性低血压和
        未发生急性低血压的11小时数据段。
    2.AHE文件夹中有755个数据段和一个文件夹，文件夹中的一个数据段时间格式
        和其他数据段不一样，其他的数据段年份都用四位数表示，有问题的有5位，
        需加以注意。此外该数据段包含在AHE的755个数据段之中。
    3. nonAHE文件夹中共有894个数据段
    4.AHE和nonAHE两个文件夹中，同一病人可能有多条AHE或nonAHE的数据记录
    5. 若对于有多条数据记录的病人只取第一次筛选出来的记录：则发生AHE的样本有
        598人，未发生AHE的有695（应该是696,但排除了一个年龄小于16周岁的）人
     6.排除重复病人的过程在数据库中进行
        
##SelectSamples_generateeigen
    该文件夹内程序的主要功能为：  
        1.  可用11小时数据段筛选
        2. 趋势数据特征值提取
        3. 提取数据记录的起始时间以及11小时数据段的起始时刻
        4. 根据病人编号和时间点，提取临床参数，生产最终的特征值矩阵

###select-11-hours-data-with-matlab
    该文件夹内程序的主要功能为：  
        1. 对原始波形文件去除基线和增益，按照特定顺序排列各参数
        2. 从每个数据记录对应的头文件中提取年龄和性别
        3. 根据AHE定义，从全部数据记录中筛选发生AHE的11小时数据段
        4. 挑选完AHE患者后，从剩余患者中筛选出未发生AHE的11小时数据段
        
        
###generate-feature-eigen-with-matlab
    该文件夹中程序的主要功能为：
        1. 对筛选出的病例组和对照组11小时数据，对每个生理参数提取10个统计特征值
        2. 对筛选出的病例组和对照组11小时数据，提取对应的年龄性别，并和第一步的特征值矩阵
                手动合并
        3.对于血压数据，通过对有创血压每隔30min求一次平均值，来模拟无创血压 
        
###extract-timepoint-with-matlab
    本文件夹下程序的主要功能为：
        1. 定位筛选出的11小时数据段在原始数据记录中的位置
        2. 保存发生AHE样本原始数据记录的起始时刻以及11小时数据段对应的位置，
            手动和之前的特征值矩阵进行拼接，用于后期从数据库中提取临床参数
        3. 保存未发生AHE样本原始数据记录的起始时刻以及11小时数据段对应的位置，
            手动和之前的特征值矩阵进行拼接，用于后期从数据库中提取临床参数
            
###generate_final_eigen_with_SQL
    本文件夹内程序的主要功能为根据筛选出的AHE、非AHE样本对应的subject_id,  
    starttime,startpoint,从数据库中提取GCS、温度、身高、体重数据
    
##DataProcess_MachineLearning
    机器学习的整个过程：  
            1. 缺失数据插值：`Missingdata`文件夹  
            2. 特征工程：`GA`文件夹以及`Featureselection_MachineLearning`文件夹中的`FS.py`  
            3. 机器学习算法：`Featureselection_MachineLearning`文件夹  
            4.对比方法`MEWS`文件夹
            
###Missingdata
    对缺失数据进行插补：首先分析各特征值的缺失比例；然后去除含缺失数据的样本
    再按照缺失比例人为构造缺失数据集；利用常用的缺失值插补方法对构造出的缺失
    数据集进行插补；比较插补结果和完整数据集之间的误差，确定最优的插补方法
    并进行缺失值的插补。
    
###FeatureSelection
    重要特征筛选，可用方法包括：
        Filter方法：Gini_index、Fisher_score、ReliefF、mRMR等
        Wrapper方法：递归特征删除、平均影响值、建模时各模型的权重
        Embedded方法：正则化方法、遗传算法
        
####Filter
    1.首先计算Relief、Fisher-score、Gini_index三个得分值，归一化后叠加到
        一起得到最终分值，注意Gini_Index是得分越小特征越重要
    2.根据叠加后的分值对特征值进行排序
    3.根据排序结果逐个增加特征值，得到BER平均值及std的变化曲线并进行保存
    
####GA
    1. 遗传算法+神经网络筛选特征值
    2. 用的是DEAP框架
    3. 进行50次遗传算法的运行结果中，0表示本次运行未选中，1表示被选中
    4. 按照遗传算法运行过程中特征值被选中的次数对特征值进行排序，根据排序结果，
        将特征值逐步增加带入到神经网络中看预测结果
###MIV 
    本程序针对于神经网络算法，用平均影响值的方式对特征值进行筛选：
        1.平均影响值计算过程：首先用全部特征值训练出神经网络模型，然后将当个特征值
            的数值增加10%和减小10%，分别用训练出的神经网络模型进行预测，两个预测结果之间的
            差值对应的就是该特征值的影响值，对全部样本上的影响值求平均即得到该样本的平均影响值
        2.得到各个特征值对应的平均影响值后特征值进行排序，平均影响值即代表该特征的重要程度
        3. 按照特征重要性排序结果，逐个增加特征值的方式比较不同特征子集对应的模型预测结果
    
###MachineLearning
    包含神经网络、AdaBoost、逻辑回归、支持向量机算法的实现及测试程序
    
####ANN
    Featureselection_MachineLearning/ann.py
    Featureselection_MachineLearning/testann.py
    
####LR
    Featureselection_MachineLearning/logRegres.py
    Featureselection_MachineLearning/testLR.py
    
####AdaBoost
    Featureselection_MachineLearning/adaboost.py
    Featureselection_MachineLearning/testcross.py
    
####SVM
    Featureselection_MachineLearning/ann.py
    Featureselection_MachineLearning/testSVM.py
            
##MEWS
    主要功能为：
        1.SQL提取AHE发生前30min内的GCS、Tem的最大值、最小值、平均值，缺失情况
            用前一个时刻的记录值代替
        2. matlab提取发生AHE前30min内HR、RR、SBP的最大值、最小值、平均值
        3. GCS、Tem缺失情况比较严重，多数都是用前一时刻的值代替的，所以用最大
            、最小、平均哪个值来计算MEWS都是一样的
         4. HR、RR、SBP用最大、最小、平均三个值分别计算，然后取得分最严重的
