clc
clear all
addpath(genpath('..\AHE\SelectSamples\extract-mimic-data-with-matlab'))

%Description:
%   提取所有未发生AHE样本数据记录的起始时间以及11小时数据段的起始位置
%Input:
%   ahepath='D:\1yj_nonAHE\时间有问题的\'：所有筛选出来的11小时nonAHE数据段
%Output:
%   time_point(i-2,1)=startpoint：11小时数据段的起始位置，对应单位为分钟
%   time_point(i-2,2)=ahe_id：subject_id
%   starttime_point(i-2,:)=starttime:整个数据记录的起始时间

codepath='..\AHE\SelectSamples\extract-mimic-data-with-matlab\';
ahepath='D:\1yj_nonAHE';%存放筛选出的AHE病例的路径
srcpath='D:\Available_yj\already\'%预处理后的原始数据的文件夹，AHE病例从此处提取
FileList_ahe=dir(ahepath);%提取所有AHE病例编号

for i=1:length(FileList_ahe)
    if FileList_ahe(i).isdir==0
        %————————————————————————————————%
        %找到样本对应的原始数据文件夹，src ，并切换路径src
        filename_ahe=FileList_ahe(i).name;%筛选出的AHE病例都是文件格式
        srcname=filename_ahe(1:6);%名称的前6个字符为病例编号，是对应的文件夹名称
        src=[srcpath,srcname];
        cd(src)
        
        %————————————————————————————————%
        %从样本对应的头文件中提取出记录的起始时间，并转换为和postgreSQL一致
        %的时间格式：starttime变量
        filename_hea=[filename_ahe(1:end-8),'.hea'];%对于nonAHE是减8，AHE是减15
        fid=fopen(filename_hea);
        lines=get_lines(fid);
        data=importdata(filename_hea,'\t');
        [row_hea,col_hea]=size(data);
        data_starttime=cell2mat(data(end));%头文件的最后记录的是记录的起始时间
        starttime_tmp=data_starttime(end-23:end-1);%提取出表示时间的字符串
        
        starttime=extracttime(starttime_tmp);%将提取出的时间转换成postgresql中一致的格式
        fclose(fid);
        
        %————————————————————————————————%
        %从原始数据段中，找到AHE样本对应的位置
        cd(ahepath)
        load(filename_ahe);
%         ahe_episode=AHE_tmp(:,4);%筛选到的AHE样本
        ahe_episode=nonAHE_data(:,4);%筛选到的AHE样本
        cd(src)
        
        filename_ahesrc=[filename_ahe(1:end-8),'_select.mat'];
        load(filename_ahesrc);
        ahe_source=val_final(:,4);%AHE样本的原始数据段
        startpoint  = locate_AHE( ahe_episode,ahe_source);
        clear val_final
        clear AHE_tmp
       
        
        ahe_id=str2num(srcname(2:end));
        
        time_point(i-2,1)=startpoint;
        time_point(i-2,2)=ahe_id;
        starttime_point(i-2,:)=starttime;
        
        cd (codepath)
    end
   
end
