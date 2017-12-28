function [ outputdata ] = reSample( inputdata)
%对输入数据每隔60个数求一次平均值,最终输出结果为10个小时，每小时60个记录值，
%共600个数
%  
[nrow,ncol]=size(inputdata);%原始数据尺度
datanum=nrow/60;%重采样后的数目

for j=1:ncol
    for i=1:datanum
        i_left=(i-1)*60+1;%起始位置
        i_right=i_left+59;%结束位置，共60个数求1求一次平均值
        temp=inputdata(i_left:i_right,j);
        meantmp=mean(temp);%求平均值
        outdata(i,j)=meantmp;
    end
end
outputdata =outdata;%重采样后的输出数据
end

