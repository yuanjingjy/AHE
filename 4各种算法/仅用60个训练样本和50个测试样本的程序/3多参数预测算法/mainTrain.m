%本程序的主要功能为利用特征值及结果矩阵，训练分类模型

clc
clear all
load flagvalue_dis%特征值及结果矩阵
%对特征参量矩阵进行归一化，除最后两列表示结果
len_flag=size(flagvalue_dis,2);
for i=1:len_flag-2
   tmp=flagvalue_dis(:,i);
   flagvalue_nor(:,i)=mmNormalize(tmp,-1,1);%归一化
end
flag_nonNorm=flagvalue_dis(:,end-1:end);%最后两列表示结果，不需要进行归一化
flagvalue_nor=[flagvalue_nor,flag_nonNorm];%特征值归一化后的特征值及结果矩阵

%根据相关性选择用于训练网络的变量SPSS挑选出的用于训练分类模型的特征值
% index_flag=[1,2,5,12,13,16,23,24,36,40,58,63,65,66];
index_flag=[36,40,58,63,65,66];
% index_flag=[1,2,5,12,13,16,23,24];

for i=1:length(index_flag)
   data_input(:,i)=flagvalue_nor(:,index_flag(i)) ;%分类模型的输入参数
end

data_output=flagvalue_nor(:,end-1:end);%分类模型的输出参数

%规范名称？
train_input=data_input;
train_output=data_output;

%对训练集进行10折交叉验证
% mse_max=0;
desired_input=[];%最优模型对应输入
desired_output=[];%最优模型对应输出
bestnet=[];%最优模型结果
besthide=[];%最优隐含层数目
right_num=0;%正确分类的数目
besterror=[];%误差结果
indices=crossvalind('Kfold',length(train_input),10);%产生10折分组编号
k=1;

for i=1:10
   disp(['以下为第',num2str(i),'次交叉验证结果'])
   
   %训练部分及测试部分数据编号
   testset=(indices == i);
   trainset=~testset;
   
   %训练部分输入输出，p表输入，t表输出
   p_cv_train=train_input(trainset,:);%p_代表用来预测的
   t_cv_train=train_output(trainset,:);%t_代表用来验证网络的
   
   %验证部分的输入输出
   p_cv_test=train_input(testset,:);
   t_cv_test=train_output(testset,:);
   
   %矩阵转置
   p_cv_train=p_cv_train';
   t_cv_train=t_cv_train';
   p_cv_test=p_cv_test';
   t_cv_test=t_cv_test';
   
for j=14%通过循环，选择隐含层数目
   
    %指定模型结构
   hiddenLayerSize=j;%隐含层数目
   net=patternnet(hiddenLayerSize);%模型结构
   net.divideParam.trainRatio=70/100;%70%的数据用于模型训练
   net.divideParam.valRatio=15/100;%15%的数据用于模型验证
   net.divideParam.testRatio=15/100;%15%的模型用于模型测试
   
   [net,tr]=train(net,p_cv_train,t_cv_train);%训练模型
   %用训练好的模型进行预测测试部分数据
   outputs=net(p_cv_test);
   outputs=round(outputs);
%    outputs=net(p_cv_train);
%    outputs=round(outputs);
   errors=gsubtract(t_cv_test,outputs);
   rightnum=find(errors(1,:)==0);%正确分类数目
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
    if rightlen>right_num%根据正确分类数目，挑选最优模型
        right_num=rightlen;%更新最优分类数目
        desired_input=p_cv_train;%最优模型输入
        desired_output=t_cv_train;%最优模型输出
        bestnet=net;%最优模型
        besthide=j;%最优隐含层数目
        besterror=errors;%最小误差值
        k=i;
    end

end
end
 disp(['第',num2str(k),'次交叉验证效果最好'])%挑选出的最优模型，重新训练，图形化训练过程
 netfinal=patternnet(besthide);
 netfinal.divideParam.trainRatio=70/100;
 netfinal.divideParam.valRatio=15/100;
 netfinal.divideParam.testRatio=15/100;
   
 [net,tr]=train(netfinal,desired_input,desired_output);
 cmd=['save 预测\bestnet net'];
 eval(cmd);