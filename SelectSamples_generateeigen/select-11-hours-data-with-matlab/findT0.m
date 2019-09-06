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
         if ns<601 || nf<7
            continue
         else
            for m = 601:5:(ns-60)
               X_input = val_final(m:m+59,4);
               [ ahe_find] = AHEEpisode( X_input,30,60,0.9 );
               obs_ahe = 0;
               if ahe_find ==1 %�ҵ�һ��AHE�㣬�о���ǰ��������Ƿ�����Ҫ��ǰ��10��Сʱû�з���AHE��
                   %��ǰ��10��Сʱ���������������ȱʧ����С��30%��
                  obs_data = val_final((m-600):(m-1),1:7);%�۲��ǰ��10��Сʱ������
                  count = 0;
                  for num_feature = 1:7%�ж�T0֮ǰ10Сʱ�ڣ�7�����������ȱʧ����
                     [n_row,n_col] = find(obs_data(:,num_feature)<=0);
                     if length(n_row) > 180
                        count = count +1; 
                     end
                  end
                  for k = 1:3:540%��ѭ���ж�T0֮ǰ10��Сʱ���Ƿ�����AHE
                     test_input = obs_data(k:k+59,4);
                     [test_ahe] = AHEEpisode(test_input,30,60,0.9);                    
                     if test_ahe == 1 
                         obs_ahe = 1;
                         break;
                     end
                  end
               end               
               if ahe_find == 1 && obs_ahe == 0 && count == 0
                   filetosave(num_sample,1)={filename_tmp(:,1:end-11)};
                   filetosave(num_sample,2)={filename_tmp(:,2:6)};
                   filetosave(num_sample,3)={ns};
                   filetosave(num_sample,4)={m}
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

save('D:\01Ԭ��\AHEdata\filetosave_ahe.mat','filetosave')
xlswrite('D:\01Ԭ��\AHEdata\test.xlsx',filetosave,'Sheet1')
