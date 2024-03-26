function [A, b] = sopi_extractLinearMatrices(var, p)
    //  
    if argn(2) < 2 then
        // create dummy problem for storing variables indexes 
        p       = sopi_problem()
        vars    = sopi_depends(var)
        p       = sopi_addVarsToPb(p, vars)
    end
    //
    select var.operator
    case 'none'
        nvar        = p.nvar
        A           = sparse([],[],[size(var,1),nvar])
        idxVar      = sopi_varIdxInPb(p, var)
        A(:,idxVar) = speye(size(var,1),size(var,1))
        b           = zeros(size(A,1),1)
    case 'llm'
        A1      = var.child(1)
        [A2,b]  = sopi_extractLinearMatrices(var.child(2), p)
        A       = A1*A2
        b       = A1*b
    case 'constant'
        b       = var.child(1)
        A       = 0
    case 'sum'
        for i = 1:length(var.child)
            [Ai,bi]     = sopi_extractLinearMatrices(var.child(i), p)
            if i == 1 then 
                b = bi
                A = Ai
            else
                b = b + bi
                A = A + Ai
            end
        end
    case 'transpose'
        [As,bs] = sopi_extractLinearMatrices(var.child(1))
        A       = As'
        b       = bs'
    else
        error("Unsupported case")
    end
endfunction
