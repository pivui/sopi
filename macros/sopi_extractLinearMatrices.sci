function [A, b] = sopi_extractLinearMatrices(p, var)
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
        [A2,b]  = sopi_extractLinearMatrices(p, var.child(2))
        A       = A1*A2
        b       = A1*b
    case 'constant'
        b       = -var.child(1) // put on the rhs
        A       = 0
    case 'sum'
        for i = 1:length(var.child)
            [Ai,bi]     = sopi_extractLinearMatrices(p, var.child(i))
            if i == 1 then 
                b = bi
                A = Ai
            else
                b = b + bi
                A = A + Ai
            end
        end
    else
        error("else case")
    end
endfunction
