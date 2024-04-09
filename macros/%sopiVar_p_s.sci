function newVar = %sopiVar_p_s(var, s)
    if s == 1 then
        newVar = var
    end
    if s < 0 || abs(round(s) - s) ~= 0 then
        error('not yet implemented')
    end
    // 
    newVar = var
    for i = 1:s-1
        newVar = newVar * var 
    end
endfunction
