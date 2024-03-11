
function newVar = %sopiVar_m_sopiVar(var1, var2)
    // check sizes
    ns              = sopi_checkSizeCoherence('mul', var1.size, var2.size)
    // 
    if var1.isConstant() & var2.isConstant() then
        newVar          = soop_new('sopiVar')
        newVar.size     = ns 
        newVar.space    = 'real'
        newVar.operator = 'constant'
        newVar.class    = var1.class 
        newVar.child    = list(var1.child(1) * var2.child(1))
    elseif var1.isConstant() & ~var2.isConstant() then
        newVar = sopi_propagateLinearMapping('l',ns,var1.child(1), var2)
    elseif ~var1.isConstant() & var2.isConstant() then 
        newVar = sopi_propagateLinearMapping('r',ns,var2.child(1), var1)
    else
        error('Multiplication between sopiVar not yet supported')
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
        A       = A * speye(ns(1),ns(2))
    end
    select var.operator
    case 'llm'
        if side == 'L' then
            var.child(1) = A * var.child(1)
            outVar = var
        else
            outVar          = soop_new('sopiVar')
            outVar.size     = ns 
            outVar.space    = 'real'
            outVar.operator = side + 'lm'
            outVar.class    = var.class 
            outVar.child    = list(A, var)
        end 
    case 'rlm' 
        if side == 'R' then
            var.child(1) = var.child(1) * A
            outVar = var
        else
            outVar          = soop_new('sopiVar')
            outVar.size     = ns 
            outVar.space    = 'real'
            outVar.operator = side + 'lm'
            outVar.class    = var.class 
            outVar.child    = list(A, var)
        end 
    case 'none'
        outVar          = soop_new('sopiVar')
        outVar.size     = ns 
        outVar.space    = 'real'
        outVar.operator = side + 'lm'
        outVar.class    = var.class 
        outVar.child    = list(A, var)
    case 'sum'
        newChild = list()
        for i = 1:length(var.child)
            termi           = var.child(i);
            termi           = sopi_propagateLinearMapping(side, ns, A, termi)
            termi.size      = ns
            newChild($+1)   = termi
        end
        var.child   = newChild
        outVar      = var
    case 'constant'
        var.child   = sopi_mulfun(side, A, var.child(1))
        var.size    = ns
        outVar      = var
    end
endfunction
