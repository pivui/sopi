function cst = %sopiVar_o_s(var, b)
    bvar            = sopi_constant(b)
    //
    cst             = sopi_constraint()
    cst.operator    = '='
    cst.lhs         = var - bvar
    cst.class       = sopi_classRules('=',cst.lhs)
endfunction
