function [out1,out2] = %sopiVar_size(var,opt)
   if argn(2) == 1 then
      // by default, get both sizes.
      opt = 12;
   end
   if argn(1) == 2 &  opt ~=12 then
      // two output arguments but only one dimension is asked.
      error("incompatible number of ouput args")
   end
   select opt
   case 1
      s = var.size(1);
   case 2
      s = var.size(2);
   case 12
      s = [var.size(1),var.size(2)];
   end
   if argn(1) == 2 then
      // two output arguments, each dimension is returned in one output argument
      out1 = s(1);
      out2 = s(2);
   else
      // one output argument, the dimension(s) are returned as a vector
      out1 = s;
   end
endfunction
