clc
clear all
addpath(genpath('E:/Ԥ���Ѫ����/20170510'))

% conna=database('Johndb','John','yuanjing')

%�ó������Ҫ����Ϊ���������ݡ�ȥ���쳣���ݡ���ȡ����ֵ������ֵɸѡ��������

%% ��ʼ������ֵ����final_eigen
final_eigen=zeros(337,78);%����ѵ�������Լ����ݹ�358��
final_eigen(1:30,end)=1;%��ǩֵΪ1��ʾ�������Ե�Ѫѹ
final_eigen(31:60,end)=2;%��ǩֵΪ2��ʾδ�������Ե�Ѫѹ
label_testA=[1,1,2,1,2,2,2,2,1,1]';
final_eigen(61:70,end)=label_testA;
label_testB=[2 1 1 2 2 2 1 2 1 2 2 2 2 1 2 2 1 1 2 2 2 1 1 1 1 2 ...
    2 2 2 2 2 2 2 1 2 2 2 1 1 2]';
final_eigen(71:110,end)=label_testB;
final_eigen(111:238,end)=1;
final_eigen(239:end,end)=2;


%% ��������
% load wuchuang
% %�����ĵ��źţ���ȡ����ֵ
% [row,col]=size(testdata_ABPMean);
% for i=1:col
%     tmp=testdata_HR(:,i);
%     hr_proabn=xigma(tmp);%�쳣ֵ
%     hr_promiss=mmMissingValues(hr_proabn,250);%ȱʧֵ
%     eigen_HR=tezhengzhi(hr_promiss);
%     final_eigen(i,1:11)=eigen_HR;
% end
threshhold=[250,200,200,200,200,100,100];
pathname='ѵ����';
cd(pathname);
FileList=dir;
for i=1:length(FileList)
    tmpname=FileList(i).name;
   if(tmpname(1)=='t')
       load(tmpname)
       for j=1:7
           data=tmpdata(1:600,j);
           pro_abn=xigma(data);
           pro_miss=mmMissingValues(pro_abn,threshhold(j));
           
%            if j==4
%                ABPMean_train(:,i)=pro_miss;
%            end
           
           %% Ѫѹ�����ز���
%            if j==4 || j==5 || j==6
%                pro_miss=reSample(pro_miss);
%            end
%            pro_miss=reSample(pro_miss);
           eigen=tezhengzhi(pro_miss);
           start=(j-1)*11+1;
           final_eigen(i-2,start:start+10)=eigen;
       end
   end
end

cd ..

pathname1='���Լ�A';
cd(pathname1);
FileList=dir;
for i=1:length(FileList)
    tmpname=FileList(i).name;
   if(tmpname(1)=='t')
       load(tmpname)
       for j=1:7
           data=tmpdata(:,j);
           pro_abn=xigma(data);
           pro_miss=mmMissingValues(pro_abn,threshhold(j));
           pro_miss=reSample60(pro_miss);
           
%            if j==4
%                ABPMean_testA(:,i)=pro_miss;
%            end
           
%            if j==4 || j==5 || j==6
%                pro_miss=reSample(pro_miss);
%            end
%            pro_miss=reSample(pro_miss);
           eigen=tezhengzhi(pro_miss);
           start=(j-1)*11+1;
           final_eigen(i-2+60,start:start+10)=eigen;
       end
   end
end
cd ..

pathname2='���Լ�B';
cd(pathname2);
FileList=dir;
for i=1:length(FileList)
    tmpname=FileList(i).name;
   if(tmpname(1)=='t')
       load(tmpname)
       for j=1:7
           data=tmpdata(:,j);
           pro_abn=xigma(data);
           pro_miss=mmMissingValues(pro_abn,threshhold(j));
           pro_miss=reSample60(pro_miss);
           
%            if j==4
%                ABPMean_testB(:,i)=pro_miss;
%            end
           
%            if j==4 || j==5 || j==6
%                pro_miss=reSample(pro_miss);
%            end
%            pro_miss=reSample(pro_miss);
           eigen=tezhengzhi(pro_miss);
           start=(j-1)*11+1;
           final_eigen(i-2+70,start:start+10)=eigen;
       end
   end
end
cd ..

pathname3='AHE';
cd(pathname3);
FileList=dir;
for i=1:length(FileList)
    tmpname=FileList(i).name;
   if(tmpname(1)=='s')
       AHEname(i,:)=str2num(tmpname(2:6));
       subjectid=AHEname(i,:);
%        sql=['select icustay_id,hadm_id,icustay_admit_age,height,'...
%            'weight_first,gender from mimic2v26.icustay_detail '...
%            'where  subject_id=' num2str(subjectid)];
%        curs=exec(conna,sql)
%        curs=fetch(curs);
%        Data=curs.Data;
       load(tmpname)
       for j=1:7
           data=AHE_tmp(1:600,j);
           pro_abn=xigma(data);
           pro_miss=mmMissingValues(pro_abn,threshhold(j));
           
%             if j==4
%                ABPMean_AHE(:,i)=pro_miss;
%            end
           
%             if j==4 || j==5 || j==6
%                pro_miss=reSample(pro_miss);
%             end
%            pro_miss=reSample(pro_miss);
           eigen=tezhengzhi(pro_miss);
           start=(j-1)*11+1;
           final_eigen(i-2+110,start:start+10)=eigen;
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
       load(tmpname)
       for j=1:7
           data=nonAHE_data(1:600,j);
           pro_abn=xigma(data);
           pro_miss=mmMissingValues(pro_abn,threshhold(j));
           
%            if j==4
%                ABPMean_nonAHE(:,i)=pro_miss;
%            end
           
%             if j==4 || j==5 || j==6
%                pro_miss=reSample(pro_miss);
%             end
%            pro_miss=reSample(pro_miss);
           eigen=tezhengzhi(pro_miss);
           start=(j-1)*11+1;
           final_eigen(i-2+238,start:start+10)=eigen;
       end
   end
end
cd ..

% load final_eigen
%����ֵ�еĿ�ֵNAN�þ�ֵ�����滻����Ϊ��ֵ�滻��������Ե������������11������ֵ
%�����滻�ģ�����������ֵ������7��������77������ֵ���е�һ��������Ҫ����7��
%pro_nan����
for k=1:7
    start=(k-1)*11+1;
   tmp=final_eigen(:,start:start+10);
   pro_nandata=pro_nan(tmp);
   final_eigen(:,start:start+10)=pro_nandata;
end

