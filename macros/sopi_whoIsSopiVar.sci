function [vIds,vNames] = sopi_whoIsSopiVar()
    vIds = list()
    vNames = list()
    pprot = funcprot(0)
    varList = who_user(%f)
    for i = 1:size(varList,1)
        varName = varList(i)
        execstr("var = "+varName)
        if  typeof(var) == 'sopiVar' then
            vIds($+1)   = var.id_
            vNames($+1) = varName
        elseif typeof(var) == 'list' & ~isempty(var) &  typeof(var(1)) == 'sopiVar' then
            for j = 1:length(var)
                vIds($+1)   = var(j).id_
                vNames($+1) = msprintf('%s(%d)',varName,j) 
            end
        end 
    end
    funcprot(pprot)
endfunction
