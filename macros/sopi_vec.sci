function newVar = sopi_vec(var)
    if isscalar(var) then
        newVar = var
        return
    end
    [m,n] = size(var)
    if n==1 then
        newVar = var
        return
    end 
    //
    newVar = zeros(m*n,1)
    for k = 1:m
        for l = 1:n
            t       = (l-1) *m + k
            e       = zeros(m*n,1)
            e(t)    = 1
            newVar = newVar + var(k,l) * e 
        end
    end
endfunction
