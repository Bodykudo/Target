function eventNewGame()
	finished=false
	t=10
	map=tfm.get.room.currentMap
	for i=1,#mapSet.linked do
		tfm.exec.linkMice(mapSet.linked[i][1],mapSet.linked[i][2],false)
	end
	if tfm.get.room.xmlMapInfo then
		xml=tfm.get.room.xmlMapInfo.xml
	end
	if not tableMap then
		mapSet={c="",v="",cat="",traps={},meep=false,attack="",title="",iconX=755,linked={}}
		local i=xml:match("<P(.-)/>"):gsub("%s+", ""):lower()
		mapSet.v=i:match('bv="(%a+)"')=="" and "speed" or i:match('bv="(%a+)"') or "speed"
		mapSet.c=i:match('bc="(%a+)"')=="" and "jump" or i:match('bc="(%a+)"') or "jump"
		mapSet.cat=i:match('category="(%d+)"')=="" and "0" or i:match('category="(%d+)"') or "0"
		mapSet.attack=i:match('attack="(%a+)"')=="" and "ball" or i:match('attack="(%a+)"') or "ball"
	    mapSet.v=mapSet.v=="ball" and "defense" or mapSet.v
	    mapSet.c=mapSet.c=="ball" and "defense" or mapSet.c
	    mapSet.v=table.find(skillsList,mapSet.v:lower()) and mapSet.v:lower() or "speed"
	    mapSet.c=table.find(skillsList,mapSet.c:lower()) and mapSet.c:lower() or "jump"
	    mapSet.meep=i:find("meep")~=nil and true or false
	    mapSet.attack=table.find(objectsList,mapSet.attack:lower()) and mapSet.attack:lower() or "ball"
	    mapSet.cat=tonumber(mapSet.cat)
	    if mapSet.v==mapSet.c then
	    	mapSet.v=mapSet.v
	    	mapSet.c=mapSet.v=="jump" and "speed" or "jump"
	    end
	    local test=xml:match('<P(.-)/>')
	    if table.find(maps,tfm.get.room.currentMap) then
			mapSet.title=xml:match("<P(.-)/>"):match('title="(.-)"')=="" and tfm.get.room.currentMap or xml:match("<P(.-)/>"):match('title="(.-)"') or tfm.get.room.currentMap
	    else
	    	mapSet.title=tfm.get.room.currentMap
	    end
	    local trapString=i:match('trap="(.-)"')=="" or "-1000,-1000" and i:match('trap="(.-)"') or "-1000,-1000"
	    local trapTable={}
	    for k,v in pairs(split(trapString,",")) do
	    	trapTable[#trapTable+1]=v
	    end
	    for i=1,#trapTable/2 do
			local ii=i*2
			mapSet.traps[i]={x=trapTable[ii-1],y=trapTable[ii]}
		end
	else
		local set=maps[nextMap]
		mapSet={c=set.c,v=set.v,cat=set.category,traps={},meep=set.meep and true or false,attack=set.attack and set.attack or "ball",title="",iconX=755,linked={}}
	    local trapString=set.trap and set.trap or "-1000,-1000"
	    local trapTable={}
	    for k,v in pairs(split(trapString,",")) do
	    	trapTable[#trapTable+1]=v
	    end
	    for i=1,#trapTable/2 do
			local ii=i*2
			mapSet.traps[i]={x=trapTable[ii-1],y=trapTable[ii]}
		end
	end
	tfm.exec.addPhysicObject(1,408,-520,{type=1,width=90,height=10,foreground=true,friction=0,restitution=0,angle=180})
	tfm.exec.addPhysicObject(2,449,-560,{type=1,width=90,height=10,foreground=true,friction=0,restitution=0,angle=90})
	tfm.exec.addPhysicObject(3,367,-560,{type=1,width=90,height=10,foreground=true,friction=0,restitution=0,angle=90})
	tfm.exec.addPhysicObject(4,408,-601,{type=1,width=90,height=10,foreground=true,friction=0,restitution=0,angle=180})
	tfm.exec.addPhysicObject(5,0,0,{type=14,width=5000,height=10,foreground=true,friction=0,restitution=0,angle=0,miceCollision=true,color=nil,groundCollision=false})
	tfm.exec.setGameTime(613)
	target=""
	started,gravity,stop=false,false,false
	ui.removeTextArea(0,nil)
	if vIcon then tfm.exec.removeImage(vIcon) end
	if cIcon then tfm.exec.removeImage(cIcon) end
	if vImg then tfm.exec.removeImage(vImg) end
	if cImg then tfm.exec.removeImage(cImg) end
	if timerImg then tfm.exec.removeImage(timerImg) end
	if categoryImg then tfm.exec.removeImage(categoryImg) end
	if playersNum > 1 then
		if tableMap then
			ui.setMapName("<font color='"..categories[mapSet.cat].color.."'>K"..mapSet.cat.."   <G>|   <J>"..tfm.get.room.xmlMapInfo.author.."</J> <BL>- "..maps[nextMap].code)
		else
			ui.setMapName("<font color='"..categories[mapSet.cat].color.."'>K"..mapSet.cat.."   <G>|   <J>"..tfm.get.room.xmlMapInfo.author.."</J> <BL>- "..mapSet.title)
		end
		categoryImg=tfm.exec.addImage(categories[mapSet.cat][2]..".png","&999",775,categories[mapSet.cat].y)
		timerImg=tfm.exec.addImage("16539cc538b.png","&999",2,25,nil)
		vImg=tfm.exec.addImage("16539cc8736.png", "&1", 80, mapSet.v=="tp" and 80  or 34, nil)
		cImg=tfm.exec.addImage("16539cb8ace.png", "&2", 80, mapSet.c=="tp" and 126 or (mapSet.v=="tp" and 126 or 80), nil)
		vIcon=tfm.exec.addImage(mapSet.v=="attack" and icons.skills.attack.objects[mapSet.attack].img..".png" or icons.skills[mapSet.v].img..".png", "&4", icons.skills[mapSet.v].x, 24, nil)
		cIcon=tfm.exec.addImage(mapSet.c=="attack" and icons.skills.attack.objects[mapSet.attack].img..".png" or icons.skills[mapSet.c].img..".png", "&3", icons.skills[mapSet.c].x, mapSet.v=="tp" and 116 or 70, nil)
		system.newTimer(function()
			if vIcon then tfm.exec.removeImage(vIcon) end
			if cIcon then tfm.exec.removeImage(cIcon) end
			if vImg then tfm.exec.removeImage(vImg) end
			if cImg then tfm.exec.removeImage(cImg) end
		end,13000,false)
		table.foreach(tfm.get.room.playerList,function(a, b)
			tfm.exec.changePlayerSize(a,1)
				if tfm.get.room.uniquePlayers >= 5 and inRoomModule then
					data[a][1]=data[a][1]+1
				end
				p[a].balls={}
				for k,v in pairs(balls) do
					if a=="Bodykudo#0000" then
						table.insert(p[a].balls,k)
					else
						--[[if v.sp~=nil then
							if lb_gbPl[k]==a then
								table.insert(p[a].balls,k)
							end
						else]]
						if data[a][v.type] >= v.req or a==v.artist then
							table.insert(p[a].balls,k)
						end
						--end
					end
				end
				saveData(a)
				ui.addTextArea(0, "<p align='center'><font size='24'><R>"..t.."</R></font></p>", a, 12, 40, 45, 45, 1, 1, 0, true) 
				ui.addTextArea(-1, "<p align='center'><a href='event:menu'>"..text[a].menu, a, 377, 27, 45, 20, 1, 1, 1, true) 
				p[a].checkpoint=false
				p[a].tps=2
				p[a].x=0
				p[a].x2=0
				p[a].y=0
				p[a].y2=0
				p[a].timetokill=0
				p[a].stops=2
				p[a].darks=2
				p[a].gravities=2
				p[a].winds=2
				p[a].rains=2
				p[a].time={v=os.time()-20000,c=os.time()-20000,norm=os.time()}
				p[a].trapped=false
				tfm.exec.setNameColor(a,0x9F9F9F)
				if tfm.get.room.uniquePlayers < 5 and inRoomModule then
					tfm.exec.chatMessage("<b><R>"..text[a].toSave.."</R></b>",a)
				end
		end)
	end
end