function [ output ] = interpolation( y )
%�����������е�0ֵ���в�ֵ����ȫ

    npoint=5;
    [X,Y,Z]=find(y);%�ҵ������з���ֵ��λ�ã�XΪ�����У�YΪ�����У�ZΪֵ
    mean_data=sum(Z)/length(X);
    
    if y(1,:)==0;
        y(1,:)=mean_data;
        y(2,:)=mean_data;
    end
    if y(end,:)==0
        y(end,:)=mean_data;
        y(end-1,:)=mean_data;
    end
    
    
    yaux=y;%yaux���������ֵ��Ľ����
N=length(y);
segmento=[];%��¼��Ҫ��ֵ��λ��
i=1;
%.................................
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
        idleft =max(1,inicio-npoint);%0ֵ�����ǰ��5����
        idright=min(N,fim+npoint);%0ֵ�յ������5����
        yleft  =mean(y(idleft:inicio));%��ֵΪ0ֵ֮ǰ5��ֵ��ƽ��ֵ
        yright =mean(y(fim:idright));%��ֵΪ0ֵ֮��5��ֵ��ƽ��ֵ
        p      = polyfit([inicio fim],[yleft yright],4);%�������Բ�ֵ
        yaux(inicio:fim) = polyval( p, inicio:fim);%���Բ�ֵ���

        % figure(1)
        % [inicio fim]
        % plot(1:length(y),y,'g',[inicio:fim],y(inicio:fim),'r.',[inicio:fim],yaux(inicio:fim),'b.')
        % pause
    end
    i=i+1;
end
output=yaux;

end

