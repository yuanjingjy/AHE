function [ ahe_find] = AHEEpisode( input,WIN,VAL,TOL )
%该函数的功能为判断1个小时的数据窗口内是否发生了急性低血压
%   输出参数：
%       ahe_find:标识该1小时的预测窗口内是否发生了急性低血压，
%                 值为1表示发生，值为0表示未发生
%       ini0：共3列，第一列为发生低血压的窗的起始位置
%                    第二列为发生低血压的窗长度
%                    第三列为该窗口内小于60mmHg的值所占的比例
%       ini1: ini0中，第三列最大值所对应的行，即低血压情况最严重的窗口的?还是找最轻的情况？
%             窗起始位置、窗长、低血压点所占比例
%       
%
%   输入参数：
%       input：待判断的1小时的数据段
%       WIN：判断窗的长度，30min或更长
%       VAL：发生低血压的ABPMean下限值，为60mmHg
%       TOL：发生AHE时，低于下限值VAL的点所占的比例，为0.9

N=length(input);
ahe_find=0;
% ini0=[];
% per_MAX=-1;
% MAX_Win=0;
% ini1=[];

for winlen=WIN:60
   for winini=1:N-winlen+1
      X=input(winini:winini+winlen-1); 
      id=find(X<=VAL);
      per_VAL=length(id)/winlen;
      
      if per_VAL>=TOL
%           ini_tmp=[winini,winlen,per_VAL];
%           ini0=[ini0; ini_tmp];
%           ini1=ini0;
          ahe_find=1;
          break;%只要找到发生急性低血压的数据段就停止
      end   
   end
  
   
   %%%下面注释掉的部分为最原始的程序，是对整个数据段进行循环，然后选择急性低血压最严重的一段
%    if length(ini0)>0
%       %记录得到pmax最大值时对应的窗长、窗的起始位置、pmax值
%       MAX_perc=-1;
%       [row,col]=size(ini0);
%       for i=1:row%找pmax的最大值
% %           if ini0(i,col)>MAX_perc
% %               MAX_perc=ini0(i,col);
% %               index=i;
% %               ini1=ini0(index,:);
% %               MAX_Win=max(ini0(:,2));
% %           end
%           if ini0(i,2)>MAX_Win
%               MAX_Win=ini0(i,col-1);
%               index=i;
%               ini1=ini0(index,:);
%           end
%       end
%    else
%        ini1=[];
%    end
   
end

end

