function Q = sopi_extractQuadraticMatrix(var, p)
    if argn(2) < 2 then
        // create dummy problem for storing variables indexes 
        p       = sopi_problem()
        vars    = sopi_depends(var)
        p       = sopi_addVarsToPb(p, vars)
    end
    select var.operator
    case 'mul'
        A1  = sopi_extractLinearMatrices(var.child(1), p)
        A2  = sopi_extractLinearMatrices(var.child(2), p)
        // (A1 * x)' (A2 * x)
        Q   = A1'*A2
    end
endfunction
