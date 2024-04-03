function out = sopi_isConvex(var)
    out = var.class.curv == 2
          var.class.type == 'poly' & var.class.order <= 1
endfunction
