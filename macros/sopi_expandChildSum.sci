function terms = sopi_expandChildSum(var)
   if var.operator == 'sum' then
      terms = var.child;
   else
      terms = list(var);
   end
endfunction
