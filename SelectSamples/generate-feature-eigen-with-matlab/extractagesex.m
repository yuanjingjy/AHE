clc
clear all
addpath(genpath('F:\F��\Project\���Ե�Ѫѹ\3.���Ե�Ѫѹɸѡ����\2matlab��������ֵ����'))

codepath='F:\F��\Project\���Ե�Ѫѹ\3.���Ե�Ѫѹɸѡ����\2matlab��������ֵ����';

%�ó������Ҫ����Ϊ���������ݡ�ȥ���쳣���ݡ���ȡ����ֵ������ֵɸѡ��������
path='D:\Available_yj\already\';%������ݵ��ļ���

%% ��ʼ������ֵ����final_eigen
final_eigen=zeros(1648,3);%����ѵ�������Լ����ݹ�358��
final_eigen(1:754,end)=1;%�������Ե�Ѫѹ��1����754��,��һ��ʱ���ʽ���Եģ�������
final_eigen(755:end,end)=0;

pathname3='AHE';
cd(pathname3);
FileList=dir;
for i=1:length(FileList)
    tmpname=FileList(i).name;
   if(tmpname(1)=='s')
       subjectname=[path,tmpname(1:6)];
       cd(subjectname)
       agefilename=[tmpname(1:end-15),'_age.mat'];
       load(agefilename)
       final_eigen(i-2,1)=agesex(1);
       final_eigen(i-2,2)=agesex(2);
       clear agesex
       cd ..
   end
end
cd (codepath)

pathname4='nonAHE';
cd(pathname4);
FileList=dir;
for i=1:length(FileList)
    tmpname=FileList(i).name;
   if(tmpname(1)=='s')
       subjectname=[path,tmpname(1:6)];
       cd(subjectname)
       agefilename=[tmpname(1:end-8),'_age.mat'];
       load(agefilename)
       final_eigen(i-2+754,1)=agesex(1);
       final_eigen(i-2+754,2)=agesex(2);
       clear agesex
       cd ..
   end
end
