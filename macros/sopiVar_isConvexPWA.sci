function ans = sopiVar_isConvexPWA(var)
    ans = var.class == sopi_classCode('pwa-convex')
//   if var.operator=='none'  then
//
//   end
//   select var.operator
//   case 'none'
//     // if a variable is elementary, then it is affine, therefore it is not, 
//      // strictly speaking, piecewise affine.
//      ans = %f;
//   case 'sum'
//      ans = %t;
//      for e = var.child
//         // a sum of pwa functions is pwa, 
//         // a sum of pwa and linear functions is pwa
//         ans = ans & (sopiVar_isPWA(e) | sopiVar_isLinear(e));
//      end
//      // ans is true if at least one of the element of the sum is pwa and the other
//      // linear or pwa
//   case 'llm' 
//      // a linear mapping of a pwa function is pwa
//      ans = sopi_isPWA(var.child(2));
//   case 'rlm'
//      ans = sopi_isPWA(var.child(2));
//   case 'fun'
//      if var.child(1) == 'norm' then
//         if or(var.child(3) == [%inf,1]) then
//            if sopiVar_isLinear(var.child(2)) | sopiVar_isPWA(var.child(2)) then
//               ans = %t
//            else
//               ans = %f;
//            end
//         end
//      elseif var.child(1) == 'max' then
//         ans = %t;
//         for e = var.child.arg(2)
//            ans = ans & sopiVar_isLinear(e) | sopiVar_isPWA(e)
//         end
//      elseif var.child(1) == 'abs' then
//         if sopiVar_isLinear(var.child(2)) | sopiVar_isPWA(var.child(2)) then
//            ans = %t
//         else
//            ans = %f;
//         end
//      end
//   end
endfunction
