// A.*sopiVar
function newVar = %s_x_sopiVar(A, var)
    // Check size coherence 
    ns  = sopi_checkSizeCoherence('hadamard', [size(A,1), size(A,2)], var.size)
    // rewritten as classic multiplication
    newVar = 0
    for i = 1:ns(1)
        l       = zeros(ns(1),1)
        l(i)    = 1
        for j = 1:ns(1)
            r       = zeros(ns(2),1)
            r(j)    = 1
            newVar = newVar + A(i,j) *(l*l')*var*(r*r')
        end
    end
    
endfunction
