
function sopi_print(printLvl,strList,varargin)
    [message, tagStr] = sopi_extractTags(strList);
    message           = " " + message;
    if sopi_verbosity()>= printLvl then
        if printLvl == -1 then
            tagStr = tagStr + "[WARNING]";
        end
        mprintf(tagStr + message, varargin(:));
    end

endfunction


// separate the message from the tags given a string or matrix of strings.
function [message, tagStr] = sopi_extractTags(strList)
   strList = ["sopi",strList];
   if  size(strList,2) > 1 then
      message     = strList($);
      tags        = strList(1:$-1);
      tagStr      = "[" + strcat(tags,"][") + "]";
   else
      message  = strList;
      tagStr   = [];
   end
endfunction
