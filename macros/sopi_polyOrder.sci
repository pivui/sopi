function r = sopi_polyOrder(var)
    if var.class.type ~= 'poly' then
        r = []
        return
    end
    r = var.class.order
//    select var.operator 
//    case 'none'
//        r = 1
//    case 'constant'
//        r = 0
//    case 'sum'
//        rs = zeros(length(var.child),1)
//        for i = 1:length(var.child)
//            rs(i) = sopi_polyOrder(var.child(i))
//        end 
//        r = max(rs)
//    case {'rlm','llm'}
//        r = sopi_polyOrder(var.child(2))
//    case 'mul'
//        r = sopi_polyOrder(var.child(1)) + sopi_polyOrder(var.child(2))
//    case 'transpose'
//        r = sopi_polyOrder(var.child(1))
//    else
//        r = %inf
//    end
endfunction
