##不太智能的地方：
#1.多次构建缺失数据集、进行插补、计算插补误差这一过程是手动进行的
#2.插补结果误差只比较rmse，没有用程序进行整合，是手动整理的
#*******************************************************************#


#读入数据
alldata <- read.csv("导出的特征值矩阵_只一次.csv")


#*********************************************#
                  #异常数据处理#
#1.体温：小于0的定义为异常数据
#2.身高：小于80和大于200的定义为异常数据
#3.体重：小于20和大于150kg的定义为异常数据
#4.年龄大于200的用年龄的中位数91.4插补，且只保留年龄16周岁以上的患者
#*********************************************#
alldata$min_tem[which(alldata$min_tem<0)] <- NA#最小体温有负值，置为缺失值
alldata$height[which(alldata$height<80)] <- NA
alldata$height[which(alldata$height>250)] <- NA#对于身高80以下，250以上认为是空值
alldata$weight_first[which(alldata$weight_first<20)]<-NA
alldata$weight_first[which(alldata$weight_first>150)]<-NA#体重小于20或大于150的置NA
alldata$weight_min[which(alldata$weight_min<20)]<-NA
alldata$weight_min[which(alldata$weight_min>150)]<-NA#体重小于20或大于150的置NA
alldata$weight_max[which(alldata$weight_max<20)]<-NA
alldata$weight_max[which(alldata$weight_max>150)]<-NA#体重小于20或大于150的置NA
alldata$age[which(alldata$age>200)] <- 91.4#年龄90以上的都置年龄的中位数91.4
#tmp <- alldata$age[which(alldata$age<16)]#只保留年龄16周岁以上的成人患者--程序没写明白，直接手动删了
summary(alldata)



#*********************************************#
#缺失情况说明#
#*********************************************#

#缺失情况说明
datawithmiss <- alldata[c("height","weight_first","weight_min","weight_max","min_tem","max_tem","mean_tem","max_gcs","min_gcs","mean_gcs")]
#cnames=paste(c("height","weight_first","weight_min","weight_max","min_tem","max_tem","max_gcs","min_gcs","mean_gcs"),sep="")
#colnames(datawithmiss)<-cnames#列名重命名
writefile <- cbind(alldata$classlabel,datawithmiss)
library(mice)
write.csv(writefile,"datawithmiss1.csv")  #该文件用来分组统计缺失数据

library("VIM")
aggr(datawithmiss,prop = FALSE, numbers = TRUE)
md.pattern(datawithmiss)#缺失数据模式

#*********************************************#

#1.首先从原始数据集中取出完整的案例
#2.保存actual为原始数据集actual，用于比较插值结果
#3.根据原始数据缺失比例，对完整数据集构建缺失案例（没有考虑有些变量一起缺失的情况）
#4.插值并比较结果
#*********************************************#

#**********开始构建完整数据集及缺失数据集************#
data_complete <- na.omit(alldata)
data_complete <- data_complete[,6:87]
actual <- data_complete
summary_actual <- summary(actual)
data_complete$min_tem[sample(nrow(data_complete), 138)] <- NA #min_tem随机缺失比例19.4%
data_complete$max_tem[sample(nrow(data_complete), 137)] <- NA #max_tem随机缺失比例19.3%
data_complete$mean_tem[sample(nrow(data_complete), 137)] <- NA #mean_tem随机缺失比例19.3%
data_complete$min_gcs[sample(nrow(data_complete), 144)] <- NA #min_gcs随机缺失比例20.3%
data_complete$max_gcs[sample(nrow(data_complete), 144)] <- NA #max_gcs随机缺失比例20.3%
data_complete$mean_gcs[sample(nrow(data_complete), 144)] <- NA #mean_gcs随机缺失比例20.3%
data_complete$height[sample(nrow(data_complete), 214)] <- NA #height随机缺失比例30%
data_complete$weight_first[sample(nrow(data_complete), 27)] <- NA #weight_first随机缺失比例3.7%
data_complete$weight_min[sample(nrow(data_complete), 23)] <- NA #weight_min随机缺失比例3.2%
data_complete$weight_max[sample(nrow(data_complete), 33)] <- NA #weight_max随机缺失比例4.6%



#**********导入所需包************#
library(DMwR)
library(Hmisc)
library(magrittr)
library(dplyr)

#**********依次用knn、中位数、平均值、众数对缺失数据进行插补************#
imp_knn <- knnImputation(data_complete, k = 10, scale = T, meth = "weighAvg", distData = NULL)#knn
imp_median <- centralImputation(data_complete)#非缺失样本的中位数插值
imp_mean<- (data_complete %>% mutate_all(impute,mean))#非缺失样本的mena插值
zhongshu <- function(x)
{
  tmp<-(as.numeric(names(table(x))[table(x)==max(table(x))]))
  return(mean(tmp))#多个数的频率是一样的
}
imp_zhongshu <- (data_complete %>% mutate_all(impute,zhongshu))#非缺失样本的众数插值

#**********计算插补后的误差************#
imp <- imp_zhongshu#这里不太智能，需要手动将imp_knn等这些插补结果赋值给imp再进行计算，手动记录误差结果
min_tem<-regr.eval(actual$min_tem, imp$min_tem)
max_tem<-regr.eval(actual$max_tem, imp$max_tem)
mean_tem<-regr.eval(actual$mean_tem, imp$mean_tem)
min_gcs<-regr.eval(actual$min_gcs, imp$min_gcs)
max_gcs<-regr.eval(actual$max_gcs, imp$max_gcs)
mean_gcs<-regr.eval(actual$mean_gcs, imp$mean_gcs)
height<-regr.eval(actual$height, imp$height)
weight_first<-regr.eval(actual$weight_first, imp$weight_first)
weight_min<-regr.eval(actual$weight_min, imp$weight_min)
weight_max<-regr.eval(actual$weight_max, imp$weight_max)
error<- cbind(min_tem,max_tem,mean_tem,min_gcs,max_gcs,mean_gcs,height,weight_first,weight_min,weight_max)


#**********用筛选出的插补方法对全部数据进行插补************#
imp_knn_final <- knnImputation(alldata[,6:87], k = 10, scale = T, meth = "weighAvg", distData = NULL)#knn
data_imp <- cbind(alldata$classlabel,imp_knn_final)
write.csv(data_imp,"data_complete.csv") 

data_imp$BMI <- data_imp$weight_first/(data_imp$height)^2*10000
final_eigen <- cbind(data_imp[,1:79],data_imp$BMI)
colnames(final_eigen)[1]<-"Label"
colnames(final_eigen)[ncol(final_eigen)]<-"BMI"
write.csv(final_eigen,"final_eigen.csv") 

