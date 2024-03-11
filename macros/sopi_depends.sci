function vList = sopi_depends(var)
    if typeof(var) == 'sopiCst' then
        var = var.lhs
    end
    vList = list()
    if var.operator == 'none' then
        vList(1) = var
    else
        select var.operator
        case {'llm','rlm'}
            vList = sopi_depends(var.child(2))
        case 'sum'
            for v = var.child
                vList = lstcat(vList, sopi_depends(v))
            end
        end
    end
endfunction
