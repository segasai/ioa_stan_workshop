functions 
{
	// Define a power-law pdf x^a and bounded by two values	
	real powerlaw_lpdf(real x, real slope, real minv, real maxv){
		return  -log( ((maxv^(slope+1)-minv^(slope+1)) /(1+slope)) ) + slope* log(x);
	}
}

data { 
	int N ; //number of datapoints;
	int ncl ; // number of clusters
	int ids[N]; // ids of the cluster
	vector[N] vals; // actual measurements
}

parameters {
	real <upper=-1> slopes[ncl];
}

model {
	// The non-hierarchical version of the model 
	real minv = 0.1 ;
	real maxv = 5;		

	for (i in 1:N)
	{
		// we measure the slopes independently
		// without putting a common prior on them
		vals[i] ~ powerlaw(slopes[ids[i]], minv, maxv);
	}	
}
