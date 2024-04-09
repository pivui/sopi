function p = sopi_min(fun, cList)
    p = sopi_problem()
    //
    p = sopi_addConstraints(p, cList)
    p = sopi_addFun(p, fun)
    //
    p = sopi_problemClass(p)
endfunction

function p = sopi_problemClass(p)
    lp = norm(p.Q)==0 & isempty(p.f) & isempty(p.ci) & isempty(p.ce) & ~isempty(p.c)
    if lp then
        p.class = 'lp'
        return
    end
    qp = isempty(p.f) & isempty(p.ci) & isempty(p.ce) & ~isempty(p.c)
    if qp then
        if p.funClass.curv == 2 then 
            p.class='qp-convex'
        else
            p.class='qp-indef'
        end
        return
    end
endfunction
