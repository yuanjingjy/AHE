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
         if ns<601 || nf<7
            continue
         else
            for m = 601:5:(ns-60)
               X_input = val_final(m:m+59,4);
               [ ahe_find] = AHEEpisode( X_input,30,60,0.9 );
               obs_ahe = 0;
               if ahe_find ==1 %找到一个AHE点，研究其前面的数据是否满足要求：前面10个小时没有发生AHE，
                   %且前面10个小时内任意生理参数的缺失比例小于30%；
                  obs_data = val_final((m-600):(m-1),1:7);%观察点前面10个小时的数据
                  count = 0;
                  for num_feature = 1:7%判断T0之前10小时内，7个生理参数的缺失比例
                     [n_row,n_col] = find(obs_data(:,num_feature)<=0);
                     if length(n_row) > 180
                        count = count +1; 
                     end
                  end
                  for k = 1:3:540%本循环判断T0之前10个小时内是否发生了AHE
                     test_input = obs_data(k:k+59,4);
                     [test_ahe] = AHEEpisode(test_input,30,60,0.9);                    
                     if test_ahe == 1 
                         obs_ahe = 1;
                         break;
                     end
                  end
               end               
               if ahe_find == 1 && obs_ahe == 0 && count == 0
                   filetosave(num_sample,1)={filename_tmp(:,1:end-11)};
                   filetosave(num_sample,2)={filename_tmp(:,2:6)};
                   filetosave(num_sample,3)={ns};
                   filetosave(num_sample,4)={m}
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

save('D:\01袁晶\AHEdata\filetosave_ahe.mat','filetosave')
xlswrite('D:\01袁晶\AHEdata\test.xlsx',filetosave,'Sheet1')
