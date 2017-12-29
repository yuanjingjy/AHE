clc
clear all
addpath(genpath('E:/预测低血容量/20170510'))

% conna=database('Johndb','John','yuanjing')

%该程序的主要流程为：加载数据、去除异常数据、提取特征值、特征值筛选、神经网络

%% 初始化特征值矩阵final_eigen
final_eigen=zeros(337,78);%所有训练集测试集数据共358例
final_eigen(1:30,end)=1;%标签值为1表示发生急性低血压
final_eigen(31:60,end)=2;%标签值为2表示未发生急性低血压
label_testA=[1,1,2,1,2,2,2,2,1,1]';
final_eigen(61:70,end)=label_testA;
label_testB=[2 1 1 2 2 2 1 2 1 2 2 2 2 1 2 2 1 1 2 2 2 1 1 1 1 2 ...
    2 2 2 2 2 2 2 1 2 2 2 1 1 2]';
final_eigen(71:110,end)=label_testB;
final_eigen(111:238,end)=1;
final_eigen(239:end,end)=2;


%% 加载数据
% load wuchuang
% %处理心电信号，提取特征值
% [row,col]=size(testdata_ABPMean);
% for i=1:col
%     tmp=testdata_HR(:,i);
%     hr_proabn=xigma(tmp);%异常值
%     hr_promiss=mmMissingValues(hr_proabn,250);%缺失值
%     eigen_HR=tezhengzhi(hr_promiss);
%     final_eigen(i,1:11)=eigen_HR;
% end
threshhold=[250,200,200,200,200,100,100];
pathname='训练集';
cd(pathname);
FileList=dir;
for i=1:length(FileList)
    tmpname=FileList(i).name;
   if(tmpname(1)=='t')
       load(tmpname)
       for j=1:7
           data=tmpdata(1:600,j);
           pro_abn=xigma(data);
           pro_miss=mmMissingValues(pro_abn,threshhold(j));
           
%            if j==4
%                ABPMean_train(:,i)=pro_miss;
%            end
           
           %% 血压数据重采样
%            if j==4 || j==5 || j==6
%                pro_miss=reSample(pro_miss);
%            end
%            pro_miss=reSample(pro_miss);
           eigen=tezhengzhi(pro_miss);
           start=(j-1)*11+1;
           final_eigen(i-2,start:start+10)=eigen;
       end
   end
end

cd ..

pathname1='测试集A';
cd(pathname1);
FileList=dir;
for i=1:length(FileList)
    tmpname=FileList(i).name;
   if(tmpname(1)=='t')
       load(tmpname)
       for j=1:7
           data=tmpdata(:,j);
           pro_abn=xigma(data);
           pro_miss=mmMissingValues(pro_abn,threshhold(j));
           pro_miss=reSample60(pro_miss);
           
%            if j==4
%                ABPMean_testA(:,i)=pro_miss;
%            end
           
%            if j==4 || j==5 || j==6
%                pro_miss=reSample(pro_miss);
%            end
%            pro_miss=reSample(pro_miss);
           eigen=tezhengzhi(pro_miss);
           start=(j-1)*11+1;
           final_eigen(i-2+60,start:start+10)=eigen;
       end
   end
end
cd ..

pathname2='测试集B';
cd(pathname2);
FileList=dir;
for i=1:length(FileList)
    tmpname=FileList(i).name;
   if(tmpname(1)=='t')
       load(tmpname)
       for j=1:7
           data=tmpdata(:,j);
           pro_abn=xigma(data);
           pro_miss=mmMissingValues(pro_abn,threshhold(j));
           pro_miss=reSample60(pro_miss);
           
%            if j==4
%                ABPMean_testB(:,i)=pro_miss;
%            end
           
%            if j==4 || j==5 || j==6
%                pro_miss=reSample(pro_miss);
%            end
%            pro_miss=reSample(pro_miss);
           eigen=tezhengzhi(pro_miss);
           start=(j-1)*11+1;
           final_eigen(i-2+70,start:start+10)=eigen;
       end
   end
end
cd ..

pathname3='AHE';
cd(pathname3);
FileList=dir;
for i=1:length(FileList)
    tmpname=FileList(i).name;
   if(tmpname(1)=='s')
       AHEname(i,:)=str2num(tmpname(2:6));
       subjectid=AHEname(i,:);
%        sql=['select icustay_id,hadm_id,icustay_admit_age,height,'...
%            'weight_first,gender from mimic2v26.icustay_detail '...
%            'where  subject_id=' num2str(subjectid)];
%        curs=exec(conna,sql)
%        curs=fetch(curs);
%        Data=curs.Data;
       load(tmpname)
       for j=1:7
           data=AHE_tmp(1:600,j);
           pro_abn=xigma(data);
           pro_miss=mmMissingValues(pro_abn,threshhold(j));
           
%             if j==4
%                ABPMean_AHE(:,i)=pro_miss;
%            end
           
%             if j==4 || j==5 || j==6
%                pro_miss=reSample(pro_miss);
%             end
%            pro_miss=reSample(pro_miss);
           eigen=tezhengzhi(pro_miss);
           start=(j-1)*11+1;
           final_eigen(i-2+110,start:start+10)=eigen;
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
       load(tmpname)
       for j=1:7
           data=nonAHE_data(1:600,j);
           pro_abn=xigma(data);
           pro_miss=mmMissingValues(pro_abn,threshhold(j));
           
%            if j==4
%                ABPMean_nonAHE(:,i)=pro_miss;
%            end
           
%             if j==4 || j==5 || j==6
%                pro_miss=reSample(pro_miss);
%             end
%            pro_miss=reSample(pro_miss);
           eigen=tezhengzhi(pro_miss);
           start=(j-1)*11+1;
           final_eigen(i-2+238,start:start+10)=eigen;
       end
   end
end
cd ..

% load final_eigen
%特征值中的空值NAN用均值进行替换，因为空值替换程序是针对单个生理参数的11个特征值
%进行替换的，而整个特征值矩阵是7个变量的77个特征值排列到一起，所以需要调用7次
%pro_nan函数
for k=1:7
    start=(k-1)*11+1;
   tmp=final_eigen(:,start:start+10);
   pro_nandata=pro_nan(tmp);
   final_eigen(:,start:start+10)=pro_nandata;
end

