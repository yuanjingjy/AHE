#Content

* [Abstract](##Abstract)
    * [extract_clinical_data.sql](###extract_clinical_data.sql)
    * [sheet_export_from_database](###sheet_export_from_database)
        * export_finaleigen_duplicate.csv
        * export_finaleigen_single.csv

##Abstract
    本文件夹内程序的主要功能为根据筛选出的AHE、非AHE样本对应的subject_id,  
    starttime,startpoint,从数据库中提取GCS、温度、身高、体重数据
    
###extract_clinical_data.sql
    --从matlab中得到包含年龄、性别、整个数据段其实记录时间、AHE开始时间点、70个特征值的表
    --根据subject_id,找到GCS、身高、体重、体温数据
    
###sheet_export_from_database
    本文件夹下存放的是从数据库导出的最终特征值矩阵结果:
        1.export_finaleigen_duplicate.csv
            _duplicate.csv结尾的文件有1648个样本，一个病人可能有多条记录
        2. export_finaleigen_single.csv
         _single.csv结尾的文件有1293个样本，对于有多条记录的病人，只取第一次发生AHE的