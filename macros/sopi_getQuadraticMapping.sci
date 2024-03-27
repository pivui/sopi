function qm = sopi_getQuadraticMapping(var, p)
    if sopi_polyOrder(var)>2 then
        error('Cannot extract quadratic mapping from variable which is not quadratic.')
    end
    QL          = list()
    QM          = list()
    QR          = list()
    L           = list()
    R           = list()
    B           = zeros(size(var,1),size(var,2))
    vList       = sopi_depends(var)
    for i = 1:length(vList)
        L($+1) = 0
        R($+1) = 0
    end
endfunction
