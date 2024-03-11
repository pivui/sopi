function var = sopi_var(s1, varargin)
    if argn(2) > 1 then
        s = [s1, varargin(1)]
    else
        s = [s1, 1]
    end
    sopi_print(2,"Creation of a sopiVar of size %dx%d.\n",s(1),s(2))
    var         = mlist(['sopiVar',...
                        'id_','name','size','space','class','operator','child'])
    var.id_     = sopi_getNewId()
    var.size    = s
    var.space   = 'real'
    var.class   = sopi_classCode("linear", s(1), s(2))
    var.operator = 'none'
endfunction

