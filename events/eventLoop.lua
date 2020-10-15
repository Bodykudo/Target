local ti=0
function eventLoop(time,remaining)
	if remaining<=0 then
		newMap()
	end
	if map~="@6984945" then
		ti=ti==1 and 0 or ti+0.5
		if time>=3000 and not started then
			t=t-0.5
			table.foreach(tfm.get.room.playerList, function(a, b) ui.updateTextArea(0,"<p align='center'><font size='24'><"..colors[math.ceil(t/5)]..">"..math.ceil(t) .."</"..colors[math.ceil(t/5)].."></font></p>", a) end)
		end
		if time>=13000 and not started then
			started=true
			changeTarget(false)
		end
		for n in pairs(tfm.get.room.playerList) do
			for k,v in pairs(mapSet.traps) do
				if n~=target and not tfm.get.room.playerList[n].isDead and math.sqrt(math.pow(tfm.get.room.playerList[n].x-v.x,2)+math.pow(tfm.get.room.playerList[n].y-v.y,2)) <= 30 and not p[n].trapped and target~="" then
					local X,Y=tfm.get.room.playerList[n].x,tfm.get.room.playerList[n].y
					local trap=tfm.exec.addShamanObject(68,X,Y)
					p[n].trapped=true
					system.newTimer(function()
						tfm.exec.removeObject(trap)
					end,2000,false)
					tfm.exec.movePlayer(n,X,Y)
					mapSet.traps[k]={x=-1000,y=-1000}
				end
			end
			if n~=target and gravity then
				tfm.exec.movePlayer(n,0,0,false,0,100,false)
			end
			if n==target and started then
				p[n].x=ti==0.5 and tfm.get.room.playerList[n].x or p[n].x
				p[n].y=ti==0.5 and tfm.get.room.playerList[n].y or p[n].y
				p[n].x2=ti==1 and tfm.get.room.playerList[n].x or p[n].x2
				p[n].y2=ti==1 and tfm.get.room.playerList[n].y or p[n].y2
				if p[n].x==p[n].x2 and p[n].y==p[n].y2 then
					p[n].timetokill=p[n].timetokill+0.5
				else
					p[n].timetokill=0
				end
				if p[n].timetokill==10 then
					tfm.exec.killPlayer(n)
					p[n].timetokill=0
				end
			end
		end
		if started then
			t=t-0.5
			table.foreach(tfm.get.room.playerList, function(a, b) ui.updateTextArea(0,"<p align='center'><font size='24'><"..colors[math.ceil(t/5)]..">"..math.ceil(t) .."</"..colors[math.ceil(t/5)].."></font></p>", a) end)
			if t==20 and target=="" then
				changeTarget(false)
			end
			if t<=0 and tfm.get.room.playerList[target] and not tfm.get.room.playerList[target].isDead then
				t=5
				tfm.exec.setGameTime(5)
				tfm.exec.giveCheese(target)
				tfm.exec.playerVictory(target)
				if tfm.get.room.uniquePlayers >= 5 and inRoomModule then
					data[target][4]=data[target][4]+1
				end
				tfm.exec.setPlayerScore(target,10,true)
				saveData(target)
				finished=true
				for n in pairs(tfm.get.room.playerList) do
					if n~=target then
						tfm.exec.killPlayer(n)
					end
				end
			end
		end
	end
    if os.time()-90000 > UpdateFileTime then
        system.loadFile(3)
        UpdateFileTime = os.time()
    end
end