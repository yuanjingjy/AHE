clc;
clear all;
addpath(genpath('E:/Ԥ���Ѫ����/201703'))

path='M:\AHE\�½��ļ���\����\';%������ݵ��ļ���
destpath='M:\AHE\�½��ļ���\����\new\';
FileList=dir(path);%��ȡ�ļ����µ��ļ�
cd(path);
for i=1:length(FileList)
   filename_i=FileList(i).name;%%���ļ��е�����
   if (filename_i(1)=='s' )
       loaddata=open(filename_i);
       input=loaddata.AHE_tmp;
       inputdata=input(:,4);
      [ AHEdata,INI,INI0,len,AHE_episode] = findAHE( inputdata,60,21,62,0.9);
      if length(AHEdata)>0
          movefile(filename_i,destpath);
      end
   end
end