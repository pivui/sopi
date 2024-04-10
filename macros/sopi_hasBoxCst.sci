

function out = sopi_hasBoxCst(p)
    out = or(p.lb>-%inf) & or(p.ub<%inf)
endfunction
