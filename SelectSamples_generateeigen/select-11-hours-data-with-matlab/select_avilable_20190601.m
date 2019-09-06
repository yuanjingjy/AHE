%Description��
%   ����findT0.m�����н����ɸѡ�����õ�AHE������ɸѡ�������£�
%       1.��ѡ����T0����600����������ս�����ܣ�T0֮ǰ������10Сʱ�����ݣ�
%       2.��subject_id���й��ˣ�����ͬһsubject_id��Ӧ��������AHE�����ݼ�¼
%           �����������ʱ�䣬ѡ���һ�η���AHE�����
%       3.�����ļ����Ƽ�T0λ�ã��������ļ����н��ж��벢��ȡ�������11Сʱ���ݶ�
%       4.��������ȱʧ�����һ������ɸѡ����ҪɸѡT0֮ǰ10Сʱ��ȱʧ������
%           ��ɸѡT0ʱ����Ϊ[10,60]�����ݱ�������90%��ȱʧ���Ӧ�ò��Ǻ����أ��˴����һ����֤����
%Input��
%   findT0.m�����н����D:\01Ԭ��\AHEdata\filetosave.mat�ļ�
%Output��
%  �½��ļ��У��洢ɸѡ���Ŀ��õ�11Сʱ�����ݶΡ�

clc
clear all
%% filetosave_aheΪfindT0.m�����н������1���ļ����� ��2��subject_id, 
%��3�����ݼ�¼�ܳ��ȣ�����Ϊ��λ������4��ΪT0λ�á�����ĳ���θ���T0��λ�ã�
%�ҵ�T0����600�����ݶΣ���֤T0ǰ������10Сʱ��������ÿ������ֻȡһ����¼��ʱ��
%��ǰ��ģ�
load D:\01Ԭ��\AHEdata\filetosave_ahe.mat
t0LT10h = filetosave(cell2mat(filetosave(:,4))>600,:);%T0Larger than 10Сʱ������
t0LT10h = sortrows(t0LT10h,1);%���ռ�¼ʱ���������
[c,ia,ib] = unique(t0LT10h(:,2));%ia�б������ÿ��subject_id��һ�γ��ֶ�Ӧ���к�
selected_AHE = t0LT10h(ia,:);
selected_AHE(:,5) = {1};
path='D:\01Ԭ��\AHEdata\already\';%������ݵ��ļ���
cd(path);

%% ��ȡ����AHE�����ݶΣ�����subject_id��Ӧ���ļ����ƶ���AHEdir���������
%  ��ʣ����ļ�����ɸѡδ����AHE������
for i = 1:length(selected_AHE)
    filename_i = [cell2mat(selected_AHE(i,1)),'_select.mat'];%�����ļ�����
    dir_i = filename_i(1,1:6);%�ļ�������
    t0 = cell2mat(selected_AHE(i,4));%T0��λ��
    cd(dir_i);
    load(filename_i);
    selected_data = val_final(t0-600:t0+59,1:7);%t0ǰ��600�����ݣ�����59������
    flag_missrate = 0;
