function  lm = sopi_getLinearMapping(var, vList, p)
    //
    if ~sopi_isLinear(var) then
        error('Cannot extract linear mapping from variable which is not a linear function')
    end
    L           = list()
    R           = list()
    B           = zeros(size(var,1),size(var,2))
    if argn(2)<2 || isempty(vList) then
        vList       = sopi_depends(var)
    end
    for i = 1:length(vList)
        L($+1) = 0
        R($+1) = 0
    end
    [L, R, B]   = sopi_getLinearMapping_(var, vList, L, R, B)
    //
    if argn(2) < 3 then
        // Decompose var as:
        //
        //  var =  B + SUM_i L(i) * X(i) * R(i) 
        //
        // where X(i) are the elementary variables
        //
        lm.L    = L
        lm.R    = R
        lm.B    = B
        lm.vars = vList
    else
        // Converts to vectorised form 
        //
        //  vec(var) = vec(B) + SUM_i kron(R(i)', L(i)) * vec(X(i))
        //
        A = sparse([],[],[size(var,'*'), p.nvar])
        for i = 1:length(vList)
            vi      = vList(i)
            idxVar  = sopi_varIdxInPb(p, vi)
            if isempty(idxVar)
                error('Variable is not in problem')
            end
            // Li * Xi * Ri => kron(Ri', Li) * vec(Xi)
            A(:,idxVar) = A(:,idxVar) + sparse(kron(R(i)', L(i)))
        end
        lm.A = A
        lm.b = B(:)
    end
endfunction

function [L, R, B] = sopi_getLinearMapping_(var, vList, L, R, B)
    select var.operator
    case 'none'
        [inList, i] = sopi_varInList(var, vList)
        [m, n]      = size(var)
        L(i)        = L(i) + speye(m, m)
        if norm(R(i)) == 0 then
            R(i)        = speye(n, n)
        end
    case 'constant'
        B           = B + var.child(1)
    case 'sum'
        for i = 1:length(var.child)
            [L, R, B] = sopi_getLinearMapping_(var.child(i), vList, L, R, B)
        end
    case 'llm'
        A   = var.child(1)
        //
        nextVar = var.child(2)
        Bi = zeros(size(nextVar,1),size(nextVar,2))
        [L, R, Bi] = sopi_getLinearMapping_(nextVar, vList, L, R, Bi)
        //
        ivL = sopi_depends(var.child(2))
        for v = ivL
            [dummy, i]  = sopi_varInList(v, vList)
            L(i)        = A * L(i)
        end
        B = B + full(A * Bi)
    case 'rlm'
        A           = var.child(1)
        //
        nextVar = var.child(2)
        Bi = zeros(size(nextVar,1),size(nextVar,2))
        [L, R, Bi]  = sopi_getLinearMapping_(nextVar, vList, L, R, Bi)
        //
        ivL = sopi_depends(var.child(2))
        for v = ivL 
            [dummy, i]  = sopi_varInList(v, vList)
            R(i)        = R(i) * A
        end        
        B = B + full(Bi * A)

    else
        error('not yet')

    end
endfunction

