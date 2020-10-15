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