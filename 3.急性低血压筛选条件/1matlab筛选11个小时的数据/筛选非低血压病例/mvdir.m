clc
clear all
addpath(genpath('E:/Ԥ���Ѫ����/201703/ɸѡ�ǵ�Ѫѹ����'))
%��������
%   1.��ȡ�����з�����Ѫѹ�Ĳ������ļ�����
%   2.��������Ѫѹ�Ĳ����������ļ����ƶ���ָ��λ�ã�ʣ�µļ�Ϊδ������Ѫѹ������

% %%��ȡ���з���AHE�Ĳ������
% pathahe='L:\AHE'
% FileList=dir(pathahe);
% cd(pathahe);
% for i=1:length(FileList)
%     if FileList(i).isdir == 0
%         filename_i=FileList(i).name;
%         file_ahe(i,:)=filename_i(:,1:6);
%     end  
% end
% 
% %%�����з���AHE���ļ����ƶ���ָ��λ�ã���ʣ�µ���������ѡδ����AHE��
% path_all='L:\Available'
% cd(path_all)
% FileList_all=dir(path_all);
% for j=1:length(file_ahe)
%    tmpname=file_ahe(j,:);
%    if tmpname(1) == 's'
%        if (exist(tmpname)==7)
%             movefile(tmpname,'L:\AHEdir');
%        else
%            continue;
%        end
%    end
% end

%%����_selected.mat��ѡδ������Ѫѹ����
path_nonAHE='L:\Available'%�����л��ˣ�·��û�б仯
cd (path_nonAHE)
FileList_nonAHE=dir(path_nonAHE);%����δ����AHE�������ļ���
for k=1:length(FileList_nonAHE)
   nonAHEname=FileList_nonAHE(k).name;%δ����AHE�ļ�������
   if nonAHEname(1)=='s'
       cd(FileList_nonAHE(k).name); %�����ļ���
       FileList_data=dir('*select.mat');
       for numdata=1:length(FileList_data)
          tmpname=FileList_data.name;
          load(tmpname);
          [startpoint,output_data]=selectnon(val_final(:,4));
          if length(output_data)>0 
              nonAHE_data=val_final(startpoint:startpoint+659,1:end);
              name_nonAHE=[tmpname(1:end-10),'non.mat'];
              save(['L:\nonAHE\',name_nonAHE],'nonAHE_data');
          end

       end
       cd ..
   end
   
end
