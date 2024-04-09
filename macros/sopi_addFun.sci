function p = sopi_addFun(p, fun)
    if size(fun,'*')>1 then
        error('Multi-objective optimisation is not handled')
    end
    if sopi_isLinear(fun) then
        vars    = sopi_depends(fun)
        p       = sopi_addVarsToPb(p, vars)
        //
        lm      = sopi_getLinearMapping(fun, [], p)
        p.c     = lm.A'
        p.r     = lm.b
        p.funClass = fun.class
    elseif sopi_isConvexPWA(fun) then
        // CPWA is turned into linear objective + linear constraints 
        [newFun, newCons]   = sopi_convexToEpigraph(fun)
        //
        vars                = sopi_depends(newFun)
        p                   = sopi_addVarsToPb(p, vars)
        //
        p                   = sopi_addFun(p, newFun)
        p                   = sopi_addConstraints(p, newCons)
        p.funClass = newFun.class
    elseif sopi_isQuadratic(fun) then 
        vars    = sopi_depends(fun)
        p       = sopi_addVarsToPb(p, vars)
        qm      = sopi_getQuadraticMapping(fun, p)
        p.Q    = qm.Q(1)
        p.c    = qm.A'
        p.r    = qm.b
        p.funClass = fun.class
    end
endfunction

function [newFun, newCons] = sopi_convexToEpigraph(fun)
    slackVar    = sopi_var(1)
    c1          = fun <= slackVar   
    newFun      = slackVar 
    newCons     = list(c1)
endfunction
