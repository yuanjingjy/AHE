function [ output] = pro_nan( data)
%pro_nan���������������������к���NAN����
%��ĳһ�������ĳһ������ȱʧʱ����õ�ͳ�Ʊ���Ϊ�Ƿ�ֵ����0ֵ
%���ڴ����������0ֵ��Ƿ�ֵ���ø����������ݵ�ƽ��ֵ���
%
%
%   ���룺
%       data:������������
%   �����
%       output����ȫ֮���������������

mean_data=data;
%�ҵ�NaNֵ��λ��
[m,n]=find(isnan(mean_data)==1);

%����ֵ��λ������
len=length(m);
for i=1:len
   for j=1:len
      mean_data(m(i),n(j))=0; 
   end
end

%��������ƽ��ֵ
sum_value=sum(mean_data);

%��������з���ֵ�ĸ���
col=size(mean_data,2);
nonzero_num=[];
for i=1:col
   nonzero=find(mean_data(:,i));
   nonzero_num(i)=length(nonzero);
end

 for k=1:11
    mean_value(k)=sum_value(k)./nonzero_num(k); 
 end

 [row,col]=find(mean_data==0);
len=length(row);
for i=1:len
    for j=1:len
       mean_data(row(i),col(j))=mean_value(col(j));
    end
end
output=mean_data;
end

