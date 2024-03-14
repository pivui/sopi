// trace .......................................................................
// computes the trace of a sopiVar
function newVar = %sopiVar_trace(var)
    if isscalar(var) then
        newVar = var
        return
    end
    if var.size(1) == var.size(2) then
        n        = size(var)
        newVar   = var(1,1)
        for i = 2:n
            newVar = newVar + var(i,i)
        end
    else
        error("Trace can only be applied to square matrices.")
    end
endfunction
