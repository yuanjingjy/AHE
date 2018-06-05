%本程序的主要功能为根据训练好的分类模型，判断测试集对应的数据
%是否会发生急性低血压

clc
clear all

%加载数据
load testA
load bestnet%最优模型
[row,col]=size(HR);

%便于书写，将数据项重命名
hr=HR;
abpmean=ABPMean;
abpdias=ABPDias;
abpsys=ABPSys;
pulse=PULSE;
resp=RESP;
spo2=SpO2;

%声明存储各参数特征值的矩阵
flagvalue=[];
flag_hr=[];
flag_abpmean=[];
flag_abpsys=[];
flag_abpdias=[];
flag_pulse=[];
flag_resp=[];
flag_spo2=[];

%对HR数据进行预处理，步骤为：缺失数据插值，重采样，提取特征值
for i=1:col
    data0=hr(:,i);
    data_miss=mmMissingValues(data0,250);
    data_resample=reSample(data_miss);
    data_value = tezhengzhi( data_resample);
    flag_hr(i,:)=data_value;
end
flag_hr=pro_nan(flag_hr);%对缺失的特征值进行补全，用均值代替

%对ABPMean数据进行预处理，步骤为：缺失数据插值，重采样，提取特征值
for i=1:col
    data0=abpmean(:,i);
    data_miss=mmMissingValues(data0,250);
    data_resample=reSample(data_miss);
    data_value = tezhengzhi( data_resample);
    flag_abpmean(i,:)=data_value;
end
flag_abpmean=pro_nan(flag_abpmean);%对缺失的特征值进行补全，用均值代替

%对ABPSys数据进行预处理，步骤为：缺失数据插值，重采样，提取特征值
for i=1:col
    data0=abpsys(:,i);
    data_miss=mmMissingValues(data0,250);
    data_resample=reSample(data_miss);
    data_value = tezhengzhi( data_resample);
    flag_abpsys(i,:)=data_value;
end
flag_abpsys=pro_nan(flag_abpsys);%对缺失的特征值进行补全，用均值代替

%对ABPDias数据进行预处理，步骤为：缺失数据插值，重采样，提取特征值
for i=1:col
    data0=abpdias(:,i);
    data_miss=mmMissingValues(data0,250);
    data_resample=reSample(data_miss);
    data_value = tezhengzhi( data_resample);
    flag_abpdias(i,:)=data_value;
end
flag_abpdias=pro_nan(flag_abpdias);%对缺失的特征值进行补全，用均值代替

%对PULSE数据进行预处理，步骤为：缺失数据插值，重采样，提取特征值
for i=1:col
    data0=pulse(:,i);
    data_miss=mmMissingValues(data0,250);
    data_resample=reSample(data_miss);
    data_value = tezhengzhi( data_resample);
    flag_pulse(i,:)=data_value;
end
flag_pulse=pro_nan(flag_pulse);%对缺失的特征值进行补全，用均值代替

%对RESP数据进行预处理，步骤为：缺失数据插值，重采样，提取特征值
for i=1:col
    data0=resp(:,i);
    data_miss=mmMissingValues(data0,250);
    data_resample=reSample(data_miss);
    data_value = tezhengzhi( data_resample);
    flag_resp(i,:)=data_value;
end
flag_resp=pro_nan(flag_resp);%对缺失的特征值进行补全，用均值代替

% 对SPO2数据进行预处理，步骤为：缺失数据插值，重采样，提取特征值
for i=1:col
    data0=spo2(:,i);
    data_miss=mmMissingValues(data0,250);
    data_resample=reSample(data_miss);
    data_value = tezhengzhi( data_resample);
    flag_spo2(i,:)=data_value;
end
flag_spo2=pro_nan(flag_spo2);%对缺失的特征值进行补全，用均值代替

flagvalue=[flag_abpdias,flag_abpmean,flag_abpsys,flag_hr,flag_pulse,...
    flag_resp,flag_spo2];

len_flag=size(flagvalue,2);
for i=1:len_flag
   tmp=flagvalue(:,i);
   flagvalue_nor(:,i)=mmNormalize(tmp,-1,1);
end

%根据相关性选择用于训练网络的变量
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