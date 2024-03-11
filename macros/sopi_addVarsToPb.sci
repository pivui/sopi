function p = sopi_addVarsToPb(p, vars)
    pid = p.varsId
    for v = vars
        if and(v.id_ ~= pid) then
            nvar            = size(v,'*')
            p               = sopi_increasePbNvars(p, nvar)
            p.vars($+1)     = v
            p.varsId($+1)   = v.id_
            p.varIdx($+1)   = max(p.varsIdx($)) + (1:nvar)
            //
            pid             = p.varsId
        end
    end
endfunction

function p = sopi_increasePbNvars(p, inc)
    p.nvar = p.nvar + inc
    // TODO update constraints
endfunction
