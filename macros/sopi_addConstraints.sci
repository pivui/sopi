function p = sopi_addConstraints(p, cList)
    for c = cList
        if sopi_isLinear(c)
            p = sopi_addLinearConstraint(p, c)
        end
    end
endfunction


function p = sopi_addLinearConstraint(p, c)
    vars    = sopi_depends(c.lhs)
    p       = sopi_addVarsToPb(p, vars)
    if c.operator == '<=' then
    elseif c.operator == '='

    end
    //   if c.lhs.isElementary then // bound
    //      if c.type == GREATER_THAN then
    //         LB          = p.lb;
    //         varIdx      = p.getVarIdx(vars(1));
    //         LB(varIdx)  = c.rhs;
    //         sopi_setVar(p,"lb",LB);
    //      elseif c.type == LESSER_THAN then
    //         UB          = p.ub;
    //         varIdx      = p.getVarIdx(vars(1));
    //         UB(varIdx)  = c.rhs;
    //         sopi_setVar(p,"ub",UB);
    //      end
    //   else
    //      [ai,bi]     = sopi_extractLinearConstraintMatrices(p,c.lhs);
    //      rhs         = c.rhs-bi;
    //      if c.type == EQUALS then
    //         Aeq     = [p.Aeq;ai];
    //         beq     = [p.beq;rhs];
    //         sopi_setVar(p,"Aeq",Aeq);
    //         sopi_setVar(p,"beq",beq);
    //      elseif c.type == LESSER_THAN then
    //         A       = [p.A;ai];
    //         b       = [p.b;rhs];
    //         sopi_setVar(p,"A",A);
    //         sopi_setVar(p,"b",b);
    //      elseif c.type == GREATER_THAN then
    //         A       = [p.A;-ai];
    //         b       = [p.b;-rhs];
    //         sopi_setVar(p,"A",A);
    //         sopi_setVar(p,"b",b);
    //      end
    //   end
endfunction

function [e, b] = sopi_isElementary(var, bin)
    e   = %f 
    b   = []
    select var.operator 
    case 'none'
        e = %t
        if argn(2) > 1 
            b = bin 
        end
    case 'sum'
        if length(var.child) > 2 then 
            e = %f
            return
        end 
        t = [sopiVar_isConstant(var.child(1)),sopiVar_isConstant(var.child(2))]
        if or(t) then 
            ib      = find(t)
            ie      = find(~t)
            [e, b] = sopi_isElementary(var.child(ie), var.child(ib))
        end 
    case 'llm'
        if issquare(var.child(1)) & det(var.child(1)) > 1e-10 then
            e = %t 
            b = A\bin
        end 
    case 'rlm'
        if issquare(var.child(1)) & det(var.child(1)) > 1e-10 then
            e = %t
            b = A/bin
        end
    end
endfunction
