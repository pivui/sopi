
// field extraction ............................................................
function out = %sopiVar_e(varargin)
    select argn(2)
    case 2
        var = varargin($)
        i   = varargin(1)
        if typeof(i) == 'string' then
            if isfield(var, i) then 
                out = var(i)
            end
        elseif typeof(i) == 'constant' then 
            out  = sopi_extractElement(var,i);
        end
    case 3
        i        = varargin(1)
        j        = varargin(2)
        var      = varargin(3)
        out       = sopi_extractElement(var,i,j)
    end

endfunction

// sopi_extractElement .........................................................
// builds the linear transformation needed to extract given elements from a 
// sopiVar.
function out = sopi_extractElement(var, varargin)
    [m, n]   = size(var)
    // row extraction
    i        = varargin(1)
    Im       = eye(m,m)
    Ei       = Im(i,:)
    if Ei == Im then
        // all the rows are required, i.e. x(:,columnID)
        out = var
    else
        // only some rows are required
        out = Ei * var
    end
    if length(varargin) == 2 then
        // column extraction
        j  = varargin(2)
        In = eye(n,n)
        Ej = In(:,j)
        if Ej ~= In then
            // only some columns are required
            out  = out * Ej
        end
    end
endfunction
