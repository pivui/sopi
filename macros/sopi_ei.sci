function e = sopi_ei(n, i, sp)
    if argn(2) < 3 then
        sp = %F
    end
    if ~sp then
        e       = zeros(n,1)
        e(i)    = 1
    else
        e = sparse([i,1],1,[n,1])
    end

endfunction
