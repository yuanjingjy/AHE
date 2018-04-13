clc;
clear all;
addpath(genpath('E:/预测低血容量/201703'))

path='L:\Available\';%存放数据的文件夹
FileList=dir(path);%提取文件夹下的文件
cd(path)%路径切换到存放数据的文件夹
for i=1:length(FileList)
   filename_i=FileList(i).name;%%子文件夹的名称
   if (FileList(i).isdir==1 && filename_i(1)=='s' )
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
                    agesex(1)=str2num(age_tmp(1:2));
                    if strcmp(sex_tmp,'F')
                        agesex(2)=1;
                    else
                        agesex(2)=0;
                    end
                end
                agename=filename_tmp(1:6);
                save (agename, 'agesex')
            end
            
         end         
        
%          save (hea_name, 'headfile')
%          fclose(fid);       
   end
          
      cd ..%返回上一级目录
   end
end
