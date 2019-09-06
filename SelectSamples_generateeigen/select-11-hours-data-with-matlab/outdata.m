function [ outputdata ] = outdata( inputdata)
%Description:
%    同时利用改进zscore及Turkey方法识别异常值
%Input：
%    660*7的矩阵，7个生理参数11小时的数据
%Output：
%    660*7的矩阵，将找到的异常值位置置-99

for num_fea = 1:7
   data_fea_i = inputdata(:,num_fea);
   %改进zscore法
   diff = data_fea_i - median(data_fea_i);%原始数据减去中位数
   MAD = median(abs(diff));%上述差值的中位数
   zscore = (0.6745 * diff) / (MAD + 0.0001);%计算zscore分数
   zscore = abs(zscore);%取绝对值
   mask_zscore = zscore > 3.5;%zscore大于3.5认为是异常值；
   
   %Turkey方法
    prec = prctile(data_fea_i,[25 50 75]);%求上下四分位数和中位数
    Q1 = prec(1);
    mid = prec(2);
    Q3 = prec(3);
   IQR = Q3-Q1;
   out_up = Q3+3*IQR;
   out_down = Q1-3*IQR;
   mask_precup = (data_fea_i>=out_up);
   mask_precdown = (data_fea_i<=out_down);
   mask_prec = mask_precup | mask_precdown;
   
   maskinfo = mask_zscore & mask_prec;
   data_fea_i(maskinfo) = -99;
   outputdata(:,num_fea) = data_fea_i;
end