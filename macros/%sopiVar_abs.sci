// abs .........................................................................
// computes the absolute value of a sopiVar.
function newVar = %sopiVar_abs(var)
   newVar           = sopi_var(size(var))
   newVar.operator  = 'fun'
   newVar.subop = 'abs'
   newVar.child     = list(var)
   newVar.class     = sopi_classRules('abs',newVar);
endfunction
