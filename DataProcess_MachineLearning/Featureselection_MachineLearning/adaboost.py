from numpy import *

'''
从txt中导入数据和标签，最后一列为标签
'''
def loadDataSet(fileName):    #general function to parse tab -delimited floats
    numFeat = len(open(fileName).readline().split('\t')) #get number of fields 
    dataMat = []; labelMat = []
    fr = open(fileName)
    for line in fr.readlines():
        lineArr =[]
        curLine = line.strip().split('\t')
        for i in range(numFeat-1):
            lineArr.append(float(curLine[i]))
        dataMat.append(lineArr)
        labelMat.append(float(curLine[-1]))
    return dataMat,labelMat

'''
Description:
    按照单一的特征进行分类
Input:
    dataMatrix:输入的特征值矩阵，多列的
    dimen:表示用哪一列特征进行分类
    threshVal:分类的阈值
    threshIneq:用小于号还是大于等于号进行分类
Output:
    retArray:分类的结果
'''
def stumpClassify(dataMatrix,dimen,threshVal,threshIneq):#just classify the data
    retArray = ones((shape(dataMatrix)[0],1))
    if threshIneq == 'lt':
        retArray[dataMatrix[:,dimen] <= threshVal] = -1.0
    else:
        retArray[dataMatrix[:,dimen] > threshVal] = -1.0
    return retArray
    
"""
Description:
    构建单层决策树
Input:
    dataArr：输入特征值矩阵
    classLabels：标签
    D：每个样本的权重
Output:
    bestStump：最优决策树包括：特征值、分类阈值、分类符号
    minError：最优决策树对应的分类误差
    bestClasEst：最优决策树对应的分类结果
"""
def buildStump(dataArr,classLabels,D):
    dataMatrix = mat(dataArr); labelMat = mat(classLabels).T
    m,n = shape(dataMatrix)
    numSteps = 10.0 #按照特征的取值范围，取10个阈值进行分类
    bestStump = {}#最优决策树
    bestClasEst = mat(zeros((m,1)))#最优分类结果
    minError = inf #init error sum, to +infinity
    for i in range(n):#loop over all dimensions，每一个特征值
        rangeMin = dataMatrix[:,i].min(); rangeMax = dataMatrix[:,i].max();
        stepSize = (rangeMax-rangeMin)/numSteps#阈值的取值步长
        for j in range(-1,int(numSteps)+1):#loop over all range in current dimension，所有可能的阈值
            for inequal in ['lt', 'gt']: #go over less than and greater than，可能的分类符号
                threshVal = (rangeMin + float(j) * stepSize)#当前用于分类的阈值
                predictedVals = stumpClassify(dataMatrix,i,threshVal,inequal)#call stump classify with i, j, lessThan，分类结果
                errArr = mat(ones((m,1)))#错误率初始化为全1
                errArr[predictedVals == labelMat] = 0#分类正确的错误率置0
                weightedError = D.T*errArr  #calc total error multiplied by D，错误率乘以各个样本的权重
                #print "split: dim %d, thresh %.2f, thresh ineqal: %s, the weighted error is %.3f" % (i, threshVal, inequal, weightedError)
                if weightedError < minError:#比较选择最小误差对应的决策树
                    minError = weightedError#最优决策树对应的权重误差
                    bestClasEst = predictedVals.copy()#最有决策树对应的各个样本的预测结果
                    bestStump['dim'] = i#最优决策树对应的分类特征值
                    bestStump['thresh'] = threshVal#最优决策树对应的特征值的分类阈值
                    bestStump['ineq'] = inequal#最优决策树对应的分类符号
    return bestStump,minError,bestClasEst

"""
Description:
    1.AdaBoost算法训练，刚开始时初始化每个样本的权重D为相等的（样本数目分之一）
    2.调用buildStump函数寻找出当前D值下的最优单程决策树，即一个弱分类器
    3.计算该弱分类器在强分类器中的权重a
    4.根据弱分类器的分类误差调整各个样本的权重D
    5.当前弱分类器叠加到强分类器中，计算当前分类结果
    6.如果误差满足要求或达到预设迭代次数，停止训练
Input:
    dataArr：特征值矩阵
    classLabels：标签
    numIt=40：迭代次数，即弱分类器的个数，默认40个
Output:
    weakClassArr：输出的弱分类器，每个弱分类器对应有：所用的特征值、分类阈值、分类符号、弱分类器的权重
    aggClassEst：分类的结果,概率值
"""

