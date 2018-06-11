# Content
* [Abstract](#abstract)
    * [extracttime.m](#extracttime)
    * [locate_AHE.m](#locate_ahe)
    * [savetimepoint_ahe.m](#savetimepoint_ahe)
    * [savetimepoint_non.m](#savetimepoint_non)


## abstract
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
    
### locate_ahe
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