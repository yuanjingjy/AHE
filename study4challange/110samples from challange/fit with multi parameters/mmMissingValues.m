%% 该函数的主要功能为处理缺失数据及异常值
%输入参数：
%       data：待处理的数据
%       maxmium：data的上限值，超出当作异常值处理
%输出参数：
%       yout：异常处理后的数据
%————————————————————————————%

function yout=mmMissingValues( data,maxmium)
 
npoint=5;
TOL   =5;  % 相邻两点差值小于5


%------------------------------- for each signal
y=data; 
%----------------------
%将小于0的位置置零（缺失值）
i99=find(y<0);
y(i99)=0.0; 

%将大于maxmium的位置置零（异常数据）
i200=find(y>=maxmium);
y(i200)=0.0; 
  
%将空值的位置置零
[m,n]=find(isnan(y)==1);
len=length(m);
for i=1:len
    y(m(i))=0;
end


%----------------------
%对于连续两个测量点之间差值大于TOL情况，后一个点的值与前一个点的值相等
ydif=diff(y);
for i=2:length(ydif)
    if (abs(ydif(i))> TOL);
        y(i)=y(i-1);
    end
end

%----------------------
%定义插值变量及结果存储位置
yaux=y;
N=length(y);
segmento=[];
i=1;

%.................................
%对缺失数据（0值）进行线性插值处理
while i<N
    %-----------------------------------------------
    %确定0值的位置
    if y(i)==0
        inicio=i;%0值的起点
        
        %连续的0
        while y(i)==0 & i<N
            i=i+1;
        end
        fim=i;%0值的终点
        
        segmento=[segmento;inicio fim];
        
        
      %----------------------------------- interpolation
      %插值起点值为0值起点向前5个点求平均值，插值终点为0值终点向后5个数的平均值
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




