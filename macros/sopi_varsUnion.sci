function vList = sopi_varsUnion(vList, vList2)
    for i = 1:length(vList2)
        inList = sopi_varInList(vList2(i), vList)
        if ~inList then 
            vList($+1) = vList2(i)
        end 
    end
endfunction
