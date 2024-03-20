// abs .........................................................................
// computes the absolute value of a sopiVar.
function newVar = %sopiVar_abs(var)
   newVar           = sopi_var(size(var))
   newVar.operator  = 'fun'
   newVar.child     = list('abs',var)
   newVar.class     = sopi_applyClassRule('abs',list(var));   
endfunction
