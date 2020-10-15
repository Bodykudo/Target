inRoomModule=tfm.get.room.isTribeHouse and false or true
moduleName = "t"
loadedData = {}

local gmatch, sub, match = string.gmatch, string.sub, string.match
local splitter = "\1"

function stringToTable(str, tab, splitChar)
	local split = splitter..string.char(splitChar)
	for i in gmatch(str, '[^'..split..']+') do
		local index, value = match(i, '(.-)=(.*)')
		local indexType, index, valueType, value = sub(index, 1, 1), sub(index, 2), sub(value, 1, 1), sub(value, 2)
		if indexType == "s" then
			index = tostring(index)
		elseif indexType == "n" then
			index = tonumber(index)
		end
		if valueType == 's' then
			tab[index] = tostring(value)
		elseif valueType == 'n' then
			tab[index] = tonumber(value)
		elseif valueType == 'b' then
			tab[index] = value == '1'
		elseif valueType == 't' then
			tab[index] = {}
			stringToTable(value,tab[index], splitChar + 1)
		end
	end
end

function tableToString(index, value, splitChar)
	local sep = splitter..string.char(splitChar)
	local str = type(index) == 'string' and 's'..index..'=' or 'n'..index..'=' 
	if type(value) == 'table' then
		local tab = {}
		for i, v in next, value do
			tab[#tab + 1] = tableToString(i,v,splitChar+1)
		end
		str = str .. 't' .. table.concat(tab, sep)
	elseif type(value) == 'number' then
		str = str .. 'n' .. tostring(value)
	elseif type(value) == 'boolean' then
		str = str .. 'b' .. (value and '1' or '0')
	elseif type(value) == 'string' then
		str = str .. 's' .. value
	end
	return str
end

function eventPlayerDataLoaded(n, pD)
	if pD:find("hunter")~=nil or pD:find("myhero")~=nil or pD:find("sniper")~=nil or pD:find("*m") then
		system.savePlayerData(n,"")
		pD=""
	end
	loadedData[n] = {}
	for i in gmatch(pD, "[^\0]+") do
		local moduleName = match(i, "s([^=]+)")
		local str = sub(i, #moduleName+4)
		loadedData[n][moduleName] = {}
		stringToTable(str,loadedData[n][moduleName], 1)
	end
    if loadedData[n]["f"] then loadedData[n]["f"] =nil end
    if loadedData[n]["w"] then loadedData[n]["w"] =nil end
    if loadedData[n]["z"] then loadedData[n]["z"] =nil end
	for i, v in next, loadedData[n][moduleName] or {} do
		data[n][i]=v 
	end
	loadedData[n][moduleName] = data[n]
	data[n][6]=tfm.get.room.playerList[n].community
	data[n][2]=data[n][3]+data[n][4]
end

function saveData(n)
    if loadedData[n] and inRoomModule and tfm.get.room.uniquePlayers >= 5 then
		local res={}
		for module, data in next, loadedData[n] do
			res[#res + 1] = tableToString(module,data,1)
		end
		system.savePlayerData(n, table.concat(res, "\0"))
	end
end