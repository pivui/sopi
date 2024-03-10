function funClass = sopi_classCode(key, m, n)
    // curvature code :
    // 0    : constant
    // 1    : affine
    // -2   : concave
    // 2    : convex
    // 3    : nl
    if (typeof(key) == "string") then
        select (key)
            case ("constant")
                code = 0
            case ("affine")
                code = 1
            case ("convex")
                code = 2
            case ("concave")
                code = 3
            case ("nonconvex")
                code = 10
            else
                error("Unknown function class")
        end
    else
        code = key
    end
    funClass = code * ones(m, n)
endfunction
