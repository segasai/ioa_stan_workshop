import os
import numpy as np
import pystan
import pickle
import scipy

np.random.seed(1)

def generate_distribution(N):
    ## Generate linear regression data
    xs = np.random.uniform(0,10,size=N)
    ys = xs*10 + 5 + np.random.normal(size=N)
    return xs,ys

def generate_distribution1(N):
    ## Linear regression with individual uncertainties
    xs = np.random.uniform(0,10,size=N)
    errs = np.random.uniform(0,1,size=N)
    ys = xs * 10 + 5 + np.random.normal(size=N)*errs
    return xs,ys,errs

def genfiles():
    N = 100
    x, y = generate_distribution(N)
    data = {'x': x, 'y': y, 'N':len(x)}
    pystan.stan_rdump(data, 'regr.data.R')
    with open('regr.data.pickle', 'wb') as fd:
        pickle.dump(data, fd)
    
    x, y, errs = generate_distribution1(N)
    data = {'x': x, 'y': y, 'N':len(x), 'err':errs}

    pystan.stan_rdump(data, 'regr1.data.R')
    with open('regr1.data.pickle', 'wb') as fd:
        pickle.dump(data, fd)
    
if __name__ == '__main__':
    genfiles()