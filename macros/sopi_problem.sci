function p = sopi_problem()
    p = mlist(['sopiPro',...
               'class',...
               'vars',...
               'varsId',...
               'varsIdx',...
               'nvar',...
               'r',...
               'c',...
               'H',...
               'f',...
               'lb',...
               'ub',...
               'A',...
               'b',...
               'Ae',...
               'be',..
               'ci',...
               'ce'])
    //
    p.class = ''
    p.vars = list()
    p.varsId = []
    p.varsIdx = list()
    p.nvar = 0
    p.r = 0
    p.c = []
    p.H = []
    p.f = []
    p.lb = []
    p.ub = []
    p.A = []
    p.b = []
    p.Ae = []
    p.be = []
    p.ce = []
    p.ci = []
endfunction
