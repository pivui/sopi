function %sopiVar_p(var)
   sizeStr = " " + string(var.size(1))+"x"+string(var.size(2));
   if ~isempty(var.name) then
      nameStr = var.name + " : ";
   else
      nameStr = "";
   end
   disp(nameStr+ var.space + sizeStr+ " sopiVar ");
endfunction
