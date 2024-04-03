function [out, r] = sopi_isPoly(var)
    out = var.class.type == 'poly'
    if out  then
        r = var.class.order
    end
endfunction
