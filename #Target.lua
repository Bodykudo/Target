VERSION = "1.0.0"

local translations={}
--[[ File main.lua ]]--
for _,v in pairs ({'disableAutoScore','disablePhysicalConsumables','disableAutoNewGame','disableDebugCommand','disableMortCommand','disableMinimalistMode','disableAutoTimeLeft','disableAutoShaman'}) do
	tfm.exec[v](true)
end
tfm.exec.setRoomMaxPlayers(20)

colors={
    [5]="CH",
    [4]="VP",
    [3]="FC",
    [2]="R",
    [1]="ROSE",
    [0]="ROSE"
}

keys={
    [72]="help",
    [80]="profile",
    [76]="leaderboard",
    [79]="shop"
}

buttons={
    help="help",
    leaderboard="leaderboard",
    profile="profile",
    shop="shop"
}

commus={bg="16501fe9900",br="16501feb767",es="16502016f7e",en="16502014e66",e2="16502014e66",ch="16502014e66",az="16502014e66",ee="16502012786",de="16502010d54",cz="1650200f889",cn="1650200dcb8",he="1650201cd14",fr="1650201ae36",fi="16502018f27",hu="1650202c454",hr="16502029140",it="165020300f6",id="1650202ed53",jp="165020338b5",lt="16502035415",lv="16502037161",nl="1650203a27f",pl="16502046783",ph="16502043268",pt="1650204a49f",ro="1650204bfab",ru="1650204f3c4",ar="165020563f3",sk="16502069482",vk="1650206ff15",xx="16502071c3a",tr="1650206d73c"}

id={
    lb={{},{},{},{},{},{},{},{},{},{}},
    shop={{},{},{}}
}

UpdateFileTime=os.time()
started=false
nextMap=1
lastMap=0
t=0
gravity=false
playersNum=0
stop=false
finished=false

target=""
p={}
data={}
ts={}
text={}
translations={}

function ui.addMenu(id, text, n, x, y, w, h, fixed)
    x=x+6
    y=y+6
    ui.addTextArea(id, "", n, x, y, w, h, 0x47707d, 0x47707d, 1, fixed)
    ui.addTextArea(id+1, "", n, x, y, 20, 20, 0x1e6180, 0x1e6180, 1, fixed)
    ui.addTextArea(id+2, "", n, x + w - 20, y, 20, 20, 0x1e6180, 0x1e6180, 1, fixed)
    ui.addTextArea(id+3, "", n, x, y + h - 20, 20, 20, 0x1e6180, 0x1e6180, 1, fixed)
    ui.addTextArea(id+4, "", n, x + w - 20, y + h - 20, 20, 20, 0x1e6180, 0x1e6180, 1, fixed)
    ui.addTextArea(id+5, "", n, x, y + (h + 40) / 4, w, ((h - 40) / 2), 0x0e3642, 0x0e3642, 1, fixed)
    ui.addTextArea(id+6, "", n, x + (w + 40) / 4, y, ((w - 40) / 2), h, 0x0e3642, 0x0e3642, 1, fixed)
    ui.addTextArea(id+7, text, n, x + 3, y + 3, w - 6, h - 6, 0x193542, 0x0E1619, 1, fixed)
end

function ui.addButton(id,text,n,x,y,w,h,fixed,button)
    x=x+6
    y=y+6
    ui.addTextArea(id, "", n, x, y, w, h, 0x47707d, 0x47707d, 1, fixed)
    ui.addTextArea(id+1, "<p align='center'>"..text, n, x + 1, y + 1, w - 2, h - 2, 0x193542, 0x0E1619, 1, fixed)
    if button then
    	ui.addTextArea(id+2,"<textformat leftmargin='1' rightmargin='1'><a href='event:"..button.."'>"..string.rep("\n",50),n, x + 1, y + 1, w - 2, h - 2, 0x193542, 0x0E1619, 0, fixed)
    end
end

function close(n)
	for i=2,30 do
		ui.removeTextArea(i,n)
	end
	for i=1,10 do
		if id.lb[i][n] then
			tfm.exec.removeImage(id.lb[i][n],n)
			id.lb[i][n]=nil
		end
	end
end
--[[ End of file main.lua ]]--
--[[ Directory functions ]]--
--[[ File functions/otherFunctions.lua ]]--
function split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

function mini(pr,leader,message,global)
	if pr~=nil then
		if leader then
	   		return pr:sub(0,1)=="*" and (pr:len() > 12 and "<a href='event:pr_"..pr.."'>"..pr:sub(0,12).."</a></font>.." or "<a href='event:pr_"..pr.."'>"..pr.."</a></font>") or pr:len()-5 > 12 and "<a href='event:pr_"..pr.."'>"..pr:sub(0,12).."</a></font>..<font size='8'><V>"..pr:sub(-5).."</V></font>" or "<a href='event:pr_"..pr.."'>"..pr:sub(1,pr:len()-5).."</a></font><font size='8'><V>"..pr:sub(-5).."</V></font>"
	    elseif global then
	   		return pr:sub(0,1)=="*" and (pr:len() > 12 and pr:sub(0,12).."</a></font>.." or pr.."</font>") or pr:len()-5 > 12 and pr:sub(0,12).."</font>..<font size='8'><V>"..pr:sub(-5).."</V></font>" or pr:sub(1,pr:len()-5).."</font><font size='8'><V>"..pr:sub(-5).."</V></font>"
	    elseif message then
	    	return pr:sub(0,1)=="*" and ("<BV>"..pr.."</B>") or "<BV>"..pr:sub(1,pr:len()-5).."</BV><font color='#606090' size='10'><V>"..pr:sub(-5).."</V></font>"
	    else
	    	return pr:sub(0,1)=="*" and (pr:len() > 12 and pr:sub(0,12).."</font>.." or pr.."</font>") or pr:len()-5 > 12 and pr:sub(0,12).."</font>..<font size='15' face='Soopafresh'><V>"..pr:sub(-5).."</V></font>" or pr:sub(1,pr:len()-5).."</font><font size='15' face='Soopafresh'><V>"..pr:sub(-5).."</V></font>"
	    end
	end
end
--[[ End of file functions/otherFunctions.lua ]]--
--[[ File functions/tableFunctions.lua ]]--
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
--[[ End of file functions/tableFunctions.lua ]]--
--[[ End of directory functions ]]--
--[[ Directory tables ]]--
--[[ File tables/balls.lua ]]--
artists={a="Argilita#0000"}
balls={
	--[[{img="165f371d5f9",req=1,type=1,text="global",sp=true},
	{img="165f371bd47",req=2,type=1,text="global",sp=true},
	{img="165f371ef7b",req=3,type=1,text="global",sp=true},]]
	{img="1686d20d4de",req=50,type=2,text="win",artist=artists.a},
	{img="1686d20b7a0",req=100,type=2,text="win",artist=artists.a},
	{img="168866f7234",req=150,x=-16,y=-18,xs=12,ys=7,type=2,text="win",artist=artists.a},
	{img="1686d209a49",req=30,type=3,text="winMouse",artist=artists.a},
	{img="1686d205fbe",req=60,type=3,text="winMouse",artist=artists.a},
	{img="1686d207cfb",req=100,type=3,text="winMouse",artist=artists.a},
	{img="1686d20427e",req=30,x=-20,y=-20,xs=11,ys=5,type=4,text="winTarget",artist=artists.a},
	{img="1686d2024d9",req=60,y=-17,ys=8,type=4,text="winTarget",artist=artists.a},
	{img="168866fc9c8",req=100,x=-17,y=-14,xs=12,ys=9,type=4,text="winTarget",artist=artists.a},
	{img="168866f8f51",req=80,x=-23,y=-18,xs=10,ys=7,type=5,text="kill",artist=artists.a},
	{img="168866fac65",req=160,x=-22,y=-21,xs=11,ys=6,type=5,text="kill",artist=artists.a},
	{img="168866fe6f3",req=250,x=-21,y=-21,xs=11,ys=6,type=5,text="kill",artist=artists.a},
	--[[{img="",req=300,type=1,text="winTarget"},
	{img="",req=300,type=5,text="winTarget"},
	{img="",req=180,type=2,text="winTarget"},]]
}
--[[ End of file tables/balls.lua ]]--
--[[ File tables/maps.lua ]]--
maps={
    "@7555559",
    "@7555550",
    "@6997689",
    "@6997250",
    "@6978892",
    "@6998702",
    "@6536451",
    "@6537482",
    "@7517295",
    "@7515260",
    "@7181539",
    "@7293314",
    "@6127820",
    "@6600843",
    "@7502120",
    "@7452667",
    "@5876406",
    "@7500090",
    "@7504501",
    "@7500051",
    "@7374565",
    "@5280099",
    "@7284716",
    "@7245483",
    "@7278964",
    "@7281232",
    "@7291577",
    "@7289495",
    "@7246689",
    "@7069376",
    "@7081266",
    "@7215021",
    "@7487037",
    "@7487483",
    "@7489204",
    "@7489570",
    "@7490308",
    "@7393606",
    "@7491912",
    "@7491957",
    "@7491265",
	{code="@7233571",v="defense",c="stop",category="6",trap="240,147,458,362,459,261,433,234,140,310,77,322,287,338,675,281,730,140,606,42,215,39"},
	{code="@7135255",v="tp",c="size",category=0},
	{code="@6748763",v="gravity",c="rain",category=0,meep=true},
	{code="@7180898",v="defense",c="tp",category=6,meep=true,trap="410,346,535,340,180,219,260,219,266,115,200,107,107,107,455,180,415,144,594,239,670,99"},
	{code="@7384823",v="spirit",c="link",category=4},
	{code="@7253880",v="gravity",c="jump",category=6,trap="153,363,35,320,15,259,58,167,85,100,577,100,680,167,765,320"},
	{code="@7166429",v="tp",c="stop",category=0,meep=true},
	{code="@7429544",v="dark",c="attack",category=0,attack="box"},
	{code="@7051516",v="speed",c="jump",category=4},
	{code="@7096446",v="tp",c="link",category=0},
	{code="@7386572",v="tp",c="spirit",category=0},
	{code="@7407998",v="defense",c="size",category=2},
	{code="@6407899",v="dark",c="jump",category=6,trap="178,258,620,258,505,242,240,80,404,50,600,80,60,101"},
	{code="@5549355",v="tp",c="stop",category=0},
	{code="@6938082",v="defense",c="link",category=0},
	{code="@7406132",v="wind",c="speed",category=3},
	{code="@7152183",v="defense",c="wind",category=0},
	{code="@7279657",v="defense",c="link",category=0},
	{code="@7303260",v="rain",c="link",category=2},
	{code="@7233156",v="wind",c="gravity",category=4},
	{code="@7283041",v="dark",c="size",category=4},
}

