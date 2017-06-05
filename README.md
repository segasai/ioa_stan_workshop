# CmdStan

Download it here https://github.com/stan-dev/cmdstan/releases/download/v2.15.0/cmdstan-2.15.0.tar.gz
Build it by doing
```
make build
```


## Model compilation

Go to the directory with CmdStan
```
$ cd /home/skoposov/cmdstan-2.15.0
$ pwd
/home/skoposov/cmdstan-2.15.0
```

Compile the model by using make and giving a path to the stan file
Here we assume that you have written the model regression.stan file
```
$ make /home/skoposov/Dropbox/Stan_work/regression/regression

--- Translating Stan model to C++ code ---
bin/stanc  /home/skoposov/Dropbox/Stan_work/regression/regression1.stan
--o=/home/skoposov/Dropbox/Stan_work/regression/regression1.hpp
Model name=regression1_model
Input file=/home/skoposov/Dropbox/Stan_work/regression/regression1.stan
Output file=/home/skoposov/Dropbox/Stan_work/regression/regression1.hpp

--- Linking C++ model ---
g++ -I src -I stan_2.15.0/src -isystem stan_2.15.0/lib/stan_math_2.15.0/...
```
That will create a binary called regression

## Running a CmdStan model
The input data must be in R format. In all the examples it is already provided in .data.R files
The output data will be default in output.csv file

### Sampling

```
[skoposov@milkyway regression]$ ./regression  sample data file=regr.data.R
method = sample (Default)
 sample
...

Gradient evaluation took 0 seconds
1000 transitions using 10 leapfrog steps per transition would take 0 seconds.
Adjust your expectations accordingly!


Iteration:    1 / 2000 [  0%]  (Warmup)
...
Iteration: 2000 / 2000 [100%]  (Sampling)

Elapsed Time: 0.15 seconds (Warm-up)
              0.11 seconds (Sampling)
              0.26 seconds (Total)

```
### Optimizing
```
$ ./regression  optimize data file=regr.data.R
```
### Different parameters
$ ./regression  sample num_samples data file=regr.data.R output file=/tmp/zz.csv

This option lists all possible arguments: 

$ ./regression help-all 
  method=<list element>
    Analysis method (Note that method= is optional)
    Valid values: sample, optimize, variational, diagnose
    Defaults to sample
.... 


### Assessing convergence
Using stansummary
```
$ ~/cmdstan-2.15.0/bin/stansummary  /tmp/zz.csv
Inference for Stan model: regression_model
1 chains: each with iter=(1000); warmup=(0); thin=(1); 1000 iterations saved.

Warmup took (0.14) seconds, 0.14 seconds total
Sampling took (0.12) seconds, 0.12 seconds total

                Mean     MCSE   StdDev    5%   50%   95%  N_Eff  N_Eff/s    R_hat
lp__             -41  6.1e-02  1.2e+00   -44   -41   -40    422     3517  1.0e+00
accept_stat__   0.95  2.2e-03  7.1e-02  0.80  0.98   1.0   1000     8333  1.0e+00
stepsize__      0.31  1.6e-15  1.2e-15  0.31  0.31  0.31   0.50      4.2  1.0e+00
treedepth__      3.0  2.7e-02  7.8e-01   2.0   3.0   4.0    840     7003  1.0e+00
n_leapfrog__      11  1.5e-01  4.9e+00   3.0    11    15   1000     8333  1.0e+00
divergent__     0.00  0.0e+00  0.0e+00  0.00  0.00  0.00   1000     8333     -nan
energy__          43  9.4e-02  1.8e+00    40    42    46    347     2890  1.0e+00
alpha            5.2  7.5e-03  1.8e-01   5.0   5.2   5.5    583     4860  1.0e+00
beta            10.0  1.3e-03  3.1e-02   9.9  10.0    10    623     5194  1.0e+00
sigma           0.92  2.8e-03  6.5e-02  0.82  0.91   1.0    528     4402  1.0e+00

Samples were drawn using hmc with nuts.
For each parameter, N_Eff is a crude measure of effective sample size,
and R_hat is the potential scale reduction factor on split chains (at
convergence, R_hat=1).
```

# PyStan

If you have a model file .stan
This  will compile and create a model object
`
mod = pystan.StanModel('regression.stan')
`
## Input data
The data for each example is stored in a pickled file. You can load it in python
by
`
data = pickle.load(open('regression.data.pickle','rb'))
Now data is the dictionary with input data

## Fitting

`
res= mod.sampling(data=data)
res= mod.optimize(data=data)
`
