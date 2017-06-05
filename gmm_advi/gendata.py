import os
import numpy as np
import pystan
import pickle
import scipy
np.random.seed(1)

ndim = 2
def generate_distribution(N,ncl):
    cens = np.random.uniform(-10, 10, size=(ncl,ndim))
    sigs = np.random.uniform(0.5, 1, size=(ncl,ndim))
    fracs = np.random.dirichlet(np.zeros(ncl) + 10)
    ns = np.random.multinomial(N, fracs)
    xs= []
    for i in range(ncl):
        xs.append(np.random.normal(size=(ns[i],ndim))*sigs[i]+cens[i])
    return np.concatenate(xs)

def genfiles():
    N = 10000
    ncl = 3
    xs = generate_distribution(N, ncl)
    data = {'y': xs, 'N':N,'D':ndim,'K':ncl,'alpha0':10}
    pystan.stan_rdump(data, 'gmm.data.R')
    with open('gmm.data.pickle', 'wb') as fd:
        pickle.dump(data, fd)

if __name__ == '__main__':
    genfiles()