categories={
	[0]={"nromal","164dc8ede60",y=374,color="#00A102"},
	[1]={"mech","164dc8efe37",y=372,color="#868B86"},
	[2]={"art","164dc9f31bd",y=371,color="#BB2174"},
	[3]={"defilante","164dc8f5738",y=372,color="#CEC71B"},
	[4]={"shaman","164ed7eaf62",y=371,color="#1B8BCE"},
	[5]={"aie","164df18afef",y=374,color="#647E07"},
	[6]={"trapped","165025d5ce8",y=374,color="#4B2D06"},
}

mapSet={c="",v="",cat="",traps={},meep=false,attack="",title="",iconX=755,linked={}}
--[[ End of file tables/maps.lua ]]--
--[[ File tables/objects.lua ]]--
objectsList={"ball","arrow","chicken","pufferfish","snowball","apple","pumpkin","box"}

objects={
	ball={id=6,angle=0,angle2=0,power=35},
	arrow={id=35,angle=180,angle2=0,power=35},
	chicken={id=33,angle=-90,angle2=90,power=35},
	pufferfish={id=65,angle=-90,angle2=90,power=35},
	snowball={id=34,angle=0,angle2=0,power=35},
	apple={id=39,angle=0,angle2=0,power=35},
	pumpkin={id=89,angle=0,angle2=0,power=35},
	box={id=1,angle=0,angle2=0,power=35},
}
--[[ End of file tables/objects.lua ]]--
--[[ File tables/skills.lua ]]--
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
--[[ End of file tables/skills.lua ]]--
--[[ End of directory tables ]]--
--[[ Directory translations ]]--
--[[ File translations/ar.lua ]]--
translations.ar={
    new="<b><BV>The Shop</BV></b> <VP>has been added!</VP>",
    ready="<J>أنتَ هو الهدف التالي, كُن مُستعدًا!</J>",
    discord="لا تنسى أن تنضم لمخدمنا الرسمي على الديسكورد:",
    disabled="غير مُتاح",
    enabled="مُتاح",
    quests={
        global="كُن <FC>#%s</FC> في قائمة الصدارة العالمية",
        win="اكسب  <VP>%s</VP> / <VP>%s</VP> جولة.",
        winMouse="اكسب <VP>%s</VP> / <VP>%s</VP> جولة <VP>كفأر</VP>.",
        winTarget="اكسب <VP>%s</VP> / <VP>%s</VP> جولة <VP>كهدف</VP>.",
        kill="اقتل <VP>%s</VP> / <VP>%s</VP> هدفًا.",
        play="العب <VP>%s</VP> / <VP>%s</VP> جولة."
    },
    leaderRoom="الغرفة",
    leaderGlobal="العالمية",
    toSave="يَجب أن يَتواجد عَلَى الأَقل 5 لَاعبين بِالغُرفة حَتَى يَتِم حِفظ البيَّانات!",
    buttons={
        shop="Shop",
        profile="الملف الشخصي",
        help="المساعدة",
        rank="قائمة الصدارة"
    },
    menu="القائمة",
    lgs="اللغات المتاحة هي",
    next="التالي",
    pre="السابق",
    help={
        "<p align='center'><font size='30' face='Soopafresh'><VP>#Target</VP></font>\n\n<p align='right'><font size='12'>مرحبًا في <b><VP>#Target</VP></b>, في هذه اللعبة, هَدفك هو أن تُمسك <b><VP>بِالهَدف</VP></b>, عليكَ أن <b><VP>تضغط</VP></b> على <b><VP>زر مسافة</VP></b> عِندما تكون قريبًا مِنه حتى <b><VP>تَقتله</VP></b>, اِستَخدِم الأزرار <b><VP>C</VP></b>, <b><VP>V</VP></b> عِنَدما تَكون <b><VP>الهَدف</VP></b> لتحصل على بعض <b><VP>المقويَّات</VP></b> لكي تهرُب, <b><VP>الهدف</VP></b> علي أنه ينجوا لمدة <b><VP>ثانية 20</VP></b>, إذا نجا, فسوف <b><VP>يفوز</VP></b> وبقية الفئران ستموت.",
        "<p align='center'><font size='30' face='Soopafresh'><VP>الأوامر</VP></font>\n\n<p align='left'><font size='12'><b><VP>!help</VP></b> أو <b><VP>H</VP></b> - عرض معلومات حول هذه اللعبة.\n<b><VP>!shop</VP></b> or <b><VP>O</VP></b> - Displays the shop.\n<b><VP>!leaderboard</VP></b> أو <b><VP>L</VP></b> - عَرض ترتيب الغُرفة.\n<b><VP>!profile </VP></b>[<b>Name#</b>] أو <b><VP>P</VP></b>  - عَرض مَلفك الشخصي أو ملف شخصٍ ما\n<b><VP>!lang</VP></b>  [<b><a href='event:langs'><BV>XX</BV></a></b>] - تَغيير اللغة الحالية",
        "<p align='center'><font size='30' face='Soopafresh'><VP>الائتمان</VP></font>\n<p align='left'><font size='12'>\n<BV><b>Bodykudo</b></BV><V><font size='10'>#0000</font></V> هذه اللُعبة تم تَطويرها بِوَاسطة\n<BV><b>Flindix</b></BV><V><font size='10'>#0095</font></V>, <BV><b>Argilita</b></BV><V><font size='10'>#0000</font></V> - Artist\n<BV><b>Sebafrancuz</b></BV><V><font size='10'>#0000</font></V>, <BV><b>Turkitutu</b></BV><V><font size='10'>#0000</font></V></V> - ساعدوا ببعض الأكواد\n\n<BV><b>Uvfn</b></BV><V><font size='10'>#0000</font></V>, <BV><b>Ju_ven</b></BV><V><font size='10'>#0000</font></V>, <BV><b>Syc</b></BV><V><font size='10'>#1270</font></V>, <BV><b>Blank</b></BV><V><font size='10'>#3495</font></V> - ساعدوا بأفكار النمط."
    },
    name="الاسم",
    commu="المجتمع",
    rounds="الجولات الملعوبة",
    wins="عدد مرات الفوز",
    winsB="الفوز",
    winsMouse="عدد مرات الفوز كفأر",
    winsTarget="عدد مرات الفوز كهدف",
    killedTargets="الأهداف المقتولة",
    close="إغلاق",
    welcome="<VP><BV><b>#Target</b></BV> مرحبًا في<br> ،<BV><b>الهدف</b></BV> هدفك هو أن تمسك<br> عندما تكون قريبًا منه لتقتله <BV><b>مسافة</b></BV> اضغط على زر</VP>",
    target="<ROSE>الآن أنت الهدف، اهرب من المغتالين</ROSE>",
    isTarget="<ROSE>!هو الهدف الآن، الحقوا به</ROSE> %s",
    won="<J>!قد فاز بالجولة</J> %s",
    killed="<VP>!لقد قَتلت الهدف<VP>",
    hasKilled="<VP>!قد قتل الهدف</VP> %s",
    skills={
        speed="<Rose>لتحصل على سرعة %s اضغط على</ROSE>",
        wind="<ROSE>لتفعيل الرِياح %s اضغط على</ROSE>",
        jump="<ROSE>لتحصل على قفزة عالية %s اضغط على</ROSE>",
        tp="<ROSE>لتنتقل لها %s لتضع نقطة انتقال، اضغط على <BV><b>B</b></BV> اضغط على</ROSE>",
        spirit="<ROSE>لتقوم بعمل فرقعة %s اضغط على</ROSE>",
        defense="<ROSE>لتكون بهيئة الدفاع %s اضغط على</ROSE>",
        gravity="<ROSE>لتغيير الجاذبية %s اضغط على</ROSE>",
        attack="<ROSE>%s اضغط على %s لرمي</ROSE>",
        stop="<ROSE>لإيقاف اللاعبين عن الحركة %s اضغط على</ROSE>",
        dark="<ROSE>لتشغيل طور الظلام %s اضغط على</ROSE>",
        rain="<ROSE>Click at %s to make it rain</ROSE>",
        link="<ROSE>Click at %s to link two mice together</ROSE>",
        size="<ROSE>Click at %s to change a random player's size</ROSE>",
        cheese="<ROSE>Click at %s to give cheese to a random player</VP>"
    },
    objects={
        ball="كرة شاطئ",
        arrow="سهم",
        chicken="دجاجة",
        pufferfish="سمكة منفوخة",
        snowball="كرة ثلج",
        apple="تفاحة",
        pumpkin="يقطينة",
        box="صُندوق"
    }
}
--[[ End of file translations/ar.lua ]]--
--[[ File translations/br.lua ]]--
translations.br={
    new="<b><BV>The Shop</BV></b> <VP>has been added!</VP>",
    ready="<J>You're the next target, Get Ready!</J>",
    discord="Não se esqueça de entrar em nosso Servidor do Discord oficial:",
    disabled="Desativado",
    enabled="Ativado",
    quests={
        global="Become the <FC>#%s</FC> in the global leaderboard",
        win="Vença <VP>%s</VP> / <VP>%s</VP> partidas.",
        winMouse="Vença <VP>%s</VP> / <VP>%s</VP> partidas como um  <VP>rato</VP>.",
        winTarget="Vença <VP>%s</VP> / <VP>%s</VP> partidas como um <VP>alvo</VP>.",
        kill="Mate <VP>%s</VP> / <VP>%s</VP> alvos.",
        play="Jogue <VP>%s</VP> / <VP>%s</VP> partidas."
    },
    leaderRoom="Sala",
    leaderGlobal="Global",
    toSave="Devem haver pelo menos  5 jogadores na sala para que os dados sejam salvos!",
    buttons={
        shop="Shop",
        profile="Perfil",
        help="Ajuda",
        rank="Classificação"
    },
    menu="Menu",
    lgs="Os idiomas disponíveis são",
    next="Próximo",
    pre="Anterior",
    help={
        "<p align='center'><font size='30' face='Soopafresh'><VP>#Target</VP></font>\n\n<p align='left'><font size='12'>Bem-vindo a <b><VP>#Target</VP></b>, neste jogo o seu objetivo é pegar o <b><VP>alvo</VP></b>, para isso você tem de <b><VP>pressionar</VP></b> a <b><VP>Barra de Espaços</VP></b> quando estiver perto dele para o <b><VP>Matar</VP></b>, use os botões <b><VP>C</VP></b>,<b><VP>V</VP></b> quando você é o <b><VP>alvo</VP></b> para ganhar <b><VP>poderes</VP></b> para escapar, o <b><VP>alvo</VP></b> tem de sobreviver por <b><VP>20 Segundos</VP></b>, caso sobreviva, <b><VP>ganhará</VP></b> e os restantes ratos irão morrer",
        "<p align='center'><font size='30' face='Soopafresh'><VP>Comandos</VP></font>\n\n<p align='left'><font size='12'><b><VP>!help</VP></b> ou <b><VP>H</VP></b> - Exibe mais informação sobre o jogo.\n<b><VP>!shop</VP></b> or <b><VP>O</VP></b> - Displays the shop.\n<b><VP>!leaderboard</VP></b> ou <b><VP>L</VP></b> - Exibe a classificação da sala\n<b><VP>!profile </VP></b>[<b>Name#0000</b>] ou <b><VP>P</VP></b>  - Exibe o perfil, seu ou de alguém.\n<b><VP>!lang</VP></b>  [<b><a href='event:langs'><BV>XX</BV></a></b>] - Altera o idioma do module",
        "<p align='center'><font size='30' face='Soopafresh'><VP>Créditos</VP></font>\n<p align='left'><font size='12'>\nEste jogo foi desenvolvido por <BV><b>Bodykudo</b></BV><V><font size='10'>#0000</font></V>\n<BV><b>Flindix</b></BV><V><font size='10'>#0095</font></V>, <BV><b>Argilita</b></BV><V><font size='10'>#0000</font></V> - Artist\n<BV><b>Sebafrancuz</b></BV><V><font size='10'>#0000</font></V>, <BV><b>Turkitutu</b></BV><V><font size='10'>#0000</font></V></V> - Com a ajuda de alguns códigos\n<BV><b>Flindix</b></BV><V><font size='10'>#0095</font></V>, <BV><b>Argilita</b></BV><V><font size='10'>#0000</font></V> - BR Tradução\n<BV><b>Uvfn</b></BV><V><font size='10'>#0000</font></V>, <BV><b>Ju_ven</b></BV><V><font size='10'>#0000</font></V>, <BV><b>Syc</b></BV><V><font size='10'>#1270</font></V>, <BV><b>Blank</b></BV><V><font size='10'>#3495</font></V> - Ajuda com ideias para o module"
    },
    name="Nome",
    commu="Comunidade",
    winsB="Vitórias",
    rounds="Partidas Jogadas",
    wins="Vitórias",
    winsMouse="Vitórias enquanto rato",
    winsTarget="Vitórias enquanto alvo",
    killedTargets="Alvos abatidos",
    close="Close",
    welcome="<VP>Bem-vindo a<BV><b>#Target</b></BV>, o seu objetivo é pegar o <BV><b>alvo</b></BV>, pressione a <BV><b>Barra de Espaços</b></BV> quando estiver perto dele para o matar!</VP>",
    target="<ROSE>Agora você é o alvo, fuja dos assassinos</ROSE>",
    isTarget="%s <ROSE>é o alvo, pegue-o!</ROSE>",
    won="%s <J>ganhou a rodada!</J>",
    killed="<VP>Você abateu o alvo!<VP>",
    hasKilled="%s <VP>abateu o alvo!</VP>",
    skills={
        speed="<Rose>Clique em %s para ativar o impulso de velocidade</ROSE>",
        wind="<ROSE>Clique em %s para ativar vento </ROSE>",
        jump="<ROSE>Clique em %s para ativar o pulo alto</ROSE>",
        tp="<ROSE>Clique em <BV><b>B</b></BV> para fazer um ponto de controlo, clique em %s para se teleportar para ele</ROSE>",
        spirit="<ROSE>Clique em %s para gerar um sp</ROSE>",
        defense="<ROSE>Clique em %s para ficar no estado defensive</ROSE>",
        gravity="<ROSE>Clique em %s para alterar a gravidade</ROSE>",
        attack="<ROSE>Clique em %s para atirar um(a) %s</ROSE>",
        stop="<ROSE>Clique em %s para parar o movimento dos jogadores</ROSE>",
        dark="<ROSE>Clique em %s para ativar o modo noite</ROSE>",
        rain="<ROSE>Click at %s to make it rain</ROSE>",
        link="<ROSE>Click at %s to link two mice together</ROSE>",
        size="<ROSE>Click at %s to change a random player's size</ROSE>",
        cheese="<ROSE>Click at %s to give cheese to a random player</VP>"
    },
    objects={
        ball="Bola de praia",
        arrow="Seta",
        chicken="Galinha",
        pufferfish="Baiacu",
        snowball="Bola de neve",
        apple="Maçã",
        pumpkin="Abóbora",
        box="Caixa"
    }
}
translations.pt=translations.br
--[[ End of file translations/br.lua ]]--
--[[ File translations/en.lua ]]--
translations.en={
    new="<b><BV>The Shop</BV></b> <VP>has been added!</VP>",
    ready="<J>You're the next target, Get Ready!</J>",
    discord="Don't forget to join our official Discord Server:",
    disabled="Unavailable ",
    enabled="Available ",
    quests={
        global="Become the <FC>#%s</FC> in the global leaderboard",
        win="Win <VP>%s</VP> / <VP>%s</VP> rounds.",
        winMouse="Win <VP>%s</VP> / <VP>%s</VP> rounds as a <VP>mouse</VP>.",
        winTarget="Win <VP>%s</VP> / <VP>%s</VP> rounds as a <VP>target</VP>.",
        kill="Kill <VP>%s</VP> / <VP>%s</VP> targets.",
        play="Play <VP>%s</VP> / <VP>%s</VP> rounds."
    },
    leaderRoom="Room",
    leaderGlobal="Global",
    toSave="There must be at least 5 players in the room in order to save the data!",
    buttons={
        shop="Shop",
        profile="Profile",
        help="Help",
        rank="Leaderboard"
    },
    menu="Menu",
    lgs="The available languages are",
    next="Next",
    pre="Previous",
    help={
        "<p align='center'><font size='30' face='Soopafresh'><VP>#Target</VP></font>\n\n<p align='left'><font size='12'>Welcome to <b><VP>#Target</VP></b>, in this game your aim is to catch the <b><VP>target</VP></b>, you have to <b><VP>press</VP></b> <b><VP>Space Bar</VP></b> when you're nearby to them in order to <b><VP>Kill them</VP></b>, use the buttons <b><VP>C</VP></b>,<b><VP>V</VP></b> when you're the <b><VP>target</VP></b> to get some <b><VP>powerups</VP></b> to escape, the <b><VP>target</VP></b> has to survive for <b><VP>20 Seconds</VP></b>, if he survives, he'll <b><VP>win</VP></b> and the other mice will die.",
        "<p align='center'><font size='30' face='Soopafresh'><VP>Commands</VP></font>\n\n<p align='left'><font size='12'><b><VP>!help</VP></b> or <b><VP>H</VP></b> - Displays info about the game.\n<b><VP>!shop</VP></b> or <b><VP>O</VP></b> - Displays the shop.\n<b><VP>!leaderboard</VP></b> or <b><VP>L</VP></b> - Displays the room ranking.\n<b><VP>!profile </VP></b>[<b>Name#0000</b>] or <b><VP>P</VP></b>  - Displays your or someone's profile.\n<b><VP>!lang</VP></b>  [<b><a href='event:langs'><BV>XX</BV></a></b>] - Changes the current language.",
        "<p align='center'><font size='30' face='Soopafresh'><VP>Credits</VP></font>\n<p align='left'><font size='12'>\nThis game was developed by <BV><b>Bodykudo</b></BV><V><font size='10'>#0000</font></V>\n<BV><b>Flindix</b></BV><V><font size='10'>#0095</font></V>, <BV><b>Argilita</b></BV><V><font size='10'>#0000</font></V> - Artist\n<BV><b>Sebafrancuz</b></BV><V><font size='10'>#0000</font></V>, <BV><b>Turkitutu</b></BV><V><font size='10'>#0000</font></V></V> - Helped with some codes\n<BV><b>Bodykudo</b></BV><V><font size='10'>#0000</font></V> - EN Translation\n<BV><b>Uvfn</b></BV><V><font size='10'>#0000</font></V>, <BV><b>Ju_ven</b></BV><V><font size='10'>#0000</font></V>, <BV><b>Syc</b></BV><V><font size='10'>#1270</font></V>, <BV><b>Blank</b></BV><V><font size='10'>#3495</font></V> - Helped with this module's ideas"
    },
    name="Name",
    commu="Community",
    winsB="Wins",
    rounds="Played Rounds",
    wins="Wins",
    winsMouse="Wins as Mouse",
    winsTarget="Wins as Target",
    killedTargets="Killed Targets",
    close="Close",
    welcome="<VP>Welcome to <BV><b>#Target</b></BV>, your aim is to catch the <BV><b>target</b></BV>, press <BV><b>Space</b></BV> when you're nearby to them to kill them!</VP>",
    target="<ROSE>Now you're the target, run away from the assassinators</ROSE>",
    isTarget="%s <ROSE>is the target now, catch him!</ROSE>",
    won="%s <J>has won the round!</J>",
    killed="<VP>You have killed the target!<VP>",
    hasKilled="%s <VP>has killed the target!</VP>",
    skills={
        speed="<Rose>Click at %s to get a speed boost</ROSE>",
        wind="<ROSE>Click at %s to enable the wind</ROSE>",
        jump="<ROSE>Click at %s to high jump</ROSE>",
        tp="<ROSE>Click at <BV><b>B</b></BV> to make a checkpoint, click at %s to teleport to it</ROSE>",
        spirit="<ROSE>Click at %s to spawn a spirit</ROSE>",
        defense="<ROSE>Click at %s to be in the defense form</ROSE>",
        gravity="<ROSE>Click at %s to change the gravity</ROSE>",
        attack="<ROSE>Click at %s to throw a %s</ROSE>",
        stop="<ROSE>Click at %s to stop the players from moving</ROSE>",
        dark="<ROSE>Click at %s to enable the DarkMode</ROSE>",
        rain="<ROSE>Click at %s to make it rain</ROSE>",
        link="<ROSE>Click at %s to link two mice together</ROSE>",
        size="<ROSE>Click at %s to change a random player's size</ROSE>",
        cheese="<ROSE>Click at %s to give cheese to a random player</VP>"
    },
    objects={
        ball="Beach ball",
        arrow="Arrow",
        chicken="Chicken",
        pufferfish="Pufferfish",
        snowball="Snowball",
        apple="Apple",
        pumpkin="Pumpkin",
        box="Box"
    }
}
--[[ End of file translations/en.lua ]]--
--[[ File translations/es.lua ]]--
translations.es={
    new="<b><BV>The Shop</BV></b> <VP>has been added!</VP>",
    ready="<J>You're the next target, Get Ready!</J>",
    discord="No olvides unirte a tu Servidor oficial en Discord:",
    disabled="Desactivado",
    enabled="Activado",
    quests={
        global="Become the <FC>#%s</FC> in the global leaderboard",
        win="Gana <VP>%s</VP> / <VP>%s</VP> rondas.",
        winMouse="Gana <VP>%s</VP> / <VP>%s</VP> rondas como un <VP>ratón</VP>.",
        winTarget="Gana <VP>%s</VP> / <VP>%s</VP> rondas como un <VP>objetivo</VP>.",
        kill="Mata <VP>%s</VP> / <VP>%s</VP> objetivos.",
        play="Juega <VP>%s</VP> / <VP>%s</VP> rondas."
    },
    leaderRoom="Sala",
    leaderGlobal="Global",
    toSave="¡Se necesitan al menos 5 jugadores en la sala para guardar los datos!",
    buttons={
        shop="Shop",
        profile="Perfil",
        help="Ayuda",
        rank="Clasificación"
    },
    menu="Menú",
    lgs="Los idiomas disponibles son",
    next="Siguiente",
    pre="Anterior",
    help={
        "<p align='center'><font size='30' face='Soopafresh'><VP>#Target</VP></font>\n\n<p align='left'><font size='12'>Bienvenido a <b><VP>#Target</VP></b>, el objetivo de este juego es atrapar al <b><VP>jugador elegido</VP></b>, tienes que <b><VP>presionar</VP></b> la <b><VP>Barra Espaciadora</VP></b> cuando estás cerca de ellos para <b><VP>matarlos</VP></b>, usa los botones <b><VP>C</VP></b>,<b><VP>V</VP></b> cuando tú eres el <b><VP>objetivo</VP></b> para obtener algunos <b><VP>poderes</VP></b> para escapar, el <b><VP>objetivo</VP></b> tiene que sobrevivir durante <b><VP>20 segundos</VP></b>, si lo consigue, <b><VP>ganará</VP></b> y los otros ratones morirán.",
        "<p align='center'><font size='30' face='Soopafresh'><VP>Comandos</VP></font>\n\n<p align='left'><font size='12'><b><VP>!help</VP></b> o <b><VP>H</VP></b> - Muestra información sobre el juego.\n<b><VP>!shop</VP></b> or <b><VP>O</VP></b> - Displays the shop.\n<b><VP>!leaderboard</VP></b> o la tecla <b><VP>L</VP></b> - Muestra la tabla de líderes de la sala.\n<b><VP>!profile </VP></b>[<b>Nombre#0000</b>] o la tecla <b><VP>P</VP></b> - muestra tu perfil o el de otra persona.\n<b><VP>!lang</VP></b>  [<b><a href='event:langs'><BV>XX</BV></a></b>] - Cambia el idioma.",
        "<p align='center'><font size='30' face='Soopafresh'><VP>Créditos</VP></font>\n<p align='left'><font size='12'>\nEl juego fue creado por <BV><b>Bodykudo</b></BV><V><font size='10'>#0000</font></V>\n<BV><b>Flindix</b></BV><V><font size='10'>#0095</font></V>, <BV><b>Argilita</b></BV><V><font size='10'>#0000</font></V> - Artista\n<BV><b>Sebafrancuz</b></BV><V><font size='10'>#0000</font></V>, <BV><b>Turkitutu</b></BV><V><font size='10'>#0000</font></V></V> - Ayudaron con algunos códigos\n<BV><b>Tocutoeltuco</b></BV><V><font size='10'>#0000</font></V> - Traducción ES\n<BV><b>Uvfn</b></BV><V><font size='10'>#0000</font></V>, <BV><b>Ju_ven</b></BV><V><font size='10'>#0000</font></V>, <BV><b>Syc</b></BV><V><font size='10'>#1270</font></V>, <BV><b>Blank</b></BV><V><font size='10'>#3495</font></V> - Ayudaron con las ideas del módulo"
    },
    name="Nombre",
    commu="Comunidad",
    winsB="Victorias",
    rounds="Rondas Jugadas",
    wins="Victorias",
    winsMouse="Victorias como Ratón",
    winsTarget="Victorias como Objetivo",
    killedTargets="Objetivos Asesinados",
    close="Cerrar",
    welcome="<VP>Bienvenido a <BV><b>#Target</b></BV>, tu objetivo es atrapar al <BV><b>objetivo</b></BV>, ¡presiona la <BV><b>Barra Espaciadora</b></BV> cuando estés cerca de ellos para matarlos!</VP>",
    target="<ROSE>Ahora eres el target, ¡escapa de los asesinos!</ROSE>",
    isTarget="¡%s <ROSE>es ahora el objetivo, atrápalo!</ROSE>",
    won="¡%s <J>ha ganado la ronda!</J>",
    killed="¡<VP>Has matado al objetivo!<VP>",
    hasKilled="¡%s <VP>ha matado al objetivo!</VP>",
    skills={
        speed="<Rose>Presiona la tecla %s para obtener un potenciador de velocidad</ROSE>",
        wind="<ROSE>Presiona la tecla %s para activar el viento</ROSE>",
        jump="<ROSE>Presiona la tecla %s para hacer un gran salto</ROSE>",
        tp="<ROSE>Presiona la tecla <BV><b>B</b></BV> para hacer un checkpoint, presiona la tecla %s para teletransportarte al mismo</ROSE>",
        spirit="<ROSE>Presiona la tecla %s para hacer aparecer una chispa</ROSE>",
        defense="<ROSE>Presiona la tecla %s para activar el modo de defensa</ROSE>",
        gravity="<ROSE>Presiona la tecla %s para cambiar la gravedad</ROSE>",
        attack="<ROSE>Presiona la tecla %s para lanzar un %s</ROSE>",
        stop="<ROSE>Presiona la tecla %s para hacer que los jugadores se detengan</ROSE>",
        dark="<ROSE>Presiona la tecla %s para activar el modo oscuro</ROSE>",
        rain="<ROSE>Click at %s to make it rain</ROSE>",
        link="<ROSE>Click at %s to link two mice together</ROSE>",
        size="<ROSE>Click at %s to change a random player's size</ROSE>",
        cheese="<ROSE>Click at %s to give cheese to a random player</VP>"
    },
    objects={
        ball="Pelota de playa",
        arrow="Flecha",
        chicken="Gallina",
        pufferfish="Pez globo",
        snowball="Bola de nieve",
        apple="Manzana",
        pumpkin="Calabaza",
        box="Caja"
    }
}
--[[ End of file translations/es.lua ]]--
--[[ File translations/fr.lua ]]--
translations.fr={
    new="<b><BV>The Shop</BV></b> <VP>has been added!</VP>",
    ready="<J>You're the next target, Get Ready!</J>",
    discord="Don't forget to join our official Discord Server:",
    disabled="Indisponible",
    enabled="Disponible",
    quests={
        global="Become the <FC>#%s</FC> in the global leaderboard",
        win="Gagner <VP>%s</VP> / <VP>%s</VP> parties.",
        winMouse="Gagner <VP>%s</VP> / <VP>%s</VP> parties comme <VP>souris</VP>.",
        winTarget="Gagner <VP>%s</VP> / <VP>%s</VP> parties comme <VP>cibles</VP>.",
        kill="Tuer <VP>%s</VP> / <VP>%s</VP> cibles.",
        play="Jouer <VP>%s</VP> / <VP>%s</VP> parties."
    },
    leaderRoom="Salon",
    leaderGlobal="Global",
    toSave="Au moins 5 joueurs doivent être présents dans le salon pour que les statistiques soient sauvegardées !",
    buttons={
        shop="Shop",
        profile="Profil",
        help="Aide",
        rank="Classement"
    },
    menu="Menu",
    lgs="Les langues disponibles sont",
    next="Suivant",
    pre="Précédant",
    help={
        "<p align='center'><font size='30' face='Soopafresh'><VP>#Target</VP></font>\n\n<p align='left'><font size='12'>Bienvenue sur<b><VP>#Target</VP></b>, dans ce jeu votre objectif sera d'attraper la <b><VP>cible</VP></b>, vous devez <b><VP>appuyer</VP></b> sur la <b><VP>barre d'espace</VP></b>quand vous êtes près d'elle afin de <b><VP>la tuer</VP></b>, utilisez les boutons <b><VP>C</VP></b>,<b><VP>V</VP></b> quand vous êtes la <b><VP>cible</VP></b> pour obtenir des <b><VP>améliorations</VP></b> pour échapper, la <b><VP>cible</VP></b> doit survivre pendant <b><VP>20 secondes</VP></b>, si elle survit, elle aura<b><VP>gagné</VP></b> et les autres souris mourront",
        "<p align='center'><font size='30' face='Soopafresh'><VP>Commandes</VP></font>\n\n<p align='left'><font size='12'><b><VP>!help</VP></b> or <b><VP>H</VP></b> - Montre les infos du jeu\n<b><VP>!shop</VP></b> or <b><VP>O</VP></b> - Displays the shop.\n<b><VP>!leaderboard</VP></b> ou <b><VP>L</VP></b> - Montre le classement du salon.\n<b><VP>!profile </VP></b>[<b>Name#0000</b>] ou <b><VP>P</VP></b>  - Affiche votre profil ou le profil de quelqu'un d'autre .\n<b><VP>!lang</VP></b>  [<b><a href='event:langs'><BV>XX</BV></a></b>] - Change la langue actuelle.",
        "<p align='center'><font size='30' face='Soopafresh'><VP>Crédits</VP></font>\n<p align='left'><font size='12'>\n Ce jeu a été développé par <BV><b>Bodykudo</b></BV><V><font size='10'>#0000</font></V>\n<BV><b>Flindix</b></BV><V><font size='10'>#0095</font></V>, <BV><b>Argilita</b></BV><V><font size='10'>#0000</font></V> - Artist\n<BV><b>Sebafrancuz</b></BV><V><font size='10'>#0000</font></V>, <BV><b>Turkitutu</b></BV><V><font size='10'>#0000</font></V></V> - Avec l'aide des codes de\n<BV><b>Niquettes</b></BV><V><font size='10'>#0000</font></V>, <BV><b>Beachair</b></BV><V><font size='10'>#0000</font></V> - Traduction FR\n<BV><b>Uvfn</b></BV><V><font size='10'>#0000</font></V>, <BV><b>Ju_ven</b></BV><V><font size='10'>#0000</font></V>, <BV><b>Syc</b></BV><V><font size='10'>#1270</font></V>, <BV><b>Blank</b></BV><V><font size='10'>#3495</font></V> -a donné l'idée de ce module"
    },
    name="Pseudo",
    commu="Communauté",
    winsB="Victoires",
    rounds="Parties jouées",
    wins="Victoires",
    winsMouse="Victoires en tant que Souris",
    winsTarget="Victoires en tant que Cible",
    killedTargets="Cibles tuées",
    close="Fermer",
    welcome="<VP>Bienvenue sur <BV><b>#Target</b></BV>,dans ce jeu votre objectif sera d'attraper la <BV><b>cible</b></BV>, vous devez appuyez sur la <BV><b>Barre d'Espace</b></BV> quand vous êtes près d'elle pour la tuer!</VP>",
    target="<ROSE>Vous êtes maintenant la cible, enfuyez-vous des assassins</ROSE>",
    isTarget="%s <ROSE>est maintenant la cible, attrapez-la!</ROSE>",
    won="%s <J>remporte la partie!</J>",
    killed="<VP>Vous avez tué la cible!<VP>",
    hasKilled="%s <VP>a tué la cible!</VP>",
    skills={
        speed="<Rose>Cliquer sur %s pour obtenir un bonus de vitesse</ROSE>",
        wind="<ROSE>Cliquer sur%s pour activer le vent</ROSE>",
        jump="<ROSE>Cliquer sur %s pour sauter haut</ROSE>",
        tp="<ROSE>Cliquer sur <BV><b>B</b></BV> pour créer un point de sauvegarde, cliquer sur %s pour s\'y téléporter</ROSE>",
        spirit="<ROSE>Cliquez sur %s pour invoquer un esprit</ROSE>",
        defense="<ROSE>Cliquez sur %s pour être en mode</ROSE>",
        gravity="<ROSE>Cliquez sur %s pour changer la gravité</ROSE>",
        attack="<ROSE>Cliquez sur %s pour jeter un %s</ROSE>",
        stop="<ROSE>Cliquez sur %s pour empêcher les joueurs de bouger </ROSE>",
        dark="<ROSE>Cliquez sur %s pour activer le mode sombre</ROSE>",
        rain="<ROSE>Click at %s to make it rain</ROSE>",
        link="<ROSE>Click at %s to link two mice together</ROSE>",
        size="<ROSE>Click at %s to change a random player's size</ROSE>",
        cheese="<ROSE>Click at %s to give cheese to a random player</VP>"
    },
    objects={
        ball="Ballon de plage",
        arrow="Flèches",
        chicken="Poulets",
        pufferfish="Diodon",
        snowball="Boule de neige",
        apple="Pomme",
        pumpkin="Citrouille",
        box="Caisse"
    }
}
--[[ End of file translations/fr.lua ]]--
--[[ File translations/pl.lua ]]--
translations.pl={
    new="<b><BV>The Shop</BV></b> <VP>has been added!</VP>",
    ready="<J>You're the next target, Get Ready!</J>",
    discord="Don't forget to join our official Discord Server:",
    disabled="Wyłączony",
    enabled="Włączony",
    quests={
        global="Become the <FC>#%s</FC> in the global leaderboard",
        win="Wygraj <VP>%s</VP> / <VP>%s</VP> rund.",
        winMouse="Wygraj <VP>%s</VP> / <VP>%s</VP> rund jako <VP>myszka</VP>.",
        winTarget="Wygraj <VP>%s</VP> / <VP>%s</VP> rund jako <VP>cel</VP>.",
        kill="Zabij <VP>%s</VP> / <VP>%s</VP> wrogów.",
        play="Zagraj <VP>%s</VP> / <VP>%s</VP> rund."
    },
    leaderRoom="Pokój",
    leaderGlobal="Światowy",
    toSave="Musi być przynajmniej 5 osób w pokoju, aby dane się zapisały!",
    buttons={
        shop="Shop",
        profile="Profil",
        help="Pomoc",
        rank="Ranking"
    },
    menu="Menu",
    lgs="Dostępne języki: ",
    next="Następna",
    pre="Poprzednia",
    help={
        "<p align='center'><font size='30' face='Soopafresh'><VP>#Target</VP></font>\n\n<p align='left'><font size='12'>Witaj na <b><VP>#Target</VP></b>, w tej grze twoim zadaniem jest złapanie <b><VP>celu</VP></b>, <b><VP>aby go zabić</VP></b>, musisz <b><VP>kliknąć Spacę</VP></b>, kiedy jesteś blisko niego, użyj klawiszy <b><VP>C</VP></b>,<b><VP>V</VP></b>, kiedy jesteś <b><VP>celem</VP></b>, aby otrzymać <b><VP>dodatkowe umiejętności</VP></b>, aby móc uciec, <b><VP>cel</VP></b> musi przetrwać przez <b><VP>20 Sekund</VP></b>, jeżeli przetrwasz, jesteś <b><VP>zwycięzcą</VP></b>, a reszta myszek umrze.",
        "<p align='center'><font size='30' face='Soopafresh'><VP>Komendy</VP></font>\n\n<p align='left'><font size='12'><b><VP>!help</VP></b> albo <b><VP>H</VP></b> - Pokazuje informacje o grze.\n<b><VP>!shop</VP></b> or <b><VP>O</VP></b> - Displays the shop.\n<b><VP>!leaderboard</VP></b> albo <b><VP>L</VP></b> - Pokazuje ranking pokoju.\n<b><VP>!profile </VP></b>[<b>Nazwa#0000</b>] albo <b><VP>P</VP></b>  - Pokazuje twój albo czyiś profil.\n<b><VP>!lang</VP></b>  [<b><a href='event:langs'><BV>XX</BV></a></b>] - Zmienia dotychczasowy język.",
        "<p align='center'><font size='30' face='Soopafresh'><VP>Credits</VP></font>\n<p align='left'><font size='12'>\nTa gra jest rozwijana przez <BV><b>Bodykudo</b></BV><V><font size='10'>#0000</font></V>\n<BV><b>Flindix</b></BV><V><font size='10'>#0095</font></V>, <BV><b>Argilita</b></BV><V><font size='10'>#0000</font></V> - Artist\n<BV><b>Sebafrancuz</b></BV><V><font size='10'>#0000</font></V>, <BV><b>Turkitutu</b></BV><V><font size='10'>#0000</font></V></V> - Pomogli w kodzie\n<BV><b>Sebafrancuz</b></BV><V><font size='10'>#0000</font></V> - Przetłumaczenie na język polski\n<BV><b>Uvfn</b></BV><V><font size='10'>#0000</font></V>, <BV><b>Ju_ven</b></BV><V><font size='10'>#0000</font></V>, <BV><b>Syc</b></BV><V><font size='10'>#1270</font></V>, <BV><b>Blank</b></BV><V><font size='10'>#3495</font></V> - Podali kilka dobrych pomysłów"
    },
    name="Nazwa",
    commu="Społeczność",
    winsB="Wygrane",
    rounds="Rozegrane Rundy",
    wins="Wygrane",
    winsMouse="Wygrane jako Myszka",
    winsTarget="Wygrane jako Cel",
    killedTargets="Zabitych Celów",
    close="Zamknij",
    welcome="<VP>Witaj na <BV><b>#Target</b></BV>, twoim zadaniem jest złapanie <BV><b>celu</b></BV>, aby go zabić kliknij <BV><b>spację</b></BV> kiedy jesteś blisko niego!</VP>",
    target="<ROSE>Teraz ty jesteś celem, uciekaj od morderców</ROSE>",
    isTarget="%s <ROSE>jest teraz celem, złap go!</ROSE>",
    won="%s <J>wygrał rundę!</J>",
    killed="<VP>Zabiłeś/-aś cel!<VP>",
    hasKilled="%s <VP>zabił/-a cel!</VP>",
    skills={
        speed="<Rose>Kliknij %s aby dostać przyspieszenie</ROSE>",
        wind="<ROSE>Kliknij %s, aby włączyć wiatr</ROSE>",
        jump="<ROSE>Kliknij %s, aby móc wysoko skokać</ROSE>",
        tp="<ROSE>Kliknij <BV><b>B</b></BV>, aby postawić checkpointa, kliknij %s, aby się przeteleportować do niego</ROSE>",
        spirit="<ROSE>Kliknij %s, aby postawić spirita</ROSE>",
        defense="<ROSE>Kliknij %s, aby włączyć formę obronną</ROSE>",
        gravity="<ROSE>Kliknij %s, aby zmienić grawitację</ROSE>",
        attack="<ROSE>Kliknij %s, aby wyrzucić %s</ROSE>",
        stop="<ROSE>Kliknij %s, aby zatrzymać graczy</ROSE>",
        dark="<ROSE>Kliknij %s, aby włączyć ciemność</ROSE>",
        rain="<ROSE>Click at %s to make it rain</ROSE>",
        link="<ROSE>Click at %s to link two mice together</ROSE>",
        size="<ROSE>Click at %s to change a random player's size</ROSE>",
        cheese="<ROSE>Click at %s to give cheese to a random player</VP>"
    },
    objects={
        ball="Piłka Plażowa",
        arrow="Strzała",
        chicken="Kurczak",
        pufferfish="Rozdymka",
        snowball="Śnieżka",
        apple="Jabłko",
        pumpkin="Dynia",
        box="Skrzynia"
    }
}
--[[ End of file translations/pl.lua ]]--
--[[ End of directory translations ]]--
--[[ Directory systems ]]--
--[[ File systems/dataSystem.lua ]]--
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
--[[ End of file systems/dataSystem.lua ]]--
--[[ File systems/mapsSystem.lua ]]--
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
--[[ End of file systems/mapsSystem.lua ]]--
--[[ File systems/rankingSystem.lua ]]--
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
--[[ End of file systems/rankingSystem.lua ]]--
--[[ File systems/targetSystem.lua ]]--
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
--[[ End of file systems/targetSystem.lua ]]--
--[[ File systems/translateSystem.lua ]]--
function setLang(n)
    text[n]=translations[tfm.get.room.playerList[n].community] or translations.en
