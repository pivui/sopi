function vList = sopi_depends(var)
    if typeof(var) == 'sopiCst' then
        var = var.lhs
    end
    vList = list()

    select var.operator
    case 'none' 
        vList(1) = var
    case {'fun','sum'}
        for v = var.child
            vList = sopi_varsUnion(vList, sopi_depends(v))
        end
    case 'mul'
        vList = sopi_varsUnion(sopi_depends(var.child(1)), sopi_depends(var.child(2)))
    end
endfunction
