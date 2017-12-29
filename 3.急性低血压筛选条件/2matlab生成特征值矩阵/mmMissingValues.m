function yout=mmMissingValues( data,maxmium)

%该函数寻找缺失值及异常大、异常小值的位置
%各生理参数上限值：
%   HR：250
%   ABPMean：200
%   ABPDias：200
%   ABPSys：200
%   PULSE：200
%   RESP：100
%   SpO2：100

npoint=5;
TOL   =5;  % two consecutive measurements should be less than TOL


%------------------------------- for each signal
y=data; 
%----------------------
i99=find(y<0);

y(i99)=0.0; 

i200=find(y>=maxmium);
y(i200)=0.0; 
  
[m,n]=find(isnan(y)==1);

%将空值的位置置零
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
while i<N
    if y(i)==0
        inicio=i;%0值的起点
        
        %连续的0
        while y(i)==0 & i<N
            i=i+1;
        end
        fim=i;%0值的终点
        
        segmento=[segmento;inicio fim];
        %----------------------------------- interpolation
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




