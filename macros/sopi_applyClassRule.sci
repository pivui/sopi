function c = sopi_applyClassRule(operator, args)
    c = sopi_classCode('nonconvex')
    select (operator)
    case ('sum')
        wc = sopi_worstClass(args)
        if isempty(wc)
            return
        end
        c = wc
    case ('mul')
        [wc, bc, iw, ib] = sopi_sortClasses(args(1).class, args(2).class)
        if bc == sopi_classCode('constant') & wc == sopi_classCode('linear') then 
            // constant * linear -> linear 
            c = wc
            return
        end
        if bc == sopi_classCode('constant') & ...
            wc == sopi_classCode('convex-pwa') || wc == sopi_classCode('concave-pwa') || ... 
            wc == sopi_classCode('convex') || wc == sopi_classCode('concave') then 
            // constant * convex|concave -> depends on the sign
            s = sign(args(ib).child(1))>=0 
            if and(s) then 
                // positive constant * convex|concave => convex|concave
                c = wc
            elseif and(~s) then 
                // negative constant * convex|concave => concave|convex
                c = -wc
            end
            return
        end
    case {'max','abs'}
        wc = sopi_worstClass(args)
        if isempty(wc)
            return
        end
        if wc == sopi_classCode('linear') then 
            c = sopi_classCode('convex-pwa')
            return
        end
        c = sopi_applyClassRule('ndconvexFun', args)
    case ('ndconvexFun')
        //non decreasing convex function
        wc = sopi_worstClass(args)
        if isempty(wc)
            return
        end
        if wc == sopi_classCode('convex') then 
            c = wc
        end
    case ('convexFun')
        wc = sopi_worstClass(args)
        if isempty(wc)
            return
        end
        if wc == sopi_classCode('linear') then 
            //f(A*x + b) is convex if f is convex
            c = sopi_classCode('convex')
        end
    case ('concaveFun')
        wc = sopi_worstClass(args)
        if isempty(wc)
            return
        end
        if wc == sopi_classCode('linear') then 
            c = sopi_classCode('concave')
        end
        // Constraints ---------------------
    case ('<=')
        // nonconvex until otherwise 
        lhs = args
        if sopiVar_isLinear(lhs)
            c = sopi_classCode('linear')
        elseif sopiVar_isConvexPWA(lhs)
            c = sopi_classCode('convex-pwa')
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

function wc = sopi_worstClass(args)
    wc = 0 
    for (i=(1:length(args))) do
        wc = sopi_sortClasses(wc, args(i).class)
        if isempty(wc)
            break
        end
    end
endfunction

function [wc, bc, iw, ib] = sopi_sortClasses(c1, c2)
    if sign(c1) == sign(c2) then
        [wc,iw]   = max([c1, c2])
        [bc, ib]  = min([c1, c2])

    else
        if c1 == c2 then 
            // cannot tell what is worse
            wc = []
            bc = []
            iw = []
            ib = []
            return
        end
        if abs(c1) > abs(c2) then 
            wc = c1
            iw = 1
            bc = c2
            ib = 2
        else
            iw = 2
            ib = 1
            wc = c2
            bc = c1
        end

    end
endfunction
