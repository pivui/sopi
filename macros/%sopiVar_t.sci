// sopiVar' ....................................................................
// transposes a sopiVar.
function newVar = %sopiVar_t(var)
    if isscalar(var) then
        newVar = var
        return 
    end
    select var.operator
    case 'transpose'
        newVar = var.child(1)
    case 'constant'
        At      = var.child(1)'
        newVar  = sopi_constant(At)
    case 'sum'
        newVar = var.child(1)'
        for i = 2:length(var.child)
            newVar = newVar + var.child(i)'
        end
//    case {'llm','rlm','mul'}
//        newVar = var.child(2)' * var.child(1)'
    else 
        newVar          = sopi_var(var.size(2), var.size(1))
        newVar.operator = 'transpose'
        newVar.child(1) = var
        newVar.class    = var.class  
    end
endfunction
