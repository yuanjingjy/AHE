function [ outputdata ] = reSample( inputdata)
%����������ÿ��60������һ��ƽ��ֵ,����������Ϊ10��Сʱ��ÿСʱ60����¼ֵ��
%��600����
%  
[nrow,ncol]=size(inputdata);%ԭʼ���ݳ߶�
datanum=nrow/60;%�ز��������Ŀ

for j=1:ncol
    for i=1:datanum
        i_left=(i-1)*60+1;%��ʼλ��
        i_right=i_left+59;%����λ�ã���60������1��һ��ƽ��ֵ
        temp=inputdata(i_left:i_right,j);
        meantmp=mean(temp);%��ƽ��ֵ
        outdata(i,j)=meantmp;
    end
end
outputdata =outdata;%�ز�������������
end

