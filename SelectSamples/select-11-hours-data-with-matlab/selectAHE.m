clc;
clear all;
addpath(genpath('F:\F��\Project\���Ե�Ѫѹ\3.���Ե�Ѫѹɸѡ����\1matlabɸѡ11��Сʱ������'))

path='D:\Available_yj\already\';%������ݵ��ļ���
FileList=dir(path);%��ȡ�ļ����µ��ļ�
cd(path)%·���л���������ݵ��ļ���
for i=1:length(FileList)
   filename_i=FileList(i).name;%%���ļ��е�����
   if (FileList(i).isdir==1 && filename_i(1)=='s' )
      cd(FileList(i).name);%·���л������ļ�����
      displaystr=['===========Now Processing ',FileList(i).name,'================='];
      disp(displaystr);
      file_tmp=dir('*_select.mat');%�������ļ����е�mat�ļ�
      
      %=====����ÿһ��_select.mat�ļ���ȡ������������ɸѡAHE����=====%
     for j=1:length(file_tmp)%����ÿһ��mat�ļ�
         filename_tmp=file_tmp(j).name; %�ļ�������
         load(filename_tmp)
      
      %===========================�ж��Ƿ���AHE=========================%
      [AHEdata] = findAHE( val_final,60,30,60,0.9);
      AHEname=[filename_tmp(1:end-4),'_AHE.mat'];
      if length(AHEdata)>0
          AHE_tmp=AHEdata;
          save(['D:\1yj_AHE\',AHEname],'AHE_tmp');
      end
      
    end
      
     
      cd ..%������һ��Ŀ¼
   end
end
