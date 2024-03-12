function p = sopi_addConstraints(p, cList)
    for c = cList
        if sopiVar_isLinear(c)
            p = sopi_addLinearConstraint(p, c)
        end
    end
endfunction


function p = sopi_addLinearConstraint(p, c)
    vars    = sopi_depends(c.lhs)
    p       = sopi_addVarsToPb(p, vars)
    // A * x <op> b
    [A, b]  = sopi_extractLinearMatrices(p, c.lhs) 
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

