function [ ahe_find] = AHEEpisode( input,WIN,VAL,TOL )
%�ú����Ĺ���Ϊ�ж�1��Сʱ�����ݴ������Ƿ����˼��Ե�Ѫѹ
%   ���������
%       ahe_find:��ʶ��1Сʱ��Ԥ�ⴰ�����Ƿ����˼��Ե�Ѫѹ��
%                 ֵΪ1��ʾ������ֵΪ0��ʾδ����
%       ini0����3�У���һ��Ϊ������Ѫѹ�Ĵ�����ʼλ��
%                    �ڶ���Ϊ������Ѫѹ�Ĵ�����
%                    ������Ϊ�ô�����С��60mmHg��ֵ��ռ�ı���
%       ini1: ini0�У����������ֵ����Ӧ���У�����Ѫѹ��������صĴ��ڵ�?����������������
%             ����ʼλ�á���������Ѫѹ����ռ����
%       
%
%   ���������
%       input�����жϵ�1Сʱ�����ݶ�
%       WIN���жϴ��ĳ��ȣ�30min�����
%       VAL��������Ѫѹ��ABPMean����ֵ��Ϊ60mmHg
%       TOL������AHEʱ����������ֵVAL�ĵ���ռ�ı�����Ϊ0.9

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
          break;%ֻҪ�ҵ��������Ե�Ѫѹ�����ݶξ�ֹͣ
      end   
   end
  
   
   %%%����ע�͵��Ĳ���Ϊ��ԭʼ�ĳ����Ƕ��������ݶν���ѭ����Ȼ��ѡ���Ե�Ѫѹ�����ص�һ��
%    if length(ini0)>0
%       %��¼�õ�pmax���ֵʱ��Ӧ�Ĵ�����������ʼλ�á�pmaxֵ
%       MAX_perc=-1;
%       [row,col]=size(ini0);
%       for i=1:row%��pmax�����ֵ
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

