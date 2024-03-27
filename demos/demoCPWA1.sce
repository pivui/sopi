//
// Example of formulation and resolution of a convex linear piecewise affine problem
//
sopi_begin;
n           = 3;
W           = rand(n,n);
d           = rand(n,1);
xMin        = rand(n,1)
// Problem formulation 
x           = sopi_var(n);
LB          = x >= xMin;
fun         = norm(W*(x - d),1);
// Problem formulation
problem     = sopi_min(fun, list(LB));
// Problem resolution 
[xopt, fopt] = sopi_solve(problem,'sopilp');
[norm(W * (xopt.x - d),1), fopt]
