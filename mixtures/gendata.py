import os
import numpy as np
import pystan
import pickle
import scipy

np.random.seed(1)

def generate_distribution(N, outlfrac = 0.2):
    xs = np.random.uniform(0,10,size=N)
    errs = 0.1 
    outl_err = 100
    outliers = np.random.uniform(size=N)<outlfrac;
    ys0 = xs*10 + 5;
    ys = ys0 + errs*np.random.normal(size=N)
    ys[outliers] = ys0[outliers] + outl_err * np.random.normal(size=outliers.sum())
    return xs,ys


def genfiles():
    N = 300
    x, y = generate_distribution(N)
    data = {'x': x, 'y': y, 'N':len(x)}
    pystan.stan_rdump(data, 'mixtures.data.R')
    with open('mixtures.data.pickle', 'wb') as fd:
        pickle.dump(data, fd)

if __name__ =='__main__':
    genfiles()

