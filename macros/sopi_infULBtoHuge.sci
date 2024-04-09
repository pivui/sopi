function [lb,ub] = sopi_infULBtoHuge(pb)
      lb                   = pb.lb
      ub                   = pb.ub
      lb(lb == -%inf)      = -number_properties('huge') // as advised in the help...
      ub(ub == %inf)       = number_properties('huge')
endfunction
