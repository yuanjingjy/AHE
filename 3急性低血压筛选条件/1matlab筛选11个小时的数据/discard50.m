clc;
clear all;
addpath(genpath('F:\F盘\Project\急性低血压\3.急性低血压筛选条件\1matlab筛选11个小时的数据'))

path='D:\1yj_nonAHE';%存放数据的文件夹
FileList=dir(path);%提取文件夹下的文件
cd(path)%路径切换到存放数据的文件夹
for i=1:length(FileList)
   filename_i=FileList(i).name;%%子文件夹的名称
   if (filename_i(1)=='s' )
      load(filename_i)
      
%       for i=1:7
% %           loss(1,i)=length(find(AHE_tmp(1:600,i)<=0));%统计缺失值的个数
%           loss(1,i)=length(find(AHE_tmp(1:600,i)<=0));%统计缺失值的个数
%           loss_50(1,i)=(loss(1,i)>180);%统计各参数缺失比例是否超过40%，是为1
%       end
%       loss_num=sum(loss_50);%统计缺失比例超过40%的特征值的个数
      [row_neg,col_neg]=find(nonAHE_data(601:660,4)<=0);
      num_neg=length(row_neg);
      if num_neg>5
         movefile(filename_i,'D:\1yj_nonAHE\discard'); 
      end
   end
end