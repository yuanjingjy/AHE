'''
Created on Oct 27, 2010
Logistic Regression Working Module
@author: Peter
'''

from numpy import *
'''
Description:
    加载数据
Output:
    datamat:特征值矩阵
    labelmat:标签
'''
def loadDataSet():
    dataMat = []; labelMat = []
    fr = open('testSet.txt')
    for line in fr.readlines():
        lineArr = line.strip().split()
        dataMat.append([1.0, float(lineArr[0]), float(lineArr[1])])
        labelMat.append(int(lineArr[2]))
    return dataMat,labelMat

'''
Description:
    S 函数
Input:
    inX：输入数据
Output:
    S函数变换后的结果
'''
def sigmoid(inX):
    return 1.0/(1+exp(-inX))

'''
Description:
    梯度上升算法
Input:
    dataMatIn：输入的特征值矩阵
    classLabels：类别标签
Output:
    weights：梯度上升算法训练后返回的权重向量
'''
def gradAscent(dataMatIn, classLabels):
    dataMatrix = mat(dataMatIn)             #convert to NumPy matrix
    labelMat = mat(classLabels).transpose() #convert to NumPy matrix
    m,n = shape(dataMatrix)
    alpha = 0.001
    maxCycles = 500#最大迭代次数
    weights = ones((n,1))#出事权重
    for k in range(maxCycles):              #heavy on matrix operations
        h = sigmoid(dataMatrix*weights)     #matrix mult，特征值乘以权重经过S函数变换后的结果
        error = (labelMat - h)              #vector subtraction，错误率
        weights = weights + alpha * dataMatrix.transpose()* error #matrix mult，权重更新
    return weights

'''
Description:
    根据权重，绘制分类结果
Input:
    weights：梯度上升算法训练后返回的权重向量
Output:
    在图中画出两类样本及分类直线
'''
def plotBestFit(weights):
    import matplotlib.pyplot as plt
    dataMat,labelMat=loadDataSet()#加载数据
    dataArr = array(dataMat)
    n = shape(dataArr)[0] #样本数目
    xcord1 = []; ycord1 = []
    xcord2 = []; ycord2 = []
    for i in range(n):
        if int(labelMat[i])== 1:
            xcord1.append(dataArr[i,1]); ycord1.append(dataArr[i,2])#第一类样本坐标
        else:
            xcord2.append(dataArr[i,1]); ycord2.append(dataArr[i,2])#第二类样本坐标
    fig = plt.figure()
    ax = fig.add_subplot(111)
    ax.scatter(xcord1, ycord1, s=30, c='red', marker='s')
    ax.scatter(xcord2, ycord2, s=30, c='green')
    x = arange(-3.0, 3.0, 0.1)
    y = (-weights[0]-weights[1]*x)/weights[2]#分类的直线
    ax.plot(x, y)
    plt.xlabel('X1'); plt.ylabel('X2');
    plt.show()

'''
Description:
    随机梯度上升算法，相比于本文件里上面的梯度上升算法，此处的算法每次只用
    一个样本来更新权重，上面的那个每次都用全部样本更新权重，更新速度慢
Input:
    dataMatrix:特征值矩阵
    classLabels:标签
Output:
    weights：随机梯度上升算法训练后返回的权重向量
'''
def stocGradAscent0(dataMatrix, classLabels):
    m,n = shape(dataMatrix)
    alpha = 0.01
    weights = ones(n)   #initialize to all ones
    for i in range(m):#样本数目
        h = sigmoid(sum(dataMatrix[i]*weights))
        error = classLabels[i] - h
        weights = weights + alpha * error * dataMatrix[i]#调整误差
    return weights

'''
Description:
    改进的随机梯度上升算法，相比于本文件里上面的随机梯度上升算法，此处的算法每次随机选择
    一个样本来更新权重，已选中的删除，下次不再选择，并且更新权重时增加了一个权值
Input:
    dataMatrix:特征值矩阵
    classLabels:标签
Output:
    weights：改进随机梯度上升算法训练后返回的权重向量
'''
def stocGradAscent1(dataMatrix, classLabels, numIter=150):
    m,n = shape(dataMatrix)
    weights = ones(n)   #initialize to all ones
    for j in range(numIter):
        dataIndex = list(range(m))
        for i in range(m):
            alpha = 4/(1.0+j+i)+0.0001    #apha decreases with iteration, does not 
            randIndex = int(random.uniform(0,len(dataIndex)))#go to 0 because of the constant
            h = sigmoid(sum(dataMatrix[randIndex]*weights))
            error = classLabels[randIndex] - h
            weights = weights + alpha * error * dataMatrix[randIndex]
            del(dataIndex[randIndex])
    return weights

'''
Description:
    根据随机梯度上升算法训练得到的权值进行分类
Input:
    inX:待分类特征值矩阵
    weights：改进随机梯度上升算法训练后返回的权重向量
Output:
    分类标签
'''
def classifyVector(inX, weights):
    prob = sigmoid(sum(inX*weights))
    if prob > 0.5: return 1.0
    else: return 0.0

'''
Description:
    根据随机梯度上升算法训练得到的权值进行分类
Input:
    inX:待分类特征值矩阵
    weights：改进随机梯度上升算法训练后返回的权重向量
Output:
    分类概率值
'''
def classifyProb(inX, weights):
    prob = sigmoid(sum(inX*weights))
    return prob

'''
Description:
    逻辑回归的应用示例
'''
def colicTest():
    frTrain = open('horseColicTraining.txt'); frTest = open('horseColicTest.txt')
    trainingSet = []; trainingLabels = []
    for line in frTrain.readlines():
        currLine = line.strip().split('\t')
        lineArr =[]
        for i in range(21):
            lineArr.append(float(currLine[i]))
        trainingSet.append(lineArr)
        trainingLabels.append(float(currLine[21]))
    trainWeights = stocGradAscent1(array(trainingSet), trainingLabels, 1000)
    errorCount = 0; numTestVec = 0.0
    for line in frTest.readlines():
        numTestVec += 1.0
        currLine = line.strip().split('\t')
        lineArr =[]
        for i in range(21):
            lineArr.append(float(currLine[i]))
        if int(classifyVector(array(lineArr), trainWeights))!= int(currLine[21]):
            errorCount += 1
    errorRate = (float(errorCount)/numTestVec)
    print("the error rate of this test is: %f" % errorRate)
    return errorRate

'''
Description:
    累计误差
'''
def multiTest():
    numTests = 10; errorSum=0.0
    for k in range(numTests):
        errorSum += colicTest()
    print ("after %d iterations the average error rate is: %f" % (numTests, errorSum/float(numTests)))
        