function out = %s_s_sopiVar(b, var)
    if isempty(b) | norm(b)<= %eps then
        out = -var
        return
    end
    bvar    = sopi_constant(b)
    out     =  bvar - var
endfunction
