function [ outputdata ] = reSample( inputdata)
%对输入数据每隔60个数求一次平均值,最终输出结果为10个小时，每小时60个记录值，
%共600个数
%  
[nrow,ncol]=size(inputdata);
datanum=nrow/30;

for j=1:ncol
    for i=1:datanum
        i_left=(i-1)*30+1;
        i_right=i_left+29;
        temp=inputdata(i_left:i_right,j);
        meantmp=mean(temp);
        outdata(i,j)=meantmp;
    end
end
outputdata =outdata;
end

