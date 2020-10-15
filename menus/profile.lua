function ts.profile(n,pr)
	close(n)
    ui.addMenu(2,"<p align='center'><font size='20' face='Soopafresh'>"..mini(pr,false,false,false).."</font>\n<p align='left'>\n"..text[n].rounds..": <J>"..data[pr][1].."</J>\n\n"..text[n].wins..": <J>"..data[pr][2].."</J>\n\n"..text[n].winsMouse..": <J>"..data[pr][3].."</J>\n\n"..text[n].winsTarget..": <J>"..data[pr][4].."</J>\n\n"..text[n].killedTargets..": <J>"..data[pr][5].."</J>",n,279,74,236,246,true)
    ui.addButton(10,"<p align='center'><R><b>"..text[n].close,n,344,293,102,22,true,"close")
end