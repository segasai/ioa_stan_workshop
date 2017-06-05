// Plummer 1/(1+r^2)^2 fit  where the positional 
// angle of major axis is parametrise as unit_vector
// rather than simply the angle
data
{
	// number of datapoints 
	int N;
	// x,y coordinates of objects
	real x[N];
	real y[N];
}
parameters
{
	// size of the object (half-radius)
	real<lower=0> rhalf;
	// ellipticity (1-b/a)
	real<lower=0,upper=1> ell;
	// center of the object
	real x0;
	real y0;

	unit_vector[2] paV;
	// better parametrisation of the angle
}
transformed parameters
{
	// we can precompute something heere 
	real norm;
	norm = 1. /(1 - ell) / rhalf^2 / pi();
	// normalization of the pdf 
}
model
{
	real r;
	real x1; 
	real y1; 

	x0 ~ normal(0,1) ;
	y0 ~ normal(0,1) ;
	// prior on the center

	for ( i in 1:N)
	{
		x1 = (x[i]-x0) * paV[1] + (y[i]-y0) * paV[2];
		y1 = (y[i]-y0) * paV[1] - (x[i]-x0) * paV[2] ;
		r = sqrt(x1^2 + y1^2 / (1-ell)^2);
		target += log(norm) - 2 * log(1+(r/rhalf)^2);
		// add to log-posterior the log-likelihood of the current 
		// datapoint

	}
}
