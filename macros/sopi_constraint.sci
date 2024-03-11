function cst = sopi_constraint()
    cst         = mlist(['sopiCst',...
                        'id_','class','operator','lhs'])
    cst.id_     = sopi_getNewId()
endfunction

