from scipy.io import loadmat
import pandas as  pd
import numpy as np
import os,random,shutil


def extract(inputdata):
    """
        Description:
            输入数据为n小时（具体长度变化），7列的特征值矩阵，以小时为单位，分别计算各生理参数。
        Outputdata：
            1行，n组特征值（根据具体数据长度变化）
        """
    eigen_tmp = []
    len = int(max(inputdata.shape) / 60)
    for i in range(len):
        data_tmp = inputdata.iloc[(i * 60):(i * 60 + 59), :]
        eigen_tmp.extend(np.max(data_tmp)) #1.最大值
        eigen_tmp.extend(np.min(data_tmp)) #2.最小值
        eigen_tmp.extend(np.mean(data_tmp)) #3.均值
        eigen_tmp.extend(np.median(data_tmp,axis = 0)) #4.中位数
        eigen_tmp.extend(np.std(data_tmp)) #5.标准差
        eigen_tmp.extend(data_tmp.skew()) #6.偏度
        eigen_tmp.extend(data_tmp.kurt()) #7.峰度
        eigen_tmp.extend(np.percentile(data_tmp,75,axis = 0)) #8.上四分位数
        eigen_tmp.extend(np.percentile(data_tmp,75,axis = 0)-np.percentile(data_tmp,25,axis = 0)) #9.四分位差
        eigen_tmp.extend(data_tmp.mad()) #10.平均绝对偏差
        eigen_tmp.extend(np.ptp(np.array(data_tmp),axis=0)) #11.极差
        eigen_tmp.extend(np.var(data_tmp)) #12.方差

    return eigen_tmp

def divideddata(fromdir,todir):
    """
    Description:
        随机选取30%的文件当作侧式集
    :param fromdir: 存放原始数据的路径
    :param todir: 文件转移路径
    :return:
    """
    pathdir = os.listdir(fromdir)  #文件原始路径
    filenumber = len(pathdir)
    rate = 0.3
    picknumber = int(filenumber*rate) #选择的图片的数目
    sample = random.sample(pathdir,picknumber) #随机选择制定数目样本
    print(sample)
    for name in sample:
        shutil.move(fromdir+name, todir+'1_'+name)
    return

def moveremaindata(fromdir,todir):
    pathdir = os.listdir(fromdir)
    for name in pathdir:
        shutil.move(fromdir+name, todir+'0_'+name)
    return


def read_directory(directory_name):
    eigen = []
    for filename in os.listdir(directory_name):
        if filename[0]=='s':
            eigen_tmp = []
            data_i = loadmat(directory_name + "/" + filename)
            data_tmp = data_i['outputdata']
            data_tmp = pd.DataFrame(data_tmp)
            eigen_tmp = extract(data_tmp)
            eigen.append(eigen_tmp)
    return eigen

def createigen(filepath,topath):
    file = os.listdir(filepath)
    os.chdir(filepath)
    gapset = np.linspace(30, 180, 6)
    winset = np.linspace(60, 420, 7)
    for gap in gapset:
        for win in winset:
            eigen = pd.DataFrame()
            eigen_tmp = []
            data_i = []
            for name in file:
                data_i = loadmat(name)
                name_sub = name[2:27]
                data_tmp = data_i['outputdata']
                data_tmp = pd.DataFrame(data_tmp)
                data_use = data_tmp.loc[600-gap-win+1:600-gap,:]
                eigen_tmp = extract(data_use)
                eigen_tmp = pd.Series(eigen_tmp)
                eigen_tmp = pd.DataFrame(eigen_tmp.reshape(1,len(eigen_tmp)))
                eigen_tmp['filename'] = name_sub
                eigen = eigen.append(eigen_tmp)
            name = str(int(gap))+'_'+str(int(win))+'.csv'
            eigen = pd.DataFrame(eigen)
            eigen.to_csv(topath+name,header=None,columns=None,index=None)
    return

def agegender():
    classlebel = pd.read_csv('D:/01袁晶/Githubcode/AHE/SelectSamples_generateeigen/select-11-hours-data-with-matlab/Predict_python/filelabel.csv')
    age = pd.read_csv('D:/01袁晶/Githubcode/AHE/SelectSamples_generateeigen/select-11-hours-data-with-matlab/Predict_python/agegender.csv')
    agegenderlabel = classlebel.join(age.set_index('filename'), on='filename')
    return agegenderlabel


filepath ='D:/01袁晶/AHEdata/processed_2019/b_divided/traindata/'
topath ='D:/01袁晶/AHEdata/processed_2019/c_final_eigen/trainset/'
createigen(filepath,topath)
print('test')


"""
#随机选择30%的AHE样本
Description：
    1.从原始数据文件夹中，随机选择30%的用来做测试；
    2.选AHE组和nonAHE组时，需要对shutil.move(fromdir+name, todir+'1_'+name)这句话里的文件名稍做修改
########################################################################

fromdir_ahe = 'D:/01袁晶/AHEdata/processed_2019/a_rawdata/AHE/available/'
todir_ahe = 'D:/01袁晶/AHEdata/processed_2019/b_divided/testdata/'
divideddata(fromdir_ahe,todir_ahe)
print('test')

#随机选择30%的nonAHE样本
fromdir_ahe = 'D:/01袁晶/AHEdata/processed_2019/a_rawdata/nonAHE/available/'
todir_ahe = 'D:/01袁晶/AHEdata/processed_2019/b_divided/testdata/'
divideddata(fromdir_ahe,todir_ahe)
"""


"""
Description:
    1.随机选择移动30%的样本到测试集文件夹中后，将剩余的70%的样本修改文件名称后，移动到训练集文件夹
fromdir_ahe = 'D:/01袁晶/AHEdata/processed_2019/a_rawdata/nonAHE/available/'
todir = 'D:/01袁晶/AHEdata/processed_2019/b_divided/traindata/'
moveremaindata(fromdir_ahe,todir)

fromdir_ahe = 'D:/01袁晶/AHEdata/processed_2019/a_rawdata/AHE/available/'
todir = 'D:/01袁晶/AHEdata/processed_2019/b_divided/traindata/'
moveremaindata(fromdir_ahe,todir)

print('test')
"""

path_ahe = 'D:/01袁晶/AHEdata/processed_2019/rawdata/AHE/avaliable'
eigen_ahe = read_directory(path_ahe)
eigen_ahe = pd.DataFrame(eigen_ahe)
eigen_ahe['label'] = 1

path_nonahe ='D:/01袁晶/AHEdata/processed_2019/rawdata/nonAHE/avaliable'
eigen_nonahe = read_directory(path_nonahe)
eigen_nonahe = pd.DataFrame(eigen_nonahe)
eigen_nonahe['label'] = 0
eigen = pd.concat([eigen_ahe,eigen_nonahe],axis=0,ignore_index=True)

print("test")