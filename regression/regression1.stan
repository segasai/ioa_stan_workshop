data {
  int<lower=0> N;
  vector[N] y;
  vector[N] x;
  vector[N] err;

}

parameters {
  real alpha;
  real beta;
  real<lower=0> sigma;
}

model {
  // priors
  alpha ~ normal(0, 100);    
  beta ~ normal(0, 100);
  sigma ~ cauchy(0,5);

//  for (n in 1:N)
//    y[n] ~ normal(alpha + beta * x[n], sqrt(sigma^2+err[n]^2));

  // vectorized version
  y ~ normal(alpha + beta * x, sqrt(sigma^2+err .* err));
  // Notice the element-wise multiplication of two vectors

}
