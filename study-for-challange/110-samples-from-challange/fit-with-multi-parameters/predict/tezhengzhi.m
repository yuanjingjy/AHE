function [ data_value] = tezhengzhi( data)

%   tezhengzhi 求各个特征值
%
%输入值：
%data:  需要计算统计量的输入数据
%
%输出值：
%   data_value(1):  data_mean,  均值
%   data_value(2):  data_median, 中位数
%   data_value(3):  data_std,   标准差
%   data_value(4):  data_skewness,:  偏度
%   data_value(5):  data_prctile,   百分位数（75%）
%   data_value(6):  data_kurtosis,  峰度（峭度）
%   data_value(7):  data_iqr,  四分位数
%   data_value(8):  data_mad,   平均绝对偏差
%   data_value(9): data_range, 极差
%   data_value(10): data_var,   方差
%   data_value(11): data_cov,   协方差

data_mean=mean(data);
data_median=median(data);
data_std=std(data);
data_skewness=skewness(data);
data_prctile=prctile(data,75);
data_kurtosis=kurtosis(data);
data_quartile=iqr(data);
data_mad=mad(data);
data_range=range(data);
data_var=var(data);
data_cov=cov(data);

data_value(1)=data_mean;
data_value(2)=data_median;
data_value(3)=data_std;
data_value(4)=data_skewness;
data_value(5)=data_prctile;
data_value(6)=data_kurtosis;
data_value(7)=data_quartile;
data_value(8)=data_mad;
data_value(9)=data_range;
data_value(10)=data_var;
data_value(11)=data_cov;

end

