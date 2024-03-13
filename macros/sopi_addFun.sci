function p = sopi_addFun(p, fun)
    if size(fun,'*')>1 then
        error('Multi-objective optimisation is not handled')
    end
    if sopiVar_isLinear(fun) then
        [ct,r]  = sopi_extractLinearMatrices(p, fun)
        p.c     = ct'
        p.r     = r
    end
endfunction
