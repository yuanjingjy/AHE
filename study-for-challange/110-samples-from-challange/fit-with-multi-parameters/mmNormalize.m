%�ú�������Ҫ����Ϊ���������ݹ�һ����ָ���ķ�Χ��
%���������
%       X������һ��������
%       minV����һ����Χ����Сֵ
%       maxV����һ����Χ�����ֵ
%�������:
%       y����һ���������
function [y]=mmNormalize(X, minV ,maxV)

X=X(:);%�����������ת��Ϊ������
% X=X+dbia;
%========================== Range [minV..maxV]
maxX=max(X);%�����������ֵ
minX=min(X);%����������Сֵ
den=maxX-minX;%�������ݷ�Χ

if maxX==minX
    y=X;
else
    y= minV + (maxV-minV)*(X-minX)/(maxX-minX);%��һ����ʽ
end

end

