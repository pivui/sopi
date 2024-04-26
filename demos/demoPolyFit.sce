//
// Example of polynomial fit on data:
// 

// Noisy polynomial data
function [x,y] = sopi_noisyPolyData(n)
    //
    a   = [1.2, 3, -2, 0.1]
    nx  = 20
    x   = linspace(0,nx,nx)'
    y   = zeros(nx, n)
    // 
    for i = 1:n
        y(:,i) = a(1) + a(2)*x + a(3) * x.^2 + a(4) * x.^3 + 20*rand(nx,1, 'normal')
    end
endfunction

// Fitting problem
sopi_begin;
// 
a0 = sopi_var(1);
a1 = sopi_var(1);
a2 = sopi_var(1);
a3 = sopi_var(1);
//
ntest   = 10;
[x,y]   = sopi_noisyPolyData(ntest);
mismatch = [];
for i = 1:ntest
    mismatch = [mismatch;a0  + a1 * x + a2 * x.^2 + a3 * x.^3 - y(:,i)];
end
// Objective: minimize max. of absolute value of mismatch
fun             = norm(mismatch, %inf);
// Create problem 
problem             = sopi_min(fun,list());
[xopt, fopt, info]  = sopi_solve(problem, 'karmarkar');
// plot solution 
for i = 1:ntest
    plot(x, y(:,i),'k.');
end
a0f = xopt.a0;
a1f = xopt.a1;
a2f = xopt.a2;
a3f = xopt.a3;
plot(x, a0f + a1f * x + a2f*x.^2 + a3f * x.^3,'r');


