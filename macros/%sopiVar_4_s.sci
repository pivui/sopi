// sopiVar >= b ................................................................
function cst = %sopiVar_4_s(var, b)
    if norm(b) <= %eps then
        cst             = sopi_constraint()
        cst.operator    = '<=' 
        cst.lhs         = (-1) * var
        cst.class       = sopi_classRules('<=',cst)
        return 
    end
    bvar = sopi_constant(b)
    cst = var >= bvar;
endfunction
