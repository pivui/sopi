
// sopi_lpSolve ................................................................
// is the main interface for accessing sopi solvers for linear problems.
// It is aimed at solving the following linear problems :
// min  c' x
//  x
// s.t. A x <= b
//      Aeq x = beq
//      lb <= x <= ub
function [xopt, fopt, flag, info] = sopi_solveLP(c, A, b, Aeq, beq, lb, ub, method)
   tic();
   timer();
   select method
   case "primal"
      // The general lp is converted to its standard form
      // T and d are the transformation matrices such that x_old = T*x_new + d
      [cs, As, bs, T, d]      = sopi_lpToStandardForm(c, A, b, Aeq, beq, lb, ub);
      [xf, ff, flag, info]    = sopi_primalSimplex(cs, As, bs);
      if flag >= 0 then
         xopt                 = T*xf + d;
         fopt                 = c'*xopt;
      else
         xopt                 = [];
         fopt                 = []; 
      end
//   case "dual"
//   case "ip"
//   case "auto"
   else
      error("Unknown LP solver.")
   end
   select flag
   case 1
      verboseFlag = ["sopiLP","The algorithm has converged.\n"];
   case 0
      verboseFlag = ["sopiLP","Maximum number of iterations reached.\n"];
   case -1
      verboseFlag = ["sopiLP","No feasible solution found.\n"];
   case -2
      verboseFlag = ["sopiLP","The problem is unbounded below.\n"];
   case -3
      verboseFlag = ["sopiLP","Failed to maintain feasibility.\n"];
   end   
   info.vFlag        = verboseFlag;
   info.elapsedTime  = toc();
   info.cpuTime      = timer();
endfunction


// ============================================================================
// SIMPLEX RELATED ROUTINES
// ============================================================================

