pi = 3.1415926
x=0:0.01:4*pi
y=sin(x);
Y=diff(y,2);          %Çó¶þ½×µ¹Êý
[I,J]=find(abs(Y)<0.000001);  
plot(x,y)
hold on
a = x(J)
b = y(J);
plot(a,b,'*')

trapz(y)
