function newVar = %sopiVar_max(varargin)
    newVar          = sopi_var(1)
    newVar.operator = 'fun'
    newVar.subop    = 'max'
    newVar.child    = varargin
    //
    newVar.class    = sopi_classRules('max', newVar)
endfunction
