function [vIds,vNames] = sopi_whoIsSopiVar()
   vIds = list()
   vNames = list()
   pprot = funcprot(0)
   varList = who_user(%f)
   for i = 1:size(varList,1)
      varName = varList(i)
      execstr("var = "+varName)
      if  typeof(var) == "sopiVar" then
         vIds($+1) = var.id_
         vNames($+1) = varName
      end
   end
   funcprot(pprot)
endfunction
