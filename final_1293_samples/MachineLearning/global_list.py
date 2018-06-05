import pandas as pd
import  numpy as np
import  ann
global dataMat
global labelMat


###read the data###
pandas_data = pd.read_csv('eigen62.csv')
data = pandas_data.fillna(np.mean(pandas_data))

data['age'][data['age'] > 200] = 91.4
#data2 = data.drop(['hr_cov', 'bpsys_cov', 'bpdia_cov', 'bpmean_cov', 'pulse_cov', 'resp_cov', 'spo2_cov','height'], axis=1)
data2=data
dataSet=np.array(data2)
dataSet[:,0:62]=ann.preprocess(dataSet[:,0:62])
dataSet[:,0:62]=ann.preprocess1(dataSet[:,0:62])
# dataSet=np.array(dataSet)
# print("test"）

