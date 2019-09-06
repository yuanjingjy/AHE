function yout=mmValues( data)

%Description:
%   �ú���Ѱ��ȱʧֵ���쳣���쳣Сֵ��λ��
%Input��
%   data:1��11Сʱ������
%   maximum����������ݵ�����ֵ
%Output:
%   yout�����쳣ֵ����������

npoint=5;
TOL   =5;  %two consecutive measurements should be less than TOL


%------------------------------- for each signal
y=data; 
%----------------------
i99=find(y<0);

y(i99)=0.0; 
  
[m,n]=find(isnan(y)==1);

%����ֵ��λ������
len=length(m);
for i=1:len
    y(m(i))=0;
end
%----------------------
ydif=diff(y);

for i=2:length(ydif)
    if (abs(ydif(i))> TOL);
        y(i)=y(i-1);
    end
end
yaux=y;
N=length(y);
segmento=[];
i=1;

[m,n] = find(yaux<=0);

[m1,n1] = find(yaux>0);
x_com = m1;
y_com = yaux(m1);

x_0 = m;
% y_0 = interp1(x_com,y_com,x_0,'linear');  
y_0 = mean(y_com);   


for i=1:length(n)
   yaux(m(i)) = y_0; 
end
yout=yaux;