// sopi_primalSimplex ..........................................................
// is a basic form of the two-phases primal simplex method.
function [xopt, fopt, flag, info] = sopi_primalSimplex(c, A, b)
   nvar = length(c);
   xopt = [];
   fopt = [];
   info = [];
   flag = [];
   // Phase 1 : searching for an initial feasible solution
   sopi_print(1,["sopiLP","Looking for an initial feasible solution (phase 1).\n"])
   [cp1, Ap1, x0p1, Bp1]   = sopi_standardFormToPhase1(c, A, b);
   [xoptp1,B,f]            = sopi_simplex(cp1, Ap1, b, x0p1, Bp1);
   if f == -3 then
      // failed to maintain feasibility
      flag = -3
      return;
   end
   // Analyse the output of phase 1
   if clean(cp1' * xoptp1) > 0 then // TODO : use a custom precision ?
      sopi_print(1,["sopiLP","No initial feasible solution found.\n"])
      // if the optimal cost is positive then the initial problem is infeasible
      flag = -1;
   else
      sopi_print(1,["sopiLP","Initial feasible solution found.\n"])
      sopi_print(1,["sopiLP","Looking for a optimal solution for the initial LP (phase 2).\n"])
      // Phase 2 : 
      if isempty(intersect(Bp1,B)) then
         cp2   = c;
         Ap2   = A;
         bp2   = b;
         x0p2  = xoptp1(1:nvar);
         Bp2   = B;
      else
         // TODO : this does not work
         error("slack variable of phase 1 are basics")
//         disp("slack variables are basic")
//         ne    = length(x0p1) - length(c);
//         nvar  = length(c)
//         cp2   = [c;zeros(ne,1)];
//         Ap2   = [A,speye(ne,ne);sparse([],[],[ne,nvar]),speye(ne,ne)];
//         bp2   = [b;zeros(ne,1)];
//         x0p2  = xoptp1;
//         Bp2   = B;
      end
      [xoptp2, B, flag, info]    = sopi_simplex(cp2, Ap2, bp2, x0p2, Bp2);
      //
      xopt                       = clean(xoptp2(1:length(c)));
      fopt                       = cp2'*xoptp2;
   end
endfunction

// sopi_simplex ................................................................
// is a basic implementation of the simplex method for lp.
function [xopt, B, flag, info] = sopi_simplex(c, A, b, x0, B)
   info = [];
   if norm(A*x0 - b) >= 1e-9 then
      error("[sopi][sopiLP] Provided initial value in not feasible");
   end
    x          = x0;
    N          = setdiff(1:size(x,1),B);
   //
   iter        = 0;
   endSimplex  = %f;
   while ~endSimplex
      iter  = iter + 1;
      // basic variables
      xb    = x(B);
      Ab    = A(:,B);
//      Lup   = umf_lufact(Ab);
      cb    = c(B);
      // non-basic variables
      xn    = x(N);
      An    = A(:,N);
      cn    = c(N);
      //
//      disp(sopi_isInv(Ab))
      if ~sopi_isInv(Ab) then
         xopt  = x;
         flag  = -3;
         break;
      end
      // dual variables
      // TODO : LU factorization of Ab + maintain it
//      lambda   = umf_lusolve(Lup,full(cb),"A''x=b");
      lambda = Ab'\cb;
      // reduced cost
      sn       = cn - An'*lambda;
      if and(sn >= 0) then 
         // no descent direction left, the basic feasible solution is optimal
         xopt        = x;
         flag        = 1;
         break;
      end
      [m, q]         = min(sn)
//      isDescentDir   = find( sn < 0 );    // choosing the descent directions
//      q              = min(isDescentDir); // smallest index yielding a decrease in the cost
      aq             = An(:,q);
//      d              = - umf_lusolve(Lup,aq);        // selected descent direction
      d              = -Ab\aq;
      if and(d >= 0) then // the problem is unbounded below
         xopt = [];
         flag = -2;
         break;
      end
      idDescent      = find(d < 0);
      stepCandidates = xb(idDescent) ./ -d(idDescent);
      [alpha,id]     = min(stepCandidates);
//      candidateID    = find(alpha == stepCandidates);
//      p              = min(idDescent(candidateID));
      p              = idDescent(id);
      // next iterate

      x(B)           = x(B) + alpha * d;
      x(N(q))        = alpha; 
      // q is the entering basic variable and p is the leaving variable
      entering       = N(q);
      leaving        = B(p);
      B(p)           = entering;
      N(q)           = leaving;
   end
   info.nIter = iter;
endfunction

// ============================================================================
// LP FORMS
// ============================================================================
// sopi_lpToStandardForm .......................................................
// converts a linear problem to its standard form :
// min_x c'*x s.t. Aeq*x = beq, x >= 0.
// TODO : need a better implementation for sparse matrices
function [cout, Aout, bout, T, d] = sopi_lpToStandardForm(c, A, b, Aeq, beq, lb, ub)
   sopi_print(1,["sopiLP","Transforming LP to standard form.\n"])
   nvar                    = length(c); // initial number of variables
   T                       = sparse([],[],[nvar,nvar]); // x_old = T*x_aug + d -> inverse transformation to true variable
   d                       = sparse([],[],[nvar,1]);   //
   // Bounds
   xAreLB                  = find(lb > -%inf);
   xAreUB                  = find(ub < %inf);
   [xAreLUB,ilb,iub]       = intersect(xAreLB,xAreUB);
   xAreLB(ilb)             = [];
   xAreUB(iub)             = [];
   // Variables which are only lower bounded :
   // x >= lb is shifted and replaced by y = x - lb >=0
   firstLoop = %t;
   for idx = xAreLB
      if firstLoop then
         sopi_print(2,["sopiLP","Lower bounded variables transformation.\n"])
         firstLoop = %f;
      end
      colA                = A(:,idx);
      b                   = b - colA*lb(idx);
      colAeq              = Aeq(:,idx);
      beq                 = beq - colAeq*lb(idx);
      //
      T(idx,idx)          = 1
      d(idx)              = lb(idx);
   end
   xArePositive = xAreLB;
   // Variables which are only upper bounded :
   // x <= ub is replaced by y = -x+ub >=0
   firstLoop = %t;
   for idx = xAreUB
      if firstLoop then
         sopi_print(2,["sopiLP","Upper bounded variables transformation.\n"])
         firstLoop = %f;
      end        
      colA                = A(:,idx);
      b                   = b - colA*ub(idx);
      A(:,idx)            = -colA;
      colAeq              = Aeq(:,idx);
      beq                 = beq - colAeq*ub(idx);
      Aeq(:,idx)          = -colAeq;
      c(idx)              = -c(idx);
      //
      T(idx,idx)          = -1
      d(idx)              = ub(idx);
   end
   xArePositive = [xArePositive,xAreUB];
   // Variables which are box bounded : the lb is transformed as above and the ub
   // is added as a linear inequality constraint
   firstLoop = %t;
   for  idx = xAreLUB
      if firstLoop then
         sopi_print(2,["sopiLP","Upper and lower bounded variables transformation.\n"])
         firstLoop = %f;
      end
      colA                = A(:,idx);
      b                   = b - colA*lb(idx);
      colAeq              = Aeq(:,idx);
      beq                 = beq - colAeq*lb(idx);
      //
      T(idx,idx)          = 1
      d(idx)              = lb(idx);
      // adding the lic
      A                 = [A;T(idx,:)];
      b                 = [b;ub(idx)-lb(idx)];
   end
   xArePositive = [xArePositive,xAreLUB];
   // Each bounded var has been treated, now the unrestricted var
   // if x is unrestricted, it is replaced by x = x+ - x-,  x+ >=0 and x->=0
   if length(xArePositive) < nvar then
      sopi_print(2,["sopiLP","Unrestricted variables transformation.\n"])
      tmp                 = (1:nvar);
      tmp(xArePositive)   = [];
      unrestrictedVar     = tmp;
      for idx = unrestrictedVar
         T(idx,idx)  = 1;
         c           = [c  ;   c(idx)      ;   -c(idx)];
         A           = [A  ,   A(:,idx)    ,   -A(:,idx)];
         Aeq         = [Aeq,   Aeq(:,idx)  ,   -Aeq(:,idx)];
         T           = [T  ,   T(:,idx)    ,   -T(:,idx)];
      end
      c(unrestrictedVar)        = [];
      A(:,unrestrictedVar)      = [];
      Aeq(:,unrestrictedVar)    = [];
      T(:,unrestrictedVar)      = [];
   end
   // Transformation of other linear inequalities
   // positive slack variables are added to the problem
   nvar            = length(c);
   ni              = size(A,1);
   slackSign       = zeros(ni,1);
   newAeqRows      = sparse([],[],[ni,nvar]);
   for i = 1:ni
      if b(i) >= 0 then
         // ai' x <= bi  with bi >= 0
         // becomes ai' x + z = bi
         newAeqRows(i,:) = A(i,:);
         slackSign(i)    = 1;
      else
         // ai' x <= bi with bi <= 0 
         // becomes -ai' x - z = -bi >= 0
         newAeqRows(i,:) = -A(i,:);
         b(i)            = -b(i);
         slackSign(i)    = -1;
      end
   end
   cout    = [c;sparse([],[],[ni,1])];
   Aout    = [Aeq      ,   sparse([],[],[size(Aeq,1),ni]);
            newAeqRows ,   diag(slackSign)   ];
   bout    = [beq;b];
   T       = [T,sparse([],[],[size(T,1),ni])];
endfunction


// sopi_standardFormToPhase1 ...................................................
function [cp1, Ap1, x0p1, Bp1] = sopi_standardFormToPhase1(c, A, b)
   ne                = size(A,1);
   nvar              = size(A,2);
   // adding slack variables z representing distance to infeasibility
   D                 = zeros(ne,1);
   D(b >= 0)         = 1;
   D(b < 0)          = -1;
   // Ax = b becomes Ax + D*z = b
   Ap1               = [A, sparse(diag(D))]
   // c'x becomes e'z (with e = 1)
   cp1               = zeros(size(Ap1,2),1)
   cp1(nvar+1:$)     = 1;
   // x = 0, z = abs(b) is a feasible initial point for this problem
   x0p1              = [zeros(nvar,1) ; abs(b)];
   // corresponding basis
   Bp1               = nvar + 1 : nvar + ne;
endfunction

function out = sopi_isInv(A)
//   if issparse(A) then
//      //
//      if  argn(2) < 2 then
//         c = condestsp(A,2);
//      else
//         c = condestsp(A,LUp);
//      end
//   else
      c = cond(full(A))
//   end
   if  c < 1/(%eps) then
      out = %t;
   else
      out = %f;
   end
endfunction
