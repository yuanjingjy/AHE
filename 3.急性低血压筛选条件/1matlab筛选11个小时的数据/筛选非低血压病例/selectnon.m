function [ startpoint,output_data ] = selectnon( input_data )
%selectnon ����ɸѡδ������Ѫѹ�Ĳ���
%ɸѡ����
%   1.���ݳ��ȴ���11Сʱ
%   2.���1Сʱ����60mmHg��ֵ��70%����
%   3.����11Сʱ������0ֵС��5%
%   4.��ֵ�ĳ���С��5%
%
%   ���������
%       input_data:����Ĵ��ж����ݶΣ�
%   ���������
%       output_data:ɸѡ���������1�����Ϲ���ļ����棬�������ݲ��ٽ����ж�

len_data=length(input_data);
output_data=[];
startpoint=[];

if len_data>660
   for ini=1:2:len_data-660
       tmp_data=input_data(ini:ini+659);
       %0ֵ����
       [row,col]=find(tmp_data==0);
       len_zero=length(row);
       per_zero=len_zero/660;
       %��ֵ����
       [row1,col1]=find(tmp_data<0);
       len_neg=length(row1);
       per_neg=len_neg/660;
       %���1Сʱ��С��60mmHg��ֵ
       last_H=tmp_data(601:660);
       [row3,col3]=find(last_H>60);
       len_LT60=length(row3);
       per_LT60=len_LT60/60;
       
       if per_zero < 0.1 & per_neg < 0.05 & per_LT60 > 0.70
           output_data=tmp_data;
           startpoint=ini;
           break;
       end
              
   end
end


end

