// sopiVar + sopiVar ...........................................................
// computes the addition of two sopiVar.
function newVar = %sopiVar_a_sopiVar(var1, var2)
    // Check size coherence 
    [ok, ns] = sopi_checkSizeCoherence('sum', var1.size, var2.size)
    // Adapt scalar if need be
    if isscalar(var1) && ~isscalar(var2) then
        var1 = ones(ns(1), ns(2)) * var1 
    elseif isscalar(var2) && ~ isscalar(var1) then 
        var2 = ones(ns(1), ns(2)) * var2
    end
    // Create new variable 
    newVar          = soop_new('sopiVar')
    newVar.isTmp    = %t
    newVar.space    = 'real' // TODO: to be adapted when other spaces are added
    newVar.operator = 'sum'
    newVar.size     = ns
    newVar.child    = lstcat(sopi_expandChildSum(var1), sopi_expandChildSum(var2))
    newVar.class    = sopi_applyClassRule('sum', newVar.child) 
endfunction
