import os
import numpy as np
import pystan
import pickle
import scipy

def generate_distribution(N, pa=1, ell=0.1, r0=2, seed=1, bgfrac=0.5, minx=-30, maxx=30,
                miny=-30, maxy=30):
    # generate the Plummer distribution with a given ellipticity
    # positional angle and scale radius
    np.random.seed(seed)
    ba = 1 - ell
    Nobj = scipy.stats.binom(N, 1 - bgfrac).rvs()
    Nbg = N - Nobj
    xbg = np.random.uniform(minx, maxx, size=Nbg)
    ybg = np.random.uniform(miny, maxy, size=Nbg)
    r = scipy.stats.gamma(2).rvs(size=Nobj)

    fi = np.random.uniform(0, 2 * np.pi, size=Nobj)
    # random angle

    x = r0 * r * np.cos(fi)
    y = r0 * r * ba * np.sin(fi)

    # rotate by angle PA
    x1 = np.cos(pa) * x + np.sin(pa) * y
    y1 = np.cos(pa) * y - np.sin(pa) * x
    xall, yall = [np.r_[x1, xbg], np.r_[y1, ybg]]
    nbins = 150
    hh, xedges, yedges = scipy.histogram2d(xall, yall, bins=[nbins, nbins])
    xcen = ((xedges[1:] + xedges[:-1]) * .5)
    ycen = ((yedges[1:] + yedges[:-1]) * .5)
    xcen2d = (xcen[:, None] + 0 * ycen[None, :])
    ycen2d = (ycen[None, :] + 0 * xcen[:, None])

    return hh, xcen2d, ycen2d


def genfiles():
    N = 100
    hh, x, y = generate_distribution(N, pa=40, ell=0.3, r0=2)
    data = {'x': x.flatten(), 'hist':hh.flatten().astype(int),
            'y':y.flatten(), 'N':hh.size}
    pystan.stan_rdump(data, 'plum.data.R')
    with open('plum.data.pickle', 'wb') as fd:
        pickle.dump(data, fd)
        
if __name__ == '__main__':
    genfiles()
