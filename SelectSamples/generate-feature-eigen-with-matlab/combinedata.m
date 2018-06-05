clc
clear all

%该程序的功能为对挑战项目中训练集和测试集的数据进行合并整理，合并前是按照参数进行
%存储，即训练集中所有60个样本的心率存在一个.mat文件中，拆分后为按照样本进行存储，
%每个样本按照心率、动脉收缩压、动脉舒张压、动脉平均压、脉搏、呼吸、血氧的顺序进行存储
%对于训练集，即保存60个660*7的.mat文件

%% 训练集数据合并
% load wuchuang
% for i=1:60
%     dataname=['train',num2str(i)];
%     tmpdata=[testdata_HR(:,i),testdata_ABPSys(:,i),testdata_ABPDias(:,i),testdata_ABPMean(:,i),...
%         testdata_PULSE(:,i),testdata_RESP(:,i),testdata_SPO2(:,i)];
%     save(dataname,'tmpdata')
% end


% %% 测试集A数据合并
% load 测试集\HRA
% load 测试集\ABPSysA
% load 测试集\ABPDiasA
% load 测试集\ABPMeanA
% load 测试集\PULSEA
% load 测试集\RESPA
% load 测试集\SpO2A
% 
% for i=1:10
%    tmpname=['testset',num2str(i)];
%    tmpdata=[HRA(:,i),ABPSysA(:,i),BPDiasA(:,i),testA(:,i),PULSEA(:,i),...
%        RESPA(:,i),SpOA(:,i)];
%    save(tmpname,'tmpdata')
% end


%% 测试集B合并
load 测试集\HRB
load 测试集\ABPSysB
load 测试集\ABPDiasB
load 测试集\ABPMeanB
load 测试集\PULSEB
load 测试集\RESPB
load 测试集\SpO2B

for i=1:40
   tmpname=['testset',num2str(i)];
   tmpdata=[HRB(:,i),ABPSysB(:,i),BPDiasB(:,i),testB(:,i),PULSEB(:,i),...
       RESPB(:,i),SpO2B(:,i)];
   save(tmpname,'tmpdata')
end