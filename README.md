# sopi

*Scilab optimisation problem interpreter* is aimed at simplifying the process of writing and solving optimisation problems in Scilab.


## Examples

### LP 

```scilab 
sopi_begin;
// Declaration of optimisation variables 
x1          = sopi_var(1);                 
x2          = sopi_var(1);
x3          = sopi_var(1);
x4          = sopi_var(1);
// Objective function
fun         = x1  + 2*x2 + 3*x3 + 4*x4   
// Constraints
c1          = x1 + x2 + x3 + x4 == 1
c2          = x1 + x3 - 3*x4 == 1/2
c3          = x1 >= 0
c4          = x2 >= 0
c5          = x3 >= 0
c6          = x4 >= 0
// Problem formulation
p               = sopi_min(fun, list(c1, c2, c3, c4, c5, c6));
// Problem resolution
[xopt1, fopt1]    = sopi_solve(p,'sopilp');
[xopt2, fopt2]    = sopi_solve(p,'karmakar');
```

### LP-ish

```scilab
n           = 3;
W           = rand(n,n);
d           = rand(n,1);
xMax        = 5*rand(n,1);
A           = rand(2,n);
b           = 20*rand(2,1);
// Problem formulation                                
x           = sopi_var(n);                 
LB          = x >= 0;                      
ci          = A*x <= b;
ce          = x(2) == xMax(2);
fun         = norm(W*(x - d),1);             
problem     = sopi_min(fun,list(LB,ce,ci));
// Problem resolution 
[xopt, fopt] = sopi_solve(problem,'sopilp');
[norm(W * (xopt.x - d),1), fopt]
```
