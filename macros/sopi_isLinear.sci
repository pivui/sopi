function out = sopi_isLinear(var)
    out = var.class.type == 'poly' & var.class.order == 1
endfunction
