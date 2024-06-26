function p = sopi_addConstraints(p, cList)
    for c = cList
        if sopi_isLinear(c)
            p   = sopi_addLinearConstraint(p, c)
        elseif sopi_isConvexPWA(c)
            [newVar, newCons]   = sopi_convexPWA2Linear(c.lhs, list())
            p                   = sopi_addVarsToPb(p, sopi_depends(newVar))
            p                   = sopi_addConstraints(p, lstcat(newVar <= 0, newCons))
        else
            //
        end
    end
endfunction

function [newVar, newC] = sopi_convexPWA2Linear(var, newC)
    if sopi_isConstant(var) | sopi_isLinear(var) then
        newVar  = var 
        return 
    end
    //
    select var.operator 
    case 'mul'
        [newV1, newC]   = sopi_convexPWA2Linear(var.child(1), newC)
        [newV2, newC]   = sopi_convexPWA2Linear(var.child(2), newC)
        newVar          = newV1 * newV2
    case 'sum'
        [newVar,newC]  =  sopi_convexPWA2Linear(var.child(1), newC)
        for i = 2:length(var.child)
            [newVi,newC]    =  sopi_convexPWA2Linear(var.child(i), newC)
            newVar          = newVar + newVi
        end
    case 'fun'
        select var.subop
        case 'abs'
            [m, n]          = size(var)
            slackVar        = sopi_var(m, n)
            [newV, newC]    = sopi_convexPWA2Linear(var.child(1), newC)
            newC($+1)       =  slackVar >= 0 
            newC($+1)       =  slackVar >= newV
            newC($+1)       = -slackVar <= newV
            newVar          =  slackVar
        case 'max'
            slackVar = sopi_var(1)
            for i = 1:length(var.child)
                [newVi, newC]  = sopi_convexPWA2Linear(var.child(i), newC)
                newC($+1)       = newVi <= slackVar
            end
            newVar = slackVar
        end
    end
endfunction

function p = sopi_addLinearConstraint(p, c)
    vars    = sopi_depends(c.lhs)
    p       = sopi_addVarsToPb(p, vars)
    // A * x + b <op> 0
    lm  = sopi_getLinearMapping(c.lhs, [], p)
    A   = lm.A
    b   = -lm.b
    // test if constraint is elementary 
    [e, alpha, idx] = sopi_isElementary(A)
    if e then
        lb = p.lb
        ub = p.ub
        select c.operator
        case '<='
            for i = 1:length(alpha)
                // TODO check if associated LB/UB is already affected
                if alpha(i)>0 then
                    // upper bound 
                    ub(idx(i)) = b(i)/alpha(i)
                else
                    // lower bound 
                    lb(idx(i)) = b(i)/alpha(i)
                end
            end
        case '='
            for i = 1 :length(alpha)
                ub(idx(i)) = b(i)/alpha(i)
                lb(idx(i)) = b(i)/alpha(i)
            end
        end
        p.lb = lb
        p.ub = ub
        return
    end
    // At this point, the constraint is not elementary 
    select c.operator
    case '<='
        p.A = [p.A;A]
        p.b = [p.b; b]
    case '='
        p.Ae = [p.Ae;A]
        p.be = [p.be;b]
    end

endfunction

function [e, alpha, idx] = sopi_isElementary(A)
    e       = %f 
    alpha   = []
    idx     = []
    for i = 1:size(A,1)
        tmp         = find(abs(A(i,:))>0)
        if length(tmp) > 1
            return
        end
        idx(i)   = tmp
        alpha(i) = A(i,tmp)
    end
    e = %t
endfunction

