data{	
	int nnodes;
	vector[nnodes] xnodes;
	// location of the spline nodes/knots 
	// here we asssume that they are equidistant

	// actual data 
	int ndat;
	vector[ndat] x;
	vector[ndat] y;
	//uncertainties	
	vector[ndat] yerr;	

	int ids[ndat];	
	// ids showing which interval the points is lying within

	//evaluate the sampled splines on the grid
	int neval;
	vector[neval] xeval;
	int ideval[neval];

}
transformed data{
	//  see e.g. here for derivations 
	// http://www.maths.lth.se/na/courses/FMN081/FMN081-06/lecture11.pdf

	// create a matrix to compute the second derivatives at the nodes	
	// it is a tridiagonal matrix 

	matrix[nnodes-2, nnodes-2] mat;
	mat = rep_matrix(0, nnodes-2, nnodes-2);

	// create a 3-diagonal matrix for computing a,b,c,d coefficients 
	// of the spline

	for (i in 1:nnodes-2)
	{
		mat[i, i]=4;
	}
	for (i in 1:nnodes-3)
	{
		mat[i, i+1]=1;
		mat[i+1, i]=1;
	}
	mat = inverse(mat);	
}

parameters{
	vector[nnodes] vnodes;
}

transformed parameters{
	// Compute a, b, c, d coefficients in each spline interval

	vector[nnodes-1] as;
	vector[nnodes-1] bs;
	vector[nnodes-1] cs; 
	vector[nnodes-1] ds;

	vector[nnodes] sigmas;
	vector[nnodes-2] deltas;
	real h; // internode step 
	h = xnodes[2] - xnodes[1];
	for (i in 1:nnodes-2)
	{
		deltas[i] = vnodes[i+2] - 2 * vnodes[i+1] + vnodes[i];
	}
	sigmas[2:nnodes-1]= 6 / h^2 * mat * deltas;
	sigmas[1] = 0;
	sigmas[nnodes] = 0;
	ds = vnodes[:nnodes-1];
	cs = (vnodes[2:]-vnodes[:nnodes-1])/h-h/6*(2*sigmas[:nnodes-1]+sigmas[2:]);
	bs = sigmas[:nnodes-1]/2;
	as = (sigmas[2:] - sigmas[:nnodes-1])/6/h;
}

model{
	int curid;
	real curval;
	for (i in 1:ndat)
	{
		curid = ids[i];
		curval = as[curid] * (x[i] - xnodes[curid])^3 +
			bs[curid] * (x[i] - xnodes[curid])^2+
			cs[curid] * (x[i] - xnodes[curid])+
			ds[curid];
		// predicted value of the spline
		y[i] ~ normal(curval, yerr[i]);
		//normal error
					
	}	
}

generated quantities{
	// For assessing the fit we are saving at each sample the value of 
	// the spline 
	int curid;
	vector[neval] yeval; 
	// compute the value of the spline at given locations
	for (i in 1:neval)
	{
		curid = ideval[i];
		yeval[i] = as[curid] * (xeval[i] - xnodes[curid])^3 +
				bs[curid] * (xeval[i] - xnodes[curid])^2+
				cs[curid] * (xeval[i] - xnodes[curid])+
				ds[curid];
					
	}	
}

