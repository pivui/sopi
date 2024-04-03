function out = sopi_getQuadraticMapping(var, p)
    if sopi_polyOrder(var)~=2 then
        error('Cannot extract quadratic mapping from variable which is not quadratic.')
    end
    Qij     = list()
    QL      = list()
    QM      = list()
    QR      = list()
    L       = list()
    R       = list()
    B       = zeros(size(var,1),size(var,2))
    vList   = sopi_depends(var)
    for i = 1:length(vList)
        L($+1) = 0
        R($+1) = 0
    end
    // Decompose var as :
    // SUM_ij QL(i,j) * X(i) * QM(i,j) * X(j) * QR(i,j) + SUM_i L(i) * X(i) * R(i) + B
    // 
    [Qij, QL,QM,QR,L,R,B] = sopi_getQuadraticMapping_(var, vList,Qij, QL,QM,QR,L,R,B)
    if argn(2) == 1 then
        out.QL   = QL
        out.QM   = QM
        out.QR   = QR 
        out.Qij  = Qij
        out.L    = L 
        out.R    = R
        out.B    = B
        out.vars = vList
    else
        [m,n]   = size(var)
        // Work element by element
        // ek' * var * el
        Q       = list()
        A       = sparse([],[],[size(var,'*'), p.nvar])
        for k = 1:m
            for l = 1:n
                t       = (l-1) *m + k
                // Linear term
                for i = 1:length(L)
                    // ek' * L(i) * X(i) * R(i) * el
                    idxi        = sopi_varIdxInPb(p, vList(i))
                    A(t,idxi) = A(t,idxi) + sparse(kron(R(i)(:,l)', L(i)(k,:)))
                end
                // Quadratic term 
                Q($+1)  = sparse([],[],[p.nvar, p.nvar])
                for iq = 1:length(Qij)
                    i       = Qij(iq)(1)
                    j       = Qij(iq)(2)
                    idxi    = sopi_varIdxInPb(p, vList(i))
                    idxj    = sopi_varIdxInPb(p, vList(j))
                    // QL(i,j) * X(i) * QM(i,j) * X(j) * QR(i,j)
                    [mj,nj] = size(vList(j))
                    Imj     = eye(mj,mj)
                    //  ek' * QLi * Xi * QMij * Xj * QRj * el
                    Q($)(idxi, idxj) = Q($)(idxi, idxj) + ...
                    sparse(kron(QM(iq),QL(iq)(k,:)') * kron(QR(iq)(:,l)',Imj))
                end
                Q($) = 1/2 * (Q($) + Q($)')
            end
        end
        // + B
        out.Q = Q
        out.A = A
        out.b = B(:)
    end
endfunction

function [Qij,QL,QM,QR,L,R,B] = sopi_getQuadraticMapping_(var, vList, Qij,QL, QM, QR, L, R, B)
    n   = length(vList)
    select var.operator
    case 'none'
        [inList, i] = sopi_varInList(var, vList)
        [m, n]      = size(var)
        L(i)        = L(i) + eye(m, m)
        if norm(R(i)) == 0 then
            R(i)        = eye(n, n)
        end
    case 'sum'
        for i = 1:length(var.child)
            [Qij,QL,QM,QR,L,R,B] = sopi_getQuadraticMapping_(var.child(i), vList, Qij, QL, QM, QR, L, R, B)
        end
    case 'llm'
        A                   = var.child(1)
        nextVar             = var.child(2)
        Bi                  = zeros(size(nextVar,1),size(nextVar,2))
        Li                  = list()
        QLi                 = list()
        for i = 1:n
            Li($+1) =0
        end
        [Qij, QLi,QM,QR,Li,R,Bi] = sopi_getQuadraticMapping_(nextVar, vList, Qij, QLi, QM, QR, Li, R, Bi)
        //
        for i = 1:n 
            if norm(Li(i)) >%eps then 
                L(i)    = L(i) + A * Li(i)
            end 
        end 
        for i = 1:length(QLi)
            QL($+1) = A * QLi(i)
        end
        B = B + full(A * Bi)
    case 'rlm'
        A                   = var.child(1)
        nextVar             = var.child(2)
        Bi                  = zeros(size(nextVar,1),size(nextVar,2))
        Ri = list()
        QRi = list()
        for i = 1:n
            Ri($+1) = 0
        end
        [QL,QM,QRi,L,Ri,Bi] = sopi_getQuadraticMapping_(nextVar, vList, QL, QM, QRi, L, Ri, Bi)
        //
        //
        for i = 1:n 
            if norm(Ri(i)) >%eps then 
                R(i)    = R(i) +  Ri(i) * A
            end 
        end 
        for i = 1:length(QRi)
            QR($+1) = QRi(i)*A
        end
        B = B + full(Bi * A)
    case 'mul'
        lm1 = sopi_getLinearMapping(var.child(1), vList)
        lm2 = sopi_getLinearMapping(var.child(2), vList)
        // (B1 + SUM_i L1(i) * X(i) * R1(i) ) *  (B2 + SUM_j L2(j) * X(j) * R2(j) ) 
        //
        // Constant term
        B   = B + lm1.B * lm2.B
        for i = 1:n
            // Linear terms
            // B1 * SUM_i L2(i) * X(i) * R2(i)
            Li = lm1.B * lm2.L(i) 
            if norm(Li)> %eps then 
                L(i) = L(i) + lm1.B * lm2.L(i)
                R(i) = R(i) + lm2.R(i)
            end
            // (SUM_i L1(i) * X(i) * R1(i) )* B2
            Ri = lm1.R(i) * lm2.B
            if norm(Ri) > %eps then
                L(i) = L(i) + lm1.L(i)
                R(i) = R(i) + Ri
            end
        end
        // Quadratic terms 
        for i = 1:n 
            if norm(lm1.L(i)) > %eps then 
                for j = 1:n 
                    if norm(lm2.L(j)) > %eps then 
                        Qij($+1)    = [i,j]
                        QL($+1)     = lm1.L(i)
                        QR($+1)     = lm2.R(j)
                        QM($+1)     = lm1.R(i) * lm2.L(j)
                    end
                end
            end
        end 

    end
endfunction
