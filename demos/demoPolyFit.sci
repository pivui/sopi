//
// Example of polynomial fit on data:
// 
// True polynomial, supposed unknown
//

function [x,y] = sopi_demoData(n)
    //
    a   = [1.2, 3, -2, 0.1]
    nx  = 20
    x   = linspace(0,nx,nx)'
    y   = zeros(nx, n)
    // 
    for i = 1:n
        y(:,i) = a(1) + a(2)*x + a(3) * x.^2 + a(4) * x.^3 + 0.5*rand(nx,1)
    end
endfunction



sopi_begin;
// 
a0 = sopi_var(1);
a1 = sopi_var(1);
a2 = sopi_var(1);
//
ntest   = 10;
[x,y]   = sopi_demoData(ntest);
mismatch = []
for i = 1:ntest
    mismatch = [mismatch;a0  + a1 * x + a2 * x.^2 - y(:,i)];
end
// Objective: minimize max. of absolute value of mismatch
fun     = norm(mismatch, 'inf');
// Create problem 
problem = sopi_min(fun,list());
[xopt, fopt] = sopi_solve(problem);
// plot solution 
for i = 1:ntest
    plot(x, y(:,i),'k.');
end
a0 = xopt.a0;
a1 = xopt.a1;
a2 = xopt.a2;
plot(x, a0 + a1 * x + a2*x.^2,'r')

