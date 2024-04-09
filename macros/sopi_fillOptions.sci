function opt = sopi_fillOptions(default, opt)
    if isempty(opt) then
        opt = struct()
    end
    fnames = fieldnames(default)
    for i = 1:size(fnames,1)
        fi = fnames(i)
        if ~isfield(opt, fi) then 
            opt(fi) = default(fi)
        end
    end
endfunction
