function p = sopi_addFun(p, fun)
    if size(fun,'*')>1 then
        error('Multi-objective optimisation is not handled')
    end
    if sopiVar_isLinear(fun) then
        [ct,r]  = sopi_extractLinearMatrices(p, fun)
        p.c     = ct'
        p.r     = r
    elseif sopiVar_isConvexPWA(fun) then
        // CPWA is turned into linear objective + linear constraints 
        [newFun, newCons]   = sopi_convexToEpigraph(fun)
        p                   = sopi_addConstraints(p, newCons)
        p                   = sopi_addFun(p, newFun)
    end
endfunction

function [newFun, newCons] = sopi_convexToEpigraph(fun)
    [m,n]       = size(fun)
    slackVar    = sopi_var(m,n)
    c1          = fun <= slackVar   
    newFun      = slackVar 
    newCons     = list(c1)
endfunction
