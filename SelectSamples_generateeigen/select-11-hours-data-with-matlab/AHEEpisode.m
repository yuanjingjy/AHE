function [ ahe_find] = AHEEpisode( input,WIN,VAL,TOL )
%Description:
%   �ú����Ĺ���Ϊ�ж�1��Сʱ�����ݴ������Ƿ����˼��Ե�Ѫѹ
%���������
%   ahe_find:��ʶ��1Сʱ��Ԥ�ⴰ�����Ƿ����˼��Ե�Ѫѹ��
%            ֵΪ1��ʾ������ֵΪ0��ʾδ����       
%
%���������
%	input�����жϵ�1Сʱ�����ݶ�
%   WIN���жϴ��ĳ��ȣ�30min�����
%   VAL��������Ѫѹ��ABPMean����ֵ��Ϊ60mmHg
%   TOL������AHEʱ����������ֵVAL�ĵ���ռ�ı�����Ϊ0.9

N=length(input);
ahe_find=0;

for winlen=WIN:60%�жϴ��ĳ���Ϊ30min�����ʱ����
   for winini=1:N-winlen+1%���жϴ����£�������ʼλ��
      X=input(winini:winini+winlen-1); 
      id=find(X<=VAL);
      per_VAL=length(id)/winlen;%����60mmHgѪѹֵ��ռ�ı���
      
      if per_VAL>=TOL%С��60mmHg��Ѫѹֵ�����Ƿ񳬹�90%
          ahe_find=1;
          break;%ֻҪ�ҵ��������Ե�Ѫѹ�����ݶξ�ֹͣ
      end   
   end
  
   
end

end

