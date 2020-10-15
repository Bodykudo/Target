function eventKeyboard(n,k,d,x,y)
	if k==32 and not tfm.get.room.playerList[n].isDead and started and n~=target and map~="@6984945" then
		local targetSet=tfm.get.room.playerList[target]
		local range=30
		if targetSet and math.sqrt(math.pow(x - targetSet.x, 2) + math.pow(y - targetSet.y, 2)) <= range and p[n].time.norm < os.time()-1500 then
			tfm.exec.killPlayer(target)
			p[n].time.norm=os.time()
			tfm.exec.chatMessage(text[n].killed,n)
			if tfm.get.room.uniquePlayers >= 5 and inRoomModule then
				data[n][5]=data[n][5]+1
			end
			saveData(n)
			for name in pairs(tfm.get.room.playerList) do
				p[name].trapped=false
				if name~=n then
					tfm.exec.chatMessage(string.format(text[name].hasKilled,mini(n,false,true,false)),name)					
				end
			end
		end
	elseif keys[k] then
		p[n].page=1
		p[n].lbPage=1
		p[n].globalPage=1
		p[n].shopPage=1
		p[n].sub={1,2,3}
		ts[keys[k]](n,k==76 and 1 or n,false)
	elseif k==0 then
		p[n].right=false
	elseif k==2 then
		p[n].right=true
	elseif k==86 and n==target and not tfm.get.room.playerList[n].isDead and map~="@6984945" and p[n].time.v < os.time()-skills[mapSet.v][2] then
		skills[mapSet.v][1](n,x,y)
		p[n].timetokill=0
		p[n].time.v=os.time()
	elseif k==67 and n==target and not tfm.get.room.playerList[n].isDead and map~="@6984945" and p[n].time.c < os.time()-skills[mapSet.c][2] then
		skills[mapSet.c][1](n,x,y)
		p[n].timetokill=0
		p[n].time.c=os.time()
	elseif k==66 and n==target and not tfm.get.room.playerList[n].isDead and (mapSet.c=="tp" or mapSet.v=="tp") and map~="@6984945" then
		skills.checkpoint[1](n,x,y)
		p[n].time.v=mapSet.v=="tp" and os.time() or p[n].time.v
		p[n].time.c=mapSet.c=="tp" and os.time() or p[n].time.c
		p[n].timetokill=0
	end
end