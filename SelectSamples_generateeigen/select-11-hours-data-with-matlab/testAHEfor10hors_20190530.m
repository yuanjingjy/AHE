%Description：
%   修改论文需要，判断已经筛选出来的样本，前10个小时中是否发生了AHE
%Input：
%   已经筛选出来的样本，前10个小时的数据
%Output：
%   对于AHE组和非AHE组，每组得到一个count值，记录发生AHE的样本个数

clc
clear all
path = 'D:\01袁晶\AHEdata\AHE_2019';
cd(path)
addpath(genpath('D:\01袁晶\Githubcode\AHE\SelectSamples_generateeigen\select-11-hours-data-with-matlab'))
count = 0;
FileList = dir(path);
for i = 1:length(FileList)
   filename_i = FileList(i).name ;
   if (filename_i(1)=='s' )
      load (filename_i)
      datafile = selected_data(1:600,4); 
      for i=1:5:540
         X_input = datafile(i:i+59,1);
         [ ahe_find] = AHEEpisode( X_input,30,60,0.9 );
         if ahe_find ==1
            count = count + 1;
            break; 
         end
      end
      clear AHE_data
   end
end