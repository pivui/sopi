function c = sopi_classRules(operator, args)
    c = sopi_class('nl')
    select (operator)
    case ('sum')
        wc = sopi_worstClass(args)
        if isempty(wc) then 
            return
        end
        c = wc
    case ('mul')
        v1 = args(1)
        v2 = args(2)
        // constant * linear -> linear
        if sopi_isConstant(v1) & sopi_isLinear(v2) | ... 
           sopi_isConstant(v2) & sopi_isLinear(v1) then
           c = sopi_sortClasses(v1.class, v2.class)
            return
        end
        // constant * convex | concave -> depends on the sign
        if sopi_isConstant(v1) & sopi_isConvex(v2) | sopi_isConcave(v2) | ...
           sopi_isConstant(v2) & sopi_isConvex(v1) | sopi_isConcave(v1) then
           [c, iw, ib]     = sopi_sortClasses(v1.class, v2.class)
            s               = sign(args(ib).child(1)) >= 0
            if and(~s) then 
                // change curvature
                // negative constant * convex|concave => concave|convex
                c.curv  = -c.curv
            end
            return
        end

    case {'max','abs'}
        [wc, iw] = sopi_worstClass(args)
        if isempty(wc)
            return
        end
        v = args(iw)
        if sopi_isLinear(v) |sopi_isConvexPWA(v) then 
            c = sopi_class('pwpoly',1,2)
            return
        end
        c = sopi_classRules('ndconvexFun', args)
    case ('ndconvexFun')
        //non decreasing convex function
        [wc, iw] = sopi_worstClass(args)
        if isempty(wc)
            return
        end
        v = args(iw)
        if sopi_isConvex(v) then 
            c = wc
        end
    case ('convexFun')
        [wc, iw] = sopi_worstClass(args)
        if isempty(wc)
            return
        end
        v = args(iw)
        if sopi_isLinear(v) then 
            //f(A*x + b) is convex if f is convex
            c = sopi_class('nl', 2)
        end
    case ('concaveFun')
        [wc, iw] = sopi_worstClass(args)
        if isempty(wc)
            return
        end
        v = args(iw)
        if sopi_isLinear(v) then 
            //f(A*x + b) is concav if f is concave
            c = sopi_class('nl', -2)
        end
        // Constraints --------------------------------------------------------
    case ('<=')
        lhs = args
        if sopi_isLinear(lhs)
            c = lhs.class
        elseif sopi_isConvexPWA(lhs)
            c = lhs.class
        elseif sopi_isConvex(lhs)
            c = lhs.class
        end 
    case '='
        lhs = args
        if sopi_isLinear(lhs)
            c = lhs.class
        end
    end
endfunction

function [wc, iw] = sopi_worstClass(args)
    wc = args(1).class
    iw = 1
    for i =2:length(args)
        [wc,kw] = sopi_sortClasses(wc, args(i).class)
        if kw == 2 then 
            iw = i
        end 
    end
endfunction

function [c, iw, ib] = sopi_sortClasses(c1, c2)
    c   = []
    iw  = []
    ib  = []
    //
    if c1.level < c2.level then
        c   = c2.level
        iw = 2
        ib = 1
    elseif c1.level > c2.level
        c   = c1.level
        iw  = 1
        ib  = 2
    else  // equal level
        if c1.curv == c2.curv then 
            // same curvature
            c = c1
            iw = 1
            ib = 2
        end
    end
    
endfunction

