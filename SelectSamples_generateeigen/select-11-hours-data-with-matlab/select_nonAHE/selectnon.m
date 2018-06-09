function [ startpoint,output_data ] = selectnon( input_data )
%selectnon 函数筛选未发生低血压的病例
%筛选规则：
%   1.数据长度大于11小时
%   2.最后1小时数据中，大于60mmHg的有27个以上
%   3.最后1小时数据中，小于等于0的值在10%以下
%   4.前10个小时的数据，所有数据缺失比例在30%以内
%
%   Input：
%       input_data:输入的待判断数据段；
%   Output：
%       output_data:筛选结果，遇到1个符合规则的即保存，后续数据不再进行判断
%       startpoint:11小时数据段的起始位置

len_data=length(input_data(:,4));
output_data=[];
startpoint=[];

if len_data>660
   for ini=1:1:len_data-660+1
       tmp_data=input_data(ini:ini+659,1:7);
       
       loss=[];
       loss_50=[];
       for i=1:7
          loss(1,i)=length(find(tmp_data(1:600,i)<=0));%统计缺失值的个数
          loss_50(1,i)=(loss(1,i)>180);%统计各参数缺失比例是否超过30%，是为1 
       end
       
       loss_num=sum(loss_50);
       if loss_num<1          
           %最后1小时内小于60mmHg的值
           last_H=tmp_data(601:660,4);
           [row3,col3]=find(last_H>60);
           len_LT60=length(row3);
%            per_LT60=len_LT60/60;
           
           %最后一小时内等于0的值
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

