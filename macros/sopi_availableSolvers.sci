function solvers = sopi_availableSolvers(key)
    solvers = list()
    select key
    case 'lp'
        // ---------------------------------------------------------------------
        // LP
        // ---------------------------------------------------------------------
        // karmarkar: scilab built in solver 
        name            = 'karmarkar'
        callingSequence = '[xopt, fopt, flag]   = karmarkar(full(pb.Ae),full(pb.be),full(pb.c),opt.x0,opt.rtolf,opt.gam,opt.maxiter,[],full(pb.A),full(pb.b),pb.lb,pb.ub)'
        flags           = list([1, 0, -1, -2, -3, -4],...
                                ["The algorithm has converged.",...
                                "Maximum number of iterations reached.",...
                                "No feasible point has been found.",...
                                "The problem is unbounded.",...
                                "Search direction became 0.",...
                                "Algorithm stopped on user request."])
        options         = struct('x0',[],'maxiter',[],'rtolf',[],'gam', [])
        ulbToHuge       = %F
        solvers($+1)    = sopi_newSolver(name, callingSequence, flags, options, ulbToHuge)
        // sopilp : sopi built in solver
        name            = 'sopilp'
        callingSequence = '[xopt, fopt, flag, info] = sopi_LPsolver(pb.c, pb.A, pb.b, pb.Ae, pb.be, pb.lb, pb.ub, ''primal'')'
        flags           = list([0,1,2,3], ["The algorithm has converged.",...
                                           "The problem is unbounded.",...
                                           "No feasible point has been found.",...
                                           "Failed to maintain feasibility"])
        options         = struct()
        ulbToHuge       = %F
        solvers($+1)    = sopi_newSolver(name, callingSequence, flags, options, ulbToHuge)
    case 'qp-convex'
        // ---------------------------------------------------------------------
        // CONVEX QP
        // ---------------------------------------------------------------------
        // qld: scilab built in 
        name            = 'qld'
        callingSequence = ['[xopt ,lagr ,flag]  = qld(2 * full(pb.Q), pb.c, full([pb.Ae;pb.A]),[pb.be;pb.b],lb,ub,size(pb.Ae,1))','fopt = xopt''*pb.Q*xopt + pb.c''*xopt']
        flags           = list([0, 1, 2, 5, 10],...
                                ["The algorithm has converged.",
                                 "Too many iterations needed.",
                                  "Accuracy insufficient to satisfy convergence criterion.",
                                  "Length of working array is too short.",
                                  "The constraints are inconsistent."])
        options         = struct()
        ulbToHuge       = %T
        solvers($+1)    = sopi_newSolver(name, callingSequence, flags, options, ulbToHuge)
        // qpsolve: scilab built in 
        name            = 'qpsolve'
        callingSequence = ['[xopt ,iact ,iter ,fopt]=qpsolve(2*full(pb.Q), pb.c, [pb.Ae;pb.A],[pb.be;pb.b],lb,ub,size(pb.Ae,1))', 'flag=0']
        flags           = list([0], ['The algorithm has converged'])
        options         = struct()
        ulbToHuge       = %T
        solvers($+1)    = sopi_newSolver(name, callingSequence, flags, options, ulbToHuge)
    end
endfunction

function solver = sopi_newSolver(name, callingSequence, flags, options, ulbToHuge)
    solver = struct('name',name,...
                    'callingSequence',callingSequence,...
                    'flags', flags,...
                    'options', options,...
                    'ulbToHuge',ulbToHuge)
endfunction
