clc;
clear all;
addpath(genpath('F:\F��\Project\���Ե�Ѫѹ\3.���Ե�Ѫѹɸѡ����\1matlabɸѡ11��Сʱ������'))

path='D:\Available_yj\already\';%������ݵ��ļ���
FileList=dir(path);%��ȡ�ļ����µ��ļ�
cd(path)%·���л���������ݵ��ļ���
for i=1:length(FileList)
   filename_i=FileList(i).name;%%���ļ��е�����
   if (FileList(i).isdir==1 && filename_i(1)=='s' )
      cd(FileList(i).name);%·���л������ļ�����
      displaystr=['===========Now Processing ',FileList(i).name,'================='];
      disp(displaystr);
      file_tmp=dir('*nm.hea');%�������ļ����е�hea�ļ�
      
      %=====����ÿһ��hea�ļ���������ȡ������¼���ݵ����ơ����ߡ�����======%
     for j=1:length(file_tmp)%����ÿһ��hea�ļ�
         filename_tmp=file_tmp(j).name; %�ļ�������
         fid=fopen(filename_tmp);%��ȡ�ļ���id���         
         lines = get_lines( fid ); %�ļ�����      
         data=importdata(filename_tmp,'\t');%����ͷ�ļ��ı�
         [row_data,col_data]=size(data);
         hea_end=0;
         for data_i=1:row_data
            data_tmp=cell2mat(data(data_i));
            if data_tmp(1)=='#' 
                data_split=regexp(data_tmp,' ','split');
                if strcmp(data_split{1,2},'<age>:')
                    age_tmp=data_split{1,3};
                    sex_tmp=data_split{1,5};
                    len=length(age_tmp);
                  
                    if len>2 
                        agesex(1)=300;
                    else
                        if strcmp(age_tmp,'??')
                            agesex(1)=-100;
                        else
                            agesex(1)=str2num(age_tmp);   
                        end
                    end
                    
                    

                    if strcmp(sex_tmp,'?')
                        agesex(2)=-100
                    end
                    if strcmp(sex_tmp,'F')
                        agesex(2)=1;
                    else
                        agesex(2)=0;
                    end
                end
                agename=[filename_tmp(1:end-4),'_age.mat'];                
                save (agename, 'agesex')
            end
            
         end         
        
%          save (hea_name, 'headfile')
         fclose(fid);       
   end
          
      cd ..%������һ��Ŀ¼
   end
end
