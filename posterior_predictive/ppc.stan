data { 
    // number of input datapoints
    int N;
    // data
    vector[N] x;
}

parameters{ 

    // the mean of the Normal distribution
    real mu;
    // The standard deviation of the distribution
    real<lower=0> sigma;
}
model 
{
    // priors 
    mu ~ normal (0,10);
    sigma ~ cauchy(0,10);
    // the data is assumed to be uniformly distributed
    x ~ normal(mu, sigma);
}

generated quantities
{
    // at each iteration create a new sample from the model 
    // so we can conduct a posterior predictive check
    vector[N] rep_x;
    for(i in 1:N)
    { 
       rep_x[i] = normal_rng(mu, sigma);
       // since our model is just N(mu, sigma) we simulate from that
    }
}
