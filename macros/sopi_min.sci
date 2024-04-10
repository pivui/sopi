function p = sopi_min(fun, cList)
    if argn(2)< 2 then
        cList = list()
    end
    p = sopi_problem()
    //
    p = sopi_addConstraints(p, cList)
    p = sopi_addFun(p, fun)
    //
    p = sopi_problemClass(p)
endfunction

function p = sopi_problemClass(p)
    hasNLPCst = sopi_hasNLPCst(p)
    hasNLPFun = ~sopi_emptyFun(p.f)
    hasBoxCst = sopi_hasBoxCst(p)
    //
    lp = ~isempty(p.c) & isempty(p.Q) & ~hasNLPFun & ~hasNLPCst
    if lp then
        p.class = 'lp'
        return
    end
    qp = ~isempty(p.Q) & ~hasNLPFun & ~hasNLPCst 
    if qp then
        if p.funClass.curv == 2 then 
            p.class='qp-convex'
        else
            p.class='qp-indef'
        end
        return
    end
    // NLP ------------------------------------------------------------------- 
    p.class = 'nlp'
    // specify which shade
    unlp = ~hasBoxCst & ~hasNLPCst
    if unlp then
        p.class = 'nlp-unc'
        return
    end
    boxnlp = hasBoxCst & ~hasNLPCst
    if boxnlp then
        p.class='nlp-box'
        return
    end
endfunction

function out = sopi_emptyFun(f)
    out =type(f)==1
endfunction


