clc
clear all
addpath(genpath('F:\F盘\Project\急性低血压\3.急性低血压筛选条件\2matlab生成特征值矩阵'))

codepath='F:\F盘\Project\急性低血压\3.急性低血压筛选条件\2matlab生成特征值矩阵';

%该程序的主要流程为：加载数据、去除异常数据、提取特征值、特征值筛选、神经网络
path='D:\Available_yj\already\';%存放数据的文件夹

%% 初始化特征值矩阵final_eigen
final_eigen=zeros(1648,3);%所有训练集测试集数据共358例
final_eigen(1:754,end)=1;%发生急性低血压的1，共754例,有一个时间格式不对的，单独算
final_eigen(755:end,end)=0;

pathname3='AHE';
cd(pathname3);
FileList=dir;
for i=1:length(FileList)
    tmpname=FileList(i).name;
   if(tmpname(1)=='s')
       subjectname=[path,tmpname(1:6)];
       cd(subjectname)
       agefilename=[tmpname(1:end-15),'_age.mat'];
       load(agefilename)
       final_eigen(i-2,1)=agesex(1);
       final_eigen(i-2,2)=agesex(2);
       clear agesex
       cd ..
   end
end
cd (codepath)

pathname4='nonAHE';
cd(pathname4);
FileList=dir;
for i=1:length(FileList)
    tmpname=FileList(i).name;
   if(tmpname(1)=='s')
       subjectname=[path,tmpname(1:6)];
       cd(subjectname)
       agefilename=[tmpname(1:end-8),'_age.mat'];
       load(agefilename)
       final_eigen(i-2+754,1)=agesex(1);
       final_eigen(i-2+754,2)=agesex(2);
       clear agesex
       cd ..
   end
end
