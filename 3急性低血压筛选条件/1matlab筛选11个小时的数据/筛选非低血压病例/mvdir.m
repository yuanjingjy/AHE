clc
clear all
addpath(genpath('F:\F��\Project\���Ե�Ѫѹ\3.���Ե�Ѫѹɸѡ����\1matlabɸѡ11��Сʱ������'))
%��������
%   1.��ȡ�����з�����Ѫѹ�Ĳ������ļ�����
%   2.��������Ѫѹ�Ĳ����������ļ����ƶ���ָ��λ�ã�ʣ�µļ�Ϊδ������Ѫѹ������

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

% %����_selected.mat��ѡδ������Ѫѹ����
% path_nonAHE='D:\Available_yj\already'%�����л��ˣ�·��û�б仯
% cd (path_nonAHE)
% FileList_nonAHE=dir(path_nonAHE);%����δ����AHE�������ļ���
% for k=1:length(FileList_nonAHE)
%    nonAHEname=FileList_nonAHE(k).name;%δ����AHE�ļ�������
%    if nonAHEname(1)=='s'
%        cd(FileList_nonAHE(k).name); %�����ļ���
%        FileList_data=dir('*select.mat');
%        for numdata=1:length(FileList_data)
%           tmpname=FileList_data(numdata).name;
%           load(tmpname);
%           [startpoint,output_data]=selectnon(val_final);
%           if length(output_data)>0 
%               nonAHE_data=val_final(startpoint:startpoint+659,1:7);
%               name_nonAHE=[tmpname(1:end-10),'non.mat'];
%               save(['D:\1yj_nonAHE\',name_nonAHE],'nonAHE_data');
%           end
% 
%        end
%        cd ..
%    end
%    
% end
