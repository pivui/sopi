function c = sopi_classRules(operator, var)
    c = sopi_class('nl')
    select (operator)
    case ('sum')
        // something else
        wc = sopi_worstClass(var.child)
        if isempty(wc) then 
            return
        end
        if wc.type == 'poly' & wc.order == 2 then 
            var.class = wc
            // test convexity
            wc.curv = sopi_testQuadConvexity(var)
        end
        c = wc
    case ('mul')
        v1 = var.child(1)
        v2 = var.child(2)
        // constant * linear -> linear
        if sopi_isConstant(v1) & sopi_isLinear(v2) | ... 
            sopi_isConstant(v2) & sopi_isLinear(v1) then
            c = sopi_sortClasses(v1.class, v2.class)
            return
        end
        // constant * convex | concave -> depends on the sign
        if sopi_isConstant(v1) & (sopi_isConvex(v2) | sopi_isConcave(v2)) | ...
            sopi_isConstant(v2) & (sopi_isConvex(v1) | sopi_isConcave(v1)) then
            [c, iw, ib]     = sopi_sortClasses(v1.class, v2.class)
            s               = sign(var.child(ib).child(1)) >= 0
            if and(~s) then 
                // change curvature
                // negative constant * convex|concave => concave|convex
                c.curv  = -c.curv
            end
            return
        end
        [op, rs] = sopi_onlyPolys(var.child)
        if op then 
            c = sopi_class('poly',sum(rs), %inf)
            if sum(rs) == 2 then 
                var.class = c //
                // test convexity
                wc.curv = sopi_testQuadConvexity(var)
            end
        end

    case {'max','abs'}
        args = var.child
        [wc, iw] = sopi_worstClass(args)
        if isempty(wc)
            return
        end
        v = args(iw)
        if sopi_isLinear(v) |sopi_isConvexPWA(v) then 
            c = sopi_class('pwpoly',1,2)
            return
        end
        c = sopi_classRules('ndconvexFun', var)
    case ('ndconvexFun')
        args = var.child
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
        args = var.child
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
        args = var.child(2)
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
        lhs = var.lhs
        if sopi_isLinear(lhs) | sopi_isConvex(lhs) then 
            c   = lhs.class
        end
    case '='
        lhs = var.lhs
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
        c   = c2
        iw = 2
        ib = 1
        return
    elseif c1.level > c2.level
        c   = c1
        iw  = 1
        ib  = 2
        return
    end  
    // equal level, seek finer elements of comparison
    if c1.type == 'poly' & c2.type == 'poly' then
        r1          = c1.order
        r2          = c2.order 
        if c1.order > c2.order  then 
            c = c1 
            iw = 1
            ib = 2
        else 
            c = c2
            iw = 2
            ib = 1
        end
        return
    end
    if c1.curv == c2.curv then 
        // same curvature
        c = c1
        iw = 1
        ib = 2
    end
endfunction

function [op, rs] = sopi_onlyPolys(vars)
    op = %T
    rs = []
    for i = 1:length(vars)
        op = op & sopi_isPoly(vars(i))
        if ~op then 
            return 
        end
        rs(i) = sopi_polyOrder(vars(i))
    end

endfunction

function outCurv = sopi_testQuadConvexity(var)
    p = sopi_problem()
    p = sopi_addVarsToPb(p, sopi_depends(var))
    qm = sopi_getQuadraticMapping(var, p)
    psd = %T     
    nsd = %T       
    for i = 1:length(qm.Q)
        Qi = full(qm.Q(i))
        ev = spec(Qi)
        psd = psd & min(ev) >= 0
        nsd = nsd & max(ev) <= 0
    end
    if psd then
        outCurv = 2
        return
    end
    if nsd then
        outCurv = -2
        return
    end
    outCurv = %inf
    
endfunction
