function [xopt, fopt, info] = sopi_callQPSolver(pb, isConvex, method)
    xopt = []
    fopt = []
    // default method + check availability
    convexSolvers = ['qld','qpsolve']
    if isConvex then
        if isempty(method) then
            method = convexSolvers(1)
        else
            sopi_checkSolverAvailability(convexSolvers, method)
        end
    end
    //
    sopi_print(1,"Solving problem with : " + method + ".\n")
    flag = %inf
    select method 
    case 'qld'
        //
        flags               = [0, 1, 2, 5, 10]
        flagMeaning         = ["The algorithm has converged.",
                               "Too many iterations needed.",
                               "Accuracy insufficient to satisfy convergence criterion.",
                               "Length of working array is too short.",
                               "The constraints are inconsistent."]
        //
        [lb,ub] = sopi_infULBtoHuge(pb)
        try
            tic()
            timer()
            [xopt ,lagr ,flag]  = qld(2 * full(pb.Q), pb.c, full([pb.Ae;pb.A]),[pb.be;pb.b],lb,ub,size(pb.Ae,1))
            info.elapsedTime    = toc()
            info.cpuTime        = timer()
            //
            fopt                = xopt'*pb.Q*xopt + pb.c'*xopt
            //
        catch 
            //
        end
    case 'qpsolve'
        flags               = [0]
        flagMeaning         = ["The algorithm has converged."]
        [lb,ub]             = sopi_infULBtoHuge(pb)
        try
            tic()
            timer()
            [xopt ,iact ,iter ,fopt]=qpsolve(2*full(pb.Q), pb.c, [pb.Ae;pb.A],[pb.be;pb.b],lb,ub,size(pb.Ae,1))
            info.elapsedTime    = toc()
            info.cpuTime        = timer()
            flag = 0
        catch 
            //
            
        end
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

