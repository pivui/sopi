function newVar = %sopiVar_f_sopiVar(var1, var2)
    [m1, n1]    = size(var1)
    [m2, n2]    = size(var2)
    ns          = sopi_checkSizeCoherence('vcat', var1.size, var2.size)
    //
    L1          = [eye(m1,m1); zeros(m2,m1)]
    L2          = [zeros(m1,m2); eye(m2,m2)]
    newVar      = L1 * var1  + L2 * var2 
endfunction
