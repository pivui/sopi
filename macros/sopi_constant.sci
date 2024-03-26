function cvar = sopi_constant(a)
    cvar            = sopi_var(size(a,1),size(a,2))
    cvar.space      = 'real'
    cvar.class      = sopi_classCode("constant",size(a,1),size(a,2))
    cvar.operator   = 'constant'
    cvar.child      = list(a)
    //
endfunction
