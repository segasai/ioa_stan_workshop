functions {
	// create a new function  for the PDF of the distribution that we are interested in 
	// In this case the distribution is the plummer distribution
	// 1/(1+(r/rhalf)^2)^2
	// The function returns log probability
	// All but first argument are the parameters of the pdf

	real plum2d_lpdf(vector xy, vector xy0, real rhalf , real ell, vector paV){
		real norm;
		real y1;
		real x1;
		real r;
		norm = 1. /(1 - ell) / rhalf^2 / pi();
		x1 = (xy[1] - xy0[1]) * paV[1] + (xy[2] - xy0[2]) * paV[2];
		y1 = (xy[2] - xy0[2]) * paV[1] - (xy[1] - xy0[1]) * paV[2];
		r = sqrt(x1^2 + y1^2 / (1-ell)^2);
		return log(norm) - 2 * log(1 + (r / rhalf)^2);
	}
}

data
{
	int N;
	vector[2] xy[N];
	matrix[2,2] covars[N];

}
parameters
{
	real<lower=0> rhalf;
	real<lower=0,upper=1> ell;
	vector[2] xy0;
	vector[2] xytrue[N];
	unit_vector[2] paV;
	// good way
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
		xy[i] ~ multi_normal(xytrue[i], covars[i]);
		xytrue[i] ~ plum2d(xy0, rhalf, ell, paV);
		// now we can use a newly created distribution here.
	}
}
