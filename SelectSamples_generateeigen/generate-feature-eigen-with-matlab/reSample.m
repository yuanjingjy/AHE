function [ outputdata ] = reSample( inputdata)
%Description:
%   对输入数据每隔30个数求一次平均值，主要目的是用有创血压模拟无创血压，30min测一次
%Input：
%   inputdata:每分钟记录一次的血压数据
%Output:
%   output：30min求一个平均值之后的数据
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

