clc
clear all

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
%   3.提取完直接复制粘贴到特征值矩阵中的

addpath(genpath('..\AHE\SelectSamples\generate-feature-eigen-with-matlab'))
codepath='..\AHE\SelectSamples\generate-feature-eigen-with-matlab';
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
