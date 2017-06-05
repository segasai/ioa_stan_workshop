functions 
{
	// Define a power-law pdf x^a and bounded by two values	
	real powerlaw_lpdf(real x, real slope, real minv, real maxv){
		return  slope* log(x) -log( ((maxv^(slope+1)-minv^(slope+1)) /(1+slope)) ) ;
		// the 
	}
}

data { 
	int N ; //number of datapoints;
	int ncl ; // number of clusters
	int ids[N]; // ids of the cluster
	vector[N] vals;
}

parameters {
	// power law slopes of individual objects
	real <upper=-1> slopes[ncl]; 
	// lower edges of the power-law
	real <lower=0, upper=min(vals)> minv;
	// upper edges of the power-law
	real <lower=max(vals), upper=100> maxv;

	// mean slope of the population
	real slope0;
	// sigma of the slopes across the population
	real <lower=0> slope_sig;
}

	
model {
		
	slope_sig ~ normal(0,0.5);
	// prior on the sigma of slopes
	
	for (i in 1:ncl)
	{
		slopes[i] ~ normal(slope0, slope_sig);
		// prior on slopes for each object
		// Note that each prior depends on the parameters of the model
	}

	for (i in 1:N)
	{
		vals[i] ~ powerlaw(slopes[ids[i]], minv, maxv);
	}	
}
