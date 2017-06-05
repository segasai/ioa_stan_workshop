// Here we are trying to model the distribution of sources by 
// Plummer 1/(1+r^2)^2 model where the position of each stars
// is measured with the uncertainty


data
{
	// number of datapoints	
	int N;
	// x,y's of the data
	vector[2] xy[N];
	// array of covariance matrices 
	matrix[2, 2] covars[N];
}
parameters
{
	// size of the object 	
	real<lower=0> rhalf;
	// ellipticity
	real<lower=0, upper=1> ell;
	// x,y center 
	vector[2] xy0;
	// Now these are the true positions of each object/star
	vector[2] xytrue[N];
	// NOTE that the model will have large number of parameters! 
	// Positional Angle
	unit_vector[2] paV;
}
model
{
	real r;
	real norm;
	real x1;
	real y1;
	norm = 1. /(1 - ell) / rhalf^2 / pi();

	for ( i in 1:N)
	{
		xy[i] ~ multi_normal( xytrue[i], covars[i]);
		// each observed x,y is measured with a Gaussian uncertainty
	}
	
	for ( i in 1:N)
	{
		x1 = (xytrue[i][1] - xy0[1]) * paV[1] + (xytrue[i][2]-xy0[2]) * paV[2];
		y1 = (xytrue[i][2] - xy0[2]) * paV[1] - (xytrue[i][1]-xy0[1]) * paV[2] ;
		r = sqrt(x1^2 + y1^2 / (1 - ell)^2);
		target += log(norm) - 2 * log(1 + (r / rhalf)^2);
	}
}
