function  lm = sopi_getLinearMapping(var, vList, p)
    //
    if ~sopi_isLinear(var) then
        error('Cannot extract linear mapping from variable which is not a linear function')
    end
    B           = zeros(size(var,1),size(var,2))
    if argn(2)<2 || isempty(vList) then
        vList       = sopi_depends(var)
    end
    [ids, L, R, B]   = sopi_getLinearMapping_(var, vList, list(), list(), list(), B)
    //
    if argn(2) < 3 then
        // Decompose var as:
        //
        //  var =  B + SUM_t L(t) * X(it) * R(t) with it in ids
        //
        // where X(i) are the elementary variables
        //
        lm.L    = L
        lm.R    = R
        lm.B    = B
        lm.ids  = ids
        lm.vars = vList
    else
        // Converts to vectorised form 
        //
        //  vec(var) = vec(B) + SUM_i kron(R(i)', L(i)) * vec(X(i))
        //
        [m,n]   = size(var)
        save('bug','var','p')
//        A       = sparse([],[],[size(var,'*'), p.nvar])
        A       = zeros(m*n, p.nvar)
        for k = 1:m
            for l = 1:n 
                //
                t = (l-1) *m + k
                for i = 1:length(ids)
                    // ek' * L(t) * X(it) * R(t) * el
                    idxVari         = sopi_varIdxInPb(p, vList(ids(i)))
                    A(t,idxVari)    = A(t, idxVari)  + kron(R(i)(:,l)', L(i)(k,:))
                end
            end
        end
        lm.A = A
        lm.b = B(:)
    end
endfunction

function [ids, L, R, B] = sopi_getLinearMapping_(var, vList, ids, L, R, B)
    n = length(vList)
    select var.operator
    case 'none'
        [inList, i] = sopi_varInList(var, vList)
        [m, n]      = size(var)
        ids($+1)    = i
        L($+1)      = eye(m,m)
        R($+1)      = eye(n,n)
    case 'constant'
        B           = B + var.child(1)
    case 'sum'
        for i = 1:length(var.child)
            [ids, L, R, B] = sopi_getLinearMapping_(var.child(i), vList, ids, L, R, B)
        end
    case 'mul'
        B1 = zeros(size(var.child(1),1), size(var.child(1),2))
        B2 = zeros(size(var.child(2),1), size(var.child(2),2))
        // (sum_i L1i Xi R1i + B1) (sum_i L2j Xj R2j + B2) , one Xi/Xj is 0 each time
        [id1, L1, R1, B1] = sopi_getLinearMapping_(var.child(1), vList, list(), list(), list(), B1)
        [id2, L2, R2, B2] = sopi_getLinearMapping_(var.child(2), vList, list(), list(), list(), B2)
        // Constant term 
        B               = B + full(B1 * B2)
        disp(size(B))
        // Linear term 
        if length(id1) == 0 then 
            // var1 is the constant 
            for i = 1:length(id2)
                L($+1)      = B1 * L2(i)
                R($+1)      = R2(i)
                ids($+1)    = id2(i)
            end
        elseif length(id2) == 0 then 
            // var2 is the constant
            for i = 1:length(id1)
                L($+1)      = L1(i)
                R($+1)      = R1(i) * B2 
                ids($+1)    = id1(i)
            end
        end
    else
        error('not yet')

    end
endfunction

