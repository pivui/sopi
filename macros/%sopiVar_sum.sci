// sum .........................................................................
// computes the sum of the elements of a sopiVar
function newVar = %sopiVar_sum(var,opt)
   [m,n] = size(var);
   if opt == 1 then
      // sum along the row dimension
      if m == 1 then
         // only one row, return the var
         newVar = var;
      else
         newVar = ones(1,m) * var;
      end
   elseif opt == 2 then
      // sum along the column dimension
      if n == 1 then
         // only one column, return the var
         newVar = var;
      else
         newVar = var * ones(n,1);
      end
   elseif opt == 12 then
      // sum along both dimensions
      newVar   = sum(sum(var,2),1);
   end
endfunction
