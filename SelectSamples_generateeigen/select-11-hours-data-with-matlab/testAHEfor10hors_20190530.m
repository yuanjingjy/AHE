%Description��
%   �޸�������Ҫ���ж��Ѿ�ɸѡ������������ǰ10��Сʱ���Ƿ�����AHE
%Input��
%   �Ѿ�ɸѡ������������ǰ10��Сʱ������
%Output��
%   ����AHE��ͷ�AHE�飬ÿ��õ�һ��countֵ����¼����AHE����������

clc
clear all
path = 'D:\01Ԭ��\AHEdata\AHE_2019';
cd(path)
addpath(genpath('D:\01Ԭ��\Githubcode\AHE\SelectSamples_generateeigen\select-11-hours-data-with-matlab'))
count = 0;
FileList = dir(path);
for i = 1:length(FileList)
   filename_i = FileList(i).name ;
   if (filename_i(1)=='s' )
      load (filename_i)
      datafile = selected_data(1:600,4); 
      for i=1:5:540
         X_input = datafile(i:i+59,1);
         [ ahe_find] = AHEEpisode( X_input,30,60,0.9 );
         if ahe_find ==1
            count = count + 1;
            break; 
         end
      end
      clear AHE_data
   end
end