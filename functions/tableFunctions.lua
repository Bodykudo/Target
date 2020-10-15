function table.find(list,value,index,f)
    for k,v in next,list do
        local i = (type(v) == "table" and index and v[index] or v)
        if (not f and i or f(i)) == value then
            return true,k
        end
    end
    return false,0
end

function table.indexesConcat(list,sep,f,i,j)
    local txt = ""
    sep = sep or ""
    i,j = i or 1,j or #list
    for k,v in next,list do
        if type(k) ~= "number" and true or (k >= i and k <= j) then
            txt = txt .. (f and f(k,v) or v) .. sep
        end
    end
    return string.sub(txt,1,-1-#sep)
end