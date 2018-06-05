function [AHEdata] = findAHE( inputdata,ForecastWin,Win,VAL,TOL)
%------------------------程序功能说明-------------------%
%本程序的功能为按照急性低血压的定义：预测窗口内（1个小时）对于给定的每分钟
%采样一次的动脉平均压值，在任意30分钟或更长的时间段内，有超过90%的血压值
%低于60mmHg时，认为该患者出现了急性低血压。
%
%首先判断数据长度：
%       当数据长度不足十一小时时，记录当前编号，输出提示：数据长度不足；
%       当数据长度超过十一小时时，从第十个小时之后的点开始判断是否会发生AHE
%       
%       重叠长度为10min，整个11个小时长度的数据段，重叠长度为10min进行移动
%
% 输出参数：
%       AHEdata：最后1个小时发生了急性低血压的共11(或3)小时的数据
%       INI： 共4列 第一列：低血压判别窗的起始位置，向前推10个小时或2个小时为数据段起点
%                   第二列：判别窗内发生低血压的数据段的起始位置
%                   第三列：判别窗内发生低血压的数据段长度
%                   第四列：低血压点数占第三列数据段长度的百分比
%              INI的每一行表示低血压判别窗移动时，找到的发生急性低血压的窗
%       INI0：INI0为INI的最后一列，表示找到的最后一个发生低血压的窗口
%       len:输出的数据段的长度，至少保证预测窗口内有2个小时长度的数据
%
%输入参数：
%       inputdata：待判断数据段
%       ForcastWin：预测窗口的长度，1个小时，（输入60）
%       Win:最小的移动窗口的长度，半个小时（输入21）
%       VAL：发生低血压时血压值的最低限值，60mmHg（输入60）
%       TOL：Win内血压值地与VAL的个数占整个窗口的比例（输入0.9）

lenN=length(inputdata(:,4));%算一共有多少行
AHEdata=[];

if lenN>=660
    forelen=0;%至少保证预测窗口之前有10个小时的数据，10*60=600
        for iniwin=1:1:(lenN-660+1)%11小时窗口的起始位置
            X_input=inputdata(iniwin:iniwin+659,1:7);%11小时的长度，660
            %ABPMean最后1小时的空值值超过6个时，舍弃该段数据
            zero_len=length(find(X_input(601:660,4)<=0));
            
            loss=[];
            loss_50=[];
            for i=1:7
               loss(1,i)=length(find(X_input(1:600,i)<=0));%统计缺失值的个数
               loss_50(1,i)=(loss(1,i)>180);%统计各参数缺失比例是否超过40%，是为1  
            end
            loss_num=sum(loss_50);
            
            if zero_len >= 6 | loss_num > 0
               continue; 
            else
                [ ahe_find] = AHEEpisode( X_input(601:660,4),Win,VAL,TOL );
                if ahe_find==1
                   ini_win=iniwin; %低血压判别窗的起始位置
%                    AHE_start=ini_win;
%                    AHE_end=ini+660-1;
                   AHEdata=X_input;
                   break;
                else
                    AHEdata=[];
                end
            end                        
        end        
else
    AHEdata=[];
end

% plot(AHEdata)
% title('含低血压数据段')
% xlabel('时间（分钟）')
% ylabel('ABPMean（mmHg）')
end

