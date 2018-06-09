clc
clear all

%Description:
%   调用selectnon.m文件，筛选未发生急性低血压的样本
%Input:
%   path_nonAHE='D:\Available_yj\already\*select.mat'：该路径下的发生AHE的原始数据已转移
%Output：
%   path='D:\1yj_nonAHE\*_non.mat'


%% 根据_selected.mat挑选未发生低血压病例
path_nonAHE='D:\Available_yj\already'%不用切换了，路径没有变化
cd (path_nonAHE)
FileList_nonAHE=dir(path_nonAHE);%所有未发生AHE的数据文件夹
for k=1:length(FileList_nonAHE)
   nonAHEname=FileList_nonAHE(k).name;%未发生AHE文件夹名称
   if nonAHEname(1)=='s'
       cd(FileList_nonAHE(k).name); %跳进文件夹
       FileList_data=dir('*select.mat');
       for numdata=1:length(FileList_data)
          tmpname=FileList_data(numdata).name;
          load(tmpname);
          [startpoint,output_data]=selectnon(val_final);
          if length(output_data)>0 
              nonAHE_data=val_final(startpoint:startpoint+659,1:7);
              name_nonAHE=[tmpname(1:end-10),'non.mat'];
              save(['D:\1yj_nonAHE\',name_nonAHE],'nonAHE_data');
          end

       end
       cd ..
   end
   
end

