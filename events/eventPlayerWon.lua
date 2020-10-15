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