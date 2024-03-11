// A * sopiVar .................................................................
// performs a left matrix multiplication between a matrix and a sopiVar.
function newVar = %s_m_sopiVar(A,var)
    if isempty(A) then
        error('Cannot multiply by empty matrix')
    end
    // check sizes
    ns              = sopi_checkSizeCoherence('mul', size(A), var.size)
    //
    Avar            = sopi_constant(A)
    newVar          = Avar * var
endfunction

