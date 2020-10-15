function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

gbPl=deepcopy(data)
lb_gbPl={}

function sort_gb(t)
    local lb1, lb = {} , {}
    for name in next, t do
        lb1[#lb1 + 1] = {name, t[name][2]}
    end
    repeat
        local a, max_Val = -math.huge , 1
        for i = 1, #lb1 do
            if lb1[i][2] > a then
                a = lb1[i][2]
                max_Val = i
            end
        end
        table.insert(lb, lb1[max_Val][1])
        table.remove(lb1, max_Val)
    until #lb1 == 0
    return lb
end

function eventFileLoaded(fN, fD)
    if fN == "3" then
    	gbPl = deepcopy(data)
    	for n in pairs(gbPl) do
      		gbPl[n][1] = gbPl[n][6]
      	end
        for n in fD:gmatch("[^$]+") do 
            local t = {}
            for k in n:gmatch("[^,]+") do 
                table.insert(t, k)
            end
            if not gbPl[t[1]] then
                gbPl[t[1]] = {t[2], tonumber(t[3])}
            end
        end
    	lb_gbPl = sort_gb(gbPl)
        local t = ""
        for i=1,50 do
            if lb_gbPl[i] then
                local n = lb_gbPl[i]
                if n:sub(0,1)~="*" then
                	t=t..""..n..","..gbPl[n][1]..","..gbPl[n][2].."$"
                end
            end
        end
        t = t:sub(#t) == "$" and t:sub(0,#t-1) or t
        if inRoomModule and tfm.get.room.uniquePlayers >= 5 then
            system.saveFile(t, 3)
        end
  	end 
end

function rankPlayers()
    prs={}
    for n in pairs(data) do
    	if tfm.get.room.playerList[n] then
        	table.insert(prs,n)
        end
    end
    maxPlayers={}
    while (#prs~=0) do
        mS=-1
        mp=nil
        for i,n in pairs (prs) do
            if mS < data[n][2] then
                mS=data[n][2]
                mP=n
                idRa=i
            end
        end
        table.insert(maxPlayers,{mP,mS})
        table.remove(prs,idRa)
    end
    return maxPlayers
end