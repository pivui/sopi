// sopi_solve ..................................................................
// is the interface for solving problems
function  [xopt, fopt] = sopi_solve(pb, varargin)
    if argn(2) >1 then
        method = varargin(1);
    else
        method = [];
    end
    infoStr = 'Nature of the optimisation problem : '
    select pb.class
    case 'lp'
        sopi_print(0,infoStr + "linear.\n")
        [xopt, fopt, info]   = sopi_switchLPSolver(pb,method)
        fopt                 = fopt + pb.r
    else
        error("Unknown class")
    end
    //
    xopt = sopi_assignOutput(pb, xopt) 
endfunction

function xo = sopi_assignOutput(p, xopt, fopt)
    [vIds, vNames]  = sopi_whoIsSopiVar()
    xo              = struct()
    for i = 1:length(vIds)
        t =  vIds(i) == p.varsId
        if or(t) then
            idx             = find(t)
            xo(vNames(i))   =  xopt(p.varsIdx(idx))

        end
    end
endfunction

// sopi_chooseLPSolver .........................................................
function [xopt, fopt, info] = sopi_switchLPSolver(pb,method)
   xopt = [];
   fopt = [];
   // Available solvers
   KARMARKAR            = "karmarkar";
   LINPRO               = "linpro";
   SOPILP               = "sopiLP"
   // Default choice
   if isempty(method) then
      method = 'karmarkar';
   end
   sopi_print(0,"Solving problem with : " + method + ".\n")
   //
   select method
   case 'karmarkar' // built-in scilab solver
      tic()
      timer()
      [xopt, fopt, flag]   = karmarkar(full(pb.Ae),full(pb.be),full(pb.c),[],[],[],[],[],full(pb.A),full(pb.b),pb.lb,pb.ub)
      info.elapsedTime     = toc()
      info.cpuTime         = timer()
      flagMeaning          = ["1","The algorithm has converged.\n",
                              "0","Maximum number of iterations reached.\n",
                             "-1","No feasible point has been found.\n",
                             "-2","The problem is unbounded.\n"]
      info.vFlag           = ["karmarkar",sopi_interpretFlag(flag,flagMeaning)]
   case 'linpro' // from external module quapro
      sopi_testIfInstalled("linpro","To use the solver linpro, the quapro module must be installed. You can get it from the atoms portal.")
      tic()
      timer()
      lb                   = pb.lb
      ub                   = pb.ub
      lb(lb == -%inf)      = -number_properties('huge') // as advised in the help...
      ub(ub == %inf)       = number_properties('huge')
      try
         [xopt, lagr, fopt]   = linpro(full(pb.c), full([pb.Ae;pb.A]), full([pb.be;pb.b]), lb, ub, size(pb.Ae,1))
         info.vFlag           = ["linpro","The algorithm has converged.\n"]
         flag                 = 1
      catch
         flag                 = -1
         info.vFlag           = "linpro : " + lasterror()
      end
      info.elapsedTime     = toc()
      info.cpuTime         = timer()
   case 'sopilp' // sopi built-in
      [xopt, fopt, flag, info] = sopi_solveLP(pb.c, pb.A, pb.b, pb.Ae, pb.be, pb.lb, pb.ub, "primal")
   end
   // Display a warning if the algorithm has not really converged
   if flag == 1
      sopi_print(0,info.vFlag)
   else
      sopi_print(-1,info.vFlag)
   end
endfunction

// sopi_interpretFlag ..........................................................
function vFlag = sopi_interpretFlag(flag,flagMeaning)
   idx   = find(flag == flagMeaning(:,1));
   vFlag = flagMeaning(idx,2);
endfunction
