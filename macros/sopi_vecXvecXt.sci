function P = sopi_vecXvecXt(m,n)
    // P is such that vec(X')  = P * vec(X)
    P = 0
    for i = 1:m
        ei = sopi_ei(m,i,1)
        for j = 1:n
            ej = sopi_ei(n,j,1)
            Eji = ej*ei'
            P = P + kron(Eji',Eji)
        end
    end
endfunction
