function [ ahe_find] = AHEEpisode( input,WIN,VAL,TOL )
%Description:
%   该函数的功能为判断1个小时的数据窗口内是否发生了急性低血压
%输出参数：
%   ahe_find:标识该1小时的预测窗口内是否发生了急性低血压，
%            值为1表示发生，值为0表示未发生       
%
%输入参数：
%	input：待判断的1小时的数据段
%   WIN：判断窗的长度，30min或更长
%   VAL：发生低血压的ABPMean下限值，为60mmHg
%   TOL：发生AHE时，低于下限值VAL的点所占的比例，为0.9

N=length(input);
ahe_find=0;

for winlen=WIN:60%判断窗的长度为30min或更长时间内
   for winini=1:N-winlen+1%该判断窗长下，窗的起始位置
      X=input(winini:winini+winlen-1); 
      id=find(X<=VAL);
      per_VAL=length(id)/winlen;%低于60mmHg血压值所占的比例
      
      if per_VAL>=TOL%小于60mmHg的血压值比例是否超过90%
          ahe_find=1;
          break;%只要找到发生急性低血压的数据段就停止
      end   
   end
  
   
end

end

