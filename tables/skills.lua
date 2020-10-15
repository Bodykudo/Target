skillsList={"speed","jump","tp","spirit","gravity","defense","dark","stop","attack","wind","rain","link","size","cheese"}

icons={
	skills={
		speed={img="16539cc018b",x=110},
		jump={img="16539cbd4aa",x=110},
		tp={img="1654ab69ef8",x=80},
		spirit={img="16539cc1e3e",x=110},
		gravity={img="1653b855ba4",x=110},
		defense={img="1653b853aa1",x=110},
		dark={img="1653b857362",x=110},
		stop={img="1653b8587f6",x=110},
		attack={
			objects={
				ball={img="16539ca75ce",x=110},
				arrow={img="16539cae8e3",x=110},
				chicken={img="16539cacfba",x=110},
				pufferfish={img="16539cb152e",x=110},
				snowball={img="16539cb787d",x=110},
				apple={img="16539fb43dc",x=110},
				pumpkin={img="16539cb3417",x=110},
				box={img="16539ca9712",x=110}
			},x=110
		},
		wind={img="1653b85a7d8",x=110},
		rain={img="165ba0d8b8a",x=110},
		link={img="1663ff20c37",x=110},
		size={img="1663ff1af71",x=110},
		cheese={img="1679cd6b5da",x=110}
	}
}

