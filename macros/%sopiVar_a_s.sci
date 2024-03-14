// sopiVar + b .................................................................
// add a sopiVar to a matrix.
function newVar = %sopiVar_a_s(var,b)
    if isempty(b) | norm(b)<= %eps then
        newVar = var
        return
    end
    bvar    = sopi_constant(b)
    newVar  = var + bvar
endfunction
