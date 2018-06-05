function [ data_value] = tezhengzhi( data)

%   tezhengzhi ���������ֵ
%
%����ֵ��
%data:  ��Ҫ����ͳ��������������
%
%���ֵ��
%   data_value(1):  data_mean,  ��ֵ
%   data_value(2):  data_median, ��λ��
%   data_value(3):  data_std,   ��׼��
%   data_value(4):  data_skewness,:  ƫ��
%   data_value(5):  data_prctile,   �ٷ�λ����75%��
%   data_value(6):  data_kurtosis,  ��ȣ��Ͷȣ�
%   data_value(7):  data_iqr,  �ķ�λ��
%   data_value(8):  data_mad,   ƽ������ƫ��
%   data_value(9): data_range, ����
%   data_value(10): data_var,   ����
%   data_value(11): data_cov,   Э����

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

