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