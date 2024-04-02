function c = sopi_class(cname, varargin)
    c           = struct()
    c.type      = cname
    c.level     = %inf
    c.curv      = %inf // by default, nonconvex
    select cname 
    case 'poly'
        c.level     = 0
        c.order     = varargin(1)
        if c.order <= 1 then
            c.curv = 2
            return
        end    
        if length(varargin) == 2 then 
            c.curv = varargin(2)
        end
    case 'pwpoly'
        c.level  = 1
        c.order = varargin(1)
        if length(varargin) == 2 then 
            c.curv = varargin(2)
        end
    case 'nl'
        // generic nonlinear class
        if length(varargin) == 1 then 
            c.curv = varargin(1)
        end
    else

        error('Unknown class')
    end
endfunction
