function scoreH1 = scoreH1( idx )
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
    H1_err=0;
    for i = 1:15
       if(idx(i)>15)
           H1_err=H1_err+1;
       end
    end
    scoreH1=(15-H1_err)/15;
end

