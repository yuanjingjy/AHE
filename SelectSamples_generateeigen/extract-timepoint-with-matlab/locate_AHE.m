function [ startpoint ] = locate_AHE( ahe_episode,ahe_source)
%Description��
%   �ҵ�ɸѡ�������ݶ���ԭʼ���ݶ��е�λ��
%Input��
%   ahe_episode:ɸѡ����AHE���ݶ�
%   ahe_source:AHEԭʼ����
%Output��
%   startpoint:AHE���ݶ���ԭʼ���ݶ��е�λ��

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

