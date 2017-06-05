import numpy as np
import scipy.stats
import pystan
import pickle
np.random.seed(1)

def gendata(ncl, nobj=10, mmin=0.1, mmax=5, alpha0=-3, salpha=0.2):
    #create data from different clusters with power-law distribution in each
    res = []
    ids = []
    for i in range(ncl):
        curnobj = scipy.stats.poisson(nobj).rvs()
        curalpha = alpha0 + np.random.normal() * salpha
        # every cluster has a random alpha 
        # every cluster has objects distributed  as 
        # M^(alpha) with mmin<M<mmax
        xs = (np.random.uniform(size=curnobj) * (mmax**(curalpha + 1) -
             mmin**(curalpha + 1)) +
          mmin**(curalpha + 1))**(1. / (curalpha + 1))
        res.append(xs)
        ids.append([i] * len(xs))
    ids = np.concatenate(ids).astype(int)+1
    res = np.concatenate(res)
    return ids, res
  
def genfiles():
    ncl = 1
    ids, res = gendata(ncl)
    data={'ids':ids, 'vals': res,'ncl':ncl, 'N':len(res)}
    pystan.stan_rdump(data,'distr1.data.R')
    with open('distr1.data.pickle','wb') as fd:
        pickle.dump(data,fd)
    ncl = 10
    ids, res = gendata(ncl)
    data={'ids':ids, 'vals': res,'ncl':ncl, 'N':len(res)}
    pystan.stan_rdump(data,'distr10.data.R')
    with open('distr10.data.pickle','wb') as fd:
        pickle.dump(data,fd)

    ncl = 500
    ids, res = gendata(ncl)
    data={'ids':ids, 'vals': res, 'ncl':ncl, 'N':len(res)}
    pystan.stan_rdump(data,'distr500.data.R')
    with open('distr500.data.pickle','wb') as fd:
        pickle.dump(data,fd)


if __name__ == '__main__':
    genfiles()