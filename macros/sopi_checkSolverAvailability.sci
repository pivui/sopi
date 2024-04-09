function sopi_checkSolverAvailability(solvers, method)
    if and(method ~= solvers) then
        error('unavailable solver '+method)
    end
endfunction
