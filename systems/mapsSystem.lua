tableMap=false
function newMap()
	if playersNum > 1 then
		nextMap=math.random(#maps)
		while nextMap==lastMap do
			nextMap=math.random(#maps)
		end
		lastMap=nextMap
		if type(maps[nextMap])=="table" then
			tableMap=true
			tfm.exec.newGame(maps[nextMap].code)
		else
			tfm.exec.newGame(maps[nextMap])
			tableMap=false
		end
	else
		tfm.exec.newGame("@6984945")
	end
end