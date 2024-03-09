function varargout = %sopiVar_size(var,varargin)
    //
    varargout = list()
    if argn(2) == 1 then
        if argn(1) == 1
            varargout(1) = var.size
        elseif argn(1) == 2
            varargout(1) = var.size(1)
            varargout(2) = var.size(2)
        end
    elseif argn(2) == 2 then 
        sel = varargin(1)
        if type(sel) == 1 then 
            if sel == 1 then
                sel = 'r'
            elseif sel == 2 then
                sel = 'c'
            end
        end
        select sel 
        case 'r'
            varargout(1) = var.size(1)
        case 'c'
            varargout(1) = var.size(2)
        case '*'
            varargout(1) = var.size(1) * var.size(2)
        end  

    end
endfunction
