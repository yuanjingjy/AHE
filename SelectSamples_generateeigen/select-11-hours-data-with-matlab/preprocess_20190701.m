%Desciption:
%   对数据进行异常值剔除、线性插值后，存储到‘D:\01袁晶\AHEdata\processed_2019\AHE’中
%Input：
%   筛选出的AHE和弄AHE样本，D:\01袁晶\AHEdata\AHE_2019中
%Output：
%   输出存储到‘D:\01袁晶\AHEdata\processed_2019\AHE’中
clc;
clear all;

path = 'D:\01袁晶\AHEdata\AHE_2019';
addpath('D:\01袁晶\Githubcode\AHE\SelectSamples_generateeigen\select-11-hours-data-with-matlab');

cd(path);
FileList = dir(path);

for i = 1:length(FileList)
   filename_i = FileList(i).name ;
   if (filename_i(1)=='s' )
      load (filename_i);
      outprocess = outdata(selected_data);
%       outprocess = selected_data;
%       gap = 0;
      for num_fea = 1:7;
          data_fea_i = outprocess(:,num_fea);
          [outputdata(:,num_fea)] = mmMissingValues(data_fea_i);
%           gap = max(gap,gap_tmp);
      end
      
%       if gap > 60
%              movefile( filename_i,'D:\01袁晶\AHEdata\nonAHE_2019\gap');
%       end
%       
      savename = ['D:\01袁晶\AHEdata\processed_2019\AHE\',filename_i];
      save (savename,'outputdata');
      clear selected_data
      clear outputdata
   end
   
end

% figure
% data = selected_data(:,4);
% plot(data);
% hold on
% for i = 1:700
%     y(1,i) = 60;
% end
% plot(y);
% hold on
% x=600;
% plot([600,600],[40,100]);
% % hold on
% data2 = outputdata(:,4);
% plot(data2);