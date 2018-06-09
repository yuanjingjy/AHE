clc
clear all
addpath(genpath('..\AHE\SelectSamples\generate-feature-eigen-with-matlab'))

%Description��
%   ������Ϊÿ�����������ȡ��10��ͳ�Ʋ�������������ֵ����
%Calls��
%   function [ output] = pro_nan( data)
%   function [ data_value] = tezhengzhi( data)
%   function [ outputdata ] = reSample( inputdata)
%   function [data]=xigma(data)
%   function yout=mmMissingValues( data,maxmium)
%Input��
%   AHE:����AHE��11Сʱ���ݶε��ļ���
%   nonAHE��δ����AHE��11Сʱ���ݶε��ļ���
%Output��
%   final_eigen������ֵ���󣬲��������䡢�Ա�
%% ��ʼ������ֵ����final_eigen
final_eigen=zeros(1648,72);%����ѵ�������Լ����ݹ�1648��
final_eigen(1:754,end)=1;%�������Ե�Ѫѹ��1����754��,��һ��ʱ���ʽ���Եģ�������
final_eigen(755:end,end)=0;


%% ��������
threshhold=[250,200,200,200,200,100,100];%�������������ֵ����������Ϊ�쳣

pathname3='AHE';
cd(pathname3);
FileList=dir;
for i=1:length(FileList)
    tmpname=FileList(i).name;
   if(tmpname(1)=='s')
       AHEname(i,:)=str2num(tmpname(2:6));
       subjectid=AHEname(i,:);
       final_eigen(i-2,71)=subjectid;
       load(tmpname)
       for j=1:7
           data=AHE_tmp(1:600,j);
           pro_abn=xigma(data);
           pro_miss=mmMissingValues(pro_abn,threshhold(j));
           
%             if j==4
%                ABPMean_AHE(:,i)=pro_miss;
%            end
           
            %% Ѫѹ���ݽ����д����޴�����
            if j==2 || j==3 || j==4
               pro_miss=reSample(pro_miss);
            end
%            pro_miss=reSample(pro_miss);
           eigen=tezhengzhi(pro_miss);%��ȡ����ֵ
           start=(j-1)*10+1;
           final_eigen(i-2,start:start+9)=eigen;
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
       final_eigen(i-2+754,71)=subjectid;
       load(tmpname)
       for j=1:7
           data=nonAHE_data(1:600,j);
           pro_abn=xigma(data);
           pro_miss=mmMissingValues(pro_abn,threshhold(j));
           
%            if j==4
%                ABPMean_nonAHE(:,i)=pro_miss;
%            end
           
            if j==2 || j==3 || j==4
               pro_miss=reSample(pro_miss);
            end
%            pro_miss=reSample(pro_miss);
           eigen=tezhengzhi(pro_miss);
           start=(j-1)*10+1;
           final_eigen(i-2+754,start:start+9)=eigen;
       end
   end
end
cd ..

% load final_eigen
%����ֵ�еĿ�ֵNAN�þ�ֵ�����滻����Ϊ��ֵ�滻��������Ե������������11������ֵ
%�����滻�ģ�����������ֵ������7��������77������ֵ���е�һ��������Ҫ����7��
%pro_nan����
for k=1:7
    start=(k-1)*10+1;
   tmp=final_eigen(:,start:start+9);
   pro_nandata=pro_nan(tmp);
   final_eigen(:,start:start+9)=pro_nandata;
end

