% 从训练集数据中提取特征参量，训练集中的心率，动脉收缩、舒张、平均
% 压，脉搏、呼吸、血氧
clc
clear all
% 
load wuchuan%所有训练集数据
[row,col]=size(testdata_HR);%提取数据个数

%所需数据重命名
hr=testdata_HR;
abpmean=testdata_ABPMean;
abpdias=testdata_ABPDias;
abpsys=testdata_ABPSys;
pulse=testdata_PULSE;
resp=testdata_RESP;
spo2=testdata_SPO2;

%定义存储各生理参数特征值的矩阵
flagvalue=[];
flag_hr=[];
flag_abpmean=[];
flag_abpdias=[];
flag_abpsys=[];
flag_pulse=[];
flag_resp=[];
flag_spo2=[];

%对心率信号进行预处理，然后提取特征值
for i=1:col
    data0=hr(:,i);
%   data=xigma(data0);
    data_out=mmMissingValues(data0,250);
    data_value = tezhengzhi( data_out);
    flag_hr(i,:)=data_value;%预处理后的心率数据
end
flag_hr=pro_nan(flag_hr);%处理特征矩阵的异常
    
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

%年龄值。但只有训练集包含年龄数据，测试集中没有
Age=[75;72;76;40;89;88;85;66;65;89;35;53;78;77;78;...
    80;58;90;79;82;68;75;32;47;66;73;56;77;85;90;...
    51;57;42;58;59;48;47;45;71;66;46;58;46;39;67;...
    54;60;81;82;90;61;61;36;84;22;88;62;69;78;76];
%性别M——1，F——0，同样，只有训练集有性别参数，测试集没直接给出
Gender=[1;0;0;1;0;1;1;1;1;0;1;1;0;0;1;...
        0;1;1;0;0;1;0;1;1;0;0;1;0;1;0;...
        1;0;0;1;1;1;1;0;0;1;1;1;0;0;1;...
        1;0;0;0;0;1;0;0;0;1;1;0;0;1;1];
%目标矩阵，1 0 表示发生了急性低血压，0 1 表示没有发生急性低血压
 Target=[1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;...
         1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;1 0;...
         0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;...
         0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1];
     
%得到特征参量
flagvalue=[flag_abpdias,flag_abpmean,flag_abpsys,flag_hr,flag_pulse,...
    flag_resp,flag_spo2,Target];

%将60组数据的顺序打乱
tmp_flagvalue=flagvalue;
index_rand=randperm(60);%将60以内的数随机打乱顺序
for i=1:length(index_rand)
    flagvalue_dis(i,:)=tmp_flagvalue(index_rand(i),:);
end

 cmd=['save flagvalue_dis flagvalue_dis'];
 eval(cmd);   
