function [n,nlayers] = sopi_countLeafs(var,n, nlayers)
    if argn(2) == 1 then
        n = 0
        nlayers = 1
    end
    nlayers = nlayers + 1
    select var.operator
    case {'constant','none'}
        n = n+1
    case 'sum'
        nl = []
        for i =1:length(var.child)
            [n,nl(i)] = sopi_countLeafs(var.child(i),n,0)
        end
        nlayers = nlayers + max(nl)
    case 'mul'
        [n, n1] = sopi_countLeafs(var.child(1),n, 0)
        [n, n2] = sopi_countLeafs(var.child(2),n, 0)
        nlayers = nlayers + max(n1,n2)
    case 'fun'
        for i =1:length(var.child)
            [n, nlayers] = sopi_countLeafs(var.child(i),n, nlayers)
        end
    end
endfunction
