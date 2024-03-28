function sopi_plotVarTree(var)
    [nl,nlayers] = sopi_countLeafs(var)
//    plot2d([0,nl],[0,-nl])    
    [dummy, nodes] = sopi_plotVarTree_(var, 0:nl-1, 0, list())
    //
    for i = 1:length(nodes)
        xstring(nodes(i)(1), nodes(i)(2),nodes(i)(3) ,0, 1)
        t               = gce()
        t.text_box      = [0,0]
        t.text_box_mode = 'centered'
        t.alignment     = 'center'
        t.fill_mode = 'on'
        t.background = color('white')
    end
    //
    
    a                   = gca()
    bnds                = a.data_bounds
    gca().data_bounds   = [-0.5,-nlayers-0.5;...
                           nl-1+0.5,0.5]
endfunction

function [xm,nodes] = sopi_plotVarTree_(var, x, y, nodes)
    yo = -1
    if typeof(var) == 'sopiVar' then
        nl      = sopi_countLeafs(var)
        varOp   = 'leaf'
        if var.operator~='none' then
            varOp = var.operator 
        end
        if ~isempty(var.name) then
            varName = var.name 
        else
            varName = 'var'+string(var.id_)
        end
    else
        varOp   = 'constant'
        varName = 'varx'
        nl      = 1
    end
    xm = mean(x)
    plot(xm,y,'ko')
    //
    select varOp
    case 'sum'
        n   = length(var.child)
        o   = 0
        for i = 1:n
            nli = sopi_countLeafs(var.child(i))
            [xms, nodes] = sopi_plotVarTree_(var.child(i), x(o+(1:nli)), y+yo,nodes)
            o   = o+nli
            plot([xm, xms],[y, y+yo],'k')
        end
    case {'rlm','llm'}
        
        [xms,nodes] = sopi_plotVarTree_(var.child(1), x(1), y+yo, nodes)
        plot([xm, xms],[y, y+yo],'k')
        [xms,nodes] = sopi_plotVarTree_(var.child(2), x(2:nl),y+yo, nodes)
        plot([xm, xms],[y, y+yo],'k')
    end
    // node text to be plotted at the end to cover links
    varDims     = string(size(var,1)) +'x' +string(size(var,2))
    nodes($+1)  = list(xm, y, [varOp;varName;varDims])
endfunction
