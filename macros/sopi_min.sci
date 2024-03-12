function p = sopi_min(fun, cList)
    p = sopi_problem()
    //
    p = sopi_addConstraints(p, cList)
//    p = sopi_addFun(p, fun)
endfunction
