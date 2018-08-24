#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2018/5/21 8:03
# @Author  : YuanJing
# @File    : resultplot.py
"""
Description:
    1.对于ANN、AdaBoost、LR、SVM四种算法逐步增加特征值后BER的平均值及标准差，
       绘制变化过程曲线，数据文件在selectresult文件夹中
    2.找到每种算法BERmean的最小值，然后找到第一个落在最小值加减标准差范围内的索引值
        注：这里的索引值的就是实际的个数，是从1 开始的
Output message：
    stdvalue:BER的标准差
    meanvalue：BER的平均值
    minindex：BER最小值索引（从1 开始的）
    minvalue：BER最小值
    up：BER最小值位置的上限（minvalue+对应的标准差）
    down：BER最小值位置的下限
    a：up、down范围内的最小特征值数目
    tmp：a对应的BER值
"""
import  pandas as pd
import  matplotlib.pyplot as plt
import  numpy as np



sortFS=pd.read_csv('FSsort.csv')#特征值排序结果
names=sortFS['Features']#排序后特征值名称
stdresult=pd.read_csv('selectresult\LRfit.csv',names=['index','std'])
meanresult=pd.read_csv('selectresult\LRmean.csv',names=['index','mean'])

#十折交叉验证后后BER的平均值、标准差，FS.py程序运行出来的
stdvalue=stdresult[1:81]['std']
meanvalue=meanresult[1:81]['mean']#提取有效数值，第一行和第一列是编号
stdvalue=stdvalue*100#最后单位都用%表示
meanvalue=meanvalue*100

std_up=meanvalue+stdvalue#平均值加标准差
std_down=meanvalue-stdvalue#平均值减标准差

minindex=np.argmin(meanvalue)#BER最小值对应的索引值
minvalue=meanvalue[minindex]#最小BER值

up=std_up[minindex]
down=std_down[minindex]
a=(meanvalue[(meanvalue<up)&(meanvalue>down)].index)[0]
tmp=meanvalue[a]


#创建画布，开始绘图
fig = plt.figure()
ax = fig.add_subplot(1,1,1)

font1 = {'family':'Times New Roman',
         'weight':'bold',
         'size': 16}
plt.tick_params(labelsize=16)
plt.xlim(1,80)
plt.ylim(10,35)
x=np.linspace(1,80,80)#刻度1：1：80
line_mean = ax.plot(x,meanvalue, 'r-', label='BER_mean',linewidth = 2)#BER平均值变化曲线
line_down=ax.plot(x,std_down ,'b:', label='BER_down',linewidth = 2)#（BER平均值-标准差）变化曲线
line_up=ax.plot(x,std_up, 'b:', label='BER_up',linewidth = 2)#（BER平均值+标准差）变化曲线
ax.fill_between(x,std_up,std_down,color='gray',alpha=0.25)#填充上下标准差之间的范围
line_h=ax.hlines(up,1,80,'r',alpha=0.25,linewidth = 2)#画横线BER最小值+对应标准差处的
ax.plot(minindex,minvalue,color='r',marker='o',markersize = 10)#作marker，在BER最小值位置
ax.plot(a,tmp,'r^',markersize = 10)#作marker，在最小允许特征子集处
ax.set_xticks([1,7,10,20,30,40,50,60,67,70,80])#标出需要添加的横坐标

ax.set_xticklabels([1,' ',' ',20,30,40,50,60,' ',' ',80],size=16)
# ax.set_xticks([10.5, 39], minor=True)
# ax.set_xticklabels(['10 11', '38 40'], minor=True,size=16)

ax.set_xticks([8,68], minor=True)
ax.set_xticklabels(['7 10','67 70'], minor=True,size=16)

for line in ax.xaxis.get_minorticklines():
    line.set_visible(False)


line_v=plt.vlines(minindex,0,minvalue,'r',alpha=0.25,linewidth = 2)#画竖线，最小BER位置处
line_v1=plt.vlines(a,0,tmp,'r',alpha=0.25,linewidth = 2)#画竖线，最小特征值对应位置处
plt.legend(loc='upper right',fontsize = 16)#制定label的位置
# plt.title('BER for LR')
plt.xlabel("Number of features",font1)
plt.ylabel("BER(%)",font1)
plt.show()



print("test")
