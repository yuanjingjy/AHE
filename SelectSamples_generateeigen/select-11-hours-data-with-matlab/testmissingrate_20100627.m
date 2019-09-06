clc
clear all;

path = 'D:\01Ô¬¾§\Githubcode\AHE\Data\AHE_2019'
cd(path);
addpath(genpath('D:\01Ô¬¾§\Githubcode\AHE\SelectSamples_generateeigen\select-11-hours-data-with-matlab'))
file = dir(path);

count = 0;
missing_rate = [];
for i = 1:length(file)
   filename_i = file(i).name;
   if filename_i(1)=='s'
      load (filename_i); 
      data_i = selected_data(1:600,:);
      for k = 1:7
         [m,n]=find(data_i(:,k)<=0);
         if length(n) >300
            count= count +1;
            continue;
         end
       missing_rate(i-2,k) = length(n); 
      end
   end
end