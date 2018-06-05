function [ output ] = interpolation( y )
%将输入序列中的0值进行插值处理补全

    npoint=5;
    [X,Y,Z]=find(y);%找到序列中非零值的位置，X为所在行，Y为所在列，Z为值
    mean_data=sum(Z)/length(X);
    
    if y(1,:)==0;
        y(1,:)=mean_data;
        y(2,:)=mean_data;
    end
    if y(end,:)==0
        y(end,:)=mean_data;
        y(end-1,:)=mean_data;
    end
    
    
    yaux=y;%yaux用来保存插值后的结果，
N=length(y);
segmento=[];%记录需要插值的位置
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
        idleft =max(1,inicio-npoint);%0值起点向前找5个点
        idright=min(N,fim+npoint);%0值终点向后找5个点
        yleft  =mean(y(idleft:inicio));%左值为0值之前5个值的平均值
        yright =mean(y(fim:idright));%右值为0值之后5个值的平均值
        p      = polyfit([inicio fim],[yleft yright],4);%进行线性插值
        yaux(inicio:fim) = polyval( p, inicio:fim);%线性插值结果

        % figure(1)
        % [inicio fim]
        % plot(1:length(y),y,'g',[inicio:fim],y(inicio:fim),'r.',[inicio:fim],yaux(inicio:fim),'b.')
        % pause
    end
    i=i+1;
end
output=yaux;

end

