clc;
clear all;
%addpath(genpath('F:\F盘\Project\急性低血压\3.急性低血压筛选条件\1matlab筛选11个小时的数据'))
addpath(genpath('..\AHE\SelectSamples\select-11-hours-data-with-matlab'))

% Description:
%   从.hea文件中提取患者的年龄和性别，对于缺失情况用-100代替，然后从临床数据库
%   中提取或插值补全
% Input:
%   path='D:\Available_yj\already\*nm.hea'
%Output:
%   path='D:\Available_yj\already\*_age.mat'

path='D:\Available_yj\already\';%存放数据的文件夹
FileList=dir(path);%提取文件夹下的文件
cd(path)%路径切换到存放数据的文件夹

for i=1:length(FileList)
   filename_i=FileList(i).name;%%子文件夹的名称
   if (FileList(i).isdir==1 && filename_i(1)=='s' )%s开头的文件夹
      cd(FileList(i).name);%路径切换到子文件夹中
      displaystr=['===========Now Processing ',FileList(i).name,'================='];
      disp(displaystr);
      file_tmp=dir('*nm.hea');%查找子文件夹中的hea文件
      
      %=====对于每一个hea文件，从中提取出所记录数据的名称、基线、增益======%
     for j=1:length(file_tmp)%对于每一个hea文件
         filename_tmp=file_tmp(j).name; %文件的名称
         fid=fopen(filename_tmp);%获取文件的id编号         
         lines = get_lines( fid ); %文件行数      
         data=importdata(filename_tmp,'\t');%读入头文件文本
         [row_data,col_data]=size(data);
         hea_end=0;
         for data_i=1:row_data
            data_tmp=cell2mat(data(data_i));
            if data_tmp(1)=='#' 
                data_split=regexp(data_tmp,' ','split');
                if strcmp(data_split{1,2},'<age>:')
                    age_tmp=data_split{1,3};
                    sex_tmp=data_split{1,5};
                    len=length(age_tmp);
                  
                    %% 对年龄的特殊处理，如果年龄大于两位数，则年龄为300岁；如果年龄用？？
                    %表示，年龄记录缺失，用-100表示；此外，年龄是两位正整数，直接字符串转数值
                    if len>2 
                        agesex(1)=300;
                    else
                        if strcmp(age_tmp,'??')
                            agesex(1)=-100;
                        else
                            agesex(1)=str2num(age_tmp);   
                        end
                    end
                    
                    
                  %% 对性别的特殊处理，?表示缺失，用-100代替，F用1表示
                  %对于年龄和性别的缺失情况，从临床数据库中找到并补全
                    if strcmp(sex_tmp,'?')
                        agesex(2)=-100
                    end
                    if strcmp(sex_tmp,'F')
                        agesex(2)=1;
                    else
                        agesex(2)=0;
                    end
                end
                agename=[filename_tmp(1:end-4),'_age.mat'];                
                save (agename, 'agesex')
            end
            
         end         
        
%          save (hea_name, 'headfile')
         fclose(fid);       
   end
          
      cd ..%返回上一级目录
   end
end
