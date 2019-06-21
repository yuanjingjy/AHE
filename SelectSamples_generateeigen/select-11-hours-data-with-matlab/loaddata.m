clc;
clear all;
% addpath(genpath('E:/预测低血容量/201703'))
addpath(genpath('D:\01袁晶\Githubcode\AHE\SelectSamples_generateeigen\select-11-hours-data-with-matlab'))

% Description：
%   本程序对convert_wavedata之后的原始波形文件进行格式转换，按照基线、增益处理后，
%   将生理参数按照特定的顺序进行排列：HR、SBP、DBP、MBP、PULSE、RESP、SPO2
%Input data：
%   path='D:\Available_yj\already\，convert_wavedata之后的数据
%Output data：
%   以"_selected.mat"结尾的文件，存放到path里

path='D:\01袁晶\AHEdata\already\';%存放数据的文件夹
FileList=dir(path);%提取文件夹下的文件
cd(path)%路径切换到存放数据的文件夹
for i=1:length(FileList)
   filename_i=FileList(i).name;%%子文件夹的名称
   if (FileList(i).isdir==1 && filename_i(1)=='s' )
      cd(FileList(i).name);%路径切换到子文件夹中
      displaystr=['===========Now Processing ',FileList(i).name,'================='];
      disp(displaystr);
      file_tmp=dir('*nm.hea');%查找子文件夹中的hea文件
      
      %=====对于每一个hea文件，从中提取出所记录数据的名称、基线、增益=====%
     for j=1:length(file_tmp)%对于每一个hea文件
         FS = 0;
         filename_tmp=file_tmp(j).name; %文件的名称
         fid=fopen(filename_tmp);%获取文件的id编号         
         lines = get_lines( fid ); %文件行数      
         data=importdata(filename_tmp,'\t');%读入头文件文本
         [row_data,col_data]=size(data);
         hea_end=0;
         for data_i=1:row_data
            data_tmp=cell2mat(data(data_i));
            if data_tmp(1)=='s'
                hea_end=hea_end+1;
            end
            %% 判断采样频率
            if data_i==1
                data_tmp_split = regexp(data_tmp,' ','split');
                sample_rate = cellstr(data_tmp_split(1,3));%提取采样频率
                if strcmp(sample_rate,'1')
                    FS = 1;
                    time_point = regexp(data_tmp_split(1,end-1),':','split');%将时间拆分成小时分钟秒钟
                    [m,n] = size(time_point{1,1});
                    if n == 3
                        time_sec = time_point{1,1}{1,3};%提取秒钟，在求平均的时候去除，使数据在自然分钟内进行平均
                        lag = str2num(time_sec);
                    else
                        lag = 0;
                    end
                    
                end
            end
         end
         data=data(2:hea_end,:);%去掉第一行和后3行
         data_split=regexp(data,' ','split');%将连在一起的字符串分割开，
         %分割后的信息为按列存储的元胞数组的嵌套，外层维数表示共有多少
         %个变量，内层元胞维数表示每个变量对应的增益、基线、单位等具体信息

         [m,n1]=size(data_split);%提取m，表示共记录了m个生理参数
         %[m1,n]=size(data_split{1,1});
         
         
         baseline=0;%用于记录每个变量的基线位置，不清零会保存上一步运行结果
         Gain=0;%用于记录每个变量的增益，同样，不清零会受上一步运行结果的影响
         Name=cell(1,m);%初始化存放名称的数组
         Name='';%不知道这句话起没起作用，，，，
         
         %===================开始提取基线、增益及名称=====================%
         for ii=1:m
            %提取基线
             base_tmp(1,ii)=data_split{ii,1}{1,5}; 
             baseline(1,ii)=str2num(base_tmp);
      
             %提取增益
             gain_tmp=data_split{ii,1}{1,3};
             len_base=length(gain_tmp);
             gain=' ';
             k=1;
             while gain_tmp(1,k) ~= '/' && gain_tmp(1,k) ~='('
               gain=strcat(gain,gain_tmp(1,k));
               Gain(1,ii)=str2num(gain);
               k=k+1;
             end
      
            %提取名称
            name='';
            [row,col]=size(data_split{ii,1});
            for j=9:col
                name=strcat(name,data_split{ii,1}{1,j}); 
            end
            Name{ii}=name;
         end
        %=================================================================%
        
        %========将从hea文件中提取出来的基线、增益、名称保存_hea.mat======%
         headfile.baseline=baseline;
         headfile.Gain=Gain;
         headfile.Name=Name;
         hea_name=[filename_tmp(1:end-4),'_hea.mat'];
         save (hea_name, 'headfile')
         fclose(fid);
         
          %============================数据数值转换===========================%
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
      
      %调整顺序
      tmp=0;
      num_ABP=0;
      for name_i=1:col_val
         switch_name=cell2mat(Name(name_i));      
         if (strcmp(switch_name,'HR'))
             val_final(:,1)=value_p(:,name_i);%第一列心率
         end
         
         if (strcmp(switch_name ,'ABPSys'))
             val_final(:,2)=value_p(:,name_i);%第二列动脉收缩压
         end
         
         if (strcmp(switch_name, 'ABPDias'))
             val_final(:,3)=value_p(:,name_i);%第三列动脉舒张压
         end
         
         if (strcmp(switch_name ,'ABPMean'))
             val_final(:,4)=value_p(:,name_i);%第四列动脉平均压
         end
         
         if (strcmp(switch_name,'PULSE'))
             val_final(:,5)=value_p(:,name_i);%第五列脉搏
         end
         
         if (strcmp(switch_name,'RESP'))
             val_final(:,6)=value_p(:,name_i);%第六列呼吸
         end
         
         if (strcmp(switch_name ,'SpO2'))
             val_final(:,7)=value_p(:,name_i);%第七列血氧
         end
         
         if (strcmp(switch_name , 'NBPSys'))
             val_final(:,8)=value_p(:,name_i);%第八列无创收缩压
         end
         
         if (strcmp(switch_name ,'NBPDias'))
             val_final(:,9)=value_p(:,name_i);%第九列无创舒张压
         end
         
         if (strcmp(switch_name , 'NBPMean'))
             val_final(:,10)=value_p(:,name_i);%第十列无创平均压
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
      
     
      cd ..%返回上一级目录
   end
end
