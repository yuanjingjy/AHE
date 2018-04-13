clc;
clear all;
addpath(genpath('F:\F盘\Project\急性低血压\3.急性低血压筛选条件\1matlab筛选11个小时的数据'))

path='D:\Available_yj\already\';%存放数据的文件夹
FileList=dir(path);%提取文件夹下的文件
cd(path)%路径切换到存放数据的文件夹
for i=1:length(FileList)
   filename_i=FileList(i).name;%%子文件夹的名称
   if (FileList(i).isdir==1 && filename_i(1)=='s' )
      cd(FileList(i).name);%路径切换到子文件夹中
      displaystr=['===========Now Processing ',FileList(i).name,'================='];
      disp(displaystr);
      file_tmp=dir('*_select.mat');%查找子文件夹中的mat文件
      
      %=====对于每一个_select.mat文件，取出第四列用来筛选AHE样本=====%
     for j=1:length(file_tmp)%对于每一个mat文件
         filename_tmp=file_tmp(j).name; %文件的名称
         load(filename_tmp)
      
      %===========================判断是否发生AHE=========================%
      [AHEdata] = findAHE( val_final,60,30,60,0.9);
      AHEname=[filename_tmp(1:end-4),'_AHE.mat'];
      if length(AHEdata)>0
          AHE_tmp=AHEdata;
          save(['D:\1yj_AHE\',AHEname],'AHE_tmp');
      end
      
    end
      
     
      cd ..%返回上一级目录
   end
end
