%���������Ҫ����Ϊ����ѵ���õķ���ģ�ͣ��жϲ��Լ���Ӧ������
%�Ƿ�ᷢ�����Ե�Ѫѹ

clc
clear all

%��������
load testA
load bestnet%����ģ��
[row,col]=size(HR);

%������д����������������
hr=HR;
abpmean=ABPMean;
abpdias=ABPDias;
abpsys=ABPSys;
pulse=PULSE;
resp=RESP;
spo2=SpO2;

%�����洢����������ֵ�ľ���
flagvalue=[];
flag_hr=[];
flag_abpmean=[];
flag_abpsys=[];
flag_abpdias=[];
flag_pulse=[];
flag_resp=[];
flag_spo2=[];

%��HR���ݽ���Ԥ��������Ϊ��ȱʧ���ݲ�ֵ���ز�������ȡ����ֵ
for i=1:col
    data0=hr(:,i);
    data_miss=mmMissingValues(data0,250);
    data_resample=reSample(data_miss);
    data_value = tezhengzhi( data_resample);
    flag_hr(i,:)=data_value;
end
flag_hr=pro_nan(flag_hr);%��ȱʧ������ֵ���в�ȫ���þ�ֵ����

%��ABPMean���ݽ���Ԥ��������Ϊ��ȱʧ���ݲ�ֵ���ز�������ȡ����ֵ
for i=1:col
    data0=abpmean(:,i);
    data_miss=mmMissingValues(data0,250);
    data_resample=reSample(data_miss);
    data_value = tezhengzhi( data_resample);
    flag_abpmean(i,:)=data_value;
end
flag_abpmean=pro_nan(flag_abpmean);%��ȱʧ������ֵ���в�ȫ���þ�ֵ����

%��ABPSys���ݽ���Ԥ��������Ϊ��ȱʧ���ݲ�ֵ���ز�������ȡ����ֵ
for i=1:col
    data0=abpsys(:,i);
    data_miss=mmMissingValues(data0,250);
    data_resample=reSample(data_miss);
    data_value = tezhengzhi( data_resample);
    flag_abpsys(i,:)=data_value;
end
flag_abpsys=pro_nan(flag_abpsys);%��ȱʧ������ֵ���в�ȫ���þ�ֵ����

%��ABPDias���ݽ���Ԥ��������Ϊ��ȱʧ���ݲ�ֵ���ز�������ȡ����ֵ
for i=1:col
    data0=abpdias(:,i);
    data_miss=mmMissingValues(data0,250);
    data_resample=reSample(data_miss);
    data_value = tezhengzhi( data_resample);
    flag_abpdias(i,:)=data_value;
end
flag_abpdias=pro_nan(flag_abpdias);%��ȱʧ������ֵ���в�ȫ���þ�ֵ����

%��PULSE���ݽ���Ԥ��������Ϊ��ȱʧ���ݲ�ֵ���ز�������ȡ����ֵ
for i=1:col
    data0=pulse(:,i);
    data_miss=mmMissingValues(data0,250);
    data_resample=reSample(data_miss);
    data_value = tezhengzhi( data_resample);
    flag_pulse(i,:)=data_value;
end
flag_pulse=pro_nan(flag_pulse);%��ȱʧ������ֵ���в�ȫ���þ�ֵ����

%��RESP���ݽ���Ԥ��������Ϊ��ȱʧ���ݲ�ֵ���ز�������ȡ����ֵ
for i=1:col
    data0=resp(:,i);
    data_miss=mmMissingValues(data0,250);
    data_resample=reSample(data_miss);
    data_value = tezhengzhi( data_resample);
    flag_resp(i,:)=data_value;
end
flag_resp=pro_nan(flag_resp);%��ȱʧ������ֵ���в�ȫ���þ�ֵ����

% ��SPO2���ݽ���Ԥ��������Ϊ��ȱʧ���ݲ�ֵ���ز�������ȡ����ֵ
for i=1:col
    data0=spo2(:,i);
    data_miss=mmMissingValues(data0,250);
    data_resample=reSample(data_miss);
    data_value = tezhengzhi( data_resample);
    flag_spo2(i,:)=data_value;
end
flag_spo2=pro_nan(flag_spo2);%��ȱʧ������ֵ���в�ȫ���þ�ֵ����

flagvalue=[flag_abpdias,flag_abpmean,flag_abpsys,flag_hr,flag_pulse,...
    flag_resp,flag_spo2];

len_flag=size(flagvalue,2);
for i=1:len_flag
   tmp=flagvalue(:,i);
   flagvalue_nor(:,i)=mmNormalize(tmp,-1,1);
end

%���������ѡ������ѵ������ı���
% index_flag=[1,2,5,12,13,16,23,24,36,40,58,63,65,66];
index_flag=[36,40,58,63,65,66];
% index_flag=[1,2,5,12,13,16,23,24,];

for i=1:length(index_flag)
   data_input(:,i)=flagvalue_nor(:,index_flag(i)) ;
end

data_input=data_input';
net=bestnet;
output=net(data_input);
data_output=round(output);