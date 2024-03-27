function [out, idx] = sopi_varInList(var, vList)
    out = %F
    idx = []
    for i = 1:length(vList)
        v = vList(i)
        if var.id_ == v.id_
            out = %T
            idx = i
            return
        end
    end
endfunction
