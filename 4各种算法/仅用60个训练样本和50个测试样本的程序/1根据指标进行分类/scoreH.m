function  rate_H  = scoreH( idx )
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    H_err=0;
    for i =1:30
     if(idx(i)>30)
         H_err=H_err+1;
     end
    end
    rate_H=(30-H_err)/30;
end

