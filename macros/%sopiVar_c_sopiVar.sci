function newVar = %sopiVar_c_sopiVar(var1, var2)
    [m1, n1]    = size(var1)
    [m2, n2]    = size(var2)
    
    ns          = sopi_checkSizeCoherence('hcat', var1.size, var2.size)
    //
    R1          = [eye(n1,n1), zeros(n1,n2)]
    R2          = [zeros(n2,n1), eye(n2,n2)]
    newVar      = var1 * R1 + var2 * R2
endfunction
