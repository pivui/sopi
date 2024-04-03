// b >= sopiVar ................................................................
function out = %s_4_sopiVar(b, var)
    if norm(b) <= %eps then
        cst             = sopi_constraint()
        cst.operator    = '<=' 
        cst.lhs         = var
        cst.class       = sopi_classRules('<=',cst)
        return 
    end
    bvar = sopi_constant(b)
    out = var <= bvar
endfunction
