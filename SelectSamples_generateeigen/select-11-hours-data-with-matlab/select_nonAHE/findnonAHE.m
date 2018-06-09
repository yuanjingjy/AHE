clc
clear all

%Description:
%   ����selectnon.m�ļ���ɸѡδ�������Ե�Ѫѹ������
%Input:
%   path_nonAHE='D:\Available_yj\already\*select.mat'����·���µķ���AHE��ԭʼ������ת��
%Output��
%   path='D:\1yj_nonAHE\*_non.mat'


%% ����_selected.mat��ѡδ������Ѫѹ����
path_nonAHE='D:\Available_yj\already'%�����л��ˣ�·��û�б仯
cd (path_nonAHE)
FileList_nonAHE=dir(path_nonAHE);%����δ����AHE�������ļ���
for k=1:length(FileList_nonAHE)
   nonAHEname=FileList_nonAHE(k).name;%δ����AHE�ļ�������
   if nonAHEname(1)=='s'
       cd(FileList_nonAHE(k).name); %�����ļ���
       FileList_data=dir('*select.mat');
       for numdata=1:length(FileList_data)
          tmpname=FileList_data(numdata).name;
          load(tmpname);
          [startpoint,output_data]=selectnon(val_final);
          if length(output_data)>0 
              nonAHE_data=val_final(startpoint:startpoint+659,1:7);
              name_nonAHE=[tmpname(1:end-10),'non.mat'];
              save(['D:\1yj_nonAHE\',name_nonAHE],'nonAHE_data');
          end

       end
       cd ..
   end
   
end

