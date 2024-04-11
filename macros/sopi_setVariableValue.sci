function p = sopi_setVariableValue(p, var, value)
    //
    if size(var,1) ~= size(value,1) | size(var,2) ~= size(value,2) then
        error('Size of variable does not match assigned value')
    end
    //
    vecValue    = value(:)
    idx         = sopi_varIdxInPb(p, var)
    //
    lb          = p.lb
    ub          = p.ub
    //
    if or(lb(idx) > vecValue) | or(ub(idx) < vecValue) then 
        error('Assigned value does not respect variable lower/upper bounds')
    end
    p.lb(idx) = vecValue
    p.ub(idx) = vecValue 
endfunction
