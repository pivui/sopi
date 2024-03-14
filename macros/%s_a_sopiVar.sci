// sopiVar + b .................................................................
// add a sopiVar to a matrix.
function newVar = %s_a_sopiVar(b,var)
    if isempty(b) | norm(b) <= %eps then
        newVar = var
        return
    end
    bvar    = sopi_constant(b)
    newVar  = var + bvar
endfunction
