function p = sopi_min(fun, cList)
    p = sopi_problem()
    //
    p = sopi_addConstraints(p, cList)
    p = sopi_addFun(p, fun)
    //
    p = sopi_problemClass(p)
endfunction

function p = sopi_problemClass(p)
    lp = isempty(p.H) & isempty(p.f) & isempty(p.ci) & isempty(p.ce) & ~isempty(p.c)
    if lp then
        p.class = 'lp'
        return
    end
endfunction
