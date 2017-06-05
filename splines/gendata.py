import os
import numpy as np
import pystan
import pickle
import scipy

def generate_distribution(N,minx,maxx):
    xs=np.random.uniform(minx,maxx,size=N)
    Func = lambda x: 10+0.1*x**2+np.sin(x*3.)
    ys= Func(xs)
    err1,err2=0.1,1
    errs = np.random.uniform(err1,err2,size=N)
    ys1 = ys + np.random.normal(0,errs)
    return xs,ys1,errs

def genfiles():
    N = 100
    minx,maxx=0,10
    x, y, err = generate_distribution(N,minx,maxx)
    nnodes=20
    xnodes=np.linspace(minx,maxx,nnodes,True)
    ids = np.digitize(x,xnodes)
    neval =400  
    xeval = np.linspace(minx+1e-5,maxx-1e-5,neval,True)
    ideval = np.digitize(xeval,xnodes)
    data = {'x': x, 'y': y,'yerr':err,'xnodes':xnodes,
            'nnodes':nnodes,'ids':ids,
        'xeval':xeval, 'neval':neval, 'ideval':ideval,'ndat':N}
    pystan.stan_rdump(data, 'spl.data.R')
    with open('spl.data.pickle', 'wb') as fd:
        pickle.dump(data, fd)

if __name__ == '__main__':
    genfiles()