skills={
	speed={
		function(n,x,y)
			tfm.exec.movePlayer(n,0,0,true,p[n].right and 80 or -80,0,false)
			for i = 1,10 do
				tfm.exec.displayParticle(35,p[n].right and x or x+100,y,(p[n].righ and 15 or -15),math.random(-3,3))
				tfm.get.room.playerList[n].x=p[n].right and tfm.get.room.playerList[n].x+80 or tfm.get.room.playerList[n].x-80
			end
		end,2000
	},
	jump={
		function(n,x,y)
			tfm.exec.movePlayer(n,0,0,true,0,-80,false)
			for i = 0,15,.25 do
				tfm.exec.displayParticle(({1,9})[((i*4)%2)+1],x+math.sin(i*1.1)*20,y+40+-i*3.5)
			end
			tfm.get.room.playerList[n].y=tfm.get.room.playerList[n].y-80
		end,2000
	},
	tp={
		function(n,x,y)
			if p[n].checkpoint and y > 0 then
				tfm.exec.displayParticle(37,x,y,0,0,0,0)
				tfm.exec.movePlayer(n,p[n].cord[1],p[n].cord[2])
				tfm.exec.displayParticle(36,p[n].cord[1],p[n].cord[2],0,0,0,0)
				tfm.get.room.playerList[n].x=p[n].cord[1]
				tfm.get.room.playerList[n].y=p[n].cord[2]
				p[n].checkpoint=false
				tfm.exec.removeImage(checkImg,n)
			end
		end,1000
	},
	checkpoint={
		function(n,x,y)
			if not p[n].checkpoint and p[n].tps > 0 and y > 0 then
				checkImg=tfm.exec.addImage("164e1ab427e.png","!999",x-12,y-10,n)
				p[n].checkpoint=true
				p[n].cord={x,y}
				p[n].tps=p[n].tps-1
			end
		end
	},
	spirit={
		function(n,x,y)
			tfm.exec.addShamanObject(24,x,y+30,0,0,0,true)
		end,2000
	},
	gravity={
		function(n,x,y)
			if p[n].gravities > 0 then
				gravity=true
				p[n].gravities=p[n].gravities-1
				local X=-10
				for i=1,40 do
					X=X+20
					tfm.exec.displayParticle(3,X,390)
				end
				local gravImg=tfm.exec.addImage("165b9fe4e84.png","&5",mapSet.iconX,26,n)
				mapSet.iconX=mapSet.iconX==700 and 755 or 700
				system.newTimer(function()
					gravity=false
					tfm.exec.removeImage(gravImg,n)
				end, 2000, false)
			end
		end,6000
	},
	defense={
		function(n,x,y)
			local ballsIds={}
			for i=1,5 do
				ballsIds[#ballsIds+1]=tfm.exec.addShamanObject(6,x,y)
			end
			if #p[n].balls > 0 then
				local out,tmp,tbl={},{},{}
				local len=#p[n].balls
				if len < 5 then
					for i = 1, 4 do
						out[i]=tbl[i]
						if tbl[i] then
							tmp[tbl[i]] = true
						else
							break
						end
					end
				end
				local outLen, counter, rand = #out, 0
				for i = 1, 5 - outLen  do
					repeat
						counter = counter + 1
						rand = p[n].balls[math.random(len)]
					until not tmp[rand] or counter >= len
					counter = 0
					tmp[rand] = true
					out[outLen + i] = rand
				end
				ballsTable=out
				for i=1,5 do
					tfm.exec.addImage(balls[ballsTable[i]].img..".png","#"..tostring(ballsIds[i]),(balls[ballsTable[i]].x or -15),(balls[ballsTable[i]].y or -15))
				end
			end
			tfm.exec.movePlayer(n,408,-542)
			tfm.get.room.playerList[n].x=408
			tfm.get.room.playerList[n].y=542
			local defImg=tfm.exec.addImage("165b9fe3227.png","&6",mapSet.iconX,26,n)
			mapSet.iconX=mapSet.iconX==700 and 755 or 700
			system.newTimer(function()
				local ID=math.random(1,5)
				local X,Y=tfm.get.room.objectList[ballsIds[ID]].x,tfm.get.room.objectList[ballsIds[ID]].y
				for i=1,5 do
					tfm.exec.removeObject(ballsIds[i])
				end
				tfm.exec.movePlayer(n,X,Y)
				tfm.exec.removeImage(defImg,n)
			end,4500,false)
		end,22000
	},
	stop={
		function(n,x,y)
			if p[n].stops > 0 then
				stop=true
				p[n].stops=p[n].stops-1
				local X=-10
				for i=1,40 do
					X=X+20
					--tfm.exec.displayParticle(3,X,390)
				end
				for n in pairs(tfm.get.room.playerList) do
					p[n].X=tfm.get.room.playerList[n].x
					p[n].Y=tfm.get.room.playerList[n].y
				end
				for name in pairs(tfm.get.room.playerList) do
					if name~=n then
						tfm.exec.freezePlayer(name)
					end
				end
				local stopImg=tfm.exec.addImage("165b9fe757f.png","&7",mapSet.iconX,26,n)
				mapSet.iconX=mapSet.iconX==700 and 755 or 700
				system.newTimer(function()
					stop=false
					tfm.exec.removeImage(stopImg,n)
					for name in pairs(tfm.get.room.playerList) do
						if name~=n then
							tfm.exec.freezePlayer(name,false)
						end
					end
				end, 2000, false)
			end
		end,5000
	},
	dark={
		function(n,x,y)
			if p[n].darks > 0 then
				p[n].darks=p[n].darks-1
				for name in pairs(tfm.get.room.playerList) do
					if name~=n then
						ui.addTextArea(1,"",name,-4000,-4000,8000,8000,1,1,1,true)
					end
				end
				local darkImg=tfm.exec.addImage("165b9fe10e9.png","&8",mapSet.iconX,26,n)
				mapSet.iconX=mapSet.iconX==700 and 755 or 700
				system.newTimer(function()
					ui.removeTextArea(1,nil)
					tfm.exec.removeImage(darkImg,n)
				end,2000,false)
			end
		end,6000
	},
	attack={
		function(n,x,y)
			local object=tfm.exec.addShamanObject(objects[mapSet.attack].id,x-15,y-5,objects[mapSet.attack].angle,-objects[mapSet.attack].power)
			local object2=tfm.exec.addShamanObject(objects[mapSet.attack].id,x+15,y-5,objects[mapSet.attack].angle2,objects[mapSet.attack].power)
			system.newTimer(function()
				tfm.exec.removeObject(object)
				tfm.exec.removeObject(object2)
			end,2500,false)
		end,4000
	},
	wind={
		function(n,x,y)
			if p[n].winds > 0 then
				p[n].winds=p[n].winds-1
				for name in pairs(tfm.get.room.playerList) do
					if name~=n then
						tfm.exec.movePlayer(name,0,0,false,p[name].right and 200 or -200,-100,false)
					end
				end
				for i=1,10 do
					tfm.exec.displayParticle(26,math.random(0,800) ,math.random(50,400), ({-5,5})[math.random(1,2)],0,0,0,nil)
					tfm.exec.displayParticle(27,math.random(0,800) ,math.random(50,400), ({-5,5})[math.random(1,2)],0,0,0,nil)
				end
			end
		end,8000
	},
	rain={
		function(n,x,y)
			if p[n].rains > 0 then
				local attackingBalls={}
				for n,p in pairs(tfm.get.room.playerList) do
					if n~=target and not tfm.get.room.playerList[n].isDead then
						attackingBalls[#attackingBalls+1]=tfm.exec.addShamanObject(17,p.x,p.y-30,180,0,50)
					end
				end
				for i=1,#attackingBalls do
					if #p[n].balls > 0 then
						local ballId=p[n].balls[math.random(#p[n].balls)]
						tfm.exec.addImage(balls[ballId].img..".png","#"..tostring(attackingBalls[i]),(balls[ballId].x or -15),(balls[ballId].y or -15))
					end
				end
				system.newTimer(function()
					for i=1,#attackingBalls do
						tfm.exec.removeObject(attackingBalls[i])
					end
				end,2500,false)
			end
		end,8000
	},
	link={
		function(n)
			local linkMice={}
			local linkId=#mapSet.linked+1
			mapSet.linked[linkId]={}
			for n in pairs(tfm.get.room.playerList) do
				if n~=target and not tfm.get.room.playerList[n].isDead then
					linkMice[#linkMice+1]=n
				end
			end
			local mouse1=math.random(#linkMice)
			local mouse2=math.random(#linkMice)
			if playersNum > 2 then
				while mouse1==mouse2 do
					mouse2=math.random(#linkMice)
				end
			end
			mapSet.linked[linkId][1]=linkMice[mouse1]
			mapSet.linked[linkId][2]=linkMice[mouse2]
			tfm.exec.linkMice(linkMice[mouse1],linkMice[mouse2])
		end,4000
	},
	size={
		function(n)
			local sizedMice={}
			for n in pairs(tfm.get.room.playerList) do
				if n~=target and not tfm.get.room.playerList[n].isDead then
					sizedMice[#sizedMice+1]=n
				end
			end
			local mouse=math.random(#sizedMice)
			tfm.exec.changePlayerSize(sizedMice[mouse],0.4)
		end,4000
	},
	cheese={
		function(n)
			local cheesed={}
			for n in pairs(tfm.get.room.playerList) do
				if n~=target and not tfm.get.room.playerList[n].isDead then
					cheesed[#cheesed+1]=n
				end
			end
			local mouse=math.random(#cheesed)
			tfm.exec.giveCheese(cheesed[mouse])
		end,4000
	}
}