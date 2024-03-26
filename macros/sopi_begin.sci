    //
    //  Initialise variables required by sopi. Must preceed any sopi-related 
    //  operation.
    //
    //  Syntax 
    //      sopi_begin()
    //
    //  Authors
    //      Pierre Vuillemin - 2024
function sopi_begin()
    // sopi dedicated namespace
    global sopiNameSpace
    sopiNameSpace = struct('verbosity',         0,...
                           'globalConstraints', %f,...
                           'id',                0)    
endfunction

function verbosity = sopi_verbosity(varargin)
    global sopiNameSpace
    if argn(2) > 0 then
        sopiNameSpace.verbosity = varargin(1)
    end
    verbosity = sopiNameSpace.verbosity
endfunction

