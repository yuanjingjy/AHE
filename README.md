
# Acute Hypotension Episode 


## 波形数据下载

WFDB软件安装方法：[https://www.physionet.org/physiotools/wfdb-windows-quick-start.shtml](https://www.physionet.org/physiotools/wfdb-windows-quick-start.shtml) <br>
匹配数据库下载方法：[https://www.physionet.org/physiobank/database/mimic2wdb/matched/](https://www.physionet.org/physiobank/database/mimic2wdb/matched/) <br>
原始波形数据格式转换[https://physionet.org/faq.shtml#tar-gz](https://physionet.org/faq.shtml#tar-gz)<br>
MIMICII临床数据库下载网址[https://physionet.org/works/MIMICIIClinicalDatabase/files/](https://physionet.org/works/MIMICIIClinicalDatabase/files/)<br>
MIMICII临床数据库安装[https://physionet.org/works/MIMICIIClinicalDatabase/files/](https://physionet.org/works/MIMICIIClinicalDatabase/files/)<br>
[https://github.com/AndreaBravi/MIMIC2](https://github.com/AndreaBravi/MIMIC2)

## 波形数据格式转换
    convert_wavedata.sh

## 急性低血压病例筛选及特征值提取
    1. matlab筛选11小时数据<br>
    2. matlab生成特征值矩阵————没有加入临床数据库中的信息<br>
    3. matlab从数据库中提取数据<br>
    4. matlab加入GCS等参数到特征值矩阵<br>
    5. SQL生成特征值矩阵<br>

## 各种算法

### 仅使用60个训练样本和50个测试样本的程序
    0. 网站上的例程GRNN<br>
    1. 根据指标进行分类<br>
    2. 拟合分类<br>
    3. 多参数预测算法<br>
 
 ### 919个样本的程序
    机器学习算法：AdaBoost、LR、ANN、SVM<br>
    这个机器学习的程序在AdaBoost的仓库中<br>
    遗传算法和MIV降维的程序在GA仓库中<br>
