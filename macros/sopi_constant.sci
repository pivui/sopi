function cvar = sopi_constant(a)
    cvar            = soop_new('sopiVar')
    cvar.size       = [size(a,1), size(a,2)]
    cvar.space      = 'real'
    cvar.class      = sopi_classCode("constant",size(a,1),size(a,2))
    cvar.operator   = 'constant'
    cvar.child      = list(a)
    //
    cvar            = soop_getObj(cvar)
endfunction
