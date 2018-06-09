clc
clear all
addpath(genpath('..\AHE\DataProcess_MachineLearning\MEWS'))

%Description��
%   ȡAHE��nonAHE������Ԥ�ⴰ��ǰ30min��HR��RR��SBP���ڼ���MEWS
%Input��
%   ɸѡ�����ķ���AHE��δ����AHE��11Сʱ���ݶ�
%Output:
%   final_eigen,��11�У��ֱ�ΪHR��SBP��RR�������С��ƽ��ֵ�Լ�subject_id��classlabel

%% ��ʼ������ֵ����final_eigen
final_eigen=zeros(1648,11);%����ѵ�������Լ����ݹ�358��
final_eigen(1:755,end)=1;
final_eigen(756:end,end)=0;

threshhold=[250,200,200,200,200,100,100];%��ֵ

pathname3='AHE';
cd(pathname3);
FileList=dir;
for i=1:length(FileList)
    tmpname=FileList(i).name;
   if(tmpname(1)=='s')
       AHEname(i,:)=str2num(tmpname(2:6));
       subjectid=AHEname(i,:);
       final_eigen(i-2,10)=subjectid;
       load(tmpname)
       start=1;
       for j=[1,2,6]%ֻ�������MEWS�õ���HR��RR��SBP
           data=AHE_tmp(1:600,j);%ǰ10��Сʱ������
           pro_abn=xigma(data);%�����쳣���ݣ�������׼��
           pro_miss=mmMissingValues(pro_abn,threshhold(j));%����ȱʧ����
           pro_MEWS=pro_miss(571:600,:);%��ȡ����AHEǰ��30min����
           
           maxvalue=max(pro_MEWS);
           minvalue=min(pro_MEWS);
           meanvalue=mean(pro_MEWS);         
            
           eigen=[maxvalue,minvalue,meanvalue];          
           final_eigen(i-2,start:start+2)=eigen;
           start=start+3;
       end
   end
end
cd ..

pathname4='nonAHE';
cd(pathname4);
FileList=dir;
for i=1:length(FileList)
    tmpname=FileList(i).name;
   if(tmpname(1)=='s')
       nonAHEname(i,:)=str2num(tmpname(2:6));
       subjectid=nonAHEname(i,:);
       final_eigen(i-2+755,10)=subjectid;
       load(tmpname)
       start=1;
       for j=[1,2,6]%ֻ��ȡ����MEWS��Ҫ��HR��RR��SBP
           data=nonAHE_data(1:600,j);%ǰ10��Сʱ������
           pro_abn=xigma(data);%������׼�����쳣
           pro_miss=mmMissingValues(pro_abn,threshhold(j));%����ȱʧ����
           pro_MEWS=pro_miss(571:600,:);%��ȡԤ�ⴰ��ǰ���Сʱ����
           
           maxvalue=max(pro_MEWS);
           minvalue=min(pro_MEWS);
           meanvalue=mean(pro_MEWS);

           eigen=[maxvalue,minvalue,meanvalue];     
           final_eigen(i-2+755,start:start+2)=eigen;
           start=start+3;
       end
   end
end
cd ..
