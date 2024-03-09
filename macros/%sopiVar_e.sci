function out = %sopiVar_e(varargin)
    var = varargin($)
    if argn(2) > 3 then
        error('Unsupported extraction in sopiVar')
    elseif argn(2) == 3
        i = varargin(1)
        j = varargin(2)
    else
        i = varargin(1)
        j = 1
    end
    m   = var.size(1)
    n   = var.size(2)
    L   = eye(m)
    R   = eye(n)
    out = L(i,:) * var * R(:,j)
endfunction
