%��2089��subject_id��Ӧ�������Ա���ȡ�������ŵ�һ���ļ��У���ģʱ������ֵ�������ƥ�䡣

clc
clear all
addpath('D:\01Ԭ��\Githubcode\AHE\SelectSamples_generateeigen\select-11-hours-data-with-matlab');

path_ahe = 'D:\01Ԭ��\AHEdata\processed_2019\a_rawdata\AHE\available'
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

path_nonahe = 'D:\01Ԭ��\AHEdata\processed_2019\a_rawdata\nonAHE\available';
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


path = 'D:\01Ԭ��\AHEdata\already'
cd(path)
FileList = dir(path);
final = struct('filename',{},'age',{},'gender',{});
k = 1;
for i = 1:length(FileList)
    filename_i = FileList(i).name;
    if FileList(i).isdir ==1 && filename_i(1)=='s'
        cd(FileList(i).name);%·���л������ļ�����
        file_tmp=dir('*_age.mat');%�������ļ����е�mat�ļ�
        
        for j=1:size(file_tmp)%����ÿһ��mat�ļ�
            filename_tmp=file_tmp(j).name; %�ļ�������        
            load(filename_tmp)
            final(k).filename = filename_tmp(1:end-8);
            final(k).age = agesex(1);
            final(k).gender = agesex(2);
            k = k+1;
        end  
        
        cd ..
    end
end
