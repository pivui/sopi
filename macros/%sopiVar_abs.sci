// abs .........................................................................
// computes the absolute value of a sopiVar.
function newVar = %sopiVar_abs(var)
   newVar           = sopi_var(size(var,1), size(var,2))
   newVar.operator  = 'fun'
   newVar.subop     = 'abs'
   newVar.child     = list(var)
   newVar.class     = sopi_classRules('abs',newVar);
endfunction
