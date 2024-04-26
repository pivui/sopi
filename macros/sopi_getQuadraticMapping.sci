function out = sopi_getQuadraticMapping(var, p)
    if sopi_polyOrder(var)~=2 then
        error('Cannot extract quadratic mapping from variable which is not quadratic.')
    end
    B       = zeros(size(var,1),size(var,2))
    vList   = sopi_depends(var)
    //
    [qids, QL, QM, QR, lids, L,R,B] = sopi_getQuadraticMapping_(var, vList,list(), list(), list(),list(),...
    list(), list(), list(),B) 
    // 
    if argn(2) == 1 then
        out.QL      = QL
        out.QM      = QM
        out.QR      = QR 
        out.idq     = qids
        out.idl     = lids
        out.L       = L 
        out.R       = R
        out.B       = B
        out.vars    = vList
    else
        [A, b]  = sopi_getLinearMappingMatrices(var, p, lids, L, R, B)
        out.A   = A
        out.b   = b
        // Quadratic term 
        [m, n]  = size(var)
        Q       = list()
        for k = 1:m
            for l = 1:n 
                t = (l-1) *m + k
                Q($+1)  = sparse([],[],[p.nvar, p.nvar])
                for q = 1:length(qids)
                    i       = qids(q)(1)
                    j       = qids(q)(2)
                    idxi    = sopi_varIdxInPb(p, vList(i))
                    idxj    = sopi_varIdxInPb(p, vList(j))
                    [mj,nj] = size(vList(j))
                    Imj     = eye(mj, mj)
                    //  ek' * QLi * Xi * QMij * Xj * QRj * el
                    Q($)(idxi, idxj) = Q($)(idxi, idxj) + ...
                    sparse(kron(QM(q),QL(q)(k,:)') * kron(QR(q)(:,l)',Imj))
                end
                Q($) = 1/2 * (Q($) + Q($)')
            end
        end
        out.Q = Q;
    end
endfunction

function [qids,QL,QM,QR,lids,L,R,B] = sopi_getQuadraticMapping_(var, vList, qids, QL, QM, QR, lids, L, R, B)
    select var.operator
    case 'sum'
        for i = 1:length(var.child)
            [qids,QL,QM,QR,lids,L,R,B] = sopi_getQuadraticMapping_(var.child(i), vList, qids, QL, QM, QR,...
            lids, L, R, B)
        end
    case 'mul'
        r1 = sopi_polyOrder(var.child(1))
        r2 = sopi_polyOrder(var.child(2))
        if r1 <= 1 & r2 <= 1 then
            // multiplication of two linear mappings  
            lm1 = sopi_getLinearMapping(var.child(1), vList)
            lm2 = sopi_getLinearMapping(var.child(2), vList)
            // Constant term
            B   = B + lm1.B * lm2.B
            // (L1 * X1 * R1 ) * B2
            for i = 1:length(lm1.ids)
                L($+1)      = lm1.L(i)
                R($+1)      = lm1.R(i) * lm2.B
                lids($+1)   = lm1.ids(i)
            end
            // B1 * (L2 * X2 * R2)
            for i = 1:length(lm2.ids)
                L($+1)      = lm1.B * lm2.L(i)
                R($+1)      = lm2.R(i)
                lids($+1)   = lm2.ids(i)
            end
            //
            for i = 1:length(lm1.ids)
                for j = 1:length(lm2.ids)
                    qids($+1)   = [lm1.ids(i), lm2.ids(j)]
                    QL($+1)     = lm1.L(i)
                    QR($+1)     = lm2.R(j)
                    QM($+1)     = lm1.R(i) * lm2.L(j)
                end
            end
        else
            // multiplication of a constant with a quadratic mapping
            if r1 < r2 then 
                B1 = var.child(1).child(1)
                nq = length(qids)
                nl = length(lids)
                B2 = zeros(size(var.child(2),1), size(var.child(2),2))
                [qids,QL,QM,QR,lids,L,R,B2] = sopi_getQuadraticMapping_(var.child(2), vList, qids, QL, QM, QR, lids, L, R, B2)
                for i = nq+1:length(qids)
                    QL(i) = B1 * QL(i)
                end
                for i = nl+1:length(lids)
                    L(i) = B1 * L(i)
                end
                B = B + B1 * B2
            else 
                B2 = var.child(2).child(1)
                nq = length(qids)
                nl = length(lids)
                B1 = zeros(size(var.child(1),1), size(var.child(1),2))
                [qids,QL,QM,QR,lids,L,R,B1] = sopi_getQuadraticMapping_(var.child(1), vList, qids, QL, QM, QR, lids, L, R, B1)
                for i = nq+1:length(qids)
                    QR(i) = QR(i) * B2
                end
                for i = nl+1:length(lids)
                    R(i) = R(i) * B2
                end
                B = B + B1 * B2
            end
        end
    end
endfunction
