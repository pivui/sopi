// A * sopiVar .................................................................
// performs a left matrix multiplication between a matrix and a sopiVar.
function newVar = %sopiVar_m_s(var, A)
    if isempty(A) then
        error('Cannot multiply by empty matrix')
    end
    // check sizes
    ns              = sopi_checkSizeCoherence('mul', var.size, size(A))
    if norm(A) < %eps then
        newVar = sopi_constant(zeros(ns(1),ns(2)))
        return
    end
//    if issquare(A) & norm(A - eye(size(A,1),size(A,1)))<%eps then
//        newVar = var
//        return
//    end
    //
    Avar            = sopi_constant(A)
    if isscalar(A) then
        // scalar on the left...
        newVar          = Avar * var
    else 
        newVar          = var * Avar 
    end

endfunction
