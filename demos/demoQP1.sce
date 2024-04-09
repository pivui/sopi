// Example of quadratic program
// 
// Example 16.2 from "Numerical Optimization" by J. Nocedal and S.J. Wright,
//
//  min 3*x1^2 + 2*x1*x2 + x1*x3 + 2.5*x2^2 + 2*x2*x3 + 2*x3^2 - 8*x1 - 3*x2 - 3*x3
// s.t. x1 + x3 = 3 and x2 + x3 = 0
//
// Solution is [2, -1, 1]'
//
sopi_begin;
x1 = sopi_var(1);
x2 = sopi_var(1);
x3 = sopi_var(1);
// Objective function
q   = 3 * x1^2 + 2 * x1 * x2 + x1 * x3 + 2.5 * x2^2 + 2*x2*x3 + 2 * x3^2 - 8*x1 - 3 * x2 - 3 * x3;
// Constraints 
c1 = x1 + x3 == 3;
c2 = x2 + x3 == 0;
// Problem formulation 
problem             = sopi_min(q, list(c1, c2));
[xopt, fopt, info]  = sopi_solve(problem);
