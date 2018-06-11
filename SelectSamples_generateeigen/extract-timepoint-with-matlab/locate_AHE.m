function [ startpoint ] = locate_AHE( ahe_episode,ahe_source)
%Description：
%   找到筛选出的数据段在原始数据段中的位置
%Input：
%   ahe_episode:筛选出的AHE数据段
%   ahe_source:AHE原始数据
%Output：
%   startpoint:AHE数据段在原始数据段中的位置

comp_tardata=ahe_episode(1:120,:);

len_ahesrc=length(ahe_source);
for i=1:len_ahesrc-660+1
   comp_srcdata=ahe_source(i:i+119);
   comp_result=comp_tardata-comp_srcdata;
   if sum(comp_result) == 0
      startpoint=i; 
   end
end

end

