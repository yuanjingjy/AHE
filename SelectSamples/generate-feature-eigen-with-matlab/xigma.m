function [data]=xigma(data)
%����������׼��ȥ�����ܴ���������쳣���ݣ�ֱ������
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