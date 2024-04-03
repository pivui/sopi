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
        for i =1:length(var.child)
            n = sopi_countLeafs(var.child(i),n)
        end
    case 'mul'
        [n, nlayers] = sopi_countLeafs(var.child(1),n, nlayers)
        [n, nlayers] = sopi_countLeafs(var.child(2),n, nlayers)
    case 'fun'
        for i =1:length(var.child)
            [n, nlayers] = sopi_countLeafs(var.child(i),n, nlayers)
        end
    end
endfunction
