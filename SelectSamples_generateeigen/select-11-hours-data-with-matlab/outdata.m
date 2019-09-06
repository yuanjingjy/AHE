function [ outputdata ] = outdata( inputdata)
%Description:
%    ͬʱ���øĽ�zscore��Turkey����ʶ���쳣ֵ
%Input��
%    660*7�ľ���7���������11Сʱ������
%Output��
%    660*7�ľ��󣬽��ҵ����쳣ֵλ����-99

for num_fea = 1:7
   data_fea_i = inputdata(:,num_fea);
   %�Ľ�zscore��
   diff = data_fea_i - median(data_fea_i);%ԭʼ���ݼ�ȥ��λ��
   MAD = median(abs(diff));%������ֵ����λ��
   zscore = (0.6745 * diff) / (MAD + 0.0001);%����zscore����
   zscore = abs(zscore);%ȡ����ֵ
   mask_zscore = zscore > 3.5;%zscore����3.5��Ϊ���쳣ֵ��
   
   %Turkey����
    prec = prctile(data_fea_i,[25 50 75]);%�������ķ�λ������λ��
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