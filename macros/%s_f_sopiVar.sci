function newVar = %s_f_sopiVar(b, var)
    if isempty(b) then
        newVar = var
        return
    end
    bvar    = sopi_constant(b)
    newVar  = [bvar; var]
endfunction
