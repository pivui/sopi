function ns = sopi_checkSizeCoherence(operator, s1, s2)
    select operator
    case 'sum'

        ok = isscalar_(s1) | isscalar_(s2) | and(s1 == s2) 
        ns = [max(s1(1),s2(1)), max(s1(2),s2(2))]
    case 'mul'
      ok = isscalar_(s1) | isscalar_(s2) | s1(2) == s2(1)
      if isscalar_(s1) then
         ns = s2
      elseif isscalar_(s2) then
         ns = s1
      else
         ns = [s1(1), s2(2)]
      end
    end

    if ~ok then
        error("Incompatible sizes : "+ sopi_sizeToString(s1) + ' '+operator+' ' + sopi_sizeToString(s2))
    end
endfunction

function ok = isscalar_(s)
    ok = max(s) == 1
endfunction
