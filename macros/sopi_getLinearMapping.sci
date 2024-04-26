function  lm = sopi_getLinearMapping(var, vList, p)
    //
    if sopi_polyOrder(var)> 1 then
        error('Cannot extract linear mapping from variable which is not a linear function')
    end
    if sopi_polyOrder(var) == 0 then
        if argn(2)<3 then
            lm.L    = list()
            lm.ids  = list()
            lm.R    = list()
            lm. B    = var.child(1)
        else
            lm.A    = zeros(0, p.nvar)
            B       = var.child(1)
            lm.b    = B(:)
        end
    end
    B           = zeros(size(var,1),size(var,2))
    if argn(2)<2 || isempty(vList) then
        vList       = sopi_depends(var)
    end
    [ids, op, L, R, B]   = sopi_getLinearMapping_(var, vList, list(), list(), list(), list(), B)
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
        lm.op   = op
        lm.vars = vList
    else
        // Converts to vectorised form 
        //
        //  vec(var) = vec(B) + SUM_i kron(R(i)', L(i)) * vec(X(i))
        //
        [A, b]  = sopi_getLinearMappingMatrices(var, p, ids, op, L, R, B)
        lm.A    = A
        lm.b    = b
    end
endfunction

function [ids, op, L, R, B] = sopi_getLinearMapping_(var, vList, ids, op, L, R, B)
    n = length(vList)
    select var.operator
    case 'none'
        [inList, i] = sopi_varInList(var, vList)
        [m, n]      = size(var)
        ids($+1)    = i
        op($+1)     = var.subop
        L($+1)      = eye(m,m)
        R($+1)      = eye(n,n)
    case 'constant'
        B           = B + var.child(1)
    case 'sum'
        for i = 1:length(var.child)
            [ids, op, L, R, B] = sopi_getLinearMapping_(var.child(i), vList, ids, op, L, R, B)
        end
    case 'mul'
        B1 = zeros(size(var.child(1),1), size(var.child(1),2))
        B2 = zeros(size(var.child(2),1), size(var.child(2),2))
        // (sum_i L1i Xi R1i + B1) (sum_i L2j Xj R2j + B2) , one Xi/Xj is 0 each time
        [id1, op1,L1, R1, B1] = sopi_getLinearMapping_(var.child(1), vList, list(), list(), list(), list(), B1)
        [id2, op2, L2, R2, B2] = sopi_getLinearMapping_(var.child(2), vList, list(), list(), list(), list(), B2)
        // Constant term 
        B               = B + full(B1 * B2)
        // Linear term 
        if length(id1) == 0 then 
            // var1 is the constant 
            for i = 1:length(id2)
                if isscalar(vList(id2(i))) then 
                    L($+1) = B1 * L2(i) * R2(i)
                    R($+1) = 1 
                else
                    L($+1)      = B1 * L2(i)
                    R($+1)      = R2(i)
                end
                ids($+1)    = id2(i)  
                op($+1)     = op2(i) 
            end
        elseif length(id2) == 0 then 
            // var2 is the constant
            for i = 1:length(id1)
                if isscalar(vList(id1(i))) then 
                    L($+1) = L1(i) * R1(i) * B2
                    R($+1) = 1
                else
                    L($+1)      = L1(i)
                    R($+1)      = R1(i) * B2 
                end
                ids($+1)    = id1(i)
                op($+1)     = op1(i)
            end
        end
    else
        error('not yet')

    end
endfunction

