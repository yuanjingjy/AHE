clc
clear all

load c1_a40282
T0=1367;%T0λ��
FW=T0+60;%Ԥ�ⴰ��λ��
threshold=60;%30min����90%ʱ�̵�ABPֵ����60mmHgʱ����Ϊ����AHE
x=ABPMean;%��������Ԥ�����������
c1_a40282=x(T0-600:FW);
%ͨ����ͼ��ʾABP�仯���̼�T0��Ԥ�ⴰ
figure
plot(x(T0-600:FW+600));%��ʼ��Ԥ�ⴰ����
hold on
plot([601 601], get(gca, 'YLim'), '-r', 'LineWidth', 0.5) %T0λ�ñ�ʶ
plot([661 661], get(gca, 'YLim'), '-r', 'LineWidth', 0.5) %Ԥ�ⴰ����λ�ñ�ʶ
plot(get(gca, 'XLim'),[threshold threshold], '-r', 'LineWidth', 1) %��ֵλ��
