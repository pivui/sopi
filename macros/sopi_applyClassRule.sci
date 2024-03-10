function C = sopi_applyClassRule(operator, args)
    select (operator)
    case ('sum')
        s = args(1).size
        C = zeros(s(1),s(2))
        for (i=(1:length(args))) do
            C = max(C, args(i).class)
        end
    end
endfunction
