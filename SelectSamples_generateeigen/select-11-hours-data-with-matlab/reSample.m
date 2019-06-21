function [ outputdata ] = reSample( inputdata)
%Description:
%   对输入数据每隔60个数求一次平均值，将每秒记录一次的数据转换为每分钟记录一次的数据
%Input：
%   inputdata:每秒记录一次的血压数据
%Output:
%   output：60个点求一个平均值之后的数据
%  
[nrow,ncol]=size(inputdata);
datanum=nrow/60;

for j=1:ncol
    for i=1:datanum
        i_left=(i-1)*60+1;
        i_right=i_left+59;
        temp=inputdata(i_left:i_right,j);
        meantmp=mean(temp);
        outdata(i,j)=meantmp;
    end
end
outputdata =outdata;
end

