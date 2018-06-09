clc;
clear all;
addpath(genpath('E:/预测低血容量/201703'))

%本程序主要用来测试已经根据（60，21，62）筛选出来的急性低血压样本，是否满足AHE的原始定义，
% 将满足条件的文件移动至destpath文件夹中

path='M:\AHE\新建文件夹\可用\';%存放数据的文件夹
destpath='M:\AHE\新建文件夹\可用\new\';
FileList=dir(path);%提取文件夹下的文件
cd(path);
for i=1:length(FileList)
   filename_i=FileList(i).name;%%子文件夹的名称
   if (filename_i(1)=='s' )
       loaddata=open(filename_i);
       input=loaddata.AHE_tmp;
       inputdata=input(:,4);
      [ AHEdata,INI,INI0,len,AHE_episode] = findAHE( inputdata,60,21,62,0.9);%用于测试AHE定义条件
      if length(AHEdata)>0
          movefile(filename_i,destpath);
      end
   end
end