function p = sopi_addVarsToPb(p, vars)
    pid = p.varsId
    for vi = vars
        vList = sopi_depends(vi)
        for v = vList
            if and(v.id_ ~= pid) then
                nvar            = size(v,'*')
                p               = sopi_increasePbNvars(p, nvar)
                p.vars($+1)     = v
                p.varsId($+1)   = v.id_
                p.varsIdx($+1)  = 1:nvar
                if length(p.varsIdx)>1 then
                    p.varsIdx($) = p.varsIdx($) + max(p.varsIdx($-1))
                end
                //
                pid             = p.varsId
            end
        end
    end
endfunction

function p = sopi_increasePbNvars(p, inc)
    // nvar
    p.nvar  = p.nvar + inc
    // ub and lb 
    p.ub    = [p.ub; %inf * ones(inc,1)]
    p.lb    = [p.lb;-%inf * ones(inc,1)]
    //
    p.c  = [p.c;zeros(inc,1)]
    // 
    p.A = [p.A,sparse([],[],[size(p.A,1), inc])]
    //
    p.Ae = [p.Ae,sparse([],[],[size(p.Ae,1), inc])]
endfunction
