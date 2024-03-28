// sopi_solve ..................................................................
// is the interface for solving problems
function  [xopt, fopt] = sopi_solve(pb, varargin)
    if argn(2) >1 then
        method = varargin(1)
    else
        method = []
    end
    infoStr = 'Nature of the optimisation problem : '
    select pb.class
    case 'lp'
        sopi_print(0,infoStr + "linear.\n")
        [xopt, fopt, info]   = sopi_callLPSolver(pb, method)
        fopt                 = fopt + pb.r
    else
        error("Unknown class")
    end
    //
    xopt = sopi_assignOutput(pb, xopt) 
endfunction

function xo = sopi_assignOutput(p, xopt, fopt)
    [vIds, vNames]  = sopi_whoIsSopiVar()
    xo              = struct()
    for i = 1:length(vIds)
        t =  vIds(i) == p.varsId
        if or(t) then
            idx             = find(t)
            xo(vNames(i))   =  xopt(p.varsIdx(idx))
        end
    end
endfunction
