// sopi_solve ..................................................................
// is the interface for solving problems
function  [xopt, fopt, info] = sopi_solve(pb, method, opt)
    //
    if argn(2)<2 then
        method = []
    end
    if argn(2) < 3 then
        opt = []
    end
    //
    sopi_print(1,'Nature of the optimisation problem:' + pb.class)
    // Look for corresponding solvers 
    solvers = sopi_availableSolvers(pb.class)
    if isempty(solvers) then
        error('No solver found for this class of problem.')
    end
    // Check if user supplied solver exists
    solver = []
    if ~isempty(method) then
        for i = 1:length(solvers)
            if solvers(i).name == method then 
                solver      = solvers(i)
                break
            end
        end
        if isempty(solver) then 
            error('Solver '''+method+''' not found for this class of problem')
        end
    else
        solver = solvers(1)
        method = solver.name
    end
    // Call solver 
    if solver.ulbToHuge then
        [lb, ub] = sopi_infULBtoHuge(pb)
    end
    opt     = sopi_fillOptions(solver.options, opt)
    //
    xopt    = []
    fopt    = %inf
    try
        tic()
        timer()
        execstr(solver.callingSequence)
        info.elapsedTime    = toc()
        info.cpuTime        = timer()
        info.flag           = flag
        info.vFlag          = sopi_interpretFlag(flag, solver.flags(1), solver.flags(2))
    catch 
        info.flag   = %inf
        info.vFlag  = 'Error in '+method+': ' + lasterror()
    end
    // Add constant term
    fopt = fopt + pb.r
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
