clc
clear all
addpath(genpath('E:/预测低血容量/201703/筛选非低血压病例'))
%程序流程
%   1.提取出所有发生低血压的病例的文件名称
%   2.将发生低血压的病例的数据文件夹移动到指定位置，剩下的即为未发生低血压的数据

% %%提取所有发生AHE的病例编号
% pathahe='L:\AHE'
% FileList=dir(pathahe);
% cd(pathahe);
% for i=1:length(FileList)
%     if FileList(i).isdir == 0
%         filename_i=FileList(i).name;
%         file_ahe(i,:)=filename_i(:,1:6);
%     end  
% end
% 
% %%将所有发生AHE的文件夹移动至指定位置，从剩下的样本中挑选未发生AHE的
% path_all='L:\Available'
% cd(path_all)
% FileList_all=dir(path_all);
% for j=1:length(file_ahe)
%    tmpname=file_ahe(j,:);
%    if tmpname(1) == 's'
%        if (exist(tmpname)==7)
%             movefile(tmpname,'L:\AHEdir');
%        else
%            continue;
%        end
%    end
% end

%%根据_selected.mat挑选未发生低血压病例
path_nonAHE='L:\Available'%不用切换了，路径没有变化
cd (path_nonAHE)
FileList_nonAHE=dir(path_nonAHE);%所有未发生AHE的数据文件夹
for k=1:length(FileList_nonAHE)
   nonAHEname=FileList_nonAHE(k).name;%未发生AHE文件夹名称
   if nonAHEname(1)=='s'
       cd(FileList_nonAHE(k).name); %跳进文件夹
       FileList_data=dir('*select.mat');
       for numdata=1:length(FileList_data)
          tmpname=FileList_data.name;
          load(tmpname);
          [startpoint,output_data]=selectnon(val_final(:,4));
          if length(output_data)>0 
              nonAHE_data=val_final(startpoint:startpoint+659,1:end);
              name_nonAHE=[tmpname(1:end-10),'non.mat'];
              save(['L:\nonAHE\',name_nonAHE],'nonAHE_data');
          end

       end
       cd ..
   end
   
end
