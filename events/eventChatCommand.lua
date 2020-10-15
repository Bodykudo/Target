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