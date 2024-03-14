function newVar = %sopiVar_max(varargin)
    newVar          = sopi_var(1)
    newVar.operator = 'fun'
    newVar.child(1) = 'max'
    newVar.child(2) = varargin
    //
    newVar.class = sopi_applyClassRule('ndconvexFun',varargin)
endfunction
