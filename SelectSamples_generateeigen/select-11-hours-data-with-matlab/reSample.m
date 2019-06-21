function [ outputdata ] = reSample( inputdata)
%Description:
%   ����������ÿ��60������һ��ƽ��ֵ����ÿ���¼һ�ε�����ת��Ϊÿ���Ӽ�¼һ�ε�����
%Input��
%   inputdata:ÿ���¼һ�ε�Ѫѹ����
%Output:
%   output��60������һ��ƽ��ֵ֮�������
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

