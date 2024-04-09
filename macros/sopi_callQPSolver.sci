function [xopt, fopt, info] = sopi_callQPSolver(pb, isConvex, method)
    xopt = []
    fopt = []
    // default method + check availability
    convexSolvers = ['qpsolve']
    if isConvex then
        if isempty(method) then
            method = convexSolvers(1)
        else
            sopi_checkSolverAvailability(convexSolvers, method)
        end
    end
    //
    select method 
    case 'qpsolve'
        [lb,ub] = sopi_infULBtoHuge(pb)
        tic()
        timer()
        [xopt ,iact ,iter ,fopt]=qpsolve(2*full(pb.Q), pb.c, [pb.Ae;pb.A],[pb.be;pb.b],lb,ub,size(pb.Ae,1))
        info.elapsedTime     = toc()
        info.cpuTime         = timer()
    end

endfunction

