%Description：
%   从path='\already\*_selected.mat'文件中，判断T0时刻的位置，并记录第一个T0对应的位置
%   subjectid-文件编号-数据段长度-T0位置-数据段起始时间-T0对应的时间
%Input:
%   path='D:\Available_yj\already\*_select.mat'
%Output:
%   输出元胞数组

clc;
clear all;
addpath(genpath('D:\01袁晶\Githubcode\AHE\SelectSamples_generateeigen\select-11-hours-data-with-matlab'))
path='D:\01袁晶\AHEdata\already';%存放数据的文件夹
FileList=dir(path);%提取文件夹下的文件
cd(path)%路径切换到存放数据的文件夹
num_sample = 1;
for i=1:length(FileList)
   filename_i=FileList(i).name;%%子文件夹的名称
   if (FileList(i).isdir==1 && filename_i(1)=='s' )
      cd(FileList(i).name);%路径切换到子文件夹中
      displaystr=['===========Now Processing ',FileList(i).name,'================='];
      disp(displaystr);
      file_tmp=dir('*_select.mat');%查找子文件夹中的mat文件

      %=====对于每一个_select.mat文件，取出第四列用来筛选AHE样本=====%
     for j=1:size(file_tmp)%对于每一个mat文件
         filename_tmp=file_tmp(j).name; %文件的名称        
         load(filename_tmp)
         
         [ns,nf] = size(val_final);
         if ns<60 || nf<7
            continue
         else
            for i = 1:5:(ns-60)
               X_input = val_final(i:i+59,4);
               [ ahe_find] = AHEEpisode( X_input,30,60,0.9 ); 
               if ahe_find == 1 
                   filetosave(num_sample,1)={filename_tmp(:,1:end-11)};
                   filetosave(num_sample,2)={filename_tmp(:,2:6)};
                   filetosave(num_sample,3)={ns};
                   filetosave(num_sample,4)={i}
                   num_sample = num_sample +1 ;
                   break;
               end 
            end
         end
     end
     clear val_final, ns
     
      cd ..%返回上一级目录
   end
end

save('D:\01袁晶\AHEdata\filetosave.mat','filetosave')
xlswrite('D:\01袁晶\AHEdata\test.xlsx',filetosave,'Sheet1')