end
--[[ End of file systems/translateSystem.lua ]]--
--[[ End of directory systems ]]--
--[[ Directory menus ]]--
--[[ File menus/help.lua ]]--
function ts.help(n)
	close(n)
	ui.addMenu(2,text[n].help[p[n].page],n,247,92,306,216,true)
    ui.addButton(10,"<p align='center'><R><b>"..text[n].close,n,339,278,122,22,true,"close")
    ui.addButton(13,"<p align='center'><b>"..text[n].next,p[n].page==3 and "RandomNubGuy" or n,475,278,72,22,true,"nextH")
    ui.addButton(16,"<p align='center'><b>"..text[n].pre,p[n].page==1 and "RandomNubGuy" or n,253,278,72,22,true,"preH")
end
--[[ End of file menus/help.lua ]]--
--[[ File menus/leaderboard.lua ]]--
function ts.leaderboard(n,page,global)
	close(n)
	local names=""
	local wins=""
	local ids=""
	local commu=""
	local lbCommus={}
	if global then
		local page=p[n].globalPage*10
		for i=page-9,page do
			local player=lb_gbPl[i]
			local playerName=mini(player,false,false,true)
			names=names..playerName.."\n"
			wins=wins.."<ROSE>"..gbPl[player][2].."</ROSE>\n"
			ids=ids.."#<J>"..i.."</J>\n"
			commu=commu..""..gbPl[player][1].."\n"
			lbCommus[#lbCommus+1]=gbPl[player][1]
		end
	else
		p_B=page*10
		p_A=p_B-9
		lbData=rankPlayers()
		if #lbData < p_B then
			p_B=#lbData
		end
		for a=p_A,p_B do
			names=names..tostring(mini(lbData[a][1],true,false,false)).."\n"
			wins=wins.."<ROSE>"..tostring(lbData[a][2]).."</ROSE>\n"
			ids=ids.."#<J>"..a.."</J>\n"
			commu=commu..""..p[lbData[a][1]].commu.."\n"
			lbCommus[#lbCommus+1]=p[lbData[a][1]].commu
		end
		if math.ceil(#lbData/10) == 0 then
			npage=1
		else
			npage=math.ceil(#lbData/10)
		end
	end
	ui.addButton(27,global and "<p align='center'>"..text[n].leaderRoom.."</a></p>" or "<p align='center'>"..text[n].leaderGlobal.."</a></p>",n,589,81,82,22,true,global and "roomLeader" or "globalLeader")
	ui.addMenu(2,"",n,201,71,386,245,true)
	ui.addTextArea(10, "<p align='center'>"..names, n, 280, 130, 140, 140, 0x0E1619, 0x0E1619, 1, true)
	ui.addTextArea(11, "<p align='center'>"..ids, n, 225, 130, 30, 140, 0x0E1619, 0x0E1619, 1, true)
	ui.addTextArea(12, "<p align='center'>"..wins, n, 440, 130, 50, 140, 0x0E1619, 0x0E1619, 1, true)
	ui.addTextArea(13, "", n, 505, 131, 70, 140, 0x0E1619, 0x0E1619, 1, true)
	ui.addTextArea(14, "<p align='center'>#<J>X</J>", n, 225, 90, 30, 20, 0x0E1619, 0x0E1619, 1, true)
	ui.addTextArea(15, "<p align='center'><b>"..text[n].name, n, 280, 90, 140, 20, 0x0E1619, 0x0E1619, 1, true)
	ui.addTextArea(16, "<p align='center'><ROSE>"..text[n].winsB, n, 440, 90, 50, 20, 0x0E1619, 0x0E1619, 1, true)
	ui.addTextArea(17, "<p align='center'><VP>"..text[n].commu, n, 505, 90, 70, 20, 0x0E1619, 0x0E1619, 1, true)
	ui.addButton(21,"<p align='center'><b><R>"..text[n].close,n,319,284,152,22,true,"close")
	if not global then
		ui.addButton(24,"<p align='center'><b>"..text[n].next,page==npage and "RandomNubGuy" or n,489,284,82,22,true,"next")
		ui.addButton(18,"<p align='center'><b>"..text[n].pre,page==1 and "RandomNubGuy" or n,219,284,82,22,true,"prev")
	else
		ui.addButton(24,"<p align='center'><b>"..text[n].next,p[n].globalPage==5 and "RandomNubGuy" or n,489,284,82,22,true,"globNext")
		ui.addButton(18,"<p align='center'><b>"..text[n].pre,p[n].globalPage==1 and "RandomNubGuy" or n,219,284,82,22,true,"globPrev")
	end
	local Y=136
	for i=1,#lbCommus do
		if commus[lbCommus[i]] then
			id.lb[i][n]=tfm.exec.addImage(commus[lbCommus[i]]..".png","&999",532,Y,n)
		end
		Y=Y+13.5
	end
end
--[[ End of file menus/leaderboard.lua ]]--
--[[ File menus/profile.lua ]]--
function ts.profile(n,pr)
	close(n)
    ui.addMenu(2,"<p align='center'><font size='20' face='Soopafresh'>"..mini(pr,false,false,false).."</font>\n<p align='left'>\n"..text[n].rounds..": <J>"..data[pr][1].."</J>\n\n"..text[n].wins..": <J>"..data[pr][2].."</J>\n\n"..text[n].winsMouse..": <J>"..data[pr][3].."</J>\n\n"..text[n].winsTarget..": <J>"..data[pr][4].."</J>\n\n"..text[n].killedTargets..": <J>"..data[pr][5].."</J>",n,279,74,236,246,true)
    ui.addButton(10,"<p align='center'><R><b>"..text[n].close,n,344,293,102,22,true,"close")
end
--[[ End of file menus/profile.lua ]]--
--[[ File menus/shop.lua ]]--
function ts.shop(n)
	close(n)
    ui.addMenu(2,"",n,221,61,346,266,true)
    ui.addButton(10,text[n].pre,p[n].shopPage==1 and "Random" or n,242,299,72,22,true,"preShop")
    ui.addButton(13,text[n].next,p[n].shopPage==#balls/3 and "Random" or n,474,299,72,22,true,"nextShop")
    ui.addButton(16,"<R>"..text[n].close,n,333,299,122,22,true,"close")
    --ui.addTextArea(28,p[n].shopPage==1 and "<p align='center'><font size='10'>"..string.format(text[n].quests[balls[p[n].sub[1]].text],p[n].sub[1]) or "<p align='center'><font size='10'>"..string.format(text[n].quests[balls[p[n].sub[1]].text],data[n][balls[p[n].sub[1]].type],balls[p[n].sub[1]].req),n,302, 90, 180, 40, 0x47707d, 0x000000, 1, true)
    --ui.addTextArea(30,p[n].shopPage==1 and "<p align='center'><font size='10'>"..string.format(text[n].quests[balls[p[n].sub[1]].text],p[n].sub[2]) or "<p align='center'><font size='10'>"..string.format(text[n].quests[balls[p[n].sub[2]].text],data[n][balls[p[n].sub[2]].type],balls[p[n].sub[2]].req),n,302, 165, 180, 40, 0x47707d, 0x000000, 1, true)
    --ui.addTextArea(29,p[n].shopPage==1 and "<p align='center'><font size='10'>"..string.format(text[n].quests[balls[p[n].sub[1]].text],p[n].sub[3]) or "<p align='center'><font size='10'>"..string.format(text[n].quests[balls[p[n].sub[3]].text],data[n][balls[p[n].sub[3]].type],balls[p[n].sub[3]].req),n,302, 240, 180, 40, 0x47707d, 0x000000, 1, true)
    ui.addTextArea(28,"<p align='center'><font size='10'>"..string.format(text[n].quests[balls[p[n].sub[1]].text],data[n][balls[p[n].sub[1]].type],balls[p[n].sub[1]].req),n,302, 90, 180, 40, 0x47707d, 0x000000, 1, true)
    ui.addTextArea(30,"<p align='center'><font size='10'>"..string.format(text[n].quests[balls[p[n].sub[2]].text],data[n][balls[p[n].sub[2]].type],balls[p[n].sub[2]].req),n,302, 165, 180, 40, 0x47707d, 0x000000, 1, true)
    ui.addTextArea(29,"<p align='center'><font size='10'>"..string.format(text[n].quests[balls[p[n].sub[3]].text],data[n][balls[p[n].sub[3]].type],balls[p[n].sub[3]].req),n,302, 240, 180, 40, 0x47707d, 0x000000, 1, true)
    ui.addTextArea(19,"",n,235,85,60, 50, 0x47707d, 0x000000, 1, true)
    ui.addTextArea(21,"",n,235,160,60,50, 0x47707d, 0x000000, 1, true)
	ui.addTextArea(20,"",n,235,235,60, 50, 0x47707d, 0x000000, 1, true)
	if n~="Bodykudo#0000" then
    	--ui.addButton(22,p[n].shopPage==1 and (n==lb_gbPl[1] and text[n].enabled or text[n].disabled) or data[n][balls[p[n].sub[1]].type] >= balls[p[n].sub[1]].req and text[n].enabled or text[n].disabled,n,489,92,72,22,true)
    	--ui.addButton(24,p[n].shopPage==1 and (n==lb_gbPl[2] and text[n].enabled or text[n].disabled) or data[n][balls[p[n].sub[2]].type] >= balls[p[n].sub[2]].req and text[n].enabled or text[n].disabled,n,489,167,72,22,true)
    	--ui.addButton(26,p[n].shopPage==1 and (n==lb_gbPl[3] and text[n].enabled or text[n].disabled) or data[n][balls[p[n].sub[3]].type] >= balls[p[n].sub[3]].req and text[n].enabled or text[n].disabled,n,489,242,72,22,true)
		ui.addButton(22,n==balls[p[n].sub[1]].artist and text[n].enabled or (data[n][balls[p[n].sub[1]].type] >= balls[p[n].sub[1]].req and text[n].enabled or text[n].disabled),n,489,92,72,22,true)
    	ui.addButton(24,n==balls[p[n].sub[2]].artist and text[n].enabled or (data[n][balls[p[n].sub[2]].type] >= balls[p[n].sub[2]].req and text[n].enabled or text[n].disabled),n,489,167,72,22,true)
    	ui.addButton(26,n==balls[p[n].sub[3]].artist and text[n].enabled or (data[n][balls[p[n].sub[3]].type] >= balls[p[n].sub[3]].req and text[n].enabled or text[n].disabled),n,489,242,72,22,true)
	else
    	ui.addButton(22,text[n].enabled,n,489,92,72,22,true)
    	ui.addButton(24,text[n].enabled,n,489,167,72,22,true)
    	ui.addButton(26,text[n].enabled,n,489,242,72,22,true)
	end
	id.lb[1][n]=tfm.exec.addImage(balls[p[n].sub[1]].img..".png","&10",235+(balls[p[n].sub[1]].xs or 15),85+(balls[p[n].sub[1]].ys or 10),n)
	id.lb[2][n]=tfm.exec.addImage(balls[p[n].sub[2]].img..".png","&11",235+(balls[p[n].sub[2]].xs or 15),160+(balls[p[n].sub[2]].ys or 10),n)
	id.lb[3][n]=tfm.exec.addImage(balls[p[n].sub[3]].img..".png","&12",235+(balls[p[n].sub[3]].xs or 15),235+(balls[p[n].sub[3]].ys or 10),n)
end
--[[ End of file menus/shop.lua ]]--
--[[ End of directory menus ]]--
--[[ Directory events ]]--
--[[ File events/eventChatCommand.lua ]]--
local c={"map","lang","profile","pr","p","leaderboard","rank","help","pw"}
function eventChatCommand(n,cmd)
	local c={}
	for i in cmd:gmatch('[^%s]+') do
		table.insert(c,i)
	end
	c[1]=c[1]:lower()
	if c[1]=="map" and n=="Bodykudo#0000" then
		if c[2] then
			tfm.exec.newGame(c[2])
		else
			newMap()
		end
	elseif c[1]=="pw" and n=="Bodykudo#0000" then
		if c[2] then
			tfm.exec.setRoomPassword(cmd:sub(c[1]:len()+2))
			tfm.exec.chatMessage("pw: "..cmd:sub(c[1]:len()+2),n)
		else
			tfm.exec.setRoomPassword("")
		end
	elseif c[1]=="kill" and n=="Bodykudo#0000" then
		tfm.exec.killPlayer(target)
	elseif c[1]=="profile" or c[1]=="pr" or c[1]=="p" then
		if c[2] then
			local P=string.gsub(c[2]:lower(),"%a",string.upper,1)
			if data[P] then
				ts.profile(n,P)
			end
		else
			ts.profile(n,n,"profile")
		end
	elseif c[1]=="lang" then	
		text[n]=lang[c[2]] or text[n]
	elseif c[1]=="leaderboard" or c[1]=="rank" then
		p[n].lbPage=1
		p[n].globalPage=1
		ts.leaderboard(n,1,false)
	elseif c[1]=="help" then
		ts.help(n)
	elseif c[1]=="shop" then
		p[n].shopPage=1
		p[n].sub={1,2,3}
		ts.shop(n)
	elseif c[1]=="test" then
		for k,v in pairs(p[n].balls) do
			print(v)
		end
	end
end

for i=1,#c do
	system.disableChatCommandDisplay(c[i],true)
end
--[[ End of file events/eventChatCommand.lua ]]--
--[[ File events/eventKeyboard.lua ]]--
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
--[[ End of file events/eventKeyboard.lua ]]--
--[[ File events/eventLoop.lua ]]--
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
--[[ End of file events/eventLoop.lua ]]--
--[[ File events/eventNewGame.lua ]]--
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
--[[ End of file events/eventNewGame.lua ]]--
--[[ File events/eventNewPlayer.lua ]]--
function eventNewPlayer(n)
	tfm.exec.lowerSyncDelay(n)
	setLang(n)
	tfm.exec.chatMessage(text[n].welcome.."\n<VP>You can submit your maps here:\n<BV><b>https://atelier801.com/topic?f=6&t=876107</b></BV></VP>\n<VP>"..text[n].discord.."</J><BV> <b>https://discord.gg/AMMAcW3</b></BV>\n"..text[n].new,n)
	playersNum=playersNum+1
	if playersNum==2 then
		tfm.exec.setGameTime(5)
	end
	for k=0,100 do
		system.bindKeyboard(n,k,true)
	end
	system.bindMouse(n,true)
	p[n]={balls={},shopPage=1,sub={1,2,3},right=true,checkpoint=false,cord={0,0},tps=2,x=0,x2=0,y=0,y2=0,X=0,Y=0,timetokill=0,stops=2,darks=2,gravities=2,winds=2,time={v=os.time()-20000,c=os.time()-20000,norm=os.time()},trapped=false,lbPage=1,commu=tfm.get.room.playerList[n].community,menu=false,page=1,globalPage=1,rains=2}
	data[n]={
		0, --rounds
		0, --wins
		0, --winsMouse
		0, --winsTarget
		0, --kills
  		tfm.get.room.playerList[n].community --Community
	}
	system.loadPlayerData(n)
	ts.help(n)
	ui.addTextArea(-1, "<p align='center'><a href='event:menu'>"..text[n].menu, n, 377, 27, 45, 20, 1, 1, 1, true)
	local newImage=tfm.exec.addImage("16521748d79.png","&0",50,97,n)
	system.newTimer(function()
		tfm.exec.removeImage(newImage,n)
	end,5000,false)
end
--[[ End of file events/eventNewPlayer.lua ]]--
--[[ File events/eventPlayerDied.lua ]]--
function eventPlayerDied(n)
	toCheck(n)
end
--[[ End of file events/eventPlayerDied.lua ]]--
--[[ File events/eventPlayerLeft.lua ]]--
function eventPlayerLeft(n)
	playersNum=playersNum-1
end
--[[ End of file events/eventPlayerLeft.lua ]]--
--[[ File events/eventPlayerWon.lua ]]--
function eventPlayerWon(n)
	if inRoomModule and tfm.get.room.uniquePlayers >= 5 then
		data[n][2]=data[n][3]+data[n][4]
		saveData(n)
	end
	for name in pairs(tfm.get.room.playerList) do
		tfm.exec.chatMessage(string.format(text[name].won,mini(n,false,true,false)),name)
	end
	toCheck(n)
end
--[[ End of file events/eventPlayerWon.lua ]]--
--[[ File events/eventTextAreaCallback.lua ]]--
function eventTextAreaCallback(id,n,cb)
	if cb=="close" then
		close(n)
		p[n].page=1
		p[n].globalPage=1
		p[n].shopPage=1
		p[n].sub={1,2,3}
	elseif cb=="next" then
		p[n].lbPage=p[n].lbPage+1
		ts.leaderboard(n,p[n].lbPage,false)
	elseif cb=="prev" and p[n].lbPage>1 then
		p[n].lbPage=p[n].lbPage-1
		ts.leaderboard(n,p[n].lbPage,false)
	elseif cb=="globNext" and p[n].globalPage < 5 then
		p[n].globalPage=p[n].globalPage+1
		ts.leaderboard(n,p[n].lbPage,true)
	elseif cb=="globPrev" and p[n].globalPage > 1 then
		p[n].globalPage=p[n].globalPage-1
		ts.leaderboard(n,p[n].lbPage,true)
	elseif cb=="roomLeader" then
		p[n].lbPage=1
		ts.leaderboard(n,p[n].lbPage,false)
	elseif cb=="globalLeader" then
		p[n].globalPage=1
		ts.leaderboard(n,1,true)
	elseif cb=="nextH" and p[n].page<3 then
		p[n].page=p[n].page+1
		ts.help(n)
	elseif cb=="preH" and p[n].page>1 then
		p[n].page=p[n].page-1
		ts.help(n)
	elseif cb=="langs" then
		tfm.exec.chatMessage("<J>"..text[n].lgs.."</J>\n<ROSE><b>"..table.indexesConcat(lang,"</b></ROSE>,<ROSE><b> ",tostring).."</b>",n)
	elseif cb=="menu" then
		if p[n].menu then
			ui.removeTextArea(-2,n)
			ui.removeTextArea(-3,n)
			p[n].menu=false
		else
			ui.addTextArea(-2,"<p align='center'><a href='event:profile'>"..text[n].buttons.profile.."</a> | <p align='center'><a href='event:shop'>"..text[n].buttons.shop.."</a> | <a href='event:help'>"..text[n].buttons.help.."</a>",n,420,27,160,20,1,1,0.8,true)
			ui.addTextArea(-3,"<p align='center'><a href='event:leaderboard'>"..text[n].buttons.rank.."</a>",n,265,27,120,20,1,1,0.8,true)
			ui.updateTextArea(-1,"<p align='center'><a href='event:menu'>"..text[n].menu,n)
			p[n].menu=true
		end
	elseif cb=="nextShop" and p[n].shopPage~=#balls/3 then
		p[n].shopPage=p[n].shopPage+1
		for i=1,3 do
			p[n].sub[i]=p[n].sub[i]+3
		end
		ts.shop(n)
	elseif cb=="preShop" and p[n].shopPage~=1 then
		p[n].shopPage=p[n].shopPage-1
		for i=1,3 do
			p[n].sub[i]=p[n].sub[i]-3
		end
		ts.shop(n)
	elseif buttons[cb] then
		p[n].lbPage=1
		p[n].page=1
		p[n].globalPage=1
		p[n].shopPage=1
		p[n].sub={1,2,3}
		ts[buttons[cb]](n,cb=="leaderboard" and 1 or n,false)
	elseif cb:sub(0,2)=="pr" then
		local player=cb:sub(4)
		if tfm.get.room.playerList[player] then
			ts.profile(n,player)
		end
	end
end
--[[ End of file events/eventTextAreaCallback.lua ]]--
--[[ End of directory events ]]--
--[[ File end.lua ]]--
table.foreach(tfm.get.room.playerList,eventNewPlayer)
system.loadFile(3)
newMap()
--[[ End of file end.lua ]]--