def adaBoostTrainDS(dataArr,classLabels,numIt=40):
    weakClassArr = []
    m = shape(dataArr)[0]#样本数目
    D = mat(ones((m,1))/m)   #init D to all equal，样本权重初始化为样本个数分之一
    aggClassEst = mat(zeros((m,1)))#分类结果初始化为全1
    for i in range(numIt):
        bestStump,error,classEst = buildStump(dataArr,classLabels,D)#build Stump，寻找最优的分类决策树
        #print （"D:",D.T）
        alpha = float(0.5*log((1.0-error)/max(error,1e-16)))#该弱分类器在最终的强分类器中所占的比例
        # print("alpha:",alpha)#calc alpha, throw in max(error,eps) to account for error=0
        bestStump['alpha'] = alpha  #存储当前最优分类器对应的权重
        weakClassArr.append(bestStump)                  #store Stump Params in Array
        #print "classEst: ",classEst.T
        expon = multiply(-1*alpha*mat(classLabels).T,classEst) #exponent for D calc, getting messy
        D = multiply(D,exp(expon))                              #Calc New D for next iteration
        D = D/D.sum()#更新各个样本的权重
        #calc training error of all classifiers, if this is 0 quit for loop early (use break)
        aggClassEst += alpha*classEst#叠加到当前的分类结果
        # print ("aggClassEst: ",aggClassEst.T)
        aggErrors = multiply(sign(aggClassEst) != mat(classLabels).T,ones((m,1)))#判断是否错误分类
        errorRate = aggErrors.sum()/m#分类错误率
        # print ("total error: ",errorRate)
        if errorRate == 0.0: break#如果分类错误率为0，停止训练
    return weakClassArr,aggClassEst

"""
Description:
    应用训练好的弱分类器进行分类
Input:
    datToClass：需要进行分类的数据，测试集数据
    classifierArr：弱分类器集合
Output:
    sign(aggClassEst)：分类的结果，标签
    aggClassEst：分类的结果，概率值
"""
def adaClassify(datToClass,classifierArr):
    dataMatrix = mat(datToClass)#do stuff similar to last aggClassEst in adaBoostTrainDS
    m = shape(dataMatrix)[0]
    aggClassEst = mat(zeros((m,1)))
    for i in range(len(classifierArr)):
        classEst = stumpClassify(dataMatrix,classifierArr[i]['dim'],\
                                 classifierArr[i]['thresh'],\
                                 classifierArr[i]['ineq'])#call stump classify
        aggClassEst += classifierArr[i]['alpha']*classEst
        #print (aggClassEst)
    return sign(aggClassEst),aggClassEst

"""
Description:
    绘制ROC曲线并求曲线下面积
Input：
    predStrengths：预测值，概率
    classLabels：实际标签
Output:
    ySum*xStep：曲线下面积
"""
def plotROC(predStrengths, classLabels):
    import matplotlib.pyplot as plt
    cur = (1.0,1.0) #cursor
    ySum = 0.0 #variable to calculate AUC
    numPosClas = sum(array(classLabels)==1.0)
    yStep = 1/float(numPosClas); xStep = 1/float(len(classLabels)-numPosClas)
    sortedIndicies = predStrengths.argsort()#get sorted index, it's reverse
    fig = plt.figure()
    fig.clf()
    ax = plt.subplot(111)
    #loop through all the values, drawing a line segment at each point
    for index in sortedIndicies.tolist()[0]:
        if classLabels[index] == 1.0:
            delX = 0; delY = yStep;
        else:
            delX = xStep; delY = 0;
            ySum += cur[1]
        #draw line from cur to (cur[0]-delX,cur[1]-delY)
        ax.plot([cur[0],cur[0]-delX],[cur[1],cur[1]-delY], c='b')
        cur = (cur[0]-delX,cur[1]-delY)
    ax.plot([0,1],[0,1],'b--')
    plt.xlabel('False positive rate'); plt.ylabel('True positive rate')
    plt.title('ROC curve for AdaBoost AHE detection system')
    ax.axis([0,1,0,1])
    plt.show()
    print ("the Area Under the Curve is: ",ySum*xStep)
    return ySum*xStep

"""
Description:
    分类模型评价指标
Input:
    y_true:实际标签
    y_predict:预测结果
    proba:预测概率值
Output:
     [[TPR,SPC,PPV,NPV,ACC,AUC,BER]]:各评价指标
     [[tn,fp,fn,tp]]:混淆矩阵
"""
def evaluatemodel(y_true,y_predict,proba):
    from sklearn.metrics import confusion_matrix
    from sklearn.metrics import roc_auc_score
    tn, fp, fn, tp =confusion_matrix(y_true,y_predict).ravel();
    TPR=tp/(tp+fn);
    SPC=tn/(tn+fp);
    PPV=tp/(tp+fp);
    NPV=tn/(tn+fn);
    ACC=(tp+tn)/(tn+fp+fn+tp);
    AUC = roc_auc_score(y_true, proba)
    #    Precision=precision_score(y_true,y_predict)
    #    Recall=recall_score(y_true,y_predict)
    BER = 0.5 * ((1 - TPR) + (1 - SPC))
    return [[TPR,SPC,PPV,NPV,ACC,AUC,BER]], [[tn,fp,fn,tp]]


