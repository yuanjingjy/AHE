%% �ú�������Ҫ����Ϊ����ȱʧ���ݼ��쳣ֵ
%���������
%       data�������������
%       maxmium��data������ֵ�����������쳣ֵ����
%���������
%       yout���쳣����������
%��������������������������������������������������������%

function yout=mmMissingValues( data,maxmium)
 
npoint=5;
TOL   =5;  % ���������ֵС��5


%------------------------------- for each signal
y=data; 
%----------------------
%��С��0��λ�����㣨ȱʧֵ��
i99=find(y<0);
y(i99)=0.0; 

%������maxmium��λ�����㣨�쳣���ݣ�
i200=find(y>=maxmium);
y(i200)=0.0; 
  
%����ֵ��λ������
[m,n]=find(isnan(y)==1);
len=length(m);
for i=1:len
    y(m(i))=0;
end


%----------------------
%������������������֮���ֵ����TOL�������һ�����ֵ��ǰһ�����ֵ���
ydif=diff(y);
for i=2:length(ydif)
    if (abs(ydif(i))> TOL);
        y(i)=y(i-1);
    end
end

%----------------------
%�����ֵ����������洢λ��
yaux=y;
N=length(y);
segmento=[];
i=1;

%.................................
%��ȱʧ���ݣ�0ֵ���������Բ�ֵ����
while i<N
    %-----------------------------------------------
    %ȷ��0ֵ��λ��
    if y(i)==0
        inicio=i;%0ֵ�����
        
        %������0
        while y(i)==0 & i<N
            i=i+1;
        end
        fim=i;%0ֵ���յ�
        
        segmento=[segmento;inicio fim];
        
        
      %----------------------------------- interpolation
      %��ֵ���ֵΪ0ֵ�����ǰ5������ƽ��ֵ����ֵ�յ�Ϊ0ֵ�յ����5������ƽ��ֵ
        idleft =max(1,inicio-npoint);
        idright=min(N,fim+npoint);
        yleft  =mean(y(idleft:inicio));
        yright =mean(y(fim:idright));
        p      = polyfit([inicio fim],[yleft yright],1);
        yaux(inicio:fim) = polyval( p, inicio:fim);

        % figure(1)
        % [inicio fim]
        % plot(1:length(y),y,'g',[inicio:fim],y(inicio:fim),'r.',[inicio:fim],yaux(inicio:fim),'b.')
        % pause
    end
    i=i+1;
end
yout=yaux;




