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
    //
    sopiNameSpace.constants =  ["LEFT_LINEAR_MAPPING","""llm""",
                               "RIGHT_LINEAR_MAPPING","""rlm""",
                               "SUM","""+""",
                               "FUN","""fun""",
                               "TRANSPOSE","""transpose""",
                               "CONSTANT","""constant""",
                               "QUADRATIC","""quad""",
                               "REAL","""real""",
                               "BINARY","""binary""",
                               "INTEGER","""integer""",
                               "LEFT","""l""",
                               "RIGHT","""r""",
                               "LINEAR_MAPPING","""lm""",
                               "LESSER_THAN","""<""",
                               "GREATER_THAN",""">""",
                               "EQUALS","""=""",
                               "TIMES","""*""",
                               "ABS","""abs""",
                               "NORM","""norm""",
                               "MAX","""max""",
                               "POW","""pow""",
                               "CONSTRAINT","""<>""",
                               "POSITIVE_DEF","""pd""",
                               "POSITIVE_SEMIDEF","""psd""",
                               "NEGATIVE_DEF","""nd""",
                               "NEGATIVE_SEMIDEF","""nsd""",
                               "INDEFINITE","""i""",
                               "CONVEX","""convex""",
                               "CONCAVE","""concave""",
                               "NONLINEAR","""nonlinear"""
                              ]
    // Create new classes 
    // Main class: sopiVar
    varAttr = list('name',...       // name of the variable to be displayed 
                   'size',...       // size of the variable 
                   'space',...      // mathematical space: real, complex, integer
                   'operator',...   // operator applied to the children
                   'child',...      // children 
                   'class',...      // class of the math function it represents: linear, convex, etc.
                   'isTmp')      // whether the variable is temporary
                   
    varMeth = list()
    soop_newClass('sopiVar' , varAttr, varMeth)
    // TODO: sopiProblem and sopiConstraint
    
endfunction

function verbosity = sopi_verbosity(varargin)
    global sopiNameSpace
    if argn(2) > 0 then
        sopiNameSpace.verbosity = varargin(1)
    end
    verbosity = sopiNameSpace.verbosity
endfunction

