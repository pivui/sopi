//
sopi_begin;
x1 = sopi_var(1);
x2 = sopi_var(1);
f = 100.0 *(x2 - x1^2)^2 + (1 - x1)^2;

problem = sopi_min(f)
