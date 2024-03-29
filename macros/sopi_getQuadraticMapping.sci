function out = sopi_getQuadraticMapping(var, p)
    if sopi_polyOrder(var)>2 then
        error('Cannot extract quadratic mapping from variable which is not quadratic.')
    end
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
        QL($+1) = 0
        QR($+1) = 0
        QM($+1) = list()
        for j = 1:length(vList)
            QM($)($+1) = 0
        end
    end
    // Decompose var as :
    // SUM_ij QL(i) * X(i) * QM(i,j) * X(j) * QR(j) + SUM_i L(i) * X(i) * R(i) + B
    // 
    [QL,QM,QR,L,R,B] = sopi_getQuadraticMapping_(var, vList, QL,QM,QR,L,R,B)
    if argn(2) == 1 then
        out.QL   = QL
        out.QM   = QM
        out.QR   = QR 
        out.L    = L 
        out.R    = R
        out.B    = B
        out.vars = vList
    end
endfunction

function [QL,QM,QR,L,R,B] = sopi_getQuadraticMapping_(var, vList, QL, QM, QR, L, R, B)
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
            [QL,QM,QR,L,R,B] = sopi_getQuadraticMapping_(var.child(i), vList, QL, QM, QR, L, R, B)
        end
    case 'llm'
        A                   = var.child(1)
        nextVar             = var.child(2)
        Bi                  = zeros(size(nextVar,1),size(nextVar,2))
        Li                  = list()
        QLi                 = list()
        for i = 1:n
            Li($+1) = 0
            QLi($+1) = 0
        end
        [QLi,QM,QR,Li,R,Bi] = sopi_getQuadraticMapping_(nextVar, vList, QLi, QM, QR, Li, R, Bi)
        //
        ivL                 = sopi_depends(var.child(2))
        for v = ivL
            [dummy, i]      = sopi_varInList(v, vList)
            L(i)            = L(i)  + A * Li(i)
            QL(i)           = QL(i) + A * QLi(i)
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
            QRi($+1) = 0
        end
        [QL,QM,QRi,L,Ri,Bi] = sopi_getQuadraticMapping_(nextVar, vList, QL, QM, QRi, L, Ri, Bi)
        //
        ivL                 = sopi_depends(nextVar)
        for v = ivL
            [dummy, i]      = sopi_varInList(v, vList)
            R(i)            = R(i) + Ri(i) * A
            QR(i)           = QR(i) + QRi(i) * A
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
            L(i) = L(i) + lm1.B * lm2.L(i)
            R(i) = R(i) + lm2.R(i)
            // (SUM_i L1(i) * X(i) * R1(i) )* B2
            L(i) = L(i) + lm1.L(i)
            R(i) = R(i) + lm1.R(i) * lm2.B
            // Quadratic terms 
            // ( SUM_i L1(i) * X(i) * R1(i) ) *  (SUM_j L2(j) * X(j) * R2(j) 
            QL(i) = QL(i) + lm1.L(i)
            QR(i) = QR(i) + lm2.R(i)
            for j = 1:n
                QM(i)(j) = QM(i)(j) + lm1.R(i) * lm2.L(j)
            end
        end
    end
endfunction
