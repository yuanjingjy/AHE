clc
clear all
addpath(genpath('..\AHE\SelectSamples\extract-mimic-data-with-matlab'))

%Description:
%   ��ȡ����δ����AHE�������ݼ�¼����ʼʱ���Լ�11Сʱ���ݶε���ʼλ��
%Input:
%   ahepath='D:\1yj_nonAHE\ʱ���������\'������ɸѡ������11СʱnonAHE���ݶ�
%Output:
%   time_point(i-2,1)=startpoint��11Сʱ���ݶε���ʼλ�ã���Ӧ��λΪ����
%   time_point(i-2,2)=ahe_id��subject_id
%   starttime_point(i-2,:)=starttime:�������ݼ�¼����ʼʱ��

codepath='..\AHE\SelectSamples\extract-mimic-data-with-matlab\';
ahepath='D:\1yj_nonAHE';%���ɸѡ����AHE������·��
srcpath='D:\Available_yj\already\'%Ԥ������ԭʼ���ݵ��ļ��У�AHE�����Ӵ˴���ȡ
FileList_ahe=dir(ahepath);%��ȡ����AHE�������

for i=1:length(FileList_ahe)
    if FileList_ahe(i).isdir==0
        %����������������������������������������������������������������%
        %�ҵ�������Ӧ��ԭʼ�����ļ��У�src �����л�·��src
        filename_ahe=FileList_ahe(i).name;%ɸѡ����AHE���������ļ���ʽ
        srcname=filename_ahe(1:6);%���Ƶ�ǰ6���ַ�Ϊ������ţ��Ƕ�Ӧ���ļ�������
        src=[srcpath,srcname];
        cd(src)
        
        %����������������������������������������������������������������%
        %��������Ӧ��ͷ�ļ�����ȡ����¼����ʼʱ�䣬��ת��Ϊ��postgreSQLһ��
        %��ʱ���ʽ��starttime����
        filename_hea=[filename_ahe(1:end-8),'.hea'];%����nonAHE�Ǽ�8��AHE�Ǽ�15
        fid=fopen(filename_hea);
        lines=get_lines(fid);
        data=importdata(filename_hea,'\t');
        [row_hea,col_hea]=size(data);
        data_starttime=cell2mat(data(end));%ͷ�ļ�������¼���Ǽ�¼����ʼʱ��
        starttime_tmp=data_starttime(end-23:end-1);%��ȡ����ʾʱ����ַ���
        
        starttime=extracttime(starttime_tmp);%����ȡ����ʱ��ת����postgresql��һ�µĸ�ʽ
        fclose(fid);
        
        %����������������������������������������������������������������%
        %��ԭʼ���ݶ��У��ҵ�AHE������Ӧ��λ��
        cd(ahepath)
        load(filename_ahe);
%         ahe_episode=AHE_tmp(:,4);%ɸѡ����AHE����
        ahe_episode=nonAHE_data(:,4);%ɸѡ����AHE����
        cd(src)
        
        filename_ahesrc=[filename_ahe(1:end-8),'_select.mat'];
        load(filename_ahesrc);
        ahe_source=val_final(:,4);%AHE������ԭʼ���ݶ�
        startpoint  = locate_AHE( ahe_episode,ahe_source);
        clear val_final
        clear AHE_tmp
       
        
        ahe_id=str2num(srcname(2:end));
        
        time_point(i-2,1)=startpoint;
        time_point(i-2,2)=ahe_id;
        starttime_point(i-2,:)=starttime;
        
        cd (codepath)
    end
   
end
