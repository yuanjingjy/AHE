#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2017/12/19 16:21
# @Author  : YuanJing
# @File    : GAscores.py
'''
遗传算法的运行程序，用的是DEAP框架
individual大小：特征值个数
进化g=100代，运行iter=100次

'''

# 遗传算法
import random
from sklearn.neural_network import MLPClassifier
from deap import base
from deap import creator
from deap import tools
import numpy as np
global labelMat,dataMat
import  pandas as  pdInput
generation=30#代数
numofga=50#遗传算法运行次数
creator.create("FitnessMax", base.Fitness, weights=(1.0,))
creator.create("Individual", list, fitness=creator.FitnessMax)

toolbox = base.Toolbox()
toolbox.register("attr_bool", random.randint, 0, 1)
toolbox.register("individual", tools.initRepeat, creator.Individual,toolbox.attr_bool, 80)
toolbox.register("population", tools.initRepeat, list, toolbox.individual)


# the goal ('fitness') function to be maximized
######calculate the fitness value#######
def evalOneMax(individual):
    import global_new as gl
    dataset=gl.dataSet
    dataset=np.random.permutation(dataset)#打乱各行的顺序
    datain=dataset[:,0:80]#80个特征值
    label=dataset[:,80]#最后1列是标签

    #找到选择出的变量
    individual = np.array(individual)
    index = np.where(individual == 1)
    index=np.array(index)
    neronum = np.size(index)
    for i in index:
        datain = dataset[:, i]
    datain = np.array(datain)
   # label=dataset[:,78]

    train_in=datain[0:905,:]
    train_out=label[0:905]

    from imblearn.under_sampling import RandomUnderSampler
    train_in, train_out = RandomUnderSampler().fit_sample(train_in, train_out)

    test_in=datain[905:1293,:]
    test_out=label[905:1293]

    clf = MLPClassifier(hidden_layer_sizes=(neronum,), activation='tanh',
                        shuffle=True, solver='sgd', alpha=1e-6, batch_size=2,
                        learning_rate='adaptive')
    clf.fit(train_in, train_out)
    scores=clf.score(test_in,test_out)
    fitnessvalue = np.mean(scores)

    return (fitnessvalue,)
#######calculate the fitness value#########


# ----------

# Operator registration


toolbox.register("evaluate", evalOneMax)
toolbox.register("mate", tools.cxTwoPoint)
toolbox.register("mutate", tools.mutFlipBit, indpb=0.09)
toolbox.register("select", tools.selRoulette)


# ----------
def main():
    global  best_ind
    global meanfit
    random.seed(64)

    # create an initial population of 20 individuals (where
    pop = toolbox.population(n=20)

    # CXPB  is the probability with which two individuals are crossed
    # MUTPB is the probability for mutating an individual

    CXPB, MUTPB = 0.4, 0.3

    print("Start of evolution")

    # Evaluate the entire population

    fitnesses = list(map(toolbox.evaluate, pop))

    for ind, fit in zip(pop, fitnesses):
        ind.fitness.values = fit

    print("  Evaluated %i individuals" % len(pop))

    # Extracting all the fitnesses of

    fits = [ind.fitness.values[0] for ind in pop]

    # Variable keeping track of the number of generations

    g = 0

    # Begin the evolution
    meanfit=[]
    while g < generation:

        # A new generation

        g = g + 1

        print("-- Generation %i --" % g)

        # Select the next generation individuals

        offspring = toolbox.select(pop, len(pop))

        # Clone the selected individuals

        offspring = list(map(toolbox.clone, offspring))

        # Apply crossover and mutation on the offspring

        for child1, child2 in zip(offspring[::2], offspring[1::2]):

            # cross two individuals with probability CXPB

            if random.random() < CXPB:
                toolbox.mate(child1, child2)

                # fitness values of the children

                # must be recalculated later

                del child1.fitness.values

                del child2.fitness.values

        for mutant in offspring:

            # mutate an individual with probability MUTPB

            if random.random() < MUTPB:
                toolbox.mutate(mutant)

                del mutant.fitness.values

        # Evaluate the individuals with an invalid fitness

        invalid_ind = [ind for ind in offspring if not ind.fitness.valid]

        fitnesses = map(toolbox.evaluate, invalid_ind)

        for ind, fit in zip(invalid_ind, fitnesses):
            ind.fitness.values = fit

        print("  Evaluated %i individuals" % len(invalid_ind))

        # The population is entirely replaced by the offspring

        pop[:] = offspring

        # Gather all the fitnesses in one list and print the stats

        fits = [ind.fitness.values[0] for ind in pop]

        length = len(pop)

        mean = sum(fits) / length
        meanfit.append(mean)

        sum2 = sum(x * x for x in fits)

        std = abs(sum2 / length - mean ** 2) ** 0.5

        print("  Min %s" % min(fits))

        print("  Max %s" % max(fits))

        print("  Avg %s" % mean)

        print("  Std %s" % std)

    print("-- End of (successful) evolution --")

    best_ind = tools.selBest(pop, 1)[0]

    # print("Best individual is %s, %s" % (best_ind, best_ind.fitness.values))
    # import matplotlib.pyplot as plt
    #
    # fig, ax1 = plt.subplots()
    # line1 = ax1.plot(meanfit, "b-", label="Minimum Fitness")
    # ax1.set_xlabel("Generation")
    # ax1.set_ylabel("Fitness", color="b")
    # plt.show()


if __name__ == "__main__":
    best=[]
    fits=[]
    iter = 0
    while iter < numofga:
        iter = iter + 1
        main()
        best.append(best_ind)
    np.array(best)
    np.savetxt("F:/new2018.txt", best)


