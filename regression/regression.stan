data {
  int<lower=0> N;
  // number of datapoints
	
  vector[N] y;
  vector[N] x;
  //data 
  # Comments can use both # and // 
}

parameters {
  // intercept of the relation 
  real alpha;
  // slope of the relation
  real beta;
  // Scatter around the relation
  real<lower=0> sigma;
}

// this sections defines the log-posteror
model {

  // priors
  alpha ~ normal(0, 10);  
  beta ~ normal(0, 10);
  sigma ~ cauchy(0, 5);
  
  for (n in 1:N) // loop variables do not need declarations
  {
    y[n] ~ normal(alpha + beta * x[n], sigma);
    // the actual likelihood of the data
  }
}

