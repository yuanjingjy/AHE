function [data]=xigma(data)
%Description:
%   根据拉依达准则，去除可能存在问题的异常数据，直接置零
%Input:
%   data：输入待判断数据
% Output: 
%   data：异常值置零后的数据


    index=[];
    xig=std(data);
    meandata=mean(data);
    ab_data1=meandata-3*xig;
    ab_data2=meandata+3*xig;
    for i=1:length(data)
        if data(i)<ab_data1 | data(i)>ab_data2
            data(i)=0;
            index=[index;i];
        end     
    end       
end