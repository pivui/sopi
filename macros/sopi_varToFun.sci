function [fun, data] = sopi_varToFun(var,p)
    funName = 'fun_'+string(var.id_)
    outVar  = 'var_'+string(var.id_)
    vars    = sopi_depends(var)
    //
    if argn(2) == 1 then
        funArgs = list() 
        for v = vars
            funArgs($+1) = 'var_'+string(v.id_)
        end
        funArgs($+1) = 'data'
    else
    end
    [str, data] = sopi_varToFun_(var,'',list())
    str         = outVar + '=' + str
    fun         = deff(outVar+' = '+funName+'('+strcat(list2vec(funArgs),',')+')',...
                       str)
endfunction


function [str, data] = sopi_varToFun_(var, str, data)
    select var.operator
    case 'none'
        //
        str = str +'var_'+string(var.id_)
    case 'constant'
        data($+1)   = var.child(1)
        str         = str+'data('+string(length(data))+')'
    case 'sum'
        str = str + '('
        for i = 1:length(var.child)
            [stri, data] = sopi_varToFun_(var.child(i), '', data)
            str = str + stri
            if i < length(var.child) then 
                str = str + '+'
            end
        end
        str = str + ')'
    case 'llm'
        data($+1)       = var.child(1)
        str             = str+'data('+string(length(data))+')*('
        [str, data]     = sopi_varToFun_(var.child(2), str, data)
        str             = str+ ')'
    case 'rlm'
        str = str+'('
        [str, data]     = sopi_varToFun_(var.child(2), str, data)
        data($+1)       = var.child(1)
        str             = str+')*data('+string(length(data))+')'
    case 'mul'
        str = str + '('
        [str, data] = sopi_varToFun_(var.child(1), str, data)
        str = str +'*'
        [str, data] = sopi_varToFun_(var.child(2), str, data)
        str = str + ')'
    end
endfunction
