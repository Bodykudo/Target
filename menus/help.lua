function ts.help(n)
	close(n)
	ui.addMenu(2,text[n].help[p[n].page],n,247,92,306,216,true)
    ui.addButton(10,"<p align='center'><R><b>"..text[n].close,n,339,278,122,22,true,"close")
    ui.addButton(13,"<p align='center'><b>"..text[n].next,p[n].page==3 and "RandomNubGuy" or n,475,278,72,22,true,"nextH")
    ui.addButton(16,"<p align='center'><b>"..text[n].pre,p[n].page==1 and "RandomNubGuy" or n,253,278,72,22,true,"preH")
end