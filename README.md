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
[xopt, fopt]    = sopi_solve(p,'sopilp');
```
