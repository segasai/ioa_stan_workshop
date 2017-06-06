// Fitting a 2d plummer model
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

	// position angle of the major axis
	real<lower=0, upper=pi()> pa; 
	// bad way because of discontinuity at edges
}
model
{
	real r;
	real norm;
	real x1; 
	real y1; 
	
	x0 ~ normal(0,1) ;
	y0 ~ normal(0,1) ;
	// prior on the center

	norm = 1. /(1 - ell) / rhalf^2 / pi();
	// normalization of the pdf 
	
	for ( i in 1:N)
	{
		x1 = (x[i]-x0) * cos(pa) + (y[i]-y0) * sin(pa);
		y1 = (y[i]-y0) * cos(pa) - (x[i]-x0) * sin(pa) ;
		r = sqrt(x1^2 + y1^2 / (1-ell)^2);
		target += log(norm) - 2 * log(1+(r/rhalf)^2);
		// add to log-posterior the log-likelihood of the current 
		// datapoint
	}
}
