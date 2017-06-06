// Fitting the Plummer model 1/(1+(r/r0)^2)^2 to the distribution of sources

data
{
	// Number of datapoints	
	int N;
	// data x,y coordinates of objects
	real x[N];
	real y[N];

}
parameters
{
	// The model is the elliptical 1/(1+(r/rh)^2)^2 profile 

	// size 	
	real<lower=0> rhalf;
	// ellipticity
	real<lower=0,upper=1> ell;
	// center
	real x0;
	real y0;
	// positional angle  (in radians)
	real<lower=0, upper=3.1415> pa; 
	// bad way
}
model
{
	
	real r;
	real norm;
	real x1;
	real y1;
	norm = 1. /(1 - ell) / rhalf^2 / pi();
	// normalization of the PDF

	for ( i in 1:N)
	{
		x1 = (x[i]-x0) * cos(pa) + (y[i]-y0) * sin(pa);
		y1 = (y[i]-y0) * cos(pa) - (x[i]-x0) * sin(pa) ;
		r = sqrt(x1^2 + y1^2 / (1-ell)^2);
		// because the plummer profile in 2D doesn't have a PDF in Stan
		// We have to augment the log(probability) by hand
		target += log(norm) - 2 * log(1+(r/rhalf)^2);
	}
}
