import numpy as np, pickle
import pystan
np.random.seed(1)
def gendata(N):
    M0= -5 
    sm = 0.2
    err1=0.01
    err2=0.1
    eplx1,eplx2 = 1e-2,2e-2

    eplx = np.random.uniform(eplx1, eplx2, size=N)

    errs = np.random.uniform(err1, err2, size=N)
    ## photometric errors

    exp_scale = 1000 # in pc

    abs_mags = M0+sm*np.random.normal(size=N)
    
    dists = np.random.exponential(size=N)*exp_scale
    dist_mod = 5*np.log10(dists)-5
    vis_mag0 = dist_mod + abs_mags
    vis_mag = np.random.normal(size=N)*errs+ vis_mag0
    plx0 = 1./dists
    plx = plx0+ np.random.normal(size=N)*eplx    
    
    return {'plx':plx,'eplx':eplx, 'vis_mag':vis_mag,'vis_mag_err':errs}

def genfiles():
    N=10
    data= gendata(10000)
    pystan.stan_rdump(data,'gaia.data.R')
    with open('gaia.data.pickle','wb') as fd:
        pickle.dump(data,fd)
    
if __name__=='__main__':
    genfiles()