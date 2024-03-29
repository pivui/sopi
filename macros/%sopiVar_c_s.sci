function newVar = %sopiVar_c_s(var, b)
    if isempty(b) then
        newVar = var
        return
    end
    bvar    = sopi_constant(b)
    newVar  = [var, bvar]
endfunction
