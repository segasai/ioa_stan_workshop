import numpy as np
import pystan
import pickle
np.random.seed(1)

def sample_schechter(lmin, slope, cutoff, N):
    res = []
    curn = 0
    while curn<N:
        xgrid = (1-np.random.uniform(size=N))**(1./(slope+1))*lmin
        sub = np.random.uniform(size=N)<np.exp(-xgrid/cutoff)
        print (xgrid.min(),lmin,slope,1./(slope+1))
        res.append(xgrid[sub])
        curn+=sub.sum()
    return np.concatenate(res)[:N]
    
    
def gendata(N, Nz):
    zs = np.random.uniform(1,5,Nz)
    slopes = -2+0.2*zs
    cutoffs = 1e10*(1-0.1*zs)
    lmins = 10**np.random.uniform(8,9,size=Nz)
    res=[]
    ids=[]
    
    for i in range(Nz):
        res.append(sample_schechter(lmins[i], slopes[i], cutoffs[i], N))
        ids.append([i]*N)    
    return {'lum':np.r_[res], 'surveyid':np.r_[ids],'zs':zs}
    

def genfiles():
    Nz=10
    Nobj = 1000
    data= gendata(Nobj,Nz)
    pystan.stan_rdump(data,'schechter.data.R')
    with open('schechter.data.pickle','wb') as fd:
        pickle.dump(data,fd)
    
if __name__=='__main__':
    genfiles()