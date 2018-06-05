function [ output] = pro_nan( data)
%pro_nan函数处理特征参数矩阵中含有NAN的项
%当某一生理参数某一个样本缺失时，求得的统计变量为非法值或者0值
%对于此类情况，将0值或非法值，用该列其他数据的平均值替代
%
%
%   输入：
%       data:特征参数矩阵
%   输出：
%       output：补全之后的特征参数矩阵

mean_data=data;
%找到NaN值的位置
[m,n]=find(isnan(mean_data)==1);

%将空值的位置置零
len=length(m);
for i=1:len
   for j=1:len
      mean_data(m(i),n(j))=0; 
   end
end

%求置零后的平均值
sum_value=sum(mean_data);

%求出各列中非零值的个数
col=size(mean_data,2);
nonzero_num=[];
for i=1:col
   nonzero=find(mean_data(:,i));
   nonzero_num(i)=length(nonzero);
end

 for k=1:11
    mean_value(k)=sum_value(k)./nonzero_num(k); 
 end

 [row,col]=find(mean_data==0);
len=length(row);
for i=1:len
    for j=1:len
       mean_data(row(i),col(j))=mean_value(col(j));
    end
end
output=mean_data;
end

