clc
clear all
addpath(genpath('..\AHE\DataProcess_MachineLearning\MEWS'))

%Description：
%   取AHE和nonAHE数据中预测窗口前30min的HR、RR、SBP用于计算MEWS
%Input：
%   筛选出来的发生AHE和未发生AHE的11小时数据段
%Output:
%   final_eigen,共11列，分别为HR、SBP、RR的最大、最小、平均值以及subject_id、classlabel

%% 初始化特征值矩阵final_eigen
final_eigen=zeros(1648,11);%所有训练集测试集数据共358例
final_eigen(1:755,end)=1;
final_eigen(756:end,end)=0;

threshhold=[250,200,200,200,200,100,100];%阈值

pathname3='AHE';
cd(pathname3);
FileList=dir;
for i=1:length(FileList)
    tmpname=FileList(i).name;
   if(tmpname(1)=='s')
       AHEname(i,:)=str2num(tmpname(2:6));
       subjectid=AHEname(i,:);
       final_eigen(i-2,10)=subjectid;
       load(tmpname)
       start=1;
       for j=[1,2,6]%只处理计算MEWS用到的HR、RR、SBP
           data=AHE_tmp(1:600,j);%前10个小时的数据
           pro_abn=xigma(data);%处理异常数据，拉依拉准则
           pro_miss=mmMissingValues(pro_abn,threshhold(j));%处理缺失数据
           pro_MEWS=pro_miss(571:600,:);%提取发生AHE前的30min数据
           
           maxvalue=max(pro_MEWS);
           minvalue=min(pro_MEWS);
           meanvalue=mean(pro_MEWS);         
            
           eigen=[maxvalue,minvalue,meanvalue];          
           final_eigen(i-2,start:start+2)=eigen;
           start=start+3;
       end
   end
end
cd ..

pathname4='nonAHE';
cd(pathname4);
FileList=dir;
for i=1:length(FileList)
    tmpname=FileList(i).name;
   if(tmpname(1)=='s')
       nonAHEname(i,:)=str2num(tmpname(2:6));
       subjectid=nonAHEname(i,:);
       final_eigen(i-2+755,10)=subjectid;
       load(tmpname)
       start=1;
       for j=[1,2,6]%只提取计算MEWS需要的HR、RR、SBP
           data=nonAHE_data(1:600,j);%前10个小时的数据
           pro_abn=xigma(data);%拉依达准则处理异常
           pro_miss=mmMissingValues(pro_abn,threshhold(j));%处理缺失数据
           pro_MEWS=pro_miss(571:600,:);%提取预测窗口前半个小时数据
           
           maxvalue=max(pro_MEWS);
           minvalue=min(pro_MEWS);
           meanvalue=mean(pro_MEWS);

           eigen=[maxvalue,minvalue,meanvalue];     
           final_eigen(i-2+755,start:start+2)=eigen;
           start=start+3;
       end
   end
end
cd ..
