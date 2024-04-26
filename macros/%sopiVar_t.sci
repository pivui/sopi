// sopiVar' ....................................................................
// transposes a sopiVar.
function newVar = %sopiVar_t(var)
    if isscalar(var) then
        newVar = var
        return 
    end
//    if ~isempty(var.subop) & var.subop(1) == 'transpose' then
//        newVar = var.subop(2)
//        return
//    end
    newVar = sopi_propagateTranspose(var)
//    [m, n] = size(var)
//    newVar = zeros(n,m)
//    for k = 1:m
//        ek = sopi_ei(m,k,%T)
//        for l = 1:n
//            el = sopi_ei(n,l,%T)
//            newVar = newVar + var(k,l) * (el*ek')
//        end
//    end
//    newVar.subop = list('transpose',var)
endfunction

function newVar = sopi_propagateTranspose(var)
    select var.operator
    case 'none'
        if var.subop == 't' then
            var.subop = ''
        else
            var.subop = 't'
        end
        newVar = var
    case 'constant'
        newVar = sopi_constant(var.child(1)')
    case 'mul'
        newVar = sopi_propagateTranspose(var.child(2)) * sopi_propagateTranspose(var.child(1))
    case 'sum'
        newVar = sopi_propagateTranspose(var.child(1))
        for i = 2:length(var.child)
            newVar = newVar + sopi_propagateTranspose(var.child(i))
        end
    else
        [m, n] = size(var)
        newVar = zeros(n,m)
        for k = 1:m
            ek = sopi_ei(m,k,%T)
            for l = 1:n
                el = sopi_ei(n,l,%T)
                newVar = newVar + var(k,l) * (el*ek')
            end
        end
    end
endfunction
