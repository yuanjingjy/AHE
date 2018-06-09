clc
clear all

%Description:
%   ��������ȡɸѡ����AHE��nonAHE������������Ա�select-11-hours-data-with-matlab
%   �ļ����е�age.m������ͷ�ļ�����ȡ���������Ա��ǵ�����ŵģ��˴����������ֵ����
%Input:
%   AHE�����з���AHE��11Сʱ���ݶε������ļ���
%   nonAHE������δ����AHE��11Сʱ���ݶε������ļ���
%Output��
%   final_eigen��1648*3������ֵ���󣬵�һ�����䣬�ڶ����Ա𣬵����б�ǩ
%Notice��
%   1.�˴���1648��������ȥ���ظ�����֮ǰ����Ŀ
%   2.����AHE����һ��ʱ���ʽ���Եģ�������
%   3.��ȡ��ֱ�Ӹ���ճ��������ֵ�����е�

addpath(genpath('..\AHE\SelectSamples\generate-feature-eigen-with-matlab'))
codepath='..\AHE\SelectSamples\generate-feature-eigen-with-matlab';
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
