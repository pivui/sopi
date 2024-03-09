// sopiVar + sopiVar ...........................................................
// computes the addition of two sopiVar.
function newVar = %sopiVar_a_sopiVar(var1, var2)
    // Check size coherence 
    s1 = var1.size 
    s2 = var2.size 
    
    newVar          = soop_new('sopiVar')
    // 
    newVar.operator = 'sum'
    
    
    
//   // checking sizes
//   newSize                 = sopi_checkSizesCoherence(var1,var2,SUM);
//   if isscalar(var1) & ~isscalar(var2) then
//      var1 = ones(newSize(1),newSize(2)) * var1;
//   elseif isscalar(var2) & ~isscalar(var1)  then
//      var2 = ones(newSize(1),newSize(2)) * var2;
//   end
//   // creating new variable
//   newVar                  = sopi_newVar();
//   newVar.size             = newSize;
//   newVar.child.operator   = SUM;
//   terms1                  = sopi_expandSum(var1);
//   terms2                  = sopi_expandSum(var2);
//   newVar.child.arg        = lstcat(terms1,terms2);
//   newClass                = newVar.child.arg(1).class;
//   for i = 2:length(newVar.child.arg)
//      //        disp(size(newVar.child.arg(i)))
//      newClass = sopi_applyAdditionRules(newClass,newVar.child.arg(i).class);
//   end
//   newVar.class           = newClass;
endfunction
