// fitting a Gaussian Mixture model to the distribution of objects
// Written for the ADVI
data{
	int<lower=0> N;
	// number of datapoints in entire dataset
	int<lower=0> K;
	// number of mixture components
	int<lower=0> D;
	// dimension
	vector[D] y[N];
	// observations
	real<lower=0> alpha0; //dirichletprior
}
transformed data{
	vector<lower=0>[K] alpha0_vec;
	for(k in 1:K)
	{e
		alpha0_vec[k] = alpha0;
	}
}
parameters{
	simplex[K] theta;
	// mixing proportions
	vector[D] mu[K];
	// locations of mixture components
	vector<lower=0>[D] sigma[K];
	// standard deviations of mixture components
}
model{
	// priors
	theta ~ dirichlet(alpha0_vec);
	for(k in 1:K){
		mu[k] ~ normal(0.0, 100.0);
		//sigma[k] ~ uniform(0.2,3);
		sigma[k] ~ cauchy(0,2);
		////sigma[k] ~ lognormal(0.0, 1.0);
	}
	// likelihood
	for(n in 1:N)
	{
		real ps[K];
		for(k in 1:K)
		{
			ps[k] = log(theta[k]) + normal_lpdf(y[n] | mu[k], sigma[k]);
		}
	target += log_sum_exp(ps);
	// this is a more numerically stable way of writing log(exp(ps[1]) + exp(ps[2]) +.... 

	}
}
