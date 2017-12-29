function [ AHEdata,INI,INI0,len,AHE_episode] = findAHE( inputdata,ForecastWin,Win,VAL,TOL)
%------------------------程序功能说明-------------------%
%本程序的功能为按照急性低血压的定义：预测窗口内（1个小时）对于给定的每分钟
%采样一次的动脉平均压值，在任意30分钟或更长的时间段内，有超过90%的血压值
%低于60mmHg时，认为该患者出现了急性低血压。筛选出11个小时的数据段
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

lenN=length(inputdata);
INI=[];
if lenN<660%判断数据段长度是否足够11个小时
    hour=lenN/60;
    disp('数据长度不足11小时！');
    if hour>=3.5
        forelen=2*ForecastWin;%至少保证预测窗口之前有2个小时的数据
        for iniwin=forelen+1:1:lenN-ForecastWin+1%1小时窗口的起始位置，可能会报错，因为整个数据段长度未必是10的整数倍！
            X_input=inputdata(iniwin:iniwin+ForecastWin-1);
            %0值超过6个时，舍弃该段数据
            zero_len=length(find(X_input==0));
            if zero_len >= 6
               continue; 
            end
            [ ahe_find,ini0,ini1] = AHEEpisode( X_input,Win,VAL,TOL );
             if ahe_find == 1
                ini_win=iniwin;%低血压判别窗的起始位置
                ini_ahe=ini1(:,1);%判别窗内低血压的起始位置
                len_ahe=ini1(:,2);%发生判别窗内发生低血压的窗长
                per_ahe=ini1(:,3);%判别窗内低血压点所占的比例
                
                INI_tmp=[ini_win,ini_ahe,len_ahe,per_ahe];
                INI=[INI;INI_tmp];
            end           
        end
        
        if length(INI)>0
            AHEdata=inputdata(INI(end,1)-forelen:INI(end,1)+ForecastWin-1,:);
            AHE_start=INI(end,1)-forelen;
            AHE_end=INI(end,1)+ForecastWin-1;
            AHE_episode=[AHE_start,AHE_end];
            INI0=INI(end,:);
            len=length(AHEdata);
        else
            AHEdata=[];
            AHE_episode=[];
            INI0=[];
            len=[];
        end
 else
    AHEdata=[];
    AHE_episode=[];
    INI0=[];
    len=[];
    end
end

if lenN>=660
    forelen=10*ForecastWin;%至少保证预测窗口之前有2个小时的数据
        for iniwin=(forelen+1):1:(lenN-ForecastWin+1)%1小时窗口的起始位置，可能会报错，因为整个数据段长度未必是10的整数倍！
            X_input=inputdata(iniwin:iniwin+ForecastWin-1);
            %0值超过6个时，舍弃该段数据
            zero_len=length(find(X_input==0));
            if zero_len >= 6
               continue; 
            end
            [ ahe_find,ini0,ini1] = AHEEpisode( X_input,Win,VAL,TOL );
            if ahe_find == 1
                ini_win=iniwin;%低血压判别窗的起始位置
                ini_ahe=ini1(:,1);%判别窗内低血压的起始位置
                len_ahe=ini1(:,2);%发生判别窗内发生低血压的窗长
                per_ahe=ini1(:,3);%判别窗内低血压点所占的比例
                
                INI_tmp=[ini_win,ini_ahe,len_ahe,per_ahe];
                INI=[INI;INI_tmp];
            end           
        end
        
        if length(INI)>0
            AHEdata=inputdata(INI(end,1)-forelen:INI(end,1)+ForecastWin-1,:);
            AHE_start=INI(end,1)-forelen;
            AHE_end=INI(end,1)+ForecastWin-1;
            AHE_episode=[AHE_start,AHE_end];
            INI0=INI(end,:);
            len=length(AHEdata);
        else
            AHEdata=[];
            INI0=[];
            len=[];
            AHE_episode=[];
        end
end
% plot(AHEdata)
% title('含低血压数据段')
% xlabel('时间（分钟）')
% ylabel('ABPMean（mmHg）')
end

