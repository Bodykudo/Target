function randomPlayer()
	local players={}
	for n,p in pairs(tfm.get.room.playerList) do
		if tfm.get.room.playerList[n] and not p.isDead then
			players[#players+1]=n
		end
	end
	local player=players[math.random(#players)]
	return player
end

function changeTarget(cooldown)
	if not finished then
		for i=1,#mapSet.linked do
			tfm.exec.linkMice(mapSet.linked[i][1],mapSet.linked[i][2],false)
		end
		mapSet.linked={}
		for n in pairs(tfm.get.room.playerList) do
			tfm.exec.changePlayerSize(n,1)
		end
		t=cooldown and 25 or 20
		if cooldown then
			target=""
			nextTarget=randomPlayer()
		else
			if tfm.get.room.playerList[nextTarget] and not tfm.get.room.playerList[nextTarget].isDead then
				target=nextTarget
			else
				target=randomPlayer()
			end
		end
		if cooldown then
			tfm.exec.chatMessage(text[nextTarget].ready,nextTarget)
			vImg=tfm.exec.addImage("16539cc8736.png", "&1", 80, mapSet.v=="tp" and 80  or 34, nil)
			cImg=tfm.exec.addImage("16539cb8ace.png", "&2", 80, mapSet.c=="tp" and 126 or (mapSet.v=="tp" and 126 or 80), nil)
			vIcon=tfm.exec.addImage(mapSet.v=="attack" and icons.skills.attack.objects[mapSet.attack].img..".png" or icons.skills[mapSet.v].img..".png", "&4", icons.skills[mapSet.v].x, 24, nil)
			cIcon=tfm.exec.addImage(mapSet.c=="attack" and icons.skills.attack.objects[mapSet.attack].img..".png" or icons.skills[mapSet.c].img..".png", "&3", icons.skills[mapSet.c].x, mapSet.v=="tp" and 116 or 70, nil)
			system.newTimer(function()
				tfm.exec.removeImage(vIcon)
				tfm.exec.removeImage(cIcon)
				tfm.exec.removeImage(vImg)
				tfm.exec.removeImage(cImg)
			end,5000,false)
		end
		if not cooldown and target~=nil and target~="" then
			if mapSet.meep then
				tfm.exec.giveMeep(target)
			end
			if mapSet.v=="cheese" or mapSet.c=="cheese" then
				for n in pairs(tfm.get.room.playerList) do
					tfm.exec.removeCheese(n)
				end
			end
			mapSet.iconX=755
			tfm.exec.chatMessage(text[target].target.."\n"..string.format(text[target].skills[mapSet.v],"<BV><b>V</b></BV>","<BV><b>"..text[target].objects[mapSet.attack].."</b></BV>").."\n"..string.format(text[target].skills[mapSet.c],"<BV><b>C</b></BV>","<BV><b>"..text[target].objects[mapSet.attack].."</b></BV>"),target)
			killMessage()
			tfm.exec.setNameColor(target,0xE6254E)
		end
		ui.setShamanName(cooldown and "" or target~=nil and mini(target,false,true,false) or "")
	end
end

function toCheck(n)
	local i=0
	local name
	for na in pairs(tfm.get.room.playerList) do
		if not tfm.get.room.playerList[na].isDead then
			i=i+1
			name=na
		end
	end
	if i==1 then
		tfm.exec.giveCheese(name)
		tfm.exec.playerVictory(name)
		if tfm.get.room.uniquePlayers >= 5 and inRoomModule then
			data[name][3]=data[name][3]+1
		end
		tfm.exec.setPlayerScore(name,10,true)
		saveData(name)
		ui.setShamanName("")
	elseif i==0 then
		t=5
		tfm.exec.setGameTime(5)
	elseif i>1 and n==target then
		changeTarget(true)
	end
end

function killMessage()
	for n in pairs(tfm.get.room.playerList) do
		if n~=target then
			tfm.exec.chatMessage(string.format(text[n].isTarget,mini(target,false,true,false)),n)
		end
	end
end