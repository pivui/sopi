function newVar = %sopiVar_s(var)
    if sopi_isConstant(var) then
        newVar = var
        newVar.child(1) = -newVar.child(1)
        return
    end
    newVar = (-1) * var
endfunction
