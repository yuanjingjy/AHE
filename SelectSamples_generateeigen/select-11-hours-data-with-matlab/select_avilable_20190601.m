%Description：
%   根据findT0.m的运行结果，筛选出可用的AHE样本，筛选流程如下：
%       1.首选过滤T0大于600，既满足挑战赛介绍，T0之前至少有10小时的数据；
%       2.对subject_id进行过滤，对于同一subject_id对应多条发生AHE的数据记录
%           的情况，根据时间，选择第一次发生AHE的情况
%       3.根据文件名称及T0位置，从数据文件夹中进行读入并截取出所需的11小时数据段
%       4.根据数据缺失情况进一步进行筛选，主要筛选T0之前10小时的缺失比例。
%           （筛选T0时条件为[10,60]的数据比例超过90%，缺失情况应该不是很严重，此处需进一步验证）。
%Input：
%   findT0.m的运行结果，D:\01袁晶\AHEdata\filetosave.mat文件
%Output：
%  新建文件夹，存储筛选出的可用的11小时的数据段。

clc
clear all
%% filetosave_ahe为findT0.m的运行结果，第1列文件名， 第2列subject_id, 
%第3列数据记录总长度（分钟为单位），第4列为T0位置。下面的程序段根据T0的位置，
%找到T0大于600的数据段（保证T0前面至少10小时），并且每个病人只取一个记录（时间
%在前面的）
load D:\01袁晶\AHEdata\filetosave_ahe.mat
t0LT10h = filetosave(cell2mat(filetosave(:,4))>600,:);%T0Larger than 10小时的数据
t0LT10h = sortrows(t0LT10h,1);%按照记录时间进行排序
[c,ia,ib] = unique(t0LT10h(:,2));%ia中保存的是每个subject_id第一次出现对应的行号
selected_AHE = t0LT10h(ia,:);
selected_AHE(:,5) = {1};
path='D:\01袁晶\AHEdata\already\';%存放数据的文件夹
cd(path);

%% 截取发生AHE的数据段，并将subject_id对应的文件夹移动至AHEdir，方便后续
%  从剩余的文件夹中筛选未发生AHE的样本
for i = 1:length(selected_AHE)
    filename_i = [cell2mat(selected_AHE(i,1)),'_select.mat'];%数据文件名称
    dir_i = filename_i(1,1:6);%文件夹名称
    t0 = cell2mat(selected_AHE(i,4));%T0的位置
    cd(dir_i);
    load(filename_i);
    selected_data = val_final(t0-600:t0+59,1:7);%t0前面600个数据，后面59个数据
    flag_missrate = 0;
%     for k = 1:7
%         [m,n] = find(val_final(1:600,k)<=0);
%         if length(m) >180
%             flag_missrate = 1;
%            break; 
%         end
%     end
    if flag_missrate == 0 
        savename = ['D:\01袁晶\AHEdata\AHE_2019\',cell2mat(selected_AHE(i,1)),'.mat'];
        save (savename, 'selected_data');%保存截取出的数据段
        cd ..
        movefile(dir_i,'D:\01袁晶\AHEdata\already\AHEdir');%筛选完AHE的文件夹进行移动，从剩下的里面筛选未发生AHE的
        clear selected_data
        clear val_final
        clear t0   
    else
        cd ..
    end
    

end

%% 开始筛选未发生AHE的样本
addpath(genpath('D:\01袁晶\Githubcode\AHE\SelectSamples_generateeigen\select-11-hours-data-with-matlab'))
path='D:\01袁晶\AHEdata\already\';%存放数据的文件夹
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
         [ns,nf] = size(val_final);%计算数据段长度
         if ns<60 || nf<7
            continue
         end
         [startpoint,output_data]=selectnon(val_final);
         if length(output_data)>0 
             datafile=val_final(startpoint:startpoint+599,4);
             %% 判断T0之前是否发生了AHE，发生的去掉 
               flag = 0;
               for i=1:5:540      
                   X_input = datafile(i:i+59,1);
                   [ ahe_find] = AHEEpisode( X_input,30,60,0.9 );
                  if ahe_find == 1
                     flag = 1; 
                  end
               end
     
                if flag == 1
                    continue; %flag为1，表示T0之前发生了AHE，删除该段数据，
                end
                
             %筛选出来的未发生AHE的，同前，存储文件名称、subject_id，数据段总
             %长度、T0位置
             filetosave_non(num_sample,1)={filename_tmp(:,1:end-11)};
             filetosave_non(num_sample,2)={filename_tmp(:,2:6)};
             filetosave_non(num_sample,3)={ns};
             filetosave_non(num_sample,4)={startpoint+600};
             num_sample = num_sample +1 ;
             clear val_final, ns
         end     
     end
   cd ..%返回上一级目录
   end
end

save('D:\01袁晶\AHEdata\filetosave_non.mat','filetosave_non')
xlswrite('D:\01袁晶\AHEdata\nonahe.xlsx',filetosave,'Sheet1')

t0LT10h_non = filetosave_non(cell2mat(filetosave_non(:,4))>=600,:);%T0Larger than 10小时的数据
t0LT10h_non = sortrows(t0LT10h_non,1);%按照记录时间进行排序
[c,ia,ib] = unique(t0LT10h_non(:,2));%ia中保存的是每个subject_id第一次出现对应的行号
selected_nonAHE = t0LT10h_non(ia,:);
selected_nonAHE(:,5) = {0};%标签列，未发生AHE的，标0


for i = 1:length(selected_nonAHE)
    filename_i = [cell2mat(selected_nonAHE(i,1)),'_select.mat'];
    dir_i = filename_i(1,1:6);
    t0 = cell2mat(selected_nonAHE(i,4));
    cd(dir_i);
    load(filename_i);
    selected_data_non = val_final(t0-600:t0+59,1:7);
      
    savename = ['D:\01袁晶\AHEdata\nonAHE_2019\',cell2mat(selected_nonAHE(i,1)),'.mat'];
    save (savename, 'selected_data_non');
    cd ..
    clear selected_data_non
    clear val_final
    clear t0
end

selected = [selected_AHE;selected_nonAHE];
save ('D:\01袁晶\AHEdata\total_stat.mat','selected');
xlswrite('D:\01袁晶\AHEdata\total_stat.xlsx',selected,'Sheet1')