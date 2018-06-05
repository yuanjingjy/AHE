function AUC = AUCH( tables,idx )
%统计分类结果，理想情况下得分排在前30的属于一类
    output=zeros(2,60);
    for i=1:60
        if(idx(i)>30)
            output(2,i)=1;
        else
            output(1,i)=1;
        end
    end    
end

