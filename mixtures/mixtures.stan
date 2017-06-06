// fitting linear regression with outliers
// the outliers are modeled as another distribution
data {
  // number of data points
  int<lower=0> N;
  // data 
  vector[N] y;
  vector[N] x;
}

parameters {
  // intercept of the linear relation
  real alpha;
  // slope of the line
  real beta;
  // spread of around the relation
  real<lower=0> sigma;


  // spread among the outliers
  real<lower=0> sigma_outl;
  // fraction of objects that are NOT outliers
  real<lower=0,upper=1> objfrac;
}
model {
  
  vector[2] temp;
  real x1;
  // Priors on the parametes

  alpha ~ normal(0,10);    
  beta ~ normal(0,10);

  sigma ~ cauchy(0,5);
  sigma_outl ~ cauchy(0,500);

  objfrac ~ beta(1, 1);
	
  for (i in 1:N)
  {
    	// Our log likelihood is 
	// log(objfrac N(y|ax+b,sigma) + (1-objfrac) *
        //             N(y|ax+b,sigma_outl)

	x1 = alpha + beta * x[i];
        temp[1] = log(objfrac) + normal_lpdf(y[i]| x1, sigma);
    	temp[2] = log(1 - objfrac) + normal_lpdf(y[i]| x1, sigma_outl);
	target += log_sum_exp(temp);
	// this is equivalent to log(exp(temp[1]) + exp(temp[2]))
  }
}