%     for k = 1:7
%         [m,n] = find(val_final(1:600,k)<=0);
%         if length(m) >180
%             flag_missrate = 1;
%            break; 
%         end
%     end
    if flag_missrate == 0 
        savename = ['D:\01Ԭ��\AHEdata\AHE_2019\',cell2mat(selected_AHE(i,1)),'.mat'];
        save (savename, 'selected_data');%�����ȡ�������ݶ�
        cd ..
        movefile(dir_i,'D:\01Ԭ��\AHEdata\already\AHEdir');%ɸѡ��AHE���ļ��н����ƶ�����ʣ�µ�����ɸѡδ����AHE��
        clear selected_data
        clear val_final
        clear t0   
    else
        cd ..
    end
    

end

%% ��ʼɸѡδ����AHE������
addpath(genpath('D:\01Ԭ��\Githubcode\AHE\SelectSamples_generateeigen\select-11-hours-data-with-matlab'))
path='D:\01Ԭ��\AHEdata\already\';%������ݵ��ļ���
FileList=dir(path);%��ȡ�ļ����µ��ļ�
cd(path)%·���л���������ݵ��ļ���
num_sample = 1;
for i=1:length(FileList)
   filename_i=FileList(i).name;%%���ļ��е�����
   if (FileList(i).isdir==1 && filename_i(1)=='s' )
      cd(FileList(i).name);%·���л������ļ�����
      displaystr=['===========Now Processing ',FileList(i).name,'================='];
      disp(displaystr);
      file_tmp=dir('*_select.mat');%�������ļ����е�mat�ļ�

      %=====����ÿһ��_select.mat�ļ���ȡ������������ɸѡAHE����=====%
     for j=1:size(file_tmp)%����ÿһ��mat�ļ�
         filename_tmp=file_tmp(j).name; %�ļ�������        
         load(filename_tmp)
         [ns,nf] = size(val_final);%�������ݶγ���
         if ns<60 || nf<7
            continue
         end
         [startpoint,output_data]=selectnon(val_final);
         if length(output_data)>0 
             datafile=val_final(startpoint:startpoint+599,4);
             %% �ж�T0֮ǰ�Ƿ�����AHE��������ȥ�� 
               flag = 0;
               for i=1:5:540      
                   X_input = datafile(i:i+59,1);
                   [ ahe_find] = AHEEpisode( X_input,30,60,0.9 );
                  if ahe_find == 1
                     flag = 1; 
                  end
               end
     
                if flag == 1
                    continue; %flagΪ1����ʾT0֮ǰ������AHE��ɾ���ö����ݣ�
                end
                
             %ɸѡ������δ����AHE�ģ�ͬǰ���洢�ļ����ơ�subject_id�����ݶ���
             %���ȡ�T0λ��
             filetosave_non(num_sample,1)={filename_tmp(:,1:end-11)};
             filetosave_non(num_sample,2)={filename_tmp(:,2:6)};
             filetosave_non(num_sample,3)={ns};
             filetosave_non(num_sample,4)={startpoint+600};
             num_sample = num_sample +1 ;
             clear val_final, ns
         end     
     end
   cd ..%������һ��Ŀ¼
   end
end

save('D:\01Ԭ��\AHEdata\filetosave_non.mat','filetosave_non')
xlswrite('D:\01Ԭ��\AHEdata\nonahe.xlsx',filetosave,'Sheet1')

t0LT10h_non = filetosave_non(cell2mat(filetosave_non(:,4))>=600,:);%T0Larger than 10Сʱ������
t0LT10h_non = sortrows(t0LT10h_non,1);%���ռ�¼ʱ���������
[c,ia,ib] = unique(t0LT10h_non(:,2));%ia�б������ÿ��subject_id��һ�γ��ֶ�Ӧ���к�
selected_nonAHE = t0LT10h_non(ia,:);
selected_nonAHE(:,5) = {0};%��ǩ�У�δ����AHE�ģ���0


for i = 1:length(selected_nonAHE)
    filename_i = [cell2mat(selected_nonAHE(i,1)),'_select.mat'];
    dir_i = filename_i(1,1:6);
    t0 = cell2mat(selected_nonAHE(i,4));
    cd(dir_i);
    load(filename_i);
    selected_data_non = val_final(t0-600:t0+59,1:7);
      
    savename = ['D:\01Ԭ��\AHEdata\nonAHE_2019\',cell2mat(selected_nonAHE(i,1)),'.mat'];
    save (savename, 'selected_data_non');
    cd ..
    clear selected_data_non
    clear val_final
    clear t0
end

selected = [selected_AHE;selected_nonAHE];
save ('D:\01Ԭ��\AHEdata\total_stat.mat','selected');
xlswrite('D:\01Ԭ��\AHEdata\total_stat.xlsx',selected,'Sheet1')