clc
clear all

%�ó���Ĺ���Ϊ����ս��Ŀ��ѵ�����Ͳ��Լ������ݽ��кϲ������ϲ�ǰ�ǰ��ղ�������
%�洢����ѵ����������60�����������ʴ���һ��.mat�ļ��У���ֺ�Ϊ�����������д洢��
%ÿ�������������ʡ���������ѹ����������ѹ������ƽ��ѹ��������������Ѫ����˳����д洢
%����ѵ������������60��660*7��.mat�ļ�

%% ѵ�������ݺϲ�
% load wuchuang
% for i=1:60
%     dataname=['train',num2str(i)];
%     tmpdata=[testdata_HR(:,i),testdata_ABPSys(:,i),testdata_ABPDias(:,i),testdata_ABPMean(:,i),...
%         testdata_PULSE(:,i),testdata_RESP(:,i),testdata_SPO2(:,i)];
%     save(dataname,'tmpdata')
% end


% %% ���Լ�A���ݺϲ�
% load ���Լ�\HRA
% load ���Լ�\ABPSysA
% load ���Լ�\ABPDiasA
% load ���Լ�\ABPMeanA
% load ���Լ�\PULSEA
% load ���Լ�\RESPA
% load ���Լ�\SpO2A
% 
% for i=1:10
%    tmpname=['testset',num2str(i)];
%    tmpdata=[HRA(:,i),ABPSysA(:,i),BPDiasA(:,i),testA(:,i),PULSEA(:,i),...
%        RESPA(:,i),SpOA(:,i)];
%    save(tmpname,'tmpdata')
% end


%% ���Լ�B�ϲ�
load ���Լ�\HRB
load ���Լ�\ABPSysB
load ���Լ�\ABPDiasB
load ���Լ�\ABPMeanB
load ���Լ�\PULSEB
load ���Լ�\RESPB
load ���Լ�\SpO2B

for i=1:40
   tmpname=['testset',num2str(i)];
   tmpdata=[HRB(:,i),ABPSysB(:,i),BPDiasB(:,i),testB(:,i),PULSEB(:,i),...
       RESPB(:,i),SpO2B(:,i)];
   save(tmpname,'tmpdata')
end