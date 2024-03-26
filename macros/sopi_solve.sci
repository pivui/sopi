// sopi_solve ..................................................................
// is the interface for solving problems
function  [xopt, fopt] = sopi_solve(pb, varargin)
    if argn(2) >1 then
        method = varargin(1)
    else
        method = []
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
   xopt = []
   fopt = []
   // Available solvers
   KARMARKAR            = "karmarkar"
   LINPRO               = "linpro"
   SOPILP               = "sopiLP"
   // Default choice
   if isempty(method) then
      method = 'karmarkar'
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
      flags                 = [1, 0, -1, -2, -3, -4]
      flagMeaning          = ["The algorithm has converged.\n",
                              "Maximum number of iterations reached.\n",
                             "No feasible point has been found.\n",
                             "The problem is unbounded.\n",
                             "Search direction became 0.\n",
                             "Algorithm stopped on user request.\n"]
      info.vFlag           = ["karmarkar",sopi_interpretFlag(flag, flags, flagMeaning)]
      if flag == 1 then 
          flag = 0
      end
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
   if flag == 0
      sopi_print(0,info.vFlag)
   else
      sopi_print(-1,info.vFlag)
   end
endfunction

// sopi_interpretFlag ..........................................................
function vFlag = sopi_interpretFlag(flag, flags,flagMeaning)
   idx   = find(flag == flags)
   vFlag = flagMeaning(idx)
endfunction
