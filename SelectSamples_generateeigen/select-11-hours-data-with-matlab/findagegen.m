%将2089个subject_id对应的年龄性别都提取出来，放到一个文件中，建模时和特征值矩阵进行匹配。

clc
clear all
addpath('D:\01袁晶\Githubcode\AHE\SelectSamples_generateeigen\select-11-hours-data-with-matlab');

path_ahe = 'D:\01袁晶\AHEdata\processed_2019\a_rawdata\AHE\available'
cd(path_ahe)
FileList_ahe = dir(path_ahe);
filelabel = struct('filename',{},'subject_id',{},'classlabel',{});
k_file = 1;
for i_ahe = 1:length(FileList_ahe)
    filename_ahei = FileList_ahe(i_ahe).name;
    if filename_ahei(1)=='s'
        filelabel(k_file).filename = filename_ahei(1:end-4);
        filelabel(k_file).subject_id = str2num(filename_ahei(2:6));
        filelabel(k_file).classlabel = 1;
        k_file = k_file+1;
    end
end

path_nonahe = 'D:\01袁晶\AHEdata\processed_2019\a_rawdata\nonAHE\available';
cd (path_nonahe)
FileList_nonahe = dir(path_nonahe);
for i_nonahe = 1:length(FileList_nonahe)
   filename_nonahei = FileList_nonahe(i_nonahe).name;
   if filename_nonahei(1) == 's'
      filelabel(k_file).filename = filename_nonahei(1:end-4);
      filelabel(k_file).subject_id = str2num(filename_ahei(2:6));
      filelabel(k_file).classlabel = 0;
      k_file = k_file+1;
   end
end


path = 'D:\01袁晶\AHEdata\already'
cd(path)
FileList = dir(path);
final = struct('filename',{},'age',{},'gender',{});
k = 1;
for i = 1:length(FileList)
    filename_i = FileList(i).name;
    if FileList(i).isdir ==1 && filename_i(1)=='s'
        cd(FileList(i).name);%路径切换到子文件夹中
        file_tmp=dir('*_age.mat');%查找子文件夹中的mat文件
        
        for j=1:size(file_tmp)%对于每一个mat文件
            filename_tmp=file_tmp(j).name; %文件的名称        
            load(filename_tmp)
            final(k).filename = filename_tmp(1:end-8);
            final(k).age = agesex(1);
            final(k).gender = agesex(2);
            k = k+1;
        end  
        
        cd ..
    end
end
