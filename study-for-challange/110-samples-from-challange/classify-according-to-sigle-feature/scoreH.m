function  rate_H  = scoreH( idx )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明

    H_err=0;
    for i =1:30
     if(idx(i)>30)
         H_err=H_err+1;
     end
    end
    rate_H=(30-H_err)/30;
end

