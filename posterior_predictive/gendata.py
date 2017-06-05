import numpy as np
import scipy.stats
import pystan
import pickle

np.random.seed(1)

def gendata1(N):
    #generate normally distributed dataset
    xs = np.random.normal(3,2,size=N)
    return xs

def gendata2(N):
    # This is the dataset from two Gaussians
    n1 = int(N*.9)
    n2 = N-n1
    xs1 = np.random.normal(3,2,size=n1)
    xs2 = np.random.normal(4,10,size=n2)
    return np.concatenate([xs1,xs2])
  
def genfiles():
    N=100
    xs = gendata1(N)
    data={'N':N,'x':xs}
    pystan.stan_rdump(data,'good.data.R')
    with open('good.data.pickle','wb') as fd:
        pickle.dump(data,fd)

    xs = gendata2(N)
    data={'N':N, 'x':xs}
    pystan.stan_rdump(data,'bad.data.R')
    with open('bad.data.pickle','wb') as fd:
        pickle.dump(data, fd)

if __name__ == '__main__':
    genfiles()

