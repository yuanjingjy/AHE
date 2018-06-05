clc
clear all

load h2_a40125
T0=6990;%T0位置
FW=T0+60;%预测窗口位置
threshold=60;%30min内有90%时刻的ABP值低于60mmHg时定义为出现AHE
x=ABPMean;%用来进行预测的输入数据
c2_a40225=x(T0-600:FW+600);
%通过画图表示ABP变化过程及T0和预测窗
figure
plot(x(T0-600:FW));%起始到预测窗结束
hold on
plot([601 601], get(gca, 'YLim'), '-r', 'LineWidth', 0.5) %T0位置标识
plot([661 661], get(gca, 'YLim'), '-r', 'LineWidth', 0.5) %预测窗结束位置标识
plot(get(gca, 'XLim'),[threshold threshold], '-r', 'LineWidth', 1) %阈值位置
