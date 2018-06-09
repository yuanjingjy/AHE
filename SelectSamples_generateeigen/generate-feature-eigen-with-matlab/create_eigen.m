clc
clear all
addpath(genpath('..\AHE\SelectSamples\generate-feature-eigen-with-matlab'))

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
%   final_eigen：特征值矩阵，不包含年龄、性别
%% 初始化特征值矩阵final_eigen
final_eigen=zeros(1648,72);%所有训练集测试集数据共1648例
final_eigen(1:754,end)=1;%发生急性低血压的1，共754例,有一个时间格式不对的，单独算
final_eigen(755:end,end)=0;


%% 加载数据
threshhold=[250,200,200,200,200,100,100];%各生理参数上限值，超过定义为异常

pathname3='AHE';
cd(pathname3);
FileList=dir;
for i=1:length(FileList)
    tmpname=FileList(i).name;
   if(tmpname(1)=='s')
       AHEname(i,:)=str2num(tmpname(2:6));
       subjectid=AHEname(i,:);
       final_eigen(i-2,71)=subjectid;
       load(tmpname)
       for j=1:7
           data=AHE_tmp(1:600,j);
           pro_abn=xigma(data);
           pro_miss=mmMissingValues(pro_abn,threshhold(j));
           
%             if j==4
%                ABPMean_AHE(:,i)=pro_miss;
%            end
           
            %% 血压数据进行有创变无创处理
            if j==2 || j==3 || j==4
               pro_miss=reSample(pro_miss);
            end
%            pro_miss=reSample(pro_miss);
           eigen=tezhengzhi(pro_miss);%提取特征值
           start=(j-1)*10+1;
           final_eigen(i-2,start:start+9)=eigen;
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
       final_eigen(i-2+754,71)=subjectid;
       load(tmpname)
       for j=1:7
           data=nonAHE_data(1:600,j);
           pro_abn=xigma(data);
           pro_miss=mmMissingValues(pro_abn,threshhold(j));
           
%            if j==4
%                ABPMean_nonAHE(:,i)=pro_miss;
%            end
           
            if j==2 || j==3 || j==4
               pro_miss=reSample(pro_miss);
            end
%            pro_miss=reSample(pro_miss);
           eigen=tezhengzhi(pro_miss);
           start=(j-1)*10+1;
           final_eigen(i-2+754,start:start+9)=eigen;
       end
   end
end
cd ..

% load final_eigen
%特征值中的空值NAN用均值进行替换，因为空值替换程序是针对单个生理参数的11个特征值
%进行替换的，而整个特征值矩阵是7个变量的77个特征值排列到一起，所以需要调用7次
%pro_nan函数
for k=1:7
    start=(k-1)*10+1;
   tmp=final_eigen(:,start:start+9);
   pro_nandata=pro_nan(tmp);
   final_eigen(:,start:start+9)=pro_nandata;
end

