clc;
clear all;
addpath(genpath('F:\F��\Project\���Ե�Ѫѹ\3.���Ե�Ѫѹɸѡ����\1matlabɸѡ11��Сʱ������'))

path='D:\1yj_nonAHE';%������ݵ��ļ���
FileList=dir(path);%��ȡ�ļ����µ��ļ�
cd(path)%·���л���������ݵ��ļ���
for i=1:length(FileList)
   filename_i=FileList(i).name;%%���ļ��е�����
   if (filename_i(1)=='s' )
      load(filename_i)
      
%       for i=1:7
% %           loss(1,i)=length(find(AHE_tmp(1:600,i)<=0));%ͳ��ȱʧֵ�ĸ���
%           loss(1,i)=length(find(AHE_tmp(1:600,i)<=0));%ͳ��ȱʧֵ�ĸ���
%           loss_50(1,i)=(loss(1,i)>180);%ͳ�Ƹ�����ȱʧ�����Ƿ񳬹�40%����Ϊ1
%       end
%       loss_num=sum(loss_50);%ͳ��ȱʧ��������40%������ֵ�ĸ���
      [row_neg,col_neg]=find(nonAHE_data(601:660,4)<=0);
      num_neg=length(row_neg);
      if num_neg>5
         movefile(filename_i,'D:\1yj_nonAHE\discard'); 
      end
   end
end