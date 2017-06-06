// Fitting an exponential profile to the pixelized density
data
{
	int N;
	vector[N] x;
	vector[N] y;
	// x,y of the pixels 

	int hist[N];
	// number of objects in a given pixel


}
parameters
{
	// size of the system  	
	real<lower=0> rhalf;
	// ellipticity 1-b/a
	real<lower=0,upper=1> ell;
	// center
	real x0;
	real y0;
	// positional angle expressed as unit vector to avoid discontinuities
	unit_vector[2] paV;
	// density of background sources
	real<lower=0> bgdens;
	// density of foreground sources;
	real<lower=0> objdens;
	// good way
}
model
{
	real x1; 
	real y1; 
	vector[N] prof;

	ell ~ uniform(0, 0.5); 
	// prior 

	for ( i in 1:N)
	{
		x1 = (x[i]-x0) * paV[1] + (y[i]-y0) * paV[2];
		y1 = (y[i]-y0) * paV[1] - (x[i]-x0) * paV[2] ;
		prof[i] = objdens * exp( - sqrt(x1^2 + (y1/ (1-ell))^2)/rhalf) + bgdens; 
	}
	hist ~ poisson(prof);
}	
