function c = sopi_applyClassRule(operator, args)
    select (operator)
    case ('sum')
//        s = args(1).size
        c = 0 // zeros(s(1),s(2))
        for (i=(1:length(args))) do
            c = max(c, args(i).class)
        end
    case ('mul')
    case ('<=')
        // nonconvex until otherwise 
        lhs = args
        c   = sopi_classCode('nonconvex',lhs.size)
        if lhs.isLinear()
            c = 1
        elseif lhs.isConvex()
            c = 2 
        end 
    case '>='
        lhs = args
        c   = sopi_classCode('nonconvex',lhs.size)
        if lhs.isLinear() 
            c = 1
        elseif  lhs.isConcave()
            // concave > 0 <-> -concave < 0 <-> convex <0
            c = 2
        end
    case '='
        lhs = args
        c   = sopi_classCode('nonconvex',lhs.size)
        if lhs.isLinear()
            c = 1
        end
    end
endfunction
