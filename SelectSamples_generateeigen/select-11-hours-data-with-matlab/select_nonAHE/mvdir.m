clc
clear all
addpath(genpath('F:\F��\Project\���Ե�Ѫѹ\3.���Ե�Ѫѹɸѡ����\1matlabɸѡ11��Сʱ������'))
%Description:
%   1.��ȡ�����з�����Ѫѹ�Ĳ������ļ�����
%   2.��������Ѫѹ�Ĳ����������ļ����ƶ���ָ��λ�ã�ʣ�µļ�Ϊδ������Ѫѹ������
% Input��
%   pathahe='D:\1yj_AHE'
%Output:
%   path='D:\Available_yj\AHEdir'

%%��ȡ���з���AHE�Ĳ������
pathahe='D:\1yj_AHE'
FileList=dir(pathahe);
cd(pathahe);
for i=1:length(FileList)
    if FileList(i).isdir == 0
        filename_i=FileList(i).name;
        file_ahe(i,:)=filename_i(:,1:6);
    end  
end

%%�����з���AHE���ļ����ƶ���ָ��λ�ã���ʣ�µ���������ѡδ����AHE��
path_all='D:\Available_yj\already'
cd(path_all)
FileList_all=dir(path_all);
for j=1:length(file_ahe)
   tmpname=file_ahe(j,:);
   if tmpname(1) == 's'
       if (exist(tmpname)==7)
            movefile(tmpname,'D:\Available_yj\AHEdir');
       else
           continue;
       end
   end
end

