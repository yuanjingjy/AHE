function [ startpoint,output_data ] = selectnon( input_data )
%selectnon ����ɸѡδ������Ѫѹ�Ĳ���
%ɸѡ����
%   1.���ݳ��ȴ���11Сʱ
%   2.���1Сʱ�����У�����60mmHg����27������
%   3.���1Сʱ�����У�С�ڵ���0��ֵ��10%����
%   4.ǰ10��Сʱ�����ݣ���������ȱʧ������30%����
%
%   Input��
%       input_data:����Ĵ��ж����ݶΣ�
%   Output��
%       output_data:ɸѡ���������1�����Ϲ���ļ����棬�������ݲ��ٽ����ж�
%       startpoint:11Сʱ���ݶε���ʼλ��

len_data=length(input_data(:,4));
output_data=[];
startpoint=[];

if len_data>660
   for ini=1:1:len_data-660+1
       tmp_data=input_data(ini:ini+659,1:7);
       
       loss=[];
       loss_50=[];
       for i=1:7
          loss(1,i)=length(find(tmp_data(1:600,i)<=0));%ͳ��ȱʧֵ�ĸ���
          loss_50(1,i)=(loss(1,i)>180);%ͳ�Ƹ�����ȱʧ�����Ƿ񳬹�30%����Ϊ1 
       end
       
       loss_num=sum(loss_50);
       if loss_num<1          
           %���1Сʱ��С��60mmHg��ֵ
           last_H=tmp_data(601:660,4);
           [row3,col3]=find(last_H>60);
           len_LT60=length(row3);
%            per_LT60=len_LT60/60;
           
           %���һСʱ�ڵ���0��ֵ
           [row_neg,col_neg]=find(last_H<=0);
           len_neg=length(row_neg);
%            per_neg=len_neg/60;
           
           if len_LT60 > 27 &len_neg < 6
               output_data=tmp_data(:,4);
               startpoint=ini;
               break;
           end
       end
           
   end
end


end

