function newVar = %sopiVar_m_sopiVar(var1, var2)
    // check sizes
    ns              = sopi_checkSizeCoherence('mul', var1.size, var2.size)
    // try to simplify a bit as the tree is built:
    if sopi_isConstant(var1) & sopi_isConstant(var2) then
        newVar = sopi_constant(var1.child(1) * var2.child(1))
        return
    end
    //
    newVar          = sopi_var(ns(1), ns(2))
    newVar.space    = 'real'
    newVar.operator = 'mul'
    newVar.child    = list(var1, var2)
    newVar.class    = sopi_classRules('mul', newVar)
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

function outVar = sopi_propagateLinearMapping(side, A, var)
    select var.operator
    case 'sum'
        outVar = sopi_propagateLinearMapping(side, A, var.child(1))
        for i = 2:length(var.child)
            outVar = outVar +  sopi_propagateLinearMapping(side, A, var.child(i))
        end
    case 'constant'
        if side == 'l' then
            outVar = sopi_constant(A * var.child(1)) 
        else
            outVar = sopi_constant(var.child(1) * A) 
        end
            
    case 'mul'
        v1 = var.child(1)
        v2 = var.child(2)
    else
//        outVar          = sopi_var(size(A,1), size(var,2))
//        outVar.space    = 'real'
//        outVar.operator = 'mul'
//        if side == 'l' then 
//            outVar.child    = list(sopi_constant(A), var)
//        else
//            outVar.child    = list(var,sopi_constant(A))
//        end
//        outVar.class    = sopi_classRules('mul', newVar)
    end
endfunction

