clc;
clear all;
% addpath(genpath('E:/Ԥ���Ѫ����/201703'))
addpath(genpath('D:\01Ԭ��\Githubcode\AHE\SelectSamples_generateeigen\select-11-hours-data-with-matlab'))

% Description��
%   �������convert_wavedata֮���ԭʼ�����ļ����и�ʽת�������ջ��ߡ����洦���
%   ��������������ض���˳��������У�HR��SBP��DBP��MBP��PULSE��RESP��SPO2
%Input data��
%   path='D:\Available_yj\already\��convert_wavedata֮�������
%Output data��
%   ��"_selected.mat"��β���ļ�����ŵ�path��

path='D:\01Ԭ��\AHEdata\already\';%������ݵ��ļ���
FileList=dir(path);%��ȡ�ļ����µ��ļ�
cd(path)%·���л���������ݵ��ļ���
for i=1:length(FileList)
   filename_i=FileList(i).name;%%���ļ��е�����
   if (FileList(i).isdir==1 && filename_i(1)=='s' )
      cd(FileList(i).name);%·���л������ļ�����
      displaystr=['===========Now Processing ',FileList(i).name,'================='];
      disp(displaystr);
      file_tmp=dir('*nm.hea');%�������ļ����е�hea�ļ�
      
      %=====����ÿһ��hea�ļ���������ȡ������¼���ݵ����ơ����ߡ�����=====%
     for j=1:length(file_tmp)%����ÿһ��hea�ļ�
         FS = 0;
         filename_tmp=file_tmp(j).name; %�ļ�������
         fid=fopen(filename_tmp);%��ȡ�ļ���id���         
         lines = get_lines( fid ); %�ļ�����      
         data=importdata(filename_tmp,'\t');%����ͷ�ļ��ı�
         [row_data,col_data]=size(data);
         hea_end=0;
         for data_i=1:row_data
            data_tmp=cell2mat(data(data_i));
            if data_tmp(1)=='s'
                hea_end=hea_end+1;
            end
            %% �жϲ���Ƶ��
            if data_i==1
                data_tmp_split = regexp(data_tmp,' ','split');
                sample_rate = cellstr(data_tmp_split(1,3));%��ȡ����Ƶ��
                if strcmp(sample_rate,'1')
                    FS = 1;
                    time_point = regexp(data_tmp_split(1,end-1),':','split');%��ʱ���ֳ�Сʱ��������
                    [m,n] = size(time_point{1,1});
                    if n == 3
                        time_sec = time_point{1,1}{1,3};%��ȡ���ӣ�����ƽ����ʱ��ȥ����ʹ��������Ȼ�����ڽ���ƽ��
                        lag = str2num(time_sec);
                    else
                        lag = 0;
                    end
                    
                end
            end
         end
         data=data(2:hea_end,:);%ȥ����һ�кͺ�3��
         data_split=regexp(data,' ','split');%������һ����ַ����ָ��
         %�ָ�����ϢΪ���д洢��Ԫ�������Ƕ�ף����ά����ʾ���ж���
         %���������ڲ�Ԫ��ά����ʾÿ��������Ӧ�����桢���ߡ���λ�Ⱦ�����Ϣ

         [m,n1]=size(data_split);%��ȡm����ʾ����¼��m���������
         %[m1,n]=size(data_split{1,1});
         
         
         baseline=0;%���ڼ�¼ÿ�������Ļ���λ�ã�������ᱣ����һ�����н��
         Gain=0;%���ڼ�¼ÿ�����������棬ͬ���������������һ�����н����Ӱ��
         Name=cell(1,m);%��ʼ��������Ƶ�����
         Name='';%��֪����仰��û�����ã�������
         
         %===================��ʼ��ȡ���ߡ����漰����=====================%
         for ii=1:m
            %��ȡ����
             base_tmp(1,ii)=data_split{ii,1}{1,5}; 
             baseline(1,ii)=str2num(base_tmp);
      
             %��ȡ����
             gain_tmp=data_split{ii,1}{1,3};
             len_base=length(gain_tmp);
             gain=' ';
             k=1;
             while gain_tmp(1,k) ~= '/' && gain_tmp(1,k) ~='('
               gain=strcat(gain,gain_tmp(1,k));
               Gain(1,ii)=str2num(gain);
               k=k+1;
             end
      
            %��ȡ����
            name='';
            [row,col]=size(data_split{ii,1});
            for j=9:col
                name=strcat(name,data_split{ii,1}{1,j}); 
            end
            Name{ii}=name;
         end
        %=================================================================%
        
        %========����hea�ļ�����ȡ�����Ļ��ߡ����桢���Ʊ���_hea.mat======%
         headfile.baseline=baseline;
         headfile.Gain=Gain;
         headfile.Name=Name;
         hea_name=[filename_tmp(1:end-4),'_hea.mat'];
         save (hea_name, 'headfile')
         fclose(fid);
         
          %============================������ֵת��===========================%
      clear val;
      clear value_p;
      val_final =[];
      matfile_name=[filename_tmp(1:end-4),'.mat'];
      
      load (matfile_name);
      val=val';
      [row_val,col_val]=size(val);
      value_p=[];
      for gain_i=1:col_val
         value_p(:,gain_i)=(val(:,gain_i)- baseline(gain_i))./Gain(gain_i);
      end
      
      %����˳��
      tmp=0;
      num_ABP=0;
      for name_i=1:col_val
         switch_name=cell2mat(Name(name_i));      
         if (strcmp(switch_name,'HR'))
             val_final(:,1)=value_p(:,name_i);%��һ������
         end
         
         if (strcmp(switch_name ,'ABPSys'))
             val_final(:,2)=value_p(:,name_i);%�ڶ��ж�������ѹ
         end
         
         if (strcmp(switch_name, 'ABPDias'))
             val_final(:,3)=value_p(:,name_i);%�����ж�������ѹ
         end
         
         if (strcmp(switch_name ,'ABPMean'))
             val_final(:,4)=value_p(:,name_i);%�����ж���ƽ��ѹ
         end
         
         if (strcmp(switch_name,'PULSE'))
             val_final(:,5)=value_p(:,name_i);%����������
         end
         
         if (strcmp(switch_name,'RESP'))
             val_final(:,6)=value_p(:,name_i);%�����к���
         end
         
         if (strcmp(switch_name ,'SpO2'))
             val_final(:,7)=value_p(:,name_i);%������Ѫ��
         end
         
         if (strcmp(switch_name , 'NBPSys'))
             val_final(:,8)=value_p(:,name_i);%�ڰ����޴�����ѹ
         end
         
         if (strcmp(switch_name ,'NBPDias'))
             val_final(:,9)=value_p(:,name_i);%�ھ����޴�����ѹ
         end
         
         if (strcmp(switch_name , 'NBPMean'))
             val_final(:,10)=value_p(:,name_i);%��ʮ���޴�ƽ��ѹ
         end
      end
      
      if length(val_final) == 0
          continue;
      end
      
      [val_m,val_n] = size(val_final);
      if FS ==1 && val_m >120
          tmp = val_final((60-lag+1):end,:);
         val_final = reSample(tmp); 
      end
          valuename=[filename_tmp(1:end-4),'_select.mat'];
          save (valuename, 'val_final');
      %===================================================================%     
   end
      
     
      cd ..%������һ��Ŀ¼
   end
end
