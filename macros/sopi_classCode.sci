function funClass = sopi_classCode(key, varargin)
    // curvature code :
    // 0    : constant
    // 1    : linear
    // 1.5 : piece wise affine
    // -2   : concave
    // 2    : convex
    // 3    : nl
    if argn(2) > 1 then
        m = varargin(1)
    end
    if argn(2)>2 then 
        n = varargin(2)
    end
    if (typeof(key) == "string") then
        select (key)
        case ("constant")
            code = 0
        case ('linear')
            code = 1
        case ('pwa-convex')
            code = 1.5
        case ('pwa-concave')
            code = -1.5
        case ("convex")
            code = 2
        case ("concave")
            code = -2
        case ("nonconvex")
            code = 10
        else
            error("Unknown function class")
        end
    else
        code = key
    end
    funClass = code // * ones(m, n)
endfunction
