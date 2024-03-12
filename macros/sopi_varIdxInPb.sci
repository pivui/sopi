function idx = sopi_varIdxInPb(p, var)
    idx = p.varsIdx(var.id_ == p.varsId)
endfunction
