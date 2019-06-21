%Description��
%   ��path='\already\*_selected.mat'�ļ��У��ж�T0ʱ�̵�λ�ã�����¼��һ��T0��Ӧ��λ��
%   subjectid-�ļ����-���ݶγ���-T0λ��-���ݶ���ʼʱ��-T0��Ӧ��ʱ��
%Input:
%   path='D:\Available_yj\already\*_select.mat'
%Output:
%   ���Ԫ������

clc;
clear all;
addpath(genpath('D:\01Ԭ��\Githubcode\AHE\SelectSamples_generateeigen\select-11-hours-data-with-matlab'))
path='D:\01Ԭ��\AHEdata\already';%������ݵ��ļ���
FileList=dir(path);%��ȡ�ļ����µ��ļ�
cd(path)%·���л���������ݵ��ļ���
num_sample = 1;
for i=1:length(FileList)
   filename_i=FileList(i).name;%%���ļ��е�����
   if (FileList(i).isdir==1 && filename_i(1)=='s' )
      cd(FileList(i).name);%·���л������ļ�����
      displaystr=['===========Now Processing ',FileList(i).name,'================='];
      disp(displaystr);
      file_tmp=dir('*_select.mat');%�������ļ����е�mat�ļ�

      %=====����ÿһ��_select.mat�ļ���ȡ������������ɸѡAHE����=====%
     for j=1:size(file_tmp)%����ÿһ��mat�ļ�
         filename_tmp=file_tmp(j).name; %�ļ�������        
         load(filename_tmp)
         
         [ns,nf] = size(val_final);
         if ns<60 || nf<7
            continue
         else
            for i = 1:5:(ns-60)
               X_input = val_final(i:i+59,4);
               [ ahe_find] = AHEEpisode( X_input,30,60,0.9 ); 
               if ahe_find == 1 
                   filetosave(num_sample,1)={filename_tmp(:,1:end-11)};
                   filetosave(num_sample,2)={filename_tmp(:,2:6)};
                   filetosave(num_sample,3)={ns};
                   filetosave(num_sample,4)={i}
                   num_sample = num_sample +1 ;
                   break;
               end 
            end
         end
     end
     clear val_final, ns
     
      cd ..%������һ��Ŀ¼
   end
end

save('D:\01Ԭ��\AHEdata\filetosave.mat','filetosave')
xlswrite('D:\01Ԭ��\AHEdata\test.xlsx',filetosave,'Sheet1')
