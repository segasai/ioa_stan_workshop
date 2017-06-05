import os
import numpy as np 
import pystan
import pickle

def generate_distribution(N, pa=1, ell=0.1, r0=2, seed=1):
    # generate the Plummer distribution with a given ellipticity
    # positional angle and scale radius
    np.random.seed(seed)
    ba = 1 - ell

    rand1=  np.random.uniform(size=N)
    r = (1 / (1 - rand1) - 1)**.5

    fi = np.random.uniform(0, 2 * np.pi, size=N)
    # random angle

    x = r0 * r * np.cos(fi)
    y = r0 * r * ba * np.sin(fi)

    # rotate by angle PA
    x1 = np.cos(pa) * x + np.sin(pa) * y
    y1 = np.cos(pa) * y - np.sin(pa) * x
    
    errx = 0.3 *r0 
    erry = 0.5 *r0 
    covars = np.array([np.array([[errx**2,0],[0,erry**2]])]*N)
    x2 = x1 + np.random.normal(size=N)*errx
    y2 = y1 + np.random.normal(size=N)*erry
    return x2, y2, covars


def genfiles():
    N=1000
    x,y,covars= generate_distribution(N,pa=40,ell=0.3,r0=2)
    xy = np.array([x,y]).T
    data={'xy':xy, 'N':N,'covars':covars}
    pystan.stan_rdump(data,'plum.data.R')
    with open('plum.data.pickle','wb') as fd:
        pickle.dump(data,fd)

if __name__ == '__main__':
    genfiles()