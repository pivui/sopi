function [A, b] = sopi_getLinearMappingMatrices(var, p, ids, L, R, B)
    [m,n] = size(var)
    A       = zeros(m*n, p.nvar)
    for k = 1:m
        for l = 1:n 
            //
            t = (l-1) *m + k
            for i = 1:length(ids)
                // ek' * L(t) * X(it) * R(t) * el
                idxVari         = sopi_varIdxInPb(p, vList(ids(i)))
                A(t,idxVari)    = A(t, idxVari)  + kron(R(i)(:,l)', L(i)(k,:))
            end
        end
    end
    b = B(:)
endfunction
