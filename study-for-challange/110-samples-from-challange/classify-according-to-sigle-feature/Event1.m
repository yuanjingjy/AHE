clc
clear all

load testA


%index II:the 5-min average of the ABP waveform before the forecast window
trainset2=testA;
indexII_H=mean(trainset2(32401:36000,:));
[sortII idxII] = sort(indexII_H);
% scoreII_H=scoreH(idxII);

%{
%index3:optimal exponentially weighted average of the 10-hr ABPMean
%before the forecast window
trainset3=testdata_ABPMean(1:600,:);
alpha=0.3;
[row,col]=size(trainset3);
for i=1:col
   s(1,i)=trainset3(1,i);
   for j=2:row
      s(j,i)=alpha*trainset3(j,i)+(1-alpha)*s(j-1,i); 
   end
end
figure 
plot(trainset3(:,5));
hold on
plot(s(:,5))
legend('Trainset','EWMA')

indexIII_H=mean(s);
[sortIII,idxIII]=sort(indexIII_H);

%indexIV:the predicted ABPMean at the midpoint of the forecast window via 
%linear regression of the 1-hr ABPMean before the forecast window
trainset4=testdata_ABPMean(541:600,:);
[row,col]=size(trainset4);
x=1:60;
x=x';
for i=1:col
    p=polyfit(x,trainset4(:,i),1);
    indexIV_H(i)=polyval(p,91);
end
[sortIV idxIV] = sort(indexIV_H);
%}