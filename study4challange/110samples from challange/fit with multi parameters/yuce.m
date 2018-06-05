% ��ѵ������������ȡ����������ѵ�����е����ʣ��������������š�ƽ��
% ѹ��������������Ѫ��
clc
clear all
% 
load wuchuan%����ѵ��������
[row,col]=size(testdata_HR);%��ȡ���ݸ���

%��������������
hr=testdata_HR;
abpmean=testdata_ABPMean;
abpdias=testdata_ABPDias;
abpsys=testdata_ABPSys;
pulse=testdata_PULSE;
resp=testdata_RESP;
spo2=testdata_SPO2;

%����洢�������������ֵ�ľ���
flagvalue=[];
flag_hr=[];
flag_abpmean=[];
flag_abpdias=[];
flag_abpsys=[];
flag_pulse=[];
flag_resp=[];
flag_spo2=[];

%�������źŽ���Ԥ����Ȼ����ȡ����ֵ
for i=1:col
    data0=hr(:,i);
%   data=xigma(data0);
    data_out=mmMissingValues(data0,250);
    data_value = tezhengzhi( data_out);
    flag_hr(i,:)=data_value;%Ԥ��������������
end
flag_hr=pro_nan(flag_hr);%��������������쳣
    
for i=1:col
    data0=abpmean(:,i);
%     data=xigma(data0);
    data_out=mmMissingValues(data0,200);
    data_value = tezhengzhi( data_out);
    flag_abpmean(i,:)=data_value;
end
flag_abpmean=pro_nan(flag_abpmean);

for i=1:col
    data0=abpdias(:,i);
%     data=xigma(data0);
    data_out=mmMissingValues(data0,200);
    data_value = tezhengzhi( data_out);
    flag_abpdias(i,:)=data_value;
end
flag_abpdias=pro_nan(flag_abpdias);


for i=1:col
    data0=abpsys(:,i);
%     data=xigma(data0);
    data_out=mmMissingValues(data0,200);
    data_value = tezhengzhi( data_out);
    flag_abpsys(i,:)=data_value;
end
flag_abpsys=pro_nan(flag_abpsys);

for i=1:col
    data0=pulse(:,i);
%     data=xigma(data0);
    data_out=mmMissingValues(data0,200);
    data_value = tezhengzhi( data_out);
    flag_pulse(i,:)=data_value;
end
flag_pulse=pro_nan(flag_pulse);

for i=1:col
    data0=resp(:,i);
%     data=xigma(data0);
    data_out=mmMissingValues(data0,100);
    data_value = tezhengzhi( data_out);
    flag_resp(i,:)=data_value;
end
flag_resp=pro_nan(flag_resp);

for i=1:col
    data0=spo2(:,i);
%     data=xigma(data0);
    data_out=mmMissingValues(data0,100);
    data_value = tezhengzhi( data_out);
    flag_spo2(i,:)=data_value;
end
flag_spo2=pro_nan(flag_spo2);

%����ֵ����ֻ��ѵ���������������ݣ����Լ���û��
Age=[75;72;76;40;89;88;85;66;65;89;35;53;78;77;78;...
    80;58;90;79;82;68;75;32;47;66;73;56;77;85;90;...
    51;57;42;58;59;48;47;45;71;66;46;58;46;39;67;...
    54;60;81;82;90;61;61;36;84;22;88;62;69;78;76];
%�Ա�M����1��F����0��ͬ����ֻ��ѵ�������Ա���������Լ�ûֱ�Ӹ���
Gender=[1;0;0;1;0;1;1;1;1;0;1;1;0;0;1;...
        0;1;1;0;0;1;0;1;1;0;0;1;0;1;0;...
        1;0;0;1;1;1;1;0;0;1;1;1;0;0;1;...
        1;0;0;0;0;1;0;0;0;1;1;0;0;1;1];
%Ŀ�����1 0 ��ʾ�����˼��Ե�Ѫѹ��0 1 ��ʾû�з������Ե�Ѫѹ
 Target=[1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;...
         1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;...
         0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;...
         0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1];
     
%�õ���������
flagvalue=[flag_abpdias,flag_abpmean,flag_abpsys,flag_hr,flag_pulse,...
    flag_resp,flag_spo2,Target];

%��60�����ݵ�˳�����
tmp_flagvalue=flagvalue;
index_rand=randperm(60);%��60���ڵ����������˳��
for i=1:length(index_rand)
    flagvalue_dis(i,:)=tmp_flagvalue(index_rand(i),:);
end

 cmd=['save flagvalue_dis flagvalue_dis'];
 eval(cmd);   
