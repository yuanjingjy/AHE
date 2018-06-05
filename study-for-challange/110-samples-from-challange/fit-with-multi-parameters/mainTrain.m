%���������Ҫ����Ϊ��������ֵ���������ѵ������ģ��

clc
clear all
load flagvalue_dis%����ֵ���������
%����������������й�һ������������б�ʾ���
len_flag=size(flagvalue_dis,2);
for i=1:len_flag-2
   tmp=flagvalue_dis(:,i);
   flagvalue_nor(:,i)=mmNormalize(tmp,-1,1);%��һ��
end
flag_nonNorm=flagvalue_dis(:,end-1:end);%������б�ʾ���������Ҫ���й�һ��
flagvalue_nor=[flagvalue_nor,flag_nonNorm];%����ֵ��һ���������ֵ���������

%���������ѡ������ѵ������ı���SPSS��ѡ��������ѵ������ģ�͵�����ֵ
% index_flag=[1,2,5,12,13,16,23,24,36,40,58,63,65,66];
index_flag=[36,40,58,63,65,66];
% index_flag=[1,2,5,12,13,16,23,24];

for i=1:length(index_flag)
   data_input(:,i)=flagvalue_nor(:,index_flag(i)) ;%����ģ�͵��������
end

data_output=flagvalue_nor(:,end-1:end);%����ģ�͵��������

%�淶���ƣ�
train_input=data_input;
train_output=data_output;

%��ѵ��������10�۽�����֤
% mse_max=0;
desired_input=[];%����ģ�Ͷ�Ӧ����
desired_output=[];%����ģ�Ͷ�Ӧ���
bestnet=[];%����ģ�ͽ��
besthide=[];%������������Ŀ
right_num=0;%��ȷ�������Ŀ
besterror=[];%�����
indices=crossvalind('Kfold',length(train_input),10);%����10�۷�����
k=1;

for i=1:10
   disp(['����Ϊ��',num2str(i),'�ν�����֤���'])
   
   %ѵ�����ּ����Բ������ݱ��
   testset=(indices == i);
   trainset=~testset;
   
   %ѵ���������������p�����룬t�����
   p_cv_train=train_input(trainset,:);%p_��������Ԥ���
   t_cv_train=train_output(trainset,:);%t_����������֤�����
   
   %��֤���ֵ��������
   p_cv_test=train_input(testset,:);
   t_cv_test=train_output(testset,:);
   
   %����ת��
   p_cv_train=p_cv_train';
   t_cv_train=t_cv_train';
   p_cv_test=p_cv_test';
   t_cv_test=t_cv_test';
   
for j=14%ͨ��ѭ����ѡ����������Ŀ
   
    %ָ��ģ�ͽṹ
   hiddenLayerSize=j;%��������Ŀ
   net=patternnet(hiddenLayerSize);%ģ�ͽṹ
   net.divideParam.trainRatio=70/100;%70%����������ģ��ѵ��
   net.divideParam.valRatio=15/100;%15%����������ģ����֤
   net.divideParam.testRatio=15/100;%15%��ģ������ģ�Ͳ���
   
   [net,tr]=train(net,p_cv_train,t_cv_train);%ѵ��ģ��
   %��ѵ���õ�ģ�ͽ���Ԥ����Բ�������
   outputs=net(p_cv_test);
   outputs=round(outputs);
%    outputs=net(p_cv_train);
%    outputs=round(outputs);
   errors=gsubtract(t_cv_test,outputs);
   rightnum=find(errors(1,:)==0);%��ȷ������Ŀ
   rightlen=length(rightnum);
%    testperform=perform(net,t_cv_test,outputs);
%    testperform=perform(net,t_cv_train,outputs);
%    if testperform > mse_max
%        mse_max=testperform;
%        desired_input=p_cv_train;
%        desired_output=t_cv_train;
%        bestnet=net;
%        besthide=j;
%        k=i;
%    end  
    if rightlen>right_num%������ȷ������Ŀ����ѡ����ģ��
        right_num=rightlen;%�������ŷ�����Ŀ
        desired_input=p_cv_train;%����ģ������
        desired_output=t_cv_train;%����ģ�����
        bestnet=net;%����ģ��
        besthide=j;%������������Ŀ
        besterror=errors;%��С���ֵ
        k=i;
    end

end
end
 disp(['��',num2str(k),'�ν�����֤Ч�����'])%��ѡ��������ģ�ͣ�����ѵ����ͼ�λ�ѵ������
 netfinal=patternnet(besthide);
 netfinal.divideParam.trainRatio=70/100;
 netfinal.divideParam.valRatio=15/100;
 netfinal.divideParam.testRatio=15/100;
   
 [net,tr]=train(netfinal,desired_input,desired_output);
 cmd=['save Ԥ��\bestnet net'];
 eval(cmd);