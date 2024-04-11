//
// Example of linear MPC
// 
sopi_begin();

// Double integrator state-space model
A       = [1, 1;0, 1];
B       = [0;1];
C       = [1,0];
umax    = 1;
// Declare optimisation variables
n       = 2;    // number of state
N       = 20;   // prediction/control horizon
u       = list(); // optimisation variables are stored in lists
x       = list();
y       = list();
for i = 1:N
    x(i) = sopi_var(n);
    u(i) = sopi_var(1);
    y(i) = sopi_var(1);
end
x($+1) = sopi_var(n); 
// Create optimisation problem
cst         = list();
alpha       = 0.1;          // weight on control activity
cost        = 0;            // cost function
for i = 1:N
    cst($+1)    = x(i+1) == A * x(i) + B * u(i);// note the == in the dynamic/output
    cst($+1)    = y(i) == C*x(i);               // those are constraints
    cst($+1)    = abs(u(i))<= umax;
    cost        = cost + y(i)^2 + alpha * u(i)^2;
end 
problem = sopi_min(cost, cst);

// Actually solve the optimisation problem
// -> this should be done multiple times
x0  = [10;0];   // initial state
P1  = sopi_setVariableValue(problem, x(1), x0); // Set initial state without building everything again
[xopt, fopt, info]  = sopi_solve(P1);
uopt                = xopt.u;
// Simulation 
ys          = zeros(N,1);
xs          = zeros(n,N);
xs(:,1)     = x0;
for i =1:N
    xs(:,i+1)   = A * xs(:,i) + B * uopt(i);
    ys(i)       = C * xs(:,i);
    //
    uvec(i)     = uopt(i); // for display
end
figure;
subplot(211);
plot(1:N+1, xs(1,:), 'b', 1:N+1,xs(2,:),'c');
xlabel('time');
ylabel('states');
subplot(212);
plot(1:N,uvec,'r');
xlabel('time');
ylabel('control input u');
