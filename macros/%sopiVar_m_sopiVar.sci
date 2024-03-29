
function newVar = %sopiVar_m_sopiVar(var1, var2)
    // check sizes
    ns              = sopi_checkSizeCoherence('mul', var1.size, var2.size)
    // 
    test = [sopiVar_isConstant(var1), sopiVar_isConstant(var2)]
    if and(test) then
        newVar          = sopi_var(ns(1), ns(2))
        newVar.space    = 'real'
        newVar.operator = 'constant'
        newVar.class    = var1.class 
        newVar.child    = list(var1.child(1) * var2.child(1))
    elseif test(1) & ~test(2) then
        newVar = sopi_propagateLinearMapping('l',ns,var1.child(1), var2)
    elseif ~test(1) & test(2) then 
        newVar = sopi_propagateLinearMapping('r',ns,var2.child(1), var1)
    else
        newVar          = sopi_var(ns(1), ns(2))
        newVar.space    = 'real'
        newVar.operator = 'mul'
        newVar.class    = sopi_applyClassRule('mul', list(var1, var2))
        newVar.child    = list(var1, var2)
    end

endfunction

function out = sopi_mulfun(side, A, var)
    if side =='l' then
        out = A * var
    elseif side == 'r' then
        out = var * A
    else 
        error('wrong argument for side')
    end
endfunction

function outVar = sopi_propagateLinearMapping(side, ns, A, var)
    if isscalar(A) then
        [m,n]   = size(var)
        if side == 'l' then
            A       = A * speye(ns(1),ns(1))
        else
            A = A * speye(ns(2), ns(2)) 
        end
    end
    select var.operator
    case 'llm'
        if side == 'l' then
            var.child(1) = A * var.child(1)
            outVar = var
        else
            outVar          = sopi_var(ns(1),ns(2))
            outVar.space    = 'real'
            outVar.operator = side + 'lm'
            outVar.class    = var.class 
            outVar.child    = list(A, var)
        end 
    case 'rlm' 
        if side == 'r' then
            var.child(1) = var.child(1) * A
            outVar = var
        else
            outVar          = sopi_var(ns(1),ns(2))
            outVar.space    = 'real'
            outVar.operator = side + 'lm'
            outVar.class    = var.class 
            outVar.child    = list(A, var)
        end 
    case 'none'
        outVar          = sopi_var(ns(1),ns(2))
        outVar.space    = 'real'
        outVar.operator = side + 'lm'
        outVar.class    = var.class 
        outVar.child    = list(A, var)
    case 'sum'
        newChild = list()
        for i = 1:length(var.child)
            termi           = var.child(i)
            termi           = sopi_propagateLinearMapping(side, ns, A, termi)
            termi.size      = ns
            newChild($+1)   = termi
        end
        var.child   = newChild
        outVar      = var
    case 'constant'
        var.child   = list(sopi_mulfun(side, A, var.child(1)))
        var.size    = ns
        outVar      = var
    case 'fun'
        outVar          = sopi_var(ns(1),ns(2))
        outVar.space    = 'real'
        outVar.operator = side + 'lm'
        outVar.class    = sopi_applyClassRule('mul', list(sopi_constant(A), var))
        outVar.child    = list(A, var)
    case 'transpose'
//        if side == 'l' then
//            // A  * x' = (x*A')'
//            outVar = (var.child(1)*A')' 
//        else
//            // x'*A = (A'*x)'
//            outVar = (A'* var.child(1))'
//        end      
    end
endfunction
