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