
// sopi_interpretFlag ..........................................................
function vFlag = sopi_interpretFlag(flag, flags, flagMeaning)
   idx   = find(flag == flags)
   vFlag = flagMeaning(idx)
endfunction
