function [fun, data, constr] = sopi_varToFun(var,p)
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
        xToVars = ''
    else
        funArgs = list('x','data')
        xToVars = []
        for i = 1:length(vars)
            vi              = vars(i)
            viIdx           = sopi_varIdxInPb(p, vi)
            xToVars($+1)    = msprintf('var_%d=matrix(x(%d:%d),[%d,%d])',...
                                        vi.id_,viIdx(1),viIdx($),size(vi,1), size(vi,2))
        end
    end
    [str, data] = sopi_varToFun_(var,'',list())
    str         = outVar + '=' + str
    fun         = deff(outVar+' = '+funName+'('+strcat(list2vec(funArgs),',')+')',...
                       [xToVars;str])
    //
    constr      = list(outVar, funName,funArgs,xToVars,str)
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
    case 'mul'
        str = str + '('
        [str, data] = sopi_varToFun_(var.child(1), str, data)
        str = str +'*'
        [str, data] = sopi_varToFun_(var.child(2), str, data)
        str = str + ')'
    end
endfunction
