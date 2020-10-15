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