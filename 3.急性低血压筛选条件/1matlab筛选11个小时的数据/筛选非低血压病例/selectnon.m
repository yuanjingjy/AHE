function [ startpoint,output_data ] = selectnon( input_data )
%selectnon 函数筛选未发生低血压的病例
%筛选规则：
%   1.数据长度大于11小时
%   2.最后1小时大于60mmHg的值在70%以上
%   3.整个11小时数据中0值小于5%
%   4.负值的长度小于5%
%
%   输入参数：
%       input_data:输入的待判断数据段；
%   输出参数：
%       output_data:筛选结果，遇到1个符合规则的即保存，后续数据不再进行判断

len_data=length(input_data);
output_data=[];
startpoint=[];

if len_data>660
   for ini=1:2:len_data-660
       tmp_data=input_data(ini:ini+659);
       %0值长度
       [row,col]=find(tmp_data==0);
       len_zero=length(row);
       per_zero=len_zero/660;
       %负值长度
       [row1,col1]=find(tmp_data<0);
       len_neg=length(row1);
       per_neg=len_neg/660;
       %最后1小时内小于60mmHg的值
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

