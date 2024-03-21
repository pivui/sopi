function newVar = %sopiVar_norm(var,normType)

select normType
case 2
   error('not yet') 
case 1
    newVar = sum(abs(var),1)
case {%inf,'inf'}
    newVar = max(abs(var))
end
endfunction
