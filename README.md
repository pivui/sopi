# sopi

*Scilab optimisation problem interpreter* is aimed at simplifying the process of writing and solving optimisation problems in Scilab.

## Getting started 

```scilab
sopi_begin // Initialise sopi
// Declare real optimisation variables (scalar)
x1 = sopi_var(1)
x2 = sopi_var(1)
// Define the objective function 
fun = x1^2 + x2^2
// and the constraints 
c1 = 2*x1 + 4*x2 >= 4
c2 = x1 >= 0
c3 = x2 >= 0
// Form the corresponding optimisation problem
problem = sopi_min(fun, list(c1, c2, c3))
// Solve it 
[xopt, fopt, info] = sopi_solve(problem)
disp(xopt) 
```

## Examples

Examples are gathered in the demos subfolder and are listed below by type of optimisation problem/applications. 

Linear problems:
- `demoLP1.sce`: academic LP
- `demopolyFit.sce`: fit a polynomial to a set of (noisy) data

Quadratic problems:
- `demoQP1.sce`: academic convex QP
- `demoLinearMPC1.sce`: linear predictive control on double integrator
