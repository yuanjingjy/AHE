function [ outputdata ] = reSample( inputdata)
%����������ÿ��60������һ��ƽ��ֵ,����������Ϊ10��Сʱ��ÿСʱ60����¼ֵ��
%��600����
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

