function [ outputdata ] = reSample( inputdata)
%Description:
%   ����������ÿ��30������һ��ƽ��ֵ����ҪĿ�������д�Ѫѹģ���޴�Ѫѹ��30min��һ��
%Input��
%   inputdata:ÿ���Ӽ�¼һ�ε�Ѫѹ����
%Output:
%   output��30min��һ��ƽ��ֵ֮�������
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

