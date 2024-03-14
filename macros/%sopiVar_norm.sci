function newVar = %sopiVar_norm(var,normType)

select normType
case 2
   error('not yet') 
case 1
    newVar = sum(abs(var))
case 'inf'
    newVar = max(abs(var))
end
endfunction
