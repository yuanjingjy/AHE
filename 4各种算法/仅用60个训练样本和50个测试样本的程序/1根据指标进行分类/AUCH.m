function AUC = AUCH( tables,idx )
%ͳ�Ʒ���������������µ÷�����ǰ30������һ��
    output=zeros(2,60);
    for i=1:60
        if(idx(i)>30)
            output(2,i)=1;
        else
            output(1,i)=1;
        end
    end    
end

