function out = sopi_isQuadratic(var)
    out = var.class.type == "poly" & var.class.order == 2
endfunction
