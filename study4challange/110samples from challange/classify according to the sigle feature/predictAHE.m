clc
clear all

load ABPMean
load ABPDias

tables1=zeros(2,60);
for i=1:30
   tables1(1,i)=1;
end
for i=31:60
   tables1(2,i)=1;
end

tables2=zeros(2,30);
for i=1:15
   tables2(1,i)=1; 
end

for j=16:30
    tables2(2,j)=1;
end

%index I:the 5-min average of the MAP vital signs (ABPMean) before the 
%forecast window
num5min=600/5;
for j=1:num5min
   tmp=testdata_ABPMean((((j-1)*5+1):j*5),:);
   trainset1(j,:)=mean(tmp); 
end
indexI_H=mean(trainset1(108:120,:));
[sortI,idxI]=sort(indexI_H);
scoreI_H=scoreH(idxI);

indexI_H1=[indexI_H(:,(1:15)),indexI_H(:,(31:45))];
[sortI1,idxI1]=sort(indexI_H1);
scoreI_H1=scoreH1(idxI1);

output=zeros(2,60);
    for i=1:60
        if(idxI(i)>30)
            output(2,i)=1;
        else
            output(1,i)=1;
        end
    end    
plotroc(tables1,output);

%index II:the 5-min average of the ABP waveform before the forecast window
trainset2=testdata_ABPMean(541:600,:);
indexII_H=mean(trainset2);
[sortII idxII] = sort(indexII_H);
scoreII_H=scoreH(idxII);

indexII_H1=[indexII_H(:,(1:15)),indexII_H(:,(31:45))];
[sortII1,idxII1]=sort(indexII_H1);
scoreII_H1=scoreH1(idxII1);

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
scoreIII_H=scoreH(idxIII);

indexIII_H1=[indexIII_H(:,(1:15)),indexIII_H(:,(31:45))];
[sortIII1,idxIII1]=sort(indexIII_H1);
scoreIII_H1=scoreH1(idxIII1);

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
scoreIV_H=scoreH(idxIV);

indexIV_H1=[indexIV_H(:,(1:15)),indexIV_H(:,(31:45))];
[sortIV1,idxIV1]=sort(indexIV_H1);
scoreIV_H1=scoreH1(idxIV1);

%indexV:5-min average of the diastolic ABP vital signs (ABPDias) 
%before the forecast window
num5min=600/5;
for j=1:num5min
   tmp=testdata_ABPDias((((j-1)*5+1):j*5),:);
   trainset5(j,:)=mean(tmp); 
end
indexV_H=mean(trainset5(108:120,:));
[sortV,idxV]=sort(indexV_H);
scoreV_H=scoreH(idxV);

indexV_H1=[indexV_H(:,(1:15)),indexV_H(:,(31:45))];
[sortV1,idxV1]=sort(indexV_H1);
scoreV_H1=scoreH1(idxV1);

%indexVI:combined index of the 5-min averages of the ABP waveform (Index II)
%and ABPDias (Index V) before the forecast window
trainset6=indexII_H+indexV_H;
indexVI_H=trainset6/2;
[sortVI,idxVI]=sort(indexVI_H);
scoreVI_H=scoreH(idxVI);

indexVI_H1=[indexVI_H(:,(1:15)),indexVI_H(:,(31:45))];
[sortVI1,idxVI1]=sort(indexVI_H1);
scoreVI_H1=scoreH1(idxVI1);

output=zeros(2,60);
    for i=1:60
        if(idxVI(i)>30)
            output(2,i)=1;
        else
            output(1,i)=1;
        end
    end    

plotroc(tables1,output);
