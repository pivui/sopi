// sopiVar <= b
function cst = %sopiVar_3_s(var, b)
    bvar    = sopi_constant(b)
    //
    cst             = soop_new('sopiCst')
    cst.operator    = '<=' 
    cst.lhs         = var - bvar
    cst.class       = sopi_applyClassRule('<=',cst.lhs)
endfunction
