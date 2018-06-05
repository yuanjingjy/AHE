%该函数的主要功能为将输入数据归一化到指定的范围内
%输入参数：
%       X：待归一化的数据
%       minV：归一化范围的最小值
%       maxV：归一化范围的最大值
%输出参数:
%       y：归一化后的数据
function [y]=mmNormalize(X, minV ,maxV)

X=X(:);%将输入的数据转换为行向量
% X=X+dbia;
%========================== Range [minV..maxV]
maxX=max(X);%输入数据最大值
minX=min(X);%输入数据最小值
den=maxX-minX;%输入数据范围

if maxX==minX
    y=X;
else
    y= minV + (maxV-minV)*(X-minX)/(maxX-minX);%归一化公式
end

end

