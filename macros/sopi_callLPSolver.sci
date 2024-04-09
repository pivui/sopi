function [xopt, fopt, info] = sopi_callLPSolver(pb,method)
    xopt = []
    fopt = []
    // Default choice
    lpSolvers = ['karmarkar','sopilp']
    if isempty(method) then
        method = lpSolvers(1)
    else
        sopi_checkSolverAvailability(lpSolvers, method)
    end
    //
    sopi_print(1,"Solving problem with : " + method + ".\n")
    //
    flag = %inf
    select method
    case 'karmarkar' // built-in scilab solver
        // output flags 
        flags                = [1, 0, -1, -2, -3, -4]
        flagMeaning          = ["The algorithm has converged.",
        "Maximum number of iterations reached.",
        "No feasible point has been found.",
        "The problem is unbounded.",
        "Search direction became 0.",
        "Algorithm stopped on user request."]
        //
        try
            tic()
            timer()
            [xopt, fopt, flag]   = karmarkar(full(pb.Ae),full(pb.be),full(pb.c),[],[],[],[],[],full(pb.A),full(pb.b),pb.lb,pb.ub)
            info.elapsedTime     = toc()
            info.cpuTime         = timer()
        catch 
        end
        //   case 'linpro' // from external module quapro
        //      sopi_testIfInstalled("linpro","To use the solver linpro, the quapro module must be installed. You can get it from the atoms portal.")
        //      [lb,ub] = sopi_infULBtoHuge(pb)
        //      tic()
        //      timer()
        //      try
        //         [xopt, lagr, fopt]   = linpro(full(pb.c), full([pb.Ae;pb.A]), full([pb.be;pb.b]), lb, ub, size(pb.Ae,1))
        //         info.vFlag           = ["linpro","The algorithm has converged.\n"]
        //         flag                 = 1
        //      catch
        //         flag                 = -1
        //         info.vFlag           = "linpro : " + lasterror()
        //      end
        //      info.elapsedTime     = toc()
        //      info.cpuTime         = timer()
    case 'sopilp' // sopi built-in
        flags                = [0,1,2,3]
        flagMeaning          = ["The algorithm has converged.",
                                "The problem is unbounded.",
                                "No feasible point has been found.",
                                "Failed to maintain feasibility"]
        try

            [xopt, fopt, flag, info] = sopi_solveLP(pb.c, pb.A, pb.b, pb.Ae, pb.be, pb.lb, pb.ub, "primal")
        catch
        end
    otherwise
        error('unknown LP solver')
    end
    //
    info.method = method
    info.flag   = flag
    if isinf(flag) then
        sopi_print(-1, 'Error in method '''+method+''': '+lasterror())
        info.vFlag = 'Error in algorithm:' + lasterror()
    else
        info.vFlag = sopi_interpretFlag(flag, flags, flagMeaning)
    end
endfunction
