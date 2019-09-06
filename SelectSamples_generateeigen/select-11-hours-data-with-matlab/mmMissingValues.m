function [yout]=mmMissingValues( data,maxmium)

%Description:
%   �ú���Ѱ��ȱʧֵ���쳣���쳣Сֵ��λ��
%   ��������������ֵ��
%       HR��250
%       ABPMean��200
%       ABPDias��200
%       ABPSys��200
%       PULSE��200
%       RESP��100
%       SpO2��100
%Input��
%   data:1��11Сʱ������
%   maximum����������ݵ�����ֵ
%Output:
%   yout�����쳣ֵ����������

npoint=5;
TOL   =5;  % two consecutive measurements should be less than TOL


%------------------------------- for each signal
y=data; 
%----------------------
i99=find(y<0);

y(i99)=0.0; 
  
[m,n]=find(isnan(y)==1);

%����ֵ��λ������
len=length(m);
for i=1:len
    y(m(i))=0;
end
%----------------------
ydif=diff(y);

for i=2:length(ydif)
    if (abs(ydif(i))> TOL);
        y(i)=y(i-1);
    end
end
yaux=y;
N=length(y);
segmento=[];
i=1;
%.................................
gap = 0;
gap_tmp = 0;
while i<N
    if y(i)==0
        inicio=i;%0ֵ�����  
        
        %������0
        while y(i)==0 & i<N
            i=i+1;
        end
        fim=i;%0ֵ���յ�
        
        segmento=[segmento;inicio fim];
        %----------------------------------- interpolation
        idleft =max(1,inicio-npoint);
        idright=min(N,fim+npoint);
        gap_tmp = idright - idleft;
        if idleft ==1 
           yleft = mean(y);
        else
            yleft  =mean(y(idleft:inicio));
        end
        yright =mean(y(fim:idright));
        p      = polyfit([inicio fim],[yleft yright],1);
        yaux(inicio:fim) = polyval( p, inicio:fim);

    end
    i=i+1;
    gap = max(gap,gap_tmp);
end

yout=yaux;



