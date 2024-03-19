function c = sopi_applyClassRule(operator, args)
    c = sopi_classCode('nonconvex')
    select (operator)
    case ('sum')
        cM = -%inf
        cm = %inf
        for (i=(1:length(args))) do
            cM = max(cM, args(i).class)
            cm = min(cm, args(i).class)
        end
        if cm == sopi_classCode('concave') && cM == sopi_classCode('convex') then 
            return
        end
        if cm >= sopi_classCode('constant') then 
            c = cM
            return
        end
        if cm == sopi_classCode('concave') & cM <= sopi_classCode('linear') then 
            c = cm
            return
        end
    case ('mul')
        if abs(args(1).class) > abs(args(2).class)
            v1 = args(2)
            v2 = args(1)
        else
            v1 = args(1)
            v2 = args(2)
        end
        Mc = v2.class
        mc = v1.class

        if mc == sopi_classCode('constant') & Mc <= sopi_classCode('linear') then
            // constant * linear -> linear
            c = sopi_classCode('linear') 
        elseif mc == sopi_classCode('constant') & abs(Mc) <= sopi_classCode('convex') then 
            // constant * convex|concave -> depends on the sign
            s = sign(v1.child(1))>=0
            if and(s) then 
                // positive constant * convex|concave => convex|concave
                c = Mc
            elseif and(~s) then 
                // negative constant * convex|concave => concave|convex
                c = -Mc
            end 
        end

    case ('ndconvexFun')
        //non decreasing convex function
        mc = 0 
        for i = 1:length(args)
            mc = max(mc, args(i).class)
        end 
        if mc >=0 & mc <= sopi_classCode('convex') then 
            c = sopi_classCode('convex')
        end
    case ('convexFun')
        mc = 0
        for i = 1:length(args)
            mc = max(mc, args(i).class)
        end
        if mc == sopi_classCode('linear') then //f(A*x + b) is convex if f is convex
            c = sopi_classCode('convex')
        end
    case ('concaveFun')
        mc = 0
        for i = 1:length(args)
            mc = max(mc, args(i).class)
        end
        if mc == 1 then
            c = sopi_classCode('concave')
        end
// Constraints ---------------------
    case ('<=')
        // nonconvex until otherwise 
        lhs = args
        if sopiVar_isLinear(lhs)
            c = sopi_classCode('linear')
        elseif sopiVar_isConvexPWA(lhs)
            c = sopi_classCode('pwa-convex')
        elseif sopiVar_isConvex(lhs)
            c = sopi_classCode('convex')
        end 
    case '='
        lhs = args
        if sopiVar_isLinear(lhs)
            c = sopi_classCode('linear')
        end
    end
endfunction
