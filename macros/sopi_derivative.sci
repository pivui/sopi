function J = sopi_derivative(var, x)
    [me, ne]    = size(var)
    [ms, ns]    = size(x)
    // J = d vec(var)/ d vec(x)
    J           = zeros(me*ne, ms*ns) 
    //
    select var.operator
    case 'none'
        if var.id_ == x.id_ then
            J = eye(me*ne, ms*ns)
        end
    case 'sum'
        for i = 1:length(var.child)
            Ji = sopi_derivative(var.child(i), x)
            J = J + Ji 
        end
    case 'mul'
        v1          = var.child(1)
        [m1,n1]     = size(v1)
        v2          = var.child(2)
        [m2, n2]    = size(v2)
        J1          = sopi_derivative(v1, x)
        J2          = sopi_derivative(v2, x)
        v1vec       = sopi_vec(v1)
        v2vec       = sopi_vec(v2)
        for k = 1:me
            ek = sopi_ei(m1, k, %T)
            Ik = speye(n1,n1)
            for l = 1:ne
                el  = sopi_ei(n2, l, %T)
                Il  = speye(m2,m2)
                Mkl = kron(Ik, ek) * kron(el', Il)
                //
                t   = (l-1) *m1 + k
                et  = sopi_ei(me*ne, t, %T)
                //
                J   = J + et * (v1vec' * Mkl * J2 + v2vec'*Mkl'*J1)
            end
        end
    end
endfunction
