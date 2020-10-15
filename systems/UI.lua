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