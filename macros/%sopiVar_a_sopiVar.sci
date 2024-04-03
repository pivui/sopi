// sopiVar + sopiVar ...........................................................
// computes the addition of two sopiVar.
function newVar = %sopiVar_a_sopiVar(var1, var2)
    // Check size coherence 
    ns = sopi_checkSizeCoherence('sum', var1.size, var2.size)
    // Adapt scalar if need be
    if isscalar(var1) && ~isscalar(var2) then
        var1 = ones(ns(1), ns(2)) * var1 
    elseif isscalar(var2) && ~ isscalar(var1) then 
        var2 = ones(ns(1), ns(2)) * var2
    end
    // Create new variable 
    newVar          = sopi_var(ns)
    newVar.space    = 'real' // TODO: to be adapted when other spaces are added
    newVar.operator = 'sum'
    newVar.size     = ns
    terms           = lstcat(sopi_expandChildSum(var1), sopi_expandChildSum(var2))
    //
    newVar.child    = terms//sopi_gatherConstants(terms)
    //
    newVar.class    = sopi_classRules('sum', newVar) 
endfunction


function terms = sopi_expandChildSum(var)
   if var.operator == 'sum' then
      terms = var.child;
   else
      terms = list(var);
   end
endfunction
