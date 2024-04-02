// sopiVar <= b
function cst = %sopiVar_3_s(var, b)
    if norm(b) <= %eps then
        cst             = sopi_constraint()
        cst.operator    = '<=' 
        cst.lhs         = var
        cst.class       = sopi_classRules('<=',cst.lhs)
        return 
    end
    bvar    = sopi_constant(b)
    //
    cst             = sopi_constraint()
    cst.operator    = '<=' 
    cst.lhs         = var - bvar
    cst.class       = sopi_classRules('<=',cst.lhs)
endfunction
