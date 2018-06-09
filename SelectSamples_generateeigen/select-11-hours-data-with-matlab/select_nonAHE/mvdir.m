clc
clear all
addpath(genpath('F:\F盘\Project\急性低血压\3.急性低血压筛选条件\1matlab筛选11个小时的数据'))
%Description:
%   1.提取出所有发生低血压的病例的文件名称
%   2.将发生低血压的病例的数据文件夹移动到指定位置，剩下的即为未发生低血压的数据
% Input：
%   pathahe='D:\1yj_AHE'
%Output:
%   path='D:\Available_yj\AHEdir'

%%提取所有发生AHE的病例编号
pathahe='D:\1yj_AHE'
FileList=dir(pathahe);
cd(pathahe);
for i=1:length(FileList)
    if FileList(i).isdir == 0
        filename_i=FileList(i).name;
        file_ahe(i,:)=filename_i(:,1:6);
    end  
end

%%将所有发生AHE的文件夹移动至指定位置，从剩下的样本中挑选未发生AHE的
path_all='D:\Available_yj\already'
cd(path_all)
FileList_all=dir(path_all);
for j=1:length(file_ahe)
   tmpname=file_ahe(j,:);
   if tmpname(1) == 's'
       if (exist(tmpname)==7)
            movefile(tmpname,'D:\Available_yj\AHEdir');
       else
           continue;
       end
   end
end

