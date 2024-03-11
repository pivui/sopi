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
    // Check if soop is available
    if ~isdef('soop_begin') then
        error('Sopi requires soop to work properly.')
    end
    // launch soop object namespace 
    soop_begin()
    // sopi dedicated namespace
    global sopiNameSpace
    sopiNameSpace = struct('verbosity',         0,...
                           'globalConstraints', %f,...
                           'constants', [])
    // Create new classes 
    // Main class: sopiVar
    varAttr = list('name',...       // name of the variable to be displayed 
                   'size',...       // size of the variable 
                   'space',...      // mathematical space: real, complex, integer
                   'operator',...   // operator applied to the children
                   'child',...      // children 
                   'class',...      // class of the math function it represents: linear, convex, etc.
                   'isTmp')      // whether the variable is temporary
                   
    varMeth = list('isConstant','isLinear','isConvex','isConcave')
    soop_newClass('sopiVar' , varAttr, varMeth)
    // Constraints 
    cstAttr = list('operator','lhs','class')
    cstMeth = list()
    soop_newClass('sopiCst', cstAttr, cstMeth)
    // Problem 
    pbAttr  = list('varList','varIdx')
    pbMeth  = list()
    soop_newClass('sopiPb', pbAttr, pbMeth)
    
endfunction

function verbosity = sopi_verbosity(varargin)
    global sopiNameSpace
    if argn(2) > 0 then
        sopiNameSpace.verbosity = varargin(1)
    end
    verbosity = sopiNameSpace.verbosity
endfunction

