function id = sopi_getNewId()
    global sopiNameSpace
    id = sopiNameSpace.id
    sopiNameSpace.id = sopiNameSpace.id + 1
endfunction
