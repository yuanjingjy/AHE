function [ AHEdata,INI,INI0,len,AHE_episode] = findAHE( inputdata,ForecastWin,Win,VAL,TOL)
%------------------------������˵��-------------------%
%������Ĺ���Ϊ���ռ��Ե�Ѫѹ�Ķ��壺Ԥ�ⴰ���ڣ�1��Сʱ�����ڸ�����ÿ����
%����һ�εĶ���ƽ��ѹֵ��������30���ӻ������ʱ����ڣ��г���90%��Ѫѹֵ
%����60mmHgʱ����Ϊ�û��߳����˼��Ե�Ѫѹ��ɸѡ��11��Сʱ�����ݶ�
%
%�����ж����ݳ��ȣ�
%       �����ݳ��Ȳ���ʮһСʱʱ����¼��ǰ��ţ������ʾ�����ݳ��Ȳ��㣻
%       �����ݳ��ȳ���ʮһСʱʱ���ӵ�ʮ��Сʱ֮��ĵ㿪ʼ�ж��Ƿ�ᷢ��AHE
%       
%       �ص�����Ϊ10min������11��Сʱ���ȵ����ݶΣ��ص�����Ϊ10min�����ƶ�
%
% ���������
%       AHEdata�����1��Сʱ�����˼��Ե�Ѫѹ�Ĺ�11(��3)Сʱ������
%       INI�� ��4�� ��һ�У���Ѫѹ�б𴰵���ʼλ�ã���ǰ��10��Сʱ��2��СʱΪ���ݶ����
%                   �ڶ��У��б��ڷ�����Ѫѹ�����ݶε���ʼλ��
%                   �����У��б��ڷ�����Ѫѹ�����ݶγ���
%                   �����У���Ѫѹ����ռ���������ݶγ��ȵİٷֱ�
%              INI��ÿһ�б�ʾ��Ѫѹ�б��ƶ�ʱ���ҵ��ķ������Ե�Ѫѹ�Ĵ�
%       INI0��INI0ΪINI�����һ�У���ʾ�ҵ������һ��������Ѫѹ�Ĵ���
%       len:��������ݶεĳ��ȣ����ٱ�֤Ԥ�ⴰ������2��Сʱ���ȵ�����
%
%���������
%       inputdata�����ж����ݶ�
%       ForcastWin��Ԥ�ⴰ�ڵĳ��ȣ�1��Сʱ��������60��
%       Win:��С���ƶ����ڵĳ��ȣ����Сʱ������21��
%       VAL��������ѪѹʱѪѹֵ�������ֵ��60mmHg������60��
%       TOL��Win��Ѫѹֵ����VAL�ĸ���ռ�������ڵı���������0.9��

lenN=length(inputdata);
INI=[];
if lenN<660%�ж����ݶγ����Ƿ��㹻11��Сʱ
    hour=lenN/60;
    disp('���ݳ��Ȳ���11Сʱ��');
    if hour>=3.5
        forelen=2*ForecastWin;%���ٱ�֤Ԥ�ⴰ��֮ǰ��2��Сʱ������
        for iniwin=forelen+1:1:lenN-ForecastWin+1%1Сʱ���ڵ���ʼλ�ã����ܻᱨ����Ϊ�������ݶγ���δ����10����������
            X_input=inputdata(iniwin:iniwin+ForecastWin-1);
            %0ֵ����6��ʱ�������ö�����
            zero_len=length(find(X_input==0));
            if zero_len >= 6
               continue; 
            end
            [ ahe_find,ini0,ini1] = AHEEpisode( X_input,Win,VAL,TOL );
             if ahe_find == 1
                ini_win=iniwin;%��Ѫѹ�б𴰵���ʼλ��
                ini_ahe=ini1(:,1);%�б��ڵ�Ѫѹ����ʼλ��
                len_ahe=ini1(:,2);%�����б��ڷ�����Ѫѹ�Ĵ���
                per_ahe=ini1(:,3);%�б��ڵ�Ѫѹ����ռ�ı���
                
                INI_tmp=[ini_win,ini_ahe,len_ahe,per_ahe];
                INI=[INI;INI_tmp];
            end           
        end
        
        if length(INI)>0
            AHEdata=inputdata(INI(end,1)-forelen:INI(end,1)+ForecastWin-1,:);
            AHE_start=INI(end,1)-forelen;
            AHE_end=INI(end,1)+ForecastWin-1;
            AHE_episode=[AHE_start,AHE_end];
            INI0=INI(end,:);
            len=length(AHEdata);
        else
            AHEdata=[];
            AHE_episode=[];
            INI0=[];
            len=[];
        end
 else
    AHEdata=[];
    AHE_episode=[];
    INI0=[];
    len=[];
    end
end

if lenN>=660
    forelen=10*ForecastWin;%���ٱ�֤Ԥ�ⴰ��֮ǰ��2��Сʱ������
        for iniwin=(forelen+1):1:(lenN-ForecastWin+1)%1Сʱ���ڵ���ʼλ�ã����ܻᱨ����Ϊ�������ݶγ���δ����10����������
            X_input=inputdata(iniwin:iniwin+ForecastWin-1);
            %0ֵ����6��ʱ�������ö�����
            zero_len=length(find(X_input==0));
            if zero_len >= 6
               continue; 
            end
            [ ahe_find,ini0,ini1] = AHEEpisode( X_input,Win,VAL,TOL );
            if ahe_find == 1
                ini_win=iniwin;%��Ѫѹ�б𴰵���ʼλ��
                ini_ahe=ini1(:,1);%�б��ڵ�Ѫѹ����ʼλ��
                len_ahe=ini1(:,2);%�����б��ڷ�����Ѫѹ�Ĵ���
                per_ahe=ini1(:,3);%�б��ڵ�Ѫѹ����ռ�ı���
                
                INI_tmp=[ini_win,ini_ahe,len_ahe,per_ahe];
                INI=[INI;INI_tmp];
            end           
        end
        
        if length(INI)>0
            AHEdata=inputdata(INI(end,1)-forelen:INI(end,1)+ForecastWin-1,:);
            AHE_start=INI(end,1)-forelen;
            AHE_end=INI(end,1)+ForecastWin-1;
            AHE_episode=[AHE_start,AHE_end];
            INI0=INI(end,:);
            len=length(AHEdata);
        else
            AHEdata=[];
            INI0=[];
            len=[];
            AHE_episode=[];
        end
end
% plot(AHEdata)
% title('����Ѫѹ���ݶ�')
% xlabel('ʱ�䣨���ӣ�')
% ylabel('ABPMean��mmHg��')
end

